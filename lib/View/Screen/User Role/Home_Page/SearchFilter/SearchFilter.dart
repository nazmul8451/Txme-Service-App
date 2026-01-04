import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../../Widgegt/Email_Input_Field/EmailInputField.dart';
import 'SearchFilterController.dart';

class Searchfilter extends StatelessWidget {
  const Searchfilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchFilterController());

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        title: Text(
          AppString.searchFilter,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22.sp),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: controller.serviceTypeController,
                  label: AppString.serviceType,
                  hint: AppString.electrician,
                  img: AppImg.searchIcon,
                ),
                SizedBox(height: 16.h),
                Obx(() => Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: controller.serviceItems.map((item) {
                        bool isActive = controller.selectedService.value == item;
                        return GestureDetector(
                          onTap: () => controller.selectedService.value = item,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFFF6F4E)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                SizedBox(height: 20.h),
                CustomTextField(
                    controller: controller.languagesSpokenController,
                    label: "Languages Spoken",
                    hint: "English"),
                SizedBox(height: 20.h),
                Text(
                  AppString.serviceTiming.tr,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("From"), Text("To")],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.pickTime(context, true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.red601),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                                // ✅ FIXED: Handle null value
                                controller.fromTime.value?.format(context) ?? "Select Time",
                                style: TextStyle(fontSize: 16.sp),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.pickTime(context, false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.red601),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                                // ✅ FIXED: Handle null value
                                controller.toTime.value?.format(context) ?? "Select Time",
                                style: TextStyle(fontSize: 16.sp),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.red601),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                              controller.selectedDate.value != null
                                  ? DateFormat('yyyy-MM-dd').format(controller.selectedDate.value!)
                                  : AppString.selectDateOfBirth,
                              style: TextStyle(fontSize: 16.sp),
                            )),
                        Icon(Icons.calendar_today,
                            size: 20.sp, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                Obx(() => _buildSliderSection(
                      title: "Price Range",
                      valueLabel: "€${controller.minPrice.value.round()} - €${controller.maxPrice.value.round()}",
                      child: RangeSlider(
                        values: RangeValues(
                            controller.minPrice.value, controller.maxPrice.value),
                        min: 0,
                        max: 1000,
                        divisions: 100,
                        labels: RangeLabels(
                          "€${controller.minPrice.value.round()}",
                          "€${controller.maxPrice.value.round()}",
                        ),
                        onChanged: controller.setPriceRange,
                      ),
                    )),

                Obx(() => _buildSliderSection(
                      title: "Radius",
                      valueLabel: "${controller.radius.value.round()} km",
                      child: Slider(
                        value: controller.radius.value,
                        min: 1,
                        max: 25,
                        divisions: 24,
                        label: "${controller.radius.value.round()} km",
                        onChanged: controller.setRadius,
                      ),
                    )),

                SizedBox(height: 40.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      height: 47.h,
                      width: 153.w,
                      BoxDecoration: BoxDecoration(
                        color: AppColors.red601,
                        border: Border.all(color: AppColors.red601, width: 1.w),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          AppString.clearAll.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.FFFFFF,
                          ),
                        ),
                      ),
                      onTap: controller.clearFilters,
                    ),
                    SizedBox(width: 8.w),
                    CustomButton(
                      height: 47.h,
                      width: 153.w,
                      BoxDecoration: BoxDecoration(
                        color: AppColors.red601,
                        border: Border.all(color: AppColors.red601, width: 1.w),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          AppString.applyFilters.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.FFFFFF,
                          ),
                        ),
                      ),
                      onTap: controller.applyFilters,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required String valueLabel,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              valueLabel,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        child,
        SizedBox(height: 12.h),
      ],
    );
  }
}
