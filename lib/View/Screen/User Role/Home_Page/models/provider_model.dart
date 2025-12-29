import '../../../../../service/api_url.dart';

class ProviderModel {
  // ===== OLD (UNCHANGED) =====
  final String id;
  final String name;
  final String service;
  final String image;
  final double rating;
  final int totalReviews;
  final int experience;
  final double hourlyRate;
  final List<String> skills;
  final List<String> workingDays;
  final String availableFrom;
  final String availableTo;
  final String bio;
  final String address;
  final bool isVerified;

  // ===== NEW =====
  final List<DateTime>? unavailableDates;
  final List<String> serviceCategories;
  final List<String> languages;
  final List<String> certifications;
  final DateTime? dateOfBirth;
  final String gender;
  final String nationality;
  final int workingDuration;

  ProviderModel({
    required this.id,
    required this.name,
    required this.service,
    required this.image, // ❗ unchanged
    required this.rating,
    required this.totalReviews,
    required this.experience,
    required this.hourlyRate,
    required this.skills,
    required this.workingDays,
    required this.availableFrom,
    required this.availableTo,
    required this.bio,
    required this.address,
    required this.isVerified,
    required this.unavailableDates,
    required this.serviceCategories,
    required this.languages,
    required this.certifications,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.workingDuration,
  });

  /// ================= IMAGE URL GUARD =================
  String get imageUrl {
    if (image.isEmpty) {
      return "assets/images/user_placeholder.png";
    }

    if (image.startsWith('http')) {
      return image;
    }

    return "${ApiConstant.baseUrl}$image";
  }

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    final providerProfile = json['providerProfile'] ?? {};
    final workingHours = providerProfile['workingHours'] ?? {};
    final review = json['review'] ?? {};
    final residential = json['residentialAddress'] ?? {};

    return ProviderModel(
      id: json['_id'] ?? '',
      name: json['fullName'] ?? 'Unknown',

      service: providerProfile['designation'] ??
          (providerProfile['serviceCategory'] != null &&
              providerProfile['serviceCategory'].isNotEmpty
              ? providerProfile['serviceCategory'][0]
              : 'Service Provider'),

      /// 🔥 backend যা দেয় সেটাই রাখছি
      image: json['profilePicture'] ?? '',

      rating: (review['averageRating'] ?? 0).toDouble(),
      totalReviews: review['totalReviews'] ?? 0,
      experience: providerProfile['experience'] ?? 0,
      hourlyRate: (providerProfile['hourlyRate'] ?? 0).toDouble(),

      skills: providerProfile['skills'] != null
          ? List<String>.from(providerProfile['skills'])
          : [],

      workingDays: providerProfile['workingDays'] != null
          ? List<String>.from(providerProfile['workingDays'])
          : [],

      availableFrom: workingHours['startTime'] ?? '--',
      availableTo: workingHours['endTime'] ?? '--',

      bio: json['bio'] ?? 'No bio available',
      address: residential['address'] ?? 'Address not provided',
      isVerified: json['isEmailVerified'] ?? false,

      unavailableDates: providerProfile['unavailableDates'] != null
          ? (providerProfile['unavailableDates'] as List)
          .map((e) => DateTime.parse(e))
          .toList()
          : null,

      serviceCategories: providerProfile['serviceCategory'] != null
          ? List<String>.from(providerProfile['serviceCategory'])
          : [],

      languages: providerProfile['languages'] != null
          ? List<String>.from(providerProfile['languages'])
          : [],

      certifications: providerProfile['certifications'] != null
          ? List<String>.from(providerProfile['certifications'])
          : [],

      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,

      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      workingDuration: workingHours['duration'] ?? 0,
    );
  }
}
