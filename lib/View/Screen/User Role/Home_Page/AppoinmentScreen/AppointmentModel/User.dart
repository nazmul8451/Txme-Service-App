import 'ProviderProfile.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String profilePicture;
  final ProviderProfile? providerProfile;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profilePicture,
    this.providerProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      profilePicture: json['profilePicture'] ?? '',
      providerProfile: json['providerProfile'] != null
          ? ProviderProfile.fromJson(json['providerProfile'])
          : null,
    );
  }
}
