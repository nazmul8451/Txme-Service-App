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
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
