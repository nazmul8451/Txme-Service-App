import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/View/Screen/Wallet/Availablebalance/Availablebalance.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/AppIcons/app_icons.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../Widgegt/cart/CardScreenDebitNaira.dart';
import '../WalletAddNewCardPage/WalletAddNewCardPage.dart';
import 'WalletPaymentController.dart';

class Walletpaypalselectpaymentmethod extends StatelessWidget {
  Walletpaypalselectpaymentmethod({Key? key}) : super(key: key);

  final WalletPaymentController controller =
  Get.put(WalletPaymentController());

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
            )),
        title: Padding(
          padding: EdgeInsets.only(left: 45.w),
          child: Text(
            "Select Payment Method",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
              children: [
                ///================  Available balance =================///

                Availablebalance(),

                SizedBox(height: 20.h),

                // Selected Card
                if (controller.selectedCardData.isNotEmpty)
                  CustomDebitCard(
                    cardType: controller.selectedCardData["type"],
                    cardNumber: controller.selectedCardData["number"],
                    expiryDate: controller.selectedCardData["expiry"],
                    cardHolderName: controller.selectedCardData["name"],
                  ),
                SizedBox(height: 20.h),

                // Add New Card
                CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: Color(0xffF7F7F7),
                        border:
                        Border.all(color: Color(0xffFF5A36), width: 1.w)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            "Add New Card",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xff4C545F)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 23.w),
                          child: SvgPicture.asset(AppIcons.plusIcons),
                        )
                      ],
                    ),
                    onTap: () async {
                      final result =
                      await Get.to(() => WalletAddNewCardPage());
                      if (result != null) {
                        controller.selectCard(result);
                      }
                    }),

                SizedBox(height: 40.h),

                // Continue Button
                CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Color(0xffFF5A36),
                    ),
                    child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xffFFFFFF)),
                        )),
                    onTap: () {
                       Get.toNamed(AppRoute.paymentdone);
                    }),
              ],
            ),
          ),
        ),
    );
  }
}
