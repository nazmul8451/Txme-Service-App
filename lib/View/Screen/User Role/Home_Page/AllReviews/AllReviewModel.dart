class AllReviewModel {
  final String name;
  final String profile;
  final String date;
  final double rating;
  final String comment;

  AllReviewModel({
    required this.name,
    required this.profile,
    required this.date,
    required this.rating,
    required this.comment,
  });

  factory AllReviewModel.fromJson(Map<String, dynamic> json) {
    return AllReviewModel(
      name: json["name"] ?? "",
      profile: json["profile"] ?? "",
      date: json["date"] ?? "",
      rating: (json["rating"] ?? 0).toDouble(),
      comment: json["comment"] ?? "",
    );
  }
}
