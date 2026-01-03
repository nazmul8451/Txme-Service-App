class WalletTransaction {
  final String id;
  final double amount;
  final String status;
  final String type;
  final String direction;
  final String from;
  final String to;
  final String createdAt;
  final String wallet;
  final String fee;

  WalletTransaction({
    required this.wallet,
    required this.id,
    required this.amount,
    required this.status,
    required this.type,
    required this.direction,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.fee,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['_id']?.toString() ?? '',
      wallet: json['wallet']?.toString() ?? '',
      fee: json['fee']?.toString() ?? '0',
      amount: json['amount'] == null
          ? 0.0
          : (json['amount'] as num).toDouble(),
      status: json['status']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      direction: json['direction']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
