import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/View/Widgegt/Email_Input_Field/EmailTextFieldWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/CustomCheckbox/CustomCheckbox.dart';
import 'sign_up_email_controller.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final controller = Get.put(SignUpEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: Text(
            AppString.signUn.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black700,
            ),
          ),
        ),
      ),
      body: GetBuilder<SignUpEmailController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Center(
                    child: Image.asset(
                      AppImg.image15,
                      height: 120.h,
                      width: 120.w,
                    ),
                  ),
                ),
            
                SizedBox(height: 32.h),
            
                /// Email Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextFieldE(
                    controller: controller.emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                  ),
                ),
            
                SizedBox(height: 20.h),
            
                /// Terms & Conditions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: 10.h),
                        child: CustomCheckbox(
                          value: controller.isChecked,
                          onChanged: (v) {
                            controller.onCheckChanged(v!);
                          },
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppString.Bycreating1.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: const Color(0xff1F2937),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final Uri url =
                                  Uri.parse('https://txme.nl/terms-and-conditions');

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                child: Text(
                                  AppString.Conditions.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: const Color(0xff3A7DFF),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10.w),
                              Text(
                                AppString.Bycreating2.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: const Color(0xff1F2937),
                                ),
                              ),
                              SizedBox(width: 8.w),

                              InkWell(
                                onTap: () async {
                                  final Uri url =
                                  Uri.parse('https://txme.nl/privacy-policy');

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                child: Text(
                                  AppString.PrivacyPolicy.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: const Color(0xff3A7DFF),
                                  ),
                                ),
                              ),



                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 12.h),
            
                /// Verify Email Button
                CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    color: AppColors.red601,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: controller.isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      AppString.VerifyEmail.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.FFFFFF,
                      ),
                    ),
                  ),
                  onTap: controller.isLoading
                      ? null
                      : () {
                    controller.onVerifyEmail();
                  },
                ),
            
            
                SizedBox(height: 293.h),
            
                /// Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.already.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoute.signinwithbiometrics);
                      },
                      child: Text(
                        AppString.signIn.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.A7DFF,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
