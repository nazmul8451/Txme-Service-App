import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../../../../../core/App_Routes/app_routes.dart';
import '../../../../../Widgegt/Custom_Button/custom_button.dart';
import 'PayWithCashController.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/AppIcons/app_icons.dart';

class Paywithcash extends StatefulWidget {
  const Paywithcash({super.key});

  @override
  State<Paywithcash> createState() => _PaywithcashState();
}

class _PaywithcashState extends State<Paywithcash> {
  final Paywithcashcontroller controller = Get.put(Paywithcashcontroller());

  late SocketApi socketApi; // ✅ Socket instance as class variable
  late String eventName; // ✅ Event name as class variable
  late String appointmentId; // ✅ Appointment ID

  @override
  void initState() {
    super.initState();

    // ✅ Get appointment ID from arguments if passed
    // You might need to pass appointment details to this page
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('appointmentId')) {
      appointmentId = args['appointmentId'];
    }

    // ✅ Initialize socket
    socketApi = SocketApi();
    eventName = "appointmentUpdate::${controller.userId.value}";

    _listenSocket();
  }

  void _listenSocket() {
    debugPrint("🔌 PayWithCash Socket listening to: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📡 PayWithCash Socket event received: $data");

      if (data != null) {
        final status = data['status']?.toString().toLowerCase();

        // ✅ Check if payment is confirmed by provider
        if (status == 'cashreceived' || status == 'review_pending') {
          Get.snackbar(
            "Payment Confirmed!",
            "The provider has confirmed receiving the payment.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );

          // ✅ Navigate to success page after confirmation
          Future.delayed(Duration(seconds: 2), () {
            Get.offNamed(AppRoute.paymentsuccessful);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // ✅ CRITICAL: Remove socket listener
    debugPrint("🔌 Removing PayWithCash socket listener: $eventName");
    socketApi.off(eventName);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            AppIcons.chevronleft,
            height: 18.h,
            width: 18.w,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 70.w),
          child: Text(
            "Payment",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff1F2937),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recipient Account Name",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
            ),
            SizedBox(
              height: 8.h,
            ),
            Obx(() => TextField(
              controller: TextEditingController(
                  text: controller.recipientName.value),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7F7F7),
                border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            )),
            SizedBox(height: 16.h),
            Text(
              "Recipient Account Number",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
            ),
            SizedBox(
              height: 8.h,
            ),
            Obx(() => TextField(
              controller: TextEditingController(
                  text: controller.accountNumber.value),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7F7F7),
                border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            )),
            SizedBox(height: 16.h),
            Text(
              "Routing Number",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
            ),
            SizedBox(
              height: 8.h,
            ),
            Obx(() => TextField(
              controller: TextEditingController(
                  text: controller.routingNumber.value),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7F7F7),
                border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            )),
            SizedBox(height: 16.h),
            TextField(
              controller: controller.noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7F7F7),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                hintText: "Note(Optional)",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Amount",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color(0xff4C545F)),
            ),
            SizedBox(height: 8.h),
            Obx(() => Container(
              padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                border: Border.all(color: Color(0xffFF5A36), width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: Color(0xff4C545F)),
                  ),
                  Text(
                    "${controller.amount.value}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: Color(0xff4C545F)),
                  ),
                ],
              ),
            )),
            SizedBox(height: 40.h),
            CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Color(0xffFF5A36),
                ),
                child: Center(
                    child: Text(
                      "Make Payment",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffFFFFFF)),
                    )),
                onTap: () {



                  // ✅ Show waiting message
                  Get.snackbar(
                    "Payment Initiated",
                    "Waiting for provider confirmation...",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );

                  // Navigate to next page or stay and wait for socket event
                  // Get.toNamed(AppRoute.paymentsuccessful);
                }),
          ],
        ),
      ),
    );
  }
}