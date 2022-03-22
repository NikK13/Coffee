import 'dart:ui';
import 'package:coffee/data/model/preferences.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider extends ChangeNotifier {
  SharedPreferences? sp;

  String? currentTheme;
  Locale? locale;
  bool? isFirst;

  String? photo;
  String? name;
  String? phoneCode;
  String? phoneNum;
  String? website;

  PreferenceProvider() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    sp ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (sp!.getString('mode') == null) await sp!.setString('mode', 'system');
    if (sp!.getBool('first') == null) await sp!.setBool('first', true);
    if (sp!.getString('language') == null) {
      switch (window.locale.languageCode) {
        case 'en':
        case 'ru':
          locale = Locale(window.locale.languageCode, '');
          break;
        default:
          locale = const Locale('en', '');
      }
    } else {
      locale = Locale(sp!.getString('language')!, '');
    }
    isFirst = sp!.getBool('first');
    currentTheme = sp!.getString('mode');

    photo = sp!.getString('photo');
    name = sp!.getString('name');
    phoneNum = sp!.getString('phoneNum');
    phoneCode = sp!.getString('phoneCode');
    website = sp!.getString('website');
    notifyListeners();
  }

  deleteAllData() async{
    await _initPrefs();
    sp!.remove('photo');
    sp!.remove('name');
    sp!.remove('phoneNum');
    sp!.remove('phoneCode');
    sp!.remove('website');

    photo = sp!.getString('photo');
    name = sp!.getString('name');
    phoneNum = sp!.getString('phoneNum');
    phoneCode = sp!.getString('phoneCode');
    website = sp!.getString('website');
    notifyListeners();
  }

  savePreference(String key, value) async {
    await _initPrefs();
    switch (key) {
      case 'mode':
      case 'language':
      case 'photo':
      case 'name':
      case 'phoneNum':
      case 'phoneCode':
      case 'website':
        sp!.setString(key, value);
        break;
      case 'first':
        sp!.setBool(key, value);
        break;
    }
    locale = Locale(sp!.getString('language')!, '');
    isFirst = sp!.getBool('first');
    currentTheme = sp!.getString('mode');

    photo = sp!.getString('photo');
    name = sp!.getString('name');
    phoneNum = sp!.getString('phoneNum');
    phoneCode = sp!.getString('phoneCode');
    website = sp!.getString('website');
    notifyListeners();
  }

  Preferences get preferences => Preferences(
    currentTheme: currentTheme,
    locale: locale,
    isFirst: isFirst,
    photo: photo,
    name: name,
    phoneCode: phoneCode,
    phoneNum: phoneNum,
    website: website
  );

  String? getThemeTitle(BuildContext context) {
    switch (sp!.getString("mode")) {
      case 'light':
        return AppLocalizations.of(context, 'theme_light');
      case 'dark':
        return AppLocalizations.of(context, 'theme_dark');
      case 'system':
        return AppLocalizations.of(context, 'theme_system');
      default:
        return "";
    }
  }
}
