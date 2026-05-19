import 'package:dating_user/core/common_model/user_model.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../dependency/dependency.dart';

class AppHelper {
  AppHelper._internal();

  // static Helper get _instance => Helper._internal();
  static final AppHelper _instance = AppHelper._internal();
  factory AppHelper() => _instance;

  static AppHelper get instance => _instance;
  UserModel? userData;

  RxList<int> onlineId = RxList();

  Future<void> getMe() async {
    try {
      var response = await di<Dio>().get(
        "/v1/user/me",
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      Logger(). e(response.requestOptions.path);
      Logger().e(response.data);
      userData = UserModel.fromJson(response.data);
    } on DioException catch (e) {
      Logger().e(e.requestOptions.path);
      Logger().e(e.response?.data ?? "Something Went Wrong");
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  static bool isListEqual(List a, List b) {
    if (a.length != b.length) return false;

    List aCopy = List.from(a)..sort();
    List bCopy = List.from(b)..sort();

    for (int i = 0; i < aCopy.length; i++) {
      if (aCopy[i] != bCopy[i]) return false;
    }
    return true;
  }
}

String getImageUrl(String url) {
  return "${ApiEndpoints.baseUrl}/$url";

}
