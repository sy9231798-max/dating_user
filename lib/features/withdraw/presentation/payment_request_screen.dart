import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/common_widget/custom_text_field.dart';
import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/dialog_helper.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/features/authentication/presentation/login/login_screen.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/withdraw/controller/payment_request_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PaymentRequestScreen extends GetView<PaymentRequestScreenController> {
  const PaymentRequestScreen({super.key});

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
            "Payment",
            style: AppTextStyle.normalPoppins.copyWith(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: .symmetric(horizontal: 12),
          child: Obx(
            () => controller.isLoading.value
                ? CustomCircularLoader()
                : controller.paymentDetail.value == null
                ? Column(
                    spacing: 12,
                    children: [
                      Text(
                        "Payment Detail Form",
                        textAlign: .center,
                        style: AppTextStyle.mediumPoppins.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      CustomTextField(
                        label: "Bank Name",
                        onChanged: (value) => controller.bankName.value = value,
                      ),
                      CustomTextField(
                        label: "Account Number",
                        onChanged: (value) =>
                            controller.accountNumber.value = value,
                      ),
                      CustomTextField(
                        label: "Account Holder Name",
                        onChanged: (value) =>
                            controller.holderName.value = value,
                      ),
                      CustomTextField(
                        label: "IFSC Code",
                        onChanged: (value) => controller.ifsc.value = value,
                      ),
                      CustomElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          controller.onSubmitPaymentDetail(context: context);
                        },
                      ),
                    ],
                  )
                : Column(
                    spacing: 12,
                    children: [
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          enabled: false,
                          backgroundColor: AppColor.primaryColor,
                          collapsedBackgroundColor: AppColor.primaryColor,
                          iconColor: Colors.white,
                          trailing: IconButton(
                            onPressed: () async {
                              var isConfirm = await showDeleteConfirmDialog(
                                context: context,
                              );

                              if (isConfirm && context.mounted) {
                                controller.removeStoredPaymentDetail(
                                  context: context,
                                );
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                          collapsedIconColor: Colors.white,
                          subtitle: Text(
                            controller.paymentDetail.value!.accountNumber,
                            style: AppTextStyle.normalPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          title: Text(
                            "Account Number",
                            style: AppTextStyle.normalPoppins.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          expandedCrossAxisAlignment: .start,
                          expandedAlignment: .centerLeft,
                          tilePadding: .symmetric(horizontal: 12),
                          childrenPadding: .symmetric(horizontal: 12),
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "Bank Name",
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  controller.paymentDetail.value!.bankName,
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "Account Holder Name",
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  controller.paymentDetail.value!.holderName,
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "IFSC Code",
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  controller.paymentDetail.value!.ifscCode,
                                  style: AppTextStyle.normalPoppins.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            "Account Credits",
                            style: AppTextStyle.semiBoldPoppins.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            (AppHelper.instance.userData?.coins ?? 0)
                                .toString(),
                            style: AppTextStyle.mediumPoppins.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      CustomTextField(
                        hint: "Enter Account To Withdraw",
                        keyboardType: .number,
                        onChanged: (value) {
                          controller.amount = value;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      Obx(
                        () => CustomElevatedButton(
                          child: controller.withdrawalLoading.value
                              ? CustomCircularLoader()
                              : Text("Withdrawal"),
                          onPressed: () {
                            controller.withdrawalRequest(context: context);
                          },
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
