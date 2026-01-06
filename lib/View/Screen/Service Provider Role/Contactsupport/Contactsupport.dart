// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../../Utils/AppColors/app_colors.dart';
// import '../../../../Utils/AppIcons/app_icons.dart';
// import '../../../../Utils/AppImg/app_img.dart';
// import '../../../../core/App_Routes/app_routes.dart';
// import '../../../Widgegt/Custom_Button/custom_button.dart';
// import 'ContactSupportController.dart';
//
//
// class ContactSupport extends StatelessWidget {
//   ContactSupport({super.key});
//
//   final ContactSupportController controller =
//   Get.put(ContactSupportController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.FFFFFF,
//       appBar: AppBar(
//         backgroundColor: AppColors.FFFFFF,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: SvgPicture.asset(AppIcons.chevronleft),
//         ),
//         title: Text(
//           "Contact support",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w400,
//             color: const Color(0xff333333),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//
//             SizedBox(height: 40.h),
//
//             Center(
//               child: Image.asset(
//                 AppImg.contactSupport,
//                 height: 183.h,
//                 width: 174.w,
//               ),
//             ),
//
//             SizedBox(height: 20.h),
//
//             ///  Title Label
//             Text(
//               "Title",
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color:  Color(0xff4C545F),
//               ),
//             ),
//             SizedBox(height: 8.h),
//
//             ///  Title Field
//             TextField(
//               controller: controller.titleController,
//               decoration: _inputDecoration(
//                 hint: "Enter the title of your issue",
//               ),
//             ),
//
//             SizedBox(height: 20.h),
//
//             /// Message Label
//             Text(
//               "Write in bellow box",
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color:  Color(0xff4C545F),
//               ),
//             ),
//             SizedBox(height: 8.h),
//
//             ///  Message Field (Big Box)
//             TextField(
//               controller: controller.messageController,
//               maxLines: 5,
//               decoration: _inputDecoration(
//                 hint: "Write here...",
//               ),
//             ),
//
//
//             SizedBox(height: 20.h),
//             CustomButton(
//               height: 56.h,
//               width: 353.w,
//               BoxDecoration: BoxDecoration(
//                 color: AppColors.red601,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Center(
//                 child: Text(
//                   "Send",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.FFFFFF,
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 Get.toNamed(AppRoute.providerHomeScreen);
//               },
//             ),
//             SizedBox(height: 20.h),
//             CustomButton(
//               height: 56.h,
//               width: 353.w,
//               BoxDecoration: BoxDecoration(
//                 color: AppColors.FFFFFF,
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: AppColors.red601)
//               ),
//               child: Center(
//                 child: Text(
//                   "Live chat",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors. red601,
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 Get.toNamed(AppRoute.chatspage);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ///  Common Red Border InputDecoration
//   InputDecoration _inputDecoration({required String hint}) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding:
//       EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
//
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.r),
//         borderSide: BorderSide(color: Colors.red),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.r),
//         borderSide: BorderSide(color: Colors.red),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.r),
//         borderSide: BorderSide(color: Colors.red, width: 1.5),
//       ),
//     );
//   }
// }
