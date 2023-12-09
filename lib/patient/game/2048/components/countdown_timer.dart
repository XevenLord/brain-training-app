import 'dart:async';

import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimer extends StatefulWidget {
  final TimerBuilder builder;
  const CountdownTimer({super.key, required this.builder});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = Duration();
  Timer? timer;

  bool isCountdown = false;

  @override
  void initState() {
    startTimer();
    reset();
    super.initState();
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
  Widget build(BuildContext context) {
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
