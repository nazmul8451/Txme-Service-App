class ChildServiceModel {
  final String id;
  final String name;
  final String image;
  final String parent;

  ChildServiceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.parent,
  });

  factory ChildServiceModel.fromJson(Map<String, dynamic> json) {
    return ChildServiceModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      parent: json["parent"] ?? "",
    );
  }
}
