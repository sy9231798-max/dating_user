import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dating_user/core/base/api_error.dart';
import 'package:dating_user/core/common_model/user_profile_status.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../core/dependency/dependency.dart';

class AuthRepo {
  Future<Either<bool, APIError>> loginCall({required String mobile}) async {
    var dio = di<Dio>();
    try {
      var endPoint = ApiEndpoints.login;
      var response = await dio.post(
        endPoint,
        data: {"phone_number": mobile, "account_type": "user"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Logger().e(response.data);
        return Left(true);
      } else {
        return Right(
          APIError(
            code: response.statusCode ?? 0,
            message: "Something went Wrong",
          ),
        );
      }
    } on DioException catch (e) {
      Logger().e(e.response?.data["detail"] ?? "Something went wrong");
      return Right(
        APIError(
          code: e.response?.statusCode ?? 0,
          message: "Something went Wrong",
        ),
      );
    } catch (e) {
      return Right(APIError(code: 0, message: "Something went wrong"));
      Logger().e(e.toString());
    }
  }

  Future<Either<UserProfileStatus, APIError>> submitOTP({
    required String number,
    required String otp,
  }) async {
    var dio = di<Dio>();
    var endPoint = ApiEndpoints.verifyOTP;
    try {
      var response = await dio.post(
        endPoint,
        data: {"phone_number": number, "otp": otp},
      );

      Logger().e(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(UserProfileStatus.fromJson(response.data));
      }
      return Right(
        APIError(
          code: response.statusCode ?? 404,
          message: response.statusMessage,
        ),
      );
    } on DioException catch (e) {
      return Right(
        APIError(
          code: 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      return Right(APIError(code: 0, message: e.toString()));
    }
  }

  Future<Either<bool, APIError>> resentOTPCall({required String number}) async {
    var dio = di<Dio>();
    var endPoint = ApiEndpoints.resentOTP;
    try {
      var response = await dio.post(
        endPoint,
        data: jsonEncode(number.toString()),
      );

      Logger().e(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Left(true);
      }
      return Left(false);
    } on DioException catch (e) {
      Logger().e(e.response?.statusCode);
      return Right(
        APIError(
          code: 0,
          message: e.response?.data["detail"] ?? "Something went wrong",
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      return Right(APIError(code: 0, message: e.toString()));
    }
  }
}
