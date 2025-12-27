import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../Utils/AppImg/app_img.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'Model/PopularProviderModel.dart';
import 'ProviderProfileDetailsPage.dart';
import 'PopularProviderController.dart';

class Popularprovider extends StatefulWidget {
  const Popularprovider({super.key});

  @override
  State<Popularprovider> createState() => _PopularproviderState();
}

class _PopularproviderState extends State<Popularprovider> {
  late PopularProviderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PopularProviderController());
  }


  bool isUserSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        title: Text(
          "Favorite Providers",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1F2937),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AppIcons.chevronleft),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.providers.length,
                itemBuilder: (context, index) {
                  final provider = controller.providers[index];
                  return _providerCard(provider);
                },
              ),
            ),

            /// NEXT BUTTON
            Obx(() {
              if (controller.isMoreLoading.value) {
                return Padding(
                  padding: EdgeInsets.all(16.h),
                  child: const CircularProgressIndicator(),
                );
              }

              if (controller.page >= controller.totalPage) {
                return const SizedBox();
              }

              return Padding(
                padding: EdgeInsets.all(16.h),
                child: CustomButton(
                  height: 48.h,
                  width: double.infinity,
                  BoxDecoration: BoxDecoration(
                    color: AppColors.red601,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    controller.fetchPopularProviders();
                  },
                ),
              );
            }),
          ],
        );
      }),

    );
  }

  Widget _providerCard(PopularProviderModel provider) {



    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      width: 353.w,
      height: 186.h,
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h, left: 20.w),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: const AssetImage(AppImg.ellipse),
                  foregroundImage: provider.profileImageUrl.isNotEmpty
                      ? NetworkImage(provider.profileImageUrl)
                      : null,
                ),

              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 8.w),
                    child: Text(
                      provider.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: const Color(0xff1F2937),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                      SizedBox(width: 4.w),
                      Text(
                        provider.review.averageRating.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "(${provider.review.totalReviews} reviews)",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                CustomButton(
                  height: 47.h,
                  width: 153.w,
                  BoxDecoration: BoxDecoration(
                    color: AppColors.red601,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      AppString.bookNow.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: AppColors.FFFFFF,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                SizedBox(width: 8.w),
                CustomButton(
                  height: 47.h,
                  width: 153.w,
                  BoxDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.red601),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      AppString.viewProfile.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  onTap: () {
                    ///  FULL MODEL PASS
                    Get.to(
                          () => ProviderProfileDetailsPage(
                        provider: provider,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

