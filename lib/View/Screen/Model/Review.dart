class Review {
  final double averageRating;
  final int totalReviews;

  Review({
    required this.averageRating,
    required this.totalReviews,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}
