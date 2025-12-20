import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class UploadDocumentsController extends GetxController {
  ///  ID Images
  XFile? frontId; // idDocuments (front)
  XFile? backId;  // idDocuments (back)

  var isUploading = false.obs;


  final ImagePicker picker = ImagePicker();

  /// ================= PICK FRONT ID =================
  Future<void> pickFrontId() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked != null) {
      frontId = picked;
      update();
    }
  }

  /// ================= PICK BACK ID =================
  Future<void> pickBackId() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked != null) {
      backId = picked;
      update();
    }
  }

  /// ================= HELPER : IMAGE FILE =================
  Future<http.MultipartFile> _buildImage(XFile file) async {
    final extension = file.path.split('.').last.toLowerCase();

    String mimeType = "image/jpeg";
    if (extension == "png") {
      mimeType = "image/png";
    }

    return http.MultipartFile.fromPath(
      "idDocuments",                 // 🔑 SAME KEY
      file.path,
      filename: basename(file.path),
      contentType: MediaType.parse(mimeType),
    );
  }

  /// ================= API HIT =================


  Future<void> uploadSelectedDocuments() async {
    if (frontId == null && backId == null) {
      Get.snackbar("Error", "Please select at least one document");
      return;
    }

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

      /// 📤 FRONT ID
      if (frontId != null) {
        request.files.add(await _buildImage(frontId!));
      }

      /// 📤 BACK ID
      if (backId != null) {
        request.files.add(await _buildImage(backId!));
      }

      /// 🪵 DEBUG
      for (var f in request.files) {
        debugPrint("📤 FILE => ${f.filename}");
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      debugPrint("📥 STATUS => ${response.statusCode}");
      debugPrint("📥 BODY => $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Documents uploaded successfully");
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
