import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Widgegt/Logout/Logout.dart';
import '../../User Role/Profile/EditProfile/EditProfile.dart';
import '../../User Role/Profile/NotificationPage/NotificationSettingsPage.dart';
import '../../User Role/Profile/VerificationPage/VerificationPage.dart';
import '../../User Role/Profile/pastInvoice/InvoiceListPage.dart';
import 'EditProfileProfession/EditProfileProfession.dart';
import 'UserHeaderController.dart';

class ProviderProfilePage extends StatelessWidget {
  ProviderProfilePage({super.key});

  final controller = Get.put(UserHeaderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF5A36), // AppColors.red601
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.wait([
            controller.fetchUserHeader(),
            controller.fetchStripeAccountStatus(),
            controller.fetchProviderStats(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE HEADER

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
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
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          user.providerProfile?.designation ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.orange),
                            const SizedBox(width: 5),
                            Text(user.review?.averageRating.toString() ?? '0'),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 22),

                Obx(() =>Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF5A36), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: controller.providerStats.value == null
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem(
                      image:  AppImg.star,
                      value: controller.providerStats.value!.averageRating.toStringAsFixed(1),
                      label: "Rating",
                    ),
                    _statItem(
                      image: AppImg.active,
                      value: controller.providerStats.value!.totalOrders.toString(),
                      label: "Completed",
                    ),
                    _statItem(
                      image: AppImg.completed,
                      value:  "${controller.providerStats.value!.experience.toString()} yrs",
                      label: "Experience",
                    ),
                  ],
                ),
              ),
                ),

              const SizedBox(height: 22),

              const Text(
                "Profile information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => Get.to(() => EditProfilePage()),
                child: menuItem(img: AppImg.editProfile, title: "Edit Profile"),
              ),

              GestureDetector(
                onTap: () => Get.to(() => Editprofileprofession()),
                child: menuItem(img: AppImg.profession, title: "Profession"),
              ),

              GestureDetector(
                onTap: () => Get.to(() => VerificationPage()),
                child: menuItem(img: AppImg.verification, title: "Verification"),
              ),

              const SizedBox(height: 20),
              const Text(
                "Wallet & Invoice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.walletpage);
                },
                child: menuItem(img: AppImg.wallet, title: "Wallet"),
              ),


              Obx(() {
                if (controller.isStripeLoading.value) {
                  return const CircularProgressIndicator();
                }

                if (controller.isStripeFullyVerified) {
                  return const SizedBox();
                }

                return GestureDetector(
                  onTap: controller.createStripeAccountSession,
                  child: menuItem(
                    img: AppImg.stripeImg,
                    title: "Connect Stripe",
                  ),
                );
              }),


              GestureDetector(
                onTap: () => Get.to(() => InvoiceListPage()),
                child: menuItem(img: AppImg.pastInvoices, title: "Past Invoices"),
              ),

              const SizedBox(height: 20),
              const Text(
                "General Preferences",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => Get.to(() => SettingsPage()),
                child: menuItem(img: AppImg.setting, title: "Setting"),
              ),

              faqItem(),

              GestureDetector(
                onTap: () => Get.dialog(const CustomLogoutPopup(),
                    barrierDismissible: false),
                child: logoutItem(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  Widget menuItem({required String img, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            img,
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFFF5A36),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget faqItem() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
          color: const Color(0xffF5F9FB), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset(
            AppImg.FAQ,
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "FAQ (THIS IS LINKED WITH TXME FAQ)",
              style: TextStyle(
                  color: Color(0xFFFF5A36), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget logoutItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
          color: const Color(0xffF5F9FB), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset(
            AppImg.Logout,
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 14),
          const Text("Logout",
              style: TextStyle(
                  color: Color(0xFFFF5A36), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statItem(
      {required String image, required String value, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 33,
          height: 30,
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
