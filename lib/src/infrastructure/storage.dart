import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
    //_preferences.clear();
  }

  getItem({String key, dynamic defaultValue}) {
    if (defaultValue is bool) {
      return _preferences.getBool(key) ?? defaultValue;
    } else if (defaultValue is int) {
      return _preferences.getInt(key) ?? defaultValue;
    } else if (defaultValue is double) {
      return _preferences.getDouble(key) ?? defaultValue;
    } else if (defaultValue is String) {
      return _preferences.getString(key) ?? defaultValue;
    } else if (defaultValue is List<String>) {
      return _preferences.getStringList(key) ?? defaultValue;
    }
  }

  setItem({String key, dynamic value}) async {
    if (value is bool) {
      await _preferences.setBool(key, value);
      return;
    } else if (value is int) {
      await _preferences.setInt(key, value);
      return;
    } else if (value is double) {
      await _preferences.setDouble(key, value);
      return;
    } else if (value is String) {
      await _preferences.setString(key, value);
      return;
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
      return;
    } else {
      await _preferences.setStringList(key, []);
    }
  }

  deleteItem({String key}) {
    _preferences.remove(key);
  }
}

class StorageKey {
  get language => 'language';

  get logins => 'logins';
  get services => 'services';

  get firstBoot => 'firstBoot';
  get autoBrightness => 'autoBrightness';

  get secretTimerDuration => 'secretTimerDuration';
  get clipboardTimerDuration => 'clipboardTimerDuration';

  get loginVisibility => 'loginVisibility';
  get serviceVisibility => 'serviceVisibility';

  get costFactor => 'costFactor';
  get blockSizeFactor => 'blockSizeFactor';

  get brightness => 'brightness';
  get accentColor => 'accentColor';
  get primaryColor => 'primaryColor';

  get visualHash => 'visualHash';
}

final storageKey = StorageKey();
final storage = Storage();
