import 'dart:math';

import 'package:flutter/material.dart';

class Digby extends StatelessWidget {
  final String direction;
  final bool movement;
  final double size;

  const Digby({
    super.key,
    required this.direction,
    required this.movement,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final digby = Image.asset('images/digby.png');
    final movingDigby = Image.asset('images/move.png');

    if (direction == 'right') {
      return SizedBox(
        height: mediaHeight * size,
        child: movement ? movingDigby : digby,
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: SizedBox(
          height: mediaHeight * size,
          child: movement ? movingDigby : digby,
        ),
      );
    }
  }
}
