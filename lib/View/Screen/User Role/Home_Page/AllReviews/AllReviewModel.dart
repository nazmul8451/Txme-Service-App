class AllReviewModel {
  final String id;

  /// Reviewer
  final String reviewerId;
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerProfile;

  /// Review info
  final String service;
  final double rating;
  final String comment;
  final String createdAt; // ✅ formatted date only

  AllReviewModel({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerEmail,
    required this.reviewerProfile,
    required this.service,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory AllReviewModel.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] ?? {};

    /// ✅ Date formatting (YYYY-MM-DD)
    String formattedDate = "";
    if (json['createdAt'] != null) {
      final dateTime = DateTime.parse(json['createdAt']);
      formattedDate =
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    }

    return AllReviewModel(
      id: json['_id'] ?? '',

      reviewerId: reviewer['_id'] ?? '',
      reviewerName: reviewer['fullName'] ?? 'Anonymous',
      reviewerEmail: reviewer['email'] ?? '',
      reviewerProfile: reviewer['profilePicture'] ?? '',

      service: json['service'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: formattedDate, // ✅ only date
    );
  }
}
