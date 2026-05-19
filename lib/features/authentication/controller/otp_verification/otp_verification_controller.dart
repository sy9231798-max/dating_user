import 'dart:async';

import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/data/auth_repo.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_screen.dart';
import 'package:dating_user/features/main_screen/presentation/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../presentation/profile_setup/profile_setup_detail_screen.dart';

class OtpVerificationController extends GetxController {
  final String number;

  OtpVerificationController(this.number);

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  final isLoading = false.obs;

  final isResentEnable = false.obs;
  final repo = AuthRepo();
  final otpController = TextEditingController();
  Timer? timer;
  final timerClock = 0.obs;

  void startTimer() {
    timer?.cancel();
    isResentEnable.value = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timerClock.value = (5 * 60) - timer.tick;
      if (timer.tick == 5 * 60) {
        isResentEnable.value = true;
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void submitOTP(BuildContext context) async {
    if (isLoading.value) return;

    if (otpController.text.trim().isEmpty) {
      errorSnackBar(context, "OTP cannot be empty");
      return;
    }

    if (otpController.text.trim().length < 6) {
      errorSnackBar(context, "OTP should be length 6");
      return;
    }
    isLoading.value = true;
    var response = await repo.submitOTP(
      number: number,
      otp: otpController.text.trim(),
    );

    response.fold(
      (l) async {
        await GetStorage().write("isLoggedIn", true);
        await GetStorage().write(StorageKeys.token, l.token);
        await GetStorage().write(StorageKeys.needProfileSetup, true);
        Get.to(
          () => LoginProfileDetailScreen(
            firstName: l.userData?.firstName ?? "",
            lastName: l.userData?.lastName ?? "",
            email: l.userData?.email ?? "",
            dob: l.userData?.dob ?? "",
            gender: l.userData?.gender ?? "",
            city: l.userData?.city ?? "",
            state: l.userData?.state ?? "",
            reference: "",
            hobby: l.userData?.hobby ?? [],
            error: "",
          ),
          binding: BindingsBuilder.put(
            () => Get.put(ProfileSetupController(initialStatus: l)),
          ),
        );
      },
      (r) {
        errorSnackBar(context, r.message ?? "Something went wrong");
      },
    );
    isLoading.value = false;
  }

  final isResentLoading = false.obs;

  void resentOTP(BuildContext context) async {
    isResentLoading.value = true;
    var response = await repo.resentOTPCall(number: number);

    response.fold(
      (l) {
        if (l) {
          startTimer();
          successSnackBar(context, "OTP Sent to $number");
        } else {
          errorSnackBar(context, "Failed to sent otp try again after sometime");
        }
      },
      (r) {
        Logger().e(r.message);
        errorSnackBar(context, r.message ?? "Something went wrong");
      },
    );
    isResentLoading.value = false;
  }
}
