import 'package:hive_flutter/hive_flutter.dart';

class HighScore {
  int highScore = 0;

  final highScoreBox = Hive.box('highscore');

  void createData() {
    highScore = 0;
  }

  void getData() {
    highScore = highScoreBox.get('key');
  }

  void updateData() {
    highScoreBox.put('key', highScore);
  }
}
