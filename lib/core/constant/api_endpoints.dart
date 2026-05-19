class ApiEndpoints {
  static const String baseUrl = "http://192.168.1.4:8000";
  // static const String baseUrl = "https://testingbackend.duckdns.org";
  // static const String baseUrl = "http://10.121.127.158:8000";
  //Auth
  static const String login = "/v1/auth/login";
  static const String verifyOTP = "/v1/auth/verify_otp";
  static const String resentOTP = "/v1/auth/resent_otp";

  //Profile Setup
  static const String profileImageSetup = "/v1/auth/client-profile-image";
  static const String removeAdditionImage = "/v1/auth//remove-addition-image";
  static const String profileVideoSetup = "/v1/auth/client-profile-video";
  static const String profileDetailSetup = "/v1/auth/client-profile-detail";
  static const String reference = "/v1/auth//submit-reference";
  static const String profileStatus = "/v1/user/profile-status";
  static const String callHistory = "/v1/user/call-history";
  static const String storedPaymentDetail = "/v1/user/stored-payment-detail";
  static const String storePaymentDetail = "/v1/user/store-payment-detail";
  static const String deleteStorePaymentDetail =
      "/v1/user/delete-store-payment-detail";
  static const String withdrawalRequest = "/v1/user/withdrawal-request";
  static const String lifeTimeEarning = "/v1/user/lifetime-earning";
  static const String withdrawalHistory = "/v1/user/get-withdraw-history";
}
