
///String extension utils
extension StringExt on String {

  ///Digit chars set
  static const Set<String> digits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
  ///Lowercased letters set
  static const Set<String> letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
  ///Uppercased letters set
  static const Set<String> upperLetters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
    "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

  ///Checks 'char is not digit'
  bool isNotDigit({int? atIndex}) {
    return !isDigit(atIndex: atIndex);
  }

  ///Checks 'char is digit'
  bool isDigit({int? atIndex}) {
    if (atIndex != null) {
      final ch = this[atIndex];
      return digits.contains(ch);
    }
    for (var i = 0; i < length; i++) {
      final ch = this[i];
      if (!digits.contains(ch)) {
        return false;
      }
    }

    return true;
  }

  ///Checks 'char is not letter'
  bool isNotLetter(int index) {
    return !isLowerLetter(index) && !isUpperLetter(index);
  }

  ///Checks 'char is lowercased letter'
  bool isLowerLetter(int index) {
    final ch = this[index];
    return letters.contains(ch);
  }

  ///Checks 'char is uppercased letter'
  bool isUpperLetter(int index) {
    final ch = this[index];
    return upperLetters.contains(ch);
  }
}