import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'SettingsController.dart'; // ✅ RENAMED
import '../../../../../Utils/AppColors/app_colors.dart';

// ✅ RENAMED: NotificationSettings -> SettingsPage
class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings", // ✅ RENAMED
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(() { // ✅ Wrapped with Obx to show a loader
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildSectionTitle("App Settings"),
              _notificationCard(
                child: _notificationRow(
                  title: "Profile Promotion",
                  value: controller.profilePromotionEnabled,
                  onTap: controller.toggleProfilePromotion,
                  isAdminControlled: controller.profilePromotionAdminControlled.value,
                ),
              ),
              SizedBox(height: 15.h),
              _notificationCard(
                child: _notificationRow(
                  title: "Card Payment",
                  value: controller.cardPaymentEnabled,
                  onTap: controller.toggleCardPayment,
                  isAdminControlled: controller.cardPaymentAdminControlled.value,
                ),
              ),
              SizedBox(height: 15.h),
              _notificationCard(
                child: _notificationRow(
                  title: "Send in Message",
                  value: controller.sendInMessageEnabled,
                  onTap: controller.toggleSendInMessage,
                  isAdminControlled: controller.sendInMessageAdminControlled.value,
                ),
              ),

              _buildSectionTitle("Digital Payments"),
              _notificationCard(
                child: _notificationRow(
                  title: "Payment by Card",
                  value: controller.paymentByCardEnabled,
                  onTap: controller.togglePaymentByCard,
                  isAdminControlled: controller.paymentByCardAdminControlled.value,
                ),
              ),
              SizedBox(height: 15.h),
              _notificationCard(
                child: _notificationRow(
                  title: "Payment by Paypal",
                  value: controller.paymentByPaypalEnabled,
                  onTap: controller.togglePaymentByPaypal,
                  isAdminControlled: controller.paymentByPaypalAdminControlled.value,
                ),
              ),
              SizedBox(height: 15.h),
              _notificationCard(
                child: _notificationRow(
                  title: "Wallet Features",
                  value: controller.walletFeaturesEnabled,
                  onTap: controller.toggleWalletFeatures,
                  isAdminControlled: controller.walletFeaturesAdminControlled.value,
                ),
              ),

              SizedBox(height: 60.h),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red601,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Save Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _notificationCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffD4E0EB).withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _notificationRow({
    required String title,
    required RxBool value,
    required VoidCallback onTap,
    required bool isAdminControlled, // ✅ ADDED
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff333333),
          ),
        ),
        Obx(() => _customToggle(value.value, onTap, isAdminControlled)),
      ],
    );
  }

  Widget _customToggle(bool value, VoidCallback onTap, bool isAdminControlled) {
    return GestureDetector(
      onTap: isAdminControlled ? null : onTap, // ✅ UPDATED: Disable tap if admin controlled
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 55.w,
        height: 28.h,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xffEEEEEE) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: value
              ? null
              : Border.all(
                  color: Colors.grey.shade400,
                  width: 1.5.w,
                ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ✅ UPDATED: Show disabled color if admin controlled
              color: value
                  ? (isAdminControlled ? Colors.grey : AppColors.red601)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
