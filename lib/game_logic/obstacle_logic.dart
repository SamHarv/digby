import 'dart:math';

class ObstacleLogic {
  List<double> obstacleX = [2, 3.5, 5, 6.5, 8, 9.5];
  List<double> obstacleY = [1, 1, 1, 1, 1, 1];
  List<double> obstacleHeight = [0.225, 0.19, 0.3, 0.12, 0.45, 0.075];
  List<bool> isGoblin = [false, false, false, false, true, false];
  double obstacleSpeed = 0.01;

  void shrinkObstacle(i) {
    obstacleHeight[i] = 0;
  }

  void growObstacle(i) {
    obstacleHeight[i] = Random().nextDouble() * 0.45;
  }

  void pushObstacleBackToStart(i) {
    obstacleX[i] = 7.5;
  }

  void moveObstacles() {
    for (int i = 0; i < obstacleX.length; i++) {
      obstacleX[i] -= obstacleSpeed;
      if (obstacleX[i] < -1.5) {
        // Move obstacle back to start without hitting Digby
        shrinkObstacle(i);
        pushObstacleBackToStart(i);
        growObstacle(i);
      }
    }
  }
}
