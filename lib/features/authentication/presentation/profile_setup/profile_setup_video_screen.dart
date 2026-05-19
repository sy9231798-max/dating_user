import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constant/app_text_style.dart';

class ProfileSetupVideoScreen extends StatefulWidget {
  const ProfileSetupVideoScreen({
    super.key,
    required this.originalVideo,
    required this.error,
  });

  final String originalVideo;
  final String error;

  @override
  State<ProfileSetupVideoScreen> createState() =>
      _ProfileSetupVideoScreenState();
}

class _ProfileSetupVideoScreenState extends State<ProfileSetupVideoScreen> {
  final controller = Get.find<ProfileSetupController>();

  late RxString copyVideo = RxString(widget.originalVideo);

  RxBool get submittable => (widget.originalVideo != copyVideo.value).obs;

  @override
  void dispose() {
    controller.isVideoInitializing.value = false;
    controller.videoController.value?.dispose();
    controller.videoController.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          forceMaterialTransparency: true,
          title: Text(
            "Video Verification",
            style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: .symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                "Almost done!\nRecord a quick 10–30 second video so we can verify it’s you. Make sure your face is clear and well-lit.",
                style: AppTextStyle.normalPoppins.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Center(
                child: CustomElevatedButton(
                  child: Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    spacing: 12,
                    children: [
                      Icon(
                        Icons.emergency_recording_rounded,
                        color: Colors.white,
                      ),
                      Text(
                        "Start Recording",
                        style: AppTextStyle.mediumPoppins.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    var video = await controller.pickProfileVideo(context);
                    if (video != null) {
                      copyVideo.value = video.path;
                      controller.loadVideo(filePath: copyVideo.value);
                    }
                  },
                ),
              ),

              Obx(
                () => controller.videoController.value == null
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          Obx(
                            () => SizedBox(
                              child: controller.isVideoInitializing.value
                                  ? AspectRatio(
                                      aspectRatio: controller
                                          .videoController
                                          .value!
                                          .value
                                          .aspectRatio,
                                      child: VideoPlayer(
                                        controller.videoController.value!,
                                      ),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return CustomElevatedButton(
                                child: Row(
                                  mainAxisSize: .min,
                                  spacing: 12,
                                  children: [
                                    Text(
                                      controller
                                              .videoController
                                              .value!
                                              .value
                                              .isPlaying
                                          ? "Pause"
                                          : "Play",
                                      style: AppTextStyle.normalPoppins
                                          .copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Icon(
                                      controller
                                              .videoController
                                              .value!
                                              .value
                                              .isPlaying
                                          ? Iconsax.pause
                                          : Iconsax.play_cricle,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (controller.videoController.value !=
                                      null) {
                                    controller
                                            .videoController
                                            .value!
                                            .value
                                            .isPlaying
                                        ? controller.videoController.value!
                                              .pause()
                                        : controller.videoController.value!
                                              .play();
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                          if (widget.error.isNotEmpty)
                            Text(
                              widget.error,
                              style: AppTextStyle.mediumPoppins.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          Obx(
                            () => submittable.value
                                ? controller.isLoading.value
                                      ? CustomCircularLoader()
                                      : CustomElevatedButton(
                                          child: Row(
                                            spacing: 12,
                                            mainAxisSize: .min,
                                            children: [
                                              Text(
                                                "Submit",
                                                style: AppTextStyle
                                                    .normalPoppins
                                                    .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              Icon(
                                                Iconsax.send_1,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            controller.uploadVideo(
                                              context,
                                              copyVideo.value,
                                            );
                                          },
                                        )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
