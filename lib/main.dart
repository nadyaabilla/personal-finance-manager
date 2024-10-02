import 'package:flutter/material.dart';
import 'package:personal_finance_manager/add_transaction_screen.dart';
import 'package:personal_finance_manager/home_screen.dart';
import 'package:personal_finance_manager/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengelola Keuangan Pribadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddTransactionScreen(),
      },
    );
  }
}
