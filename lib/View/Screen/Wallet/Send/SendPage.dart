import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../Availablebalance/Availablebalance.dart';
import 'SendPageController.dart';


class Sendpage extends StatefulWidget {
  Sendpage({Key? key}) : super(key: key);

  @override
  State<Sendpage> createState() => _SendpageState();
}

class _SendpageState extends State<Sendpage> {
  final Sendpagecontroller controller = Get.put(Sendpagecontroller());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AppIcons.chevronleft),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Availablebalance(),

              SizedBox(height: 20.sp),

              // Amount Input
              Text(
                "Enter Amount",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4C545F),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.ammountController,
                decoration: _inputDecoration(hint: "€0.00"),
              ),
              SizedBox(height: 20.h),

              Text(
                "Recipient Email or Phone",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4C545F),
                ),
              ),
              SizedBox(height: 8.h),
              // Message Input
              TextField(
                controller: controller.nameController,
                decoration: _inputDecoration(hint: ""),
              ),
              SizedBox(height: 20.h),


              /// Message Label
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color:  Color(0xff4C545F),
                ),
              ),
              SizedBox(height: 8.h),

              ///  Message Field (Big Box)
              TextField(
                controller: controller.messageController,
                maxLines: 5,
                decoration: _inputDecoration(
                  hint: "Mandatory",
                ),
              ),

              SizedBox(height: 15.h),


              // Add New Card Button
              Obx(() => CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  color: AppColors.red601,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: controller.isSending.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Send",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.FFFFFF,
                    ),
                  ),
                ),
                onTap: controller.isSending.value
                    ? null
                    : () async {
                  final transaction =
                  await controller.sendMoney();

                  if (transaction != null) {
                    Get.toNamed(
                      AppRoute.paymentdone,
                      arguments: transaction, // 🔥 PASS DATA
                    );
                  }
                },
              )),



          ],
          )),
        ),
    );
  }

  // Widget buildPaymentButton(
  //     {required int index, required String iconPath, required String title}) {
  //   return Obx(
  //         () => CustomButton(
  //       height: 56.h,
  //       width: 353.w,
  //       BoxDecoration: BoxDecoration(
  //         color: AppColors.FFFFFF,
  //         borderRadius: BorderRadius.circular(12.r),
  //         border: Border.all(
  //           color: controller.selectedPaymentIndex.value == index
  //               ? AppColors.red601
  //               : Color(0xffCACACA),
  //         ),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Image.asset(iconPath, height: 25, width: 25),
  //                 SizedBox(width: 4.w),
  //                 Text(
  //                   title,
  //                   style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w400,
  //                       color: Color(0xff4C545F)),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               height: 9,
  //               width: 9,
  //               decoration: BoxDecoration(
  //                 color: controller.selectedPaymentIndex.value == index
  //                     ? AppColors.red601
  //                     : Color(0xffCACACA),
  //                 borderRadius: BorderRadius.circular(4.r),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       onTap: () => controller.sendMoney(index),
  //     ),
  //   );
  // }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
