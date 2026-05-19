import 'dart:math';

import 'package:dating_user/core/common_widget/custom_text_field.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/widget/chat_container.dart';
import 'package:dating_user/features/chat/presentation/widget/chat_data.dart';
import 'package:dating_user/features/chat/presentation/widget/chat_details.dart';
import 'package:dating_user/features/chat/presentation/widget/user_details.dart';
import 'package:dating_user/features/video_call/controller/video_call_controller.dart';
import 'package:dating_user/features/video_call/presentation/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';


class UserChatScreen extends GetView<ChatController> {
  const UserChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: ImageBackgroundContainer(
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            leadingWidth: 24 + 24,
            title: InkWell(
              onTap: () {
                // Get.to(() => ProfileScreen());
              },
              child: Row(
                spacing: 12,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          "${ApiEndpoints.baseUrl}/${controller.user.profilePicture}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        controller.user.fullName,
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        AppHelper.instance.onlineId.contains(controller.user.id)
                            ? "Online"
                            : "Offline",
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(
                    () => VideoCall(),
                    binding: BindingsBuilder.put(
                      () => VideoCallController(receiverId: controller.user.id),
                    ),
                  );
                },

                icon: Icon(Iconsax.video, color: AppColor.primaryColor),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => RequestGiftScreen());
                },
                icon: Icon(Iconsax.gift, color: AppColor.primaryColor),
              ),
            ],
          ),
          body: SafeArea(
            bottom: true,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(child: CustomCircularLoader())
                        : ListView.separated(
                          physics: ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: controller.allChat.length,
                          itemBuilder: (context, index) {
                            var chatData = controller.allChat[index];
                            return ChatContainer(
                              chatData: chatData,
                              receiver: controller.user,
                              ownMessage:
                                  chatData.sender ==
                                  AppHelper.instance.userData?.id,
                            );
                          },
                        ),
                  ),
                ),
                SizedBox(height: 12),

                Padding(
                  padding: .symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "Enter Message",
                          controller: controller.messageController,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.sendMessage();
                        },
                        icon: Icon(
                          Iconsax.send_1,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<ChatData> generateDummyChats(int count) {
  final random = Random();
  List<String> names = [
    "Amit Sharma",
    "Priya Patel",
    "Rahul Verma",
    "Sneha Joshi",
    "Karan Mehta",
    "Neha Singh",
  ];

  List<String> cities = ["Ahmedabad", "Mumbai", "Delhi", "Bangalore", "Pune"];

  List<String> messages = [
    "Hello! How are you?",
    "Let's meet tomorrow.",
    "Check this out!",
    "Good morning ☀️",
    "See you soon.",
    "Flutter is awesome 🚀",
  ];

  return List.generate(count, (index) {
    final id = index + 1;

    return ChatData(
      chatDetails: ChatDetails(
        id: id,
        userId: index.toString(),
        image: "https://i.pravatar.cc/150?img=${random.nextInt(70)}",
        message: messages[random.nextInt(messages.length)],
        createdAt: DateTime.now()
            .subtract(Duration(minutes: random.nextInt(5000)))
            .toString(),
        updatedAt: DateTime.now().toString(),
      ),
      userDetails: UserDetails(
        id: id,
        name: names[random.nextInt(names.length)],
        email: "user$id@example.com",
        phoneNumber: "9${random.nextInt(900000000) + 100000000}",
        gender: random.nextBool() ? "Male" : "Female",
        address: "Street ${random.nextInt(100)}, Area ${random.nextInt(50)}",
        city: cities[random.nextInt(cities.length)],
        state: "Gujarat",
        dateOfBirth: DateTime(
          1990 + random.nextInt(10),
          1 + random.nextInt(12),
          1 + random.nextInt(28),
        ).toString(),
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      ),
    );
  });
}
