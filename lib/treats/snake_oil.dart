import 'package:flutter/material.dart';

class SnakeOil extends StatelessWidget {
  final double snakeOilX;
  final double size;

  const SnakeOil({
    super.key,
    required this.snakeOilX,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(snakeOilX, 1),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * size / 2,
        child: Image.asset('images/snake.png'),
      ),
    );
  }
}
