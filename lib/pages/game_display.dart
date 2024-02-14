import 'dart:async';

import 'package:digby/game_logic/game_play_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '/data/db.dart';

import '/providers.dart';

import '../custom_widgets/app_drawer_menu.dart';
import '../custom_widgets/action_button.dart';

import '../characters/obstacle.dart';
import '/characters/digby.dart';
import '/characters/jumping.dart';

import '../power_ups/senzu.dart';
import '../power_ups/creatine.dart';
import '../power_ups/snake_oil.dart';

class GameDisplay extends ConsumerStatefulWidget {
  const GameDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameDisplayState();
}

class _GameDisplayState extends ConsumerState<GameDisplay>
    with SingleTickerProviderStateMixin {
  var gameFont = GoogleFonts.pressStart2p(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );
  Color backgroundColour = Colors.black;
  bool gameModeInfinite = false;
  final highScoreBox = Hive.box('highscore');
  HighScore db = HighScore();
  GamePlayLogic gamePlayLogic = GamePlayLogic();
  late FocusNode _focusNode;

  void goblinMotion() {
    ref.read(goblinMotionState.notifier).state =
        !ref.read(goblinMotionState.notifier).state;
  }

  void startGame() {
    gamePlayLogic.gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (gamePlayLogic.digbyDied) {
        timer.cancel();
        showDialogue();
        gamePlayLogic.digbyDied = false;
      } else {
        setState(() {
          goblinMotion();
          gamePlayLogic.startGame();
        });
      }
    });
  }

  @override
  void initState() {
    (highScoreBox.get('key') == null) ? db.createData() : db.getData();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  void showDialogue() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (gamePlayLogic.score > db.highScore) {
          db.highScore = gamePlayLogic.score;
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
              onTap: () {
                setState(() {
                  gamePlayLogic.resetGame();
                  Navigator.pop(context);
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ref.watch(isInfiniteMode)
        ? gameModeInfinite = true
        : gameModeInfinite = false;
    backgroundColour = ref.watch(isDarkMode) ? Colors.black : Colors.blue;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
            event is RawKeyDownEvent &&
            (gamePlayLogic.digbyLogic.digbyX + 0.02 < 1)) {
          if (gamePlayLogic.gameHasStarted) {
            gamePlayLogic.digbyLogic.direction = 'right';
            setState(() {
              gamePlayLogic.digbyLogic.digbyX += 0.1;
              gamePlayLogic.digbyLogic.movement =
                  !gamePlayLogic.digbyLogic.movement;
              gamePlayLogic.checkPowerUps();
            });
          } else {
            startGame();
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
            event is RawKeyDownEvent &&
            (gamePlayLogic.digbyLogic.digbyX - 0.02 > -1)) {
          if (gamePlayLogic.gameHasStarted) {
            gamePlayLogic.digbyLogic.direction = 'left';
            setState(() {
              gamePlayLogic.digbyLogic.digbyX -= 0.1;
              gamePlayLogic.digbyLogic.movement =
                  !gamePlayLogic.digbyLogic.movement;
              gamePlayLogic.checkPowerUps();
            });
          } else {
            startGame();
          }
        } else if (event is RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.arrowUp)) {
          setState(() {
            gamePlayLogic.digbyJump();
          });
        }
      },
      child: Scaffold(
        drawer: const AppDrawerMenu(),
        onDrawerChanged: (isClosed) {
          if (isClosed) {
            setState(() {
              gamePlayLogic.resumeGame(gamePlayLogic.pauseGameSpeed);
            });
          }
        },
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
                        alignment: Alignment(gamePlayLogic.digbyLogic.digbyX,
                            gamePlayLogic.digbyLogic.digbyY),
                        child: gamePlayLogic.digbyLogic.midJump
                            ? Jumping(
                                direction: gamePlayLogic.digbyLogic.direction,
                                size: gamePlayLogic.digbyLogic.digbySize,
                              )
                            : Digby(
                                direction: gamePlayLogic.digbyLogic.direction,
                                movement: gamePlayLogic.digbyLogic.movement,
                                size: gamePlayLogic.digbyLogic.digbySize,
                              ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _scaffoldKey.currentState?.openDrawer();
                          gamePlayLogic.pauseGame(gamePlayLogic.gameSpeed);
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
                    child: gamePlayLogic.gameHasStarted
                        ? const Text('')
                        : Text(
                            'P R E S S  A N Y  B U T T O N  T O  P L A Y',
                            style: gameFont,
                          ),
                  ),
                  for (int i = 0;
                      i < gamePlayLogic.obstacleLogic.obstacleX.length;
                      i++)
                    Obstacle(
                      obstacleXPosition:
                          gamePlayLogic.obstacleLogic.obstacleX[i],
                      obstacleYPosition:
                          gamePlayLogic.obstacleLogic.obstacleY[i],
                      obstacleHeight:
                          gamePlayLogic.obstacleLogic.obstacleHeight[i],
                      isGoblin: gamePlayLogic.obstacleLogic.isGoblin[i],
                    ),
                  Creatine(
                      creatineXPosition: gamePlayLogic.powerUpsLogic.creatineX),
                  ref.watch(isInfiniteMode)
                      ? const SnakeOil(snakeOilXPosition: -3)
                      : SnakeOil(
                          snakeOilXPosition:
                              gamePlayLogic.powerUpsLogic.snakeOilX),
                  Senzu(senzuXPosition: gamePlayLogic.powerUpsLogic.senzuX),
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
                                  gamePlayLogic.lives >= 1
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: gamePlayLogic.lives >= 1
                                      ? Colors.red
                                      : Colors.white,
                                  size: 36,
                                ),
                                Icon(
                                  gamePlayLogic.lives >= 2
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: gamePlayLogic.lives >= 2
                                      ? Colors.red
                                      : Colors.white,
                                  size: 36,
                                ),
                                Icon(
                                  gamePlayLogic.lives >= 3
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: gamePlayLogic.lives >= 3
                                      ? Colors.red
                                      : Colors.white,
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
                              ref.watch(isInfiniteMode)
                                  ? '0'
                                  : '${gamePlayLogic.score}',
                              style: ref.watch(isInfiniteMode)
                                  ? const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontFamily: 'Press Start 2P',
                                    )
                                  : gameFont,
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
                color: ref.watch(isDarkMode) ? Colors.blueGrey : Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      action: gamePlayLogic.gameHasStarted
                          ? gamePlayLogic.digbyMoveLeft
                          : startGame,
                      buttonWidth: MediaQuery.of(context).size.width * 0.23,
                      actionIcon: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    ActionButton(
                      action: gamePlayLogic.gameHasStarted
                          ? gamePlayLogic.digbyMoveRight
                          : startGame,
                      buttonWidth: MediaQuery.of(context).size.width * 0.23,
                      actionIcon: const Icon(
                        Icons.arrow_forward,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    ActionButton(
                      action: gamePlayLogic.gameHasStarted
                          ? gamePlayLogic.digbyJump
                          : startGame,
                      buttonWidth: MediaQuery.of(context).size.width * 0.48,
                      actionIcon: const Icon(
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
