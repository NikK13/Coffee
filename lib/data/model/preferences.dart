import 'package:flutter/material.dart';

class Preferences {
  String? currentTheme;
  Locale? locale;
  bool? isFirst;

  String? photo;
  String? name;
  String? phoneCode;
  String? phoneNum;
  String? website;

  Preferences({
    required this.currentTheme,
    required this.locale,
    required this.isFirst,
    this.photo,
    this.name,
    this.phoneCode,
    this.phoneNum,
    this.website
  });
}
