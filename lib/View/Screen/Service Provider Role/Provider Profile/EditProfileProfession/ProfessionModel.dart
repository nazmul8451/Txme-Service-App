class ChildServiceModel {
  final String id;
  final String name;
  final String image;

  ChildServiceModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ChildServiceModel.fromJson(Map<String, dynamic> json) {
    return ChildServiceModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
