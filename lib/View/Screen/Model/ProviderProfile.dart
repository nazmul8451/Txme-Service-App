import 'WorkingHours.dart';

class ProviderProfile {
  final String designation;              // ✅ ADDED
  final List<String> serviceCategory;
  final List<String> workingDays;
  final List<String> unavailableDates;
  final int hourlyRate;
  final List<String> certifications;
  final List<String> skills;              // ✅ ADDED
  final List<String> languages;
  final WorkingHours? workingHours;

  ProviderProfile({
    required this.designation,
    required this.serviceCategory,
    required this.workingDays,
    required this.unavailableDates,
    required this.hourlyRate,
    required this.certifications,
    required this.skills,
    required this.languages,
    this.workingHours,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      designation: json['designation'] ?? '',   // ✅ FIXED

      serviceCategory:
      List<String>.from(json['serviceCategory'] ?? []),

      workingDays:
      List<String>.from(json['workingDays'] ?? []),

      unavailableDates:
      List<String>.from(json['unavailableDates'] ?? []),

      hourlyRate: json['hourlyRate'] ?? 0,

      certifications:
      List<String>.from(json['certifications'] ?? []),

      skills:                                   //  FIXED
      List<String>.from(json['skills'] ?? []),

      languages:
      List<String>.from(json['languages'] ?? []),

      workingHours: json['workingHours'] != null
          ? WorkingHours.fromJson(json['workingHours'])
          : null,
    );
  }
}
