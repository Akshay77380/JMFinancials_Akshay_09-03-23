import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/theme.dart';

class Utils {


  static const blackColor = Color(0xff41414e);
  static var greyColor =ThemeConstants.themeMode.value == ThemeMode.light? Color(0xff7a7a7a):Colors.white;
  static const primaryColor = Color(0xff444cf1);
  static const whiteColor = Color(0xffffffff);
  static const dullWhiteColor = Color(0xffefefef);
  static var lightGreyColor = ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff969ba1) : Colors.white;
  static const containerColor = Color(0xffeaebec);
  static const darkRedColor = Color(0xffc21700);
  static const mediumRedColor = Color(0xffdd2006);
  static const lightRedColor = Color(0xfff25b47);
  static const brightRedColor = Color(0xffef4444);
  static const darkGreenColor = Color(0xff109e62);
  static const mediumGreenColor = Color(0xff1bbd79);
  static const lightGreenColor = Color(0xff26d088);
  static const brightGreenColor = Color(0xff22c55e);
  static const lightyellowColor = Color(0xffffcc50);
  static const darkyellowColor = Color(0xffffa903);

  static fonts(
      {size = 14.0,
      fontWeight = FontWeight.w600,
      color,
      textDecoration = TextDecoration.none}
      ) {
    if (color == null)
      return GoogleFonts.beVietnamPro(
          fontWeight: fontWeight, fontSize: size, decoration: textDecoration);
    else
      return GoogleFonts.beVietnamPro(
          fontWeight: fontWeight,
          fontSize: size,
          color: color,
          decoration: textDecoration);
  }

  static getSharedPreferences(key, type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var result;
    if (type == "String")
      result = pref.getString(key) ?? "";
    else if (type == "Int")
      result = pref.getInt(key) ?? 0;
    else if (type == "Bool")
      result = pref.getBool(key) ?? false;
    else if (type == "Double") result = pref.getDouble(key) ?? 0.0;

    return result;
  }

  static saveSharedPreferences(key, value, type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (type == "String")
      pref.setString(key, value);
    else if (type == "Int")
      pref.setInt(key, value);
    else if (type == "Bool")
      pref.setBool(key, value);
    else if (type == "Double") pref.setDouble(key, value);
  }
}
