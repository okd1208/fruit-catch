import 'package:flutter/material.dart';
import 'dart:math';
import '../models/fruit.dart';

class FruitWidget extends StatefulWidget {
  final Fruit fruit;
  final VoidCallback onTap;

  const FruitWidget({Key? key, required this.fruit, required this.onTap}) : super(key: key);

  @override
  _FruitWidgetState createState() => _FruitWidgetState();
}

class _FruitWidgetState extends State<FruitWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3), // 回転の速度を調整
      vsync: this,
    )..repeat(); // 無限に回転
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.fruit.x,
      top: widget.fruit.y,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 1.0 * pi,  // 0から2π（360度）で回転
              child: child,
            );
          },
          child: Image.asset(
            'assets/${widget.fruit.type}.png',
            width: widget.fruit.size,
            height: widget.fruit.size,
          ),
        ),
      ),
    );
  }
}
