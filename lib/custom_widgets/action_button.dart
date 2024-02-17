import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ActionButton extends ConsumerWidget {
  final IconData? actionIcon;
  final dynamic action;
  static bool isHoldingButton = false;
  final double buttonWidth;

  const ActionButton({
    super.key,
    this.actionIcon,
    this.action,
    required this.buttonWidth,
  });

  bool isHoldingButtonDown() {
    return isHoldingButton;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTapDown: (tapDownDetails) {
        isHoldingButton = true;
        action();
      },
      onTapUp: (tapUpDetails) {
        isHoldingButton = false;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: mediaWidth * buttonWidth,
          height:
              mediaWidth > mediaHeight ? mediaWidth * 0.07 : mediaWidth * 0.27,
          padding: const EdgeInsets.all(10),
          color:
              ref.watch(isDarkMode) ? Colors.blueGrey[300] : Colors.green[300],
          child: Icon(
            actionIcon,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
