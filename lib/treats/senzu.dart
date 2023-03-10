import 'package:flutter/material.dart';

class Senzu extends StatelessWidget {
  final double senzuX;
  final double size;

  const Senzu({
    super.key,
    required this.senzuX,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(senzuX, 1),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * size / 2,
        child: Image.asset('images/senzu.png'),
      ),
    );
  }
}
