
import 'dart:convert';

import '../extension/json_codec_ext.dart';
import 'vk_sex.dart';

///VK ID profile info
class VkProfile {

  ///VK user ID
  final int userId;
  ///User first name
  final String firstName;
  ///User last name
  final String lastName;
  ///User phone number
  final String phone;
  ///User avatar url
  final String ava;
  ///User has avatar flag
  bool get hasAva {
    return ava.isNotEmpty;
  }
  ///User email
  final String email;
  ///User gender api key
  final int? sexApiKey;
  ///Parsed user gender
  VkSex? get parsedSex {
    final apiKey = sexApiKey;
    if (apiKey == null) {
      return null;
    }
    return VkSexExt.from(apiKey);
  }
  ///User account is verified flag
  final bool? verified;
  ///User birthday
  final String? bDay;
  DateTime? get bDayDt {
    final birthday = bDay;
    if (birthday == null || birthday.isEmpty) {
      return null;
    }
    final split = birthday.split('.');
    final day = int.tryParse(split[0]);
    if (day == null || day <= 0 || day > 31 || split.length < 2) {
      return null;
    }
    final month = int.tryParse(split[1]);
    if (month == null || month <= 0 || month > 12) {
      return null;
    }
    var year = 1970;
    if (split.length > 2) {
      year = int.tryParse(split[2]) ?? 1970;
    }
    return DateTime(year, month, day);
  }

  const VkProfile({required this.userId, required this.firstName, required this.lastName, required this.phone, required this.ava, required this.email, required this.sexApiKey, required this.verified, required this.bDay});

  static VkProfile? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("user_id")) {
      return null;
    }
    final uid = json.tryGetIntFrom(jsonMap, key: "user_id");
    if (uid == null) {
      return null;
    }
    final String fname = jsonMap["first_name"] ?? "";
    final String lname = jsonMap["last_name"] ?? "";
    final String phone = jsonMap["phone"] ?? "";
    final String ava = jsonMap["avatar"] ?? "";
    final String mail = jsonMap["email"] ?? "";
    final sex = json.tryGetIntFrom(jsonMap, key: "sex");
    final verified = json.tryGetBoolFrom(jsonMap, key: "verified");
    final String? bDayStr = jsonMap["birthday"];

    return VkProfile(userId: uid, firstName: fname, lastName: lname, phone: phone, ava: ava, email: mail, sexApiKey: sex, verified: verified, bDay: bDayStr);
  }
}