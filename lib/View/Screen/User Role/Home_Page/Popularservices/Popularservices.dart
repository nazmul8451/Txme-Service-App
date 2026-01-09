import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomContainer/CustomContainer.dart';
import '../ChildService/ChildServiceScreen.dart';
import 'ServiceController.dart';

class Popularservices extends StatelessWidget {
  Popularservices({super.key});

  final ServiceController controller = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        title: Text(
          "Popular services",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1F2937),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.parentServices.isEmpty) {
          return Center(
            child: Text(
              "No services available",
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: GridView.builder(
            itemCount: controller.parentServices.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final service = controller.parentServices[index];

              // ✅ Debug: Print each service data
              debugPrint("📋 Service ${index + 1}:");
              debugPrint("   Name: ${service.name}");
              debugPrint("   Image: ${service.image}");
              debugPrint("   ImageURL: ${service.imageUrl}");

              return GestureDetector(
                onTap: () {
                  Get.to(
                        () => ChildServiceScreen(
                      parentId: service.id,
                      title: service.name,
                    ),
                  );
                },
                child: Customcontainer(
                  cText: service.name,
                  img: service.imageUrl, // ✅ Use imageUrl getter
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
