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
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../DetailsPage/ProvidersDetailsPage.dart';
import '../models/provider_model.dart';
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
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        if (controller.isMoreLoading.value) {
          return Padding(
            padding: EdgeInsets.all(12.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.totalPage <= 1) {
          return const SizedBox();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.FFFFFF,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// ◀️ PREVIOUS
              CustomButton(
                height: 44.h,
                width: 140.w,
                BoxDecoration: BoxDecoration(
                  border: Border.all(
                    color: controller.page > 1
                        ? AppColors.red601
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.page > 1
                          ? AppColors.red601
                          : Colors.grey,
                    ),
                  ),
                ),
                onTap: controller.page > 1
                    ? () {
                  controller.page--;
                  controller.fetchPopularProviders();
                }
                    : null,
              ),

              /// NEXT ▶️
              CustomButton(
                height: 44.h,
                width: 140.w,
                BoxDecoration: BoxDecoration(
                  color: controller.page < controller.totalPage
                      ? AppColors.red601
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: controller.page < controller.totalPage
                    ? () {
                  controller.page++;
                  controller.fetchPopularProviders();
                }
                    : null,
              ),
            ],
          ),
        );
      }),


    );

  }

  Widget _providerCard(ProviderModel provider) {
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
                  foregroundImage: provider.imageUrl.isNotEmpty
                      ? NetworkImage(provider.image)
                      : null,
                ),

              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 8.w),
                    child: Text(
                      provider.name,
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
                        provider.rating.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "(${provider.totalReviews} reviews)",
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
                  onTap: () {
                    Get.toNamed(
                      AppRoute.requestBooking,
                      arguments: {
                        "providerId": provider.id,
                        "service": provider.service,
                      },
                    );
                  },
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
                          () => DetailsPage(
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

