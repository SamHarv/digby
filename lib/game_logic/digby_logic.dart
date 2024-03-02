import 'dart:async';

import '../custom_widgets/action_button_widget.dart';

class DigbyLogic {
  double digbyX = 0;
  double digbyY = 1;
  double digbySize = 0.2;
  double jumpHeight = 0;
  bool midJump = false;
  String direction = 'right';
  double gravity = -4.9;
  double velocity = 6;
  bool movement = false;

  void plusSizeDiby() {
    digbySize = 0.4;
    velocity = 8; // was 7
  }

  void microDigby() {
    digbySize = 0.1;
    velocity = 6;
  }

  void standardSizeDigby() {
    digbySize = 0.2;
    velocity = 6;
  }

  void jump() {
    double initialHeight = digbyY;
    if (midJump == false) {
      midJump = true;
      double time = 0;
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        time += 0.04; // higher number increases speed of jump
        jumpHeight = gravity * time * time + velocity * time;
        if (initialHeight - jumpHeight > 1) {
          midJump = false;
          digbyY = 1;
          timer.cancel();
        } else {
          digbyY = initialHeight - jumpHeight;
        }
      });
    }
  }

  void moveRight() {
    direction = 'right';
    Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) {
        if (const ActionButtonWidget(buttonWidth: 0).isHoldingButtonDown() &&
            digbyX + 0.04 < 1) {
          digbyX += 0.04;
          movement = !movement;
        } else {
          timer.cancel();
        }
      },
    );
  }

  void moveLeft() {
    direction = 'left';
    Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) {
        if (const ActionButtonWidget(buttonWidth: 0).isHoldingButtonDown() &&
            digbyX - 0.04 > -1) {
          digbyX -= 0.04;
          movement = !movement;
        } else {
          timer.cancel();
        }
      },
    );
  }
}
