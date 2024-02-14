import 'package:flutter/material.dart';

class SnakeOil extends StatelessWidget {
  final double snakeOilXPosition;
  final double snakeOilYPosition;

  const SnakeOil({
    super.key,
    required this.snakeOilXPosition,
    this.snakeOilYPosition = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(snakeOilXPosition, snakeOilYPosition),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Image.asset('images/snake.png'),
      ),
    );
  }
}
