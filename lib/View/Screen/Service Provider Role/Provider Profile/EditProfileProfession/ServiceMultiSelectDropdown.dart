import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'EditProfileProfessionController.dart';
import '../../../../../Utils/AppColors/app_colors.dart';

class ServiceMultiSelectDropdown extends StatelessWidget {
  final Editprofileprofessioncontroller c;

  const ServiceMultiSelectDropdown({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.isServiceLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        height: 200.h,
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.red601),
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: c.services.map((service) {
              final selected = c.selectedServices.contains(service);

              return InkWell(
                onTap: () => c.toggleService(service),
                child: Row(
                  children: [
                    Checkbox(
                      value: selected,
                      onChanged: (_) => c.toggleService(service),
                      activeColor: AppColors.red601,
                    ),
                    Expanded(
                      child: Text(
                        service.name,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
