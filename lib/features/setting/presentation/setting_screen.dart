import 'dart:math';

import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/profile_edit/presentation/profile_edit_screen.dart';
import 'package:dating_user/features/withdraw/controller/withdraw_screen_controller.dart';
import 'package:dating_user/features/withdraw/presentation/withdraw_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_text_style.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: .symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                Text(
                  "Settings",
                  style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => ProfileEditScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: Colors.white,
                    ),
                    padding: .symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            Icon(Iconsax.user),
                            Text(
                              "Profile",
                              style: AppTextStyle.mediumPoppins.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: AppColor.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              spacing: 6,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(6),
                          ),
                          insetPadding: .symmetric(horizontal: 24),
                          child: Padding(
                            padding: .all(12),
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 12,
                              mainAxisSize: .min,
                              children: [
                                Text(
                                  "Are You Sure?",
                                  style: AppTextStyle.semiBoldPoppins.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.offAll(() => LoginScreen());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text("Logout"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.black,
                  ),
                  child: Text("Logout"),
                ),
                Text(
                  "Version 1.0.0(12)",
                  style: AppTextStyle.mediumPoppins.copyWith(
                    color: Colors.grey,
                    fontSize: 14,
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
