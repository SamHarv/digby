import 'package:digby/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Goblin extends ConsumerWidget {
  const Goblin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: mediaHeight * 0.45,
      child: ref.watch(goblinMotionState)
          ? Image.asset('images/goblin.png')
          : Image.asset('images/goblin2.png'),
    );
  }
}
