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
  List<Map<String, dynamic>> fruits = []; // 果物の位置とサイズを含むリスト
  bool gameStarted = false; // ゲームが開始されたかどうかを示すフラグ
  bool gameOver = false; // ゲームオーバーかどうか
  Timer? gameTimer; // ゲームのタイマー

  // ゲームを開始する
  void startGame() {
    setState(() {
      gameStarted = true;
      gameOver = false; // ゲームオーバーのフラグをリセット
    });

    // 1秒ごとに果物を追加
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      addFruit();
    });
  }

  // 果物を追加する
  void addFruit() {
    double startPositionX = Random().nextDouble() * MediaQuery.of(context).size.width;
    double fruitSize = 50; // 果物のサイズ（幅と高さ）

    setState(() {
      fruits.add({
        'x': startPositionX,
        'y': 0.0, // 果物は上から落ちる
        'size': fruitSize
      });
    });

    // 果物を下に落とすアニメーション
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var fruit in fruits) {
          fruit['y'] += 5; // 果物を下に移動させる

          // 果物が画面の下に到達した場合にゲームオーバー処理
          if (fruit['y'] > MediaQuery.of(context).size.height && !gameOver) {
            timer.cancel();
            handleGameOver();
            break; // 1つの果物でゲームオーバーになったらループを終了
          }
        }
      });
    });
  }

  // ゲームオーバーの処理
  void handleGameOver() {
    gameOver = true;
    gameTimer?.cancel(); // ゲームタイマーを停止
    showGameOverDialog(); // ゲームオーバーのダイアログを表示
  }

  // ゲームオーバーのダイアログを表示
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,  // モーダル外をタップしても閉じないように設定
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Score: $score'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fruits.clear();
                  score = 0;
                  gameStarted = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  // タップされたかどうかを確認する
  void checkTap(TapDownDetails details) {
    double tapX = details.globalPosition.dx;
    double tapY = details.globalPosition.dy;

    setState(() {
      int index = fruits.indexWhere((fruit) {
        double fruitX = fruit['x'];
        double fruitY = fruit['y'];
        double fruitSize = fruit['size'];

        // タップが果物の範囲内かどうかを判定
        return (tapX >= fruitX && tapX <= fruitX + fruitSize) &&
               (tapY >= fruitY && tapY <= fruitY + fruitSize);
      });

      if (index != -1) {
        print('Fruit at index $index removed');
        fruits.removeAt(index);
        score += 1;
      } else {
        print('Fruit not found!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Catch Game'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          double appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;

          return GestureDetector(
            onTapDown: (details) {
              double tapY = details.globalPosition.dy - appBarHeight;
              checkTap(TapDownDetails(globalPosition: Offset(details.globalPosition.dx, tapY)));
            },
            child: Stack(
              children: [
                // 果物を描画
                ...fruits.map((fruit) {
                  return Positioned(
                    left: fruit['x'],
                    top: fruit['y'],
                    child: Image.asset(
                      'assets/fruit.png',
                      width: fruit['size'],
                      height: fruit['size'],
                    ),
                  );
                }).toList(),

                // スコア表示
                Positioned(
                  top: 20,
                  left: 20,
                  child: Text('Score: $score', style: TextStyle(fontSize: 24)),
                ),

                // ゲーム開始前のスタートボタン
                if (!gameStarted)
                  Center(
                    child: ElevatedButton(
                      onPressed: startGame,
                      child: Text('Start Game'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
