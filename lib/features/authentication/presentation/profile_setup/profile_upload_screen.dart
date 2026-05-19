import 'dart:io';

import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';

import '../../../../core/common_widget/dotted_border_container.dart';
import '../../../../core/constant/app_image.dart';
import '../../../../core/constant/app_text_style.dart';

class ProfileUploadScreen extends StatefulWidget {
  const ProfileUploadScreen({
    super.key,
    required this.originalAdditionImage,
    required this.originalProfilePicture,
    required this.originalAdditionImageId,
    required this.error,
  });

  final List<String> originalAdditionImage;
  final List<int> originalAdditionImageId;
  final String originalProfilePicture;
  final String error;

  @override
  State<ProfileUploadScreen> createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  final controller = Get.find<ProfileSetupController>();

  late RxList<String> originalAdditionImage = RxList(
    widget.originalAdditionImage,
  );
  late RxList<String> copyAdditionImage = RxList(widget.originalAdditionImage);
  late RxString copyProfilePicture = RxString(widget.originalProfilePicture);
  late RxString originalProfilePicture = RxString(
    widget.originalProfilePicture,
  );

  RxBool get enableImageSubmit =>
      (copyProfilePicture.value != originalProfilePicture.value ||
              !copyAdditionImage.every(
                (element) => originalAdditionImage.contains(element),
              ))
          .obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ImageBackgroundContainer(
        child: Padding(
          padding: .symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              AppBar(
                forceMaterialTransparency: true,
                title: Text("Profile Picture"),
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                centerTitle: true,
              ),
              Text(
                "Your profile photo and additional images help others recognize you and build trust.",
                style: AppTextStyle.normalPoppins.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Align(
                alignment: .center,
                child: InkWell(
                  onTap: () async {
                    var photo = await controller.pickProfileImage(context);
                    if (photo != null) {
                      copyProfilePicture.value = photo.path;
                    }
                  },
                  child: DottedBorderContainer(
                    color: Colors.white,
                    padding: .all(6),
                    child: Obx(
                      () => SizedBox(
                        height: 100,
                        width: 100,
                        child: copyProfilePicture.value.isEmpty
                            ? Column(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    "Profile Picture",
                                    style: AppTextStyle.normalPoppins.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : ImageWidget(
                                imagePath: copyProfilePicture.value,
                                onPressed: () {
                                  copyProfilePicture.value = "";
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Additional Images",
                style: AppTextStyle.normalPoppins.copyWith(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                children: List.generate(3, (index) {
                  return Expanded(
                    child: InkWell(
                      onTap: () async {
                        var photos = await controller.pickAdditionImage(
                          context,
                          3 - copyAdditionImage.length,
                        );
                        if (photos.isEmpty) return;
                        copyAdditionImage.addAll(
                          photos.map((e) => e.path).toList(),
                        );
                      },
                      child: DottedBorderContainer(
                        color: Colors.white,
                        strokeWidth: 1,
                        dotLength: 10,
                        padding: .all(6),
                        child: Obx(
                          () => SizedBox(
                            height: 100,
                            child: copyAdditionImage.length > index
                                ? ImageWidget(
                                    imagePath: copyAdditionImage[index],
                                    onPressed: () async {
                                      copyAdditionImage.removeAt(index);

                                      if (originalAdditionImage.isNotEmpty) {
                                        controller.removeAdditionImage(
                                          context,
                                          widget.originalAdditionImageId[index],
                                        );
                                      }
                                    },
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
                      ),
                    ),
                  );
                }),
              ),
              if (widget.error.isNotEmpty)
                Text(
                  widget.error,
                  style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
                ),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Obx(
                    () => enableImageSubmit.value
                        ? controller.isLoading.value
                              ? CustomCircularLoader()
                              : CustomElevatedButton(
                                  child: Row(
                                    spacing: 12,
                                    mainAxisSize: .min,
                                    children: [
                                      Text(
                                        "Submit",
                                        style: AppTextStyle.normalPoppins
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                      ),
                                      Icon(Iconsax.send_1, color: Colors.white),
                                    ],
                                  ),
                                  onPressed: () {
                                    controller.uploadImage(
                                      context,
                                      originalAdditionImage.toList(),
                                      copyAdditionImage.toList(),
                                      copyProfilePicture.value ==
                                              originalProfilePicture.value
                                          ? ""
                                          : copyProfilePicture.value,
                                    );
                                  },
                                )
                        : SizedBox.shrink(),
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

class ImageBackgroundContainer extends StatelessWidget {
  const ImageBackgroundContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: child,
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.imagePath, this.onPressed});

  final String imagePath;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: (imagePath.startsWith('upload'))
                ? Image.network(getImageUrl(imagePath), fit: BoxFit.cover)
                : (File(imagePath).existsSync())
                ? Image.file(File(imagePath), fit: BoxFit.cover)
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),

        if (onPressed != null)
          Positioned(
            right: -10,
            top: -10,
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(Iconsax.close_circle, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
