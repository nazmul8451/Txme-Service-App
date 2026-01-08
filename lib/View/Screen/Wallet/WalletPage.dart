import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import 'package:txme_app/service/settings_service.dart';
import '../../../Utils/AppIcons/app_icons.dart';
import '../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import 'Availablebalance/Availablebalance.dart';
import 'Request/RequestPage.dart';
import 'Send/SendPage.dart';
import 'WalletController.dart';
import 'modelTransactions.dart'; // ✅ ADDED

class WalletPage extends StatelessWidget {
  WalletPage({Key? key}) : super(key: key);

  final WalletController controller = Get.put(WalletController());
  final SettingsService settingsService = Get.find<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        elevation: 0,
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
        onRefresh: () => controller.fetchTransactions(),
        child: Obx(
          () => controller.isLoading.value && controller.transactions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 12.h),

                    /// BALANCE
                    const Availablebalance(),

                    SizedBox(height: 34.5.h),

                    /// BUTTONS
                    Row(
                      children: [
                        Obx(() => settingsService.topUpEnabled.value
                            ? buildButton(1, "Top-up", () {
                                controller.selectButton(1);
                                Get.toNamed(AppRoute.topuppage);
                              })
                            : const Expanded(child: SizedBox())),
                        SizedBox(width: 16.w),

                        Obx(() => settingsService.withdrawEnabled.value
                            ? buildButton(2, "Withdraw", () {
                                controller.selectButton(2);
                                Get.toNamed(AppRoute.withdrawpage);
                              })
                            : const Expanded(child: SizedBox())),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Obx(() => settingsService.moneySendEnabled.value
                            ? buildButton(3, "Send", () {
                                controller.selectButton(3);
                                Get.to(() => Sendpage()); // ✅ CORRECTED
                              })
                            : const Expanded(child: SizedBox())),
                        SizedBox(width: 16.w),
                        Obx(() => settingsService.moneyRequestEnabled.value
                            ? buildButton(4, "Request", () {
                                controller.selectButton(4);
                                Get.to(() => Requestpage()); // ✅ CORRECTED
                              })
                            : const Expanded(child: SizedBox())),
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
                                      "${tx.type.toUpperCase()} €${tx.amount}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      tx.direction == "debit"
                                          ? "To ${tx.toEmail}"
                                          : "From ${tx.fromEmail}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                controller.format24h(tx.createdAt), // CORRECTED
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
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
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
