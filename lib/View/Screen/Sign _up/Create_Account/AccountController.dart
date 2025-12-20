import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:txme_app/service/api_url.dart';
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

class AccountController extends GetxController {
  /// ================= TEXT CONTROLLERS =================
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final nationalityController = TextEditingController();
  final residenceController = TextEditingController();
  final addressController = TextEditingController();
  final postalController = TextEditingController();
  final idNumberController = TextEditingController();
  final genderController = TextEditingController();
  final iDController = TextEditingController();
  final maritalController = TextEditingController();

  /// ================= RX =================
  final selectedDate = Rxn<DateTime>();
  final selectedGender = RxnString();
  final selectedID = RxnString();
  final selectedMarital = RxnString();
  final idFront = Rxn<File>();
  final idBack = Rxn<File>();
  final addressDoc = Rxn<File>();


  /// ================= IMAGE =================
  final profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  /// ================= CAMERA =================
  Future<void> openCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  /// ================= DATE =================
  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  /// ================= GENDER =================
  Future<void> selectGender(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Select Gender"),
        children: [
          SimpleDialogOption(
            child: const Text("Male"),
            onPressed: () => Get.back(result: "male"),
          ),
          SimpleDialogOption(
            child: const Text("Female"),
            onPressed: () => Get.back(result: "female"),
          ),
        ],
      ),
    );

    if (result != null) {
      selectedGender.value = result;
      genderController.text = result.capitalizeFirst!;
    }
  }

  /// ================= ID TYPE =================
  Future<void> selectID(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Select ID"),
        children: [
          SimpleDialogOption(
            child: const Text("NID"),
            onPressed: () => Get.back(result: "nid"),
          ),
          SimpleDialogOption(
            child: const Text("Passport"),
            onPressed: () => Get.back(result: "passport"),
          ),
        ],
      ),
    );

    if (result != null) {
      selectedID.value = result;
      iDController.text = result.toUpperCase();
    }
  }

  /// ================= MARITAL =================
  Future<void> selectMarital(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Marital Status"),
        children: [
          SimpleDialogOption(
            child: const Text("Married"),
            onPressed: () => Get.back(result: "married"),
          ),
          SimpleDialogOption(
            child: const Text("Unmarried"),
            onPressed: () => Get.back(result: "unmarried"),
          ),
        ],
      ),
    );

    if (result != null) {
      selectedMarital.value = result;
      maritalController.text = result.capitalizeFirst!;
    }
  }

  /// ================= SUBMIT PROFILE =================
  Future<void> submitCompleteProfile() async {
    final token =
    await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (token.isEmpty) {
      Get.snackbar("Error", "Unauthorized");
      return;
    }

    final uri =
    Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");

    final request = http.MultipartRequest("PATCH", uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    /// ================= FULL DATA =================
    final Map<String, dynamic> data = {
      "fullName": nameController.text.trim(),
      "dateOfBirth": dobController.text.trim(),
      "gender": selectedGender.value,
      "nationality": nationalityController.text.trim(),
      "countryOfResidence": residenceController.text.trim(),

      "residentialAddress": {
        "address": addressController.text.trim(),
        "latitude": 23.8103,
        "longitude": 90.4125,
      },

      "postalAddress": postalController.text.trim(),

      "identification": {
        "type": selectedID.value,
        "value": idNumberController.text.trim(),
      },

      "maritalStatus": selectedMarital.value,

      "providerProfile": {
        "serviceCategory": ["plumber", "electrician"],
        "workingHours": {
          "startTime": "09:00",
          "endTime": "18:00",
          "duration": 120,
          "workingDays": ["mon", "tue", "wed", "thu", "fri"],
        },
        "pricePerSlot": 500,
        "bio": "Experienced service provider",
        "experience": 5,
        "skills": ["pipe fitting", "electrical wiring"],
      }
    };

    request.fields['data'] = jsonEncode(data);

    /// ================= PROFILE IMAGE (optional) =================
    if (profileImage.value != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          profileImage.value!.path,
        ),
      );
    }

    /// ================= ID DOCUMENTS =================
    if (idFront.value != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "idDocuments",
          idFront.value!.path,
        ),
      );
    }

    if (idBack.value != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "idDocuments",
          idBack.value!.path,
        ),
      );
    }

    /// ================= ADDRESS DOCUMENT =================
    if (addressDoc.value != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "addressDocuments",
          addressDoc.value!.path,
        ),
      );
    }

    /// ================= SEND =================
    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Profile completed");
        Get.offAllNamed(AppRoute.faceIDSetupScreen);
      } else {
        Get.snackbar("Error", body);
      }
    } catch (e) {
      print("UPLOAD ERROR => $e");
      Get.snackbar("Error", e.toString());
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    nationalityController.dispose();
    residenceController.dispose();
    addressController.dispose();
    postalController.dispose();
    idNumberController.dispose();
    genderController.dispose();
    iDController.dispose();
    maritalController.dispose();
    super.onClose();
  }
}
