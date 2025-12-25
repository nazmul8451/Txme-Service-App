import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import 'EditProfileProfessionController.dart';

class DayMultiSelectPicker extends StatelessWidget {
  final String hint;
  final RxList<String> selectedDays;
  final void Function(String) onToggle;
  final Editprofileprofessioncontroller c;

  DayMultiSelectPicker({
    super.key,
    required this.hint,
    required this.selectedDays,
    required this.onToggle,
    required this.c,
  });

  /// local open state
  final RxBool isOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.red601, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            /// ===== HEADER (CLICK AREA) =====
            InkWell(
              onTap: () => isOpen.toggle(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDays.isEmpty
                            ? hint
                            : selectedDays.join(", "),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      isOpen.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 26.sp,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ),

            /// ===== DROPDOWN LIST =====
            if (isOpen.value) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.red601,
              ),
              SizedBox(
                height: 130.h,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  children: c.weekDays.map((day) {
                    final isSelected = selectedDays.contains(day);

                    return InkWell(
                      onTap: () => onToggle(day),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: AppColors.red601,
                              onChanged: (_) => onToggle(day),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
