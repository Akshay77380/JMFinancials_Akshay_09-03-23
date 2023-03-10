import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart' as mobx;

class ThemeConstants {
  ThemeConstants();
  static const Color splashColor = const Color(0xFF5494EC);
  static const Color primaryColor = Colors.blueAccent;
  static Color buyColor = const Color(0xff34c758);
  static Color sellColor = const Color(0xfffe3c30);
  static Color chartbuyColor = const Color(0xff34c758);
  // static charts.MaterialPalette chartsellColor = const Color(0xfffe3c30);
  static const Color buyColorOld = const Color(0xff009966);
  static const Color sellColorOld = const Color(0xffF24343);
  static const Color greyBg = const Color(0xffF2F4F7);
  static const Color dropdown = const Color(0xff3E5165);
  static const Color searchBackgroundLight = Color(0xffF5F5F5);
  static const Color searchBackgroundDark = Color(0xffF1F1F1);
  static final themeMode = mobx.Observable(ThemeMode.dark);
  static final amoledThemeMode = mobx.Observable(false);
  static final setLightTheme = mobx.Action(() {
    themeMode.value = ThemeMode.light;
  });
  static final setDarkTheme = mobx.Action(() {
    amoledThemeMode.value = false;
    themeMode.value = ThemeMode.dark;
  });

  static final setAmoledTheme = mobx.Action(() {
    themeMode.value = ThemeMode.dark;
    amoledThemeMode.value = true;
  });
}
