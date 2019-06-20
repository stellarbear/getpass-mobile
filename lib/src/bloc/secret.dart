import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:getpass/src/generator/generate.dart';
import 'package:getpass/src/infrastructure/countdownTimer.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';
import 'package:getpass/src/infrastructure/validators.dart';
import 'package:rxdart/rxdart.dart';

class SecretBloc with Validators, CountdownTimer {
  final _secretController = BehaviorSubject<String>(seedValue: '');
  String get secretValue => _secretController.value;
  Stream<String> get secretStream => _secretController.stream;
  Function(String) get secretOnChange => _secretController.sink.add;

  Future<String> generatePassword({
    Login login,
    Service service,
    int costFactor,
    int blockSizeFactor,
  }) async {
    String secret = _secretController.value;
    return await compute(
      generatePasswordImplementation,
      GenerateHandle(
        costFactor: costFactor,
        blockSizeFactor: blockSizeFactor,
        login: login,
        service: service,
        secret: secret,
      ),
    );
  }

  init() async {}

  dispose() {
    _secretController.close();
    timerDispose();
  }

  @override
  onTimerEnd() {
    //print('Debug: Secret expired');
    secretOnChange('');
  }
}

final secretBloc = SecretBloc();

enum TimerState {
  running,
  idle,
}
