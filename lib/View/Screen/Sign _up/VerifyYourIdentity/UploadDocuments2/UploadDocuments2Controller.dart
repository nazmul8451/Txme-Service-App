import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../../../core/App_Routes/app_routes.dart';

class CompleteProfileController extends GetxController {
  XFile? imageFile;

  final isUploading = false.obs;
  final ImagePicker picker = ImagePicker();

  /// 📸 OPEN CAMERA
  Future<void> openCamera() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked != null) {
      imageFile = picked;
      update();
    }
  }

  /// 🚀 UPLOAD SINGLE ID DOCUMENT
  Future<void> uploadImage() async {
    if (imageFile == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    if (isUploading.value) return;

    isUploading.value = true;

    try {
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      if (token.isEmpty) {
        Get.snackbar("Error", "Unauthorized");
        return;
      }

      final uri =
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.completeProfile}");

      final request = http.MultipartRequest("PATCH", uri);

      /// 🔐 HEADER
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      /// 🖼️ ID DOCUMENT (SINGLE)
      final file = imageFile!;
      final extension = file.path.split('.').last.toLowerCase();

      String mimeType = "image/jpeg";
      if (extension == "png") {
        mimeType = "image/png";
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          "idDocuments", // ✅ REQUIRED KEY
          file.path,
          filename: basename(file.path),
          contentType: MediaType.parse(mimeType),
        ),
      );

      /// 🪵 DEBUG
      debugPrint("📤 FILE => ${file.path}");

      final response = await request.send();
      final body = await response.stream.bytesToString();

      debugPrint("📥 STATUS => ${response.statusCode}");
      debugPrint("📥 BODY => $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Document uploaded successfully");
        Get.offAllNamed(AppRoute.verifyyouridentity);
      } else {
        Get.snackbar("Error", body);
      }
    } catch (e) {
      debugPrint("❌ UPLOAD ERROR => $e");
      Get.snackbar("Error", "Upload failed");
    } finally {
      isUploading.value = false;
    }
  }
}
