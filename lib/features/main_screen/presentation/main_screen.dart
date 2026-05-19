import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/scoket_helper.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/call/controller/call_controller.dart';
import 'package:dating_user/features/call/presentation/call_screen.dart';
import 'package:dating_user/features/chat/presentation/chat_screen.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_helper.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:dating_user/features/home/controller/home_screen_controller.dart';
import 'package:dating_user/features/home/presentation/home_screen.dart';
import 'package:dating_user/features/setting/presentation/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainScreenController controller;
  @override
  void initState() {
    controller = Get.put(MainScreenController());
    Get.put(MainChatController());
    Get.put(HomeScreenController());
    Get.lazyPut(()=>CallController(),fenix: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: (value) {
              controller.currentIndex.value = value;
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            selectedItemColor: AppColor.primaryColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(color: AppColor.primaryColor),
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            selectedLabelStyle: AppTextStyle.normalPoppins.copyWith(
              fontSize: 16,
              color: AppColor.primaryColor,
            ),
            unselectedLabelStyle: AppTextStyle.normalPoppins.copyWith(
              fontSize: 16,
              color: Colors.grey,
            ),
            currentIndex: controller.currentIndex.value,
            items: [
              BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.message),
                label: "Chat",
              ),
              BottomNavigationBarItem(icon: Icon(Iconsax.call), label: "Call"),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.setting),
                label: "Settings",
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.screenHolder[controller.currentIndex.value](),
        ),
      ),
    );
  }
}

class MainScreenController extends GetxController {
  static MainScreenController get instance => Get.find();
  ChatHelper chatHelper = ChatHelper();
  var socket = SocketHelper();


  @override
  void onInit() {
    socket.initialize();
    super.onInit();
  }

  final currentIndex = 0.obs;
  final screenHolder = [
    () => HomeScreen(),
    () => ChatScreen(),
    () => CallScreen(),
    () => SettingScreen(),
  ];
}
