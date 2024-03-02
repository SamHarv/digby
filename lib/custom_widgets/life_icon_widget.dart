import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifeIconWidget extends ConsumerWidget {
  final int lives;
  final int lifeIndex;

  const LifeIconWidget({
    super.key,
    required this.lives,
    required this.lifeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Icon(
      lives >= lifeIndex + 1 ? Icons.favorite : Icons.favorite_border,
      color: lives >= lifeIndex + 1 ? Colors.red : Colors.white,
      size: 36,
    );
  }
}
