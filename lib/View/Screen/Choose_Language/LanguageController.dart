import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../helper/Shared_prefe/shared_prefe.dart' show SharePrefsHelper;


class LanguageController extends GetxController {

  final Rx<Locale> selectedLocale = const Locale('en', 'US').obs;

  final Map<String, Locale> languagesMap = {
    "English": const Locale('en', 'US'),
    "German": const Locale('de', 'DE'),
    "Dutch": const Locale('nl', 'NL'),
    "French": const Locale('fr', 'FR'),
  };

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> changeLanguage(String lang) async {
    final locale = languagesMap[lang]!;

    selectedLocale.value = locale;
    Get.updateLocale(locale);

    await SharePrefsHelper.setString(
      SharePrefsHelper.language,
      lang,
    );

    await SharePrefsHelper.setBool(
      SharePrefsHelper.languageSelected,
      true,
    );
  }


  /// Load saved language
  Future<void> _loadSavedLanguage() async {
    final savedLang =
    await SharePrefsHelper.getString(SharePrefsHelper.language);

    if (savedLang.isNotEmpty && languagesMap.containsKey(savedLang)) {
      final locale = languagesMap[savedLang]!;
      selectedLocale.value = locale;
      Get.updateLocale(locale);

      debugPrint("🔁 LANGUAGE LOADED => $savedLang");
    }
  }
}

