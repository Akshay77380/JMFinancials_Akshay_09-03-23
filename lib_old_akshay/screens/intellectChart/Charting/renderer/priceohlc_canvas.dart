import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../../../../util/Dataconstants.dart';
import '../entity/candle_entity.dart';
import '../chart_widget.dart' show MainState, RateStyle;
import '../entity/studies.dart';
import '../utils/date_format_util.dart';
import 'base_chart_renderer.dart';

enum VerticalTextAlignment { left, right }

class PriceOHLCCanvas extends BaseChartRenderer<CandleEntity> {
  double mCandleWidth;
  double mCandleLineWidth;
  List<MainState> state;
  bool isLine;

  //Drawn content area
  Rect _contentRect;
  double _contentPadding = 1.0;
  List<int> maDayList;
  final ChartStyle chartStyle;
  final ChartColors chartColors;
  final ChartStudies chartStudies;
  final double mLineStrokeWidth = 1.0;
  double scaleX;
  Paint mLinePaint;
  Paint mLineBkPaint;
  Color bgColor;

  PriceOHLCCanvas(
      Rect mainRect,
      double canvasHeight,
      double maxValue,
      double minValue,
      double topPadding,
      double contentPadding,
      this.state,
      this.isLine,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.chartStudies,
      this.scaleX,
      NumberFormat indianRateDisplay,
      String chartPeriod,
      double chartInterval,
      this.bgColor,
      [this.maDayList = const [5, 10, 20]])
      : super(
            chartRect: mainRect,
            canvasHeight: canvasHeight,
            maxValue: maxValue,
            minValue: minValue,
            topPadding: topPadding,
            fixedLength: fixedLength,
            indianRateDisplay: chartStyle.indianRateDisplay,
            gridColor: chartColors.gridColor,
            chartPeriod: chartPeriod,
            chartInterval: chartInterval) {
    mCandleWidth = this.chartStyle.candleWidth;
    mCandleLineWidth = this.chartStyle.candleLineWidth;
    mLinePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = mLineStrokeWidth
      ..color = this.chartColors.kLineColor;
    mLineBkPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    _contentPadding += contentPadding;
    _contentRect = Rect.fromLTRB(
        chartRect.left,
        chartRect.top + _contentPadding,
        chartRect.right,
        chartRect.bottom - _contentPadding);
    if (maxValue == minValue) {
      maxValue *= 1.5;
      minValue /= 2;
    }
    scaleY = _contentRect.height / (maxValue - minValue);
  }

  @override
  void drawText(Canvas canvas, CandleEntity data, CandleEntity dataPrev,
      double x, String symbol) {
    TextSpan span;
    span = TextSpan(
      children: _createPriceOHLCTextSpan(data, dataPrev, symbol),
    );
    span.children.addAll(_createStudyTextSpan(data));
    for (int i = 0; i < /*state.length*/ 0; i++) {
      if (state[i] == MainState.NONE) {
        span = TextSpan(
          children: _createPriceOHLCTextSpan(data, dataPrev, symbol),
        );
      } else if (state[i] == MainState.MA) {
        span = TextSpan(
          children: _createPriceOHLCTextSpan(data, dataPrev, symbol),
        );
        // span.children.addAll(_createMATextSpan(data));
        span.children.addAll(_createStudyTextSpan(data));
        // span = TextSpan(
        //   children: _createMATextSpan(data),
        // );
      } else if (state[i] == MainState.BOLL) {}
    }

    if (span == null) return;
    if (span.children.length >= 6) {
      printOHLCTextPainter(canvas, data, dataPrev, x, symbol, span);
    } else if (span.children.length == 2) {
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x, chartRect.top - topPadding));
    } else {
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x, chartRect.top - topPadding));
    }
  }

  void printOHLCTextPainter(Canvas canvas, CandleEntity data,
      CandleEntity dataPrev, double x, String symbol, TextSpan span) {
    double xV, y1;
    final int topPad = 18;
    final int topPadStudy = 16;
    double textWidth;
    Color textBgColor = Color.fromARGB(50, 48, 48, 48);
    // textBgColor = Color.fromARGB(166, 99, 98, 98);

    // TextPainter tp =
    //     TextPainter(text: span.children[0], textDirection: TextDirection.ltr);
    textWidth = getTextSpanWidth(span.children[0].toPlainText());

    // tp.layout();
    // tp.paint(canvas, Offset(x, chartRect.top - topPadding + 2));
    printText(canvas, span.children[0], x, chartRect.top - topPadding + 2);

    xV = x +
        textWidth +
        (symbol.length <= 5
            ? 6
            : symbol.length >= 25
                ? -18
                : 0);

    printText(canvas, span.children[1], xV, chartRect.top - topPadding + 1);

    textWidth = getTextSpanWidth(span.children[1].toPlainText());
    //O

    xV += textWidth + 6;
    printText(canvas, span.children[2], xV, chartRect.top - topPadding + 2);
    textWidth = getTextSpanWidth(span.children[4].toPlainText());
    xV = x;

    y1 = chartRect.top - topPadding + topPad;

    mLineBkPaint.color = textBgColor;

    printText(
        canvas, span.children[3], xV, chartRect.top - topPadding + topPad);

    xV += textWidth;
    printText(
        canvas, span.children[4], xV, chartRect.top - topPadding + topPad);

    xV += textWidth;

    printText(
        canvas, span.children[5], xV, chartRect.top - topPadding + topPad);
    xV += textWidth;

    printText(
        canvas, span.children[6], xV, chartRect.top - topPadding + topPad + 2);

    if (span.children.length > 5) {
      double w = x;
      textWidth = 0;
      for (int i = 7; i < span.children.length; i++) {
        y1 = chartRect.top - topPadding + topPad + topPadStudy;

        mLineBkPaint.color = textBgColor;
        textWidth =
            getTextSpanWidth(span.children[i].toPlainText(), adjustWidth: 16.0);
        //double tH = getTextSpanHeight(span.children[i].toPlainText().trim());

        //canvas.drawRect(Rect.fromLTRB(x, y1, textWidth, y1 + tH), mLineBkPaint);

        printText(canvas, span.children[i], x + w, y1);
        w += textWidth;
      }
      //   y1 = chartRect.top - topPadding + topPad + topPadStudy;

      // mLineBkPaint.color = textBgColor;
      // textWidth = getTextSpanWidth(span.children[6].toPlainText().trim(),
      //     adjustWidth: 14.0);
      // double tH = getTextSpanHeight(span.children[6].toPlainText().trim());

      // canvas.drawRect(Rect.fromLTRB(x, y1, textWidth, y1 + tH), mLineBkPaint);

      // printText(canvas, span.children[6], x, y1);
    }
  }

  TextPainter getTextPainter(text, color) {
    if (color == null) {
      color = this.chartColors.defaultTextColor;
    }
    TextSpan span =
        TextSpan(text: "$text", style: getTextStyle(color, fSize: 9.0));
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }

  void printText(Canvas canvas, InlineSpan ilText, double x, double y) {
    TextPainter tp =
        TextPainter(text: ilText, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }

  double getTextSpanWidth(String data, {double adjustWidth = 0.0}) {
    final double adjust = 6.0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: data),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return (textPainter.size.width /
            WidgetsBinding.instance.window.textScaleFactor) -
        (adjustWidth == 0.0 ? adjust : adjustWidth);
  }

  double getTextSpanHeight(String data) {
    final int adjust = 4;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: data),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return (textPainter.size.height /
            WidgetsBinding.instance.window.textScaleFactor) -
        adjust;
  }

  List<InlineSpan> _createPriceOHLCTextSpan(
      CandleEntity data, CandleEntity dataPrev, String symbol) {
    List<InlineSpan> result = [];
    // result.add(TextSpan(
    //     text: symbol +
    //         "  O:  ${format(data.open)} , H:  ${format(data.high)} , L:  ${format(data.low)} , C:  ${format(data.close)}",
    //     style: getTextStyle(this.chartColors.nowPriceTextColor)));
    double rateChange = 0.0, ratePcnt = 0.0;
    int fractionalDigits = 2;
    TextStyle rateStyle, closeStyle;
    if (dataPrev != null && dataPrev.close > 0.0) {
      ratePcnt = ((data.close - dataPrev.close) / dataPrev.close) * 100;
      rateChange = data.close - dataPrev.close;

      if (ratePcnt < 0)
        rateStyle = getTextStyle(this.chartColors.fontRed, fSize: 12.0);
      else
        rateStyle = getTextStyle(this.chartColors.fontGreen, fSize: 12.0);
    } else {
      rateStyle = getTextStyle(this.chartColors.nowPriceTextColor, fSize: 12.0);
    }

    closeStyle = TextStyle(
        fontSize: rateStyle.fontSize + 2,
        fontWeight: FontWeight.bold,
        color: rateStyle.color);
    result.add(TextSpan(
        text: '$symbol   ',
        style: getTextStyle(
            bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fSize: symbol.length>15?12: 13.0)));
    result.add(TextSpan(
        text: " ${format(data.close, rateStyle: RateStyle.Rupees)}  ",
        style: closeStyle));
    result.add(TextSpan(
        text: (ratePcnt < 0)
            ? "${format(rateChange, fractionalDigits: fractionalDigits, rateStyle: RateStyle.Rupees)}  ${format(ratePcnt, fractionalDigits: fractionalDigits)}%"
            : "+${format(rateChange, fractionalDigits: fractionalDigits, rateStyle: RateStyle.Rupees)}  +${format(ratePcnt, fractionalDigits: fractionalDigits)}%",
        style: rateStyle));
    // result.add(TextSpan(
    //     text:
    //         "O:  ${format(data.open)} , H:  ${format(data.high)} , L:  ${format(data.low)}",
    //     style: getTextStyle(this.chartColors.nowPriceTextColor)));
    // if (Dataconstants.isFromToolsToFlashTrade == false) {
      result.add(TextSpan(
          text: "O: ${format(data.open, rateStyle: RateStyle.Rupees)} ",
          style: getTextStyle(
              bgColor.computeLuminance() > 0.5
                  ? this.chartColors.studyLabelTextColorLight
                  : this.chartColors.studyLabelTextColor,
              fSize: 12.5)));
      result.add(TextSpan(
          text: "H: ${format(data.high, rateStyle: RateStyle.Rupees)} ",
          style: getTextStyle(this.chartColors.hiColor, fSize: 12.5)));
      result.add(TextSpan(
          text: "L: ${format(data.low, rateStyle: RateStyle.Rupees)}",
          style: getTextStyle(this.chartColors.loColor, fSize: 12.5)));
      // result.add(TextSpan(
      //     text: "C: ${format(data.close)}",
      //     style: getTextStyle(this.chartColors.nowPriceTextColor)));
      result.add(TextSpan(
          text: chartPeriod != 'I'
              ? "${getDate(data.datetime)}"
              : "${getTimeDate(data.datetime)}",
          style: getTextStyle(
              bgColor.computeLuminance() > 0.5
                  ? this.chartColors.studyLabelTextColorLight
                  : this.chartColors.studyLabelTextColor,
              fSize: 11.0)));
    // }
    return result;
  }

  List<InlineSpan> _createStudyTextSpan(CandleEntity data) {
    List<InlineSpan> result = [];
    StudyDef stdDef;
    double tmpVal = 0.0;
    Color labelTextColor = bgColor.computeLuminance() > 0.5
        ? this.chartColors.studyLabelTextColorLight
        : this.chartColors.studyLabelTextColor;
    for (int i = 2; i < (this.chartStudies.studyList?.length ?? 0); i++) {
      stdDef = this.chartStudies.studyList[i];
      if (!stdDef.visible) continue;
      if (!stdDef.allowed) continue;
      if (stdDef.mainState == MainState.NONE) continue;

      switch (stdDef.mainState) {
        case MainState.PRICETYP:
          for (int j = 0; j < (stdDef.outColCnt ?? 0); j++) {
            if (data.priceTyp[stdDef.outCols[j]] != 0) {
              var item = TextSpan(
                  text: "${stdDef.displayText}  ",
                  style: getTextStyle(labelTextColor));
              result.add(item);
              item = TextSpan(
                  text: " ${doubleToString(data.priceTyp[stdDef.outCols[j]])}",
                  style: getTextStyle(stdDef.colors[j]));
              result.add(item);
            }
          }
          break;
        case MainState.MA:
          for (int j = 0; j < (stdDef.outColCnt ?? 0); j++) {
            if (data.maValueList[stdDef.outCols[j]] != 0) {
              var item = TextSpan(
                  text: "${stdDef.displayText}  ",
                  style: getTextStyle(labelTextColor));
              result.add(item);
              item = TextSpan(
                  text:
                      " ${doubleToString(data.maValueList[stdDef.outCols[j]])}", //${format(data.maValueList[stdDef.outCols[j]])}",
                  style: getTextStyle(stdDef.colors[
                      j])); //style: getTextStyle(this.chartColors.getMAColor(i)));
              result.add(item);
            }
          }
          break;
        case MainState.STREND:
          for (int j = 0; j < (stdDef.outColCnt ?? 0); j++) {
            if (data.supertrend[stdDef.outCols[j]] != 0) {
              var item = TextSpan(
                  text: "${stdDef.displayText}",
                  style: getTextStyle(labelTextColor));
              result.add(item);
              item = TextSpan(
                  text:
                      "${doubleToString(data.supertrend[stdDef.outCols[j]])} ", //${format(data.maValueList[stdDef.outCols[j]])}",
                  style: getTextStyle(stdDef.colors[
                      j])); //style: getTextStyle(this.chartColors.getMAColor(i)));
              result.add(item);
            }
          }
          break;
        case MainState.BOLL:
          var item = TextSpan(
              text: "${stdDef.displayText}  ",
              style: getTextStyle(labelTextColor));
          result.add(item);
          for (int j = 0; j < (stdDef.outColCnt ?? 0); j++) {
            /*if (data.maValueList[j] != 0)*/ {
              // var item = TextSpan(
              //     text: "${stdDef.displayText}  ",
              //     style: getTextStyle(this.chartColors.studyLabelTextColor));
              // result.add(item);
              tmpVal = (j == 0)
                  ? data.up[stdDef.outCols[j]]
                  : (j == 1)
                      ? data.mb[stdDef.outCols[j]]
                      : data.dn[stdDef.outCols[j]];
              item = TextSpan(
                  text: " ${doubleToString(tmpVal)}",
                  style: getTextStyle(stdDef.colors[j]));
              result.add(item);
            }
          }
          break;
        case MainState.DONCHAIN:
          var item = TextSpan(
              text: "${stdDef.displayText}  ",
              style: getTextStyle(labelTextColor));
          result.add(item);
          for (int j = 0; j < (stdDef.outColCnt ?? 0); j++) {
            tmpVal = (j == 0)
                ? data.dcUp[stdDef.outCols[j]]
                : (j == 1)
                    ? data.dcMd[stdDef.outCols[j]]
                    : data.dcLw[stdDef.outCols[j]];
            item = TextSpan(
                text: " ${doubleToString(tmpVal)}",
                style: getTextStyle(stdDef.colors[j]));
            result.add(item);
          }
          break;
        case MainState.PRICE:
          {}
          break;
        case MainState.NONE:
          {}
          break;
        case MainState.VWAP:
          {}
          break;
        case MainState.SWING:
          {}
          break;
      }
    }
    return result;
  }

  List<String> mFormats = [dd, ' ', M, ' ', yy, ' ', D]; //, ' ', HH, ':', nn];
  List<String> mTFormats = [
    dd,
    ' ',
    M,
    ' ',
    yy,
    ' ',
    HH,
    ':',
    nn,
    '.',
    ss
  ]; //, ' ', HH, ':', nn];
  String getDate(int date) => dateFormat(
      DateTime.fromMillisecondsSinceEpoch(
          date ?? DateTime.now().millisecondsSinceEpoch),
      mFormats);

  DateTime getDateTime(int date) => DateTime.fromMillisecondsSinceEpoch(
      date ?? DateTime.now().millisecondsSinceEpoch);

  String getTimeDate(int date) => dateFormat(
      DateTime.fromMillisecondsSinceEpoch(
          date ?? DateTime.now().millisecondsSinceEpoch),
      mTFormats);
  @override
  void drawChart(CandleEntity lastPoint, CandleEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    // //print(studyDef.lName);
    if (isLine != true) {
      if (this.chartStudies.studyList[0].drawStyle[0].index == 2)
        drawJapaneseCandle(curPoint, canvas, curX);
      else if (this.chartStudies.studyList[0].drawStyle[0].index == 1)
        drawBarCandle(curPoint, canvas, curX);
    }
  }

  void drawChartPrimaryStudy(CandleEntity lastPoint, CandleEntity curPoint,
      double lastX, double curX, Size size, Canvas canvas) {
    if (this.chartStudies.studyList[0].drawStyle[0].index == 5)
      drawCloseLine(lastPoint, curPoint, canvas, lastX, curX); // tick by tick
    {
      for (int i = 0; i < state.length; i++) {
        switch (state[i]) {
          case MainState.PRICE:
            {}
            break;
          case MainState.MA:
            drawMaLine(lastPoint, curPoint, canvas, lastX, curX);
            break;
          case MainState.BOLL:
            drawBollLine(lastPoint, curPoint, canvas, lastX, curX);
            break;
          case MainState.DONCHAIN:
            drawDonLine(lastPoint, curPoint, canvas, lastX, curX);
            break;
          case MainState.NONE:
            {}
            break;
          case MainState.VWAP:
            {}
            break;
          case MainState.PRICETYP:
            {
              drawDSLine2(lastPoint, curPoint, canvas, lastX, curX);
            }
            break;
          case MainState.STREND:
            drawSuperTrendLine(lastPoint, curPoint, canvas, lastX, curX);
            break;
          case MainState.SWING:
            {}
            break;
        }
      }
    }
  }

  void drawCloseLine(
      CandleEntity lastPoint,
      CandleEntity curPoint, //chart tick by tick
      Canvas canvas,
      double lastX,
      double curX) {
    if (lastPoint.close != 0) {
      drawLine(
          lastPoint.close,
          curPoint.close,
          canvas,
          lastX,
          curX,
          this
              .chartColors
              .chartStudyColors
              .priceColors[(curPoint.close < lastPoint.close ? 1 : 0)],
          0.0);
    }
  }

  void drawMaLine(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    for (int i = 0; i < (curPoint.maValueList?.length ?? 0); i++) {
      // if (i == 3) {
      //   break;
      // }
      if (lastPoint.maValueList[i] != 0) {
        drawLine(lastPoint.maValueList[i], curPoint.maValueList[i], canvas,
            lastX, curX, this.chartColors.chartStudyColors.maColors[i], 0.0);
        // drawLine(lastPoint.maValueList[i], curPoint.maValueList[i], canvas,
        //     lastX, curX, this.chartColors.getMAColor(i), 0.0);
      }
    }
  }

  void drawDSLine2(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    for (int i = 0; i < (curPoint.priceTyp?.length ?? 0); i++) {
      if (lastPoint.priceTyp[i] != 0) {
        drawLine(
            lastPoint.priceTyp[i],
            curPoint.priceTyp[i],
            canvas,
            lastX,
            curX,
            this.chartColors.chartStudyColors.pTypColors[
                (curPoint.priceTyp[i] < lastPoint.priceTyp[i] ? 1 : 0)],
            0.0);
      }
    }
  }

  void drawSuperTrendLine(CandleEntity lastPoint, CandleEntity curPoint,
      Canvas canvas, double lastX, double curX) {
    for (int i = 0; i < (curPoint.supertrend?.length ?? 0); i++) {
      // if (i == 3) {
      //   break;
      // }
      if (lastPoint.supertrend[i] != 0) {
        drawLine(
            lastPoint.supertrend[i],
            curPoint.supertrend[i],
            canvas,
            lastX,
            curX,
            this.chartColors.chartStudyColors.strendColors[
                (curPoint.supertrend[i] > lastPoint.supertrend[i]
                    ? (i * 2) + 1
                    : i * 2)],
            0.0);
        // drawLine(lastPoint.maValueList[i], curPoint.maValueList[i], canvas,
        //     lastX, curX, this.chartColors.getMAColor(i), 0.0);
      }
    }
  }

  void drawBollLine(CandleEntity lastPoint, CandleEntity curPoint,
      Canvas canvas, double lastX, double curX) {
    for (int i = 0; i < (curPoint.up?.length ?? 0); i++) {
      if (lastPoint.up[i] != 0) {
        drawLine(lastPoint.up[i], curPoint.up[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.bollColors[i * 3], 0.0);
      }
    }

    for (int i = 0; i < (curPoint.mb?.length ?? 0); i++) {
      if (lastPoint.mb[i] != 0) {
        drawLine(lastPoint.mb[i], curPoint.mb[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.bollColors[(i * 2) + 1 + i], 0.0);
      }
    }
    for (int i = 0; i < (curPoint.dn?.length ?? 0); i++) {
      if (lastPoint.dn[i] != 0) {
        drawLine(lastPoint.dn[i], curPoint.dn[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.bollColors[(i * 2) + 2 + i], 0.0);
      }
    }
  }

  void drawDonLine(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    for (int i = 0; i < (curPoint.dcUp?.length ?? 0); i++) {
      if (lastPoint?.dcUp[i] != 0) {
        drawLine(lastPoint?.dcUp[i], curPoint?.dcUp[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.donColors[i * 3], 0.0);
      }
    }

    for (int i = 0; i < (curPoint.dcMd?.length ?? 0); i++) {
      if (lastPoint?.dcMd[i] != 0) {
        drawLine(lastPoint?.dcMd[i], curPoint?.dcMd[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.donColors[(i * 2) + 1 + i], 0.0);
      }
    }
    for (int i = 0; i < (curPoint.dcLw?.length ?? 0); i++) {
      if (lastPoint?.dcLw[i] != 0) {
        drawLine(lastPoint?.dcLw[i], curPoint?.dcLw[i], canvas, lastX, curX,
            this.chartColors.chartStudyColors.donColors[(i * 2) + 2 + i], 0.0);
      }
    }
  }

  void drawJapaneseCandle(CandleEntity curPoint, Canvas canvas, double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    double r = mCandleWidth / 2;
    double lineR = mCandleLineWidth / 2;
    if (scaleX < 0.1) {
      lineR = r - scaleX - 0.5;
    } else if (scaleX < 0.2) {
      lineR = r - scaleX - 1.5;
    } else if (scaleX < 0.4) {
      lineR = r - scaleX - 2.5;
    }
    if (open >= close) {
      if (open - close < mCandleLineWidth) {
        open = close + mCandleLineWidth;
      }

      chartPaint.color = this.chartColors.chartStudyColors.priceColors[0];
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
      chartPaint.color = this
          .chartColors
          .chartStudyColors
          .priceColors[0]; //this.chartColors.upColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, close, curX + r, open), chartPaint);
    } else if (close > open) {
      // Entity height>= CandleLineWidth
      if (close - open < mCandleLineWidth) {
        open = close - mCandleLineWidth;
      }

      chartPaint.color = this.chartColors.chartStudyColors.priceColors[1];
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);

      chartPaint.color = this
          .chartColors
          .chartStudyColors
          .priceColors[1]; //this.chartColors.dnColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, open, curX + r, close), chartPaint);
    }
  }

  void drawBarCandle(CandleEntity curPoint, Canvas canvas, double curX) {
    ///zzzz
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    // if (open < 0) open = close;
    double r = (mCandleWidth - 1) / 1.5;
    // r = r - 0.9;
    double lineR = mCandleLineWidth / 2;
    // lineR = lineR - 0.50;
    if (scaleX < 0.1) {
      lineR = r - scaleX - 0.5;
    } else if (scaleX < 0.2) {
      lineR = r - scaleX - 1.5;
    } else if (scaleX < 0.4) {
      lineR = r - scaleX - 2.5;
    } else if (scaleX < 0.6) {
      lineR = r - scaleX - 3.0;
    }

    if (open >= close) {
      // Entity height>= CandleLineWidth
      if (open - close < mCandleLineWidth) {
        open = close + mCandleLineWidth;
      }
      // //print('scaleX:{$scaleX}');

      //wick
      chartPaint.color = this.chartColors.chartStudyColors.priceColors[0];
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
      // canvas.drawRect(
      //     Rect.fromLTRB(curX - r, close, curX + r, open), chartPaint);
      canvas.drawLine(Offset(curX - r, open), Offset(curX, open), chartPaint);
      canvas.drawLine(
          Offset(curX - r, open - 1), Offset(curX, open - 1), chartPaint);

      canvas.drawLine(Offset(curX, close), Offset(curX + r, close), chartPaint);
      canvas.drawLine(
          Offset(curX, close + 1), Offset(curX + r, close + 1), chartPaint);
    } else if (close > open) {
      // Entity height>= CandleLineWidth
      if (close - open < mCandleLineWidth) {
        open = close - mCandleLineWidth;
      }

      //wick
      chartPaint.color = this.chartColors.chartStudyColors.priceColors[1];
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);

      // canvas.drawRect(
      //     Rect.fromLTRB(curX - r, open, curX + r, close), chartPaint);
      canvas.drawLine(Offset(curX, close), Offset(curX + r, close), chartPaint);
      canvas.drawLine(
          Offset(curX, close - 1), Offset(curX + r, close - 1), chartPaint);
      canvas.drawLine(Offset(curX - r, open), Offset(curX, open), chartPaint);
      canvas.drawLine(
          Offset(curX - r, open + 1), Offset(curX, open + 1), chartPaint);
    }
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    // gridRows = 6; //uncomment later
    double sY = scaleY;
    double mV = minValue;
// if (!Global.scaleCanvas) return;
    double rowSpace = chartRect.height / gridRows;
    ////print(getY(mMainMinValue));
    // rowSpace = getY(mMainMinValue) / gridRows;
    ////print(chartRect.height.toString() + ' : ' + _contentRect.top.toString());
    double p;
    TextSpan span = TextSpan(
        text: "${format(0.00, rateStyle: RateStyle.Rupees)}", style: textStyle);
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    double a = tp.height / 2;
    for (int i = 0; i < gridRows; i++) {
      p = rowSpace * i + topPadding - a;
      double scaleV = getYPixel(p + a, cP: _contentPadding);
      // if (scaleV > 2) scaleV = double.parse(scaleV.toStringAsFixed(1));
      TextSpan span = TextSpan(
          text: "${format(scaleV, rateStyle: RateStyle.Rupees)}",
          style: textStyle);
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      int xPad = scaleV < 100 ? 10 : 0;
      tp.paint(canvas, Offset(chartRect.width - tp.width - 0 - xPad, p));
    }
    return;
    // if (!Global.scaleCanvas) return;
    /*double rowSpace = chartRect.height / gridRows;
    for (var i = 0; i <= gridRows; ++i) {
      double value = (gridRows - i) * rowSpace / sY + mV;
      TextSpan span = TextSpan(
          text: "${format(value, rateStyle: RateStyle.Rupees)}",
          style: textStyle);

      int xPad = value < 100 ? 10 : 0;
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      if (i == 0) {
        // tp.paint(canvas, Offset(chartRect.width - tp.width, topPadding));
        tp.paint(
            canvas,
            Offset(chartRect.width - tp.width - 0 - xPad,
                topPadding - tp.height / 2));
      } else if (i == gridRows) {
        // tp.paint(canvas, Offset(chartRect.width - tp.width, topPadding));
        tp.paint(
            canvas,
            Offset(chartRect.width - tp.width - 0 - xPad,
                rowSpace * i - tp.height + topPadding));
      } else {
        tp.paint(
            canvas,
            Offset(chartRect.width - tp.width - 0 - xPad,
                rowSpace * i - tp.height + topPadding + tp.height / 2));
      }
    }*/
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns, bool isDotted,
      bool verticalLine, bool horizontalLine) {
    if (isDotted) {
      if (horizontalLine) {
        double rowSpace = chartRect.height / gridRows;
        for (int i = 0; i <= gridRows; i++) {
          double startX = 0;
          // final max = -mTranslateX + (mWidth - 100) / scaleX; //giving problem in case of very few candles
          final max = chartRect.width - scaleMargin;
          final gridWidth = this.chartStyle.gridLinesWidth;
          final space = this.chartStyle.nowPriceLineSpan + gridWidth;
          while (startX < max) {
            canvas.drawLine(
                Offset(startX, rowSpace * i + topPadding),
                Offset(startX + gridWidth - 3, rowSpace * i + topPadding),
                gridPaint);
            startX += space;
          }

          // canvas.drawLine(Offset(0, rowSpace * i + topPadding),
          //     Offset(chartRect.width, rowSpace * i + topPadding), gridPaint);
        }
      }
      if (verticalLine) {
        double columnSpace = chartRect.width / gridColumns;
        for (int i = 0; i <= columnSpace; i++) {
          double startY = topPadding / 3; //columnSpace * i;
          // final max = -mTranslateX + (mWidth - 100) / scaleX; //giving problem in case of very few candles
          final max = chartRect.bottom;
          final space = this.chartStyle.nowPriceLineSpan +
              this.chartStyle.nowPriceLineLength;
          while (startY < max) {
            // if (i != 2) break;
            // canvas.drawLine(Offset(startY, topPadding / 3),
            //     Offset(startY, chartRect.bottom), gridPaint);
            canvas.drawLine(Offset(columnSpace * i, startY),
                Offset(columnSpace * i, startY + 1), gridPaint);
            startY += space;
          }

          // canvas.drawLine(Offset(columnSpace * i, topPadding / 3),
          //     Offset(columnSpace * i, chartRect.bottom), gridPaint);
        }
      }
    } else {
      if (horizontalLine) {
        //    final int gridRows = 4, gridColumns = 4;
        double rowSpace = chartRect.height / gridRows;
        for (int i = 0; i <= gridRows; i++) {
          canvas.drawLine(Offset(0, rowSpace * i + topPadding),
              Offset(chartRect.width, rowSpace * i + topPadding), gridPaint);
        }
      }
      if (verticalLine) {
        double columnSpace = chartRect.width / gridColumns;
        for (int i = 0; i <= columnSpace; i++) {
          canvas.drawLine(Offset(columnSpace * i, topPadding / 3),
              Offset(columnSpace * i, chartRect.bottom), gridPaint);
        }
      }
    }
  }

  @override
  void drawGridCalendar(CandleEntity lastPoint, CandleEntity curPoint,
      Canvas canvas, double curX, bool isDotted) {
    // //print(getDateTime(lastPoint.datetime));
    // //print(getDateTime(curPoint.datetime));
    DateTime d1 = getDateTime(lastPoint.datetime);
    DateTime d2 = getDateTime(curPoint.datetime);

    if (chartPeriod == 'D') if (d1.month == d2.month) return;
    if (chartPeriod == 'M') if (d1.year == d2.year) return;
    if (chartPeriod == 'W') {
      if (d1.year == d2.year) {
        if (!(d1.month == 6 && d2.month == 7)) return;
      }
    }
    if (chartPeriod == 'I') if (d1.day == d2.day) return;

    double r = mCandleWidth / 2;
    double lineR = mCandleLineWidth / 2;
    double space = 10;
    Color lineColor = bgColor.computeLuminance() > 0.5
        ? this.chartColors.studyLabelTextColorLight
        : this.chartColors.studyLabelTextColor;

    if (scaleX < 0.1) {
      lineR = r - scaleX + 2.5;
    } else if (scaleX <= 0.2) {
      lineR = r - scaleX - 0.5;
    } else if (scaleX < 0.4) {
      lineR = r - scaleX - 2.0;
    } else if (scaleX < 0.8) {
      lineR = r - scaleX - 2.5;
    }
    curX -= this.chartStyle.candleWidth / 1.2;
    gridPaint..strokeWidth = lineR;

    if (d2.month == 1 && chartPeriod == 'D') {
      space = 13.7;
      gridPaint..color = lineColor;
      /*Color.fromARGB(
            237, 178, 180, 187); //Color.fromARGB(234, 238, 233, 233);*/
    } else if (chartPeriod == 'I') {
      space = 12.7;
      gridPaint..color = lineColor; //Color.fromARGB(237, 178, 180, 187);
    } else
      gridPaint..color = this.chartColors.gridColor; //.gridColorDark;
    double startY = topPadding; // / 3;
    final max = canvasHeight - 1;

    while (startY < max) {
      canvas.drawLine(
          Offset(curX, startY), Offset(curX, startY + 5), gridPaint);
      startY += space;
    }
  }

  @override
  void drawScaleLine(Canvas canvas) {
    Paint _gridPaint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 0.5
      ..color = Color.fromARGB(255, 145, 145, 150);

    canvas.drawLine(Offset(chartRect.left, chartRect.top - topPadding + 0),
        Offset(chartRect.width, chartRect.top - topPadding + 0), _gridPaint);

    // canvas.drawLine(Offset(chartRect.left, chartRect.top),
    //     Offset(chartRect.width, chartRect.top), _gridPaint);

    // canvas.drawLine(Offset(chartRect.width - 1, topPadding / 3),
    //     Offset(chartRect.width - 1, chartRect.bottom), _gridPaint);

    double xOffset = chartRect.width - scaleMargin;

    canvas.drawLine(Offset(xOffset, chartRect.top - topPadding),
        Offset(xOffset, chartRect.bottom), _gridPaint);

    // canvas.drawLine(Offset(10, 10), Offset(10, 10), _gridPaint);
    canvas.drawLine(Offset(chartRect.left, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), _gridPaint);
  }

  @override
  double getY(double y) {
    return (maxValue - y) * scaleY + _contentRect.top;
  }

  String priceToString(double price) {
    return price >= 1000
        ? price.toStringAsFixed(2)
        : price > 100
            ? price.toStringAsFixed(3)
            : price > 10
                ? price.toStringAsFixed(4)
                : price > 1
                    ? price.toStringAsFixed(5)
                    : price.toStringAsFixed(7);
  }
}
