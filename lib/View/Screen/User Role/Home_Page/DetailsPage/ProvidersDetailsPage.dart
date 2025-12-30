import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/View/Screen/User%20Role/Home_Page/models/review_model.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../models/provider_model.dart';
import 'ProvidersDetailsController.dart';

class DetailsPage extends StatefulWidget {
  final ProviderModel provider;

  const DetailsPage({super.key, required this.provider});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final controller = Get.put(Providersdetailscontroller());

  bool isUserSelected = true;
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    controller.fetchAllReviews(widget.provider.id);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image Section
          Container(
            width: 393.w,
            height: 344.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
              child: widget.provider.image.startsWith("http")
                  ? Image.network(
                      widget.provider.image,
                      width: 393.w,
                      height: 344.h,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.provider.image,
                      width: 393.w,
                      height: 344.h,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4C545F)),
                ),

                Text(
                  widget.provider.service,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xff4C545F),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 20),

                // Rating / Orders / Experience

                Container(
                  width: 353.w,
                  height: 103.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray.withOpacity(0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoColumn(
                          AppImg.star, widget.provider.rating, "Rating"),
                      _infoColumn(AppImg.completed, widget.provider.experience,
                          "Orders"),
                      _infoColumn(AppImg.experience, widget.provider.experience,
                          "Years"),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Color(0xff565656),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: widget.provider.skills.map((skill) {
                        int index = widget.provider.skills.indexOf(skill);
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == widget.provider.skills.length - 1
                                  ? 0
                                  : 10.w), // last element-এর পরে gap নেই
                          child: Container(
                            height: 30.h, // fixed height
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w), // width text অনুযায়ী
                            decoration: BoxDecoration(
                              color: Color(0xffF7F7F7),
                              borderRadius: BorderRadius.circular(6.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gray.withOpacity(0.2),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff565656),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.h,
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Available",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Color(0xff4C545F)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 60.w),
                          child: Text(
                            "Rate",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Color(0xff4C545F)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF7F7F7),
                                borderRadius: BorderRadius.circular(6.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gray.withOpacity(0.2),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                widget.provider.availableFrom,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4C545F)),
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "To",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff4C545F)),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 60.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF7F7F7),
                                borderRadius: BorderRadius.circular(6.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gray.withOpacity(0.2),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                widget.provider.availableTo,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4C545F)),
                              )),
                            ),
                          ],
                        ),
                        Container(
                          width: 95.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gray.withOpacity(0.2),
                                blurRadius: 12.r,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "\$${widget.provider.hourlyRate} (Hourly)",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4C545F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(
                  height: 20.h,
                ),

                // Bio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.provider.bio,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
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
                            Get.toNamed(
                              AppRoute.allreviews,
                              arguments: widget.provider.id, // 🔥 providerId pass
                            );
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

                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (controller.reviewList.isEmpty) {
                        return Text(
                          "No reviews yet",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      final reviews = showAll
                          ? controller.reviewList
                          : controller.reviewList.take(3).toList();

                      return Column(
                        children: reviews.map((review) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: review.reviewerProfile.startsWith("http")
                                          ? Image.network(
                                        review.reviewerProfile,
                                        width: 24.w,
                                        height: 24.h,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        AppImg.editProfile,
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      review.reviewerName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                    Spacer(),
                                    Text(
                                      review.createdAt, //  formatted date
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 4.h),
                                buildStarRating(review.rating),

                                SizedBox(height: 4.h),
                                Text(
                                  review.comment,
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),


                SizedBox(
                  height: 20.h,
                ),

                CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color:
                          isUserSelected ? AppColors.red601 : Color(0xffFFEFEB),
                      border: Border.all(color: AppColors.red601, width: 1.w),
                    ),
                    child: Center(
                        child: Text(
                      "Request Booking",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isUserSelected
                            ? AppColors.FFFFFF
                            : AppColors.black900,
                      ),
                    )),
                    onTap: () {
                      Get.toNamed(
                        AppRoute.requestBooking,
                        arguments: {
                          "providerId": widget.provider.id,
                          "service": widget.provider.service,
                        },
                      );

                      setState(() {
                        isUserSelected = true;
                      });
                    }),
                SizedBox(
                  height: 20.h,
                ),

                Obx(() => CustomButton(
                      height: 56,
                      width: double.infinity,
                      BoxDecoration: BoxDecoration(
                        color: !controller.isUserSelected.value
                            ? AppColors.red601
                            : Color(0xffFFEFEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.red601),
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
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
                        setState(() {
                          isUserSelected = false;
                        });
                        controller.selectMessage(
                          participantId: widget.provider.id,
                        );
                      },
                    )),
              ],
            ),
          ),
        ],
      )),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
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

  Widget _infoColumn(String icon, dynamic value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon),
        Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }
}
