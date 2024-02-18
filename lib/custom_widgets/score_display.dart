import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers.dart';

class ScoreDisplay extends ConsumerWidget {
  final String title;
  final bool isInfiniteMode;
  final String score;
  const ScoreDisplay({
    super.key,
    required this.title,
    required this.isInfiniteMode,
    required this.score,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          title,
          style: gameFont,
        ),
        const SizedBox(height: 10),
        Text(
          score,
          style: isInfiniteMode
              ? GoogleFonts.pressStart2p(
                  textStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: "PressStart2P",
                  ),
                )
              : gameFont,
        )
      ],
    );
  }
}
