import 'package:get/get.dart';

import 'RequestBookingController.dart';


class RequestBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestBookingController>(
          () => RequestBookingController(),
    );
  }
}
