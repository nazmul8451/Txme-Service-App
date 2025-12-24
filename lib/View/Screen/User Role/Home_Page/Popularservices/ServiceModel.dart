class ServiceModel {
  final String id;
  final String name;
  final String image;
  final String? parent;

  ServiceModel({
    required this.id,
    required this.name,
    required this.image,
    this.parent,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      parent: json["parent"],
    );
  }
}
