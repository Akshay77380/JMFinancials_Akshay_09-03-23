import 'dart:async' show StreamSink;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../../../../util/Dataconstants.dart';
import '../../Constant/GlobalValues.dart';
import '../chart_widget.dart';
import '../entity/info_window_entity.dart';
import '../entity/k_line_entity.dart';
import '../entity/studies.dart';
import '../utils/date_format_util.dart';
import '../utils/number_util.dart';
import 'base_chart_painter.dart';
import 'base_chart_renderer.dart';
import 'priceohlc_canvas.dart';
import 'secondary_renderer.dart';
import 'vol_renderer.dart';

class ChartPainter extends BaseChartPainter {
  final String symbol;
  bool scaleCanvas;
  final String chartPeriod;
  final double chartInterval;
  double contentPadding = 1.0;
  static get maxScrollX => BaseChartPainter.maxScrollX;
  BaseChartRenderer mMainRenderer;
  BaseChartRenderer mVolRenderer, mSecondaryRenderer, mTertiaryRenderer;
  StreamSink<InfoWindowEntity> sink;
  Color upColor, dnColor;
  Color ma5Color, ma10Color, ma30Color;
  Color volColor;
  Color macdColor, difColor, deaColor, jColor;
  List<Color> bgColor;
  int fixedLength;
  List<int> maDayList;
  NumberFormat indianRateDisplay;
  final ChartColors chartColors;
  Paint selectPointPaint,
      selectorBorderPaint,
      nowPricePaint,
      crosshairDottedPaint;
  final ChartStyle chartStyle;
  final bool hideGrid;
  final bool showNowPrice;
  final VerticalTextAlignment verticalTextAlignment;
  final bool buySellButtonActivate;
  final bool lineOnTick;

  ChartPainter(
    this.symbol,
    this.chartStyle,
    this.chartColors,
    this.scaleCanvas,
    this.chartPeriod,
    this.chartInterval,
    this.contentPadding, {
    datas,
    chartStudies,
    scaleX,
    scrollX,
    isLongPass,
    isLongPass2,
    selectX,
    selectY,
    mainState,
    volHidden,
    secondaryState,
    tertiaryState,
    this.sink,
    bool isLine = false,
    this.hideGrid = false,
    this.showNowPrice = true,
    this.verticalTextAlignment = VerticalTextAlignment.right,
    this.bgColor,
    this.fixedLength = 2,
    this.maDayList = const [10, 50, 200],
    this.buySellButtonActivate,
    this.lineOnTick,
  })  : assert(bgColor == null || bgColor.length >= 2),
        super(
          symbol,
          chartStyle,
          datas: datas,
          chartStudies: chartStudies,
          scaleX: scaleX,
          chartPeriod: chartPeriod,
          scrollX: scrollX,
          isLongPress: isLongPass,
          isLongPress2: isLongPass2,
          selectX: selectX,
          selectY: selectY,
          mainState: mainState,
          volHidden: volHidden,
          secondaryState: secondaryState,
          tertiaryState: tertiaryState,
          isLine: isLine,
          buySellButtonActivate: buySellButtonActivate,
          lineOnTick: lineOnTick,
        ) {
    selectPointPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 0.5
      ..color = this.chartColors.selectFillColor;
    selectorBorderPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 0.05
      ..style = PaintingStyle.stroke
      ..color = this.chartColors.SolidCrossColor;
    nowPricePaint = Paint()
      ..strokeWidth = this.chartStyle.nowPriceLineWidth
      ..isAntiAlias = true;
    crosshairDottedPaint = Paint()
      ..strokeWidth = this.chartStyle.nowPriceLineWidth
      ..isAntiAlias = true;
  }

  @override
  void initChartRenderer() {
    scaleCanvas = scaleCanvas;
    if (datas != null) {
      var t = datas[0];
      fixedLength =
          NumberUtil.getMaxDecimalLength(t.open, t.close, t.high, t.low);
    }

    NumberFormat indianRateDisplay = this.chartStyle.indianRateDisplay;

    mMainRenderer = PriceOHLCCanvas(
        mMainRect,
        mCanvasHeight,
        mMainMaxValue,
        mMainMinValue,
        mTopPadding,
        contentPadding,
        mainState,
        isLine,
        fixedLength,
        this.chartStyle,
        this.chartColors,
        this.chartStudies,
        this.scaleX,
        indianRateDisplay,
        this.chartPeriod,
        this.chartInterval,
        bgColor[0],
        maDayList);
    if (mVolRect != null) {
      mVolRenderer = VolRenderer(
          mVolRect,
          mVolMaxValue,
          mVolMinValue,
          mChildPadding,
          fixedLength,
          this.chartStyle,
          this.chartColors,
          bgColor[0]);
    }
    if (mSecondaryRect != null) {
      mSecondaryRenderer = SecondaryRenderer(
          mSecondaryRect,
          mSecondaryMaxValue,
          mSecondaryMinValue,
          mChildPadding,
          secondaryState,
          fixedLength,
          chartStyle,
          chartColors,
          this.scaleX,
          bgColor[0]);
    }
    if (mTertiaryRect != null) {
      mTertiaryRenderer = SecondaryRenderer(
          mTertiaryRect,
          mTertiaryMaxValue,
          mTertiaryMinValue,
          mChildPadding,
          tertiaryState,
          fixedLength,
          chartStyle,
          chartColors,
          this.scaleX,
          bgColor[0]);
    }
    _setColors();
  }

  @override
  void drawBg(Canvas canvas, Size size) {
    Paint mBgPaint = Paint();
    Gradient mBgGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: bgColor ?? //ssss
          [Color(0xff171b26), Color(0xff171b26)],
    );
    Rect mainRect =
        Rect.fromLTRB(0, 0, mMainRect.width, mMainRect.height + mTopPadding);
    canvas.drawRect(
        mainRect, mBgPaint..shader = mBgGradient.createShader(mainRect));

    if (mVolRect != null) {
      Rect volRect = Rect.fromLTRB(
          0, mVolRect.top - mChildPadding, mVolRect.width, mVolRect.bottom);
      canvas.drawRect(
          volRect, mBgPaint..shader = mBgGradient.createShader(volRect));
    }

    if (mSecondaryRect != null) {
      Rect secondaryRect = Rect.fromLTRB(0, mSecondaryRect.top - mChildPadding,
          mSecondaryRect.width, mSecondaryRect.bottom);
      canvas.drawRect(secondaryRect,
          mBgPaint..shader = mBgGradient.createShader(secondaryRect));
    }
    if (mTertiaryRect != null) {
      Rect secondaryRect = Rect.fromLTRB(0, mTertiaryRect.top - mChildPadding,
          mTertiaryRect.width, mTertiaryRect.bottom);
      canvas.drawRect(secondaryRect,
          mBgPaint..shader = mBgGradient.createShader(secondaryRect));
    }
    Rect dateRect =
        Rect.fromLTRB(0, size.height - mBottomPadding, size.width, size.height);
    canvas.drawRect(
        dateRect, mBgPaint..shader = mBgGradient.createShader(dateRect));
  }

  @override
  void drawGrid(canvas) {
    if (scaleCanvas) return;
    if (!hideGrid) {
      mMainRenderer.drawGrid(
          canvas, mGridRows, mGridColumns, true, false, true);
      //Do gridlines only for PriceOHLC graph
      //mVolRenderer?.drawGrid(canvas, mGridRows, mGridColumns, false);
      //mSecondaryRenderer?.drawGrid(canvas, mGridRows, mGridColumns, false);
    }
  }

  @override
  void drawScaleLine(canvas) {
    mMainRenderer.drawScaleLine(canvas);
    mVolRenderer?.drawScaleLine(canvas);
    mSecondaryRenderer?.drawScaleLine(canvas);
    mTertiaryRenderer?.drawScaleLine(canvas);
  }

  @override
  void drawChart(Canvas canvas, Size size) {
    ///zzzz
    if (this.scaleCanvas) return;
    canvas.save();
    Dataconstants.chartHeight = size.height;
    Dataconstants.chartWidth = size.width;
    // canvas.translate(mTranslateX * scaleX, 0.0);
    // canvas.scale(scaleX, 1.0);
    canvas.scale(1, 1);
    // int k = mStartIndex;
    var j = mStopIndex;
    for (int i = mStartIndex; datas != null && i <= mStopIndex; i++) {
      KLineEntity curPoint = datas[i];
      if (curPoint == null) continue;
      KLineEntity lastPoint = i == 0 ? curPoint : datas[i - 1];
      // var index = calculateSelectedX(selectX);
      double curX = BaseChartPainter.getX(i);
      //double curX = translateXtoX(getX(i));

      double lastX = i == 0 ? curX : BaseChartPainter.getX(i - 1);

      //double lastX = i == 0 ? curX : translateXtoX(getX(i - 1));
      // k++;
      // if ((k < mStopIndex)) continue;
      //first subgraph PriceOHLC
      canvas.translate(mTranslateX * scaleX, 0.0);
      canvas.scale(scaleX, 1.0);

      if (!hideGrid)
        mMainRenderer.drawGridCalendar(lastPoint, curPoint, canvas, curX, true);
      //second subgraph Volume
      mMainRenderer.drawChart(lastPoint, curPoint, lastX, curX, size, canvas);
      mVolRenderer?.drawChart(lastPoint, curPoint, lastX, curX, size, canvas);
      canvas.restore();
      canvas.save();
      canvas.translate(0.0, 0.0);
      canvas.scale(1, 1);
      curX = translateXtoX(BaseChartPainter.getX(i));
      lastX = i == 0 ? curX : translateXtoX(BaseChartPainter.getX(i - 1));
      // if (Dataconstants.buySellButtonTickByTick == true) {
      //   Dataconstants.flashTradeDataPoints.add(new flashTradeDataPoint());
      //   Dataconstants.timerChartPointHide
      //       .add(DateTime.now().millisecondsSinceEpoch);
      //   Dataconstants.buySellPointColor == true
      //       ? Dataconstants.isBuyColor.add(true)
      //       : Dataconstants.isBuyColor.add(false);
      //   var j = Dataconstants.flashTradeDataPoints.length - 1;
      //   Dataconstants.flashTradeDataPoints[j].index = datas.length - 1;
      //   Dataconstants.flashTradeDataPoints[j].currentX =
      //       translateXtoX(BaseChartPainter.getX(i));
      //   Dataconstants.flashTradeDataPoints[j].curPrice =
      //       datas[datas.length - 1].close;
      //   Dataconstants.flashTradeDataPoints[j].lastPrice = lastPoint.close;
      //   Dataconstants.buySellButtonTickByTick = false;
      //   Dataconstants.buySellButtonTickByTick2 = true;
      // }
      // for (int i = 0; i < Dataconstants.flashTradeDataPoints.length; i++) {
      //   if (Dataconstants.flashTradeDataPoints[i].index != null) {
      //     Dataconstants.flashTradeDataPoints[i].lastX = translateXtoX(
      //         BaseChartPainter.getX(
      //             Dataconstants.flashTradeDataPoints[i].index));
      //   }
      // }

      mMainRenderer.drawChartPrimaryStudy(
          // line chart tick by tick
          lastPoint,
          curPoint,
          lastX,
          curX,
          size,
          canvas);
      //third subgraph study
      mSecondaryRenderer?.drawChart(
          lastPoint, curPoint, lastX, curX, size, canvas);
      //fourth subgraph study
      mTertiaryRenderer?.drawChart(
          lastPoint, curPoint, lastX, curX, size, canvas);
    }
    Global.chartLow = mMainLowMinValue;
    Global.chartHigh = mMainMaxValue;
    Global.chartVisibleClose = datas[mStopIndex].close;
    Global.chartClose = datas[datas.length - 1].close;
    // if (isLongPress == true) drawCrossHairLines(canvas, size);
    canvas.restore();
  }

  @override
  void drawRightText(canvas) {
    // if (!this.scaleCanvas) return;
    var textStyle = getTextStyle(
        bgColor[0].computeLuminance() > 0.5
            ? this.chartColors.studyLabelTextColorLight
            : this.chartColors.studyLabelTextColor,
        this.chartColors.defaultTextSize);
    /*if (!hideGrid)*/ {
      mMainRenderer.drawRightText(canvas, textStyle, mGridRows);
    }
    mVolRenderer?.drawRightText(canvas, textStyle, mGridRows);
    mSecondaryRenderer?.drawRightText(canvas, textStyle, mGridRows);
    mTertiaryRenderer?.drawRightText(canvas, textStyle, mGridRows);
  }

  @override
  void drawDate(Canvas canvas, Size size, String chartPeriod) {
    if (this.scaleCanvas) return;
    double columnSpace = size.width / mGridColumns;
    columnSpace -= 5;
    double startX =
        BaseChartPainter.getX(mStartIndex) - BaseChartPainter.mPointWidth / 2;
    double stopX =
        BaseChartPainter.getX(mStopIndex) + BaseChartPainter.mPointWidth / 2;
    double y = 0.0;
    double fontSize = chartPeriod == "I" ? 8.5 : 10.0;
    for (var i = 1; i <= mGridColumns; ++i) {
      double translateX = xToTranslateXIndex(columnSpace * i);
      if (translateX >= startX && translateX <= stopX) {
        int index = indexOfTranslateX(translateX);
        if (datas[index] == null) continue;
        TextPainter tp = getTextPainter(
            getDate(datas[index].time),
            bgColor[0].computeLuminance() > 0.5
                ? this.chartColors.studyLabelTextColorLight
                : this.chartColors.studyLabelTextColor,
            fontsize: fontSize);
        y = size.height - (mBottomPadding - tp.height) / 2 - tp.height;
        tp.paint(canvas, Offset(columnSpace * i - tp.width / 2, y));
      }
    }

//    double translateX = xToTranslateX(0);
//    if (translateX >= startX && translateX <= stopX) {
//      TextPainter tp = getTextPainter(getDate(datas[mStartIndex].id));
//      tp.paint(canvas, Offset(0, y));
//    }
//    translateX = xToTranslateX(size.width);
//    if (translateX >= startX && translateX <= stopX) {
//      TextPainter tp = getTextPainter(getDate(datas[mStopIndex].id));
//      tp.paint(canvas, Offset(size.width - tp.width, y));
//    }
  }

  @override
  void drawExternalDataWindow(Canvas canvas, Size size) {
    // return;
    if (this.scaleCanvas) return;
    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index);
    double displayPoint = selectY - 0; //point.close
    displayPoint = max(displayPoint, mTopPadding);
    displayPoint = min(displayPoint, mCanvasHeight);
    double yPixel = getYPixel(displayPoint);

    yPixel = getPixelByGraph(selectX, displayPoint, cP:contentPadding);
    if (yPixel == -1) return;

    TextPainter tp = getTextPainter(
        this.chartStyle.indianRateDisplay.format(yPixel),
        chartColors.crossTextColor,
        fontsize: 12.0);
    double textHeight = tp.height;
    double textWidth = tp.width;

    double w1 = 2;
    double w2 = 1;
    double r = textHeight / 2 + w2;
    double y = displayPoint; //getMainY(point.close);
    double x;
    bool isLeft = false;
    /*if (translateXtoX(getX(index)) < mWidth / 2) {
      //right side of screen
      isLeft = false;
      x = 1;
      Path path = new Path();
      path.moveTo(x, y - r);
      path.lineTo(x, y + r);
      path.lineTo(textWidth + 2 * w1, y + r);
      path.lineTo(textWidth + 2 * w1 + w2, y);
      path.lineTo(textWidth + 2 * w1, y - r);
      path.close();
      canvas.drawPath(path, selectPointPaint);
      canvas.drawPath(path, selectorBorderPaint);
      tp.paint(canvas, Offset(x + w1, y - textHeight / 2));
    } else*/
    {
      //left side of screen
      //isLeft = true;
      isLeft = (translateXtoX(BaseChartPainter.getX(index)) > mWidth / 1);
      // //print(isLeft);
      x = mWidth - textWidth - 1 - 2 * w1 - w2;
      double adjust = 0;
      if (isLeft) {
        adjust = (x + 1);
      }

      Path path = new Path();
      path.moveTo(x - adjust, y);
      path.lineTo(x - adjust /*+ w2*/, y + r);
      path.lineTo(mWidth - adjust, y + r);
      path.lineTo(mWidth - adjust, y - r);
      path.lineTo(x - adjust /*+ w2*/, y - r);
      path.close();
      canvas.drawPath(path, selectPointPaint);
      canvas.drawPath(path, selectorBorderPaint);
      tp.paint(canvas, Offset(x - adjust + w1 + w2, y - textHeight / 2));
    }
    TextPainter dateTp = getTextPainter(
        getDate(point.time), chartColors.crossTextColor,
        fontsize: 12.0);
    textWidth = dateTp.width;
    r = textHeight / 2;
    x = translateXtoX(BaseChartPainter.getX(index));
    y = size.height - mBottomPadding + 2;

    if (x < textWidth + 2 * w1) {
      x = 1 + textWidth / 2 + w1;
    } else if (mWidth - x < textWidth + 2 * w1) {
      x = mWidth - 1 - textWidth / 2 - w1;
    }
    double baseLine = textHeight / 2;
    canvas.drawRect(
        Rect.fromLTRB(x - textWidth / 2 - w1, y, x + textWidth / 2 + w1,
            y + baseLine + r),
        selectPointPaint);
    canvas.drawRect(
        Rect.fromLTRB(x - textWidth / 2 - w1, y, x + textWidth / 2 + w1,
            y + baseLine + r),
        selectorBorderPaint);

    dateTp.paint(canvas, Offset(x - textWidth / 2, y));
    //Long press to show the details of this data
    // sink?.add(InfoWindowEntity(point, isLeft: isLeft));
  }

  @override
  void drawStudyText(
      Canvas canvas, KLineEntity data, KLineEntity dataPrev, double x) {
    if (this.scaleCanvas) return;
    //Long press to display the data being pressed
    if (isLongPress) {
      var index = calculateSelectedX(selectX);
      data = getItem(index);
      if (index > 0)
        dataPrev = getItem(index - 1);
      else
        dataPrev = null;
    }
    //Release to display the last data
    mMainRenderer.drawText(canvas, data, dataPrev, x, this.symbol);
    mVolRenderer?.drawText(canvas, data, dataPrev, x, this.symbol);
    mSecondaryRenderer?.drawText(canvas, data, dataPrev, x, this.symbol);
    mTertiaryRenderer?.drawText(canvas, data, dataPrev, x, this.symbol);
  }

  @override
  void drawMaxAndMin(Canvas canvas) {
    return;
    if (this.scaleCanvas) return;
    if (isLine == true) return;
    //Plot the maximum and minimum values
    double x = translateXtoX(BaseChartPainter.getX(mMainMinIndex));
    double y = getMainY(mMainLowMinValue);
    if (x < mWidth / 2) {
      //Draw right
      TextPainter tp = getTextPainter(
          "── " + mMainLowMinValue.toStringAsFixed(fixedLength),
          chartColors.minColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter(
          mMainLowMinValue.toStringAsFixed(fixedLength) + " ──",
          chartColors.minColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }
    x = translateXtoX(BaseChartPainter.getX(mMainMaxIndex));
    y = getMainY(mMainHighMaxValue);
    if (x < mWidth / 2) {
      //Draw right
      TextPainter tp = getTextPainter(
          "── " + mMainHighMaxValue.toStringAsFixed(fixedLength),
          chartColors.maxColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter(
          mMainHighMaxValue.toStringAsFixed(fixedLength) + " ──",
          chartColors.maxColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }
  }

  /*@override
  void drawPriceCloseLine(Canvas canvas) {
    // return;
    if (this.scaleCanvas) return;
    if (!this.showNowPrice) {
      return;
    }
    if (isLine == true || datas == null) {
      return;
    }
    double value = datas.last.close;
    List<double> valueStudyMainArr = [];
    List<double> yStudyMainArr = [];
    List<Color> maColors = [];
    double valueStudyMain = 0.0, valueStudySecond = 0.0;
    int i = 0;
    if (mainState != MainState.NONE) {
      valueStudyMain = datas.last.maValueList[0];
      for (double item in datas.last.maValueList) {
        valueStudyMainArr.add(item);
        yStudyMainArr.add(getMainY(item));
        switch (i) {
          case 0:
            maColors.add(this.chartColors.ma5Color);
            break;
          case 1:
            maColors.add(this.chartColors.ma10Color);
            break;
          case 2:
            maColors.add(this.chartColors.ma30Color);
            break;
        }
        i++;
      }
    }
    valueStudySecond = datas.last.rsi;
    double y = getMainY(value);
    // double yStudy = getMainY(valueStudyMain);
    double yStudyThird = getSecondY(valueStudySecond);
    //skip drawing outside scale view
    // if (y > getMainY(mMainLowMinValue) || y < getMainY(mMainHighMaxValue)) {
    //   return;
    // }
    TextPainter tp;
    double offsetX;
    double top;

    for (int i = 0; i < datas.last.maValueList.length; i++) {
      tp = getTextPainter(
          this.chartStyle.indianRateDisplay.format(valueStudyMainArr[i]),
          value >= datas.last.open
              ? this.chartColors.nowPriceTextColor2
              : this.chartColors.nowPriceTextColor,
          fontsize: 13.0);
      top = yStudyMainArr[i] - tp.height / 2;
      nowPricePaint..color = maColors[min(i, maColors.length - 1)];
      switch (verticalTextAlignment) {
        case VerticalTextAlignment.left:
          offsetX = 0;
          break;
        case VerticalTextAlignment.right:
          offsetX = mWidth - tp.width;
          break;
      }
      canvas.drawRect(
          Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
          nowPricePaint);
      tp.paint(canvas, Offset(offsetX, top));
    }

    if (yStudyThird > getSecondY(mSecondaryMinValue) ||
        yStudyThird < getSecondY(mSecondaryMaxValue)) {
      return;
    }
    if (yStudyThird == -1) return;

    tp = getTextPainter(
        this.chartStyle.indianRateDisplay.format(valueStudySecond),
        value >= datas.last.open
            ? this.chartColors.nowPriceTextColor2
            : this.chartColors.nowPriceTextColor,
        fontsize: 13.0);
    top = yStudyThird - tp.height / 2;
    nowPricePaint..color = this.chartColors.ma5Color;
    switch (verticalTextAlignment) {
      case VerticalTextAlignment.left:
        offsetX = 0;
        break;
      case VerticalTextAlignment.right:
        offsetX = mWidth - tp.width;
        break;
    }
    canvas.drawRect(
        Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
        nowPricePaint);
    tp.paint(canvas, Offset(offsetX, top));

    if (y < getMainY(mMainLowMinValue) || y > getMainY(mMainHighMaxValue)) {
      nowPricePaint
        ..color = value >= datas.last.open
            ? this.chartColors.upColor //nowPriceUpColor
            : this.chartColors.dnColor; //nowPriceDnColor;
      //Draw horizontal lines first
      double startX = 0;
      // final max = -mTranslateX + (mWidth - 100) / scaleX; //giving problem in case of very few candles
      final max = mWidth;
      final space =
          this.chartStyle.nowPriceLineSpan + this.chartStyle.nowPriceLineLength;
      while (startX < max) {
        canvas.drawLine(
            Offset(startX, y),
            Offset(startX + this.chartStyle.nowPriceLineLength, y),
            nowPricePaint);
        startX += space;
      }
      //Draw background and text again
      tp = getTextPainter(
          this.chartStyle.indianRateDisplay.format(value),
          value >= datas.last.open
              ? this.chartColors.nowPriceTextColor2
              : this.chartColors.nowPriceTextColor,
          fontsize: 13.0);

      switch (verticalTextAlignment) {
        case VerticalTextAlignment.left:
          offsetX = 0;
          break;
        case VerticalTextAlignment.right:
          offsetX = mWidth - tp.width;
          break;
      }
      top = y - tp.height / 2;
      canvas.drawRect(
          Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
          nowPricePaint);
      tp.paint(canvas, Offset(offsetX, top));
      /*
    TextPainter tp = getTextPainter(
        value.toStringAsFixed(fixedLength), this.chartColors.nowPriceTextColor);
    double left = mWidth - 45; //0;
    double top = y - tp.height / 2;
    canvas.drawRect(Rect.fromLTRB(left, top, left + tp.width, top + tp.height),
        nowPricePaint);
    tp.paint(canvas, Offset(left, top));
    */
    }
  }*/

  @override
  void drawPriceCloseLine(Canvas canvas) {
    // return;
    if (this.scaleCanvas) return;
    if (!this.showNowPrice) {
      return;
    }
    if (isLine == true || datas == null) {
      return;
    }
    double value = datas.last.close;
    double y = getMainY(value);
    List<double> y1 = [];
    List<double> y1Sub = [];
    List<Color> colors = [];
    List<Color> colors2 = [];
    TextPainter tp;
    double offsetX;
    double top;

    // y1 = List<double>.filled(datas.last.maValueList.length + 1, 0);
    // colors = List<Color>.filled(
    // datas.last.maValueList.length + 1, Color.fromARGB(0, 0, 0, 0));
    //y1.add(datas.last.close);
    // y1[y1.length - 1] = datas.last.close;
    // for (int i = 0; i < datas.last.maValueList?.length; i++) {
    // y1.add(datas.last.maValueList[i]);
    // y1[datas.last.maValueList.length - 1 - i] = datas.last.maValueList[i];
    // }

    int k; // = datas.last.maValueList.length - 1;
    StudyDef stDef;
    for (int j = 2; j < chartStudies.studyList.length; j++) {
      k = 0;
      stDef = chartStudies.studyList[j];
      if (!stDef.visible) continue;
      if (stDef.mainState != MainState.NONE) {
        switch (stDef.studyType) {
          case TStudyType.DSDummyFirst:
          case TStudyType.STPrice:
          case TStudyType.STVolume:
          case TStudyType.STVwap:
          case TStudyType.STAdx:
          case TStudyType.DSDummyLast:
            break;
          case TStudyType.STAvgS:
          case TStudyType.STAvgE:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1.add(datas.last.maValueList[stDef.outCols[k]]);
            }
            for (k = 0; k < stDef.colorCnt; k++) {
              colors.add(stDef.colors[k]);
            }
            break;
          case TStudyType.STSuperTrend:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1.add(datas.last.supertrend[stDef.outCols[k]]);
            }
            colors.add(stDef.colors[0]);
            break;
          case TStudyType.STBoll:
            {
              //int l = 0;
              for (k = 0; k < stDef.outColCnt; k += 3) {
                //if (++l == k)
                y1.add(datas.last.up[stDef.outCols[k]]);
                y1.add(datas.last.mb[stDef.outCols[k + 1]]);
                y1.add(datas.last.dn[stDef.outCols[k + 2]]);
              }
              for (k = 0; k < stDef.colorCnt; k++) {
                colors.add(stDef.colors[k]);
              }
              //y1.add(datas.last.up);
              // y1.add(datas.last.mb);
              // y1.add(datas.last.dn);
              // colors.add(stDef.colors[0]);
              // colors.add(stDef.colors[1]);
              // colors.add(stDef.colors[2]);
            }
            break;
          case TStudyType.STDonC:
            {
              for (k = 0; k < stDef.outColCnt; k += 3) {
                y1.add(datas.last.dcUp[stDef.outCols[k]]);
                y1.add(datas.last.dcMd[stDef.outCols[k + 1]]);
                y1.add(datas.last.dcLw[stDef.outCols[k + 2]]);
              }
              for (k = 0; k < stDef.colorCnt; k++) {
                colors.add(stDef.colors[k]);
              }
            }
            break;
          case TStudyType.STSwing:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1.add(datas.last.swing[stDef.outCols[k]]);
            }
            for (k = 0; k < stDef.colorCnt; k++) {
              colors.add(stDef.colors[k]);
            }
            break;
          case TStudyType.STPriceTyp:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1.add(datas.last.priceTyp[stDef.outCols[k]]);
            }
            colors.add(stDef.colors[0]);
            break;
          case TStudyType.STATR:
          case TStudyType.STMacd:
          case TStudyType.STCCI:
          case TStudyType.STRsi:
          case TStudyType.STWlmR:
          case TStudyType.STStochKDJ:
            break;
        }
      } else if (stDef.mainState == MainState.NONE) {
        switch (stDef.studyType) {
          case TStudyType.DSDummyFirst:
          case TStudyType.STPrice:
          case TStudyType.STVolume:
          case TStudyType.DSDummyLast:
          case TStudyType.STAvgS:
          case TStudyType.STAvgE:
          case TStudyType.STDonC:
          case TStudyType.STSuperTrend:
            {
              //Skip.
            }
            break;
          case TStudyType.STRsi:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1Sub.add(datas.last.rsi[stDef.outCols[k]]);
            }
            colors2.add(stDef.colors[0]);
            break;
          case TStudyType.STWlmR:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1Sub.add(datas.last.r[stDef.outCols[k]]);
            }
            colors2.add(stDef.colors[0]);
            break;
          case TStudyType.STBoll:
          case TStudyType.STSwing:
            break;
          case TStudyType.STMacd:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1Sub.add(datas.last.dif[stDef.outCols[k]]);
            }
            colors2.add(stDef.colors[0]);
            break;
          case TStudyType.STCCI:
            {
              for (k = 0; k < stDef.outColCnt; k++) {
                y1Sub.add(datas.last.cci[stDef.outCols[k]]);
              }
              colors2.add(stDef.colors[0]);
              break;
            }
            break;
          case TStudyType.STATR:
            for (k = 0; k < stDef.outColCnt; k++) {
              y1Sub.add(datas.last.atr[stDef.outCols[k]]);
            }
            colors2.add(stDef.colors[0]);
            break;
          case TStudyType.STVwap:
          case TStudyType.STPriceTyp:
            break;
          case TStudyType.STStochKDJ:
            y1Sub.add(datas.last.k);
            y1Sub.add(datas.last.d);
            y1Sub.add(datas.last.j);
            colors2.add(stDef.colors[0]);
            colors2.add(stDef.colors[1]);
            colors2.add(stDef.colors[2]);
            break;
          case TStudyType.STAdx:
            {
              y1Sub.add(datas.last.Adxdn[0]);
              colors2.add(stDef.colors[2]);
            }
            break;
        }
      }
    }

    y1.add(datas.last.close);
    colors.add(value >= datas.last.open
        ? this.chartColors.upColor
        : this.chartColors.dnColor);

    for (int i = 0; i < y1.length; i++) {
      y = getMainY(y1[i]);
      if (_checkOutOfBounds(y1[i], 0)) continue;
      /*if (y < getMainY(mMainLowMinValue) || y > getMainY(mMainHighMaxValue))*/ {
        nowPricePaint..color = colors[i];
        //Draw horizontal lines first
        if (i == y1.length - 1) {
          double startX = 0;
          // final max = -mTranslateX + (mWidth - 100) / scaleX; //giving problem in case of very few candles
          final max = mWidth;
          final space = this.chartStyle.nowPriceLineSpan +
              this.chartStyle.nowPriceLineLength;
          while (startX < max) {
            canvas.drawLine(
                Offset(startX, y),
                Offset(startX + this.chartStyle.nowPriceLineLength, y),
                nowPricePaint);
            startX += space;
          }
        }
        //Draw background and text again
        tp = getTextPainter(
            this.chartStyle.indianRateDisplay.format(y1[i]),
            value >= datas.last.open
                ? this.chartColors.nowPriceTextColor2
                : (i == y1.length - 1)
                    ? this.chartColors.nowPriceTextColor
                    : this.chartColors.nowPriceTextColor2,
            fontsize: 13.0);

        switch (verticalTextAlignment) {
          case VerticalTextAlignment.left:
            offsetX = 0;
            break;
          case VerticalTextAlignment.right:
            offsetX = mWidth - tp.width;
            break;
        }
        top = y - tp.height / 2;
        canvas.drawRect(
            Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
            nowPricePaint);
        tp.paint(canvas, Offset(offsetX, top));
      }
    }
    for (int i = 0; i < y1Sub.length; i++) {
      if (!_checkOutOfBounds(y1Sub[i], i + 2)) {
        y = getSubY(y1Sub[i], i + 2);
        nowPricePaint..color = colors2[i];
        //Draw background and text again
        tp = getTextPainter(
            this.chartStyle.indianRateDisplay.format(y1Sub[i]),
            value >= datas.last.open
                ? this.chartColors.nowPriceTextColor2
                : this.chartColors.nowPriceTextColor2,
            fontsize: 13.0);

        switch (verticalTextAlignment) {
          case VerticalTextAlignment.left:
            offsetX = 0;
            break;
          case VerticalTextAlignment.right:
            offsetX = mWidth - tp.width;
            break;
        }
        top = y - tp.height / 2;
        canvas.drawRect(
            Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
            nowPricePaint);
        tp.paint(canvas, Offset(offsetX, top));
      }
    }
  }

  void drawPlacedOrderLine(Canvas canvas) {
    // return;
    if (this.scaleCanvas) return;
    if (!this.showNowPrice) {
      return;
    }
    if (isLine == true || datas == null) {
      return;
    }
    // double value = Dataconstants.ltpTickByTick;
    // double y = getMainY(value);
    // // Dataconstants.y1.add(Dataconstants.ltpTickByTick);
    // // List<double> y1 = [];
    // TextPainter tp;
    // double offsetX;
    // double top;
    // var y1=Dataconstants.y1.length;
    // // y1.add(Dataconstants.ltpTickByTick);
    /*Dataconstants.y1.clear();
    Dataconstants.y1.add(42200.0);
    Dataconstants.isBuyColorFlashTrade.clear();
    Dataconstants.isBuyColorFlashTrade.add(true);
    Dataconstants.bQty.clear();
    Dataconstants.bQty.add('100');*/
    for (int i = 0; i < Dataconstants.y1.length; i++) {
      /*if ((Dataconstants.createdFromFlashTrade[i] &&
              Dataconstants.isFromToolsToFlashTrade) ||
          (!Dataconstants.createdFromFlashTrade[i] &&
              !Dataconstants.isFromToolsToFlashTrade))*/
      {
        //
        // if ((DateTime.now().millisecondsSinceEpoch - Dataconstants.timerChart[i] <= 120000)
        //     ||(Dataconstants.timerFlashTradeStartTime[i]==Dataconstants.timerFlashTradeEndTime[i]))

        {
          double value = Dataconstants.y1[i];
          double y = getMainY(value);
          if(y> mMainRenderer.chartRect.bottom)
            continue;
          // Dataconstants.y1.add(Dataconstants.ltpTickByTick);
          // List<double> y1 = [];
          TextPainter tp;
          double offsetX;
          double top;
          var y1 = Dataconstants.y1.length;
          // y1.add(Dataconstants.ltpTickByTick);

          // if(Dataconstants.isFromToolsToFlashTrade == true) {
          nowPricePaint
            ..color = Dataconstants.isBuyColorFlashTrade[i]
                ? Color(0xff089981)
                : Color(0xffff3333);
          // }else{

          //   nowPricePaint
          //     ..color = Dataconstants.placedOrderLineTickByTick[i]
          //         ? Color(0xff66ff33)
          //         : Color(0xffff3333);
          // // }

          // nowPricePaint..color=Color(0xffff3333);

          {
            double startX = 0;
            final max = mWidth-4 /*- (scaleMargin - 18)*/;
            final space = this.chartStyle.nowPriceLineSpan +
                this.chartStyle.nowPriceLineLength +
                2;
            while (startX < max) {
              canvas.drawLine(
                  Offset(startX, y),
                  Offset(startX + this.chartStyle.nowPriceLineLength, y),
                  nowPricePaint);
              startX += space;
            }
          }
          //Draw background and text again
          // for(int i= 0;i<y1.length;i++ ){}

          tp = getTextPainter(
              this.chartStyle.indianRateDisplay.format(Dataconstants.y1[i]) +
                  '\nQty: ' +
                  Dataconstants.bQty[i] ?? 0,
              Colors.grey[200],
              /*value >= datas.last.open
                  ? this.chartColors.nowPriceTextColor2
                  : this.chartColors.nowPriceTextColor2,*/
              fontsize: 12.0);
          switch (verticalTextAlignment) {
            case VerticalTextAlignment.left:
              offsetX = 0;
              break;
            case VerticalTextAlignment.right:
              offsetX = mWidth - tp.width -4 /*- (scaleMargin - 18)*/;
              break;
          }
          top = y - tp.height / 2;
          canvas.drawRect(
              Rect.fromLTRB(offsetX, top, offsetX + tp.width, top + tp.height),
              nowPricePaint);
          tp.paint(canvas, Offset(offsetX, top));
        }
      }
    }
  }

  ///Draw cross lines
  @override
  void drawCrossHairLines(Canvas canvas, Size size) {
    drawCrossHairLines2(canvas, size);
    return;
    /*double strokeWidth = 2.0;
    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index);
    Paint paintY = Paint()
      ..color = this.chartColors.vCrossColor
      ..strokeWidth = this.chartStyle.vCrossWidth
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
    double x = getX(index);
    double y = getMainY(point.close);
    // line graph vertical line
    canvas.drawLine(Offset(x, mTopPadding),
        Offset(x, size.height - mBottomPadding), paintY);

    Paint paintX = Paint()
      ..color = this.chartColors.vCrossColor //hCrossColor
      ..strokeWidth = this.chartStyle.hCrossWidth
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
    // Line graph
    canvas.drawLine(Offset(-mTranslateX, y),
        Offset(-mTranslateX + mWidth / scaleX, y), paintX);
    if (scaleX >= 1) {
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(x, y), height: 2.0 * scaleX, width: 2.0),
          paintX);
    } else {
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(x, y), height: 2.0, width: 2.0 / scaleX),
          paintX);
    }*/
  }

  void drawCrossHairLines2(Canvas canvas, Size size) {
    // double strokeWidth = 1.0;
    var index = calculateSelectedX(selectX);
    // KLineEntity point = getItem(index);
    double x = translateXtoX(BaseChartPainter.getX(index)); //getX(index);
    //double y = getMainY(point.close);
    // Paint paintX = Paint()
    // ..color = this.chartColors.vCrossColor //hCrossColor
    // ..strokeWidth = this.chartStyle.hCrossWidth
    // ..strokeWidth = strokeWidth
    // ..isAntiAlias = true;
    // Line graph
    double y1 = max(selectY, mTopPadding);
    y1 = min(y1, mCanvasHeight);
    var maxV = size.width - 5; // size gets to width
    var dashWidth = 5.0;
    var dashSpace = 5.0;
    double startX = 0;
    double space = (dashSpace + dashWidth);
    crosshairDottedPaint
      ..color = bgColor[0].computeLuminance() > 0.5
          ? this.chartColors.studyLabelTextColorLight
          : this.chartColors.vCrossColor
      ..isAntiAlias = true;
    while (startX < maxV) {
      canvas.drawLine(
          Offset(startX, y1),
          Offset(startX + dashWidth, y1), //ssss  cross hair
          crosshairDottedPaint);
      startX += space;
    }

    // canvas.drawLine(Offset(-mTranslateX, selectY - 0),
    //     Offset(-mTranslateX + mWidth / scaleX, selectY - 0), paintX);
    // canvas.drawLine(Offset(-mTranslateX, selectY - 0),
    //     Offset(-mTranslateX + mWidth / scaleX, selectY - 0), paintX);

    maxV = size.height - mBottomPadding; // size gets to width
    dashWidth = 5.0;
    dashSpace = 5.0;
    double startY = mTopPadding;
    space = (dashSpace + dashWidth);
    crosshairDottedPaint
      ..color = bgColor[0].computeLuminance() > 0.5
          ? this.chartColors.studyLabelTextColorLight
          : this.chartColors.vCrossColor
      // ..color = this.chartColors.vCrossColor
      ..isAntiAlias = true;
    while (startY < maxV) {
      canvas.drawLine(Offset(x, startY), Offset(x, startY + dashWidth),
          crosshairDottedPaint);
      startY += space;
    }

    canvas.drawCircle(Offset(x, y1), 4, crosshairDottedPaint); //ssss drawCircle

    var paint1 = Paint()
      ..color = this.chartColors.selectFillColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y1), 2, paint1);
    // canvas.drawRect(Offset(x, y1) & const Size(30, 30), paint1);

// line graph vertical line
    // canvas.drawLine(Offset(selectX, mTopPadding),
    //     Offset(selectX, size.height - mBottomPadding), crosshairDottedPaint);
    // canvas.drawLine(Offset(selectX, mTopPadding),
    //     Offset(selectX, size.height - mBottomPadding), crosshairDottedPaint);
  }

  void drawLinOnTick(Canvas canvas, Size size) {
    try {
      // canvas.translate(mTranslateX * 0.1, 0.0);

      var index =
          calculateSelectedX(Dataconstants.closePriceTickByTick); //selectX

      Dataconstants.index = index;
      double x = translateXtoX(BaseChartPainter.getX(index)); //getX(index);
      KLineEntity point = getItem(index);
      double y1 = max(selectY, mTopPadding);
      y1 = min(y1, mCanvasHeight);
      var maxV = size.width - 5; // size gets to width
      var dashWidth = 5.0;
      var dashSpace = 5.0;
      double startX = 0;
      double space = (dashSpace + dashWidth);
      crosshairDottedPaint
        ..color = bgColor[0].computeLuminance() > 0.5
            ? this.chartColors.studyLabelTextColorLight
            : this.chartColors.vCrossColor
        ..isAntiAlias = true;

      ///zzzz

      //var index = calculateSelectedX(mSelectX);
      //               KLineEntity point = getItem(index);

      KLineEntity curPoint = datas.last;
      double curX = BaseChartPainter.getX(datas.length);

      double displayPoint = selectY - 0;
      double yPixel = getYPixel(displayPoint);
      //print("$yPixel");

      // while (startX < maxV) {
      //   canvas.drawLine(Offset(x, y1), Offset(x + 150, y1),
      //
      //       crosshairDottedPaint);
      //   startX += space;
      // }
      var paint1 = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y1), 3, paint1);
      // Dataconstants.buySellButtonTickByTick=false;
    } catch (e) {
      //print(e);
    }
  }

  void drawBuySellButton(Canvas canvas, Size size) {
    if (selectX == 0.0) {
      selectX = 180.0;
    }
    if (selectY == 0.0) {
      selectY = 255.0;
    }
    var index = calculateSelectedX(selectX);
    double x = translateXtoX(BaseChartPainter.getX(index)); //getX(index);
    double y1 = max(selectY, mTopPadding);
    y1 = min(y1, mCanvasHeight);
    var maxV = size.width - 5; // size gets to width
    var dashWidth = 5.0;
    var dashSpace = 5.0;
    double startX = 0;
    double space = (dashSpace + dashWidth);
    crosshairDottedPaint
      ..color = bgColor[0].computeLuminance() > 0.5
          ? this.chartColors.studyLabelTextColorLight
          : this.chartColors.vCrossColor
      ..isAntiAlias = true;
    while (startX < maxV) {
      canvas.drawLine(
          Offset(startX, y1),
          Offset(startX + dashWidth, y1), //ssss  cross hair
          crosshairDottedPaint);
      startX += space;
    }
    maxV = size.height - mBottomPadding; // size gets to width
    dashWidth = 5.0;
    dashSpace = 5.0;
    double startY = mTopPadding;
    space = (dashSpace + dashWidth);
    crosshairDottedPaint
      ..color = this.chartColors.vCrossColor
      ..isAntiAlias = true;
    while (startY < maxV) {
      canvas.drawLine(Offset(x, startY), Offset(x, startY + dashWidth),
          crosshairDottedPaint);
      startY += space;
    }

    canvas.drawCircle(Offset(x, y1), 4, crosshairDottedPaint); //ssss drawCircle

    var paint1 = Paint()
      ..color = this.chartColors.selectFillColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y1), 2, paint1);

    ///-------------------------- Buy & Sell Button-------------------  //ssss buySell

    double displayPoint = selectY - 0; //point.close
    double yPixel = getYPixel(displayPoint);

    var buyPaint = Paint()
      ..color = Color(0xff089981)
      ..style = PaintingStyle.fill;
    var sellPaint = Paint()
      ..color = Color(0xfff23645)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(x - 12, y1 - 15), Offset(x - 80, y1 - 45)),
            Radius.circular(5.0)),
        sellPaint);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(x + 12, y1 - 15), Offset(x + 80, y1 - 45)),
            Radius.circular(5.0)),
        buyPaint);

    TextSpan buyTextSpan = new TextSpan(
        style: new TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        text: "B");
    TextPainter buyTp = new TextPainter(
        text: buyTextSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    buyTp.layout();
    buyTp.paint(canvas, new Offset(x + 18, y1 - 40));

    TextSpan buyTextWithSpanRate = new TextSpan(
        style: new TextStyle(
            fontSize: 12.5, fontWeight: FontWeight.w400, color: Colors.white),
        text: yPixel.toStringAsFixed(2));
    TextPainter buyTpWithRate = new TextPainter(
        text: buyTextWithSpanRate,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);
    buyTpWithRate.layout();
    buyTpWithRate.paint(canvas, new Offset(x + 35, y1 - 36.5));

    TextSpan sellTextSpan = new TextSpan(
        style: new TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        text: "S");
    TextPainter sellTp = new TextPainter(
        text: sellTextSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);
    sellTp.layout();
    sellTp.paint(canvas, new Offset(x - 75, y1 - 40));

    TextSpan sellTextWithSpanRate = new TextSpan(
        style: new TextStyle(
            fontSize: 12.5, fontWeight: FontWeight.w400, color: Colors.white),
        text: yPixel.toStringAsFixed(2));
    TextPainter sellTpWithRate = new TextPainter(
        text: sellTextWithSpanRate,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);
    sellTpWithRate.layout();
    sellTpWithRate.paint(canvas, new Offset(x - 60, y1 - 36.5));

// line graph vertical line
    // canvas.drawLine(Offset(selectX, mTopPadding),
    //     Offset(selectX, size.height - mBottomPadding), crosshairDottedPaint);
    // canvas.drawLine(Offset(selectX, mTopPadding),
    //     Offset(selectX, size.height - mBottomPadding), crosshairDottedPaint);
  }

  TextPainter getTextPainter(text, color, {fontsize = 9.0}) {
    //-------x Axis DatTime Text---------
    if (color == null) {
      color = this.chartColors.defaultTextColor;
    }
    TextSpan span =
        TextSpan(text: "$text", style: getTextStyle(color, fontsize));
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }

  String getDate(int date) => dateFormat(
      DateTime.fromMillisecondsSinceEpoch(
          date ?? DateTime.now().millisecondsSinceEpoch),
      mFormats);

  double getMainY(double y) => mMainRenderer.getY(y);

  double getSubY(double y, int index) {
    double retVal = -1;
    switch (index) {
      case 0:
        retVal = mMainRenderer != null ? mMainRenderer?.getY(y) : -1;
        break;
      case 2:
        retVal = mSecondaryRenderer != null ? mSecondaryRenderer?.getY(y) : -1;
        break;
      case 3:
        retVal = mTertiaryRenderer != null ? mTertiaryRenderer?.getY(y) : -1;
        break;
      default:
        break;
    }
    return retVal;
  }

  double getSecondY(double y) =>
      mSecondaryRenderer != null ? mSecondaryRenderer?.getY(y) : -1;

  double getThirdY(double y) =>
      mTertiaryRenderer != null ? mTertiaryRenderer?.getY(y) : -1;

  double getYPixel(double y,{double cP = 0.0}) => mMainRenderer.getYPixel(y,cP: cP);

  double getYSubPixel(double y, int index) {
    double retVal = -1;
    switch (index) {
      case 0:
        retVal = mMainRenderer != null ? mMainRenderer?.getYPixel(y) : -1;
        break;
      case 1:
        retVal = mVolRenderer != null ? mVolRenderer?.getYPixel(y) : -1;
        break;
      case 2:
        retVal =
            mSecondaryRenderer != null ? mSecondaryRenderer?.getYPixel(y) : -1;
        break;
      case 3:
        retVal =
            mTertiaryRenderer != null ? mTertiaryRenderer?.getYPixel(y) : -1;
        break;
      default:
        break;
    }
    return retVal;
  }

  double getPixelByGraph(double dx, double dy,{double cP = 0.0}) {
    if (isInVolumeRect(Offset(dx, dy))) {
      return -1;
      //getYSubPixel(dy, 1);
    } else if (isInSecondaryRect(Offset(dx, dy))) {
      return -1;
      //getYSubPixel(dy, 2);
    } else if (isInTertiaryRect(Offset(dx, dy))) {
      return -1; //getYSubPixel(dy, 3);
    } else
      return getYPixel(dy,cP: cP);
    //return dx;
  }

  /// Whether the point is in VolRect
  bool isInVolumeRect(Offset point) {
    return mVolRect?.contains(point) ?? false;
  }

  /// Whether the point is in SecondaryRect
  bool isInSecondaryRect(Offset point) {
    return mSecondaryRect?.contains(point) ?? false;
  }

  /// Whether the point is in SecondaryRect
  bool isInTertiaryRect(Offset point) {
    return mTertiaryRect?.contains(point) ?? false;
  }

  @override
  void drawOverLimitLines(Canvas canvas, Size size, List<StudyDef> studyList) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.low
      ..strokeWidth = 0.5
      ..color = Color.fromARGB(200, 185, 185, 185);

    double startX;
    double y2;
    double pOB, pOS;
    var max = size.width - 60; // size gets to width
    var dashWidth = 2.0;
    var dashSpace = 2.0;
    double space = (dashSpace + dashWidth);
    for (int i = 0; i < studyList.length; i++) {
      if (!studyList[i].visible) continue;
      if (studyList[i].overBSLines == 0) continue;
      if (studyList[i].mainState ==
          MainState.NONE) if (studyList[i].secondaryState != MainState.NONE) {
        pOB = studyList[i].overBLevel;
        pOS = studyList[i].overSLevel;
        //if (i == 6) continue;
        int subIndex = studyList[i].subGraphIndex;
        if (!_checkOutOfBounds(pOB, subIndex)) {
          startX = 0;
          y2 = getSubY(pOB, subIndex);

          while (startX < max) {
            canvas.drawLine(
                Offset(startX, y2), Offset(startX + dashWidth, y2), paint);
            startX += space;
          }
        }
        if (pOB == 0.0) continue;
        if (!_checkOutOfBounds(pOS, subIndex)) {
          startX = 0;
          y2 = getSubY(pOS, subIndex); // - minTp.height;

          while (startX < max) {
            canvas.drawLine(
                Offset(startX, y2), Offset(startX + dashWidth, y2), paint);
            startX += space;
          }
        }
      }
    }
  }

  bool _checkOutOfBounds(double y, int subIndex) {
    bool retVal = false;
    double y2 = getSubY(y, subIndex);
    switch (subIndex) {
      case 0:
        if (y2 > getSubY(mMainMinValue, subIndex))
          retVal = true;
        else if (y2 < getSubY(mMainMaxValue, subIndex)) retVal = true;
        break;
      case 2:
        if (y2 > getSubY(mSecondaryMinValue, subIndex))
          retVal = true;
        else if (y2 < getSubY(mSecondaryMaxValue, subIndex)) retVal = true;
        break;
      case 3:
        if (y2 > getSubY(mTertiaryMinValue, subIndex))
          retVal = true;
        else if (y2 < getSubY(mTertiaryMaxValue, subIndex)) retVal = true;
        break;
      default:
    }
    return retVal;
  }

  void _setColors() {
    /*if (chartColors.chartStudyColors == null)*/ {
      chartColors.chartStudyColors = new ChartStudyColors();
      Color c1;
      StudyDef std;
      for (int i = 0; i < chartStudies.studyList.length; i++) {
        std = chartStudies.studyList[i];
        if (!std.visible) continue;

        for (int j = 0; j < std.colorCnt; j++) {
          c1 = std.colors[j];
          switch (std.mainState) {
            case MainState.PRICE:
              {
                chartColors.chartStudyColors.priceColors.add(c1);
                chartColors.chartStudyColors.priceDisplayText = std.displayText;
              }
              break;
            case MainState.MA:
              {
                chartColors.chartStudyColors.maDisplayText = std.displayText;
                chartColors.chartStudyColors.maColors.add(c1);
              }
              break;
            case MainState.BOLL:
              {
                chartColors.chartStudyColors.bollColors.add(c1);
              }
              break;
            case MainState.DONCHAIN:
              {
                chartColors.chartStudyColors.donColors.add(c1);
              }
              break;
            case MainState.SWING:
              {
                chartColors.chartStudyColors.swingColors.add(c1);
              }
              break;
            case MainState.NONE:
              {}
              break;
            case MainState.VWAP:
              {}
              break;
            case MainState.PRICETYP:
              {
                chartColors.chartStudyColors.pTypColors.add(c1);
              }
              break;
            case MainState.STREND:
              chartColors.chartStudyColors.strendColors.add(c1);
              break;
          }
          switch (std.secondaryState) {
            case SecondaryState.VOL:
              {
                chartColors.chartStudyColors.volColors.add(c1);
                chartColors.chartStudyColors.volDisplayText = std.displayText;
              }
              break;
            case SecondaryState.ADX:
            case SecondaryState.ATR:
              {}
              break;
            case SecondaryState.MACD:
              {
                chartColors.chartStudyColors.macdColors.add(c1);
                chartColors.chartStudyColors.macdDisplayText = std.displayText;
              }
              break;
            case SecondaryState.KDJ:
              {
                chartColors.chartStudyColors.kdjColors.add(c1);
                chartColors.chartStudyColors.kdjDisplayText = std.displayText;
              }
              break;
            case SecondaryState.RSI:
              {
                chartColors.chartStudyColors.rsiColors.add(c1);
                chartColors.chartStudyColors.rsiDisplayText = std.displayText;
              }
              break;
            case SecondaryState.WR:
              {
                chartColors.chartStudyColors.wrColors.add(c1);
                chartColors.chartStudyColors.wrDisplayText = std.displayText;
              }
              break;
            case SecondaryState.CCI:
              {
                chartColors.chartStudyColors.cciColors.add(c1);
                chartColors.chartStudyColors.cciDisplayText = std.displayText;
              }
              break;
            case SecondaryState.NONE:
              {}
              break;
          }
        }

        if (mSecondaryRenderer != null) if (std.subGraphIndex == 2)
          mSecondaryRenderer.studyDef = std;
        if (mTertiaryRenderer != null) if (std.subGraphIndex == 3)
          mTertiaryRenderer.studyDef = std;
      }
    }
  }
}
