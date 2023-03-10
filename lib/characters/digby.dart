import 'dart:math';

import 'package:flutter/material.dart';

class Digby extends StatelessWidget {
  final String direction;
  final bool movement;
  final double size;

  const Digby(
      {super.key,
      required this.direction,
      required this.movement,
      required this.size});

  @override
  Widget build(BuildContext context) {
    if (direction == 'right') {
      return SizedBox(
        height: MediaQuery.of(context).size.height * size / 2,
        child: movement
            ? Image.asset('images/move.png')
            : Image.asset('images/digby.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * size / 2,
          child: movement
              ? Image.asset('images/move.png')
              : Image.asset('images/digby.png'),
        ),
      );
    }
  }
}
