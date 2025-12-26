import 'PopularProviderModel.dart';

class PopularProviderListResponse {
  final bool success;
  final String message;
  final List<PopularProviderModel> data;

  PopularProviderListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PopularProviderListResponse.fromJson(
      Map<String, dynamic> json) {
    return PopularProviderListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => PopularProviderModel.fromJson(e))
          .toList(),
    );
  }
}
