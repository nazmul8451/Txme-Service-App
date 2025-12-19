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

  /// ================= RX VALUES =================
  final selectedDate = Rxn<DateTime>();
  final selectedGender = RxnString();     // male / female
  final selectedID = RxnString();         // passport / nid
  final selectedMarital = RxnString();    // married / unmarried

  /// ================= FILES =================
  var profileImage = Rxn<File>();
  final List<File> idDocuments = [];
  final List<File> addressDocuments = [];

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

  /// ================= DATE PICKER =================
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
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

  /// ================= COMPLETE PROFILE API =================
  Future<void> submitCompleteProfile() async {
    final accessToken =
    await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (accessToken.isEmpty) {
      Get.snackbar("Error", "Unauthorized");
      return;
    }

    if (profileImage.value == null) {
      Get.snackbar("Error", "Profile image required");
      return;
    }

    final uri =
    Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");

    final request = http.MultipartRequest("PATCH", uri);

    /// 🔐 HEADER
    request.headers['Authorization'] = "Bearer $accessToken";

    /// 🧠 JSON DATA (Postman same)
    final Map<String, dynamic> data = {
      "fullName": nameController.text.trim(),
      "dateOfBirth": selectedDate.value
          ?.toIso8601String()
          .split("T")
          .first,
      "gender": selectedGender.value,
      "nationality": nationalityController.text.trim(),
      "countryOfResidence": residenceController.text.trim(),
      "residentialAddress": {
        "address": addressController.text.trim(),
      },
      "postalAddress": postalController.text.trim(),
      "identification": {
        "type": selectedID.value,
        "value": idNumberController.text.trim(),
      },
      "maritalStatus": selectedMarital.value,
    };

    request.fields['data'] = jsonEncode(data);

    /// 📸 PROFILE IMAGE
    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        profileImage.value!.path,
      ),
    );


    /// 🚀 SEND
    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "Profile completed successfully");
      Get.offAllNamed(AppRoute.verifyyouridentity);
    } else {
      Get.snackbar("Error", body);
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
