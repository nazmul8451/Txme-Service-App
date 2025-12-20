class ApiConstant {
  static const String baseUrl = "http://10.10.7.26:5002";
  static const String apiVersion = "/api/v1";


  static const String socketUrl = baseUrl;

  ///===================== SIGN UP =========================///

  static const String signUpSendEmailOtp =
      "$apiVersion/auth/send-email-otp";

  static const String signUpEmailVerifyOtp =
      "$apiVersion/auth/verify-otp";

  static const String resendOtp =
      "$apiVersion/auth/resend-otp";

  static const String completeProfile =
      "$apiVersion/auth/complete-profile";

  ///===================== SIGN IN =========================///

  static const String login =
      "$apiVersion/auth/login";

  static const String enableBiometric =
      "$apiVersion/auth/enable-biometric";
  // body: { "email": "example@gmail.com" }
  // → OTP যাবে → verify করলে biometricToken দিবে

  static const String biometricLogin =
      "$apiVersion/auth/biometric-login";
// body: { "biometricToken": "xxxx" }



  static const String bearerToken = "bearerToken";

}
