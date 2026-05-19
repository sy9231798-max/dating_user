import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/controller/login/login_controller.dart';
import 'package:dating_user/features/authentication/controller/profile_setup/profile_setup_controller.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_detail_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_setup_screen.dart';
import 'package:dating_user/features/main_screen/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      var isLoggedIn = GetStorage().read<bool>(StorageKeys.isLoggedIn) ?? false;

      Logger().e(isLoggedIn);
      if (isLoggedIn) {
        var profileSetupNeeded =
            GetStorage().read<bool>(StorageKeys.needProfileSetup) ?? true;
        var token = GetStorage().read(StorageKeys.token) ?? "";
        if (token == "") {
          Get.to(
            () => LoginScreen(),
            binding: BindingsBuilder.put(() => Get.put(LoginController())),
          );
          return;
        }
        await AppHelper.instance.getMe();

        if (profileSetupNeeded) {
          Get.to(
            () => LoginProfileDetailScreen(
              firstName: AppHelper.instance.userData?.firstName ?? "",
              lastName: AppHelper.instance.userData?.lastName ?? "",
              email: AppHelper.instance.userData?.email ?? "",
              dob: AppHelper.instance.userData?.dob ?? "",
              gender: AppHelper.instance.userData?.gender ?? "",
              city: AppHelper.instance.userData?.city ?? "",
              state: AppHelper.instance.userData?.state ?? "",
              reference: "",
              hobby: AppHelper.instance.userData?.hobby ?? [],
              error: "",
            ),
            binding: BindingsBuilder.put(
              () => Get.put(ProfileSetupController()),
            ),
          );
          return;
        } else {
          Get.to(() => MainScreen());
          return;
        }
      } else {
        Get.to(
          () => LoginScreen(),
          binding: BindingsBuilder.put(() => Get.put(LoginController())),
        );
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column());
  }
}
