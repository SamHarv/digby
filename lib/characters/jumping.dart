import 'dart:math';

import 'package:flutter/material.dart';

class Jumping extends StatelessWidget {
  final String direction;
  final double size;

  const Jumping({
    super.key,
    required this.direction,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == 'right') {
      return SizedBox(
        width: MediaQuery.of(context).size.height * size / 2,
        height: MediaQuery.of(context).size.height * size / 2,
        child: Image.asset('images/jump.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: SizedBox(
          width: MediaQuery.of(context).size.height * size / 2,
          height: MediaQuery.of(context).size.height * size / 2,
          child: Image.asset('images/jump.png'),
        ),
      );
    }
  }
}
