// import 'package:dating_user/core/common_model/user_model.dart';
// import 'package:dating_user/core/helper/scoket_helper.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart' hide navigator;
// import 'package:logger/logger.dart';
//
// class VideoCallController extends GetxController {
//   final _localRTCVideoRenderer = RTCVideoRenderer();
//
//   RTCVideoRenderer get localRTCVideoRenderer => _localRTCVideoRenderer;
//
//   final _remoteRTCVideoRenderer = RTCVideoRenderer();
//
//   RTCVideoRenderer get remoteRTCVideoRenderer => _remoteRTCVideoRenderer;
//
//   MediaStream? _localStream;
//   RTCPeerConnection? _rtcPeerConnection;
//
//   final isAudioOn = true.obs;
//   final isVideoOn = true.obs;
//   final isFrontCameraSelected = true.obs;
//   final isLocalStreamReady = false.obs;
//   final isRemoteStreamReady = false.obs; // ✅ NEW: drives remote video UI
//
//   final dynamic offer;
//   final UserModel? callerDetail;
//   final int? receiverId;
//
//   RTCDataChannel? dataChannel;
//   List<RTCIceCandidate> rtcIceCandidates = [];
//
//   final RTCDataChannelInit _dataChannelDict = RTCDataChannelInit();
//
//   final _logger = Logger();
//
//   // ─── ICE / TURN configuration ───────────────────────────────────────────────
//   //
//   // ROOT CAUSE of "no remote video":
//   // STUN-only works only when both peers are on the same network or have
//   // open NATs. For real cross-network calls you MUST have a TURN server
//   // as a relay fallback — otherwise ICE stays in CONNECTING and never
//   // reaches CONNECTED, so media never flows even though onTrack fires.
//   //
//   // The config below uses the free openrelay.metered.ca TURN service.
//   // ⚠️  Replace with your own coturn / Twilio / Xirsys credentials in
//   //     production — public TURN servers have strict bandwidth limits.
//   //
//   static const _iceServers = {
//     'iceServers': [
//       {
//         'urls': [
//           'stun:stun1.l.google.com:19302',
//           'stun:stun2.l.google.com:19302',
//         ],
//       },
//       {
//         'urls': [
//           'turn:testingbackend.duckdns.org:3478?transport=tcp',
//         ],
//         'username': 'admin',
//         'credential': 'admin',
//       },
//
//       // 🔥 IF POSSIBLE ADD TLS (VERY IMPORTANT)
//       {
//         'urls': [
//           'turns:testingbackend.duckdns.org:5349'
//         ],
//         'username': 'admin',
//         'credential': 'admin',
//       },
//     ],
//   };
//
//   VideoCallController({this.callerDetail, this.receiverId, this.offer});
//
//   @override
//   void onInit() {
//     super.onInit();
//     _setupPeerConnection();
//   }
//
//   @override
//   void onClose() {
//     SocketHelper.instance.socket.off("iceCandidate");
//     SocketHelper.instance.socket.off("callAnswered");
//
//     _localRTCVideoRenderer.dispose();
//     _remoteRTCVideoRenderer.dispose();
//     _localStream?.dispose();
//     _rtcPeerConnection?.dispose();
//
//     super.onClose();
//   }
//
//   void _setupPeerConnection() async {
//     await _localRTCVideoRenderer.initialize();
//     await _remoteRTCVideoRenderer.initialize();
//
//     _rtcPeerConnection = await createPeerConnection(_iceServers);
//
//     // ✅ Log ICE state — use this to verify TURN is working
//     _rtcPeerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
//       _logger.d("ICE state → $state");
//       if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
//         _logger.e("ICE FAILED. Check TURN server credentials/reachability.");
//         // Uncomment to attempt automatic ICE restart on failure:
//         // _rtcPeerConnection?.restartIce();
//       }
//     };
//
//     _rtcPeerConnection!.onConnectionState = (RTCPeerConnectionState state) {
//       _logger.d("Peer connection state → $state");
//     };
//
//     // ✅ Set remote stream + signal UI when track arrives
//     _rtcPeerConnection!.onTrack = (event) {
//       _logger.d("onTrack: streams=${event.streams.length}");
//       if (event.streams.isNotEmpty) {
//         _remoteRTCVideoRenderer.srcObject = event.streams[0];
//         isRemoteStreamReady.value = true;
//       }
//     };
//
//     // Get local camera/mic stream
//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': isAudioOn.value,
//       'video': isVideoOn.value
//           ? {'facingMode': isFrontCameraSelected.value ? 'user' : 'environment'}
//           : false,
//     });
//
//     _localStream!.getTracks().forEach((track) {
//       _rtcPeerConnection!.addTrack(track, _localStream!);
//     });
//
//     _localRTCVideoRenderer.srcObject = _localStream;
//     isLocalStreamReady.value = true;
//
//     if (offer != null) {
//       // ─── Incoming call ────────────────────────────────────────────────────
//       _logger.d("Incoming call — setting remote description");
//
//
//       if (callerDetail == null) {
//         _logger.e("callerDetail is null, cannot answer call");
//         return;
//       }
//
//       _rtcPeerConnection!.onDataChannel = (RTCDataChannel channel) {
//         dataChannel = channel;
//         dataChannel!.onMessage = (msg) => _logger.d("DC msg: ${msg.text}");
//       };
//
//       await _rtcPeerConnection!.setRemoteDescription(
//         RTCSessionDescription(offer["sdp"], offer["type"]),
//       );
//
//       final RTCSessionDescription answer = await _rtcPeerConnection!
//           .createAnswer();
//
//       await _rtcPeerConnection!.setLocalDescription(answer);
//
//       SocketHelper.instance.answerCall(
//         answer: answer,
//         callerId: callerDetail!.id,
//       );
//     } else {
//       // ─── Outgoing call ────────────────────────────────────────────────────
//       _logger.d("Outgoing call — creating offer");
//
//       if (receiverId == null) {
//         _logger.e("receiverId is null, cannot make call");
//         return;
//       }
//
//       _rtcPeerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
//         rtcIceCandidates.add(candidate);
//       };
//
//       dataChannel = await _rtcPeerConnection!.createDataChannel(
//         "chat",
//         _dataChannelDict,
//       );
//       dataChannel!.onMessage = (RTCDataChannelMessage msg) =>
//           _logger.d("DC msg: ${msg.text}");
//
//       SocketHelper.instance.socket.on("callAnswered", (data) async {
//         _logger.d("Remote answered — setting remote description");
//         await _rtcPeerConnection!.setRemoteDescription(
//           RTCSessionDescription(
//             data["sdpAnswer"]["sdp"],
//             data["sdpAnswer"]["type"],
//           ),
//         );
//
//         for (var i in rtcIceCandidates) {
//           SocketHelper.instance.sendIceCandidate(
//             receiverId: receiverId!,
//             candidate: i,
//           );
//         }
//       });
//
//       final RTCSessionDescription outgoingOffer = await _rtcPeerConnection!
//           .createOffer();
//       await _rtcPeerConnection!.setLocalDescription(outgoingOffer);
//       SocketHelper.instance.makeCall(
//         offer: outgoingOffer,
//         receiverId: receiverId!,
//       );
//     }
//   }
// }

import 'dart:async';

import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide navigator;
import 'package:logger/logger.dart';
import 'package:videosdk/videosdk.dart';

import '../../../core/common_model/user_model.dart';
import '../../../core/helper/scoket_helper.dart';

final videoToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3NjUxMjY1MS1lOTYxLTQ3NjEtYmU3Zi1jODAwZWI1NjlhNzIiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc3NzU2MTA4NiwiZXhwIjoxNzc4MTY1ODg2fQ.Gk53jkb_TzXOeqdeKX-rsl2Vee1XMHlNmWfuMNk1gz8";

class VideoCallController extends GetxController {
  String? roomId;
  final int? receiverId;
  final UserModel? callerDetail;

  VideoCallController({this.roomId, this.receiverId, this.callerDetail});

  Room? _room;
  var micEnabled = true;
  var camEnabled = true;

  RxMap<String, Participant> participants = RxMap();

  Rxn<Stream> participantVideoStream = Rxn(null);
  Rxn<Stream> participantAudioStream = Rxn(null);

  Rxn<Stream> localVideoStream = Rxn(null);
  Rxn<Stream> localAudioStream = Rxn(null);


  @override
  void onReady() {
    Future.microtask(() => initializeRoom());
    super.onReady();
  }

  var isConnected = false;

  Timer? waitingTimer;

  void startWaitingTimer() {
    waitingTimer?.cancel();
    waitingTimer = Timer(Duration(seconds: 30), () {
      if (isConnected) return;
      Logger().e("CallDrop Hit");
      SocketHelper.instance.callDrop(receiverId: receiverId!, roomId: roomId!);
      Get.back();
    });
  }

  var isBackPressed = false;

  void disConnectCall() {
    isBackPressed = true;
    if (roomId != null) {
      if (receiverId != null && !isConnected) {
        SocketHelper.instance.callDrop(
          receiverId: receiverId!,
          roomId: roomId!,
        );
      }

      if (receiverId != null) {
        SocketHelper.instance.disConnectCall(roomId: roomId!);
      }
    }
  }

  void initializeRoom() async {
    if (roomId == null) {
      try {
        roomId = await getRoomId(receiverId!);
        SocketHelper.instance.makeCall(
          receiverId: receiverId!,
          roomId: roomId!,
        );

        SocketHelper.instance.socket.on("makeCallACK", (data) {
          startWaitingTimer();
        });

        SocketHelper.instance.socket.on("rejectCall", (data) {
          Logger().e("RejectCall");
          Get.back();
        });
      } catch (e) {
        if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
          Get.back();
          errorSnackBar(Get.overlayContext!, e is DioException ? (e.response?.data?["detail"] ?? "Something Went Wrong") : e.toString());
        }
        return;
      }
    }

    _room = VideoSDK.createRoom(
      roomId: roomId!,
      token: videoToken,
      participantId: AppHelper.instance.userData?.id.toString() ?? "0",
      displayName: AppHelper.instance.userData?.fullName ?? "No Name",
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: kIsWeb ? 0 : 1,
    );

    setMeetingEventListener();
    _room!.join();
  }

  void setMeetingEventListener() {
    _room!.on(Events.roomJoined, () {
      Logger().e("Room Joined");
      participants.putIfAbsent(
        _room!.localParticipant.id,
            () => _room!.localParticipant,
      );

      _room!.localParticipant.streams.forEach((key, Stream stream) {
        if (stream.kind == 'video') {
          localVideoStream.value = stream;
        }
      });
      _room!.localParticipant.on(Events.streamEnabled, (Stream stream) {
        if (stream.kind == 'video') {
          localVideoStream.value = stream;
        } else if (stream.kind == 'audio') {
          localAudioStream.value = stream;
        }
      });

      _room!.localParticipant.on(Events.streamDisabled, (Stream stream) {
        if (stream.kind == 'video') {
          localVideoStream.value = null;
        } else if (stream.kind == 'audio') {
          localAudioStream.value = null;
        }
      });
    });

    _room!.on(Events.participantJoined, (Participant participant) {
      Logger().e("Participant Joined");
      isConnected = true;
      waitingTimer?.cancel();
      if (callerDetail != null) {
        startDurationTimer();
      }

      participants.putIfAbsent(participant.id, () => participant);
      participant.streams.forEach((key, Stream stream) {
        if (stream.kind == 'video') {
          participantVideoStream.value = stream;
        }
      });
      _initStreamListeners(participant);
    });

    _room!.on(Events.participantLeft, (String participantId,
        Map<String, dynamic> reason,) {
      Logger().e("ParticipantLeft");
      if (participants.containsKey(participantId)) {
        participants.remove(participantId);
        // Get.back();
      }
    });

    _room!.on(Events.roomLeft, () {
      Logger().e("RoomLeft");
      participants.clear();
      if (!isBackPressed) {
        Get.back();
      }
    });
  }

  Timer? timer;

  void startDurationTimer() {
    timer?.cancel();
    SocketHelper.instance.registerBalanceDebut(callerId: callerDetail!.id);
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      SocketHelper.instance.registerBalanceDebut(callerId: callerDetail!.id);
    });
  }

  void _initStreamListeners(Participant participant) {
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        participantVideoStream.value = stream;
      } else if (stream.kind == 'audio') {
        participantAudioStream.value = stream;
      }
    });

    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        participantVideoStream.value = null;
      } else if (stream.kind == 'audio') {
        participantAudioStream.value = null;
      }
    });
  }

  Future<String> getRoomId(int receiverId) async {
    try {
      var response = await di<Dio>().get(
        "/v1/user/check-call/$receiverId",
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );
      return response.data["roomId"];
    } on DioException catch (e) {

      // errorSnackBar(
      //   Get.overlayContext!,
      //   e.response?.data["detail"] ?? "Something went wrong",
      // );
      rethrow;
    } catch (e) {
      Logger().e(e.toString());
      errorSnackBar(Get.overlayContext!, e.toString());
      rethrow;
    }
  }

  @override
  void onClose() {
    _room?.end();
    waitingTimer?.cancel();
    SocketHelper.instance.socket.off("makeCallACK");
    SocketHelper.instance.socket.off("rejectCall");
    timer?.cancel();
    super.onClose();
  }
}
