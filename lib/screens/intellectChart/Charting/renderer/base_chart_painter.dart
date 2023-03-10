import 'dart:math';

import 'package:flutter/material.dart'
    show Color, TextStyle, Rect, Canvas, Size, CustomPainter;
import 'package:markets/util/Dataconstants.dart';

// import '../../../../util/Dataconstants.dart';
import '../chart_style.dart' show ChartStyle;
import '../entity/k_line_entity.dart';
import '../chart_widget.dart';
import '../entity/studies.dart';
import '../utils/date_format_util.dart';

export 'package:flutter/material.dart'
    show Color, required, TextStyle, Rect, Canvas, Size, CustomPainter;

abstract class BaseChartPainter extends CustomPainter {
  static double maxScrollX = 0.0;
  List<KLineEntity> datas;
  final ChartStudies chartStudies;
  List<MainState> mainState;

  SecondaryState secondaryState;
  SecondaryState tertiaryState;

  bool volHidden;
  double scaleX = 1.0, scrollX = 0.0, selectX, selectY;
  bool isLongPress = false;
  bool isLongPress2 = false;
  bool isLine;

  Rect mMainRect;
  Rect mVolRect, mSecondaryRect, mTertiaryRect;
  double mCanvasHeight, mDisplayHeight, mWidth;
  double mTopPadding = 48.0, mBottomPadding = 20.0, mChildPadding = 12.0;
  final int mGridRows = 10, mGridColumns = 6, scaleMargin = 80;
  int mStartIndex = 0, mStopIndex = 0;
  double mMainMaxValue = double.minPositive, mMainMinValue = double.maxFinite;
  double mVolMaxValue = double.minPositive, mVolMinValue = double.maxFinite;
  double mSecondaryMaxValue = double.minPositive,
      mSecondaryMinValue = double.maxFinite;
  double mTertiaryMaxValue = double.minPositive,
      mTertiaryMinValue = double.maxFinite;
  int mSecOutCol, mTerOutCol;
  double mTranslateX = double.minPositive;
  int mMainMaxIndex = 0, mMainMinIndex = 0;
  double mMainHighMaxValue = double.minPositive,
      mMainLowMinValue = double.maxFinite;
  int mItemCount = 0;
  double mDataLen = 0.0;
  final String symbol;
  final ChartStyle chartStyle;
  static double mPointWidth;
  static double mScalePadding = 30; //60
  List<String> mFormats = [
    yyyy,
    '-',
    mm,
    '-',
    dd,
    ' ',
    HH,
    ':',
    nn
  ]; //Format time

  int dayInterval = 24 * 60 * 60;
  int monthInterval = 24 * 60 * 60 * 28;
  String chartPeriod = "";
  bool buySellButtonActivate;
  bool lineOnTick;
  BaseChartPainter(
    this.symbol,
    this.chartStyle, {
    this.datas,
    this.scaleX,
    this.chartStudies,
    this.chartPeriod,
    this.scrollX,
    this.isLongPress,
    this.isLongPress2,
    this.selectX,
    this.selectY,
    this.mainState, // = MainState.NONE,
    this.volHidden = false,
    this.secondaryState = SecondaryState.NONE,
    this.tertiaryState = SecondaryState.NONE,
    this.isLine = false,
    this.buySellButtonActivate,
    this.lineOnTick,
  }) {
    mItemCount = datas?.length ?? 0;
    mPointWidth = this.chartStyle.pointWidth;
    mDataLen = mItemCount * mPointWidth;
    initFormats();
  }

  void initFormats() {
//    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]
    if (mItemCount < 2) return;
    int firstTime = datas.first.time ?? 0;
    int secondTime = datas[1].time ?? 0;
    int time = secondTime - firstTime;
    time ~/= 1000;
    //Month line
    if (time >= monthInterval)
      mFormats = [yy, '-', mm];
    //Daily etc.
    else if (time >= dayInterval)
      mFormats = [dd, '-', M, '-', yy]; //mFormats = [yy, '-', mm, '-', dd];
    //Hour line etc.
    else
      mFormats = [mm, '-', dd, ' ', HH, ':', nn];
    if (chartPeriod == "I") mFormats = [mm, '-', dd, ' ', HH, ':', nn];
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    mCanvasHeight = size.height - mBottomPadding;
    mDisplayHeight = size.height - mTopPadding - mBottomPadding;
    mWidth = size.width;

    initRectS(size);
    calculateScaleValues();
    initChartRenderer();

    canvas.save();
    canvas.scale(1, 1);
    drawBg(canvas, size);
    drawGrid(canvas);
    drawScaleLine(canvas);
    if (datas != null && datas.isNotEmpty) {
      drawChart(canvas, size);
      drawRightText(canvas);
      /*if(Dataconstants.isFromToolsToFlashTrade==false)*/ {
        drawDate(canvas, size, chartPeriod);
      }
      //if (isLongPress == true) drawExternalDataWindow(canvas, size);
      KLineEntity d = datas.last;
      KLineEntity d2;
      if (datas.length > 2) d2 = datas[datas.length - 2];
      drawStudyText(canvas, d, d2, 1);
      drawPriceCloseLine(canvas);

      /// buysell logic

      if (isLongPress == true && buySellButtonActivate == false) {
        drawCrossHairLines(canvas, size);
        drawExternalDataWindow(canvas, size);
      }

      if (buySellButtonActivate == true) {
        //isLongPress2 == true &&
        drawBuySellButton(canvas, size);
        drawExternalDataWindow(canvas, size);
      }
      Dataconstants.y1.clear();
      Dataconstants.bQty.clear();
      Dataconstants.isBuyColorFlashTrade.clear();
      // if ( Dataconstants.defaultBuySellChartSetting==true
      // ) {// chart tick by tick
      // if ((Dataconstants.flashTradeModel.positions.length > 0) /*&&
      //     (Dataconstants.nullCheckFlashTradeLineDraw == null)*/) {
      //   //9827670470  abcd1234  19091996
      //   for (int i = 0; i < Dataconstants.flashTradeModel.positions.length; i++) {
      //     Dataconstants.y1.add(double.parse(Dataconstants.flashTradeModel.positions[i].averageprice) / 100);
      //     Dataconstants.bQty
      //         .add(Dataconstants.flashTradeModel.positions[i].openpositionqty);
      //     Dataconstants.createdFromFlashTrade.add(true); //mmmm
      //     Dataconstants.defaultBuySellChartSetting = true;
      //     Dataconstants.drawLineOnBuySell.add(true);
      //     if(Dataconstants.flashTradeModel.positions[i].openpositionflow.toUpperCase() == 'B')
      //     Dataconstants.isBuyColorFlashTrade.add(true);
      //     else
      //       Dataconstants.isBuyColorFlashTrade.add(false);
      //
      //   }
      //
      //    drawPlacedOrderLine(canvas);
      //   Dataconstants.nullCheckFlashTradeLineDraw = 0;
      // } /*else {
      //   drawPlacedOrderLine(canvas);
      // }*/
      // drawExternalDataWindow(canvas, size);
      // }

      // if ( lineOnTick==true) { //isLongPress2 == true &&
      // if ( Dataconstants.buySellButtonTickByTick==true) { //isLongPress2 == true &&
      //   drawLinOnTick(canvas, size);
      //   lineOnTick=false;
      //   // Dataconstants.buySellButtonTickByTick=false;
      //
      //   // drawExternalDataWindow(canvas, size);
      // }

      drawOverLimitLines(canvas, size, chartStudies.studyList);
    }
    canvas.restore();
  }

  void initChartRenderer();

  void drawBg(Canvas canvas, Size size);

  void drawGrid(canvas);

  void drawScaleLine(canvas);

  void drawChart(Canvas canvas, Size size);

  void drawRightText(canvas);

  void drawDate(Canvas canvas, Size size, String chartPeriod);

  void drawStudyText(
      Canvas canvas, KLineEntity data, KLineEntity dataPrev, double x);

  void drawPriceCloseLine(Canvas canvas);
  void drawPlacedOrderLine(Canvas canvas);

  void drawExternalDataWindow(Canvas canvas, Size size);

  void drawCrossHairLines(Canvas canvas, Size size);

  /// draw buySell button
  void drawBuySellButton(Canvas canvas, Size size);
  void drawLinOnTick(Canvas canvas, Size size);

  void drawOverLimitLines(Canvas canvas, Size size, List<StudyDef> studyList);

  void initRect(Size size) {
    double volHeight = volHidden != true ? mDisplayHeight * 0.15 : 0;
    double secondaryHeight =
        secondaryState != SecondaryState.NONE ? mDisplayHeight * 0.15 : 0;
    double tertiaryHeight =
        tertiaryState != SecondaryState.NONE ? mDisplayHeight * 0.15 : 0;
    double mainHeight = mDisplayHeight;
    mainHeight -= volHeight;
    mainHeight -= secondaryHeight;
    mainHeight -= tertiaryHeight;

    mMainRect = Rect.fromLTRB(0, mTopPadding, mWidth, mTopPadding + mainHeight);

    if (volHidden != true) {
      mVolRect = Rect.fromLTRB(0, mMainRect.bottom + mChildPadding, mWidth,
          mMainRect.bottom + volHeight);
    }

    //secondaryState == SecondaryState.NONE Hide side view
    if (secondaryState != SecondaryState.NONE) {
      mSecondaryRect = Rect.fromLTRB(
          0,
          mMainRect.bottom + volHeight + mChildPadding,
          mWidth,
          mMainRect.bottom + volHeight + secondaryHeight);
    }
    if (tertiaryState != SecondaryState.NONE) {
      mTertiaryRect = Rect.fromLTRB(
          0,
          mMainRect.bottom + volHeight + secondaryHeight + mChildPadding,
          mWidth,
          mMainRect.bottom + volHeight + secondaryHeight + tertiaryHeight);
    }
  }

  void initRectS(Size size) {
    double volHeight = 0;
    double secondaryHeight = 0;
    double tertiaryHeight = 0;

    double mainHeight = mDisplayHeight;
    bool v = false, s = false, t = false;
    for (int k = 1; k < chartStudies.studyList.length; k++) {
      if (!chartStudies.studyList[k].visible) continue;
      if (chartStudies.studyList[k].secondaryState == SecondaryState.VOL) {
        v = true;
        continue;
      }
      // if (chartStudies.studyList[k].secondaryState == SecondaryState.RSI) {
      if (chartStudies.studyList[k].subGraphIndex == 2) {
        s = true;
        mSecOutCol = chartStudies.studyList[k].outCols[0];
        continue;
      }
      // if (chartStudies.studyList[k].secondaryState == SecondaryState.WR) {
      if (chartStudies.studyList[k].subGraphIndex == 3) {
        t = true;
        mTerOutCol = chartStudies.studyList[k].outCols[0];
        continue;
      }
    }

    if (/*volHidden != true || */ v) {
      volHeight = mDisplayHeight * 0.15;
    }

    if (s) {
      secondaryHeight = mDisplayHeight * 0.20;
    }
    if (t) {
      tertiaryHeight = mDisplayHeight * 0.20;
    }
    mainHeight -= volHeight;
    mainHeight -= secondaryHeight;
    mainHeight -= tertiaryHeight;
    mMainRect = Rect.fromLTRB(0, mTopPadding, mWidth, mTopPadding + mainHeight);

    if (/*volHidden != true || */ v) {
      mVolRect = Rect.fromLTRB(0, mMainRect.bottom + mChildPadding, mWidth,
          mMainRect.bottom + volHeight);
    }

    if (s) {
      mSecondaryRect = Rect.fromLTRB(
          0,
          mMainRect.bottom + volHeight + mChildPadding,
          mWidth,
          mMainRect.bottom + volHeight + secondaryHeight);
    }
    if (t) {
      mTertiaryRect = Rect.fromLTRB(
          0,
          mMainRect.bottom + volHeight + secondaryHeight + mChildPadding,
          mWidth,
          mMainRect.bottom + volHeight + secondaryHeight + tertiaryHeight);
    }
  }

  calculateScaleValues() {
    if (datas == null) return;
    if (datas.isEmpty) return;
    maxScrollX = getMinTranslateX().abs() + scaleMargin;
    setTranslateXFromScrollX(scrollX);
    mStartIndex = indexOfTranslateX(xToTranslateX(0));
    mStopIndex = indexOfTranslateX(xToTranslateX(mWidth));
    for (int i = mStartIndex; i <= mStopIndex; i++) {
      var item = datas[i];
      getMainMaxMinValue(item, i);
      getVolMaxMinValue(item);
      getSecondaryMaxMinValue(item, mSecOutCol);
      getTertiaryMaxMinValue(item, mTerOutCol);
    }
  }

  void getMainMaxMinValue(KLineEntity item, int i) {
    if (isLine == true) {
      mMainMaxValue = max(mMainMaxValue, item.close);
      mMainMinValue = min(mMainMinValue, item.close);
    } else {
      double maxPrice = item.high, minPrice = item.low;
      for (int i = 0; i < mainState.length; i++) {
        if (mainState[i] == MainState.MA) {
          maxPrice = max(
              max(maxPrice, item.high), _findMaxMA(item.maValueList ?? [0]));
          minPrice =
              min(min(item.low, minPrice), _findMinMA(item.maValueList ?? [0]));
        } else if (mainState[i] == MainState.BOLL) {
          maxPrice = max(
              max(maxPrice, item.high),
              _findMaxMA(
                  item.up ?? [0])); //maxPrice = max(item.up ?? 0, item.high);
          minPrice = min(
              min(item.low, minPrice),
              _findMinMA(
                  item.dn ?? [0])); //minPrice = min(item.dn ?? 0, item.low);
        } else if (mainState[i] == MainState.DONCHAIN) {
          maxPrice = max(
              max(maxPrice, item.high),
              _findMaxMA(
                  item.dcUp ?? [0])); //maxPrice = max(item.up ?? 0, item.high);
          minPrice = min(
              min(item.low, minPrice),
              _findMinMA(
                  item.dcLw ?? [0])); //minPrice = min(item.dn ?? 0, item.low);
        } else if (mainState[i] == MainState.STREND) {
          maxPrice =
              max(max(maxPrice, item.high), _findMaxMA(item.supertrend ?? [0]));
          minPrice =
              min(min(item.low, minPrice), _findMinMA(item.supertrend ?? [0]));
        } else {
          maxPrice = item.high;
          minPrice = item.low;
        }
      }

      mMainMaxValue = max(mMainMaxValue, maxPrice);
      mMainMinValue = min(mMainMinValue, minPrice);

      if (mMainHighMaxValue < item.high) {
        mMainHighMaxValue = item.high;
        mMainMaxIndex = i;
      }
      if (mMainLowMinValue > item.low) {
        mMainLowMinValue = item.low;
        mMainMinIndex = i;
      }
    }
  }

  double _findMaxMA(List<double> a) {
    double result = double.minPositive;
    for (double i in a) {
      result = max(result, i);
    }
    return result;
  }

  double _findMinMA(List<double> a) {
    double result = double.maxFinite;
    for (double i in a) {
      result = min(result, i == 0 ? double.maxFinite : i);
    }
    return result;
  }

  void getVolMaxMinValue(KLineEntity item) {
    mVolMaxValue = max(mVolMaxValue,
        max(item.vol, max(item.MA5Volume ?? 0, item.MA10Volume ?? 0)));
    mVolMinValue = min(mVolMinValue,
        min(item.vol, min(item.MA5Volume ?? 0, item.MA10Volume ?? 0)));
  }

  void getSecondaryMaxMinValue(KLineEntity item, int oC) {
    if (secondaryState == SecondaryState.MACD) {
      if (item.dif != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.dif[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.dif[oC] ?? [0]));

        /*mSecondaryMaxValue = max(mSecondaryMaxValue,
            max(item.macd[oC], max(item.dif[oC], item.dea[oC])));
        mSecondaryMinValue = min(mSecondaryMinValue,
            min(item.macd[oC], min(item.dif[oC], item.dea[oC])));*/
      }
    } else if (secondaryState == SecondaryState.ATR) {
      if (item.atr != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.atr[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.atr[oC] ?? [0]));
      }
    } else if (secondaryState == SecondaryState.KDJ) {
      if (item.d != null) {
        mSecondaryMaxValue =
            max(mSecondaryMaxValue, max(item.k, max(item.d, item.j)));
        mSecondaryMinValue =
            min(mSecondaryMinValue, min(item.k, min(item.d, item.j)));
      }
    } else if (secondaryState == SecondaryState.RSI) {
      if (item.rsi != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.rsi[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.rsi[oC] ?? [0]));
      }
      // mSecondaryMaxValue = max(mSecondaryMaxValue, item.rsi);
      // mSecondaryMinValue = min(mSecondaryMinValue, item.rsi);
    } else if (secondaryState == SecondaryState.WR) {
      if (item.r != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.r[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.r[oC] ?? [0]));
      }
      // mSecondaryMaxValue = max(mSecondaryMaxValue, item.r);
      // mSecondaryMinValue = min(mSecondaryMinValue, item.r);
    } else if (secondaryState == SecondaryState.CCI) {
      if (item.cci != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.cci[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.cci[oC] ?? [0]));
      }
      // mSecondaryMaxValue = max(mSecondaryMaxValue, item.cci);
      // mSecondaryMinValue = min(mSecondaryMinValue, item.cci);
    } else if (secondaryState == SecondaryState.ADX) {
      if (item.Adxup != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.Adxup[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.Adxup[oC] ?? [0]));
      }
      if (item.Adxmb != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.Adxmb[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.Adxmb[oC] ?? [0]));
      }
      if (item.Adxdn != null) {
        mSecondaryMaxValue = max(mSecondaryMaxValue, (item.Adxdn[oC] ?? [0]));
        mSecondaryMinValue = min(mSecondaryMinValue, (item.Adxdn[oC] ?? [0]));
      }
    } else {
      mSecondaryMaxValue = 0;
      mSecondaryMinValue = 0;
    }
  }

  void getTertiaryMaxMinValue(KLineEntity item, int oC) {
    if (tertiaryState == SecondaryState.MACD) {
      if (item.dif != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.dif[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.dif[oC] ?? [0]));

        /*if (item.macd != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue,
            max(item.macd[oC], max(item.dif[oC], item.dea[oC])));
        mTertiaryMinValue = min(mTertiaryMinValue,
            min(item.macd[oC], min(item.dif[oC], item.dea[oC])));*/
      }
    } else if (tertiaryState == SecondaryState.ATR) {
      if (item.atr != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.atr[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.atr[oC] ?? [0]));
      }
    } else if (tertiaryState == SecondaryState.KDJ) {
      if (item.d != null) {
        mTertiaryMaxValue =
            max(mTertiaryMaxValue, max(item.k, max(item.d, item.j)));
        mTertiaryMinValue =
            min(mTertiaryMinValue, min(item.k, min(item.d, item.j)));
      }
    } else if (tertiaryState == SecondaryState.RSI) {
      if (item.rsi != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.rsi[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.rsi[oC] ?? [0]));
      }
      // mTertiaryMaxValue = max(mTertiaryMaxValue, item.rsi);
      // mTertiaryMinValue = min(mTertiaryMinValue, item.rsi);
    } else if (tertiaryState == SecondaryState.WR) {
      if (item.r != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.r[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.r[oC] ?? [0]));
      }
      // mTertiaryMaxValue = max(mTertiaryMaxValue, item.r);
      // mTertiaryMinValue = min(mTertiaryMinValue, item.r);
    } else if (tertiaryState == SecondaryState.CCI) {
      if (item.cci != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.cci[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.cci[oC] ?? [0]));
      }
      // mTertiaryMaxValue = max(mTertiaryMaxValue, item.cci);
      // mTertiaryMinValue = min(mTertiaryMinValue, item.cci);
    } else if (tertiaryState == SecondaryState.ADX) {
      if (item.Adxup != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.Adxup[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.Adxup[oC] ?? [0]));
      }
      if (item.Adxmb != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.Adxmb[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.Adxmb[oC] ?? [0]));
      }
      if (item.Adxdn != null) {
        mTertiaryMaxValue = max(mTertiaryMaxValue, (item.Adxdn[oC] ?? [0]));
        mTertiaryMinValue = min(mTertiaryMinValue, (item.Adxdn[oC] ?? [0]));
      }
    } else {
      mTertiaryMaxValue = 0;
      mTertiaryMinValue = 0;
    }
  }

  double xToTranslateXIndex(double x) => -mTranslateX + x / scaleX;

  double xToTranslateX(double x) => -mTranslateX + xScale(x) / scaleX;

  double xScale(double x) => x == 0.0 ? 1.0 : x - scaleMargin;

  int indexOfTranslateX(double translateX) =>
      _indexOfTranslateX(translateX, 0, mItemCount - 1);

  int _indexOfTranslateX(double translateX, int start, int end) {
    if (end == start || end == -1) {
      return start;
    }
    if (end - start == 1) {
      double startValue = getX(start);
      double endValue = getX(end);
      return (translateX - startValue).abs() < (translateX - endValue).abs()
          ? start
          : end;
    }
    int mid = start + (end - start) ~/ 2;
    double midValue = getX(mid);
    if (translateX < midValue) {
      return _indexOfTranslateX(translateX, start, mid);
    } else if (translateX > midValue) {
      return _indexOfTranslateX(translateX, mid, end);
    } else {
      return mid;
    }
  }

  static double getX(int position) =>
      (position * mPointWidth + mPointWidth / 2) - mScalePadding;

  KLineEntity getItem(int position) {
    return datas[position];
    // if (datas != null) {
    //   return datas[position];
    // } else {
    //   return null;
    // }
  }

  void setTranslateXFromScrollX(double scrollX) =>
      mTranslateX = scrollX + getMinTranslateX();

  double getMinTranslateX() {
    var x = -mDataLen + (mWidth - scaleMargin) / scaleX - mPointWidth / 2;
    return x >= 0 ? 0.0 : x;
  }

  int calculateSelectedX(double selectX) {
    int mSelectedIndex = indexOfTranslateX(xToTranslateXIndex(selectX));
    if (mSelectedIndex < mStartIndex) {
      mSelectedIndex = mStartIndex;
    }
    if (mSelectedIndex > mStopIndex) {
      mSelectedIndex = mStopIndex;
    }
    return mSelectedIndex;
  }

  double translateXtoX(double translateX) =>
      (translateX + mTranslateX) * scaleX;

  TextStyle getTextStyle(Color color, double fontSize) {
    return TextStyle(fontSize: fontSize, color: color);
  }

  @override
  bool shouldRepaint(BaseChartPainter oldDelegate) {
    return true;
  }
}
