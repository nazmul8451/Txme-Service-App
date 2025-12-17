import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isScanning = false.obs;

  Future<void> onFingerprintPressed() async {
    print("Fingerprint pressed");

    if (isScanning.value) return;
    isScanning.value = true;

    try {
      bool isSupported = await auth.isDeviceSupported();
      bool canCheck = await auth.canCheckBiometrics;

      print("Supported: $isSupported");
      print("CanCheck: $canCheck");

      if (!isSupported || !canCheck) {
        isScanning.value = false;
        Get.snackbar("Error", "Fingerprint not available");
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Verify your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      isScanning.value = false;

      if (authenticated) {
        Get.offNamed('/faceverificationdone');
      } else {
        Get.snackbar("Failed", "Fingerprint not matched");
      }
    } catch (e) {
      isScanning.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
