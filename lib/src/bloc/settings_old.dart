import 'package:getpass/src/bloc/clipboard.dart';
import 'package:getpass/src/bloc/secret.dart';
import 'package:getpass/src/infrastructure/storage.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  static bool firstBootDefault = true;
  static bool visualHashDefault = true;  
  static bool autoBrightnessDefault = false;

  static int loginVisibilityDefault = 8;
  static int serviceVisibilityDefault = 8;
  static int secretTimerDurationDefault = 15;
  static int clipboardTimerDurationDefault = 60;

  static int costFactorDefault = 12;
  static int blockSizeFactorDefault = 4;

  BehaviorSubject<String> _notifyController =
      BehaviorSubject<String>(seedValue: null);
  Stream<String> get notifyStream => _notifyController.stream;
  Function(String) get notifyOnChange => _notifyController.sink.add;

  BehaviorSubject<bool> _firstBootController;
  Stream<bool> get firstBootStream => _firstBootController.stream;
  bool get firstBootValue => _firstBootController.value;
  void firstBootOnChange(bool value) {
    _firstBootController.sink.add(value);
    storage.setItem(key: storageKey.firstBoot, value: value);
  }

  BehaviorSubject<bool> _autoBrightnessController;
  Stream<bool> get autoBrightnessStream => _autoBrightnessController.stream;
  bool get autoBrightnessValue => _autoBrightnessController.value;
  void autoBrightnessOnChange(bool value) {
    _autoBrightnessController.sink.add(value);
    storage.setItem(key: storageKey.autoBrightness, value: value);
  }

  BehaviorSubject<bool> _visualHashController;
  Stream<bool> get visualHashStream => _visualHashController.stream;
  bool get visualHashValue => _visualHashController.value;
  void visualHashOnChange(bool value) {
    _visualHashController.sink.add(value);
    storage.setItem(key: storageKey.visualHash, value: value);
  }

  BehaviorSubject<int> _secretTimerDurationController;
  get secretTimerDurationStream => _secretTimerDurationController.stream;
  void secretTimerDurationOnChange(int value) {
    secretBloc.resetTimer();
    _secretTimerDurationController.sink.add(value);
    storage.setItem(key: storageKey.secretTimerDuration, value: value);
  }

  BehaviorSubject<int> _clipboardTimerDurationController;
  get clipboardTimerDurationStream => _clipboardTimerDurationController.stream;
  void clipboardTimerDurationOnChange(int value) {
    clipboardBloc.resetTimer();
    _clipboardTimerDurationController.sink.add(value);
    storage.setItem(key: storageKey.clipboardTimerDuration, value: value);
  }

  BehaviorSubject<int> _loginVisibilityController;
  get loginVisibilityStream => _loginVisibilityController.stream;
  void loginVisibilityOnChange(int value) {
    _loginVisibilityController.sink.add(value);
    storage.setItem(key: storageKey.loginVisibility, value: value);
  }

  BehaviorSubject<int> _serviceVisibilityController;
  get serviceVisibilityStream => _serviceVisibilityController.stream;
  void serviceVisibilityOnChange(int value) {
    _serviceVisibilityController.sink.add(value);
    storage.setItem(key: storageKey.serviceVisibility, value: value);
  }

  BehaviorSubject<int> _costFactorController;
  get costFactorStream => _costFactorController.stream;
  void costFactorOnChange(int value) {
    _costFactorController.sink.add(value);
    storage.setItem(key: storageKey.costFactor, value: value);
  }
  
  BehaviorSubject<int> _blockSizeFactorController;
  get blockSizeFactorStream => _blockSizeFactorController.stream;
  void blockSizeFactorOnChange(int value) {
    _blockSizeFactorController.sink.add(value);
    storage.setItem(key: storageKey.blockSizeFactor, value: value);
  }

  init() async {
    _firstBootController = BehaviorSubject<bool>(
        seedValue: storage.getItem(
            key: storageKey.firstBoot, defaultValue: firstBootDefault));

    _autoBrightnessController = BehaviorSubject<bool>(
        seedValue: storage.getItem(
            key: storageKey.autoBrightness,
            defaultValue: autoBrightnessDefault));

    _visualHashController = BehaviorSubject<bool>(
        seedValue: storage.getItem(
            key: storageKey.visualHash,
            defaultValue: visualHashDefault));

    _secretTimerDurationController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.secretTimerDuration,
            defaultValue: secretTimerDurationDefault));

    _clipboardTimerDurationController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.clipboardTimerDuration,
            defaultValue: clipboardTimerDurationDefault));

    _serviceVisibilityController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.serviceVisibility,
            defaultValue: serviceVisibilityDefault));
    _loginVisibilityController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.loginVisibility,
            defaultValue: loginVisibilityDefault));

    _costFactorController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.costFactor,
            defaultValue: costFactorDefault));
    _blockSizeFactorController = BehaviorSubject<int>(
        seedValue: storage.getItem(
            key: storageKey.blockSizeFactor,
            defaultValue: blockSizeFactorDefault));
  }

  dispose() {
    _clipboardTimerDurationController.close();
    _secretTimerDurationController.close();
    _serviceVisibilityController.close();
    _blockSizeFactorController.close();
    _loginVisibilityController.close();
    _autoBrightnessController.close();
    _costFactorController.close();
    _visualHashController.close();
    _firstBootController.close();
    _notifyController.close();
  }

  void reset() {
    clipboardTimerDurationOnChange(clipboardTimerDurationDefault);
    secretTimerDurationOnChange(secretTimerDurationDefault);
    serviceVisibilityOnChange(serviceVisibilityDefault);
    loginVisibilityOnChange(loginVisibilityDefault);
    autoBrightnessOnChange(autoBrightnessDefault);
    visualHashOnChange(visualHashDefault);
    firstBootOnChange(firstBootDefault);
  }
}

final settingsBloc = SettingsBloc();
