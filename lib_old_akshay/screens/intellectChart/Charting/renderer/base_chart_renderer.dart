import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
// import 'package:markets/screens/intellectChart/Charting/renderer/base_chart_painter.dart';
import '../../../../util/Dataconstants.dart';
import '../chart_widget.dart';
import '../entity/studies.dart';
import 'base_chart_painter.dart';
export '../chart_style.dart';

abstract class BaseChartRenderer<T> {
  double maxValue, minValue;
  double scaleY;
  double topPadding;
  Rect chartRect;
  double canvasHeight;
  int fixedLength;
  NumberFormat indianRateDisplay;
  String chartPeriod;
  double chartInterval;
  double scaleMargin = 60;
  StudyDef studyDef;
  Paint chartPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 1.0
    ..color = Colors.red;
  Paint gridPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 0.5
    ..color = Color(0xff4c5c74);

  BaseChartRenderer({
    this.chartRect,
    this.canvasHeight,
    this.maxValue,
    this.minValue,
    this.topPadding,
    this.fixedLength,
    this.indianRateDisplay,
    this.chartPeriod,
    this.chartInterval,
    Color gridColor,
  }) {
    if (maxValue == minValue) {
      maxValue *= 1.5;
      minValue /= 2;
    }
    scaleY = chartRect.height / (maxValue - minValue);
    gridPaint.color = gridColor;
    // //print("maxValue=====" + maxValue.toString() + "====minValue===" + minValue.toString() + "==scaleY==" + scaleY.toString());
  }

  double getY(double y) => (maxValue - y) * scaleY + chartRect.top;

  double getYPixel(double y,{double cP = 0.0}) =>
      maxValue - (y - topPadding - cP) / (chartRect.height) * (maxValue - minValue);

  double log10(num x) => log(x) / ln10;

  double getRoof(double number) {
    int log = log10(number).floor();
    return (number ~/ pow(10, log) + 1) * pow(10, log).toDouble();
  }

  String format(double n,
      {int fractionalDigits = 0, RateStyle rateStyle = RateStyle.Default}) {
    String retVal = '';
    if (fractionalDigits != 0) {
      retVal = n.toStringAsFixed(fractionalDigits);
    }
    if (n == null || n.isNaN) {
      retVal = "0.00";
    } else if (n > 10000000)
      retVal = (n / 10000000).toStringAsFixed(fixedLength) + ' Cr.';
    else if (n > 1000000000)
      retVal = (n / 1000000000).toStringAsFixed(fixedLength) + ' Cr.';
    else if (n > 100000)
      retVal = (n / 100000).toStringAsFixed(fixedLength) + ' Lk.';
    else if (n > 0.1 && n <= 100000)
      retVal = n.toStringAsFixed(2);
    else {
      retVal = n.toStringAsFixed(fixedLength);
    }
    indianRateDisplay?.minimumFractionDigits = 2;
    indianRateDisplay?.maximumFractionDigits = 2;

    if (rateStyle == RateStyle.Default)
      return retVal;
    else {
      double r = double.parse(retVal);
      return indianRateDisplay.format(r).toString();
    }
  }

  String doubleToString(double price) {
    String retVal = price.toStringAsFixed(fixedLength);

    switch (retVal.length) {
      case 3:
        retVal = retVal.padRight(4);
        break;
      case 4:
        retVal = retVal.padRight(8);
        break;
      case 5:
        retVal = retVal.padRight(9);
        break;
      case 6:
        retVal = retVal.padRight(9);
        break;
      case 7:
        retVal = retVal.padRight(9);
        break;
      case 8:
        retVal = retVal.padRight(10);
        break;
      default:
        retVal = retVal.padRight(12);
        break;
    }
    return retVal;
  }

  void drawGrid(Canvas canvas, int gridRows, int gridColumns, bool isDotted,
      bool verticalLine, bool horizontalLine);

  void drawGridCalendar(
      T lastPoint, T curPoint, Canvas canvas, double curX, bool isDotted);

  void drawScaleLine(Canvas canvas);

  void drawText(Canvas canvas, T data, T data2, double x, String symbol);

  void drawRightText(canvas, textStyle, int gridRows);

  void drawChart(T lastPoint, T curPoint, double lastX, double curX, Size size,
      Canvas canvas);

  void drawChartPrimaryStudy(T lastPoint, T curPoint, double lastX, double curX,
      Size size, Canvas canvas);

  void drawLine(double lastPrice, double curPrice, Canvas canvas, double lastX,
      double curX, Color color, double scaleX) {
    if (lastPrice == null || curPrice == null) {
      return;
    }

    double lastY = getY(lastPrice);
    double curY = getY(curPrice);
    chartPaint
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(lastX, lastY), Offset(curX, curY), chartPaint);

    ///---------------------------------------------Draw polygon-------------------------------
    ///
    /*if(Dataconstants.isFromToolsToFlashTrade == true)
    {
      var mountainShadow = Paint()
        ..color = Colors.cyanAccent.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      // Paint()..color=Color(0xff66ff33).withOpacity(0.2)..style=PaintingStyle.fill;
      // var redHeight=Dataconstants.chartHeight-curY;
      Path path = Path();
      path.addPolygon([
        Offset(lastX, lastY),
        // color== Color(0xff66ff33)?Offset(curX, lastY): Offset(lastX, curY),
        Offset(curX, curY),
        Offset(curX, Dataconstants.chartHeight - 20),
        Offset(lastX, Dataconstants.chartHeight - 20), //110 for main chart
      ], false);
      canvas.drawPath(path, mountainShadow);
    }*/

    ///--------------------------------------------------------------------------//
    // for (int i = 0; i < Dataconstants.flashTradeDataPoints.length; i++) {
    //   var length = Dataconstants.flashTradeDataPoints.length;
    //   var chartTine = Dataconstants.timerChartPointHide;
    //   if (DateTime.now().millisecondsSinceEpoch -
    //           Dataconstants.timerChartPointHide[i] <=
    //       60000) {
    //     if (Dataconstants.flashTradeDataPoints[i].curPrice != null &&
    //         Dataconstants.flashTradeDataPoints[i].lastX != null) {
    //       double curY2 = getY(Dataconstants.flashTradeDataPoints[i].curPrice);
    //
    //       var buyPaint = Paint()
    //         ..color = Color(0xff089981)
    //         ..style = PaintingStyle.fill;
    //       var sellPaint = Paint()
    //         ..color = Color(0xfff23645)
    //         ..style = PaintingStyle.fill;
    //       canvas.drawCircle(
    //           Offset(Dataconstants.flashTradeDataPoints[i].lastX, curY2),
    //           8,
    //           Dataconstants.isBuyColor[i] ? buyPaint : sellPaint);
    //       // Dataconstants.buySellPointColor=false;
    //
    //       ///zzzz    tick by tick
    //     }
    //   }
    // }
  }

  TextStyle getTextStyle(Color color, {double fSize = 0}) {
    if (fSize == 0)
      return TextStyle(fontSize: 11.0, color: color);
    else
      return TextStyle(fontSize: fSize, color: color);
  }
}

class flashTradeDataPoint {
  double lastX; //chart tick by tick
  double currentX; //chart tick by tick
  double lastPrice; //chart tick by tick
  double curPrice;
  int index;
}
