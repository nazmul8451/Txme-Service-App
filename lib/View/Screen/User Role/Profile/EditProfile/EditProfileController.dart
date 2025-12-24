import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../../service/api_url.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';

class EditProfileController extends GetxController {

  /// ================= CONTROLLERS =================
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final postalController = TextEditingController();
  final nationalityController = TextEditingController();
  final residenceController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  /// ================= IMAGE =================
  Rxn<File> profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  /// ================= LOCATION =================
  double? latitude;
  double? longitude;

  /// ================= COUNTRY =================

  RxString selectedCountryName = "Netherlands".obs;
  RxString phoneCode = "+31".obs;
  RxString selectedFlag = "🇳🇱".obs;



  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showWorldWide: true,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 420,
        borderRadius: BorderRadius.circular(12),
        inputDecoration: InputDecoration(
          hintText: "Search country",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onSelect: (Country country) {
        selectedCountryName.value = country.name;
        phoneCode.value = "+${country.phoneCode}";
        selectedFlag.value = country.flagEmoji;


      },
    );
  }




  /// ================= PICK IMAGE =================
  Future<void> pickProfileImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  /// ================= LOCATION =================
  Future<void> getLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  /// ================= UPDATE PROFILE ( SAME AS COMPLETE PROFILE) =================
  Future<void> updateProfile() async {
    try {
      await getLocation();

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final uri =
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");

      final request = http.MultipartRequest("PATCH", uri);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      final Map<String, dynamic> data = {
        "fullName": nameController.text.trim(),
        "nationality": nationalityController.text.trim(),
        "countryOfResidence": residenceController.text.trim(),
        "postalAddress": postalController.text.trim(),
        "residentialAddress": {
          "address": addressController.text.trim(),
          "latitude": latitude,
          "longitude": longitude,
        },
      };

      request.fields["data"] = jsonEncode(data);

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            profileImage.value!.path,
            contentType: MediaType.parse("image/jpeg"),
          ),
        );
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Error", body);
      }
    } catch (e) {
      Get.snackbar("Error", "Profile update failed");
    }
  }
}
