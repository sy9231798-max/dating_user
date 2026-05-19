import 'dart:math';

import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/call/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:random_name_generator/random_name_generator.dart';

class CallScreen extends GetView<CallController> {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: .symmetric(horizontal: 12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: .start,
          children: [
            Text(
              "Recent Call",
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
                    : controller.allCallHistory.isEmpty
                    ? Center(
                        child: Text(
                          "No Call History",
                          style: AppTextStyle.normalPoppins.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Obx(
                        () => ListView.separated(
                          itemCount: controller.allCallHistory.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            var call = controller.allCallHistory[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: .circular(12),
                                color: Colors.white,
                              ),
                              padding: .symmetric(horizontal: 12, vertical: 6),
                              child: Row(
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
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    getImageUrl(
                                                      call.user?.profilePicture ??
                                                          "",
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              spacing: 6,
                                              crossAxisAlignment: .start,
                                              mainAxisAlignment: .start,
                                              children: [
                                                Text(
                                                  call.user?.firstName ?? "",
                                                  style: AppTextStyle
                                                      .mediumPoppins
                                                      .copyWith(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                Row(
                                                  spacing: 6,
                                                  children: [
                                                    Icon(
                                                      call.callerId ==
                                                              AppHelper
                                                                  .instance
                                                                  .userData
                                                                  ?.id
                                                          ? Iconsax
                                                                .call_outgoing_copy
                                                          : Iconsax
                                                                .call_incoming_copy,
                                                      color: Colors.green,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                        'MMMM d, h:mm a',
                                                      ).format(
                                                        call.createdAt ??
                                                            DateTime.now(),
                                                      ),
                                                      style: AppTextStyle
                                                          .normalPoppins
                                                          .copyWith(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        call.duration.toString(),
                                        style: AppTextStyle.semiBoldPoppins
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.video,
                                        color: AppColor.primaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
