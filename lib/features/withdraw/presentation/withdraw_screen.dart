import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/withdraw/controller/payment_request_screen_controller.dart';
import 'package:dating_user/features/withdraw/controller/withdraw_screen_controller.dart';
import 'package:dating_user/features/withdraw/presentation/payment_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../model/PaymentHistoryModel.dart';

class WithdrawScreen extends GetView<WithdrawScreenController> {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: Text(
            "Withdraw",
            style: AppTextStyle.normalPoppins.copyWith(fontSize: 18),
          ),
        ),
        body: Column(
          spacing: 12,
          children: [
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: Container(
                    padding: .all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: .circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 6,
                      children: [
                        Text(
                          "Lifetime",
                          style: AppTextStyle.mediumPoppins.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${controller.lifeTimeEarning.value} Coins",
                            style: AppTextStyle.normalPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: .all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: .circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 6,
                      children: [
                        Text(
                          "Earning",
                          style: AppTextStyle.mediumPoppins.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${controller.currentEarning.value} Coins",
                            style: AppTextStyle.normalPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: .symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                    ),
                    child: Text(
                      "Withdrawal Request",
                      style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
                    ),
                    onPressed: () {
                      Get.to(
                        () => PaymentRequestScreen(),
                        binding: BindingsBuilder.put(
                          () => PaymentRequestScreenController(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  "Withdrawal History",
                  style: AppTextStyle.normalPoppins.copyWith(fontSize: 18),
                ),
              ],
            ),
            Expanded(
              child: PagingListener(
                controller: controller.pagingController,
                builder:
                    (
                      BuildContext context,
                      PagingState<int, PaymentHistoryModel> state,
                      void Function() fetchNextPage,
                    ) {
                      return PagedListView<int, PaymentHistoryModel>.separated(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) {
                            return Container(
                              padding: .symmetric(vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: .circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    DateFormat(
                                      "dd/MM/yyyy",
                                    ).format(item.createdAt ?? DateTime.now()),
                                    style: AppTextStyle.mediumPoppins.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${item.amount} Coins",
                                    style: AppTextStyle.normalPoppins.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
              ),
            ),
            // ...List.generate(3, (index) {
            //   return Container(
            //     padding: .symmetric(vertical: 12, horizontal: 12),
            //     decoration: BoxDecoration(
            //       color: AppColor.primaryColor,
            //       borderRadius: .circular(12),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: .spaceBetween,
            //       children: [
            //         Text(
            //           "12/04/2026",
            //           style: AppTextStyle.mediumPoppins.copyWith(fontSize: 16),
            //         ),
            //         Text(
            //           "120 Coins",
            //           style: AppTextStyle.normalPoppins.copyWith(fontSize: 16),
            //         ),
            //       ],
            //     ),
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
