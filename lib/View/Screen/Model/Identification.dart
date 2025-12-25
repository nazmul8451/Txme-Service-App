class Identification {
  final String type;
  final String value;

  Identification({
    required this.type,
    required this.value,
  });

  factory Identification.fromJson(Map<String, dynamic> json) {
    return Identification(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
