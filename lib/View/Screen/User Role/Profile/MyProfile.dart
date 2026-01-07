import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/View/Screen/User%20Role/Profile/pastInvoice/InvoiceListPage.dart';
import 'package:txme_app/View/Screen/User%20Role/Profile/profile_controller.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import 'package:txme_app/service/settings_service.dart'; // ✅ ADDED
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Widgegt/Logout/Logout.dart';
import 'EditProfile/EditProfile.dart';
import 'NotificationPage/NotificationSettingsPage.dart';
import 'VerificationPage/VerificationPage.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final controller = Get.put(ProfileController());
  final settingsService = Get.find<SettingsService>(); // ✅ ADDED

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "My Profile",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.red601,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.wait([
            controller.fetchUserHeader(),
            controller.fetchStripeAccountStatus(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= PROFILE HEADER =================

              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                final user = controller.user.value;
                if (user == null) return const SizedBox();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        Text(
                          user.fullName,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 18.sp, color: Colors.orange),
                            SizedBox(width: 5.w),
                            Text(
                            user.review?.averageRating.toString() ?? '0',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }),

              SizedBox(height: 22.h),

              /// ================= PROFILE INFORMATION =================
              Text(
                "Profile information",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: const Color(0xff565656),
                ),
              ),
              SizedBox(height: 12.h),

              profileMenu(
                onTap: () => Get.to(() => EditProfilePage()),
                img: AppImg.editProfile,
                title: "Edit Profile",
              ),
              profileMenu(
                onTap: () => Get.to(() => VerificationPage()),
                img: AppImg.verification,
                title: "Verification",
              ),
              // ✅ UPDATED: Conditionally show Wallet button
              Obx(() {
                  if (!settingsService.walletPaymentEnabled.value) {
                    return const SizedBox.shrink();
                  }
                  return profileMenu(
                    onTap: () {
                      Get.toNamed(AppRoute.walletpage);
                    },
                    img: AppImg.wallet,
                    title: "Wallet",
                  );
                }),


              Obx(() {
                if (controller.isStripeLoading.value) {
                  return const CircularProgressIndicator();
                }

                if (controller.isStripeFullyVerified) {
                  return const SizedBox();
                }

                return profileMenu(
                  onTap: controller.createStripeAccountSession,
                  img: AppImg.stripeImg,
                  title: "Connect Stripe",
                );
              }),



          SizedBox(height: 20.h),

              /// ================= GENERAL PREFERENCES =================
              Text(
                "General Preferences",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.black87),
              ),
              SizedBox(height: 12.h),

              profileMenu(
                onTap: () => Get.to(() => SettingsPage()),
                img: AppImg.setting,
                title: "Setting",
              ),
              profileMenu(
                onTap: () => Get.to(
                    () => InvoiceListPage()), // pass the page, not the controller
                img: AppImg.pastInvoices,
                title: "Past Invoices",
              ),

              faqItem(),
              logoutItem(),

              SizedBox(height: 20.h),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  /// ================= MENU ITEM =================
  Widget profileMenu({
    required String title,
    VoidCallback? onTap,
    required String img,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6.r,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(img, height: 44.h, width: 44.w),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray,
                ),
              ),
            ),
            Container(
              height: 44.h,
              width: 44.w,
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5A36),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= FAQ =================
  Widget faqItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xffF5F9FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(AppImg.FAQ, height: 44.h, width: 44.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              "FAQ (THIS IS LINKED WITH TXME FAQ)",
              style: TextStyle(
                color: AppColors.red601,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= LOGOUT =================
  Widget logoutItem() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          const CustomLogoutPopup(),
          barrierDismissible: true, 
          barrierColor: Colors.black.withOpacity(0.5), 
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF5F9FB),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Image.asset(AppImg.Logout, height: 44.h, width: 44.w),
            SizedBox(width: 14.w),
            Text(
              "Logout",
              style: TextStyle(
                color: AppColors.red601,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
