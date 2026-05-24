import 'package:dating_user/core/common_widget/custom_text_field.dart';
import 'package:dating_user/core/constant/app_image.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/features/authentication/controller/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common_widget/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

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
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: .all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                  child: Icon(Icons.home, size: 56),
                ),
                Text(
                  "Welcome",
                  style: AppTextStyle.semiBoldPoppins.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Enter your details to receive a secure One-Time Password for login.",
                  textAlign: .center,
                  style: AppTextStyle.normalPoppins.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                  width: double.infinity,

                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 12,
                      mainAxisAlignment: .center,
                      children: [
                        CustomTextField(
                          label: "Mobile Number",
                          prefixIcon: Icon(Iconsax.mobile_copy),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: controller.mobileController,
                        ),
                        Obx(
                          () => CustomElevatedButton(
                            onPressed: () {
                              controller.login(context);
                            },
                            child: controller.isLoading.value
                                ? CustomCircularLoader()
                                : Row(
                                    spacing: 6,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Send OTP",
                                        style: AppTextStyle.mediumPoppins
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                      ),
                                      Icon(
                                        Iconsax.arrow_right_1_copy,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
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

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: 12),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
