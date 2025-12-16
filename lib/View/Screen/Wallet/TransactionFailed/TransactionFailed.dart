import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';

import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';

class Transactionfailed extends StatefulWidget {
  const Transactionfailed({super.key});

  @override
  State<Transactionfailed> createState() => _TransactionfailedState();
}

class _TransactionfailedState extends State<Transactionfailed> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 93.h,
          ),
          Center(
              child: SvgPicture.asset(
            AppIcons.TransactionFailed,
            height: 100.h,
            width: 100.w,
          )),

          Text("Transaction Failed", style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 36.sp, 
            color: Color(0xff1F2937)
          ),),

          SizedBox(height: 69.h,),

          Text("There was a problem processing your ", style: TextStyle(
            fontSize: 12.sp, 
            fontWeight: FontWeight.w400, 
            color: Color(0xff4C545F)
          ),),

          Text("request. Please check your internet ", style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff4C545F)
          ),),

          Text("connection and try again.", style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff4C545F)
          ),),


          SizedBox(height: 40.h),
          CustomButton(
              height: 56.h,
              width: 353.w,
              BoxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                 color: Color(0xffFF5A36)
              ),
              child:
                  Center(
                    child: Text(
                      "Try Again",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.FFFFFF),
                    ),
                  ),
              onTap: () {
                Get.toNamed(AppRoute.walletpage);
              }),

        ],
      ),
    );
  }
}
