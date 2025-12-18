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
  static const String enableBiometric =
      "$apiVersion/auth/enable-biometric"; //"email":"ce.sakilhossene302@gmail.com" a otp jabe otp dile token dibe
  static const String biometricLogin =
      "$apiVersion/auth/biometric-login"; //{"biometricToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NDM1MDE4NWFhMTQzNjQxOTNlNmM0NiIsInJvbGUiOiJQUk9WSURFUiIsImVtYWlsIjoiY2Uuc2FraWxob3NzZW5lMzAyQGdtYWlsLmNvbSIsImlhdCI6MTc2NjAxOTcyMCwiZXhwIjoxNzY4NjExNzIwfQ.Zl8X5Jr_8HEDZcLF0JAOq8a0-c-16OZUIXHYFEp-rPk"}

  static const String bearerToken = "bearerToken";
}
