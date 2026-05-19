import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:dating_user/features/chat/presentation/user_chat.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends GetView<MainChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 12),
      child: Column(
        spacing: 12,
        crossAxisAlignment: .start,
        children: [
          SizedBox(height: kToolbarHeight),
          Text(
            "Recent\nConversation",
            style: AppTextStyle.boldPoppins.copyWith(
              fontSize: 30,
              letterSpacing: 1.2,
              height: 1,
            ),
          ),

          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? CustomCircularLoader()
                  : Obx(
                      () => controller.allConversation.isEmpty
                          ? Center(
                              child: Text(
                                "No Conversation",
                                style: AppTextStyle.mediumPoppins.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: controller.allConversation.length,
                              padding: .zero,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => ConversationCard(
                                    data:
                                        controller.allConversation[index].value,
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationCard extends StatelessWidget {
  const ConversationCard({super.key, required this.data});

  final ConversationDataModel data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => UserChatScreen(),
          binding: BindingsBuilder.put(
            () => ChatController(conversationId: data.id, user: data.user!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: .all(color: Colors.white),
        ),
        padding: .symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    spacing: 12,
                    children: [
                      CachedNetworkImage(
                        imageUrl: getImageUrl(data.user?.profilePicture ?? ""),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Column(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .start,
                        children: [
                          Text(
                            data.user?.fullName ?? "No Name",
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            data.lastMessage,
                            style: AppTextStyle.normalPoppins.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              spacing: 6,
              mainAxisAlignment: .start,
              children: [
                Text(
                  DateFormat(
                    'hh:mm a',
                  ).format(data.updatedAt ?? DateTime.now()),
                  style: AppTextStyle.normalPoppins.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                if (data.unreadCount.toInt() != 0)
                  CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    radius: 10,
                    child: Text(
                      data.unreadCount.toString(),
                      style: AppTextStyle.normalPoppins.copyWith(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
