import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';

class ExportData {
  ColorTheme theme;
  Settings settings;
  List<Login> logins;
  List<Service> services;

  ExportData({this.logins, this.services, this.settings, this.theme});

  factory ExportData.fromJson(Map<String, dynamic> json) {
    return ExportData(
      logins: (json['logins'] as List)
          .map((login) => Login.fromJson(login))
          .toList(),
      services: (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList(),
      settings: Settings.fromJson(json['settings']),
      theme: ColorTheme.fromJson(json['theme']),
    );
  }

  Map<String, dynamic> toJson() => {
        'logins': logins.map((login) => login.toJson()).toList(),
        'services': services.map((service) => service.toJson()).toList(),
        'settings': settings.toJson(),
        'theme': theme.toJson(),
      };
}
