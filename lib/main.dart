import 'package:flutter/material.dart';
import 'screens/fruit_catch_game.dart'; // ゲーム画面をインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Catch Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FruitCatchGame(),  // 最初に表示する画面
    );
  }
}
