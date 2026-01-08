class ApiConstant {
  // static const String baseUrl = "http://174.129.53.103:5000";  // this Live ip address
  static const String baseUrl = "https://api.txme-exchange.com";  // this Live ip address
  //static const String baseUrl = "http://10.10.7.26:5002";  // this local ip address
  // static const String baseUrl = "http://10.10.7.26:5000";  // this local ip address
  // static const String baseUrl = "https://fahim_hasan5000.binarybards.online";  // this local ip address
  static const String apiVersion = "/api/v1";

  static const String socketUrl = baseUrl;

  static const String signUpSendEmailOtp = "$apiVersion/auth/send-email-otp";
  static const String signUpSendPhoneOtp = "$apiVersion/auth/send-phone-otp";
  static const String signUpEmailVerifyOtp = "$apiVersion/auth/verify-otp";
  static const String resendOtp = "$apiVersion/auth/resend-otp";
  static const String completeProfile = "$apiVersion/auth/complete-profile";

  static const String login = "$apiVersion/auth/login";
  static const String enableBiometric = "$apiVersion/auth/enable-biometric";
  static const String biometricLogin = "$apiVersion/auth/biometric-login";

  static const String providerCalendar = "$apiVersion/provider";
  static const String postReview = "$apiVersion/review";
  static const String currentAppointment = "$apiVersion/appointment/current-appointment?status";
  static const String appointmentCreate = "$apiVersion/appointment/create";
  static const String appointmentMyAppointments = "$apiVersion/appointment/my-appointments/";
  static const String serviceGet = "$apiVersion/service/get-services";
  static const String popularProviders = "$apiVersion/provider/popular";
  static const String appointmentUpdate = "$apiVersion/appointment/update-status/";
  static const String providerStats = "$apiVersion/provider/";
  static const String userFcmToken = "$apiVersion/user/fcm-token"; // ✅ ADDED

  static const String walletPay = "$apiVersion/appointment/pay-with-wallet/";
  static const String myTransactions = "$apiVersion/transaction/my-transactions";
  static const String transactionInvoice = "$apiVersion/transaction/invoice/";
  static const String walletSend = "$apiVersion/wallet/send";
  static const String walletWithdraw = "$apiVersion/wallet/withdraw";
  static const String stripeAccount = "$apiVersion/stripe/account-status";
  static const String stripeAccountSession = "$apiVersion/stripe/account-link";
  static const String myWalletAvailableBalance = "$apiVersion/wallet/my-wallet";
  static const String createPaymentIntent = "$apiVersion/wallet/topup";
  static const String onlinePay = "$apiVersion/stripe/create-appointment-payment-intent/";
  static const String kycSession = "$apiVersion/kyc/didit-session";

  static const String CeatsChat = "$apiVersion/chat";
  static const String chatAdminSupport = "$apiVersion/chat/admin-support";
  static const String moneyRequestMessage = "$apiVersion/message";

  static const String getChat = "$apiVersion/chat";
  static const String getAdminSupportAll = "$apiVersion/chat/admin-support/all";
  static const String deleteChat = "$apiVersion/api/chat/";

  static const String notification = "$apiVersion/notification";
  static const String notificationCount = "$apiVersion/notification/unread-count";
  static const String message = "$apiVersion/message";

  static const String getMessage = "$apiVersion/message";
  static const String deleteMessage = "$apiVersion/message";
  static const String childServices = "$apiVersion/service/get-all-child-services";
  static const String userMe = "$apiVersion/user/me";
  static const String allProviderUser = "$apiVersion/user";
  static const String setting = "$apiVersion/setting";












  static const String bearerToken = "bearerToken";
}
