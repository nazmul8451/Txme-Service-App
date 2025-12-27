import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppImg/app_img.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'Model/PopularProviderModel.dart';
import 'ProviderProfileDetaisController.dart';

class ProviderProfileDetailsPage extends StatelessWidget {
  final PopularProviderModel provider;


  ProviderProfileDetailsPage({
    super.key,
    required this.provider,
  });

  final controller = Get.put(ProviderProfileDetailsController());
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    /// ✅ FIXED: correct path
    final profile = provider.providerProfile;
    final review = provider.review;
    final skills = profile.skills;

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        surfaceTintColor: Colors.transparent,
        title: Text(provider.fullName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP IMAGE
            Container(
              width: double.infinity,
              height: 344.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: provider.profileImageUrl.isNotEmpty
                    ? Image.network(
                  provider.profileImageUrl,
                  width: double.infinity,
                  height: 344.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.person,
                    size: 300,
                    color: Colors.grey[300],
                  ),
                )
                    : Icon(
                  Icons.person,
                  size: 300,
                  color: Colors.grey[300],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 NAME
                  Text(
                    provider.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4C545F),
                    ),
                  ),

                  /// 🔹 DESIGNATION
                  Text(
                    profile.designation ?? "Service Provider",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4C545F),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 STATS
                  Container(
                    height: 103,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoColumn(
                          AppImg.star,
                          review.averageRating,
                          "Rating",
                        ),
                        _infoColumn(
                          AppImg.completed,
                          review.totalReviews,
                          "Reviews",
                        ),
                        _infoColumn(
                          AppImg.experience,
                          profile.experience,
                          "Years",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 SKILLS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Skills",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: const Color(0xff565656),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (profile.skills.isEmpty)
                        Text(
                          "No skills added",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10.w,      // 👉 horizontal gap
                          runSpacing: 10.h,   // 👉 vertical gap
                          children: profile.skills.map((skill) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffF5F6F8), // light grey bg
                                borderRadius: BorderRadius.circular(12.r), // pill shape
                                border: Border.all(
                                  color: const Color(0xffE5E7EB),
                                ),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff4B5563),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),


                  const SizedBox(height: 20),

                  /// 🔹 WORKING HOURS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      /// 🔹 AVAILABLE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: const Color(0xff4C545F),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              _timeBox(profile.workingHours.startTime),
                              SizedBox(width: 8.w),
                              Text(
                                "To",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff6B7280),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _timeBox(profile.workingHours.endTime),
                            ],
                          ),
                        ],
                      ),

                      /// 🔹 RATE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rate",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: const Color(0xff4C545F),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F6F8),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xffE5E7EB),
                              ),
                            ),
                            child: Text(
                              "€${profile.hourlyRate} (Hourly)",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff4B5563),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 BIO
                  const Text(
                    "Bio",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.bio ?? "No bio available",
                    style: const TextStyle(fontSize: 15),
                  ),


                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Review",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Color(0xff4C545F)),
                          ),
                          GestureDetector(
                            onTap: () {


                              Get.toNamed(AppRoute.allreviews);

                            },
                            child: Text(
                              "Show all",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Column(
                      //   children: (showAll
                      //       ? widget.provider.reviews
                      //       : widget.provider.reviews.take(2).toList())
                      //       .map((review) {
                      //     return Padding(
                      //       padding: EdgeInsets.only(bottom: 10.h),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Row(
                      //             children: [
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(12.r),
                      //                 child: review.profile.startsWith("http")
                      //                     ? Image.network(
                      //                   review.profile,
                      //                   width: 24.w,
                      //                   height: 24.h,
                      //                   fit: BoxFit.cover,
                      //                 )
                      //                     : Image.asset(
                      //                   review.profile,
                      //                   width: 24.w,
                      //                   height: 24.h,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //               SizedBox(width: 8.w),
                      //               Text(
                      //                 review.name,
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 14.sp),
                      //               ),
                      //               Spacer(),
                      //               Text(
                      //                 review.date,
                      //                 style: TextStyle(
                      //                     fontSize: 12.sp,
                      //                     color: Colors.grey[600]),
                      //               ),
                      //             ],
                      //           ),
                      //
                      //           // ⭐ Rating stars added here
                      //           SizedBox(height: 4.h),
                      //           buildStarRating(review
                      //               .rating), // <-- review.rating অনুযায়ী star
                      //
                      //           SizedBox(height: 4.h),
                      //           Text(
                      //             review.comment,
                      //             style: TextStyle(
                      //                 fontSize: 12.sp, color: Colors.grey[700]),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),




                  /// 🔹 REQUEST BUTTON
                  Obx(() => CustomButton(
                    height: 56,
                    width: double.infinity,
                    BoxDecoration: BoxDecoration(
                      color: controller.isUserSelected.value
                          ? AppColors.red601
                          : const Color(0xffFFEFEB),
                      borderRadius:
                      BorderRadius.circular(12),
                      border:
                      Border.all(color: AppColors.red601),
                    ),
                    child: Center(
                      child: Text(
                        "Request Booking",
                        style: TextStyle(
                          color: controller.isUserSelected.value
                              ? AppColors.FFFFFF
                              : AppColors.black900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onTap:(){
                      controller.selectRequest();

                      Get.toNamed(
                        AppRoute.requestBooking,
                        arguments: {
                          "providerId": provider.id,
                          "service": provider.service,
                        },
                      );

                    }

                  )),

                  const SizedBox(height: 20),

                  /// 🔹 MESSAGE BUTTON
                  Obx(() => CustomButton(
                    height: 56,
                    width: double.infinity,
                    BoxDecoration: BoxDecoration(
                      color: !controller.isUserSelected.value
                          ? AppColors.red601
                          : const Color(0xffFFEFEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.red601),
                    ),
                    child: Center(
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Message",
                        style: TextStyle(
                          color: !controller.isUserSelected.value
                              ? AppColors.FFFFFF
                              : AppColors.black900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onTap: () {

                      controller.selectMessage(
                        participantId: provider.id, // 👈 VERY IMPORTANT
                      );
                    },
                  )),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String icon, dynamic value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, height: 24, width: 24),
        const SizedBox(height: 6),
        Text(
          value?.toString() ?? "0",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff4C545F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff6B7280),
          ),
        ),
      ],
    );
  }

  Widget _timeBox(String time) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F6F8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff4B5563),
        ),
      ),
    );
  }

  Widget buildStarRating(double rating) {
    rating = rating.clamp(0.0, 5.0);

    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Color(0xffFF5A36), size: 16));
    }

    if (hasHalfStar) {
      stars
          .add(const Icon(Icons.star_half, color: Color(0xffFF5A36), size: 16));
    }

    int remaining = 5 - stars.length;
    for (int i = 0; i < remaining; i++) {
      stars.add(
          const Icon(Icons.star_border, color: Color(0xffD9D9D9), size: 16));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

}
