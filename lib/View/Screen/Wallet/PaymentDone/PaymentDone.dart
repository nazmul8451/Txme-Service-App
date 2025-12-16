import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../transaction/transaction_details_screen.dart';
import '../transaction/transaction_type.dart';

class Paymentdone extends StatefulWidget {
  const Paymentdone({super.key});

  @override
  State<Paymentdone> createState() => _PaymentdoneState();
}

class _PaymentdoneState extends State<Paymentdone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        leading: Text(""),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              AppIcons.xIcons,
              height: 24.h,
              width: 24.w,
              color: AppColors.red601,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Center(
                  child: SvgPicture.asset(
                AppIcons.PaymentDone,
                height: 80.h,
                width: 80.w,
              )),
          
              SizedBox(height: 20.h,),
              Text("Payment Done", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 36.sp,
                color: Color(0xff1F2937),
              ),),
          
              SizedBox(height: 20.h,),
              Text("you’ve added:", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: Color(0xff4C545F),
              ),),
          
          
              SizedBox(height: 20.h,),
              Text("€50.00", style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 48.sp,
                color: Color(0xff1F2937),
              ),),
              SizedBox(height: 16.h,),
          
          
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7), 
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.red601, width: 1.w),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("New wallet Balance:", style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1F2937),
                        ),),

                        Text("€125.00", style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1F2937),
                        ),)
                      ],
                    ),
                    SizedBox(height: 12.h,),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Transaction ID:", style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1F2937),
                        ),),



                        Text("TXN123654987", style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1F2937),
                        ),)
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h,),

              CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xff4CAF50),
                  ),
                  child: Center(
                      child: Text(
                        "Go to Wallet",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xffFFFFFF)),
                      )),
                  onTap: () {
                    Get.toNamed(AppRoute.walletpage);
                  }),


              CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xffFFFFFF),
                  ),
                  child: Center(
                      child: Text(
                        "View Transaction Details",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff3A7DFF)),
                      )),
                  onTap: () {
                    Get.to(
                      const TransactionDetailsScreen(
                        type: TransactionType.topUp,
                      ),
                    );

                  }),
          
            ],
          ),
        ),
      ),
    );
  }
}
