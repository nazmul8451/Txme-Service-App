import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppImg/app_img.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../../service/api_url.dart';
import '../../../../Widgegt/CustomContainer/CustomContainer.dart';
import '../ChildService/ChildServiceScreen.dart';
import 'ServiceController.dart';

class Popularservices extends StatelessWidget {
  Popularservices({super.key});

  final ServiceController controller =
  Get.put(ServiceController());

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
            color: Color(0xff1F2937),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: GridView.builder(
            itemCount: controller.parentServices.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final service =
              controller.parentServices[index];

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
                  img:
                  "${ApiConstant.baseUrl}${service.image}",
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

