import 'package:get/get.dart';

class VerifyIdentityController extends GetxController {
  RxBool idVerified = false.obs;
  RxBool addressVerified = false.obs;

  void markIdVerified() {
    idVerified.value = true;
  }

  void markAddressVerified() {
    addressVerified.value = true;
  }

  bool get isAllVerified => idVerified.value && addressVerified.value;
}


