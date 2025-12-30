import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../../User Role/Home_Page/homeController.dart';
import 'ProviderPaymentSuccessfulController.dart';

class Providerpaymentsuccessful extends StatefulWidget {
  final int rating;

  const Providerpaymentsuccessful({Key? key, this.rating = 0})
      : super(key: key);

  @override
  State<Providerpaymentsuccessful> createState() =>
      _ProviderpaymentsuccessfulState();
}

class _ProviderpaymentsuccessfulState extends State<Providerpaymentsuccessful> {
  final ReviewController controller = Get.put(ReviewController());

  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;

  int userRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 76.h),
                child: Center(child: SvgPicture.asset(AppIcons.success)),
              ),
              SizedBox(height: 12.h),
              Text(
                "Payment Successful",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1F2937),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.only(
                    top: 12.h, left: 12.w, right: 10.w, bottom: 12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xff3A7DFF), width: 1.w)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.Username.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          AppString.requesthelp.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          AppString.price.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          AppString.Date.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          AppString.time.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appointment.customerName.tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          "Cleaning",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(height: 12.h),

                        /// এখানে price + (Hourly)
                        Text(
                          "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'} (Hourly)",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          appointment.date,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          "€ ${appointment.totalWorkedTime?.toStringAsFixed(2) ?? '0.00'} Hours",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    height: 24.h,
                    width: 75.w,
                    BoxDecoration: BoxDecoration(),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.download),
                        Text(
                          " Invoice",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: Color(0xffFF5A36),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(AppRoute.invoicePListPage);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                "Rate Your Experience",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1F2937),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        userRating = index + 1;
                      });
                      controller.setRating(index + 1);
                    },
                    child: Icon(
                      index < userRating ? Icons.star : Icons.star_border,
                      color: index < userRating ? Colors.orange : Colors.grey,
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 353.w,
                height: 105.h,
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Color(0xFF3A7DFF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: controller.commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your feedback",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Color(0xffFF5A36),
                ),
                child: Center(
                  child: Obx(
                    () => controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Submit",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                onTap: () async {
                  final success = await controller.submitReview(appointment);

                  if (success) {
                    Get.delete<
                        HomeController>(); //  clear review redirect guard

                    final userRole = await SharePrefsHelper.getString(
                        SharePrefsHelper.userRole);

                    if (userRole == "PROVIDER") {
                      Get.offAllNamed(AppRoute.providerHomeScreen);
                    } else {
                      Get.offAllNamed(AppRoute.homepage); // CUSTOMER
                    }

                    Get.snackbar(
                      "Success",
                      "Review submitted successfully",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
