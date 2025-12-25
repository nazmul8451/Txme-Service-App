import '../../../../service/api_url.dart';
import 'Identification.dart';
import 'ProviderProfile.dart';
import 'ResidentialAddress.dart';
import 'Review.dart';

class UserModel {
  final String id;
  final String email;
  final String role;

  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool biometricEnabled;
  final bool isStripeConnected;

  final String status;
  final String fullName;
  final String gender;
  final String maritalStatus;
  final String nationality;
  final String countryOfResidence;
  final String postalAddress;
  final String profilePicture;

  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<String> idDocuments;
  final List<String> addressDocuments;

  final ResidentialAddress? residentialAddress;
  final Identification? identification;
  final Review? review;

  final ProviderProfile? providerProfile;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.biometricEnabled,
    required this.isStripeConnected,
    required this.status,
    required this.fullName,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.countryOfResidence,
    required this.postalAddress,
    required this.profilePicture,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    required this.idDocuments,
    required this.addressDocuments,
    this.residentialAddress,
    this.identification,
    this.review,
    this.providerProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',

      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      biometricEnabled: json['biometricEnabled'] ?? false,
      isStripeConnected: json['isStripeConnected'] ?? false,

      status: json['status'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      nationality: json['nationality'] ?? '',
      countryOfResidence: json['countryOfResidence'] ?? '',
      postalAddress: json['postalAddress'] ?? '',
      profilePicture: json['profilePicture'] ?? '',

      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      idDocuments: List<String>.from(json['idDocuments'] ?? []),
      addressDocuments: List<String>.from(json['addressDocuments'] ?? []),

      residentialAddress: json['residentialAddress'] != null
          ? ResidentialAddress.fromJson(json['residentialAddress'])
          : null,

      identification: json['identification'] != null
          ? Identification.fromJson(json['identification'])
          : null,

      review: json['review'] != null
          ? Review.fromJson(json['review'])
          : null,

      providerProfile:
      json['role'] == 'PROVIDER' && json['providerProfile'] != null
          ? ProviderProfile.fromJson(json['providerProfile'])
          : null,
    );
  }

  // ===================== 🔥 ADDED GETTERS 🔥 =====================

  /// ✅ FULL PROFILE IMAGE URL
  String get profileImageUrl {
    if (profilePicture.isEmpty) {
      return 'http://10.10.7.26:5002';
    }

    if (profilePicture.startsWith('http')) {
      return profilePicture;
    }

    return '${ApiConstant.baseUrl}$profilePicture';
  }

  /// ✅ DESIGNATION (safe)
  String get designation {
    return providerProfile?.designation ?? '';
  }

  /// ✅ AVERAGE REVIEW
  double get averageRating {
    return review?.averageRating ?? 0.0;
  }

  /// ✅ SKILLS (comma joined)
  String get skillsText {
    return providerProfile?.skills.join(', ') ?? '';
  }
}
