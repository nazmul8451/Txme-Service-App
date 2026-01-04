import 'dart:convert';

ProviderStats providerStatsFromJson(String str) => ProviderStats.fromJson(json.decode(str));

class ProviderStats {
    final double averageRating;
    final int totalOrders;
    final int experience;

    ProviderStats({
        required this.averageRating,
        required this.totalOrders,
        required this.experience,
    });

    factory ProviderStats.fromJson(Map<String, dynamic> json) => ProviderStats(
        averageRating: (json["averageRating"] ?? 0).toDouble(),
        totalOrders: json["totalOrders"] ?? 0,
        experience: json["experience"] ?? 0,
    );
}
