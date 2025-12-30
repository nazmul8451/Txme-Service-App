// import 'User.dart';
//
// class Appointment {
//   final String id;
//   final User customer;
//   final User provider;
//   final String service;
//   final DateTime date;
//   final String startTime;
//   final String endTime;
//   final String status;
//
//   Appointment({
//     required this.id,
//     required this.customer,
//     required this.provider,
//     required this.service,
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.status,
//   });
//
//   factory Appointment.fromJson(Map<String, dynamic> json) {
//     return Appointment(
//       id: json['_id'],
//       customer: User.fromJson(json['customer']),
//       provider: User.fromJson(json['provider']),
//       service: json['service'],
//       date: DateTime.parse(json['date']),
//       startTime: json['startTime'],
//       endTime: json['endTime'],
//       status: json['status'],
//     );
//   }
// }
