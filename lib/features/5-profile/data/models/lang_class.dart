import 'package:flutter/material.dart';
import 'package:shopak/generated/l10n.dart';

class LangClass {
  final String name;
  final String name2;
  final String locale;
  LangClass({required this.name2, required this.locale, required this.name});
}


 List<LangClass> langList({required BuildContext context}) => [
    LangClass(
      locale: 'system',
      name: S.of(context).device,
      name2: S.of(context).device_language,
    ),
    LangClass(
      locale: 'en',
      name: S.of(context).english,
      name2: S.of(context).english_language,
    ),
    LangClass(
      locale: 'ar',
      name: S.of(context).arabic,
      name2: S.of(context).arabic_language,
    ),
  ];
