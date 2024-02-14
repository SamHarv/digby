import 'package:flutter/material.dart';

class Creatine extends StatelessWidget {
  final double creatineXPosition;
  final double creatineYPosition;

  const Creatine({
    super.key,
    required this.creatineXPosition,
    this.creatineYPosition = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(creatineXPosition, creatineYPosition),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Image.asset('images/creatine.png'),
      ),
    );
  }
}
