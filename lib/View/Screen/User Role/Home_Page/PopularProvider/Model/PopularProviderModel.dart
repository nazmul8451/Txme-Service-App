import '../../../../../../service/api_url.dart';
import 'PopularIdentification.dart';
import 'PopularProviderProfile.dart';
import 'PopularResidentialAddress.dart';
import 'PopularReview.dart';

class PopularProviderModel {
  final String id;
  final String fullName;
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
  final List<String> addressDocuments;
  final List<String> idDocuments;

  final bool biometricEnabled;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isStripeConnected;

  final String? countryOfResidence;
  final String? nationality;
  final String? gender;
  final String? maritalStatus;
  final String? postalAddress;
  final String? stripeAccountId;
  final DateTime? dateOfBirth;

  PopularProviderModel({
    required this.id,
    required this.fullName,
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
    required this.addressDocuments,
    required this.idDocuments,
    required this.biometricEnabled,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isStripeConnected,
    this.countryOfResidence,
    this.nationality,
    this.gender,
    this.maritalStatus,
    this.postalAddress,
    this.stripeAccountId,
    this.dateOfBirth,
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

      review: PopularReview.fromJson(json['review'] ?? {}),
      residentialAddress: PopularResidentialAddress.fromJson(
          json['residentialAddress'] ?? {}),
      identification: json['identification'] != null
          ? PopularIdentification.fromJson(json['identification'])
          : null,
      providerProfile: PopularProviderProfile.fromJson(
          json['providerProfile'] ?? {}),

      addressDocuments:
      List<String>.from(json['addressDocuments'] ?? []),
      idDocuments:
      List<String>.from(json['idDocuments'] ?? []),

      biometricEnabled: json['biometricEnabled'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isStripeConnected: json['isStripeConnected'] ?? false,

      countryOfResidence: json['countryOfResidence'],
      nationality: json['nationality'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      postalAddress: json['postalAddress'],
      stripeAccountId: json['stripeAccountId'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
    );
  }

  String get profileImageUrl {
    if (profilePicture == null || profilePicture!.isEmpty) {
      return '';
    }

    if (profilePicture!.startsWith('http')) {
      return profilePicture!;
    }

    return '${ApiConstant.baseUrl}$profilePicture';
  }




}
