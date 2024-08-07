
import 'package:test/test.dart';
import 'package:vk_id/src/util/vk_string_util.dart';

void main() {

  group("VK string validate util tests group", () {

    test("Valid string with digits only", () {
      final str = "1234567890";
      expect(VkStringUtil.valid(str), true, reason: "Invalid string validator");
    });

    test("VK string validate with lower letters only", () {
      final str = "abcdefgoklagjskdg";
      expect(VkStringUtil.valid(str), true, reason: "Invalid string validator");
    });

    test("VK string validate with upper letters only", () {
      final str = "HJSDPOFERIMCZA";
      expect(VkStringUtil.valid(str), true, reason: "Invalid string validator");
    });

    test("VK string validate with spec characters only", () {
      final str = "------___---_";
      expect(VkStringUtil.valid(str), true, reason: "Invalid string validator");
    });

    test("VK string validate with mixed characters", () {
      final str = "123hfs3_FJKSD31-lka1_";
      expect(VkStringUtil.valid(str), true, reason: "Invalid string validator");
    });

    test("VK string validate with invalid characters", () {
      final str = "123hfs3#_FJKSD31-lk*a1_";
      expect(VkStringUtil.valid(str), false, reason: "Invalid string validator");
    });
  });

  group("VK string generate util tests group", () {

    test("Generate random string test", () {
      final generated = VkStringUtil.generate(48);
      expect(VkStringUtil.valid(generated), true, reason: "Invalid string generator");
    });

  });
}