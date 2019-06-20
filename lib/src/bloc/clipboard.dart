import 'package:flutter/services.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/infrastructure/countdownTimer.dart';

class ClipboardBloc with CountdownTimer {
  init() async {}

  dispose() {
    timerDispose();
  }

  void setText({String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  onTimerEnd() async {
    //print('Debug: Clipboard wiped');
    setText(text: i18n.get(at: I18n.NotifyClipboardWiped));
  }
}

final clipboardBloc = ClipboardBloc();
