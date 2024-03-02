import 'package:flutter/material.dart';

class Creatine extends StatelessWidget {
  final double xPosition;
  final double yPosition;

  const Creatine({
    super.key,
    required this.xPosition,
    this.yPosition = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(xPosition, yPosition),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Image.asset('images/creatine.png'),
      ),
    );
  }
}
