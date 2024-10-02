class Transaction {
  final int id;
  final String description;
  final int amount;
  final String category;
  final String date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJSON(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      description: json['description'] ?? '',
      amount: json['amount'] != null ? int.parse(json['amount'].toString()) : 0,
      category: json['category'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
