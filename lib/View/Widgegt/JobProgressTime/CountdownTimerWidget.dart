import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'JobTimerController.dart';

class JobTimerCard extends StatelessWidget {
  JobTimerCard({super.key});

  final timer = Get.find<JobTimerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status indicator
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: timer.isRunning.value
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: timer.isRunning.value ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  timer.isRunning.value ? "Job In Progress" : "Job Paused",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: timer.isRunning.value
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          )),

          SizedBox(height: 16.h),

          /// 🔥 LIVE TIMER
          Obx(() => Text(
            timer.formattedTime,
            style: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff2563EB),
            ),
          )),

          SizedBox(height: 6.h),

          Text(
            "Time Elapsed",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              color: const Color(0xff6B7280),
            ),
          ),

          // Debug info (remove in production)
          if (kDebugMode) ...[
            SizedBox(height: 12.h),
            Obx(() => Text(
              "Seconds: ${timer.seconds.value}",
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
            )),
          ],
        ],
      ),
    );
  }
}