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
      fee: json["fee"],
      wallet: json['wallet'],
      id: json['_id'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      direction: json['direction'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
