import 'dart:math';

class BaseCount {
  int bitCount;
  int charCount;

  BaseCount({this.bitCount, this.charCount});
}

String base({String alphabet, String input}) {
  //alphabet = [...new Set(alphabet.split(''))].join('');
  final data = input.split('').map((el) {
    String char = el.codeUnits[0].toRadixString(2);
    String pad = List.filled(8 - char.length, "0").join('');
    return "$pad$char";
  }).join('');
  BaseCount baseCount = getOptimalBitsCount(alphabet.length);

  //  tail is withdrawn
  //  8 - UTF8 char length in bits
  int mainBitLength =
      ((input.length * 8 / baseCount.bitCount).floor() * baseCount.bitCount);
  int mainCharCount =
      (mainBitLength * baseCount.charCount / baseCount.bitCount).floor();
  int length = (mainCharCount / baseCount.charCount).floor();

  String result = '';
  for (int i = 0; i < length; i++) {
    int bitIndex = i * baseCount.bitCount;

    String bitArray = data.substring(bitIndex, bitIndex + baseCount.bitCount);
    BigInt number = BigInt.from(int.parse(bitArray, radix: 2));
    BigInt alphabetLength = BigInt.from(alphabet.length);

    for (int c = 0; c < baseCount.charCount; c++) {
      result += alphabet[(number % alphabetLength).toInt()];
      number = number ~/ alphabetLength;
    }
  }

  return result;
}

//  https://m.habr.com/ru/post/219993/
//  http://kvanttt.github.io/BaseNcoding/

//  a - Alphabet capacity
//  b - radix (=2)
//  k - count of encoding chars
//  n - number of bits in radix b for representing k chars of alphabet
//  n1 - max block bits count (=64)
//  a^k >= b^n
//  rval = a^k / b^n inside [+1;+infinity) -> min
//  rbits = n/k inside [+1;+infinity) -> max
//  n inside [floor(log_b(a))); n1]
//  k = ceil(log_a(b^n))

BaseCount getOptimalBitsCount(int alphabetCapacity) {
  int a = alphabetCapacity;
  int n1 = 64; //  max block bits value
  int b = 2; //  baseRadix

  int kFinal = 0;
  int nFinal = 0;
  int n0 = logarithm(radix: b, value: a).floor();

  double deltaFinal = 0;

  for (int n = n0; n <= n1; n++) {
    int k = (n * logarithm(radix: a, value: b)).ceil();
    double delta = n / k;

    if (delta > deltaFinal) {
      deltaFinal = delta;
      nFinal = n;
      kFinal = k;
    }
  }

  return BaseCount(bitCount: nFinal, charCount: kFinal);
}

double logarithm({radix, int value}) {
  return log(value) / log(radix);
}
