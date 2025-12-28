import 'package:intl/intl.dart';

import '../../../../../../service/api_url.dart';
import '../../../../Model/ResidentialAddress.dart';

class AppointmentModel2 {
  final String id;
  final String displayName;
  final String image;
  final String date;
  final String description;
  final String status;
  final ResidentialAddress? residentialAddress;

  final String? actualStartTime;
  final String? actualEndTime;
  final double? totalCost;
  final double? totalWorkedTime;

  AppointmentModel2({
    required this.id,
    required this.displayName,
    required this.image,
    required this.date,
    required this.description,
    required this.status,
    this.residentialAddress,

    this.actualStartTime,
    this.actualEndTime,
    this.totalCost,
    this.totalWorkedTime,



  });

  factory AppointmentModel2.fromJson(
      Map<String, dynamic> json, {
        required String userRole,
      }) {
    final provider = json['provider'];
    final customer = json['customer'];

    /// 🔥 ROLE BASED PERSON
    final person = userRole == "CUSTOMER" ? provider : customer;

    /// -------- NAME --------
    final name = person?['fullName'] ?? "Unknown";

    /// -------- IMAGE --------
    final rawImage = person?['profilePicture'];
    String imageUrl = "";

    if (rawImage != null && rawImage.toString().isNotEmpty) {
      imageUrl = rawImage.toString().startsWith('http')
          ? rawImage
          : "${ApiConstant.baseUrl}$rawImage";
    }

    /// -------- DATE --------
    String formattedDate = '';
    if (json['date'] != null) {
      final dateTime = DateTime.parse(json['date']).toLocal();
      formattedDate = DateFormat('EEEE, d MMMM').format(dateTime);
    }

    final startTime = json['startTime'] ?? '';
    final endTime = json['endTime'] ?? '';

    /// -------- ADDRESS --------
    ResidentialAddress? address;
    if (person?['residentialAddress'] != null) {
      address = ResidentialAddress.fromJson(
        person['residentialAddress'],
      );
    }

    return AppointmentModel2(
      id: json['_id'] ?? '',
      displayName: name,
      image: imageUrl,
      date: "$formattedDate at $startTime",
      description: "${json['service']} ($startTime - $endTime)",
      status: json['status'] ?? 'pending',
      residentialAddress: address,

      ///  NEW DATA MAPPING
      actualStartTime: json['actualStartTime'],
      actualEndTime: json['actualEndTime'],
      totalCost: json['totalCost'] != null
          ? (json['totalCost'] as num).toDouble()
          : null,
      totalWorkedTime: json['totalWorkedTime'] != null
          ? (json['totalWorkedTime'] as num).toDouble()
          : null,
    );
  }
}
