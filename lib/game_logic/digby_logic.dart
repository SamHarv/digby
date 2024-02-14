import 'dart:async';

import '../custom_widgets/action_button.dart';

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
    velocity = 7;
  }

  void microDigby() {
    digbySize = 0.1;
    velocity = 6;
  }

  void standardSizeDigby() {
    digbySize = 0.2;
    velocity = 6;
  }

  void jump(double time) {
    double initialHeight = digbyY;
    if (midJump == false) {
      midJump = true;
      time = 0;
      Timer.periodic(const Duration(milliseconds: 35), (timer) {
        time += 0.05;
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
        if (const ActionButton(buttonWidth: 0).isHoldingButtonDown() &&
            digbyX + 0.02 < 1) {
          digbyX += 0.02;
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
        if (const ActionButton(buttonWidth: 0).isHoldingButtonDown() &&
            digbyX - 0.02 > -1) {
          digbyX -= 0.02;
          movement = !movement;
        } else {
          timer.cancel();
        }
      },
    );
  }
}
