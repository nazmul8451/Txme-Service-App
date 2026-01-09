import 'package:flutter/material.dart';
import '../../../../../Utils/AppImg/app_img.dart';
import '../../../../../service/api_url.dart';

class ServiceModel {
  final String id;
  final String name;
  final String image;
  final String? parent;

  ServiceModel({
    required this.id,
    required this.name,
    required this.image,
    this.parent,
  });

  /// ================= IMAGE URL GUARD =================
  String get imageUrl {
    debugPrint("🖼️ Original image value: $image");

    if (image.isEmpty) {
      debugPrint("⚠️ Image is empty, using fallback");
      return AppImg.editProfile;
    }

    if (image.startsWith('http')) {
      debugPrint("✅ Image is full URL: $image");
      return image;
    }

    final fullUrl = "${ApiConstant.baseUrl}$image";
    debugPrint("🔗 Constructed URL: $fullUrl");
    return fullUrl;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      parent: json["parent"],
    );
  }
}