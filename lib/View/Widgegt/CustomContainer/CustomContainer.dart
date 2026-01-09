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

    // ✅ Debug: Print image URL
    debugPrint("🖼️ Loading image: $img");
    debugPrint("📡 Is network image: $isNetworkImage");

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
            padding: EdgeInsets.only(top: 10.5.h),
            child: isNetworkImage
                ? Image.network(
              img,
              height: 45.h,
              fit: BoxFit.contain,
              // ✅ Loading indicator
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 45.h,
                  width: 45.w,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              // ✅ Better error handling
              errorBuilder: (context, error, stackTrace) {
                debugPrint("❌ Image error: $error");
                return Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            )
                : Image.asset(
              img,
              height: 45.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("❌ Asset error: $error");
                return const Icon(Icons.broken_image);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 2.w, right: 2.w),
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