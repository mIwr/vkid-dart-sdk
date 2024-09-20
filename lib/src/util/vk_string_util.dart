
import 'dart:math';

import 'package:vk_id/src/extension/string_ext.dart';

///VK ID string parameter generator utils
abstract class VkStringUtil {

  ///VK ID string alphabet
  ///
  ///Contains digits, uppercased and lowercased letters
  ///Also contains special characters '-' and '_'
  static const _kAlphabet = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    '-', '_'
  ];

  ///Checks the string against alphabet 'a-zA-Z0-9_-'
  static bool valid(String val) {
    for (var i = 0; i < val.length; i++) {
      if (val[i] != '-' && val[i] != '_' && !val.isDigit(atIndex: i) && !val.isUpperLetter(i) && !val.isLowerLetter(i)) {
        return false;
      }
    }
    return true;
  }

  ///Generates the random string with defined length according alphabet 'a-zA-Z0-9_-'
  static String generate(int length) {
    final rnd = Random();
    final alphabetLength = _kAlphabet.length;
    var res = "";
    for (var i = 0; i < length; i++) {
      res += _kAlphabet[rnd.nextInt(alphabetLength)];
    }
    return res;
  }
}