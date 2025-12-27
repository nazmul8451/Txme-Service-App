import '../../../../../../service/api_url.dart';

class AppointmentModel2 {
  final String id;
  final String displayName; // 👈 COMMON NAME (customer/provider)
  final String image;
  final String date;
  final String description;
  final String status;

  AppointmentModel2({
    required this.id,
    required this.displayName,
    required this.image,
    required this.date,
    required this.description,
    required this.status,
  });

  factory AppointmentModel2.fromJson(Map<String, dynamic> json) {
    final provider = json['provider'];
    final customer = json['customer'];

    /// -------- NAME (whoever exists) --------
    final name =
        provider?['fullName'] ??
            customer?['fullName'] ??
            "Unknown";

    /// -------- IMAGE --------
    final rawImage =
        provider?['profilePicture'] ??
            customer?['profilePicture'];

    String imageUrl = "";
    if (rawImage != null && rawImage.toString().isNotEmpty) {
      imageUrl = rawImage.toString().startsWith('http')
          ? rawImage
          : "${ApiConstant.baseUrl}$rawImage";
    }

    return AppointmentModel2(
      id: json['_id'] ?? '',
      displayName: name,
      image: imageUrl,
      date: json['date'] ?? '',
      description:
      "${json['service']} (${json['startTime']} - ${json['endTime']})",
      status: json['status'] ?? 'pending',
    );
  }
}
