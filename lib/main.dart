import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:txme_app/service/api_client.dart';
import 'package:txme_app/service/socket_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:txme_app/service/settings_service.dart';
import 'Language/translator.dart';
import 'View/Screen/splashScreen/splash_screen_view.dart';
import 'core/App_Routes/app_routes.dart';
import 'core/dependency_injection/dependencies.dart';
import 'helper/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase FIRST
  await Firebase.initializeApp();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize API Client
  Get.put<ApiClient>(ApiClient(), permanent: true);

  // Initialize Socket
  final socketApi = Get.put<SocketApi>(SocketApi(), permanent: true);
  await socketApi.init();

  // Initialize and fetch settings
  final settingsService = Get.put(SettingsService(), permanent: true);
  await settingsService.fetchSettings();

  // Initialize dependencies
  Dependencies.init();

  // ✅ Initialize Stripe
  Stripe.publishableKey =
  "pk_test_51S4W0lGhgUPSwjlABGmNej51c3D22QxSkMG6k4RC3rsR8lZcdLRGMzmSWmYEIhF5vT70ps9pzwcbVAmXGledP6pz00vlcvZLcV";
  await Stripe.instance.applySettings();

  // ✅ Initialize Firebase Notifications (AFTER Firebase.initializeApp())
  try {
    await FirebaseApi().initNotifications();
    debugPrint("✅ Firebase notifications initialized successfully");
  } catch (e) {
    debugPrint("❌ Error initializing Firebase notifications: $e");
  }

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