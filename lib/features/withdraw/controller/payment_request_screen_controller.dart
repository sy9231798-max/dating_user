import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/core/helper/helper.dart';
import 'package:dating_user/core/helper/snackbar_helper.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dating_user/features/withdraw/model/payment_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PaymentRequestScreenController extends GetxController {
  Rxn<PaymentDetail> paymentDetail = Rxn();
  RxBool isLoading = false.obs;

  RxString accountNumber = "".obs;
  RxString holderName = "".obs;
  RxString bankName = "".obs;
  RxString ifsc = "".obs;

  @override
  void onInit() {
    super.onInit();

    Future.microtask(() => fetchStoredPaymentDetail());
  }

  void fetchStoredPaymentDetail() async {
    isLoading.value = true;
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.storedPaymentDetail;
    try {
      var response = await dio.get(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      paymentDetail.value = PaymentDetail.fromJson(response.data);
    } on DioException catch (e) {
      Logger().e(e.response?.data);
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onSubmitPaymentDetail({required BuildContext context}) async {
    if (bankName.value.isEmpty) {
      errorSnackBar(context, "Bank Name Cannot Be Empty");
      return;
    }
    if (accountNumber.value.isEmpty) {
      errorSnackBar(context, "Account Number Cannot Be Empty");
      return;
    }
    if (holderName.value.isEmpty) {
      errorSnackBar(context, "Account Holder Name Cannot Be Empty");
      return;
    }
    if (ifsc.value.isEmpty) {
      errorSnackBar(context, "IFSC Cannot Be Empty");
      return;
    }

    await addStoredPaymentDetail({
      "account_number": accountNumber.value,
      "holder_name": holderName.value,
      "ifsc_code": ifsc.value,
      "bank_name": bankName.value,
    });
  }

  Future<void> addStoredPaymentDetail(Map<String, dynamic> data) async {
    isLoading.value = true;
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.storePaymentDetail;
    try {
      var response = await dio.post(
        endPoints,
        data: data,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );
      paymentDetail.value = PaymentDetail.fromJson(response.data);
    } on DioException catch (e) {
      Logger().e(e.response?.data);
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeStoredPaymentDetail({
    required BuildContext context,
  }) async {
    isLoading.value = true;
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.deleteStorePaymentDetail;
    try {
      var response = await dio.delete(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        paymentDetail.value = null;
      }
    } on DioException catch (e) {
      Logger().e(e.response?.data);
      if (!context.mounted) return;
      errorSnackBar(
        context,
        e.response?.data?["detail"] ?? "Something went wrong",
      );
    } catch (e) {
      if (!context.mounted) return;
      errorSnackBar(context, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  var amount = "";
  final withdrawalLoading = false.obs;

  Future<void> withdrawalRequest({required BuildContext context}) async {
    if (withdrawalLoading.value) return;
    if (amount.isEmpty) {
      errorSnackBar(context, "Amount Cannot Be Empty");
      return;
    }
    final amountValue = int.tryParse(amount) ?? 0;
    if (amountValue == 0 || amountValue < 100) {
      errorSnackBar(context, "Amount Should Be Greater Then 100");
      return;
    }
    withdrawalLoading.value = true;
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.withdrawalRequest;
    try {
      var response = await dio.post(
        endPoints,
        data: amountValue,
        options: Options(
          headers: StorageHelper().getHeaderWithToken(),
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
      }
    } on DioException catch (e) {
      Logger().e(e.response?.data);
      if (!context.mounted) return;
      errorSnackBar(
        context,
        e.response?.data?["detail"] ?? "Something went wrong",
      );
    } catch (e) {
      if (!context.mounted) return;
      errorSnackBar(context, e.toString());
    } finally {
      withdrawalLoading.value = false;
    }
  }
}
