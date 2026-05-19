import 'package:dartz/dartz.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dating_user/features/call/call_history_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide navigator;
import 'package:logger/logger.dart';

class CallController extends GetxController {
  RxList<CallHistoryModel> allCallHistory = RxList();

  @override
  void onInit() {
    getAllCallHistory();
    super.onInit();
  }

  final isLoading = false.obs;

  void getAllCallHistory() async {
    try {
      isLoading.value = true;
      var response = await di<Dio>().get(
        ApiEndpoints.callHistory,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      var temp = <CallHistoryModel>[];
      for (var i in response.data) {
        temp.add(CallHistoryModel.fromJson(i));
      }
      allCallHistory.addAll(temp);
    } on DioException catch (e) {
      Logger().e(e.response?.data ?? "Something went wrong");
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
