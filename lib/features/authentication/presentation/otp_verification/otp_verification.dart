import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_image.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/time_format_helper.dart';
import 'package:dating_user/features/authentication/controller/otp_verification/otp_verification_controller.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/common_widget/custom_elevated_button.dart';

class OtpVerification extends GetView<OtpVerificationController> {
  const OtpVerification({super.key});

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
          child: Padding(
            padding: .symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: .circular(12)),
                  padding: .all(12),
                  child: Column(
                    spacing: 12,
                    children: [
                      Container(
                        padding: .all(12),
                        decoration: BoxDecoration(
                          color: Color(0xffC4C0FF),
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                        child: Icon(Icons.lock, color: AppColor.primaryColor),
                      ),
                      Text(
                        "Enter Code",
                        style: AppTextStyle.semiBoldPoppins.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "We've sent a 6-digit verification code to your email and mobile number.",
                        textAlign: .center,

                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),

                      Pinput(
                        length: 6,
                        controller: controller.otpController,
                        defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: AppColor.primaryColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF3EEFF),
                            borderRadius: .circular(6),
                          ),
                          height: 60,
                          width: 56,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => CustomElevatedButton(
                                padding: .symmetric(vertical: 10),
                                child: controller.isLoading.value
                                    ? CustomCircularLoader()
                                    : Text(
                                        "Verify",
                                        style: AppTextStyle.mediumPoppins
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                      ),
                                onPressed: () {
                                  controller.submitOTP(context);
                                  // Get.off(
                                  //   () => ProfileSetupScreen(),
                                  //   binding: BindingsBuilder.put(
                                  //     () => Get.put(ProfileSetupController()),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      Obx(() {
                        return !controller.isResentEnable.value
                            ? Row(
                                mainAxisAlignment: .center,
                                spacing: 6,
                                children: [
                                  Icon(CupertinoIcons.clock, size: 14),
                                  Obx(
                                    () => Text(
                                      "Resend code in ${formatSeconds(controller.timerClock.value)}",
                                      style: AppTextStyle.mediumPoppins
                                          .copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              )
                            : TextButton(
                                onPressed: () {
                                  controller.resentOTP(context);
                                },
                                child: Text(
                                  "Resend Code",
                                  style: AppTextStyle.mediumPoppins.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                      }),
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
