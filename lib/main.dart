import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:txme_app/service/api_client.dart';
import 'package:txme_app/service/socket_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:txme_app/service/settings_service.dart'; // ✅ ADDED
import 'Language/translator.dart';
import 'View/Screen/splashScreen/splash_screen_view.dart';
import 'core/App_Routes/app_routes.dart';
import 'core/dependency_injection/dependencies.dart';
import 'firebase_options.dart';
import 'helper/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  
  Get.put<ApiClient>(ApiClient(), permanent: true);
  final socketApi = Get.put<SocketApi>(SocketApi(), permanent: true);
  await socketApi.init();
  
  // ✅ ADDED: Initialize and fetch settings
  final settingsService = Get.put(SettingsService(), permanent: true);
  await settingsService.fetchSettings();

  Dependencies.init(); 

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Stripe.publishableKey =
      "pk_test_51S4W0lGhgUPSwjlABGmNej51c3D22QxSkMG6k4RC3rsR8lZcdLRGMzmSWmYEIhF5vT70ps9pzwcbVAmXGledP6pz00vlcvZLcV";
  await Stripe.instance.applySettings();

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale("en", "US"),
        fallbackLocale: const Locale('en', 'US'),
        translations: Language(),
        defaultTransition: Transition.fadeIn,
        getPages: AppRoute.routes,
        home: SplashScreenView(),
      ),
    );
  }
}
