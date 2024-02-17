class PowerUpsLogic {
  double creatineX = 0.5;
  double snakeOilX = -0.5;
  double senzuX = 60;
  bool consumedSenzu = false;

  void moveSenzu() {
    senzuX -= 0.01;
  }

  void senzuTryAgain() {
    if (senzuX < -1.5 && !consumedSenzu) senzuX += 9;
  }

  void hadCreatine() {
    creatineX += 2;
  }

  void snakeOiled() {
    snakeOilX += 2;
    creatineX += 2;
  }

  void hadSenzu() {
    consumedSenzu = true;
    senzuX -= 3;
    creatineX += 2;
  }
}
