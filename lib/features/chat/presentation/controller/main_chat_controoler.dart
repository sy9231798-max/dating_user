import 'package:dating_user/features/chat/presentation/controller/chat_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/dependency/dependency.dart';
import '../../../../core/helper/storage_helper.dart';

class MainChatController extends GetxController {
  static MainChatController get instance => Get.find();

  final index = 0.obs;

  var messageHelper = ChatHelper();

  RxList<Rx<ConversationDataModel>> get allConversation => messageHelper.allConversation;

  final isLoading = false.obs;

  @override
  void onInit() {
    fetchAllConversation();
    super.onInit();
  }


  void fetchAllConversation() async {
    try {
      isLoading.value = true;
      var response = await di<Dio>().get(
        "/v1/user/conversation",
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );
      var temp = <Rx<ConversationDataModel>>[];
      for (var i in response.data) {
        temp.add(ConversationDataModel.fromJson(i).obs);
      }
      messageHelper.allConversation.addAll(temp);
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class ConversationDataModel {
  ConversationDataModel({
    required this.id,
    required this.lastMessage,
    required this.userId,
    required this.user,
    required this.unreadCount,
    required this.updatedAt,
  });

  final int id;
  final String lastMessage;
  final int userId;
  final ConversationUserModel? user;
  final num unreadCount;
  final DateTime? updatedAt;

  ConversationDataModel copyWith({
    int? id,
    String? lastMessage,
    int? userId,
    ConversationUserModel? user,
    num? unreadCount,
    DateTime? updatedAt,
  }) {
    return ConversationDataModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ConversationDataModel.fromJson(Map<String, dynamic> json) {
    return ConversationDataModel(
      id: json["id"] ?? 0,
      lastMessage: json["last_message"] ?? "",
      userId: json["user_id"] ?? 0,
      user: json["user"] == null
          ? null
          : ConversationUserModel.fromJson(json["user"]),
      unreadCount: json["unread_count"] ?? 0,
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_message": lastMessage,
    "user_id": userId,
    "user": user?.toJson(),
    "unread_count": unreadCount,
  };

  @override
  String toString() {
    return "$id, $lastMessage, $userId, $user, $unreadCount, ";
  }
}

class ConversationUserModel {
  ConversationUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  ConversationUserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) {
    return ConversationUserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  factory ConversationUserModel.fromJson(Map<String, dynamic> json) {
    return ConversationUserModel(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      profilePicture: json["profile_picture"] ?? "",
    );
  }

  String get fullName => "$firstName $lastName";

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
  };

  @override
  String toString() {
    return "$id, $firstName, $lastName, $profilePicture, ";
  }
}
