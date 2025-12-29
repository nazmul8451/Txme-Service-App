import 'package:intl/intl.dart';

import '../../../../../../service/api_url.dart';
import '../../../../Model/ResidentialAddress.dart';

class AppointmentModel2 {
  final String id;

  /// ROLE BASED (opposite person)
  final String displayName;

  final String displayPersonId;

  final String customerId;
  final String providerId;

  /// ALWAYS SPECIFIC
  final String customerName;
  final String providerName;

  final String image;
  final String date;
  final String description;

  final String status;
  final String statusText;

  final ResidentialAddress? residentialAddress;

  final String? actualStartTime;
  final String? actualEndTime;
  final double? totalCost;
  final double? hourlyRate;
  final double? totalWorkedTime;

  AppointmentModel2({
    required this.customerId,
    required this.providerId,
    required this.displayPersonId,
    required this.id,
    required this.displayName,
    required this.customerName,
    required this.providerName,
    required this.image,
    required this.date,
    required this.description,
    required this.status,
    required this.statusText,
    this.residentialAddress,
    this.actualStartTime,
    this.actualEndTime,
    this.totalCost,
    this.totalWorkedTime,
    this.hourlyRate,
  });


  factory AppointmentModel2.fromJson(
      Map<String, dynamic> json, {
        required String userRole,
      }) {
    final provider = json['provider'];
    final customer = json['customer'];

    /// ================= IDS (NEW) =================
    final providerId = provider?['_id'] ?? '';
    final customerId = customer?['_id'] ?? '';

    /// ROLE BASED DISPLAY PERSON ID
    final displayPersonId =
    userRole == "CUSTOMER" ? providerId : customerId;

    /// -------- NAMES --------
    final providerName = provider?['fullName'] ?? "Unknown Provider";
    final customerName = customer?['fullName'] ?? "Unknown Customer";

    /// ROLE BASED DISPLAY NAME (আগের behavior)
    final displayName =
    userRole == "CUSTOMER" ? providerName : customerName;

    /// -------- IMAGE (opposite person) --------
    final person = userRole == "CUSTOMER" ? provider : customer;
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

    final rawStatus = json['status'] ?? 'pending';

    return AppointmentModel2(

      customerId: customerId,
      providerId: providerId,
      displayPersonId: displayPersonId,

      id: json['_id'] ?? '',
      displayName: displayName,
      customerName: customerName,
      providerName: providerName,
      image: imageUrl,
      date: "$formattedDate at $startTime",
      description: "${json['service']} ($startTime - $endTime)",

      status: rawStatus,
      statusText: _mapStatusToText(rawStatus),

      residentialAddress: address,

      hourlyRate:
      json['provider']?['providerProfile']?['hourlyRate'] != null
          ? (json['provider']['providerProfile']['hourlyRate'] as num)
          .toDouble()
          : null,

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


  /// ================= STATUS MAPPER =================
  static String _mapStatusToText(String status) {
    switch (status) {
      case "pending":
        return "Pending Request";
      case "accepted":
        return "Accepted";
      case "in_progress":
        return "Work In Progress";
      case "work_completed":
        return "Work Completed";
      case "awaiting_payment":
        return "Awaiting Payment";
      case "cashPayment":
        return "Cash Payment Initiated";
      case "cashReceived":
        return "Cash Received";
      case "review_pending":
        return "Review Pending";
      case "provider_review_pending":
        return "Provider Review Pending";
      case "customer_review_pending":
        return "Customer Review Pending";
      case "completed":
        return "Completed";
      case "cancelled":
        return "Cancelled";
      case "rejected":
        return "Rejected";
      default:
        return "Unknown Status";
    }
  }
}
