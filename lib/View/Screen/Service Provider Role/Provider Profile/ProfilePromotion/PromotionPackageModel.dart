class PromotionPackageModel {
  final String id;
  final String title;
  final String productId;
  final int durationDays;
  final int price;
  final String description;
  final bool isActive;

  PromotionPackageModel({
    required this.id,
    required this.title,
    required this.productId,
    required this.durationDays,
    required this.price,
    required this.description,
    required this.isActive,
  });

  factory PromotionPackageModel.fromJson(Map<String, dynamic> json) {
    return PromotionPackageModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      productId: json['productId'] ?? '',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
