import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/CustomContainer/CustomContainer.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../service/api_url.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../../Service Provider Role/MyBooking/CancelBooking/CancelBooking.dart';
import '../../Service Provider Role/MyBooking/NewBookingRequest/NewBookingRequest.dart';
import 'AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import 'AppoinmentScreen/AppointmentsController.dart';
import 'ChildService/ChildServiceScreen.dart';
import 'DetailsPage/ProvidersDetailsPage.dart';
import 'PopularProvider/Model/PopularProviderModel.dart';
import 'PopularProvider/ProviderProfileDetailsPage.dart';
import 'PopularProvider/PopularProviderController.dart';
import 'Popularservices/ServiceController.dart';
import 'homeController.dart';
import 'models/provider_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final serviceController = Get.find<ServiceController>();
  final appointmentController = Get.put(AppointmentsController());
  final popularProviderController = Get.put(PopularProviderController());

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _refreshHome();
  }

  Future<void> _refreshHome() async {
    await Future.wait([
      serviceController.getParentServices(),
      popularProviderController.fetchPopularProviders(),
      appointmentController.loadData(),
      homeController.fetchUnreadNotificationCount(), //  REFRESH COUNT
    ]);

    ///  review check
    homeController.checkAgain();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return AppColors.A7DFF;
      case "confirmed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        automaticallyImplyLeading: false, //  FIXED: Removed unnecessary leading widget
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.notificationPage);
              },
              child: Obx(() => Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none, size: 30.w),
                  if(homeController.notificationCount.value > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 16.h,
                        width: 16.w,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            homeController.notificationCount.value.toString(),
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
            ),
          ),
        ],
        title: Row(
          children: [
            Text(
              AppString.Welcome,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.sp),
            ),
            Text(
              "",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      //
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        color: AppColors.A7DFF,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

                final providers = popularProviderController.providers.length > 2
                    ? popularProviderController.providers.take(2).toList()
                    : popularProviderController.providers;

                if (providers.isEmpty) {
                  return const SizedBox();
                }

                return Column(
                  children: List.generate(
                    providers.length,
                        (index) {
                      final provider = providers[index];
                      return _providerCard(provider);
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
              Obx(() {
                if (appointmentController.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                final pendingAppointments = appointmentController.appointments
                    .where((e) => e.status == "pending")
                    .take(3)
                    .toList();

                if (pendingAppointments.isEmpty) {
                  return const SizedBox();
                }

                return Column(
                  children: pendingAppointments
                      .map((appointment) => _buildCard(appointment))
                      .toList(),
                );
              }),

              SizedBox(
                height: 100.h,
              ),
            ],
          ),
        ),
      ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
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


  Widget _buildCard(AppointmentModel2 appointment) {
    final isCustomer = appointmentController.userRole.value == "CUSTOMER";
    final isProvider = appointmentController.userRole.value == "PROVIDER";
    final isPending = appointment.status.toLowerCase() == "pending";

    return GestureDetector(
      onTap: () {
        if (isProvider) {
          Get.to(() => Newbookingrequest(), arguments: appointment);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: [
            /// ================= TOP ROW =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: appointment.image.isNotEmpty
                      ? NetworkImage(appointment.image)
                      : null,
                  child: appointment.image.isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME
                      Text(
                        appointment.displayName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      /// DATE
                      Text(
                        appointment.date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      /// DESCRIPTION
                      Text(
                        appointment.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),


                /// STATUS BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color:getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            /// ================= CUSTOMER BUTTONS =================
            if (isCustomer && isPending)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    SizedBox(width: 8.w),

                    /// Cancel Button
                    GestureDetector(
                      onTap: () {
                        Get.to(
                              () => Cancelbooking(),
                          arguments: appointment,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

}