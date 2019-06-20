import 'package:getpass/src/infrastructure/storage.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  BehaviorSubject<Settings> _settingsController;
  Observable<Settings> get settingsStream => _settingsController.stream;
  void settingsOnChange(Settings value) {
    _settingsController.sink.add(value);
    value.save();
  }

  init() async {
    _settingsController = BehaviorSubject<Settings>(seedValue: Settings.seed());
  }

  dispose() {
    _settingsController.close();
  }

  void reset() {
    settingsOnChange(Settings.byDefault());
  }
}

final settingsBloc = SettingsBloc();

class Settings {
  bool firstBoot;
  bool visualHash;
  int loginVisibility;
  int serviceVisibility;
  int secretTimerDuration;
  int clipboardTimerDuration;
  int costFactor;
  int blockSizeFactor;

  static bool firstBootDefault = true;
  static bool visualHashDefault = true;
  static int loginVisibilityDefault = 8;
  static int serviceVisibilityDefault = 8;
  static int secretTimerDurationDefault = 15;
  static int clipboardTimerDurationDefault = 60;
  static int costFactorDefault = 12;
  static int blockSizeFactorDefault = 4;

  Settings({
    this.firstBoot,
    this.visualHash,
    this.loginVisibility,
    this.serviceVisibility,
    this.secretTimerDuration,
    this.clipboardTimerDuration,
    this.costFactor,
    this.blockSizeFactor,
  });

  Settings.seed()
      : firstBoot = storage.getItem(
            key: storageKey.firstBoot, defaultValue: firstBootDefault),
        visualHash = storage.getItem(
            key: storageKey.visualHash, defaultValue: visualHashDefault),
        loginVisibility = storage.getItem(
            key: storageKey.loginVisibility,
            defaultValue: loginVisibilityDefault),
        serviceVisibility = storage.getItem(
            key: storageKey.serviceVisibility,
            defaultValue: serviceVisibilityDefault),
        secretTimerDuration = storage.getItem(
            key: storageKey.secretTimerDuration,
            defaultValue: secretTimerDurationDefault),
        clipboardTimerDuration = storage.getItem(
            key: storageKey.clipboardTimerDuration,
            defaultValue: clipboardTimerDurationDefault),
        costFactor = storage.getItem(
            key: storageKey.costFactor, defaultValue: costFactorDefault),
        blockSizeFactor = storage.getItem(
            key: storageKey.blockSizeFactor,
            defaultValue: blockSizeFactorDefault);

  void save() async {
    await storage.setItem(key: storageKey.firstBoot, value: firstBoot);
    await storage.setItem(key: storageKey.visualHash, value: visualHash);
    await storage.setItem(
        key: storageKey.loginVisibility, value: loginVisibility);
    await storage.setItem(
        key: storageKey.serviceVisibility, value: serviceVisibility);
    await storage.setItem(
        key: storageKey.secretTimerDuration, value: secretTimerDuration);
    await storage.setItem(
        key: storageKey.clipboardTimerDuration, value: clipboardTimerDuration);
    await storage.setItem(key: storageKey.costFactor, value: costFactor);
    await storage.setItem(
        key: storageKey.blockSizeFactor, value: blockSizeFactor);
  }

  Settings copyWith({
    bool firstBoot,
    bool visualHash,
    int loginVisibility,
    int serviceVisibility,
    int secretTimerDuration,
    int clipboardTimerDuration,
    int costFactor,
    int blockSizeFactor,
  }) {
    return Settings(
      firstBoot: firstBoot ?? this.firstBoot,
      visualHash: visualHash ?? this.visualHash,
      loginVisibility: loginVisibility ?? this.loginVisibility,
      serviceVisibility: serviceVisibility ?? this.serviceVisibility,
      secretTimerDuration: secretTimerDuration ?? this.secretTimerDuration,
      clipboardTimerDuration:
          clipboardTimerDuration ?? this.clipboardTimerDuration,
      costFactor: costFactor ?? this.costFactor,
      blockSizeFactor: blockSizeFactor ?? this.blockSizeFactor,
    );
  }

  static Settings byDefault() => new Settings(
        firstBoot: firstBootDefault,
        visualHash: visualHashDefault,
        loginVisibility: loginVisibilityDefault,
        serviceVisibility: serviceVisibilityDefault,
        secretTimerDuration: secretTimerDurationDefault,
        clipboardTimerDuration: clipboardTimerDurationDefault,
        costFactor: costFactorDefault,
        blockSizeFactor: blockSizeFactorDefault,
      );

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      firstBoot: json['firstBoot'],
      visualHash: json['visualHash'],
      loginVisibility: json['loginVisibility'],
      serviceVisibility: json['serviceVisibility'],
      secretTimerDuration: json['secretTimerDuration'],
      clipboardTimerDuration: json['clipboardTimerDuration'],
      costFactor: json['costFactor'],
      blockSizeFactor: json['blockSizeFactor'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstBoot': firstBoot,
        'visualHash': visualHash,
        'loginVisibility': loginVisibility,
        'serviceVisibility': serviceVisibility,
        'secretTimerDuration': secretTimerDuration,
        'clipboardTimerDuration': clipboardTimerDuration,
        'costFactor': costFactor,
        'blockSizeFactor': blockSizeFactor,
      };
}
