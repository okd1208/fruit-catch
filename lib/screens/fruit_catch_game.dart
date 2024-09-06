import 'package:flutter/material.dart';
import '../models/fruit.dart';  // データモデルをインポート
import '../widgets/fruit_widget.dart';  // ウィジェットをインポート
import '../utils/game_utils.dart';  // ユーティリティ関数をインポート
import 'dart:async';
import 'dart:math';

class FruitCatchGame extends StatefulWidget {
  @override
  _FruitCatchGameState createState() => _FruitCatchGameState();
}

class _FruitCatchGameState extends State<FruitCatchGame> {
  int score = 0;
  List<Fruit> fruits = [];
  bool gameStarted = false;
  bool gameOver = false;
  double elapsedTime = 0.05;
  double gravity = 9.8 / 9;
  double maxSpeed = 10.0;
  Timer? gameTimer;

  // ゲームを開始するメソッド
  void startGame() {
    setState(() {
      gameStarted = true;
      gameOver = false;
      elapsedTime = 0.05;
      score = 0;
      fruits.clear();
    });

    // 1秒ごとに果物を追加
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      addFruit();
    });

    // 50msごとに果物を落下させるタイマー
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (elapsedTime < 0.2) {
          elapsedTime += 0.001;  // 経過時間を徐々に増加
        }

        for (var fruit in fruits) {
          fruit.velocity = applyGravity(fruit.velocity, gravity, elapsedTime, fruit.mass, maxSpeed);
          fruit.y += fruit.velocity;

          // 画面下に到達したらゲームオーバー
          if (fruit.y > MediaQuery.of(context).size.height && !gameOver) {
            timer.cancel();
            handleGameOver();
            break;
          }
        }
      });
    });
  }

  // 果物を追加する
  void addFruit() {
    double startX = Random().nextDouble() * (MediaQuery.of(context).size.width - 25);  // 画面上にランダムに追加
    fruits.add(Fruit(
      type: 'apple',
      x: startX,
      y: 0.0,
      size: 50.0,
      mass: 1.0,
      velocity: 5.0,
    ));
  }

  // フルーツがタップされたときにスコアを増加して削除
  void onFruitTapped(Fruit tappedFruit) {
    setState(() {
      fruits.remove(tappedFruit);
      score += 1;
    });
  }

  // ゲームオーバー処理
  void handleGameOver() {
    gameOver = true;
    gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Score: $score'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();  // ゲームを再スタート
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Catch Game'),
      ),
      body: Stack(
        children: [
          // 果物を表示（タップ可能にする）
          ...fruits.map((fruit) => FruitWidget(fruit: fruit, onTap: () => onFruitTapped(fruit))),
          // スコア表示
          Positioned(
            top: 20,
            left: 20,
            child: Text('Score: $score', style: TextStyle(fontSize: 24)),
          ),
          // ゲーム開始ボタン
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
  }
}
