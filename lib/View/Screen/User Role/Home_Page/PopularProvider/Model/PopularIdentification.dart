class PopularIdentification {
  final String type;
  final String value;

  PopularIdentification({
    required this.type,
    required this.value,
  });

  factory PopularIdentification.fromJson(Map<String, dynamic> json) {
    return PopularIdentification(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
