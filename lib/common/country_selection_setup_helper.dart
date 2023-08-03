import 'package:beauty_clud_salon_owner/common/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';


class CountrySelectionSetupHelper {
  static GetStorage _box= new GetStorage();
  static  Locale fromStringToLocale(String _locale) {
    if (_locale.contains('_')) {
      // en_US
      return Locale(_locale.split('_').elementAt(0), _locale.split('_').elementAt(1));
    } else {
      // en
      return Locale(_locale);
    }
  }
  static List<Locale> supportedLocales() {
    final languages = [
      'en_US',
      'fr',
      'it',
    ];
    return languages.map((_locale) {
      return fromStringToLocale(_locale);
    }).toList();
  }
  static final translations = Map<String, Map<String, String>>().obs;
  static final fallbackLocale = Locale('en', 'US');

  static Locale getLocale() {
   // _box = new GetStorage();
    String? _locale = _box.read<String>('language');
    if (_locale == null || _locale.isEmpty) {
      _locale = "en";//Get.find<SettingsService>().setting.value.mobileLanguage;
    }
    return fromStringToLocale(_locale);
  }

  static ThemeMode getThemeMode() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white),
    );
    return ThemeMode.light;
  }

  static ThemeData getLightTheme() {
    // TODO change font dynamically
    String accentColor ="#BBC4C1";
    String secondColor ="#042819";
    String mainColor ="#09594B";
    return ThemeData(
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(accentColor, opacity: 0.1),
        focusColor: Ui.parseColor(accentColor),
        hintColor: Ui.parseColor(secondColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Ui.parseColor(mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: Ui.parseColor(mainColor),
          secondary: Ui.parseColor(mainColor),
        ),
        textTheme: GoogleFonts.getTextTheme(
          'Poppins',
          TextTheme(
            headline6: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Ui.parseColor(mainColor), height: 1.3),
            headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Ui.parseColor(secondColor), height: 1.3),
            headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Ui.parseColor(secondColor), height: 1.3),
            headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Ui.parseColor(secondColor), height: 1.3),
            headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Ui.parseColor(mainColor), height: 1.4),
            headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Ui.parseColor(secondColor), height: 1.4),
            subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Ui.parseColor(secondColor), height: 1.2),
            subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Ui.parseColor(mainColor), height: 1.2),
            bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Ui.parseColor(secondColor), height: 1.2),
            bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Ui.parseColor(secondColor), height: 1.2),
            caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Ui.parseColor(accentColor), height: 1.2),
          ),
        ));
  }



  static ThemeData getDarkTheme() {
    // TODO change font dynamically
    String accentDarkColor ="#99AA99";
    String secondDarkColor ="#CCDDCF";
    String mainDarkColor ="#F4841F";
    String mainColor ="#ADC148";
    return ThemeData(
        primaryColor: Color(0xFF252525),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0),
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        dividerColor: Ui.parseColor(accentDarkColor, opacity: 0.1),
        focusColor: Ui.parseColor(accentDarkColor),
        hintColor: Ui.parseColor(secondDarkColor),
        toggleableActiveColor: Ui.parseColor(mainDarkColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Ui.parseColor(mainColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(mainDarkColor),
          secondary: Ui.parseColor(mainDarkColor),
        ),
        textTheme: GoogleFonts.getTextTheme(
            'Poppins',
            TextTheme(
              headline6: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Ui.parseColor(mainDarkColor), height: 1.3),
              headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Ui.parseColor(secondDarkColor), height: 1.3),
              headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Ui.parseColor(secondDarkColor), height: 1.3),
              headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Ui.parseColor(secondDarkColor), height: 1.3),
              headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Ui.parseColor(mainDarkColor), height: 1.4),
              headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Ui.parseColor(secondDarkColor), height: 1.4),
              subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Ui.parseColor(secondDarkColor), height: 1.2),
              subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Ui.parseColor(mainDarkColor), height: 1.2),
              bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Ui.parseColor(secondDarkColor), height: 1.2),
              bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Ui.parseColor(secondDarkColor), height: 1.2),
              caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Ui.parseColor(accentDarkColor), height: 1.2),
            )));
  }

}
