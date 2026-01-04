import 'package:get/get.dart';

class NotificationControllerSt extends GetxController {
  var generalNotification = true.obs;
  var soundNotification = true.obs;
  var vibrateNotification = false.obs;

  void toggleGeneral() {
    generalNotification.value = !generalNotification.value;
  }

  void toggleSound() {
    soundNotification.value = !soundNotification.value;
  }

  void toggleVibrate() {
    vibrateNotification.value = !vibrateNotification.value;
  }

  void saveSettings() {
    // TODO: Implement API call to save notification settings
    Get.snackbar('Success', 'Settings saved!');
  }
}
