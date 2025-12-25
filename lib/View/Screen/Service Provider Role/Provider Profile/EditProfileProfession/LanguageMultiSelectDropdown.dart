import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import 'EditProfileProfessionController.dart';

class LanguageMultiSelectDropdown extends StatelessWidget {
  final Editprofileprofessioncontroller c;

  LanguageMultiSelectDropdown({super.key, required this.c});

  final RxBool isOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.red601, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            /// HEADER
            InkWell(
              onTap: () => isOpen.toggle(),
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        c.selectedLanguages.isEmpty
                            ? "Select Languages"
                            : c.selectedLanguages.join(", "),
                        style: TextStyle(fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      isOpen.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 26.sp,
                      color: Colors.grey.shade700,
                    )
                  ],
                ),
              ),
            ),

            /// DROPDOWN
            if (isOpen.value) ...[
              Divider(height: 1, color: AppColors.red601),
              SizedBox(
                height: 200.h,
                child: ListView(
                  children: c.allLanguages.map((lang) {
                    return CheckboxListTile(
                      dense: true,
                      activeColor: AppColors.red601,
                      value: c.selectedLanguages.contains(lang),
                      title: Text(lang),
                      onChanged: (_) => c.toggleLanguage(lang),
                    );
                  }).toList(),
                ),
              )
            ]
          ],
        ),
      );
    });
  }
}
