import 'dart:async';

import 'package:brain_training_app/patient/game/2048/components/countdown_timer.dart';
import 'package:brain_training_app/patient/game/2048/services/tzfe_service.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';

import 'components/button.dart';
import 'components/empty_board.dart';
import 'components/score_board.dart';
import 'components/tile_board.dart';
import 'const/colors.dart';
import 'managers/board.dart';

class TZFEGame extends ConsumerStatefulWidget {
  Level? level;
  TZFEGame({super.key, this.level = Level.Easy});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TZFEGameState();
}

class _TZFEGameState extends ConsumerState<TZFEGame>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late void Function() startGameTimer = () => {};

  //The contoller used to move the tiles
  late final AnimationController _moveController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
      //When the movement finishes merge the tiles and start the scale animation which gives the pop effect.
      if (status == AnimationStatus.completed) {
        ref.read(boardManager.notifier).merge();
        _scaleController.forward(from: 0.0);
      }
    });

  //The curve animation for the move animation controller.
  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  //The contoller used to show a popup effect when the tiles get merged
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..addStatusListener((status) {
      //When the scale animation finishes end the round and if there is a queued movement start the move controller again for the next direction.
      if (status == AnimationStatus.completed) {
        if (ref.read(boardManager.notifier).endRound()) {
          _moveController.forward(from: 0.0);
        }
      }
    });

  //The curve animation for the scale animation controller.
  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    //Add an Observer for the Lifecycles of the App

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void submitScore(int score, bool status, Duration duration) async {
    await TZFEService.submitScore(score, status ? 'win' : 'lose', duration);
  }

  Future<bool> onWillPop() async {
    // Call your method here before leaving the page
    final board = ref.watch(boardManager);
    if (board.over && board.duration != null) {
      submitScore(board.score, board.won, board.duration);
    }
    // ref.read(boardManager.notifier).newGame();
    return true; // Return true to allow popping the page, false to prevent it.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await onWillPop();
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          //Move the tile with the arrows on the keyboard on Desktop
          if (ref.read(boardManager.notifier).onKey(event)) {
            _moveController.forward(from: 0.0);
          }
        },
        child: SwipeDetector(
          onSwipe: (direction, offset) {
            if (ref.read(boardManager.notifier).move(direction)) {
              _moveController.forward(from: 0.0);
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: textColor,
                ),
                onPressed: () {
                  Get.back();
                  // ref.read(boardManager.notifier).newGame();
                },
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32.w),
                  child: CountdownTimer(
                    builder:
                        (BuildContext context, void Function() startTimer) {
                      startGameTimer = startTimer;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2048',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 52.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const ScoreBoard(),
                          const SizedBox(
                            height: 32.0,
                          ),
                          Row(
                            children: [
                              // ButtonWidget(
                              //   icon: Icons.undo,
                              //   onPressed: () {
                              //     //Undo the round.
                              //     ref.read(boardManager.notifier).undo();
                              //   },
                              // ),
                              // const SizedBox(
                              //   width: 16.0,
                              // ),
                              ButtonWidget(
                                icon: Icons.refresh,
                                onPressed: () {
                                  //Restart the game
                                  ref.read(boardManager.notifier).newGame();
                                  startGameTimer.call();
                                },
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Stack(
                  children: [
                    const EmptyBoardWidget(),
                    TileBoardWidget(
                        moveAnimation: _moveAnimation,
                        scaleAnimation: _scaleAnimation,
                        level: widget.level!,
                        startGameTimer: () {
                          startGameTimer.call();
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Save current state when the app becomes inactive
    if (state == AppLifecycleState.inactive) {
      ref.read(boardManager.notifier).save();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
