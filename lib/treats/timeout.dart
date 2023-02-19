import 'package:flutter/material.dart';

class TimeOutBar extends StatelessWidget {
  final double timeOutX;

  const TimeOutBar({super.key, required this.timeOutX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(timeOutX, 1),
      child: SizedBox(
        height: 35,
        width: 100,
        child: Image.asset('images/timeout.png'),
      ),
    );
  }
}

//(2 * timeOutX + 100) / (2 - 100)
