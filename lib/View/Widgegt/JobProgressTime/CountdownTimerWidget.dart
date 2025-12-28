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
          const Text(
            "Job In Progress",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff1F2937),
            ),
          ),
          const SizedBox(height: 10),

          /// 🔥 LIVE / API BASED TIMER
          Obx(() => Text(
            timer.formattedTime,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w600,
              color: Color(0xff2563EB),
            ),
          )),

          const SizedBox(height: 6),
          const Text(
            "Time Elapsed",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Color(0xff6B7280),
            ),
          ),
        ],
      ),
    );
  }
}



//start bottom

///timer.reset();
// timer.start();

//end bottom

//final totalSeconds = timer.stop();
// final payload = timer.timePayload;
// // send payload to API

