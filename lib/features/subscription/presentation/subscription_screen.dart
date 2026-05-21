import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("Subscription"),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        body: GridView.builder(
          itemCount: 7,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 150,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: .all(6),
              decoration: BoxDecoration(
                borderRadius: .circular(12),
                color: AppColor.primaryColor,
              ),
              child: Column(
                spacing: 12,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: .circular(12 - 2),
                      ),
                      alignment: .center,
                      child: Badge.count(
                        count: 1200,
                        textStyle: AppTextStyle.semiBoldPoppins.copyWith(
                          fontSize: 18,
                        ),
                        backgroundColor: AppColor.primaryColor,
                        child: Icon(Iconsax.coin_1, size: 54),
                      ),
                    ),
                  ),
                  Text(
                    "Rs 100",
                    style: AppTextStyle.normalPoppins.copyWith(fontSize: 18),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
