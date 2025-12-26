import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/CustomContainer/CustomContainer.dart';
import 'package:txme_app/View/Widgegt/CustomFavoriteProvidersContainer/CustomFavoriteProvidersContainer.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../Utils/AppColors/app_colors.dart';

import '../../../../service/api_url.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import 'ChildService/ChildServiceScreen.dart';
import 'PopularProvider/Model/PopularProviderModel.dart';
import 'PopularProvider/ProviderProfileDetailsPage.dart';
import 'PopularProvider/PopularProviderController.dart';
import 'Popularservices/ServiceController.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final serviceController = Get.find<ServiceController>();

  final popularProviderController =
  Get.put(PopularProviderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppRoute.notificationPage);
              },
              icon: Icon(Icons.notifications)),
        ],
        title: Row(
          children: [
            Text(
              AppString.Welcome,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.sp),
            ),
            Text(
              AppString.Oliver,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.r),
                  color: Color(0xffF7F7F7),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.searchfilter);
                        },
                        child: Icon(Icons.search_sharp)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            AppRoute.searchfilter); // এখানে তোমার next screen
                      },
                      child: Image.asset(AppImg.adjustments),
                    ),
                    hintText: AppString.searchServices.tr,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.popularServices.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.gray900),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.popularservices);
                    },
                    child: Text(
                      AppString.viewAll.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.A7DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                if (serviceController.isLoading.value) {
                  return CircularProgressIndicator();
                }

                final services = serviceController.parentServices.length > 6
                    ? serviceController.parentServices.take(6).toList()
                    : serviceController.parentServices;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                              () => ChildServiceScreen(
                            parentId: service.id,   //  VERY IMPORTANT
                            title: service.name,
                          ),
                        );
                      },
                      child: Customcontainer(
                        cText: service.name,
                        img: "${ApiConstant.baseUrl}${service.image}",
                      ),
                    );
                  },
                );
              }),

              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.favoriteProviders.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.gray900),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.popularprovider);
                    },
                    child: Text(
                      AppString.viewAll.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.A7DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                if (popularProviderController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final providers = popularProviderController.homeProviders;

                if (providers.isEmpty) {
                  return const SizedBox();
                }

                return Column(
                  children: List.generate(
                    providers.length,
                        (index) {
                      final provider = providers[index];
                      return _homePopularProviderCard(provider);
                    },
                  ),
                );
              }),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.upcomingAppointments.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.gray900),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.appointmentsPage);
                    },
                    child: Text(
                      AppString.viewAll.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.A7DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 353.w,
                height: 144.h,
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    /// LEFT TEXT AREA
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.w),
                            child: Text(
                              "Tomorrow, 10:00 AM",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff7C7D7E),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h, left: 20.w),
                            child: Text(
                              "Home Cleaning",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff1D1D1D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h, left: 20.w),
                            child: Text(
                              "With Sarah Miller",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff7C7D7E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT IMAGE
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            AppImg.ellipse,
                            height: 80.h,
                            width: 80.w,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _homePopularProviderCard(PopularProviderModel provider) {

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
