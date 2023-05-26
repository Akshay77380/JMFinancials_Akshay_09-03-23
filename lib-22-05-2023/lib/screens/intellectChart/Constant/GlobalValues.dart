import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'Constant.dart';
import 'package:http/http.dart' as http;

class Global {
  static bool isIOS = Platform.isIOS;
  static int connectionTimeOut = 25, connectionTimeOut2 = 30;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static NumberFormat myFormat = NumberFormat.decimalPattern('hi_IN');
  static void setNumberFormatValues() {
    myFormat.minimumFractionDigits = 2;
    myFormat.maximumFractionDigits = 2;
  }

  static NumberFormat myIntFormat = NumberFormat.decimalPattern('hi_IN');
  static void setIntNumberFormatValues() {
    myIntFormat.maximumFractionDigits = 2;
  }

  // static RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  // static Function mathFunc = (Match match) => '${match[1]},';
  static double chartHigh = 0.0,
      chartLow = 0.0,
      chartVisibleClose = 0.0,
      chartClose = 0.0,
      scaleY = 0.0,
      minValue = 0.0;
  static bool scaleCanvas = false;
  static TabController controller;
  static bool themeColor;
  static int watchListid;
  static String generatedFrom;


  static List<String> symbolsName = [];
  static String fontName;


  static TabController tabController;
  static String globalFilePath;


  static bool executed = false;
  static String decryptedMobileNo;
  static String userphone = "";
  static bool isCalled = false;
  static double devicepixelration;
  static PageController pageController = PageController();
  static InAppWebViewController webViewController;

  static ProductType productType = ProductType.Premium;

//Sqlite Memory fields


  static List<Map<String, dynamic>> favScannerList = [];
  static String deviceIPAddress;

  //Theme Part

  static Color bGGreen;
  static Color fontGreen;
  static Color bGRed;
  static Color fontRed;
  static Color darkThemeLightTextColor;
  static Color lightThemeLightTextColor;

  static Color darkThemeTextColor;
  static Color lightThemeTextColor;
  static Color blueColor;
  static bool isExecuted = false;

  static Color rowsAlternatingOddDark = const Color(0Xff1C252B);
  static Color rowsAlternatingEvenDark = const Color(0Xff12171B);

  static Color tabbarrowsAlternatingEvenDark = const Color(0xFF151b1f);
  static Color tabbarrowsAlternatingOddDark = const Color(0Xff1A2227);

  static Color tabbarrowsAlternatingEvenLight = const Color(0XffF9F9F9);

  static getColor() {
    bGGreen = Color(0Xffecf8f4);
    fontRed = Color(0Xfffc4343);

    bGRed = Color(0Xfffceeed);
    fontGreen = Color(0Xff34c85a);

    darkThemeTextColor = Colors.grey[300];
    darkThemeLightTextColor = Colors.blueGrey[400];

    lightThemeTextColor = Colors.grey[850];
    //lightThemeTextColor = Color(0xff28282B);
    lightThemeLightTextColor = Colors.grey[600];
    blueColor = Colors.blue;
  }
  //End Theme

//GetVersion Method

  static String versionNumber, buildNumber;

//WatchListName part

  static int watchListCount = 5;
  static List<String> watchListName = [];
  static generateList() {
    watchListName = [];
    for (int i = 0; i < watchListCount; i++) {
      watchListName.add((i + 1).toString());
    }
  }

  static const List listUserType = [
    {'name': 'Roboto', 'value': 'Roboto'},
    {'name': 'WorkSans', 'value': 'WorkSans'},
    {'name': 'Lato', 'value': 'Lato'},
    {'name': 'Heebo', 'value': 'Heebo'},
    {'name': 'Literata', 'value': 'Literata'},
    {'name': 'Prod_S_Regu', 'value': 'Product Sans Regular'},
  ];

  static String stringDateFormat(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static DateFormat globalDateFormat({String format}) {
    return DateFormat(format);
  }

  static FontWeight textSymbolBold = FontWeight.bold;

  static String globalCurrentExchange = "";
  static int globalCurrentScCode = 0;
  static String lastticktime;
  static String prevDayDate;
  static String username = "";
  static String emailid = "";
}

enum ProductType { DummyFirst, FreeUser, Pro, Premium, Elite, DummyLast }

class GlobalWatchlists {
  static bool isFilterList = false;
  static bool searchonclick = true;
  static List<String> listOfwatchlist = [];
}
