import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../../core/App_Routes/app_routes.dart';
import '../../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../../Wallet/Availablebalance/Availablebalance.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import 'PaywithWalletController.dart';

class Paywithwallet extends StatelessWidget {
  Paywithwallet({super.key});

  final PayWithWalletController controller = Get.put(PayWithWalletController());

  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Availablebalance(),
            SizedBox(height: 95.h),
            Text(
              "Amount",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Color(0xff4C545F),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: TextEditingController(
                text: "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Color(0xff4C545F),
              ),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7F7F7),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFF5A36), width: 1.w),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            ),

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
            SizedBox(height: 20.h),
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
                  controller.payWithWallet(appointment);
                }),
          ],
        ),
      ),
    );
  }
}
