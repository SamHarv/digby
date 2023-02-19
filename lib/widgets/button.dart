import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class Button extends ConsumerWidget {
  final Widget? child;
  final dynamic function;
  static bool holdingButton = false;
  final double buttonWidth;

  const Button({
    super.key,
    this.child,
    this.function,
    required this.buttonWidth,
  });

  bool userIsHoldingButtonDown() {
    return holdingButton;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    return GestureDetector(
      onTapDown: (details) {
        holdingButton = true;
        function();
      },
      onTapUp: (details) {
        holdingButton = false;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: buttonWidth,
          height: MediaQuery.of(context).size.width >
                  MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.width * 0.07
              : MediaQuery.of(context).size.width * 0.27,
          padding: const EdgeInsets.all(10),
          color: isDarkMode ? Colors.blueGrey[300] : Colors.green[300],
          child: child,
        ),
      ),
    );
  }
}
