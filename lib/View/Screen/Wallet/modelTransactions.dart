class WalletTransactionModel {
  final String id;
  final double amount;
  final String type;
  final String direction;
  final String status;
  final String fromEmail;
  final String toEmail;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.direction,
    required this.status,
    required this.fromEmail,
    required this.toEmail,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['_id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
      direction: json['direction']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fromEmail: json['from']?['email']?.toString() ?? '',
      toEmail: json['to']?['email']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

}

String format24h(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  } catch (_) {
    return iso;
  }
}
