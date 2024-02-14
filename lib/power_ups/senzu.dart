import 'package:flutter/material.dart';

class Senzu extends StatelessWidget {
  final double senzuXPosition;
  final double senzuYPosition;

  const Senzu({
    super.key,
    required this.senzuXPosition,
    this.senzuYPosition = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(senzuXPosition, senzuYPosition),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Image.asset('images/senzu.png'),
      ),
    );
  }
}
