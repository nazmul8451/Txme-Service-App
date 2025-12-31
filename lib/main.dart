import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:txme_app/service/api_client.dart';
import 'package:txme_app/service/socket_service.dart';

import 'Language/translator.dart';
import 'View/Screen/splashScreen/splash_screen_view.dart';
import 'core/App_Routes/app_routes.dart';
import 'core/dependency_injection/dependencies.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///  GetStorage init
  await GetStorage.init();

  ///  Stripe init
   //  তোমার Stripe publishable key
  Stripe.publishableKey =
  "pk_test_51S4W0lGhgUPSwjlABGmNej51c3D22QxSkMG6k4RC3rsR8lZcdLRGMzmSWmYEIhF5vT70ps9pzwcbVAmXGledP6pz00vlcvZLcV";
   await Stripe.instance.applySettings();

  Get.put<ApiClient>(ApiClient(), permanent: true);

  final socketApi = Get.put<SocketApi>(SocketApi(), permanent: true);
  await socketApi.init();

  /// GetX dependencies initialized here
  Dependencies.init();

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
