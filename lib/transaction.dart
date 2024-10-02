class Transaction {
  final int? id;
  final String description;
  final double amount;
  final String category;
  final String date;

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      category: json['category'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }
}
