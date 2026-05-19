import 'package:dating_user/core/common_model/user_model.dart';
import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class HomeScreenController extends GetxController {
  RxList<UserModel> allUser = RxList();
  final isLoading = false.obs;


  @override
  void onInit() {
    getExploreData();
    super.onInit();
  }
  void getExploreData() async {
    isLoading.value = true;
    try {
      var response = await di<Dio>().get(
        "/v1/user/explore",
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );
      var temp = <UserModel>[];
      for (var i in response.data) {
        temp.add(UserModel.fromJson(i));
      }

      allUser.addAll(temp);
    } on DioException catch (e) {

      Logger().e(e.requestOptions.path);
      Logger().e(e.response?.data ?? "Something went wrong");
    } catch (e) {
      Logger().e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
