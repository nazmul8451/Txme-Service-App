class ApiConstant {
  static const String baseUrl = "http://10.10.7.26:5002";
  static const String apiVersion = "/api/v1";

  static const String socketUrl = baseUrl;


  ///===================== Sing Up =========================///

  static const String signUpSendEmailOtp = "$apiVersion/auth/send-email-otp";
  static const String signUpEmailVerifyOtp = "$apiVersion/auth/verify-otp";
  static const String resendOtp = "$apiVersion/auth/resend-otp";


  ///===================== Sing In =========================///

  static const String login = "$apiVersion/auth/login";



  static const String bearerToken = "bearerToken";
}
