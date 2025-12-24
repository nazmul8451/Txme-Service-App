import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/Email_Input_Field/CustomTextField.dart';
import '../../../../Widgegt/Email_Input_Field/EmailInputField.dart';
import '../../../../Widgegt/FilterSliderSection/FilterSliderSection.dart';
import 'EditProfileProfessionController.dart';

class Editprofileprofession extends StatefulWidget {
  const Editprofileprofession({super.key});

  @override
  State<Editprofileprofession> createState() => _EditprofileprofessionState();
}

class _EditprofileprofessionState extends State<Editprofileprofession> {
  final Editprofileprofessioncontroller c =
      Get.put(Editprofileprofessioncontroller());

  bool isPromoted = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double getFontSize(double size) => size * screenWidth / 375;
    double getSpacing(double size) => size * screenHeight / 812;

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
            "Profession",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 20.h),

              CustomTextField(
                controller: c.serviceNameController,
                label: "Service name",
                hint: "Cleaner",
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                controller: c.serviceNameController,
                label: "Expert in",
                hint: "Home clean, lawn clean, Washing",
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                controller: c.serviceNameController,
                label: "Languages Spoken",
                hint: "English",
              ),
              SizedBox(height: 16.h),

              /// ===== Service Timing =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.serviceTiming.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: const Color(0xff4C545F)),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              GetBuilder<Editprofileprofessioncontroller>(
                builder: (c) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text("From"), Text("To")],
                      ),
                      SizedBox(height: 10.h),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => c.pickTime(context, true),
                              child: _timeBox(c.fromTime.format(context)),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => c.pickTime(context, false),
                              child: _timeBox(c.toTime.format(context)),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Working Days",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4C545F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      /// Working day
                      _datePicker(
                        context,
                        c.selectedDate,
                        "Select Your Availability",
                        c.pickDate,
                      ),

                      SizedBox(height: 16.h),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Out Of office",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4C545F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      /// Out of office
                      _datePicker(
                        context,
                        c.selectedDate,
                        "Select your out of office days",
                        c.pickDate,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// ===== Location =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: const Color(0xff4C545F)),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${c.radius.value.start.toStringAsFixed(0)} km",
                        style: TextStyle(
                            fontSize: getFontSize(14),
                            color: const Color(0xff4C545F)),
                      ),
                      Text(
                        "${c.radius.value.end.toStringAsFixed(0)} km",
                        style: TextStyle(
                            fontSize: getFontSize(14),
                            color: const Color(0xff4C545F)),
                      ),
                    ],
                  )
              ),

              Obx(() => RangeSlider(
                    min: 0,
                    max: 50,
                    divisions: 150,
                    activeColor: const Color(0xff4C545F),
                    values: c.radius.value,
                    onChanged: (val) => c.radius.value = val,
                  )),


              SizedBox(height: 20.h),
              CustomTextField(label: "Rate", hint: "€25(Hourly)"),

                  SizedBox(height: 20.h),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                    "Advertise Your Service",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4C545F),
                    ),
                                 ),
                 ],
               ),
              const SizedBox(height: 10),

              /// Promote Box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xffff4d2d), // red/orange border
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Text
                    const Text(
                      "Promote (€1)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2E2E2E),
                      ),
                    ),

                    /// Switch
                    Switch(
                      value: isPromoted,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xffff4d2d),
                      onChanged: (value) {
                        setState(() {
                          isPromoted = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]))));
  }

  /// ===== Helpers (design unchanged) =====
  Widget _timeBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red601),
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(fontSize: 16.sp)),
    );
  }

  Widget _datePicker(
    BuildContext context,
    DateTime? date,
    String hint,
    Function(BuildContext) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.red601),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? "${date.day}/${date.month}/${date.year}" : hint,
              style: TextStyle(fontSize: 16.sp),
            ),
            Icon(Icons.calendar_today,
                size: 20.sp, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
