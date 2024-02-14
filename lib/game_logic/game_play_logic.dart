import 'package:digby/game_logic/digby_logic.dart';
import 'package:digby/game_logic/obstacle_logic.dart';
import 'package:digby/game_logic/power_ups_logic.dart';
import 'package:digby/pages/game_display.dart';
import 'package:flutter/services.dart';

import '../characters/obstacle.dart';

class GamePlayLogic {
  int lives = 3;
  double time = 0;
  bool gameHasStarted = false;
  int score = 0;
  double gameSpeed = 0.02;
  double pauseGameSpeed = 0.02;
  bool paused = false;
  bool gameModeInfinite = false;
  bool digbyDied = false;
  PowerUpsLogic powerUpsLogic = PowerUpsLogic();
  GameDisplay gameDisplay = const GameDisplay();
  ObstacleLogic obstacleLogic = ObstacleLogic();
  DigbyLogic digbyLogic = DigbyLogic();

  bool digbyIsDead() {
    if (lives == 0) {
      gameHasStarted = false;
      digbyDied = true;
      return true;
    } else {
      return false;
    }
  }

  void digbyJump() {
    digbyLogic.jump(time);
    checkPowerUps();
  }

  void digbyMoveRight() {
    digbyLogic.moveRight();
    checkPowerUps();
  }

  void digbyMoveLeft() {
    digbyLogic.moveLeft();
    checkPowerUps();
  }

  void moveMap() {
    obstacleLogic.moveObstacles(gameSpeed);
    powerUpsLogic.moveSenzu();
    powerUpsLogic.senzuTryAgain();
    scoreIncrement();
  }

  void scoreIncrement() {
    for (int i = 0; i < obstacleLogic.obstacleX.length; i++) {
      if (obstacleLogic.obstacleX[i] < digbyLogic.digbyX &&
          obstacleLogic.obstacleX[i] > digbyLogic.digbyX - 0.06) {
        score++;
        speedUp();
      }
    }
  }

  void startGame() {
    if (gameHasStarted) {
      moveMap();
      collisionDetection();
      time += 0.05;
    }
  }

  void decrementLives() {
    lives--;
  }

  void replenishLives() {
    lives = 3;
  }

  bool obstacleCollision() {
    for (int i = 0; i < obstacleLogic.obstacleX.length; i++) {
      if (obstacleLogic.obstacleX[i] <= digbyLogic.digbyX + 0.02 &&
          obstacleLogic.obstacleX[i] + obstacleWidth >=
              digbyLogic.digbyX - 0.02 &&
          digbyLogic.digbyY >= 1 - obstacleLogic.obstacleHeight[i]) {
        return true;
      }
    }
    return false;
  }

  void collisionDetection() {
    for (int i = 0; i < obstacleLogic.obstacleX.length; i++) {
      if (obstacleCollision() &&
          digbyLogic.digbySize <= 0.2 &&
          lives == 1 &&
          !gameModeInfinite) {
        HapticFeedback.vibrate();
        decrementLives();
        digbyIsDead();
      } else if (obstacleCollision() && digbyLogic.digbySize == 0.2) {
        gameModeInfinite ? lives = lives : decrementLives();
        powerUpsLogic.creatineX = 0.7;
        HapticFeedback.mediumImpact();
        gameModeInfinite
            ? obstacleLogic.obstacleX = obstacleLogic.obstacleX
            : obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
        digbyIsDead();
      } else if (obstacleCollision() && digbyLogic.digbySize == 0.4) {
        HapticFeedback.lightImpact();
        digbyLogic.standardSizeDigby();
        powerUpsLogic.creatineX = 0.7;
        obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
        digbyIsDead();
      }
      scoreIncrement();
    }
  }

  void speedUp() {
    gameSpeed += 0.0001;
  }

  void resetGame() {
    digbyLogic.digbyX = 0;
    gameHasStarted = false;
    time = 0;
    digbyLogic.digbyY = 1;
    powerUpsLogic.creatineX = 0.5;
    powerUpsLogic.snakeOilX = -0.5;
    powerUpsLogic.senzuX = 30;
    digbyLogic.direction = 'right';
    digbyLogic.standardSizeDigby();
    obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
    replenishLives();
    digbyDied = false;
    gameSpeed = 0.02;
    score = 0;
  }

  void saveGameSpeed(gameSpeed) {
    pauseGameSpeed = gameSpeed;
  }

  void pauseGame(gameSpeed) {
    saveGameSpeed(gameSpeed);
    paused = true;
    gameHasStarted = false;
    time = 0;
    gameSpeed = 0;
  }

  void resumeGame(pauseGameSpeed) {
    paused = false;
    gameHasStarted = true;
    gameSpeed = pauseGameSpeed;
  }

  void hadCreatine() {
    if ((digbyLogic.digbyX - powerUpsLogic.creatineX).abs() < 0.07 &&
        (digbyLogic.digbyY - 1).abs() < 0.07) {
      powerUpsLogic.hadCreatine();
      digbyLogic.plusSizeDiby();
    }
  }

  void placeSnakeOil() {
    gameModeInfinite
        ? powerUpsLogic.snakeOilX = -3
        : powerUpsLogic.snakeOilX = -0.5;
  }

  void snakeOiled() {
    if ((digbyLogic.digbyX - powerUpsLogic.snakeOilX).abs() < 0.07 &&
        (digbyLogic.digbyY - 1).abs() < 0.07) {
      powerUpsLogic.snakeOiled();
      digbyLogic.microDigby();
      lives = 1;
    }
  }

  void hadSenzu() {
    if ((digbyLogic.digbyX - powerUpsLogic.senzuX).abs() < 0.07 &&
        (digbyLogic.digbyY - 1).abs() < 0.07) {
      powerUpsLogic.hadSenzu();
      digbyLogic.plusSizeDiby();
      replenishLives();
      gameSpeed = 0.02;
    }
  }

  void checkPowerUps() {
    hadCreatine();
    snakeOiled();
    hadSenzu();
  }
}
