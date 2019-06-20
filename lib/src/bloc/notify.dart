import 'package:rxdart/rxdart.dart';

class NotifyBloc {
  BehaviorSubject<String> _notifyController =
      BehaviorSubject<String>(seedValue: null);
  Stream<String> get notifyStream => _notifyController.stream;
  Function(String) get notifyOnChange => _notifyController.sink.add;

  dispose() {
    _notifyController.close();
  }
}

final notifyBloc = NotifyBloc();
