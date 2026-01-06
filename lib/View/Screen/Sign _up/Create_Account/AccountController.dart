import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:txme_app/service/api_url.dart';
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

class AccountController extends GetxController {
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

  final selectedDate = Rxn<DateTime>();
  final selectedGender = RxnString();
  final selectedID = RxnString();
  final selectedMarital = RxnString();

  var profileImage = Rxn<File>();
  final List<File> idDocuments = [];
  final List<File> addressDocuments = [];

  final ImagePicker _picker = ImagePicker();

  double? latitude;
  double? longitude;

  final isLoading = false.obs;

  Future<void> openCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("", "Location service disabled");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("", "Location permission denied forever");
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }

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

  Future<void> submitCompleteProfile() async {
    if (isLoading.value) return;
    try {
      isLoading(true);
      await getCurrentLocation();
      final accessToken = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (accessToken.isEmpty) {
        Get.snackbar("", "Unauthorized");
        return;
      }
      if (profileImage.value == null) {
        Get.snackbar("", "Profile image required");
        return;
      }
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");
      final request = http.MultipartRequest("PATCH", uri);
      request.headers.addAll({
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      });
      final Map<String, dynamic> data = {
        "fullName": nameController.text.trim(),
        "dateOfBirth": selectedDate.value?.toIso8601String().split("T").first,
        "gender": selectedGender.value,
        "nationality": nationalityController.text.trim(),
        "countryOfResidence": residenceController.text.trim(),
        "residentialAddress": {
          "address": addressController.text.trim(),
          "latitude": latitude ?? 23.8103,
          "longitude": longitude ?? 90.4125,
        },
        "postalAddress": postalController.text.trim(),
        "identification": {
          "type": selectedID.value,
          "value": idNumberController.text.trim(),
        },
        "maritalStatus": selectedMarital.value,
      };
      request.fields["data"] = jsonEncode(data);
      final imageFile = profileImage.value!;
      final extension = imageFile.path.split('.').last.toLowerCase();
      String mimeType = extension == "png" ? "image/png" : "image/jpeg";
      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile.path,
          filename: "profile.$extension",
          contentType: MediaType.parse(mimeType),
        ),
      );
      final response = await request.send();
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(body);

        debugPrint(body);

        // ✅ FIXED: Correctly access tokens from the 'tokens' object
        if (decoded['data']?['tokens']?['accessToken'] != null) {
          final newAccessToken = decoded['data']['tokens']['accessToken'];
          await SharePrefsHelper.setString(SharePrefsHelper.bearerToken, newAccessToken);
          debugPrint("✅ New Access Token Saved: $newAccessToken");
        }
        if (decoded['data']?['tokens']?['refreshToken'] != null) {
          final newRefreshToken = decoded['data']['tokens']['refreshToken'];
          await SharePrefsHelper.setString(SharePrefsHelper.refreshToken, newRefreshToken);
          debugPrint("✅ New Refresh Token Saved: $newRefreshToken");
        }

        Get.snackbar("Success", "Profile completed successfully");
        _navigateToNextPage();
      } else {
        Get.snackbar("", body);
      }
    } catch (e) {
      debugPrint("❌ COMPLETE PROFILE ERROR => $e");
      Get.snackbar("", "Server error, try again");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _navigateToNextPage() async {
    final role = await SharePrefsHelper.getString(SharePrefsHelper.userRole);
    if (role == "PROVIDER") {
      Get.offAllNamed(AppRoute.profession);
    } else if (role == "CUSTOMER") {
      Get.offAllNamed(AppRoute.signindone);
    } else {
      Get.offAllNamed(AppRoute.signinwithbiometrics);
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
