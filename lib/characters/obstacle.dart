import 'package:digby/characters/goblin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

const double obstacleWidth = 0.05;

class Obstacle extends ConsumerWidget {
  final double obstacleHeight;
  final double obstacleXPosition;
  final double obstacleYPosition;
  final bool isGoblin;

  const Obstacle({
    super.key,
    required this.obstacleHeight,
    required this.obstacleXPosition,
    required this.isGoblin,
    required this.obstacleYPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment(obstacleXPosition, obstacleYPosition),
      child: isGoblin
          ? const Goblin()
          : Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: ref.watch(isDarkMode) ? Colors.blueGrey : Colors.green,
              ),
              width: mediaWidth * obstacleWidth,
              height: mediaHeight * obstacleHeight,
            ),
    );
  }
}
