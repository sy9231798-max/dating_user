import 'dart:convert';

import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/core/helper/scoket_helper.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_helper.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/dependency/dependency.dart';

class ChatController extends GetxController {
  int? conversationId;
  final ConversationUserModel user;
  final RxnInt _conversationId = RxnInt();

  ChatController({this.conversationId, required this.user}) {
    _conversationId.value = conversationId;
  }

  RxList<ChatMessageModel> get allChat {
    final id = _conversationId.value;

    if (id == null) {
      return <ChatMessageModel>[].obs;
    }

    if (!ChatHelper.instance.allChats.containsKey(id)) {
      ChatHelper.instance.allChats[id] = <ChatMessageModel>[].obs;
    }

    return ChatHelper.instance.allChats[id]!;
  }

  final isLoading = false.obs;

  @override
  void onInit() {
    ever(allChat, (callback) {
      print("New message received: ${callback.last.message}");
    });
    if (conversationId != null) {
      fetchAllMessage();
    } else {
      Logger().e("Socket Listening");
      SocketHelper.instance.socket.on("currentConversation", (data) {
        Logger().e("Current Conversation Hit");
        var conversation = ConversationDataModel.fromJson(jsonDecode(data));
        conversationId = conversation.id;
        _conversationId.value = conversationId;
        ChatHelper.instance.addNewConversation(conversation);
        ChatHelper.instance.allChats[conversationId!]?.add(
          ChatMessageModel(
            id: "-1",
            conversationId: conversationId!,
            receiver: user.id,
            sender: AppHelper.instance.userData!.id,
            messageType: "text",
            message: conversation.lastMessage,
            image: "",
            sendAt: conversation.updatedAt,
          ),
        );
      });
    }

    super.onInit();
  }

  void fetchAllMessage() async {
    Logger().e(ChatHelper.instance.allChats.containsKey(conversationId));
    if (ChatHelper.instance.allChats.containsKey(conversationId) &&
        ChatHelper.instance.allChats[conversationId]!.isNotEmpty) {
      return;
    }


    isLoading.value = true;
    try {
      var response = await di<Dio>().get(
        "/v1/user/messages/$conversationId",
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );


      var temp = <ChatMessageModel>[];
      for (var i in response.data) {
        temp.add(ChatMessageModel.fromJson(i));
      }

      ChatHelper.instance.allChats[conversationId]?.addAll(temp);
    } on DioException catch (e) {
      Logger().e(e.response?.requestOptions.path);
      Logger().e(e.response?.requestOptions.queryParameters);
      Logger().e(e.response?.data ?? "Something went wrong");
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  final messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    var newMessage = ChatMessageModel(
      id: "-1",
      conversationId: conversationId ?? 0,
      receiver: user.id,
      sender: AppHelper.instance.userData?.id ?? -1,
      messageType: "text",
      message: messageController.text.trim(),
      image: "",
      sendAt: DateTime.now(),
    );

    SocketHelper().sendMessage(newMessage.toMessage());
    allChat.insert(0, newMessage);
    messageController.clear();
  }
}

class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.receiver,
    required this.sender,
    required this.messageType,
    required this.message,
    required this.image,
    required this.sendAt,
  });

  final String id;
  final int conversationId;
  final num receiver;
  final num sender;
  final String messageType;
  final String message;
  final String image;
  final DateTime? sendAt;

  ChatMessageModel copyWith({
    String? id,
    int? conversationId,
    num? receiver,
    num? sender,
    String? messageType,
    String? message,
    String? image,
    DateTime? sendAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
      messageType: messageType ?? this.messageType,
      message: message ?? this.message,
      image: image ?? this.image,
      sendAt: sendAt ?? this.sendAt,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] ?? "",
      conversationId: json["conversation_id"] ?? 0,
      receiver: json["receiver"] ?? 0,
      sender: json["sender"] ?? 0,
      messageType: json["message_type"] ?? "",
      message: json["message"] ?? "",
      image: json["image"] ?? "",
      sendAt: DateTime.tryParse(json["send_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "conversation_id": conversationId,
    "receiver": receiver,
    "sender": sender,
    "message_type": messageType,
    "message": message,
    "image": image,
    "send_at": sendAt?.toIso8601String(),
  };

  Map<String, dynamic> toMessage() => {
    "conversation_id": conversationId,
    "receiver": receiver,
    "sender": sender,
    "type": "newMessage",
    "message_type": messageType,
    "message": message,
  };

  @override
  String toString() {
    return "$id, $conversationId, $receiver, $sender, $messageType, $message, $image, $sendAt, ";
  }
}
