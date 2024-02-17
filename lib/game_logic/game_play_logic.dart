import 'package:digby/game_logic/digby_logic.dart';
import 'package:digby/game_logic/obstacle_logic.dart';
import 'package:digby/game_logic/power_ups_logic.dart';
import 'package:digby/pages/game_display.dart';
import 'package:flutter/services.dart';

import '../characters/obstacle.dart';

class GamePlayLogic {
  // final Ref _ref;

  int lives = 3;
  double time = 0;
  bool gameHasStarted = false;
  int score = 0;
  double gameSpeed = 0.01;
  late double pauseGameSpeed; // keeps defaulting to hardcoded value
  bool paused = false;
  bool digbyDied = false;
  bool restarted = false;

  PowerUpsLogic powerUpsLogic = PowerUpsLogic();
  GameDisplay gameDisplay = const GameDisplay();
  ObstacleLogic obstacleLogic = ObstacleLogic();
  DigbyLogic digbyLogic = DigbyLogic();

  // GamePlayLogic(this._ref);

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
    digbyLogic.jump();
  }

  void digbyMoveRight() {
    digbyLogic.moveRight();
  }

  void digbyMoveLeft() {
    digbyLogic.moveLeft();
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

  void startGame(gameModeInfinite) {
    if (gameHasStarted) {
      moveMap();
      if (!gameModeInfinite) {
        collisionDetection();
        checkPowerUps();
      }
    }
  }

  void checkHighScore(db) {
    if (score > db.highScore) {
      db.highScore = score;
      db.updateData();
    } else {
      db.highScore = db.highScore;
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
      if (obstacleCollision() && digbyLogic.digbySize <= 0.2 && lives == 1) {
        HapticFeedback.vibrate();
        decrementLives();
        digbyIsDead();
      } else if (obstacleCollision() && digbyLogic.digbySize == 0.2) {
        decrementLives();
        HapticFeedback.mediumImpact();
        obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
        digbyIsDead();
      } else if (obstacleCollision() && digbyLogic.digbySize == 0.4) {
        HapticFeedback.lightImpact();
        digbyLogic.standardSizeDigby();
        powerUpsLogic.creatineX = 0.7;
        obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
        digbyIsDead();
      }
    }
  }

  void speedUp() {
    gameSpeed += 0.00004;
  }

  void resetGame() {
    digbyLogic.digbyX = 0;
    gameHasStarted = false;
    digbyLogic.digbyY = 1;
    powerUpsLogic.creatineX = 0.5;
    powerUpsLogic.snakeOilX = -0.5;
    powerUpsLogic.senzuX = 60;
    digbyLogic.direction = 'right';
    digbyLogic.standardSizeDigby();
    obstacleLogic.obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
    replenishLives();
    digbyDied = false;
    gameSpeed = 0.01;
    pauseGameSpeed = 0.01;
    score = 0;
  }

  void saveGameSpeed() {
    if (paused) pauseGameSpeed = gameSpeed;
  }

  void pauseGame() {
    paused = true;
    saveGameSpeed();
    gameHasStarted = false;
    gameSpeed = 0;
  }

  void loadGameSpeed() {
    if (!paused) gameSpeed = pauseGameSpeed;
  }

  void resumeGame() {
    paused = false;
    gameHasStarted = true;
    loadGameSpeed();
  }

  void hadCreatine() {
    if ((digbyLogic.digbyX - powerUpsLogic.creatineX).abs() < 0.07 &&
        (digbyLogic.digbyY - 1).abs() < 0.07) {
      powerUpsLogic.hadCreatine();
      digbyLogic.plusSizeDiby();
    }
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
      gameSpeed = 0.01;
    }
  }

  void checkPowerUps() {
    hadCreatine();
    snakeOiled();
    hadSenzu();
  }
}
