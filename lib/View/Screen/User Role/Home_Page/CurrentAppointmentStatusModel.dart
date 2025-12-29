class CurrentAppointmentStatusModel {
  final String? status;

  CurrentAppointmentStatusModel({this.status});

  factory CurrentAppointmentStatusModel.fromJson(Map<String, dynamic> json) {
    return CurrentAppointmentStatusModel(
      status: json['data']?['status'],
    );
  }
}
