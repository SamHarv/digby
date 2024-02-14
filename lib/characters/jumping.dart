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
    final mediaHeight = MediaQuery.of(context).size.height;
    final jumpingDigby = Image.asset('images/jump.png');
    if (direction == 'right') {
      return SizedBox(
        height: mediaHeight * size,
        child: jumpingDigby,
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: SizedBox(
          height: mediaHeight * size,
          child: jumpingDigby,
        ),
      );
    }
  }
}
