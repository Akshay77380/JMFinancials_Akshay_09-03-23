// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'Dataconstants.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DateUtil {
  static final String tag = "DateUtil";
  static DateFormat dateFormatter = DateFormat("dd/MM/yyyy HH:mm:ss");
  static DateFormat iciciDateFormatter = DateFormat('dd-MMM-yyyy');
  static DateTime exchStartDate = DateTime(1980, 1, 1, 0, 0, 0);
  static DateTime exchStartDate1 = DateTime(1970, 1, 1, 0, 0, 0); // for chart purpose
  static String getDateWithFormatForPass(int timeInSeconds, String format) {
    try {
      String mystring = "01/01/1980";

      var formatter1 = new DateFormat("dd/MM/yyyy");

      DateTime startDate;
      try {
        startDate = formatter1.parse(mystring);
      } on Exception {}
      var formatter2 = new DateFormat(format);
      int millis = (timeInSeconds + startDate.millisecondsSinceEpoch ~/ 1000);
      return formatter2
          .format(new DateTime.fromMillisecondsSinceEpoch(millis * 1000));
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return timeInSeconds.toString();
    }
  }

  static String getFormattedDate(String str) {
    try {
      var oldDateFormat = new DateFormat("dd MMM yyyy");
      var newDateFormat = new DateFormat("dd-MM-yyyy");
      return newDateFormat.format(oldDateFormat.parse(str));
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return str;
    }
  }

  static int getIntFromDate1Chart(String date) {
    try {
      var formatter1 = new DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime startDate = formatter1.parse(date);
      // startDate = startDate.add(Duration(hours: 14, minutes: 30));
      return startDate.difference(exchStartDate1).inSeconds;
    } on Exception catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      return 0;
    }
  }

  static int getMcxformattedDateFromIsec(String date) {
    // try {
    //   var formatter1 = new DateFormat("dd-MMM-yyyy");
    //   DateTime startDate = formatter1.parse(date);
    //   // startDate = startDate.add(Duration(hours: 14, minutes: 30));
    //   return startDate.difference(exchStartDate1).inSeconds + 86399;
    // } on Exception catch (e, s) {
    //   FirebaseCrashlytics.instance.recordError(e, s);
    //   return 0;
    // }
    try {
      var formatter1 = new DateFormat("dd-MMM-yyyy");
      DateTime startDate = formatter1.parse(date);
      startDate = startDate.add(Duration(hours: 23, minutes: 59,seconds: 59));
      return startDate.difference(exchStartDate1).inSeconds;
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return 0;
    }
  }

  static String getAnyFormattedDate(DateTime date, String format) {
    try {
      var newDateFormat = new DateFormat(format);
      return newDateFormat.format(date);
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return "";
    }
  }

  static DateTime getDateTimeFromString(String date, String format) {
    try {
      var newDateFormat = new DateFormat(format);
      return newDateFormat.parse(date);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return DateTime.now();
    }
  }

  static DateTime getDateTimeFromIsecDate(String date) {
    try {
      return iciciDateFormatter.parse(date);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return DateTime.now();
    }
  }

  static String getAnyFormattedExchDate(int date, String format) {
    try {
      DateTime dt = Dataconstants.exchStartDate.add(Duration(seconds: date));
      var newDateFormat = new DateFormat(format);
      return newDateFormat.format(dt);
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return "";
    }
  }

  static String getAnyFormattedExchDateMCX(int date, String format) {
    try {
      DateTime dt = Dataconstants.exchStartDateMCX.add(Duration(seconds: date));
      var newDateFormat = new DateFormat(format);
      return newDateFormat.format(dt);
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return "";
    }
  }

  static String getFormattedCurrentDate(String format) {
    try {
      var oldDateFormat = new DateFormat(format);
      return oldDateFormat.format(DateTime.now());
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return "";
    }
  }

  static String getMcxDateWithFormat(int timeInSeconds, String format) {
    try {
      String mystring = "01/01/1970";

      var formatter1 = new DateFormat("dd/MM/yyyy");

      DateTime startDate;
      try {
        startDate = formatter1.parse(mystring);
      } on Exception {}
      var formatter2 = new DateFormat(format);

      int millis =
          ((timeInSeconds * 1000) + startDate.millisecondsSinceEpoch).toInt();
      DateTime dt = new DateTime.fromMillisecondsSinceEpoch(millis);
      return formatter2.format(dt);
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return timeInSeconds.toString();
    }
  }

  static int getIntFromDate(String date) {
    try {
      var formatter1 = new DateFormat("dd-MMM-yyyy");
      DateTime startDate = formatter1.parse(date);
      startDate = startDate.add(Duration(hours: 14, minutes: 30));
      return startDate.difference(exchStartDate).inSeconds;
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return 0;
    }
  }

  static int getIntFromDate2(String date) {
    try {
      var formatter1 = new DateFormat("dd-MM-yyyy");
      DateTime startDate = formatter1.parse(date);
      startDate = startDate.add(Duration(hours: 14, minutes: 30));
      return startDate.difference(exchStartDate).inSeconds;
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return 0;
    }
  }

  static int getIntFromDate1(String date) {
    try {
      var formatter1 = new DateFormat("dd-MMM-yyyy HH:mm:ss");
      DateTime startDate = formatter1.parse(date);
      // startDate = startDate.add(Duration(hours: 14, minutes: 30));
      return startDate.difference(exchStartDate1).inSeconds;
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return 0;
    }
  }

  static String getDateWithFormat(int timeInSeconds, String format) {
    try {
      String mystring = "01/01/1980";

      var formatter1 = new DateFormat("dd/MM/yyyy");

      DateTime startDate;
      try {
        startDate = formatter1.parse(mystring);
      } on Exception {}
      var formatter2 = new DateFormat(format);

      int millis =
          ((timeInSeconds * 1000) + startDate.millisecondsSinceEpoch).toInt();
      DateTime dt = new DateTime.fromMillisecondsSinceEpoch(millis);
      return formatter2.format(dt);
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return timeInSeconds.toString();
    }
  }


  static String getDateWithFormatForAlgoDate(int timeInSeconds, String format) {
    try {
      String mystring = "01/01/1980";

      var formatter1 = new DateFormat("dd/MM/yyyy");

      DateTime startDate;
      try {
        startDate = formatter1.parse(mystring);
      } on Exception {}
      var formatter2 = new DateFormat(format);
      int millis = (timeInSeconds + startDate.millisecondsSinceEpoch ~/ 1000);
      return formatter2
          .format(new DateTime.fromMillisecondsSinceEpoch(millis * 1000));
    } on Exception catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      return timeInSeconds.toString();
    }
  }

/*  void compareDates(GregorianCalendar cal2){

  }*/
}
