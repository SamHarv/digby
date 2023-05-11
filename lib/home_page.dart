import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/data/db.dart';

import '/providers.dart';

import '/widgets/app_drawer.dart';
import '/widgets/button.dart';

import '/characters/obstacles.dart';
import '/characters/digby.dart';
import '/characters/jumping.dart';

import '/treats/senzu.dart';
import '/treats/creatine.dart';
import '/treats/snake_oil.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  double digbyX = 0;
  static double digbyY = 1;
  double digbySize = 0.4;
  double creatineX = 0.5;
  double creatineY = 1;
  double creatineSize = 0.35;
  double snakeOilX = -0.5;
  double snakeOilY = 1;
  double snakeOilSize = 0.35;
  bool snakeOilConsumed = false;
  double senzuX = 30;
  double senzuY = 1;
  double senzuSize = 0.35;
  double time = 0;
  double height = 0;
  double initialHeight = digbyY;
  String direction = 'right';
  double gravity = -4.9;
  double velocity = 6;
  bool movement = false;
  bool midJump = false;
  var gameFont = const TextStyle(color: Colors.white, fontSize: 20);
  int score = 0;
  final highScoreBox = Hive.box('highscore');
  HighScore db = HighScore();
  bool gameHasStarted = false;
  double gameSpeed = 0.02;
  int lives = 3;
  Color backgroundColour = Colors.black;
  static List<double> barrierX = [2, 3.5, 5, 6.5, 8, 9.5];
  static double barrierWidth = 0.1;
  List<double> barrierHeight = [0.6, 0.5, 0.8, 0.3, 1.2, 0.2];
  List<bool> isGoblin = [false, false, false, false, true, false];
  bool gameModeInfinite = false;
  bool goblinMove = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    if (highScoreBox.get('key') == null) {
      db.createData();
    } else {
      db.getData();
    }
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (digbyIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialogue();
      }
      gameModeInfinite ? snakeOilX = -3 : snakeOilX = -0.5;
      moveMap();
      hadSenzu();
      goblinMove = !goblinMove;
      time += 0.05;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= gameSpeed;
        senzuX -= 0.002;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 9;
      }
      if (senzuX < -1.5 && senzuX > -2) {
        senzuX += 9;
      }
      if (barrierX[i] < digbyX && barrierX[i] > digbyX - 0.1) {
        gameModeInfinite ? score = 0 : score += 1;
        speedUp();
      }
    }
  }

  void speedUp() {
    gameModeInfinite ? gameSpeed = 0.02 : gameSpeed += 0.0002;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      digbyX = 0;
      gameHasStarted = false;
      time = 0;
      digbyY = 1;
      creatineX = 0.5;
      snakeOilX = -0.5;
      snakeOilConsumed = false;
      senzuX = 30;
      direction = 'right';
      digbySize = 0.4;
      barrierX = [2, 3.5, 5, 6.5, 8, 9.5];
      lives = 3;
      gameSpeed = 0.02;
      score = 0;
    });
  }

  void _showDialogue() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (score > db.highScore) {
          db.highScore = score;
          db.updateData();
        } else {
          db.highScore = db.highScore;
        }
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: const Center(
            child: Text(
              'G A M E  O V E R\n\n'
              'What have you done?\n\n'
              'He\'s dead.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool digbyIsDead() {
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= digbyX + 0.02 &&
          barrierX[i] + barrierWidth >= digbyX - 0.02 &&
          digbyY >= 1 - barrierHeight[i] &&
          (digbySize == 0.4 || digbySize == 0.2) &&
          lives == 1 &&
          !gameModeInfinite) {
        HapticFeedback.vibrate();
        return true;
      } else if (barrierX[i] <= digbyX + 0.02 &&
          barrierX[i] + barrierWidth >= digbyX - 0.02 &&
          digbyY >= 1 - barrierHeight[i] &&
          digbySize == 0.4) {
        gameModeInfinite ? lives = lives : lives -= 1;
        creatineX = 0.7;
        velocity = 6;
        HapticFeedback.mediumImpact();
        gameModeInfinite
            ? barrierX = barrierX
            : barrierX = [2, 3.5, 5, 6.5, 8, 9.5];
        return false;
      } else if (barrierX[i] <= digbyX + 0.02 &&
          barrierX[i] + barrierWidth >= digbyX - 0.02 &&
          digbyY >= 1 - barrierHeight[i] &&
          digbySize == 0.8) {
        HapticFeedback.lightImpact();
        digbySize = 0.4;
        creatineX = 0.7;
        velocity = 6;
        barrierX = [2, 3.5, 5, 6.5, 8, 9.5];
        return false;
      }
    }
    return false;
  }

  void hadCreatine() {
    if ((digbyX - creatineX).abs() < 0.1 && (digbyY - creatineY).abs() < 0.05) {
      creatineX += 2;
      digbySize = 0.8;
      velocity = 7;
      snakeOilConsumed = false;
    }
  }

  void snakeOiled() {
    if ((digbyX - snakeOilX).abs() < 0.1 && (digbyY - snakeOilY).abs() < 0.07) {
      snakeOilX += 2;
      snakeOilConsumed = true;
      digbySize = 0.2;
      velocity = 6;
      lives = 1;
    }
  }

  void hadSenzu() {
    if ((digbyX - senzuX).abs() < 0.1 && (digbyY - senzuY).abs() < 0.07) {
      senzuX += -3;
      digbySize = 0.8;
      creatineX += 2;
      velocity = 7;
      lives = 3;
      gameSpeed = 0.02;
      snakeOilConsumed = false;
    }
  }

  void preJump() {
    time = 0;
    initialHeight = digbyY;
  }

  void jump() {
    if (gameHasStarted) {
      if (midJump == false) {
        midJump = true;
        preJump();
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          time += 0.05;
          height = gravity * time * time + velocity * time;
          if (initialHeight - height > 1) {
            midJump = false;
            digbyY = 1;
            timer.cancel();
          } else {
            digbyY = initialHeight - height;
          }
        });
      }
    } else {
      startGame();
    }
  }

  void moveRight() {
    direction = 'right';
    gameHasStarted
        ? Timer.periodic(const Duration(milliseconds: 20), (timer) {
            hadCreatine();
            snakeOiled();
            hadSenzu();
            if (Button(
                  buttonWidth: MediaQuery.of(context).size.width * 0.23,
                ).userIsHoldingButtonDown() &&
                digbyX + 0.02 < 1) {
              digbyX += 0.02;
              movement = !movement;
            } else {
              timer.cancel();
            }
          })
        : startGame();
  }

  void moveLeft() {
    direction = 'left';
    gameHasStarted
        ? Timer.periodic(
            const Duration(milliseconds: 20),
            (timer) {
              hadCreatine();
              snakeOiled();
              hadSenzu();
              if (Button(buttonWidth: MediaQuery.of(context).size.width * 0.23)
                      .userIsHoldingButtonDown() &&
                  digbyX - 0.02 > -1) {
                digbyX -= 0.02;
                movement = !movement;
              } else {
                timer.cancel();
              }
            },
          )
        : startGame();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkMode);
    final isInfiniteMode = ref.watch(infiniteMode);
    isInfiniteMode ? gameModeInfinite = true : gameModeInfinite = false;
    backgroundColour = isDarkMode ? Colors.black : Colors.blue;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
            event is RawKeyDownEvent &&
            (digbyX + 0.02 < 1)) {
          if (gameHasStarted) {
            direction = 'right';
            hadCreatine();
            snakeOiled();
            hadSenzu();
            digbyX += 0.1;
            movement = !movement;
          } else {
            startGame();
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
            event is RawKeyDownEvent &&
            (digbyX - 0.02 > -1)) {
          if (gameHasStarted) {
            direction = 'left';
            hadCreatine();
            snakeOiled();
            hadSenzu();
            setState(() {
              digbyX -= 0.1;
              movement = !movement;
            });
          } else {
            startGame();
          }
        } else if (event is RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.arrowUp)) {
          jump();
        }
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    color: backgroundColour,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        alignment: Alignment(digbyX, digbyY),
                        child: midJump
                            ? Jumping(
                                direction: direction,
                                size: digbySize,
                              )
                            : Digby(
                                direction: direction,
                                movement: movement,
                                size: digbySize,
                              ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _scaffoldKey.currentState?.openDrawer();
                        });
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Container(
                    alignment: const Alignment(0, 0),
                    child: gameHasStarted
                        ? const Text('')
                        : const Text(
                            'P R E S S  A N Y  B U T T O N  T O  P L A Y',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ),
                  Obstacle(
                    barrierX: barrierX[0],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[0],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[0],
                  ),
                  Obstacle(
                    barrierX: barrierX[1],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[1],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[1],
                  ),
                  Obstacle(
                    barrierX: barrierX[2],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[2],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[2],
                  ),
                  Obstacle(
                    barrierX: barrierX[3],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[3],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[3],
                  ),
                  Obstacle(
                    barrierX: barrierX[4],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[4],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[4],
                  ),
                  Obstacle(
                    barrierX: barrierX[5],
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[5],
                    goblinMove: goblinMove,
                    isGoblin: isGoblin[5],
                  ),
                  Creatine(creatineX: creatineX, size: creatineSize),
                  isInfiniteMode
                      ? SnakeOil(snakeOilX: -3, size: snakeOilSize)
                      : SnakeOil(
                          snakeOilX: snakeOilConsumed ? 1.5 : -0.5,
                          size: snakeOilSize),
                  Senzu(senzuX: senzuX, size: senzuSize),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'DIGBY',
                              style: gameFont,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  lives >= 1
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: lives >= 1 ? Colors.red : Colors.white,
                                  size: 36,
                                ),
                                Icon(
                                  lives >= 2
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: lives >= 2 ? Colors.red : Colors.white,
                                  size: 36,
                                ),
                                Icon(
                                  lives >= 3
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: lives >= 3 ? Colors.red : Colors.white,
                                  size: 36,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'SCORE',
                              style: gameFont,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isInfiniteMode ? '0' : '$score',
                              style: isInfiniteMode
                                  ? const TextStyle(
                                      color: Colors.red, fontSize: 20)
                                  : const TextStyle(
                                      color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'HIGH SCORE',
                              style: gameFont,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${db.highScore}',
                              style: gameFont,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: isDarkMode ? Colors.blueGrey : Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      function: moveLeft,
                      buttonWidth: MediaQuery.of(context).size.width * 0.23,
                      child: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Button(
                      function: moveRight,
                      buttonWidth: MediaQuery.of(context).size.width * 0.23,
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Button(
                      function: jump,
                      buttonWidth: MediaQuery.of(context).size.width * 0.48,
                      child: const Icon(
                        Icons.arrow_upward,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
