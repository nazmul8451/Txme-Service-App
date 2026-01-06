// import 'dart:convert';
// import 'dart:io';
// import 'package:http_parser/http_parser.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:txme_app/service/api_url.dart';
// import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
// import 'package:txme_app/core/App_Routes/app_routes.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:url_launcher/url_launcher.dart'; // ✅ ADDED
//
// class AccountController extends GetxController {
//   /// ================= TEXT CONTROLLERS =================
//   final nameController = TextEditingController();
//   final dobController = TextEditingController();
//   final nationalityController = TextEditingController();
//   final residenceController = TextEditingController();
//   final addressController = TextEditingController();
//   final postalController = TextEditingController();
//   final idNumberController = TextEditingController();
//   final genderController = TextEditingController();
//   final iDController = TextEditingController();
//   final maritalController = TextEditingController();
//
//   /// ================= RX VALUES =================
//   final selectedDate = Rxn<DateTime>();
//   final selectedGender = RxnString();     // male / female
//   final selectedID = RxnString();         // passport / nid
//   final selectedMarital = RxnString();    // married / unmarried
//
//   /// ================= FILES =================
//   var profileImage = Rxn<File>();
//   final List<File> idDocuments = [];
//   final List<File> addressDocuments = [];
//
//   final ImagePicker _picker = ImagePicker();
//
//   double? latitude;
//   double? longitude;
//
//   final isLoading = false.obs;
//
//
//   /// ================= CAMERA =================
//   Future<void> openCamera() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 85,
//     );
//
//     if (image != null) {
//       profileImage.value = File(image.path);
//     }
//   }
//
//
//   Future<void> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar("Error", "Location service disabled");
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar("Error", "Location permission denied forever");
//       return;
//     }
//
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     latitude = position.latitude;
//     longitude = position.longitude;
//   }
//
//
//   /// ================= DATE PICKER =================
//   Future<void> selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: Get.context!,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       selectedDate.value = picked;
//       dobController.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }
//
//   /// ================= GENDER =================
//   Future<void> selectGender(BuildContext context) async {
//     final result = await showDialog<String>(
//       context: context,
//       builder: (_) => SimpleDialog(
//         title: const Text("Select Gender"),
//         children: [
//           SimpleDialogOption(
//             child: const Text("Male"),
//             onPressed: () => Get.back(result: "male"),
//           ),
//           SimpleDialogOption(
//             child: const Text("Female"),
//             onPressed: () => Get.back(result: "female"),
//           ),
//         ],
//       ),
//     );
//
//     if (result != null) {
//       selectedGender.value = result;
//       genderController.text = result.capitalizeFirst!;
//     }
//   }
//
//   /// ================= ID TYPE =================
//   Future<void> selectID(BuildContext context) async {
//     final result = await showDialog<String>(
//       context: context,
//       builder: (_) => SimpleDialog(
//         title: const Text("Select ID"),
//         children: [
//           SimpleDialogOption(
//             child: const Text("NID"),
//             onPressed: () => Get.back(result: "nid"),
//           ),
//           SimpleDialogOption(
//             child: const Text("Passport"),
//             onPressed: () => Get.back(result: "passport"),
//           ),
//         ],
//       ),
//     );
//
//     if (result != null) {
//       selectedID.value = result;
//       iDController.text = result.toUpperCase();
//     }
//   }
//
//   /// ================= MARITAL =================
//   Future<void> selectMarital(BuildContext context) async {
//     final result = await showDialog<String>(
//       context: context,
//       builder: (_) => SimpleDialog(
//         title: const Text("Marital Status"),
//         children: [
//           SimpleDialogOption(
//             child: const Text("Married"),
//             onPressed: () => Get.back(result: "married"),
//           ),
//           SimpleDialogOption(
//             child: const Text("Unmarried"),
//             onPressed: () => Get.back(result: "unmarried"),
//           ),
//         ],
//       ),
//     );
//
//     if (result != null) {
//       selectedMarital.value = result;
//       maritalController.text = result.capitalizeFirst!;
//     }
//   }
//
//   /// ================= COMPLETE PROFILE API =================
//   Future<void> submitCompleteProfile() async {
//     if (isLoading.value) return; // 🔒 prevent double click
//
//     try {
//       isLoading(true);
//
//       await getCurrentLocation();
//
//       final accessToken = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
//
//       if (accessToken.isEmpty) {
//         Get.snackbar("Error", "Unauthorized");
//         return;
//       }
//
//       if (profileImage.value == null) {
//         Get.snackbar("Error", "Profile image required");
//         return;
//       }
//
//       final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");
//
//       final request = http.MultipartRequest("PATCH", uri);
//
//       /// HEADER
//       request.headers.addAll({
//         "Authorization": "Bearer $accessToken",
//         "Accept": "application/json",
//       });
//
//       /// JSON DATA
//       final Map<String, dynamic> data = {
//         "fullName": nameController.text.trim(),
//         "dateOfBirth": selectedDate.value?.toIso8601String().split("T").first,
//         "gender": selectedGender.value,
//         "nationality": nationalityController.text.trim(),
//         "countryOfResidence": residenceController.text.trim(),
//         "residentialAddress": {
//           "address": addressController.text.trim(),
//           "latitude": latitude ?? 23.8103,
//           "longitude": longitude ?? 90.4125,
//         },
//         "postalAddress": postalController.text.trim(),
//         "identification": {
//           "type": selectedID.value,
//           "value": idNumberController.text.trim(),
//         },
//         "maritalStatus": selectedMarital.value,
//       };
//
//       request.fields["data"] = jsonEncode(data);
//
//       /// IMAGE FILE
//       final imageFile = profileImage.value!;
//       final extension = imageFile.path.split('.').last.toLowerCase();
//
//       String mimeType = extension == "png" ? "image/png" : "image/jpeg";
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           "image",
//           imageFile.path,
//           filename: "profile.$extension",
//           contentType: MediaType.parse(mimeType),
//         ),
//       );
//
//       final response = await request.send();
//       final body = await response.stream.bytesToString();
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         await startKycProcess(); // ✅ UPDATED: Start KYC instead of navigating directly
//       } else {
//         Get.snackbar("", body);
//       }
//     } catch (e) {
//       debugPrint("❌ COMPLETE PROFILE ERROR => $e");
//       Get.snackbar("", "Server error, try again");
//     } finally {
//       isLoading(false); //  always stop loader
//     }
//   }
//
//   /// ================= KYC PROCESS =================
//   Future<void> startKycProcess() async {
//     try {
//       final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
//
//       final response = await http.post(
//         Uri.parse("${ApiConstant.baseUrl}${ApiConstant.kycSession}"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body)['data'];
//         final String? url = data?['url'];
//
//         if (url != null && await canLaunchUrl(Uri.parse(url))) {
//           await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//           // TODO: After KYC, you should probably navigate the user.
//           // For now, we'll go to the sign in done page as a placeholder.
//            _navigateToNextPage();
//         } else {
//           Get.snackbar("Error", "Could not launch KYC page.");
//         }
//       } else {
//         Get.snackbar("Error", "Could not start KYC process.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred during KYC.");
//     }
//   }
//
//   /// ================= POST-KYC NAVIGATION =================
//   Future<void> _navigateToNextPage() async {
//     final role = await SharePrefsHelper.getString(SharePrefsHelper.userRole);
//     if (role == "PROVIDER") {
//       Get.offAllNamed(AppRoute.profession);
//     } else if (role == "CUSTOMER") {
//       Get.offAllNamed(AppRoute.signindone);
//     } else {
//       Get.offAllNamed(AppRoute.signinwithbiometrics);
//     }
//   }
//
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     dobController.dispose();
//     nationalityController.dispose();
//     residenceController.dispose();
//     addressController.dispose();
//     postalController.dispose();
//     idNumberController.dispose();
//     genderController.dispose();
//     iDController.dispose();
//     maritalController.dispose();
//     super.onClose();
//   }
// }
