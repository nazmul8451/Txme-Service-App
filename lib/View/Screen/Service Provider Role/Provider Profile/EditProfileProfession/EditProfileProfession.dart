import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/Email_Input_Field/EmailInputField.dart';
import 'DayMultiSelectPicker.dart';
import 'EditProfileProfessionController.dart';
import 'LanguageMultiSelectDropdown.dart';
import 'MultiDateCalendarPicker.dart';
import 'ServiceMultiSelectDropdown.dart';

class Editprofileprofession extends StatefulWidget {
  const Editprofileprofession({super.key});

  @override
  State<Editprofileprofession> createState() => _EditprofileprofessionState();
}

class _EditprofileprofessionState extends State<Editprofileprofession> {
  final Editprofileprofessioncontroller c =
      Get.put(Editprofileprofessioncontroller());

  bool showServiceDropdown = false;

  bool isPromoted = true;

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
          "Profession",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(
            children: [

              /// ===== Duration =====

              CustomTextField(
                controller: c.designationController,
                label: "Designation",
                hint: " Enter You Designation ",
                errorText: c.designation,
              ),

              /// ===== Service Name =====

              SizedBox(height: 20.h),

              GestureDetector(
                onTap: () {
                  setState(() {
                    showServiceDropdown = !showServiceDropdown;
                  });
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: c.serviceNameController,
                    label: "Service name *",
                    hint: "Enter You Service",
                    errorText: c.serviceNameError,
                  ),
                ),
              ),

              if (showServiceDropdown) ...[
                SizedBox(height: 8.h),
                ServiceMultiSelectDropdown(c: c),
              ],

              SizedBox(height: 16.h),

              CustomTextField(
                controller: c.skillsController,
                label: "Skills",
                hint: "Enter You Skills",
                errorText: c.skills,
              ),




              SizedBox(height: 16.h),

              /// ===== Expert In =====
              // CustomTextField(
              //   controller: c.expertInController,
              //   label: "Expert in *",
              //   hint: "Home clean, lawn clean",
              //   errorText: c.expertInError,
              // ),

              SizedBox(height: 16.h),

              /// ===== Language =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Languages Spoken *",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4C545F),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              LanguageMultiSelectDropdown(c: c),

              if (c.languageError != null) _errorText(c.languageError),

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
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== From / To =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("From"),
                          Text("To"),
                        ],
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

                      if (c.timeError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            c.timeError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      SizedBox(height: 16.h),

                      /// ===== Duration =====
                      CustomTextField(
                        controller: c.workiDurationController,
                        label: "Par Service Duration (Hour)",
                        hint: " 2 ",
                        errorText: c.languageError,
                      ),

                      SizedBox(height: 20.h),

                      /// ===== Working Days =====
                      const Text(
                        "Working Days *",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4C545F),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      DayMultiSelectPicker(
                        hint: "Select Your Availability",
                        selectedDays: c.selectedWorkingDays,
                        onToggle: c.toggleWorkingDay,
                        c: c,
                      ),

                      ///============     =================////

                      SizedBox(height: 12.h),

                      /// ===== Out Of Office =====
                      Row(
                        children: const [
                          Text(
                            "Out Of Office",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4C545F),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      UnavailableDateField(c: c),

                      SizedBox(height: 24.h),

                      /// ===== Rate =====
                      CustomTextField(
                        controller: c.rateController,
                        label: "Rate *",
                        hint: "€25 (Hourly)",
                        errorText: c.rateError,
                      ),

                      SizedBox(height: 40.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {

                            c.submitProfile();

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A36),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ))),
    );
  }

  Widget _timeBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red601),
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  Widget _errorText(String? text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text ?? "",
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
