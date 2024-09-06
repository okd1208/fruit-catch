import 'package:flutter/material.dart';
import '../models/fruit.dart';

class FruitWidget extends StatelessWidget {
  final Fruit fruit;

  const FruitWidget({Key? key, required this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: fruit.x,
      top: fruit.y,
      child: Image.asset(
        'assets/${fruit.type}.png',  // 果物の種類に応じた画像を表示
        width: fruit.size,
        height: fruit.size,
      ),
    );
  }
}
