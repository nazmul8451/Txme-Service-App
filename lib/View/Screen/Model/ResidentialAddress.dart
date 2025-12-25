class ResidentialAddress {
  final String address;
  final double latitude;
  final double longitude;

  ResidentialAddress({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ResidentialAddress.fromJson(Map<String, dynamic> json) {
    return ResidentialAddress(
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
