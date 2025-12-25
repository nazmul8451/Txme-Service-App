// class UserModel {
//   final String id;
//   final String email;
//   final String role;
//   final String fullName;
//   final String gender;
//   final String nationality;
//   final String maritalStatus;
//   final String profilePicture;
//   final String countryOfResidence;
//   final String postalAddress;
//   final DateTime? dateOfBirth;
//
//   final ResidentialAddress  residentialAddress;
//   final Identification  identification;
//   final ProviderProfile  providerProfile;
//
//   UserModel({
//     required this.id,
//     required this.email,
//     required this.role,
//     required this.fullName,
//     required this.gender,
//     required this.nationality,
//     required this.maritalStatus,
//     required this.profilePicture,
//     required this.countryOfResidence,
//     required this.postalAddress,
//     this.dateOfBirth,
//     this.residentialAddress,
//     this.identification,
//     this.providerProfile,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id'] ?? '',
//       email: json['email'] ?? '',
//       role: json['role'] ?? '',
//       fullName: json['fullName'] ?? '',
//       gender: json['gender'] ?? '',
//       nationality: json['nationality'] ?? '',
//       maritalStatus: json['maritalStatus'] ?? '',
//       profilePicture: json['profilePicture'] ?? '',
//       countryOfResidence: json['countryOfResidence'] ?? '',
//       postalAddress: json['postalAddress'] ?? '',
//       dateOfBirth: json['dateOfBirth'] != null
//           ? DateTime.parse(json['dateOfBirth'])
//           : null,
//
//       residentialAddress: json['residentialAddress'] != null
//           ? ResidentialAddress.fromJson(json['residentialAddress'])
//           : null,
//
//       identification: json['identification'] != null
//           ? Identification.fromJson(json['identification'])
//           : null,
//
//       // 🔥 ROLE CHECK (VERY IMPORTANT)
//       providerProfile:
//       json['role'] == 'PROVIDER' && json['providerProfile'] != null
//           ? ProviderProfile.fromJson(json['providerProfile'])
//           : null,
//     );
//   }
//
//
// }
//
// class ProviderProfile {
// }
//
// class Identification {
// }
//
// class ResidentialAddress {
// }
//
//
//
