import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';

class Customcontainer extends StatelessWidget {
  final String img;
  final String cText;

  const Customcontainer({
    Key? key,
    required this.cText,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = img.startsWith('http');

    return Container(
      height: 100.h,
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.FFFFFF,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.5.h, ),
            child: isNetworkImage
                ? Image.network(
              img,
              height: 45.h,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image),
            )
                : Image.asset(
              img,
              height: 45.h,
              fit: BoxFit.contain,
            ),
          ),


          Padding(
            padding:  EdgeInsets.only(top: 15.h, left: 2.w, right: 2.w),
            child: Text(
              cText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff565656),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
