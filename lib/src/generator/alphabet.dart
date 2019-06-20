const String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
const String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const String specials = '!#\$%&()*+,-.:;<=>?@[]^_{}';
const String numbers = '0123456789';

final List<String> lowerCaseArray = lowerCase.split('');
final List<String> upperCaseArray = upperCase.split('');
final List<String> specialCaseArray = specials.split('');
final List<String> numberCaseArray = numbers.split('');

String apply({bool flag, String alphabet}) {
  return flag ? alphabet : '';
}

String alphabet({bool lower, bool upper, bool number, bool special}) {
  return [
    apply(flag: lower, alphabet: lowerCase),
    apply(flag: upper, alphabet: upperCase),
    apply(flag: number, alphabet: numbers),
    apply(flag: special, alphabet: specials),
  ].join('');
}

bool verify({bool lower, bool upper, bool number, bool special, String input}) {
  var inputArray = input.split('');
  if (lower) {
    if (!inputArray.any((String el) => lowerCaseArray.contains(el))) {
      return false;
    }
  }
  if (upper) {
    if (!inputArray.any((String el) => upperCaseArray.contains(el))) {
      return false;
    }
  }
  if (number) {
    if (!inputArray.any((String el) => numberCaseArray.contains(el))) {
      return false;
    }
  }
  if (special) {
    if (!inputArray.any((String el) => specialCaseArray.contains(el))) {
      return false;
    }
  }
  return true;
}
