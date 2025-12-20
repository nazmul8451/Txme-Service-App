import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class UploadDocumentsController extends GetxController {
  XFile? frontId;   // idDocuments (front)
  XFile? backId;    // idDocuments (back)

  var isUploading = false.obs;

  final ImagePicker picker = ImagePicker();

  /// 📸 Front ID
  Future<void> pickFrontId() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      frontId = picked;
      update();
    }
  }

  /// 📸 Back ID
  Future<void> pickBackId() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      backId = picked;
      update();
    }
  }

  /// 🚀 API HIT (ONLY idDocuments)
  Future<void> uploadSelectedDocuments() async {
    if (frontId == null && backId == null) {
      Get.snackbar("Error", "Please select at least one document");
      return;
    }

    isUploading.value = true;

    final uri = Uri.parse(
      "${ApiConstant.baseUrl}${ApiConstant.completeProfile}",
    );

    final request = http.MultipartRequest('PATCH', uri);

    /// 🔐 Authorization
    final token =
    await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    /// 🔑 idDocuments → MULTIPLE
    if (frontId != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'idDocuments',
          frontId!.path,
          filename: basename(frontId!.path),
        ),
      );
    }

    if (backId != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'idDocuments',
          backId!.path,
          filename: basename(backId!.path),
        ),
      );
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Documents uploaded successfully");
        Get.back();
      } else {
        Get.snackbar("Failed", body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploading.value = false;
    }
  }
}
