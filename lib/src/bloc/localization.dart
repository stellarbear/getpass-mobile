import 'package:getpass/src/infrastructure/storage.dart';
import 'package:getpass/src/localization/eng.dart';
import 'package:getpass/src/localization/rus.dart';
import 'package:rxdart/rxdart.dart';

enum I18nLangCode { ENG, RUS }

enum I18n {
  AboutTitle,
  AboutAfterWord,
  AboutStepsTitle,
  AboutSteps,
  AboutWeb,
  AboutTipsTitle,
  AboutPlatformTitle,
  AboutTips,
  AboutBrowser,
  AboutDesktop,
  AboutMobile,
  AboutTileTitle,
  AccentColorTitle,
  AddNewLoginPlaceholder,
  AddNewLoginText,
  AddNewServicePlaceholder,
  AddNewServiceText,
  AlreadyExistingLogin,
  AlreadyExistingService,
  AppTitle,
  AutoBrightness,
  BrightnessDark,
  BrightnessLight,
  BrightnessTitle,
  Cancel,
  ChangeLanguageTitle,
  ClipboardExpirationTitle,
  ColorTileTitle,
  Dismiss,
  MigratePasswordsTitle,
  EditLoginAddFirst,
  EditLoginFilterPlaceholder,
  EditLoginTitle,
  EditServiceAddFirst,
  EditServiceFilterPlaceholder,
  EditServiceTitle,
  ExportDataTitle,
  ExportKeyPlaceholder,
  FullyVisible,
  GenerateButtonActive,
  GenerateButtonSelectLogin,
  GenerateButtonSelectService,
  GenerateButtonUpdateSecret,
  GenerationMockPageTitle,
  ImportDataPlaceholder,
  ImportDataTitle,
  ImportErrorMessage,
  ImportKeyPlaceholder,
  Loading,
  LoginTileButton,
  LoginTileMock,
  LoginTileTitle,
  LoginVisibilityEnding,
  LoginVisibilityTitle,
  MainTab,
  MainTileTitle,
  ManagementTileTitle,
  Min,
  NotifyClipboardWiped,
  NotifyExportSucceed,
  NotifyImportSucceed,
  NotifyIncompatibleParams,
  NotifyPasswordGenerated,
  NotifyPasswordsMigrated,
  OK,
  OptionCounter,
  OptionLowerCase,
  OptionNumbers,
  OptionPassLength,
  OptionSpecialChars,
  OptionUpperCase,
  PrimaryColorTitle,
  ResetDataPlaceholder,
  ResetDataTitle,
  ScryptBlockSizeFactor,
  ScryptCostFactor,
  ScryptDefault,
  ScryptTileTitle,
  ScryptTough,
  ScryptWarning,
  Sec,
  SecretTileButton,
  SecretTileMock,
  SecretTileTitle,
  SecretTimeLeft,
  SecretTimerTitle,
  ServiceTileButton,
  ServiceTileMock,
  ServiceTileTitle,
  ServiceVisibilityEnding,
  ServiceVisibilityTitle,
  SettingsTab,
  Update,
  UpdateSecretText,
  VisualHash,
  WipeClipboardTitle,
}

class LangMeta {
  String name;
  String assetPath;

  LangMeta({this.assetPath, this.name});
}

class LocalizationBloc {
  I18nLangCode languageDefaultValue = I18nLangCode.ENG;

  BehaviorSubject<I18nLangCode> _languageController;
  Stream<I18nLangCode> get languageStream => _languageController.stream;
  void languageOnChange(I18nLangCode value) {
    _languageController.sink.add(value);
    storage.setItem(key: storageKey.language, value: value.index);
  }

  String get({I18n at}) {
    return _localizedValues[_languageController.value][at] ??
        _localizedValues[languageDefaultValue][at];
  }

  LangMeta getLanguageMeta({I18nLangCode code}) {
    switch (code) {
      case I18nLangCode.RUS:
        return LangMeta(name: 'Русский', assetPath: 'rus.png');
      case I18nLangCode.ENG:
      default:
        return LangMeta(name: 'English', assetPath: 'eng.png');
    }
  }

  Map<I18nLangCode, Map<I18n, String>> _localizedValues = {
    I18nLangCode.ENG: engLocalization,
    I18nLangCode.RUS: rusLocalization,
  };

  init() async {
    _languageController = BehaviorSubject<I18nLangCode>(
        seedValue: I18nLangCode.values[storage.getItem(
            key: storageKey.language,
            defaultValue: languageDefaultValue.index)]);
  }

  dispose() {
    _languageController.close();
  }
}

final i18n = LocalizationBloc();
