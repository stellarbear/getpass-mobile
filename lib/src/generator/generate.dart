import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:getpass/src/generator/alphabet.dart';
import 'package:getpass/src/generator/base.dart';
import 'package:getpass/src/generator/scrypt.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';
import 'package:meta/meta.dart';

class GenerateHandle {
  int blockSizeFactor;
  int costFactor;

  Service service;
  String secret;
  Login login;

  GenerateHandle({
    @required this.secret,
    @required this.service,
    @required this.login,
    @required this.blockSizeFactor,
    @required this.costFactor,
  });
}

String sha(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}

String shaCycle(List<String> input) {
  String hash = 'getpass';
  for (int i = 0; i < input.length; i++) {
    String entry = input[i];
    hash = sha('$hash$entry');
  }
  return hash;
}

String generatePasswordImplementation(GenerateHandle handle) {
  int costFactor = handle.costFactor;
  int blockSizeFactor = handle.blockSizeFactor;
  int length = handle.service.length;
  bool lower = handle.service.lower;
  bool upper = handle.service.upper;
  bool number = handle.service.number;
  bool special = handle.service.special;
  String secret = handle.secret;
  String login = handle.login.value;
  String service = '${handle.service.value}${handle.service.counter}';
  String currentAlphabet = alphabet(
    lower: lower,
    upper: upper,
    number: number,
    special: special,
  );

  int N = 1 << costFactor, r = blockSizeFactor, p = 1;

  String password = shaCycle([secret, login, service]);
  String salt = shaCycle([login, service, secret]);

  String hash = bytesToHex(scrypt(password, salt, N, r, p, length));

  String result = hash;

  do {
    result = base(
      input: sha(result),
      alphabet: currentAlphabet,
    ).substring(0, length);
  } while ((length >= 8) &&
      (!verify(
          lower: lower,
          upper: upper,
          number: number,
          special: special,
          input: result)));

  return result;
}
