
extension StringExt on String {

  static const Set<String> digits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
  static const Set<String> letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
  static const Set<String> upperLetters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
    "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

  bool isNotDigit({int? atIndex}) {
    return !isDigit(atIndex: atIndex);
  }

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

  bool isNotLetter(int index) {
    return !isLowerLetter(index) && !isUpperLetter(index);
  }

  bool isLowerLetter(int index) {
    final ch = this[index];
    return letters.contains(ch);
  }

  bool isUpperLetter(int index) {
    final ch = this[index];
    return upperLetters.contains(ch);
  }
}