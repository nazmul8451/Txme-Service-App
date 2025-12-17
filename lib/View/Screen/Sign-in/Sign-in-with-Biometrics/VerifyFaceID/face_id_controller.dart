import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceIdController extends GetxController {
  CameraController? cameraController;
  late FaceDetector faceDetector;

  RxBool isCameraInitialized = false.obs;
  RxDouble faceProgress = 0.0.obs;

  bool isProcessing = false;

  @override
  void onInit() {
    super.onInit();
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
      ),
    );
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (e) => e.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController!.initialize();

    isCameraInitialized.value = true;

    cameraController!.startImageStream(processCameraImage);
  }

  Future<void> processCameraImage(CameraImage image) async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      final WriteBuffer buffer = WriteBuffer();
      for (final plane in image.planes) {
        buffer.putUint8List(plane.bytes);
      }

      final inputImage = InputImage.fromBytes(
        bytes: buffer.done().buffer.asUint8List(),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation270deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final area = face.boundingBox.width * face.boundingBox.height;

        faceProgress.value = (area / 70000).clamp(0.0, 1.0);

        if (faceProgress.value >= 1) {
          await onFaceVerified();
        }
      }
    } catch (e) {
      debugPrint("Face error: $e");
    } finally {
      isProcessing = false;
    }
  }

  ///  FACE VERIFIED → API HIT HERE
  Future<void> onFaceVerified() async {
    cameraController?.stopImageStream();

    ///  এখানে পরে API hit হবে
    /// await FaceVerifyApi.verifyFace();

    Get.offNamed('/face-verification-done');
  }

  ///  Button press করলে manually verify
  Future<void> onAuthenticatePressed() async {
    if (faceProgress.value < 1) {
      Get.snackbar(
        "Face ID",
        "Please position your face inside the circle",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await onFaceVerified();
  }


  @override
  void onClose() {
    cameraController?.dispose();
    faceDetector.close();
    super.onClose();
  }
}
