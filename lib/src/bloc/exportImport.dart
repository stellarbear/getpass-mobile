import 'dart:async';
import 'package:getpass/src/infrastructure/export.dart';
import 'package:getpass/src/infrastructure/validators.dart';
import 'package:rxdart/rxdart.dart';

class ImportData {
  String key;
  String data;

  ImportData({this.key, this.data});
}

class ExportImportBloc with Validators {
  BehaviorSubject<String> _importKeyController =
      BehaviorSubject<String>(seedValue: '');
  Stream<String> get importKeyStream => _importKeyController.stream;
  Function(String) get importKeyOnChange => _importKeyController.sink.add;

  BehaviorSubject<String> _importDataController =
      BehaviorSubject<String>(seedValue: '');
  Stream<String> get importDataStream => _importDataController.stream;
  Function(String) get importDataOnChange => _importDataController.sink.add;

  Stream<ExportData> get importStream => Observable.combineLatest2(
          _importKeyController,
          _importDataController,
          (key, data) => new ImportData(key: key, data: data))
      .transform(correctExportFormat);

  BehaviorSubject<String> _exportKeyController =
      BehaviorSubject<String>(seedValue: '');
  Stream<String> get exportKeyStream => _exportKeyController.stream;
  Function(String) get exportOnChange => _exportKeyController.sink.add;

  dispose() {
    _importDataController.close();
    _importKeyController.close();
    _exportKeyController.close();
  }
}

final exportImportBloc = ExportImportBloc();
