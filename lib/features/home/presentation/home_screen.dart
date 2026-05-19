import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/home/controller/home_screen_controller.dart';
import 'package:dating_user/features/profile/persentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../core/constant/app_icon.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isToggle = true;
    return Column(
      children: [
        Column(
          spacing: 12,
          children: [
            AppBar(
              title: Text(AppHelper.instance.userData?.fullName ?? "No Name"),
              centerTitle: false,
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              actions: [
                Container(
                  padding: .symmetric(horizontal: 6,vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Icon(Iconsax.coin_1, color: Colors.black),
                      Text(
                        AppHelper.instance.userData?.coins.toString() ?? "",
                        style: AppTextStyle.mediumPoppins.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              Obx(
                () => controller.isLoading.value
                    ? SliverToBoxAdapter(child: SizedBox())
                    : SliverGrid.builder(
                        itemCount: controller.allUser.length,
                        itemBuilder: (context, index) {
                          var user = controller.allUser[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => ProfileScreen(userData: user));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(12),
                              ),
                              color:
                                  AppHelper.instance.onlineId.contains(user.id)
                                  ? Colors.green
                                  : Colors.red ?? AppColor.primaryColor,
                              shadowColor: Colors.transparent,
                              elevation: 0.5,
                              child: Column(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: .circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  "${ApiEndpoints.baseUrl}/${user.profilePicture}",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          child: Row(
                                            spacing: 6,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppHelper
                                                          .instance
                                                          .onlineId
                                                          .contains(user.id)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  shape: .circle,
                                                ),
                                              ),
                                              Text(
                                                AppHelper.instance.onlineId
                                                        .contains(user.id)
                                                    ? "Online"
                                                    : "Offline",
                                                style: AppTextStyle
                                                    .semiBoldPoppins
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: .all(6),
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          user.fullName.toString(),
                                          style: AppTextStyle.semiBoldPoppins
                                              .copyWith(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
