import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import 'AllReviewModel.dart';
import 'AllReviewModelController.dart';


class Allreviews extends StatefulWidget {
  Allreviews({
    super.key,
  });

  @override
  State<Allreviews> createState() => _AllreviewsState();
}

class _AllreviewsState extends State<Allreviews> {
  final AllReviewModelController controller =
  Get.put(AllReviewModelController());
  bool isUserSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AppIcons.chevronleft),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 50.w),
          child: Text(
            "All Reviews",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24.sp.clamp(24, 27),
              color: Color(0xff1F2937),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isUserSelected = true;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      width: 72.w,
                      decoration: BoxDecoration(
                          color: Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: isUserSelected
                                ? AppColors.red601
                                : Colors.transparent,
                          )),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.adjustments),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("ALL",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1F2937),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isUserSelected = false;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: isUserSelected
                                ? Colors.transparent
                                : AppColors.red601,
                          )),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.switchVertical),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("Sort By",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.sp.clamp(12, 13),
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1F2937),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 21.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 85.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffD4E0EB).withOpacity(0.5),
                            blurRadius: 10.r,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text("5 Stars",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4C545F),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 85.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffD4E0EB).withOpacity(0.5),
                            blurRadius: 10.r,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text("Newest",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4C545F),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 85.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffD4E0EB).withOpacity(0.5),
                            blurRadius: 10.r,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text("Oldest",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4C545F),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.reviewList.length,
                  itemBuilder: (context, index) {
                    final review = controller.reviewList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 6.h,
                          left: 10.w,
                          right: 8.w,
                          bottom: 16.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Color(0xff3A7DFF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                /// Profile Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: review.reviewerEmail.startsWith("http")
                                      ? Image.network(
                                    review.reviewerProfile,
                                    height: 40.h,
                                    width: 40.w,
                                    fit: BoxFit.cover,
                                  )
                                      : SvgPicture.asset(
                                    AppIcons.prof,
                                    height: 40.h,
                                    width: 40.w,
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                /// Name + Date
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.reviewerName,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.sp,
                                        color: Color(0xff1F2937),
                                      ),
                                    ),
                                    Text(
                                      review.createdAt,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff4C545F),
                                      ),
                                    ),
                                  ],
                                ),

                                Spacer(),

                                /// Rating
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Color(0xffFDB937), size: 18),
                                    SizedBox(width: 4.w),
                                    Text(review.rating.toString()),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 7.h),

                            /// Comment
                            Text(
                              review.comment,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14.sp,
                                color: Color(0xff374151),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

            ],
          ),
        ),
      ),
    );
  }
}
