class TimeSlot {
  final String startTime;
  final String endTime;
  final DateTime date;
  final bool available;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json["startTime"],
      endTime: json["endTime"],
      date: DateTime.parse(json["date"]),
      available: json["status"] == "available",
    );
  }
}
