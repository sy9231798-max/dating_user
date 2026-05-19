import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:dating_user/core/enums/profile_setup_status.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_detail_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_video_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/main_screen/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../../../core/constant/app_image.dart';
import 'widget/profile_setup_card.dart';

class ProfileSetupScreen extends GetView<ProfileSetupController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: Obx(
            () => Padding(
              padding: .symmetric(horizontal: 6),
              child: controller.profileStatus.value == null
                  ? Center(child: CustomCircularLoader())
                  : Column(
                      spacing: 12,
                      children: [
                        AppBar(
                          forceMaterialTransparency: true,
                          title: Text(
                            "Profile Setup",
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          centerTitle: true,
                        ),
                        ProfileSetupCard(
                          index: 1,
                          cardName: "Profile Photo",
                          profileStatus: controller.getStatusByResponse(
                            response: controller
                                .profileStatus
                                .value!
                                .step1ErrorMessage,
                          ),
                          onTap: () {
                            Get.to(
                              () => ProfileUploadScreen(
                                originalAdditionImage:
                                    controller
                                        .profileStatus
                                        .value
                                        ?.additionImage
                                        .map((e) => e.imagePath)
                                        .toList() ??
                                    [],
                                originalProfilePicture:
                                    controller
                                        .profileStatus
                                        .value
                                        ?.userData
                                        ?.profilePicture ??
                                    "",
                                originalAdditionImageId:
                                    controller
                                        .profileStatus
                                        .value
                                        ?.additionImage
                                        .map((e) => e.id)
                                        .toList() ??
                                    [],
                                error: switch (controller.getStatusByResponse(
                                  response: controller
                                      .profileStatus
                                      .value!
                                      .step1ErrorMessage,
                                )) {
                                  ProfileSetupStatusEnum.pending => "",
                                  ProfileSetupStatusEnum.completed => "",
                                  ProfileSetupStatusEnum.error =>
                                    controller
                                        .profileStatus
                                        .value!
                                        .step1ErrorMessage,
                                  ProfileSetupStatusEnum.waiting => "",
                                },
                              ),
                            );
                          },
                        ),
                        ProfileSetupCard(
                          index: 2,
                          cardName: "Video Verification",
                          profileStatus: controller.getStatusByResponse(
                            response: controller
                                .profileStatus
                                .value!
                                .step2ErrorMessage,
                          ),
                          onTap: () {
                            var videoLink = controller
                                .profileStatus
                                .value!
                                .userData
                                ?.videoPicture;

                            if (videoLink != null && videoLink.isNotEmpty) {
                              controller.loadVideo(
                                filePath: "${ApiEndpoints.baseUrl}/$videoLink",
                                isFile: false,
                              );
                            }
                            Get.to(
                              () => ProfileSetupVideoScreen(
                                originalVideo: videoLink ?? "",
                                error: switch (controller.getStatusByResponse(
                                  response: controller
                                      .profileStatus
                                      .value!
                                      .step2ErrorMessage,
                                )) {
                                  ProfileSetupStatusEnum.pending => "",
                                  ProfileSetupStatusEnum.completed => "",
                                  ProfileSetupStatusEnum.error =>
                                    controller
                                        .profileStatus
                                        .value!
                                        .step2ErrorMessage,
                                  ProfileSetupStatusEnum.waiting => "",
                                },
                              ),
                            );
                          },
                        ),
                        ProfileSetupCard(
                          index: 3,
                          cardName: "Profile Details",
                          profileStatus: controller.getStatusByResponse(
                            response: controller
                                .profileStatus
                                .value!
                                .step3ErrorMessage,
                          ),
                          onTap: () {
                            final user =
                                controller.profileStatus.value?.userData;
                            Get.to(
                              () => LoginProfileDetailScreen(
                                firstName: user?.firstName ?? "",
                                lastName: user?.lastName ?? '',
                                email: user?.email ?? '',
                                dob: user?.dob ?? '',
                                gender: user?.gender ?? "male",
                                city: user?.city ?? '',
                                state: user?.state ?? '',
                                reference:
                                    controller.profileStatus.value?.reference ??
                                    '',
                                hobby:
                                    controller
                                        .profileStatus
                                        .value
                                        ?.userData
                                        ?.hobby ??
                                    [],
                                error: switch (controller.getStatusByResponse(
                                  response: controller
                                      .profileStatus
                                      .value!
                                      .step3ErrorMessage,
                                )) {
                                  ProfileSetupStatusEnum.pending => "",
                                  ProfileSetupStatusEnum.completed => "",
                                  ProfileSetupStatusEnum.error =>
                                    controller
                                        .profileStatus
                                        .value!
                                        .step3ErrorMessage,
                                  ProfileSetupStatusEnum.waiting => "",
                                },
                              ),
                            );
                          },
                        ),
                        _ProfileStatusText(
                          errorCode:
                              controller.profileStatus.value?.errorCode
                                  .toInt() ??
                              0,
                        ),
                        CustomElevatedButton(
                          onPressed:
                              controller.profileStatus.value?.errorCode
                                      .toInt() !=
                                  200
                              ? null
                              : () async {
                                  await GetStorage().write(
                                    StorageKeys.needProfileSetup,
                                    false,
                                  );

                                  Get.to(() => MainScreen());
                                },
                          child: Text(
                            "Proceed",
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStatusText extends StatelessWidget {
  const _ProfileStatusText({required this.errorCode});

  final int errorCode;

  @override
  Widget build(BuildContext context) {
    return Text(switch (errorCode) {
      404 =>
        "Please fill all setup detail and admin will review after admin approve you can proceed",
      400 =>
        "There is problem in you profile detail please fill again problem one",
      200 => "Profile has been approve by admin you can proceed",
      int() => "",
    }, style: AppTextStyle.normalPoppins.copyWith(fontSize: 14));
  }
}
