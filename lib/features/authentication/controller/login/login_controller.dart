import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/features/authentication/controller/otp_verification/otp_verification_controller.dart';
import 'package:dating_user/features/authentication/data/auth_repo.dart';
import 'package:dating_user/features/authentication/presentation/otp_verification/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  final repo = AuthRepo();
  final isLoading = false.obs;

  void login(BuildContext context) async {
    if (isLoading.value) return;

    if (mobileController.text.trim().isEmpty) {
      errorSnackBar(context, "Mobile Cannot Be Empty");
      return;
    }
    isLoading.value = true;
    var response = await repo.loginCall(mobile: mobileController.text.trim());
    response.fold(
      (l) {
        Get.off(
          () => OtpVerification(),
          binding: BindingsBuilder.put(
            () => Get.put(
              OtpVerificationController(mobileController.text.trim()),
            ),
          ),
        );
      },
      (r) {
        errorSnackBar(context, r.message!);
      },
    );
    isLoading.value = false;
  }
}
