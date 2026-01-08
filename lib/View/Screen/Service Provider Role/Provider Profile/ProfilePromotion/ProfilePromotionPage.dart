import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'PromotionController.dart';

class ProfilePromotionPage extends StatelessWidget {
  ProfilePromotionPage({super.key});

  final PromotionController controller = Get.put(PromotionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Promote Your Profile",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }

        if (controller.packages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  "No packages available",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                "Boost Your Visibility",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Choose a plan to get more exposure and reach more customers",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 24.h),

              // Package List
              ...List.generate(
                controller.packages.length,
                    (index) {
                  final package = controller.packages[index];
                  final isPopular = index == 1; // Middle package as popular

                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPopular
                            ? [Colors.blue.shade400, Colors.blue.shade600]
                            : [Colors.white, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: isPopular
                              ? Colors.blue.withOpacity(0.3)
                              : Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isPopular
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Popular Badge
                        if (isPopular)
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Popular",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon and Title
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: isPopular
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.rocket_launch,
                                      size: 28.sp,
                                      color: isPopular
                                          ? Colors.white
                                          : Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          package.title,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isPopular
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14.sp,
                                              color: isPopular
                                                  ? Colors.white70
                                                  : Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              "${package.durationDays} Days",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: isPopular
                                                    ? Colors.white70
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16.h),

                              // Description
                              Text(
                                package.description,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: isPopular
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.grey.shade700,
                                ),
                              ),

                              SizedBox(height: 20.h),

                              // Divider
                              Divider(
                                color: isPopular
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.grey.shade300,
                                thickness: 1,
                              ),

                              SizedBox(height: 16.h),

                              // Price and Button Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isPopular
                                              ? Colors.white70
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "€${package.price}",
                                            style: TextStyle(
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold,
                                              color: isPopular
                                                  ? Colors.white
                                                  : Colors.green.shade600,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 4.h),
                                            child: Text(
                                              "EUR",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: isPopular
                                                    ? Colors.white70
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Button
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.activatePackage(package.id);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isPopular
                                          ? Colors.white
                                          : Colors.blue.shade600,
                                      foregroundColor: isPopular
                                          ? Colors.blue.shade600
                                          : Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Activate",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Info Card
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.blue.shade100,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          "Promoted profiles appear first in search results and get 3x more visibility",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}