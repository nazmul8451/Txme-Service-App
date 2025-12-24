import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'WalletController.dart';

class Availablebalance extends StatefulWidget {
  const Availablebalance({super.key});

  @override
  State<Availablebalance> createState() => _AvailablebalanceState();
}

class _AvailablebalanceState extends State<Availablebalance> {
  final controller = Get.put(WalletControllerA());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 259.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return Column(
            children: [
              Text(
                "Available balance",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff1F2937),
                ),
              ),
              SizedBox(height: 20.sp),
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                return Text(
                  "€ ${controller.balance.value}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 48.sp,
                    color: Color(0xff1F2937),
                  ),
                );
              })
            ],
          );
        }),
      ),
    );
  }
}
