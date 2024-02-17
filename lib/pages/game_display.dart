import 'dart:async';

import 'package:digby/custom_widgets/life_icon.dart';
import 'package:digby/custom_widgets/score_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/game_logic/game_play_logic.dart';
import '/data/db.dart';
import '/providers.dart';
import '/custom_widgets/app_drawer_menu.dart';
import '/custom_widgets/action_button.dart';
import '/characters/obstacle.dart';
import '/characters/digby.dart';
import '/characters/jumping.dart';
import '/power_ups/senzu.dart';
import '/power_ups/creatine.dart';
import '/power_ups/snake_oil.dart';

class GameDisplay extends ConsumerStatefulWidget {
  const GameDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameDisplayState();
}

class _GameDisplayState extends ConsumerState<GameDisplay>
    with SingleTickerProviderStateMixin {
  Color backgroundColour = Colors.black;
  bool gameModeInfinite = false;
  final highScoreBox = Hive.box('highscore');
  HighScore db = HighScore();
  GamePlayLogic gamePlayLogic = GamePlayLogic();
  late FocusNode _focusNode;

  @override
  void initState() {
    (highScoreBox.get('key') == null) ? db.createData() : db.getData();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  void goblinMotion() {
    ref.read(goblinMotionState.notifier).state =
        !ref.read(goblinMotionState.notifier).state;
  }

  void startGame() {
    gamePlayLogic.gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (gamePlayLogic.digbyDied) {
        timer.cancel();
        showDialogue();
        gamePlayLogic.digbyDied = false;
      } else {
        setState(() {
          goblinMotion();
          gamePlayLogic.startGame(gameModeInfinite);
        });
      }
    });
  }

  void showDialogue() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        gamePlayLogic.checkHighScore(db);
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: const Center(
            child: Text(
              'G A M E  O V E R\n\nWhat have you done?\n\nHe\'s dead.',
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
    gameModeInfinite = ref.watch(isInfiniteMode);
    backgroundColour = ref.watch(isDarkMode) ? Colors.black : Colors.blue;
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        // Respond to right arrow on keyboard
        if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
            event is RawKeyDownEvent &&
            (gamePlayLogic.digbyLogic.digbyX + 0.02 < 1)) {
          if (gamePlayLogic.gameHasStarted) {
            gamePlayLogic.digbyLogic.direction = 'right';
            setState(() {
              gamePlayLogic.digbyLogic.digbyX += 0.1;
              gamePlayLogic.digbyLogic.movement =
                  !gamePlayLogic.digbyLogic.movement;
              if (!gameModeInfinite) gamePlayLogic.checkPowerUps();
            });
          } else {
            startGame();
          }
          // Respond to left arrow on keyboard
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
            event is RawKeyDownEvent &&
            (gamePlayLogic.digbyLogic.digbyX - 0.02 > -1)) {
          if (gamePlayLogic.gameHasStarted) {
            gamePlayLogic.digbyLogic.direction = 'left';
            setState(() {
              gamePlayLogic.digbyLogic.digbyX -= 0.1;
              gamePlayLogic.digbyLogic.movement =
                  !gamePlayLogic.digbyLogic.movement;
              if (!gameModeInfinite) gamePlayLogic.checkPowerUps();
            });
          } else {
            startGame();
          }
          // Respond to spacebar or up arrow on keyboard
        } else if (event is RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.arrowUp)) {
          setState(() {
            gamePlayLogic.digbyJump();
          });
        }
      },
      child: Scaffold(
        drawer: AppDrawerMenu(gamePlayLogic: gamePlayLogic, ref: ref),
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
                        duration: const Duration(milliseconds: 100),
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
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          gamePlayLogic.pauseGame();
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
                      creatineXPosition: gameModeInfinite
                          ? -3
                          : gamePlayLogic.powerUpsLogic.creatineX),
                  SnakeOil(
                      snakeOilXPosition: gameModeInfinite
                          ? -3
                          : gamePlayLogic.powerUpsLogic.snakeOilX),
                  Senzu(
                      senzuXPosition: gameModeInfinite
                          ? -3
                          : gamePlayLogic.powerUpsLogic.senzuX),
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
                                for (int i = 0; i < 3; i++)
                                  LifeIcon(
                                      lives: gamePlayLogic.lives, lifeIndex: i),
                              ],
                            ),
                          ],
                        ),
                        ScoreDisplay(
                          title: 'SCORE',
                          isInfiniteMode: ref.watch(isInfiniteMode),
                          score: ref.watch(isInfiniteMode)
                              ? '0'
                              : '${gamePlayLogic.score}',
                        ),
                        ScoreDisplay(
                          title: 'HIGH SCORE',
                          isInfiniteMode: ref.watch(isInfiniteMode),
                          score: '${db.highScore}',
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
                      buttonWidth: 0.23,
                      actionIcon: Icons.arrow_back,
                    ),
                    ActionButton(
                      action: gamePlayLogic.gameHasStarted
                          ? gamePlayLogic.digbyMoveRight
                          : startGame,
                      buttonWidth: 0.23,
                      actionIcon: Icons.arrow_forward,
                    ),
                    ActionButton(
                      action: gamePlayLogic.gameHasStarted
                          ? gamePlayLogic.digbyJump
                          : startGame,
                      buttonWidth: 0.48,
                      actionIcon: Icons.arrow_upward,
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
