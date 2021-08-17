import 'package:flutter/material.dart';
import 'dart:async';

class StatusBar extends StatefulWidget {
  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  late final Timer _timer;
  late final DateTime _startTime;
  String _timeSinceStart = "0 seconds";

  _StatusBarState() {
    _startTime = DateTime.now();

    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          Duration diff = DateTime.now().difference(_startTime);
          int seconds = diff.inSeconds;
          int minutes = (seconds / 60).floor();
          seconds = seconds % 60;

          _timeSinceStart = (minutes > 0)
              ? minutes.toString() +
                  " minutes, " +
                  seconds.toString() +
                  " seconds"
              : seconds.toString() + " seconds";
        });
      },
    );
  }

  stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10).copyWith(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "time spend: ",
          ),
          Text(
            _timeSinceStart,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
