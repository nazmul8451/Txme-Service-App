import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/View/Screen/Wallet/Availablebalance/Availablebalance.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../../../Utils/AppIcons/app_icons.dart';
import '../../../core/App_Routes/app_routes.dart';
import '../../../helper/Shared_prefe/shared_prefe.dart';
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
          onPressed: () async {
            final role = await SharePrefsHelper.getString(
              SharePrefsHelper.userRole,
            );

            if (role == "PROVIDER") {
              Get.offAllNamed(AppRoute.providerHomeScreen);
            } else if (role == "CUSTOMER") {
              Get.offAllNamed(AppRoute.homepage);
            } else {
              Get.back();
            }
          },
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

      body: RefreshIndicator(
        color: AppColors.red601,
        backgroundColor: Colors.white,
        onRefresh: () => controller.refreshWallet(), // ✅ CORRECT
        child: Obx(
              () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 12.h),

              /// BALANCE
              Availablebalance(),

              SizedBox(height: 34.5.h),

              /// BUTTONS
              Row(
                children: [
                  buildButton(1, "Top-up", () {
                    controller.selectButton(1);
                    Get.toNamed(AppRoute.topuppage);
                  }),
                  SizedBox(width: 16.w),
                  buildButton(2, "Withdraw", () {
                    controller.selectButton(2);
                    Get.toNamed(AppRoute.withdrawpage);
                  }),
                ],
              ),

              SizedBox(height: 20.h),

              Row(
                children: [
                  buildButton(3, "Send", () {
                    controller.selectButton(3);
                    Get.toNamed(AppRoute.sendpage);
                  }),
                  SizedBox(width: 16.w),
                  buildButton(4, "Request", () {
                    controller.selectButton(4);
                    Get.toNamed(AppRoute.requestpage);
                  }),
                ],
              ),

              SizedBox(height: 40.h),

              /// TRANSACTIONS
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1F2937),
                ),
              ),

              SizedBox(height: 12.h),

              if (controller.transactions.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Text(
                      "No transactions found",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ...controller.transactions.map((tx) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.transactions,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${tx['type']} ${tx['amount']}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                tx['note'],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          tx['timeAgo'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(int index, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
              () => Container(
            padding: EdgeInsets.symmetric(vertical: 14.5.h),
            decoration: BoxDecoration(
              color: controller.selectedIndex.value == index
                  ? Colors.red
                  : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.red),
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

