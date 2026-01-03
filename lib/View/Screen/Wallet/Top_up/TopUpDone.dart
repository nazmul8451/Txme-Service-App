import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../Availablebalance/WalletController.dart';
import '../Top_up/TopUpController.dart';
import '../WalletTransaction.dart';
import '../transaction/transaction_details_screen.dart';
import '../transaction/transaction_type.dart';

class PaymentdoneT extends StatefulWidget {
  const PaymentdoneT({super.key});

  @override
  State<PaymentdoneT> createState() => _PaymentdoneTState();
}

class _PaymentdoneTState extends State<PaymentdoneT> {


  late final int amount;
  late final String currency;
  late final double newBalance;
  late final String transactionId;



  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};

    amount = args["amount"] ?? 0;
    currency = args["currency"] ?? "EUR";
    newBalance = (args["amount"] ?? 0).toDouble();
    transactionId = args["wallet"] ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h),

              SvgPicture.asset(
                AppIcons.PaymentDone,
                height: 80.h,
                width: 80.w,
              ),

              SizedBox(height: 20.h),

              Text(
                "Payment Done",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 36.sp,
                  color: const Color(0xff1F2937),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                "You’ve added:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: const Color(0xff4C545F),
                ),
              ),

              SizedBox(height: 20.h),

              ///  Amount (Dynamic)
              Text(
                // ("€ ${amount}"),
                "€${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 48.sp,
                  color: const Color(0xff1F2937),
                ),
              ),

              SizedBox(height: 16.h),

              /// 📦 Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.red601,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      "New balance:",
                      "€${amount.toStringAsFixed(2)}",
                    ),
                    SizedBox(height: 12.h),
                    _infoRow(
                      "Transaction ID:",
                      transactionId
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// 👉 Wallet
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xff4CAF50),
                ),
                child: const Center(
                  child: Text(
                    "Go to Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  //  Wallet balance refresh
                  Get.find<WalletControllerA>().getAvailableBalance();

                  //  Go to wallet page
                  Get.offAllNamed(AppRoute.walletpage,);
                },

              ),

              SizedBox(height: 12.h),

              ///  Transaction Details
              // CustomButton(
              //   height: 56.h,
              //   width: 353.w,
              //   BoxDecoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12.r),
              //     color: Colors.white,
              //   ),
              //   child: const Center(
              //     child: Text(
              //       "View Transaction Details",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //         color: Color(0xff3A7DFF),
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     Get.to(
              //           () => TransactionDetailsScreen(type: TransactionType.send),
              //       arguments: tx,
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff1F2937),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff1F2937),
          ),
        ),
      ],
    );
  }
}



