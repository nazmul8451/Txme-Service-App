import 'PopularWorkingHours.dart';

class PopularProviderProfile {
  final PopularWorkingHours workingHours;
  final String? designation;
  final int hourlyRate;
  final int experience;

  final List<String> serviceCategory;
  final List<String> workingDays;
  final List<String> unavailableDates;
  final List<String> skills;
  final List<String> certifications;
  final List<String> languages;

  PopularProviderProfile({
    required this.workingHours,
    this.designation,
    required this.hourlyRate,
    required this.experience,
    required this.serviceCategory,
    required this.workingDays,
    required this.unavailableDates,
    required this.skills,
    required this.certifications,
    required this.languages,
  });

  factory PopularProviderProfile.fromJson(
      Map<String, dynamic> json) {
    return PopularProviderProfile(
      workingHours: PopularWorkingHours.fromJson(
          json['workingHours'] ?? {}),
      designation: json['designation'],
      hourlyRate: json['hourlyRate'] ?? 0,
      experience: json['experience'] ?? 0,
      serviceCategory:
      List<String>.from(json['serviceCategory'] ?? []),
      workingDays:
      List<String>.from(json['workingDays'] ?? []),
      unavailableDates:
      List<String>.from(json['unavailableDates'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      certifications:
      List<String>.from(json['certifications'] ?? []),
      languages:
      List<String>.from(json['languages'] ?? []),
    );
  }
}
