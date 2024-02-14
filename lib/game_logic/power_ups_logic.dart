class PowerUpsLogic {
  double creatineX = 0.5;
  double snakeOilX = -0.5;
  double senzuX = 30;

  void moveSenzu() {
    senzuX -= 0.02;
  }

  void senzuTryAgain() {
    if (senzuX < -1.5) senzuX += 9;
  }

  void hadCreatine() {
    creatineX += 2;
  }

  void snakeOiled() {
    snakeOilX += 2;
  }

  void hadSenzu() {
    senzuX -= 3;
    creatineX += 2;
  }
}
