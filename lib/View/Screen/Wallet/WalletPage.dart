import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../../../Utils/AppIcons/app_icons.dart';
import '../../../core/App_Routes/app_routes.dart';
import 'WalletController.dart';


class Walletpage extends StatelessWidget {
  Walletpage({Key? key}) : super(key: key);

  final WalletController controller = Get.put(WalletController());

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
        title: Text(
          "Wallet",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff333333),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Obx(() => Column(
          children: [
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 259.w,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Available balance",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff1F2937)),
                    ),
                    SizedBox(height: 20.sp),
                    Text(
                      controller.balance.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 48.sp,
                          color: Color(0xff1F2937)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 34.5.h),
            // Buttons Row
            Row(
              children: [
                buildButton(1, "Top-up", () {
                  controller.selectButton(1);
                  Get.toNamed(AppRoute.topuppage);
                }),
                SizedBox(width: 16.sp),
                buildButton(2, "Withdraw", () {
                  controller.selectButton(2);
                  Get.toNamed(AppRoute.sendpage);
                }),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                buildButton(3, "Send", () {
                  controller.selectButton(3);

                  Get.toNamed(AppRoute.requestpage);

                }),
                SizedBox(width: 16.sp),
                buildButton(4, "Request", () {
                  controller.selectButton(4);

                  Get.toNamed(AppRoute.withdrawpage);

                }),
              ],
            ),
            SizedBox(height: 80.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: SvgPicture.asset(
                                  AppIcons.transactions,
                                  height: 24.h,
                                  width: 24.w,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${tx['type']} ${tx['amount']}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff1F2937),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      tx['note'],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff4C545F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 28.h),
                                child: Text(
                                  tx['timeAgo'],
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color(0xff9CA3AF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildButton(int index, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
              () => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.5.h),
            decoration: BoxDecoration(
              color: controller.selectedIndex.value == index
                  ? Colors.red
                  : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.red, width: 1.w),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: controller.selectedIndex.value == index
                      ? Colors.white
                      : Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
