import 'package:rxdart/rxdart.dart';

class ProgressBloc {
  BehaviorSubject<double> _progressController;
  Observable<double> get progressStream => _progressController.stream;
  Function(double) get progressOnChange => _progressController.sink.add;

  init() async {
    _progressController = BehaviorSubject<double>(seedValue: 0.0);
  }

  dispose() {
    _progressController.close();
  }
}

final progressBloc = ProgressBloc();
