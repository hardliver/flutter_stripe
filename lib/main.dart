import 'package:flutter/material.dart';
import 'package:flutter_stripe/pages/existing-cards.dart';
import 'package:flutter_stripe/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/existing-cards': (context) => ExistingCardsPage(),
      },
    );
  }
}
