import 'package:flutter/material.dart';

class DietCoke extends StatelessWidget {
  final double dietCokeX;

  const DietCoke({
    super.key,
    required this.dietCokeX,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(dietCokeX, 1.06),
      child: SizedBox(
        height: 100,
        width: 35,
        child: Image.asset('images/dietcoke.png'),
      ),
    );
  }
}
