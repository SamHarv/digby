import 'package:flutter/material.dart';

class Creatine extends StatelessWidget {
  final double creatineX;
  final double size;

  const Creatine({
    super.key,
    required this.creatineX,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(creatineX, 1),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * size / 2,
        child: Image.asset('images/creatine.png'),
      ),
    );
  }
}

//(2 * timeOutX + 100) / (2 - 100)
