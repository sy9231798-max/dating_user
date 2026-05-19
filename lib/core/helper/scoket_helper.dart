import 'dart:convert';

import 'package:dating_user/core/common_model/user_model.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_helper.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:dating_user/features/video_call/presentation/new_call_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../features/video_call/controller/video_call_controller.dart';

//
// class SocketHelper {
//   Socket socket = io(
//     ApiEndpoints.baseUrl,
//     OptionBuilder()
//         .setTransports(['websocket']) // for Flutter or Dart VM
//         .disableAutoConnect() // disable auto-connection
//         .setQuery({"token": GetStorage().read(StorageKeys.token)})
//         .build(),
//   );
//
//   SocketHelper._internal() {
//     Logger().e("Here");
//   }
//
//   static final SocketHelper _instance = SocketHelper._internal();
//
//   factory SocketHelper() => _instance;
//
//   static SocketHelper get instance => _instance;
//
//   void initialize() {
//     socket.onConnect((_) {
//       Logger().e("OnConnect");
//       socket.emit("agent_connect");
//     });
//     socket.on("newConversation", (data) {
//       Logger().e("New Conversation");
//       ChatHelper().addNewConversation(
//         ConversationDataModel.fromJson(jsonDecode(data)),
//       );
//     });
//     socket.on("newMessage", (data) {
//       Logger().e("New Message");
//       var message = ChatMessageModel.fromJson(jsonDecode(data));
//       ChatHelper().updateConversation(message);
//     });
//     socket.on("user_online", (data) {
//       Logger().e(data);
//     });
//
//     socket.on("callReceived", (data) {
//       var callerDetail = UserModel.fromJson(data["sender_details"]);
//       var sdpOffer = data["sdpOffer"];
//
//       Get.to(
//         () => VideoCall(),
//         binding: BindingsBuilder.put(
//           () =>
//               VideoCallController(callerDetail: callerDetail, offer: sdpOffer),
//         ),
//       );
//     });
//     socket.onDisconnect((_) => print('disconnect'));
//     socket.connect();
//   }
//
//   void sendMessage(Map<String, dynamic> newMessage) {
//     socket.emit("message", jsonEncode(newMessage));
//   }
//
//   void sendTyping(Map<String, dynamic> newTyping) {
//     socket.emit("message", newTyping);
//   }
//
//   void makeCall({
//     required int receiverId,
//     required RTCSessionDescription offer,
//   }) {
//     socket.emit(
//       'call',
//       jsonEncode({
//         "type": "makeCall",
//         "receiverId": receiverId,
//         "callerDetail": AppHelper.instance.userData?.toJson(),
//         "sdpOffer": offer.toMap(),
//       }),
//     );
//   }
//
//   void sendIceCandidate({
//     required int receiverId,
//     required RTCIceCandidate candidate,
//   }) {
//     socket.emit(
//       "call",
//       jsonEncode({
//         "type": "iceCandidate",
//         "receiverId": receiverId,
//         "iceCandidate": {
//           "id": candidate.sdpMid,
//           "label": candidate.sdpMLineIndex,
//           "candidate": candidate.candidate,
//         },
//       }),
//     );
//   }
//
//   void answerCall({
//     required int callerId,
//     required RTCSessionDescription answer,
//   }) {
//     socket.emit(
//       'call',
//       jsonEncode({
//         "type": "answerCall",
//         "callerId": callerId,
//         "sdpAnswer": answer.toMap(),
//       }),
//     );
//   }
// }




class SocketHelper {
  late Socket socket;

  final _logger = Logger();

  // ─── ICE candidate buffer ──────────────────────────────────────────────────
  // Candidates that arrive before VideoCallController is created are stored
  // here and flushed the moment the controller registers itself.
  VideoCallController? _activeCallController;
  final List<Map<String, dynamic>> _pendingIceCandidates = [];

  // ─── Singleton ─────────────────────────────────────────────────────────────
  SocketHelper._internal();

  static final SocketHelper _instance = SocketHelper._internal();

  factory SocketHelper() => _instance;

  static SocketHelper get instance => _instance;

  void initialize() {
    final token = GetStorage().read(StorageKeys.token);

    socket = io(
      ApiEndpoints.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({"token": token})
          .build(),
    );

    socket.onConnect((_) {
      _logger.i("Socket connected");
      socket.emit("agent_connect");
    });

    socket.onDisconnect((_) {
      _logger.w("Socket disconnected");
    });

    socket.onConnectError((err) {
      _logger.e("Socket connect error: $err");
    });

    // ─── Chat events ──────────────────────────────────────────────────────────
    socket.on("newConversation", (data) {
      _logger.d("newConversation received");
      try {
        ChatHelper().addNewConversation(
          ConversationDataModel.fromJson(jsonDecode(data)),
        );
      } catch (e) {
        _logger.e("Failed to parse newConversation: $e");
      }
    });

    socket.on("newMessage", (data) {
      _logger.d("newMessage received");
      try {
        final message = ChatMessageModel.fromJson(jsonDecode(data));
        ChatHelper().updateConversation(message);
      } catch (e) {
        _logger.e("Failed to parse newMessage: $e");
      }
    });

    socket.on("user_online", (data) => AppHelper.instance.onlineId.add(data));
    socket.on("user_offline", (data) => AppHelper.instance.onlineId.remove(data));

    // ─── Call events ──────────────────────────────────────────────────────────

    // Incoming call — navigate to call screen
    socket.on("callReceived", (data) {
      _logger.d("callReceived");
      try {
        final roomId = data["roomId"];
        final senderDetails = data["sender_details"];

        if (roomId == null || senderDetails == null) {
          _logger.e("callReceived: missing sdpOffer or sender_details");
          return;
        }

        final callerDetail = UserModel.fromJson(senderDetails);
        Get.to(NewCallScreen(caller: callerDetail, roomId: roomId));
        // VideoCallController.onInit() will call registerCallController(this),
        // which flushes any ICE candidates that arrived before the screen opened.
      } catch (e) {
        _logger.e("callReceived parse error: $e");
      }
    });


    socket.connect();
  }

  // ─── Emit helpers ──────────────────────────────────────────────────────────

  void sendMessage(Map<String, dynamic> message) {
    socket.emit("message", jsonEncode(message));
  }

  void sendTyping(Map<String, dynamic> typing) {
    socket.emit("message", jsonEncode(typing));
  }

  void makeCall({required int receiverId, required String roomId}) {
    socket.emit(
      'call',
      jsonEncode({
        "type": "makeCall",
        "receiverId": receiverId,
        "callerDetail": AppHelper.instance.userData?.toJson(),
        "roomId": roomId,
      }),
    );
  }

  void rejectCall({required int callerId, required String roomId}) {
    socket.emit(
      'call',
      jsonEncode({
        "type": "rejectCall",
        "callerId": callerId,
        "roomId": roomId,
      }),
    );
  }

  void callDrop({required int receiverId, required String roomId}) {
    socket.emit(
      'call',
      jsonEncode({
        "type": "callDrop",
        "receiverId": receiverId,
        "roomId": roomId,
      }),
    );
  }

  void registerBalanceDebut({required int callerId}) {
    socket.emit(
      'call',
      jsonEncode({"type": "balanceDeduct", "caller_id": callerId}),
    );
  }

  void disConnectCall({required String roomId}) {
    socket.emit(
      'call',
      jsonEncode({"type": "callDisconnect", "roomId": roomId}),
    );
  }
}
