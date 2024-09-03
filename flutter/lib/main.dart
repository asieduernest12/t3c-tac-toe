import 'package:flutter/material.dart';

import 'T3cTacToeGame/t3c_tac_toe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T3c Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const T3cTacToeGame(),
    );
  }
}
