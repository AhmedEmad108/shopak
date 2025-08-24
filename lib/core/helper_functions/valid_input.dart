import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopak/generated/l10n.dart';

/// Universal input validator function
/// Returns [String] message if invalid, otherwise returns null
String? validInput({
  required BuildContext context,
  required String val,
  required String type,
  required int max,
  required int min,
  String? compareWith, // مفيدة لـ confirmPassword
  Pattern? customRegex, // للـ custom validation
}) {
  // 1️⃣ تأكد إن الفيلد مش فاضي
  if (val.trim().isEmpty) {
    return S.of(context).cant_be_empty;
  }

  // 2️⃣ تحقق بناءً على نوع الإدخال
  switch (type) {
    case 'userName':
      if (!GetUtils.isUsername(val)) {
        return S.of(context).not_valid_name;
      }
      break;

    case 'text':
      // نص عادي (Address, Description, ... إلخ)
      if (val.length < min) {
        return '${S.of(context).cant_be_less_than} $min';
      }
      break;

    case 'email':
      if (!GetUtils.isEmail(val)) {
        return S.of(context).not_valid_email;
      }
      break;

    case 'phone':
      if (!GetUtils.isPhoneNumber(val)) {
        return S.of(context).not_valid_phone;
      }
      break;

    case 'price':
    case 'number':
      if (!GetUtils.isNum(val)) {
        return S.of(context).not_valid_price;
      }
      break;

    case 'password':
      if (val.length < min) {
        return '${S.of(context).cant_be_less_than} $min';
      }
      // if (!val.contains(RegExp(r'[A-Z]'))) {
      //   return S.of(context).password_must_have_uppercase;
      // }
      // if (!val.contains(RegExp(r'[a-z]'))) {
      //   return S.of(context).password_must_have_lowercase;
      // }
      // if (!val.contains(RegExp(r'[0-9]'))) {
      //   return S.of(context).password_must_have_number;
      // }
      break;

    case 'confirmPassword':
      if (compareWith != null && val != compareWith) {
        return S.of(context).password_not_match;
      }
      break;

    case 'url':
      if (!GetUtils.isURL(val)) {
        return S.of(context).not_valid_url;
      }
      break;

    case 'date':
      if (!GetUtils.isDateTime(val)) {
        return S.of(context).not_valid_date;
      }
      break;

    case 'customRegex':
      if (customRegex != null &&
          !RegExp(customRegex.toString()).hasMatch(val)) {
        return S.of(context).not_valid_input;
      }
      break;

    default:
      debugPrint("⚠️ Warning: Unknown validation type '$type'");
  }

  // 3️⃣ تحقق من الطول
  if (val.length > max) {
    return '${S.of(context).cant_be_large_than} $max';
  }

  if (val.length < min) {
    return '${S.of(context).cant_be_less_than} $min';
  }

  // ✅ الإدخال صحيح
  return null;
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shopak/generated/l10n.dart';

// validInput({
//   required BuildContext context,
//   required String val,
//   required String type,
//   required int max,
//   required int min,
// }) {
//   if (type == 'userName') {
//     if (!GetUtils.isUsername(val)) {
//       return S.of(context).not_valid_name;
//     }
//   }

//   if (type == 'text') {
//     if (!GetUtils.isUsername(val)) {
//       return S.of(context).not_valid_address;
//     }
//   }

//   if (type == 'email') {
//     if (!GetUtils.isEmail(val)) {
//       return S.of(context).not_valid_email;
//     }
//   }

//   if (type == 'phone') {
//     if (!GetUtils.isPhoneNumber(val)) {
//       return S.of(context).not_valid_phone;
//     }
//   }
//   if (type == 'price') {
//     if (!GetUtils.isNum(val)) {
//       return S.of(context).not_valid_price;
//     }
//   }
//   if (val.isEmpty) {
//     return S.of(context).cant_be_empty;
//   }
//   if (val.length > max) {
//     return '${S.of(context).cant_be_large_than} $max';
//   }
//   if (val.length < min) {
//     return '${S.of(context).cant_be_less_than} $min';
//   }
// }
