import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'ProfessionModel.dart';

class Editprofileprofessioncontroller extends GetxController {

  /// ================= TEXT CONTROLLERS =================
  final serviceNameController = TextEditingController();
  final expertInController = TextEditingController();
  final languageController = TextEditingController();
  final rateController = TextEditingController();
  final workiDurationController = TextEditingController();
  final designationController = TextEditingController();
  final skillsController = TextEditingController();

  /// ================= SERVICES =================
  final services = <ChildServiceModel>[].obs;
  final selectedServices = <ChildServiceModel>[].obs;
  final isServiceLoading = false.obs;

  void toggleService(ChildServiceModel service) {
    selectedServices.contains(service)
        ? selectedServices.remove(service)
        : selectedServices.add(service);

    serviceNameController.text =
        selectedServices.map((e) => e.name).join(", ");
  }

  /// ================= LANGUAGES =================
  final List<String> allLanguages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Arabic",
    "Bengali",
    "Hindi",
    "Portuguese",
    "Russian",
    "Japanese",
    "Albanian",
    "Armenian",
    "Azerbaijani",
    "Belarusian",
    "Bosnian",
    "Bulgarian",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "Estonian",
    "Finnish",
    "Georgian",
    "Greek",
    "Hungarian",
    "Icelandic",
    "Irish",
    "Italian",
    "Kazakh",
    "Latvian",
    "Lithuanian",
    "Luxembourgish",
    "Macedonian",
    "Maltese",
    "Moldovan",
    "Montenegrin",
    "Norwegian",
    "Polish",
    "Romanian",
    "Serbian",
    "Slovak",
    "Slovenian",
    "Swedish",
    "Turkish",
    "Ukrainian",
  ];

  final RxList<String> selectedLanguages = <String>[].obs;

  void toggleLanguage(String lang) {
    selectedLanguages.contains(lang)
        ? selectedLanguages.remove(lang)
        : selectedLanguages.add(lang);

    languageController.text = selectedLanguages.join(", ");
  }

  /// ================= WEEK DAYS =================
  final List<String> weekDays = const [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  final RxList<String> selectedWorkingDays = <String>[].obs;

  void toggleWorkingDay(String day) {
    selectedWorkingDays.contains(day)
        ? selectedWorkingDays.remove(day)
        : selectedWorkingDays.add(day);
  }

  /// ================= UI TEXT =================
  String get unavailableDatesText {
    if (unavailableDates.isEmpty) {
      return "Select unavailable dates";
    }

    return unavailableDates
        .map((e) =>
    "${e.day.toString().padLeft(2, '0')}/"
        "${e.month.toString().padLeft(2, '0')}/"
        "${e.year}")
        .join(", ");
  }


  /// ================= CALENDAR =================
  RxBool isCalendarOpen = false.obs;
  RxList<DateTime> unavailableDates = <DateTime>[].obs;

  void toggleCalendar() => isCalendarOpen.toggle();

  void toggleDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    unavailableDates.any((e) =>
    e.year == d.year && e.month == d.month && e.day == d.day)
        ? unavailableDates.removeWhere((e) =>
    e.year == d.year && e.month == d.month && e.day == d.day)
        : unavailableDates.add(d);
  }

  bool isSelected(DateTime day) {
    return unavailableDates.any(
            (d) => d.year == day.year && d.month == day.month && d.day == day.day);
  }

  List<String> get unavailableDatesForApi =>
      unavailableDates.map((e) => e.toIso8601String().split('T').first).toList();

  /// ================= TIME =================
  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 18, minute: 0);

  Future<void> pickTime(BuildContext context, bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? fromTime : toTime,
    );
    if (picked != null) {
      isFrom ? fromTime = picked : toTime = picked;
      update();
    }
  }

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  /// ================= ERRORS =================
  String? serviceNameError;
  String? languageError;
  String? designation;
  String? rateError;
  String? timeError;
  String? skills;

  bool validate() {
    serviceNameError =
    selectedServices.isEmpty ? "Service required" : null;

    languageError =
    selectedLanguages.isEmpty ? "Language required" : null;

    designation =
    designationController.text.isEmpty ? "Designation required" : null;

    skills =
    skillsController.text.isEmpty ? "Skills required" : null;

    rateError =
    rateController.text.isEmpty ? "Rate required" : null;

    timeError = fromTime == toTime ? "Invalid service time" : null;

    update();

    return serviceNameError == null &&
        languageError == null &&
        designation == null &&
        skills == null &&
        rateError == null &&
        timeError == null;
  }


  /// ================= API =================
  Future<void> getChildServices() async {
    try {
      isServiceLoading(true);
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.childServices),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        services.value = (decoded['data'] as List)
            .map((e) => ChildServiceModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isServiceLoading(false);
    }
  }



  Future<void> fetchProfessionProfile() async {
    try {
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final provider = decoded['data']['providerProfile'];

        if (provider == null) return;

        /// ================= SET TEXT FIELDS =================
        designationController.text = provider['designation'] ?? "";
        workiDurationController.text =
            provider['workingHours']?['duration']?.toString() ?? "";
        rateController.text = provider['hourlyRate']?.toString() ?? "";

        /// ================= SKILLS =================
        if (provider['skills'] != null && provider['skills'].isNotEmpty) {
          skillsController.text = provider['skills'].join(", ");
        }

        /// ================= SERVICES =================
        if (provider['serviceCategory'] != null) {
          selectedServices.clear();

          for (final s in provider['serviceCategory']) {
            final match =
            services.firstWhereOrNull((e) => e.name == s);
            if (match != null) selectedServices.add(match);
          }

          serviceNameController.text =
              selectedServices.map((e) => e.name).join(", ");
        }

        /// ================= LANGUAGES =================
        if (provider['languages'] != null) {
          selectedLanguages.value =
          List<String>.from(provider['languages']);

          languageController.text = selectedLanguages.join(", ");
        }

        /// ================= WORKING DAYS =================
        if (provider['workingDays'] != null) {
          selectedWorkingDays.value =
          List<String>.from(provider['workingDays']);
        }

        /// ================= WORKING HOURS =================
        final start = provider['workingHours']?['startTime'];
        final end = provider['workingHours']?['endTime'];

        if (start != null) {
          final sp = start.split(":");
          fromTime = TimeOfDay(
              hour: int.parse(sp[0]), minute: int.parse(sp[1]));
        }

        if (end != null) {
          final ep = end.split(":");
          toTime = TimeOfDay(
              hour: int.parse(ep[0]), minute: int.parse(ep[1]));
        }

        /// ================= UNAVAILABLE DATES =================
        if (provider['unavailableDates'] != null) {
          unavailableDates.value = (provider['unavailableDates'] as List)
              .map((e) => DateTime.parse(e))
              .toList();
        }

        update();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }




  Future<void> submitProfile() async {
    debugPrint("🔥 submitProfile called");

    if (!validate()) {
      Get.snackbar("", "Validation failed");
      return;
    }

    try {
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "User not authenticated");
        return;
      } else {
        debugPrint("✅ TOKEN FOUND => $token");
      }

      ///  CORRECT BODY STRUCTURE
      final Map<String, dynamic> body = {
        "providerProfile": {
          "designation": designationController.text,
          "skills": [skillsController.text],
          "serviceCategory": selectedServices.map((e) => e.name).toList(),

          "workingHours": {
            "startTime": _formatTime(fromTime),
            "endTime": _formatTime(toTime),
            "duration": int.tryParse(workiDurationController.text) ?? 0,
          },

          "workingDays": selectedWorkingDays,

          if (unavailableDates.isNotEmpty)
            "unavailableDates": unavailableDates
                .map((e) => e.toIso8601String())
                .toList(),

          "hourlyRate": int.tryParse(rateController.text) ?? 0,

          "languages": selectedLanguages,
        }
      };


      debugPrint("BODY => ${jsonEncode(body)}");


      final res = await http.patch(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.completeProfile),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("STATUS => ${res.statusCode}");
      debugPrint("RESPONSE => ${res.body}");


      final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : {};

      if (res.statusCode == 200 || res.statusCode == 201) {

        print(jsonEncode(decoded)); // debugPrint না

        Get.snackbar("Success", decoded["message"] ?? "Profile updated");

        // GetStorage().write("providerProfile", decoded["data"]);

        Get.offAllNamed(AppRoute.providerHomeScreen);
      } else {
        Get.snackbar("Try Again", decoded["message"] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("$e", e.toString());
      debugPrint("EXCEPTION => $e");
    }
  }


  @override
  void onInit() {
    super.onInit();

    getChildServices().then((_) {
      fetchProfessionProfile(); // 🔥 service load হওয়ার পরে
    });
  }

}
