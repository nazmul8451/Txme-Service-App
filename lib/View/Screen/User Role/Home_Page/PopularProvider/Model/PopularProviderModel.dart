import '../../../../../../service/api_url.dart';
import 'PopularIdentification.dart';
import 'PopularProviderProfile.dart';
import 'PopularResidentialAddress.dart';
import 'PopularReview.dart';

class PopularProviderModel {
  final String id;
  final String fullName;
  final String service;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String? bio;
  final String? profilePicture;

  final PopularReview review;
  final PopularResidentialAddress residentialAddress;
  final PopularIdentification? identification;
  final PopularProviderProfile providerProfile;

  PopularProviderModel({
    required this.id,
    required this.fullName,
    required this.service,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.review,
    required this.residentialAddress,
    required this.providerProfile,
    this.identification,
    this.bio,
    this.profilePicture,
  });

  factory PopularProviderModel.fromJson(Map<String, dynamic> json) {
    return PopularProviderModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      bio: json['bio'],
      profilePicture: json['profilePicture'],

      /// ✅ FIXED
      service: json['service'] ?? json['designation'] ?? '',

      review: PopularReview.fromJson(json['review'] ?? {}),
      residentialAddress:
      PopularResidentialAddress.fromJson(json['residentialAddress'] ?? {}),
      identification: json['identification'] != null
          ? PopularIdentification.fromJson(json['identification'])
          : null,
      providerProfile:
      PopularProviderProfile.fromJson(json['providerProfile'] ?? {}),
    );
  }

  String get profileImageUrl {
    if (profilePicture == null || profilePicture!.isEmpty) return '';
    if (profilePicture!.startsWith('http')) return profilePicture!;
    return '${ApiConstant.baseUrl}$profilePicture';
  }
}

