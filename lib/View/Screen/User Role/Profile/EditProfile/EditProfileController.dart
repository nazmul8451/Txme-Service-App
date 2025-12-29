import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../../service/api_url.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../Model/UserModel.dart';

class EditProfileController extends GetxController {
  /// ================= TEXT CONTROLLERS =================
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final postalController = TextEditingController();
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
  RxString selectedCountryName = "".obs;
  RxString phoneCode = "".obs;
  RxString selectedFlag = "".obs;

  /// ================= STATE =================
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  /// ================= COUNTRY HELPER =================
  Country? _findCountryByName(String name) {
    try {
      return CountryService()
          .getAll()
          .firstWhere(
            (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// ================= FETCH USER =================
  Future<void> fetchUserHeader() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final data = UserModel.fromJson(decoded['data']);

        user.value = data;

        /// ================= SET FORM VALUES =================
        nameController.text = data.fullName;
        addressController.text =
            data.residentialAddress?.address ?? "";
        postalController.text = data.postalAddress;
        residenceController.text = data.countryOfResidence;
        bioController.text = data.bio ?? "";

        /// ================= AUTO COUNTRY + FLAG =================
        final country = _findCountryByName(data.nationality);

        if (country != null) {
          selectedCountryName.value = country.name;
          selectedFlag.value = country.flagEmoji;
          phoneCode.value = "+${country.phoneCode}";
        } else {
          /// fallback (unknown country name)
          selectedCountryName.value = data.nationality;
          selectedFlag.value = "🏳️";
          phoneCode.value = "";
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserHeader();
  }

  /// ================= COUNTRY PICKER =================
  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
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
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }

  /// ================= UPDATE PROFILE =================
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
        "nationality": selectedCountryName.value,
        "countryOfResidence": residenceController.text.trim(),
        "postalAddress": postalController.text.trim(),
        "residentialAddress": {
          "address": addressController.text.trim(),
          "latitude": latitude,
          "longitude": longitude,
        },
        "bio": bioController.text.trim(),
      };

      request.fields["data"] = jsonEncode(data);

      /// IMAGE OPTIONAL
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
        fetchUserHeader();
      } else {
        Get.snackbar("Error", body);
      }
    } catch (e) {
      Get.snackbar("Error", "Profile update failed");
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    postalController.dispose();
    residenceController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
