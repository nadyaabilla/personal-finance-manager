import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_transaction_screen.dart';
import 'dart:convert';
import 'models/list.dart';
import 'api_service.dart';
import 'add_transaction_screen.dart'; // Import the add transaction screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];
  int totalIncome = 0;
  int totalExpense = 0;
  int balance = 0;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await http.get(Uri.parse('${ApiService.baseUrl}list.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        transactions = data.map((json) => Transaction.fromJSON(json)).toList();
        calculateTotals();
      });
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  void calculateTotals() {
    totalIncome = transactions
        .where((tx) => tx.category == 'income')
        .fold(0, (sum, tx) => sum + tx.amount);

    totalExpense = transactions
        .where((tx) => tx.category == 'expense')
        .fold(0, (sum, tx) => sum + tx.amount);

    balance = totalIncome - totalExpense;
  }

  Future<void> deleteTransaction(int index) async {
    final transactionId = transactions[index]
        .id; // Assuming your transaction model has an 'id' field
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}delete_transaction.php'),
      body: {'id': transactionId.toString()},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          transactions.removeAt(index);
          calculateTotals();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete transaction'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionScreen(),
                ),
              ).then((result) {
                if (result == true) {
                  fetchTransactions(); // Refresh the transaction list
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryCard('Total Income', totalIncome, Colors.green),
            _buildSummaryCard('Total Expense', totalExpense, Colors.red),
            _buildSummaryCard('Balance', balance, Colors.blue),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        transaction.category == 'income'
                            ? Icons.arrow_circle_up
                            : Icons.arrow_circle_down,
                        color: transaction.category == 'income'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(transaction.description),
                      subtitle: Text(transaction.date),
                      trailing: Text('Rp${transaction.amount}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditTransactionScreen(transaction: transaction),
                          ),
                        ).then((result) {
                          if (result == true) {
                            fetchTransactions(); // Refresh the transaction list
                          }
                        });
                      },
                      onLongPress: () {
                        // Implement delete transaction
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Delete Transaction'),
                            content: Text(
                                'Are you sure you want to delete this transaction?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  deleteTransaction(index);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int amount, Color color) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          title == 'Total Income'
              ? Icons.trending_up
              : title == 'Total Expense'
                  ? Icons.trending_down
                  : Icons.account_balance_wallet,
          color: color,
        ),
        title: Text(title),
        trailing: Text(
          'Rp$amount',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
