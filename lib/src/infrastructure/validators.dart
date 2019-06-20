import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as Enc;
import 'package:getpass/src/bloc/exportImport.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/infrastructure/export.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';

class Validators {
  validateServices({List<Service> uniqueList}) {
    return StreamTransformer<Service, Service>.fromHandlers(
      handleData: (input, sink) {
        if (uniqueList.any((item) => item.value == input.value)) {
          sink.addError(i18n.get(at: I18n.AlreadyExistingService));
          return;
        }

        sink.add(input);
      },
    );
  }

  validateLogins({List<Login> uniqueList}) {
    return StreamTransformer<Login, Login>.fromHandlers(
      handleData: (input, sink) {
        if (uniqueList.any((item) => item.value == input.value)) {
          sink.addError(i18n.get(at: I18n.AlreadyExistingLogin));
          return;
        }

        sink.add(input);
      },
    );
  }

  final correctExportFormat =
      StreamTransformer<ImportData, ExportData>.fromHandlers(
    handleData: (import, sink) {
      ExportData export;
      try {
        final keyVal =
            sha256.convert(utf8.encode(import.key)).toString().substring(0, 32);
        final key = Enc.Key.fromUtf8(keyVal);

        final encrypter = Enc.Encrypter(Enc.AES(key, mode: Enc.AESMode.cbc));
        final iv = Enc.IV.fromLength(16);

        final decrypted =
            encrypter.decrypt(Enc.Encrypted.fromBase64(import.data), iv: iv);
        export = ExportData.fromJson(json.decode(decrypted));
      } catch (ex) {
        sink.addError(i18n.get(at: I18n.ImportErrorMessage));
        return;
      }

      sink.add(export);
    },
  );
}
