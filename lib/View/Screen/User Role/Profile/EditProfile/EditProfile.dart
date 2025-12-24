import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import 'EditProfileController.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= PROFILE IMAGE =================
            Center(
              child: GestureDetector(
                onTap: controller.pickProfileImage, // optional (tap on image)
                child: Obx(() => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [

                    /// ================= PROFILE IMAGE =================
                    CircleAvatar(
                      radius: 55.r,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : const AssetImage("")
                      as ImageProvider,
                    ),

                    /// ================= CAMERA ICON =================
                    Positioned(
                      bottom: 0.h,

                      right: 8.w,
                      child: GestureDetector(
                        onTap: controller.pickProfileImage,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppColors.red601,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),


            SizedBox(height: 25.h),

            /// ================= NAME =================
            _inputLabel("Name"),
            _inputField(controller.nameController),



            /// ================= EMAIL =================


            SizedBox(height: 15.h),

            /// ================= COUNTRY =================
            _inputLabel("Country"),
            _countryDropdown(context),

            SizedBox(height: 15.h),

            /// ================= PHONE =================
            _inputLabel("Phone number"),
            _phoneInput(),

            SizedBox(height: 15.h),

            /// ================= ADDRESS =================
            _inputLabel("Address"),
            _inputField(controller.addressController),

            SizedBox(height: 15.h),

            /// ================= BIO =================
            _inputLabel("Bio"),
            _bioInput(),
            /// ================= NEW FROM CREATE ACCOUNT =================
            SizedBox(height: 20.h),


            SizedBox(height: 15.h),

            _inputLabel("Country of Residence"),
            _inputField(controller.residenceController),

            SizedBox(height: 15.h),

            _inputLabel("Postal Address"),
            _inputField(controller.postalController),

            SizedBox(height: 30.h),

            /// ================= UPDATE BUTTON =================
            _updateButton(),

            SizedBox(height: 20.h),

            Text(
              "Profile information will be updated securely.",
              style: TextStyle(fontSize: 12.sp, color: Colors.black54),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  // 🔹 Label
  Widget _inputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  // 🔹 Normal Input Field
  Widget _inputField(TextEditingController textController,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: textController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.orange, width: 1.5.w),
        ),
      ),
    );
  }

  //  Country Dropdown
  Widget _countryDropdown(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => controller.pickCountry(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Text(
              controller.selectedFlag.value,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                controller.selectedCountryName.value,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    ));
  }


  // 🔹 Phone Number Input
  Widget _phoneInput() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          // Flag of country
          Text(controller.selectedFlag.value, style: TextStyle(fontSize: 18.sp)),
          SizedBox(width: 10.w),
          Text(controller.phoneCode.value, style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    ));
  }

  // 🔹 Bio Input
  Widget _bioInput() {
    return TextField(
      controller: controller.bioController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Tell more about yourself",
        hintStyle: TextStyle(fontSize: 13.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  //  Update Button
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
