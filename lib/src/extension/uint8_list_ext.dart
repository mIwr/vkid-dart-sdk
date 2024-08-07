
import 'dart:math';
import 'dart:typed_data';

extension Uint8ListExt on Uint8List {

  ///Copy byte array
  Uint8List clone() {
    Uint8List cloned = Uint8List(length);
    for (var i = 0; i < cloned.length; i++) {
      cloned[i] = this[i];
    }

    return cloned;
  }

  int compareTo(Uint8List a) {
    if (length != a.length) {
      return length > a.length ? 1 : -1;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] > a[i]) {
        return 1;
      } else if (this[i] < a[i]) {
        return - 1;
      }
    }

    return 0;
  }

  ///Parse byte array from hex string
  static Uint8List? fromHexString(String hexString) {
    List<int> bytes = [];
    for (var i = 0; i < hexString.length; i+=2) {
      final hex = hexString[i] + hexString[i + 1];
      final parsed = int.tryParse(hex, radix: 16);
      if (parsed == null) {
        return null;
      }
      bytes.add(parsed);
    }

    return Uint8List.fromList(bytes);
  }

  static Uint8List random(int length) {
    assert(length > 0);
    if (length == 0) {
      return Uint8List(0);
    }
    final rnd = Random();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = rnd.nextInt(255);
    }
    return bytes;
  }
}