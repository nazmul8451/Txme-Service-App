import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../service/api_url.dart';
import '../../../../Widgegt/CustomContainer/CustomContainer.dart';
import 'ChildServiceController.dart';

class ChildServiceScreen extends StatelessWidget {
  final String parentId;
  final String title;

  const ChildServiceScreen({
    super.key,
    required this.parentId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(ChildServiceController(parentId));

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        title: Text(title),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.childServices.isEmpty) {
          return Center(child: Text("No services found"));
        }

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: GridView.builder(
            itemCount: controller.childServices.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final service =
              controller.childServices[index];

              return Customcontainer(
                cText: service.name,
                img:
                "${ApiConstant.baseUrl}${service.image}",
              );
            },
          ),
        );
      }),
    );
  }
}
