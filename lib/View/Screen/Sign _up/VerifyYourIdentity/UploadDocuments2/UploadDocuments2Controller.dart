import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CompleteProfileController extends GetxController {

  XFile? imageFile;
  var isUploading = false.obs;

  final ImagePicker picker = ImagePicker();

  Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = pickedFile;
      update(); // refresh UI
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) return;

    isUploading.value = true;

    // pretend upload…
    await Future.delayed(Duration(seconds: 2));

    Get.back();

    isUploading.value = false;
  }
}
