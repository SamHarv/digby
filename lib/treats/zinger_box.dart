import 'package:flutter/material.dart';

class ZingerBox extends StatelessWidget {
  final double zingerBoxX;

  const ZingerBox({super.key, required this.zingerBoxX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(zingerBoxX, 1),
      child: SizedBox(
        height: 83,
        width: 100,
        child: Image.asset('images/zingerbox.png'),
      ),
    );
  }
}
