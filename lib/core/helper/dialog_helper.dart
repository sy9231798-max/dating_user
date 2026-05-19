import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

Future<List<XFile>> galleryAndCameraDialog({
  required BuildContext context,
  bool multipleGallery = false,
  int limit = 1,
}) async {
  return await showDialog<List<XFile>>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: .symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            child: Padding(
              padding: .symmetric(horizontal: 54, vertical: 12),
              child: Column(
                spacing: 12,
                mainAxisSize: .min,
                children: [
                  Text(
                    "Choose an option",
                    style: AppTextStyle.mediumPoppins.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      if (multipleGallery) {
                        final List<XFile> photo = await picker.pickMultiImage(
                          limit: limit,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context, photo);
                      } else {
                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(
                          context,
                          photo == null ? <XFile>[] : [photo],
                        );
                      }
                    },
                    child: Card(
                      elevation: 0.5,

                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                      color: Colors.black ?? Color(0xffF3EEFF),
                      child: Padding(
                        padding: .all(12),
                        child: Row(
                          mainAxisAlignment: .center,
                          spacing: 12,
                          children: [
                            Icon(Iconsax.gallery, color: Colors.white),
                            Text(
                              "Gallery",
                              style: AppTextStyle.normalPoppins.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? photo = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(
                        context,
                        photo == null ? <XFile>[] : [photo],
                      );
                    },
                    child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                      color: Colors.black ?? Color(0xffF3EEFF),
                      child: Padding(
                        padding: .all(12),
                        child: Row(
                          mainAxisAlignment: .center,
                          spacing: 12,
                          children: [
                            Icon(Iconsax.camera, color: Colors.white),
                            Text(
                              "Camera",
                              style: AppTextStyle.normalPoppins.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      [];
}

Future<bool> showDeleteConfirmDialog({required BuildContext context}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              padding: .all(12),
              child: Column(
                spacing: 12,
                mainAxisSize: .min,
                children: [
                  Text("Are You Sure ?"),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Get.back(result: false);
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomElevatedButton(
                          child: Text("Confirm"),
                          onPressed: () {
                            Get.back(result: true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}
