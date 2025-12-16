import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import 'transaction_controller.dart';
import 'transaction_type.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionType type;

  const TransactionDetailsScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionDetailsController(type));

    return Scaffold(
        backgroundColor: AppColors.FFFFFF,


      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        title: Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: Text("Transaction Details"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        controller.title.value,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4C545F)),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.amount.value,
                        style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1F2937)),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 127.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Color(0xffDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.SuccessfulIcons,
                              height: 7.h,
                              width: 11.5.w,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(controller.status.value),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.red601, width: 1.w)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      _row("Transaction Type", controller.title.value),
                      _row("Date & Time", controller.dateTime.value),
                      _row("Payment Method", controller.paymentMethod.value),
                      _row("Transaction ID", controller.transactionId.value),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
            
            
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.red601, width: 1.w)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      _row("Amount", controller.amount2.value),
                      _row("Fee:", controller. fee.value),
            
                      Container(
                        width: double.infinity,
                        height: 2.h,
                        color: Color(0xff4C545F),
                      ),
                      _row("Total:", controller.total.value),
            
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
            
                 SizedBox(height: 24.h),
                CustomButton(
                    height: 44.h,
                    width: 349.w,
                    BoxDecoration: BoxDecoration(
            
                      border: Border.all(color: Color(0xff3A7DFF))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            
                        SvgPicture.asset(AppIcons.download),
            
                        SizedBox(width: 5.w,),
            
                        Text(
                          "Download Pdf",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.red601),
                        ),
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(AppRoute.transactionfailed);
                    }),
            
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}
