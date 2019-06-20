import 'dart:async';
import 'dart:convert';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/storage.dart';
import 'package:getpass/src/infrastructure/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  static List<Login> _logins = List<Login>();

  final _selectedLoginController = BehaviorSubject<Login>();
  Stream<Login> get selectedLoginStream => _selectedLoginController.stream;
  Function(Login) get selectedLoginOnChange =>
      _selectedLoginController.sink.add;

  final _filterController = BehaviorSubject<String>(seedValue: '');
  Stream<String> get filterStream => _filterController.stream;
  Function(String) get filterOnChange => _filterController.sink.add;

  final _newLoginController = BehaviorSubject<Login>();
  Stream<Login> get newLoginStream =>
      _newLoginController.stream.transform(validateLogins(uniqueList: _logins));
  Function(Login) get newLoginOnChange => _newLoginController.sink.add;

  BehaviorSubject<List<Login>> _loginsController =
      BehaviorSubject<List<Login>>(seedValue: []);
  List<Login> get loginList => _loginsController.value;
  Stream<List<Login>> get loginStream => _loginsController.stream;

  BehaviorSubject<Login> _loginAddController = BehaviorSubject<Login>();
  Function(Login) get loginAdd => _loginAddController.sink.add;

  BehaviorSubject<Login> _loginRemoveController = BehaviorSubject<Login>();
  Function(Login) get loginRemove => _loginRemoveController.sink.add;

  LoginBloc() {
    _loginAddController.listen(_handleAddLogin);
    _loginRemoveController.listen(_handleRemoveLogin);
  }

  void _handleAddLogin(Login input) {
    if ((input.value.length > 0) &&
        (_logins.indexWhere((login) => login.value == input.value) == -1)) {
      _logins.add(input);
    }
    _loginsController.sink.add(_logins);
    updateStorage();
  }

  void _handleRemoveLogin(Login input) {
    _logins.remove(input);
    _loginsController.sink.add(_logins);

    if (_selectedLoginController.value != null) {
      if (input.value == _selectedLoginController.value.value) {
        selectedLoginOnChange(null);
      }
    }
    updateStorage();
  }

  dispose() {
    _loginsController.close();
    _loginAddController.close();
    _loginRemoveController.close();

    _newLoginController.close();
    _filterController.close();
    _selectedLoginController.close();
  }

  void init() async {
    String data = storage.getItem(key: storageKey.logins, defaultValue: '');

    try{
       _logins = (json.decode(data) as List)
        .map((value) => Login.fromJson(value))
        .toList();
    }
    catch (ex) {
      _logins = List<Login>();
    }
   
    _loginsController.sink.add(_logins);
  }

  void updateStorage() async {
    String data = json.encode(_logins.map((login) => login.toJson()).toList());

    await storage.setItem(
      value: data,
      key: storageKey.logins,
    );
  }

  void reset() {
    selectedLoginOnChange(null);
    _logins.clear();
    updateStorage();
  }
}

final loginBloc = LoginBloc();
