import '../../../../Model/WorkingHours.dart';

class ProviderProfile {
  final WorkingHours workingHours;
  final String designation;
  final List<String> workingDays;
  final List<DateTime> unavailableDates;
  final int hourlyRate;

  ProviderProfile({
    required this.workingHours,
    required this.designation,
    required this.workingDays,
    required this.unavailableDates,
    required this.hourlyRate,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      workingHours: WorkingHours.fromJson(json['workingHours']),
      designation: json['designation'],
      workingDays: List<String>.from(json['workingDays']),
      unavailableDates: (json['unavailableDates'] as List)
          .map((e) => DateTime.parse(e))
          .toList(),
      hourlyRate: json['hourlyRate'],
    );
  }
}
