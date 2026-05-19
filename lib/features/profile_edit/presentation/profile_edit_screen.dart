import 'dart:math';

import 'package:dating_user/core/common_widget/dotted_border_container.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:random_name_generator/random_name_generator.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("Profile Edit"),

          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: .symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 24,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              getImageUrl(
                                AppHelper.instance.userData?.profilePicture ??
                                    "",
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 6,
                      children: [
                        Icon(Iconsax.edit_copy, size: 16),
                        Text(
                          "Edit Profile Picture",
                          style: AppTextStyle.normalPoppins.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 12,
                  children: List.generate(AppHelper.instance.userData?.additionImages.length ?? 3, (index) {
                    return Expanded(
                      child: InkWell(
                        onTap: () async {},
                        child: DottedBorderContainer(
                          strokeWidth: 1,
                          dotLength: 10,
                          padding: .all(6),
                          child: SizedBox(
                            height: 100,
                            child: true
                                ? ImageWidget(
                                    imagePath:
                                        AppHelper
                                            .instance
                                            .userData
                                            ?.additionImages[index]
                                            .imagePath ??
                                        "",
                                  )
                                : Column(
                                    mainAxisAlignment: .center,
                                    children: [
                                      Text(
                                        "Profile Picture",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: AppTextStyle.mediumPoppins.copyWith(fontSize: 16),
                    ),
                    Text(
                      AppHelper.instance.userData?.fullName ?? "",
                      style: AppTextStyle.normalPoppins.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: AppTextStyle.mediumPoppins.copyWith(fontSize: 16),
                    ),
                    Text(
                      AppHelper.instance.userData?.email ?? "",
                      style: AppTextStyle.normalPoppins.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                if (false)
                  Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone",
                        style: AppTextStyle.mediumPoppins.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        AppHelper.instance.userData?.email ?? "",
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
