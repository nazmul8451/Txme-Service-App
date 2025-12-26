import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import 'EditProfileController.dart';

class EditProfilePage extends GetView<EditProfileController> {
  EditProfilePage({super.key});

  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = controller.user.value;
          if (user == null) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE IMAGE
              Center(
                child: GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage: controller.profileImage.value != null
                            ? FileImage(controller.profileImage.value!)
                            : (user.profileImageUrl != null &&
                            user.profileImageUrl!.isNotEmpty
                            ? NetworkImage(user.profileImageUrl!)
                            : const AssetImage(AppImg.editProfile))
                        as ImageProvider,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppColors.red601,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 15.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              _label("Full Name"),
              _input(controller.nameController),

              SizedBox(height: 15.h),
              _label("Nationality"),
              _countryDropdown(context),

              SizedBox(height: 15.h),
              _label("Phone"),
              _phoneInput(),

              SizedBox(height: 15.h),
              _label("Address"),
              _input(controller.addressController),

              SizedBox(height: 15.h),
              _label("Bio"),
              _bioInput(),

              SizedBox(height: 15.h),
              _label("Country of Residence"),
              _input(controller.residenceController),

              SizedBox(height: 15.h),
              _label("Postal Address"),
              _input(controller.postalController),

              SizedBox(height: 30.h),
              _updateButton(),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(text,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
    );
  }

  Widget _input(TextEditingController c) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Widget _countryDropdown(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => controller.pickCountry(context),
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Text(controller.selectedFlag.value),
            SizedBox(width: 10.w),
            Expanded(
                child:
                Text(controller.selectedCountryName.value)),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    ));
  }

  Widget _phoneInput() {
    return Obx(() => Container(
      padding:
      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Text(controller.selectedFlag.value),
          SizedBox(width: 6.w),
          Text(controller.phoneCode.value),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration:
              const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _bioInput() {
    return TextField(
      controller: controller.bioController,
      maxLines: 4,
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }


  Widget _updateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5A36),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "Update",
          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
