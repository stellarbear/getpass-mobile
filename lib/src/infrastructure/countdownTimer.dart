import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class CountdownTimer {
  BehaviorSubject<int> _timerController = BehaviorSubject<int>(seedValue: 0);
  Stream<int> get timerStream => _timerController.stream;

  TimerState state = TimerState.idle;
  final Stopwatch _stopwatch = new Stopwatch();
  Duration _currentTime = Duration(seconds: 0);
  Duration _lastStartTime = Duration(seconds: 10);

  resetTimer() async {
    _currentTime = Duration(seconds: 0);
    _timerController.sink.add(0);
    state = TimerState.idle;

    _stopwatch.reset();
  }

  restartTimer({int duration}) {
    _lastStartTime = Duration(seconds: duration);
    _currentTime = _lastStartTime;
    _stopwatch.reset();
    _stopwatch.start();

    if (state != TimerState.running) {
      state = TimerState.running;
      _tick();
    }
  }

  @protected
  onTimerEnd();

  _tick() async {
    _currentTime = _lastStartTime - _stopwatch.elapsed;
    _timerController.sink.add(_currentTime.inSeconds);

    if ((_currentTime.inSeconds > 0) && (state != TimerState.idle)) {
      new Timer(const Duration(seconds: 1), _tick);
    } else {
      state = TimerState.idle;
      resetTimer();
      onTimerEnd();
    }
  }

  init() async {}

  timerDispose() {
    _timerController.close();
  }
}

enum TimerState {
  running,
  idle,
}
