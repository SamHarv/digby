import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class Obstacle extends ConsumerWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool goblinMove;
  final bool isGoblin;

  //final size;
  const Obstacle({
    super.key,
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.goblinMove,
    required this.isGoblin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    return Container(
      alignment:
          Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), 1),
      child: isGoblin
          ? SizedBox(
              height: MediaQuery.of(context).size.height *
                  3 /
                  4 *
                  barrierHeight /
                  2,
              child: goblinMove
                  ? Image.asset('images/goblin.png')
                  : Image.asset('images/goblin2.png'),
            )
          : Container(
              color: isDarkMode ? Colors.blueGrey : Colors.green,
              width: MediaQuery.of(context).size.width * barrierWidth / 2,
              height: MediaQuery.of(context).size.height *
                  3 /
                  4 *
                  barrierHeight /
                  2,
            ),
    );
  }
}
