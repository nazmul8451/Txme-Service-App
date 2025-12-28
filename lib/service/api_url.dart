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



  ///===================== Home (user) =========================///


  /// GET → Provider calendar slots
  /// usage: /provider/{id}/calendar?date=yyyy-MM-dd
  static const String providerCalendar = "$apiVersion/provider";

  static const String appointmentCreate = "$apiVersion/appointment/create";

  static const String appointmentMyAppointments = "$apiVersion/appointment/my-appointments/";


  static const String serviceGet  = "$apiVersion/service/get-services";

  static const String popularProviders  = "$apiVersion/provider/popular";
  static const String appointmentUpdate  = "$apiVersion/appointment/update-status/";



  ///===================== Wallet =========================///



  static const String myWalletAvailableBalance  =
      "$apiVersion/wallet/my-wallet";
  static const String createPaymentIntent  =
      "$apiVersion/wallet/create-payment-intent";


  ///===================== Chats =========================///

  /// ======================== post Api =========================///


  static const String CeatsChat  = "$apiVersion/chat";

  static const String chatAdminSupport  = "$apiVersion/chat/admin-support";


  /// ====================== Get Api ======================= ///

  static const String  getChat = "$apiVersion/chat";  ///


  static const String  getAdminSupportAll = "$apiVersion/chat/admin-support/all";
  static const String  deleteChat = "$apiVersion/api/chat/"; //+id caicce


  ///=====================  message =========================///

  /// ======================== post Api =========================///


  static const String  message = "$apiVersion/message";                        ///

  ///================================ Get Api ==================================///


  static const String getMessage = "$apiVersion/message"; // + /{chatId}?page=&limit=

  static const String deleteMessage = "$apiVersion/message"; // + /{messageId}



  static const String childServices = "$apiVersion/service/get-all-child-services";


  static const String userMe = "$apiVersion/user/me";

  static const String allProviderUser = "$apiVersion/user";


  static const String bearerToken = "bearerToken";

}
