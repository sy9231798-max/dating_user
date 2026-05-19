import 'dart:math';

import 'package:dating_user/core/common_model/user_model.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_helper.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:dating_user/features/chat/presentation/user_chat.dart';
import 'package:dating_user/features/video_call/presentation/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';

import '../../../core/common_widget/dotted_border_container.dart';
import '../../video_call/controller/video_call_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userData});

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("Profile"),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: .symmetric(horizontal: 12),
          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView.builder(
                  controller: PageController(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: .symmetric(horizontal: 6),
                      child: Image(
                        image: NetworkImage(
                          "${ApiEndpoints.baseUrl}/${userData.profilePicture}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: .all(color: Colors.white38),
                  borderRadius: .circular(12),
                ),
                padding: .symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          userData.fullName,
                          style: AppTextStyle.mediumPoppins.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Random().nextInt(80).toString(),
                                style: AppTextStyle.mediumPoppins.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "  Age",
                                style: AppTextStyle.normalPoppins.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "${userData.state}, ${userData.city}",
                          style: AppTextStyle.normalPoppins.copyWith(
                            fontSize: 14,
                          ),
                        ),

                        Obx(
                          () => Row(
                            spacing: 6,
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    AppHelper.instance.onlineId.contains(
                                      userData.id,
                                    )
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              Text(
                                AppHelper.instance.onlineId.contains(
                                      userData.id,
                                    )
                                    ? "Online"
                                    : "Offline",
                                style: AppTextStyle.mediumPoppins.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        Logger().e(
                          ChatHelper.instance.allConversation.indexWhere(
                            (e) => e.value.userId == userData.id,
                          ),
                        );

                        var index = ChatHelper.instance.allConversation
                            .indexWhere((e) => e.value.userId == userData.id);

                        Get.to(
                          () => UserChatScreen(),
                          binding: BindingsBuilder.put(
                            () => ChatController(
                              user: ConversationUserModel.fromJson(
                                userData.toJson(),
                              ),
                              conversationId: index == -1
                                  ? null
                                  : ChatHelper
                                        .instance
                                        .allConversation[index]
                                        .value
                                        .id,
                            ),
                          ),
                        );
                      },
                      icon: Row(
                        spacing: 6,
                        children: [
                          Icon(Iconsax.message, color: AppColor.primaryColor),
                          Text(
                            'Chat',
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Get.to(
                          () => VideoCall(),
                          binding: BindingsBuilder.put(
                            () => VideoCallController(
                              receiverId: userData.id,
                            ),
                          ),
                        );
                      },
                      icon: Row(
                        spacing: 6,
                        children: [
                          Icon(Iconsax.video, color: AppColor.primaryColor),
                          Text(
                            "Video Call",
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: .start,
                spacing: 3,
                children: [
                  Text(
                    "Hobbies",
                    style: AppTextStyle.semiBoldPoppins.copyWith(fontSize: 18),
                  ),
                  Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: List.generate(userData.hobby.length, (index) {
                      return Container(
                        padding: .symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(120),
                        ),
                        child: Text(
                          userData.hobby[index],

                          style: AppTextStyle.mediumPoppins.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: .start,
                spacing: 3,
                children: [
                  Text(
                    "Other Picture",
                    style: AppTextStyle.semiBoldPoppins.copyWith(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 12,
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: DottedBorderContainer(
                          color: Colors.white,
                          strokeWidth: 1,
                          dotLength: 10,
                          padding: .all(6),
                          child: SizedBox(
                            height: 100,
                            child: userData.additionImages.length > index
                                ? ImageWidget(
                                    imagePath: userData
                                        .additionImages[index]
                                        .imagePath,
                                  )
                                : Column(
                                    mainAxisAlignment: .center,
                                    children: [
                                      Text(
                                        "Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.normalPoppins
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
