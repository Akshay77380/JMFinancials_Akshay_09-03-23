import 'package:flutter/material.dart' show Color;
import 'package:intl/intl.dart';

class ChartColors {
  Color kLineColor = Color(0xff4C86CD);
  Color lineFillColor = Color(0x554C86CD);
  Color ma5Color = Color(0xffC9B885);
  Color ma10Color = Color(0xff6CB0A6);
  Color ma30Color = Color(0xff9979C6);
  ChartStudyColors chartStudyColors;
  Color upColor = Color(0xff089981); //Color(0xff4DAA90);
  Color dnColor = Color(0xfff23645); //Color(0xffC15466);
  Color fontRed = Color(0xfff23645);
  Color fontGreen = Color(0xff089981);
  Color volColor = Color(0xff089981); //Color(0xff4729AE);
  Color hiColor = Color(0xFF31A779);
  Color loColor = Color.fromARGB(255, 196, 81, 86); //Color(0xFFC23833);
  Color macdColor = Color(0xff4729AE);
  Color difColor = Color(0xffC9B885);
  Color deaColor = Color(0xff6CB0A6);
  Color kColor = Color(0xffC9B885);
  Color dColor = Color(0xff6CB0A6);
  Color jColor = Color(0xff9979C6);
  Color rsiColor = Color(0xffC9B885);
  Color studyLabelTextColor = Color(0xB1FFFFFF);
  Color studyLabelTextColorLight = Color.fromARGB(185, 46, 46, 46);
  double defaultTextSize = 12.5;
  Color defaultTextColor =
      Color.fromARGB(255, 192, 192, 199); //Color(0xff60738E);
  Color nowPriceUpColor = Color(0xff4DAA90);
  Color nowPriceDnColor = Color(0xffC15466);
  Color nowPriceTextColor = Color(0xffffffff);
  Color nowPriceTextColor2 = Color.fromARGB(218, 31, 31, 31);
  //Deep color
  Color depthBuyColor = Color(0xff60A893);
  Color depthSellColor = Color(0xffC15866);
  //Display value border color after selection
  Color selectBorderColor = Color(0xff6C7A86);
  //The fill color of the background of the displayed value after selection
  Color selectFillColor = Color.fromARGB(
      255, 0, 112, 192); //Color(0xFF3C454D); //Color(0xff0D1722);
  //Dividing line color
  Color gridColor = Color(0xFF3C506E);       //Color(0xff4c5c74);
  Color gridColorDark = Color(0xff145DA0);
  Color infoWindowNormalColor = Color(0xffffffff);
  Color infoWindowTitleColor = Color(0xffffffff);
  Color infoWindowUpColor = Color(0xff00ff00);
  Color infoWindowDnColor = Color(0xffff0000);
  Color hCrossColor = Color(0xffffffff);
  Color vCrossColor = Color(0x9BFFFFFF); //Color(0x1EFFFFFF);
  Color crossTextColor = Color(0xffffffff);
  Color SolidCrossColor = Color(0xFFFFFFFF);
  //The color of the maximum and minimum values ??in the current display
  Color maxColor = Color(0xffffffff);
  Color minColor = Color(0xffffffff);
  Color getMAColor(int index) {
    Color maColor = ma5Color;
    switch (index % 3) {
      case 0:
        maColor = ma5Color;
        break;
      case 1:
        maColor = ma10Color;
        break;
      case 2:
        maColor = ma30Color;
        break;
    }
    return maColor;
  }
}

class ChartStudyColors {
  List<Color> priceColors = [];
  String priceDisplayText = '';
  List<Color> volColors = [];
  String volDisplayText = '';
  List<Color> maColors = [];
  List<Color> strendColors = [];
  String maDisplayText = '';
  List<Color> macdColors = [];
  String macdDisplayText = '';
  List<Color> bollColors = [];
  String bollDisplayText = '';
  List<Color> donColors = [];
  List<Color> swingColors = [];
  List<Color> rsiColors = [];
  String rsiDisplayText = '';
  List<Color> wrColors = [];
  String wrDisplayText = '';
  List<Color> cciColors = [];
  String cciDisplayText = '';
  List<Color> kdjColors = [];
  String kdjDisplayText = '';
  List<Color> pTypColors = [];
  ChartStudyColors();

  Color getPriceColor(int index) {
    return priceColors[index];
  }

  Color getVolColor(int index) {
    return volColors[index];
  }

  Color getMAColor(int index) {
    return maColors[index];
  }

  Color getMACDColor(int index) {
    return macdColors[index];
  }

  Color getBollColor(int index) {
    return bollColors[index];
  }

  Color getRSIColor(int index) {
    return rsiColors[index];
  }

  Color getWRColor(int index) {
    return wrColors[index];
  }

  Color getCCIColor(int index) {
    return cciColors[index];
  }

  Color getKDJColor(int index) {
    return kdjColors[index];
  }
}

class ChartStyle {
  //Point-to-point distance
  double pointWidth = 12.0;

  //Candle width
  double candleWidth = 8.5;

  //The width of the middle line of the candle
  double candleLineWidth = 1.1;

  //vol Column width
  double volWidth = 5; //8.5;

  //macd Column width
  double macdWidth = 3.0;

  //Vertical cross line width
  double vCrossWidth = 1.5; //8.5;

  //Horizontal cross line width
  double hCrossWidth = 1.0;

  //Line length at current price
  double nowPriceLineLength = 1;

  //Line interval of current price
  double nowPriceLineSpan = 1;

  //Line thickness of current price
  double nowPriceLineWidth = 1;

  double gridLinesWidth = 10;

  //Display rate in indian format.
  NumberFormat indianRateDisplay = NumberFormat.decimalPattern('hi_IN');
}
