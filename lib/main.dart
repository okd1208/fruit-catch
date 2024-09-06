import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
      home: FruitCatchGame(),
    );
  }
}

class FruitCatchGame extends StatefulWidget {
  @override
  _FruitCatchGameState createState() => _FruitCatchGameState();
}

class _FruitCatchGameState extends State<FruitCatchGame> {
  int score = 0;
  List<Widget> fruits = [];
  bool gameStarted = false; // ゲームが開始されたかどうかを示すフラグ

  void startGame() {
    setState(() {
      gameStarted = true;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      addFruit();
      checkGameOver();
    });
  }

  void addFruit() {
    double startPosition = Random().nextDouble() * MediaQuery.of(context).size.width;
    double fruitSize = 50; // 果物のサイズ（幅と高さ）

    setState(() {
      fruits.add(Positioned(
        top: 0,
        left: startPosition,
        child: GestureDetector(
          onTapDown: (details) {
            setState(() {
              // タップされた位置を取得
              double tapX = details.globalPosition.dx;
              double tapY = details.globalPosition.dy - 100;

              // 果物がクリック範囲内かどうかを確認
              int index = fruits.indexWhere((fruit) {
                // 現在の果物の位置を取得
                Positioned fruitPositioned = fruit as Positioned;
                double fruitLeft = fruitPositioned.left!;
                double fruitTop = fruitPositioned.top!;
                print(tapY);
                
                // クリックが果物の範囲内かどうかを判定
                return (tapX >= fruitLeft && tapX <= fruitLeft + fruitSize) &&
                      (tapY >= fruitTop && tapY <= fruitTop + fruitSize);
              });

              if (index != -1) {
                print('Fruit at index $index removed');
                fruits.removeAt(index);
                score += 1;
              } else {
                print('Fruit not found!');
              }
            });
          },
          child: Image.asset('assets/fruit.png', width: fruitSize, height: fruitSize),
        ),
      ));
    });
  }



  void checkGameOver() {
    // ゲームオーバー判定
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Catch Game'),
      ),
      body: Stack(
        children: [
          ...fruits,
          Positioned(
            top: 20,
            left: 20,
            child: Text('Score: $score'),
          ),
          if (!gameStarted) // ゲームが開始されていない場合にスタートボタンを表示
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                child: Text('Start Game'),
              ),
            ),
        ],
      ),
    );
  }
}
