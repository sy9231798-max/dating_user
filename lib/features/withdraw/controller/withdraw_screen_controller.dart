import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dating_user/features/withdraw/model/PaymentHistoryModel.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../core/dependency/dependency.dart';

class WithdrawScreenController extends GetxController {
  late final pagingController = PagingController<int, PaymentHistoryModel>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => getPaymentHistory(pageKey),
  );
  final headerLoading = false.obs;
  final lifeTimeEarning = 0.obs;
  final currentEarning = 0.obs;

  @override
  void onInit() {
    Future.microtask(() => getLifeTimeEarning());
    super.onInit();
  }

  Future<void> getLifeTimeEarning() async {
    // return ;
    try {
      var response = await di<Dio>().get(
        ApiEndpoints.lifeTimeEarning,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );
      lifeTimeEarning.value = response.data?["lifetime_earning"] ?? 0;
      currentEarning.value = response.data?["current_earning"] ?? 0;
    } on DioException catch (e) {
      Logger().e(e.response?.data?["detail"] ?? "Something went wrong");
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  Future<List<PaymentHistoryModel>> getPaymentHistory(int page) async {
    try {
      var response = await di<Dio>().get(
        ApiEndpoints.withdrawalHistory,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
        queryParameters: {"page": page, "page_size": 20},
      );
      var allHistory = response.data["data"] as List<dynamic>;
      return allHistory.map((e) => PaymentHistoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      Logger().e(e.response?.data?["detail"] ?? "Something went wrong");
      return [];
    } catch (e) {
      Logger().e(e.toString());
      return [];
    }
  }
}
