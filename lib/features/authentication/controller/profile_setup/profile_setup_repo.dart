import 'package:dartz/dartz.dart';
import 'package:dating_user/core/base/api_error.dart';
import 'package:dating_user/core/common_model/user_profile_status.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/dependency/dependency.dart';
import 'package:dating_user/core/helper/storage_helper.dart';
import 'package:dating_user/features/authentication/model/profile_setup_detail.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ProfileSetupRepo {
  Future<Either<bool, APIError>> submitProfileImageCall({
    required String profilePicture,
    required List<String> additionImages,
  }) async {
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.profileImageSetup;
    try {
      final otherPictures = await Future.wait(
        additionImages.map((path) async {
          return await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          );
        }),
      );
      FormData formData = FormData.fromMap({
        if (profilePicture.isNotEmpty)
          "profile_picture": await MultipartFile.fromFile(
            profilePicture,
            filename: profilePicture.split('/').last,
          ),
        if (additionImages.isNotEmpty) "other_picture": otherPictures,
      });

      var response = await dio.post(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.statusCode);
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<bool, APIError>> submitProfileVideoCall({
    required String videoPath,
  }) async {
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.profileVideoSetup;
    try {
      FormData formData = FormData.fromMap({
        "profile_video": await MultipartFile.fromFile(
          videoPath,
          filename: videoPath.split('/').last,
        ),
      });
      var response = await dio.post(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<bool, APIError>> submitProfileDetailCall({
    required ProfileSetupDetailModel model,
  }) async {
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.profileDetailSetup;
    try {
      var response = await dio.post(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<bool, APIError>> removeAdditionImage({required int id}) async {
    var dio = di<Dio>();
    var endPoints = "${ApiEndpoints.removeAdditionImage}/$id";
    try {
      var response = await dio.delete(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<UserProfileStatus, APIError>> getProfileStatus() async {
    var dio = di<Dio>();
    var endPoints = ApiEndpoints.profileStatus;
    try {
      var response = await dio.get(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      Logger().e(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(UserProfileStatus.fromJson(response.data));
      }
      return Right(
        APIError(
          code: 0,
          message:
              "Failed to get profile with status code ${response.statusCode}",
        ),
      );
    } on DioException catch (e) {
      Logger().e(e.error);
      Logger().e(e.response?.statusCode);
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<bool, APIError>> submitReference(String referenceCode) async {
    var dio = di<Dio>();
    var endPoints = "${ApiEndpoints.reference}/$referenceCode";
    try {
      var response = await dio.post(
        endPoints,
        options: Options(headers: StorageHelper().getHeaderWithToken()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }
}
