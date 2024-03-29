import 'dart:async';

import 'package:brain_training_app/patient/game/2048/managers/board.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimer extends ConsumerStatefulWidget {
  final TimerBuilder builder;
  CountdownTimer({super.key, required this.builder});

  @override
  ConsumerState<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends ConsumerState<CountdownTimer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const countdownDuration = Duration(minutes: 10);

  Duration duration = Duration();
  Timer? timer;

  bool isCountdown = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final board = ref.watch(boardManager);
      if (!board.over && timer == null) {
        print("board.over" + board.over.toString());
        if (board.duration != null) {
          duration = board.duration;
        }
        startTimer(resets: board.duration != null ? false : true);
        if (board.duration == null) {
          reset();
        }
      } else {
        print("HEllOOO");
        startTimer();
      }
    });

    // startTimer();
    // reset();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void reset() {
    if (isCountdown) {
      setState(() {
        duration = countdownDuration;
      });
    } else {
      setState(() {
        duration = Duration();
      });
    }
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else
        duration = Duration(seconds: seconds);

      ref.read(boardManager.notifier).setDuration(duration);
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      reset();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) reset();

    setState(() {
      timer?.cancel();
    });
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Duration get getDuration => duration;

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(boardManager);
    if (board.over) {
      stopTimer(resets: false);
    }
    widget.builder.call(context, startTimer);
    return buildTime();
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: "HOURS"),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: "MINUTES"),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: "SECONDS"),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(time, style: AppTextStyle.h1),
          ),
          SizedBox(height: 16.w),
          Text(header, style: AppTextStyle.h5)
        ],
      );
}

typedef TimerBuilder = void Function(
    BuildContext context, void Function() methodFromTimer);
