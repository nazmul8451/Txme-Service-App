import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:txme_app/View/Screen/Service%20Provider%20Role/MyBooking/MyBookingPage/ProviderBookingsPage.dart';
import '../../View/Screen/Chats/ChatsPage.dart';
import '../../View/Screen/Chats/view/chat_home_page.dart';
import '../../View/Screen/Choose_Language/LanguagePage.dart';
import '../../View/Screen/Service Provider Role/Contactsupport/Contactsupport.dart';
import '../../View/Screen/Service Provider Role/HomePage/ProviderHomeScreen.dart';
import '../../View/Screen/Service Provider Role/MyBooking/CancelBooking/CancelBooking.dart';
import '../../View/Screen/Service Provider Role/MyBooking/ConfirmPayment/ConfirmPayment.dart';
import '../../View/Screen/Service Provider Role/MyBooking/NewBookingRequest/NewBookingRequest.dart';
import '../../View/Screen/Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import '../../View/Screen/Service Provider Role/MyBooking/ProviderJobProgressPage/ProviderJobProgressPage.dart';
import '../../View/Screen/Service Provider Role/MyBooking/ProviderTotalDuration/ProviderTotalDuration.dart';
import '../../View/Screen/Service Provider Role/Provider Profile/ProviderProfile.dart';
import '../../View/Screen/Sign _up/Create_Account/CreateAccount.dart';
import '../../View/Screen/Sign _up/FaceIDSetupScreen/FaceIDSetupScreen.dart';
import '../../View/Screen/Sign _up/FaceIDSetupScreen/FaceIDSetupScreen2.dart';
import '../../View/Screen/Sign _up/FaceIDSetupScreen/SignUpDone.dart';
import '../../View/Screen/Sign _up/Sign_Up_Email/Sign_up_Email.dart';
import '../../View/Screen/Sign _up/Sign_Up_Phone/Sign_Up_Phone.dart';
import '../../View/Screen/Sign _up/VerifyYourIdentity/UploadDocuments1/UploadDocuments1.dart';
import '../../View/Screen/Sign _up/VerifyYourIdentity/UploadDocuments2/UploadDocuments2.dart';
import '../../View/Screen/Sign _up/VerifyYourIdentity/VerifyYourIdentity.dart';
import '../../View/Screen/Sign _up/Verifyotppage/Verifyotppage.dart';
import '../../View/Screen/Sign-in/Done/SignInDone.dart';
import '../../View/Screen/Sign-in/Sign-in-with-Biometrics/Enter_email/enter_email.dart';
import '../../View/Screen/Sign-in/Sign-in-with-Biometrics/SignInWithBiometrics.dart';
import '../../View/Screen/Sign-in/Sign-in-with-Biometrics/Verify-Fingerprint/verifyFingerprint.dart';
import '../../View/Screen/Sign-in/Sign-in-with-Biometrics/VerifyFaceID/Face_Verification_Done/faceVerificationDone.dart';
import '../../View/Screen/Sign-in/Sign-in-with-Biometrics/VerifyFaceID/VerifyfaceidID.dart';
import '../../View/Screen/Sign_As_Screen/sign_as_screen.dart';
import '../../View/Screen/User Role/BookingsViewClient/Bookings/Request Sent/RequestSent.dart';
import '../../View/Screen/User Role/BookingsViewClient/BookingsPage.dart';
import '../../View/Screen/User Role/BookingsViewClient/JobStartedPage/JobProgressPage/JobProgressPage.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/Invoice/Invoice.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/Onlinepayment/Onlinepayment.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PayWithCash/PayWithCash.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaymentPage.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaymentSuccessful/PaymentSuccessful.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaywithWallet/PaywithWallet.dart';
import '../../View/Screen/User Role/BookingsViewClient/TotalDuration/TotalDuration.dart';
import '../../View/Screen/User Role/Home_Page/AppoinmentScreen/AppoinmentScreen.dart';
import '../../View/Screen/User Role/Home_Page/ElectricianProviders/ElectricianProviders.dart';
import '../../View/Screen/User Role/Home_Page/NotificationPage/NotificationPage.dart';
import '../../View/Screen/User Role/Home_Page/Popularservices/Popularservices.dart';
import '../../View/Screen/User Role/Home_Page/SearchFilter/SearchFilter.dart';
import '../../View/Screen/User Role/Home_Page/homePage.dart';
import '../../View/Screen/User Role/Profile/MyProfile.dart';
import '../../View/Screen/Wallet/PaymentDone/PaymentDone.dart';
import '../../View/Screen/Wallet/Request/RequestPage.dart';
import '../../View/Screen/Wallet/Send/SendPage.dart';
import '../../View/Screen/Wallet/Top_up/TopUpPage.dart';
import '../../View/Screen/Wallet/TransactionFailed/TransactionFailed.dart';
import '../../View/Screen/Wallet/WalletPage.dart';
import '../../View/Screen/Wallet/WalletPayPalSelectPaymentMethod/WalletPayPalSelectPaymentMethod.dart';
import '../../View/Screen/Wallet/Withdraw/WithdrawPage.dart';

class AppRoute {
  ///==================== Initial Routes ====================///
  static const String signAsScreen = "/signAsScreen";
  static const String signinwithbiometrics = "/signinwithbiometrics";
  static const String verifyfingerprint = "/verifyfingerprint";
  static const String enterEmail = "/enterEmail";
  static const String verifyfaceid = "/verifyfaceid";
  static const String verifyFaceId = "/verifyFaceId";
  static const String faceverificationdone = "/faceverificationdone";
  static const String verifyotppage = "/verifyotppage";
  static const String homepage = "/homepage";
  static const String signUpEmail = "/signUpEmail";
  static const String verifyotppageS = "/verifyotppageS";
  static const String signUpPhone = "/signUpPhone";
  static const String createaccount = "/createaccount";
  static const String faceIDSetupScreen = "/faceIDSetupScreen";
  static const String faceIDSetupScreen2 = "/faceIDSetupScreen2";
  static const String signUPdone = "/signupdone";
  static const String signindone = "/signindone";
  static const String verifyyouridentity = "/verifyyouridentity";
  static const String uploaddocuments1 = "/uploaddocuments1";
  static const String uploaddocuments2 = "/uploaddocuments2";
  static const String searchfilter = "/searchfilter";
  static const String languagepage = "/languagepage";
  static const String electricianproviders = "/electricianproviders";
  static const String popularservices = "/popularservices";
  static const String notificationPage = "/notificationPage";
  static const String appointmentsPage = "/appointmentsPage";
  static const String profilePage = "/profilePage";
  static const String messagepage = "/messagepage";
  static const String bookingspage = "/bookingspage";
  static const String providerProfilePage = "/providerProfilePage";
  static const String providerHomeScreen = "/providerHomeScreen";
  static const String requestSent = "/requestSent";
  static const String myBookingsPage = "/myBookingsPage";
  static const String jobPage = "/jobPage";
  static const String totalduration = "/totalduration";
  static const String paymentpage = "/paymentpage";
  static const String onlinepayment = "/onlinepayment";
  static const String paymentsuccessful = "/paymentsuccessful";
  static const String invoicePListPage = "/invoicePListPage";
  static const String paywithcash = "/paywithcash";
  static const String paywithwallet = "/paywithwallet";
  static const String providerMyBookingsPage = "/providerMyBookingsPage";
  static const String newbookingrequest = "/newbookingrequest";
  static const String cancelbooking = "/cancelbooking";
  static const String providerjobprogresspage = "/providerjobprogresspage";
  static const String providertotalduration = "/providertotalduration";
  static const String confirmPaymentpage = "/confirmPaymentpage";
  static const String providerpaymentsuccessful = "/providerpaymentsuccessful";
  static const String contactsupport = "/contactsupport";
  static const String chatspage = "/chatspage";
  static const String walletpage = "/walletpage";
  static const String topuppage = "/topuppage";
  static const String paymentdone = "/paymentdone";
  static const String walletpaypalselectpaymentmethod = "/walletpaypalselectpaymentmethod";
  static const String transactionfailed = "/transactionfailed";
  static const String sendpage = "/sendpage";
  static const String requestpage = "/requestpage";
  static const String withdrawpage = "/withdrawpage";



  static List<GetPage> routes = [
    ///==================== Authentication  Routes ====================///

    GetPage(name: signAsScreen, page: () => const SignAsScreen()),
    GetPage(name: signinwithbiometrics, page: () =>  SigninWithBiometrics()),
    GetPage(name: verifyfingerprint, page: () =>  Verifyfingerprint()),
    GetPage(name: enterEmail, page: () =>  EnterEmail()),
   // GetPage(name: verifyfaceid, page: () => const Verifyfaceid()),
    GetPage(name: verifyFaceId, page: () =>  VerifyFaceId()),
    GetPage(name: faceverificationdone, page: () => const Faceverificationdone()),
    //GetPage(name: verifyotppage, page: () =>  Verifyotppage()),
    GetPage(name: homepage, page: () => const Homepage()),
    GetPage(name: signUpEmail, page: () => const SignUpEmail()),
    GetPage(name: verifyotppageS, page: () => const VerifyotppageS()),
    GetPage(name: signUpPhone, page: () => const SignUpPhone()),
    GetPage(name: createaccount, page: () =>  CreateAccountScreen()),
    GetPage(name: faceIDSetupScreen, page: () =>  FaceIDSetupScreen()),
    GetPage(name: faceIDSetupScreen2, page: () =>  FaceIDSetupScreen2()),
    GetPage(name: signUPdone, page: () =>  Signupdone()),
    GetPage(name: signindone, page: () =>  Signindone()),
    GetPage(name: verifyyouridentity, page: () =>  Verifyyouridentity()),
    GetPage(name: uploaddocuments1, page: () =>  Uploaddocuments1()),
    GetPage(name: uploaddocuments2, page: () =>  Uploaddocuments2()),
    GetPage(name: searchfilter, page: () =>  Searchfilter()),
    GetPage(name: searchfilter, page: () =>  Searchfilter()),
    GetPage(name: languagepage, page: () =>  Languagepage()),
    GetPage(name: electricianproviders, page: () =>  Electricianproviders()),
    GetPage(name: popularservices, page: () =>  Popularservices()),
    GetPage(name: notificationPage, page: () =>  NotificationPage()),
    GetPage(name: appointmentsPage, page: () =>  AppointmentsPage()),
    GetPage(name: profilePage, page: () =>  ProfilePage()),
    //GetPage(name: messagepage, page: () =>  Messagepage()),
    GetPage(name: requestSent, page: () =>  RequestSent()), ///Request Page
    GetPage(name: providerProfilePage, page: () =>  ProviderProfilePage()),
    GetPage(name: providerHomeScreen, page: () =>  ProviderHomeScreen()),
    GetPage(name: myBookingsPage, page: () =>  MyBookingsPage()),
    GetPage(name: jobPage, page: () =>  JobPage()),
    GetPage(name: totalduration, page: () =>  Totalduration()),
    GetPage(name: paymentpage, page: () =>  Paymentpage()),
    GetPage(name: onlinepayment, page: () =>  Onlinepayment()),
    GetPage(name: paymentsuccessful, page: () =>  Paymentsuccessful()),
    GetPage(name: invoicePListPage, page: () =>  InvoicePListPage()),
    GetPage(name: paywithcash, page: () =>  Paywithcash()),
    GetPage(name: paywithwallet, page: () =>  Paywithwallet()),
    GetPage(name: providerMyBookingsPage, page: () =>  ProviderMyBookingsPageUI()),
    GetPage(name: newbookingrequest, page: () =>  Newbookingrequest()),
    GetPage(name: cancelbooking, page: () =>  Cancelbooking()),
    GetPage(name: providerjobprogresspage, page: () =>  Providerjobprogresspage()),
    GetPage(name: providertotalduration, page: () =>  Providertotalduration()),
    GetPage(name: confirmPaymentpage, page: () =>  ConfirmPaymentpage()),
    GetPage(name: providerpaymentsuccessful, page: () =>  Providerpaymentsuccessful()),
    GetPage(name: contactsupport, page: () =>  ContactSupport()),
    GetPage(name: chatspage, page: () =>  ChatHomePage()),
    GetPage(name: walletpage, page: () =>  Walletpage()),
    GetPage(name: topuppage, page: () =>  Topuppage()),
    GetPage(name: walletpaypalselectpaymentmethod, page: () =>  Walletpaypalselectpaymentmethod()),
    GetPage(name: paymentdone, page: () =>  Paymentdone()),
    GetPage(name: transactionfailed, page: () =>  Transactionfailed()),
    GetPage(name: sendpage, page: () =>  Sendpage()),
    GetPage(name: requestpage, page: () =>  Requestpage()),
    GetPage(name: withdrawpage, page: () =>  Withdrawpage()),








  ];
}