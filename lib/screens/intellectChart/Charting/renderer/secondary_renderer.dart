import 'package:flutter/material.dart';
import '../entity/macd_entity.dart';
import '../chart_widget.dart' show SecondaryState;
import 'base_chart_renderer.dart';

class SecondaryRenderer extends BaseChartRenderer<MACDEntity> {
  double mMACDWidth;
  SecondaryState state;
  final ChartStyle chartStyle;
  final ChartColors chartColors;
  double scaleX;
  Color bgColor;

  SecondaryRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      this.state,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.scaleX,
      this.bgColor)
      : super(
          chartRect: mainRect,
          maxValue: maxValue,
          minValue: minValue,
          topPadding: topPadding,
          fixedLength: fixedLength,
          gridColor: chartColors.gridColor,
        ) {
    mMACDWidth = this.chartStyle.macdWidth;
  }

  @override
  void drawChart(MACDEntity lastPoint, MACDEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    switch (state) {
      case SecondaryState.MACD:
        drawMACD(curPoint, canvas, curX, lastPoint, lastX);
        break;
      case SecondaryState.ATR:
        for (int i = 0; i < (curPoint.atr?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.atr[i] != 0) {
            drawLine(lastPoint.atr[i], curPoint.atr[i], canvas, lastX, curX,
                studyDef.colors[0], scaleX);
          }
        }
        break;
      case SecondaryState.KDJ:
        drawLine(lastPoint.k, curPoint.k, canvas, lastX, curX,
            studyDef.colors[0], scaleX);
        drawLine(lastPoint.d, curPoint.d, canvas, lastX, curX,
            studyDef.colors[1], scaleX);
        drawLine(lastPoint.j, curPoint.j, canvas, lastX, curX,
            studyDef.colors[2], scaleX);
        break;
      case SecondaryState.RSI:
        for (int i = 0; i < (curPoint.rsi?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.rsi[i] != 0) {
            drawLine(lastPoint.rsi[i], curPoint.rsi[i], canvas, lastX, curX,
                studyDef.colors[0], scaleX);
          }
        }
        // drawLine(lastPoint.rsi, curPoint.rsi, canvas, lastX, curX,
        //     this.chartColors.rsiColor, scaleX);
        // drawLineOB(lastPoint.rsi, curPoint.rsi, curPoint.oB, curPoint.oS,
        //     canvas, lastX, curX, this.chartColors.rsiColor);
        break;
      case SecondaryState.WR:
        for (int i = 0; i < (curPoint.r?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          /*if (lastPoint.r[i] != 0)*/ {
            drawLine(lastPoint.r[i], curPoint.r[i], canvas, lastX, curX,
                studyDef.colors[0], scaleX);
          }
        }
        // drawLine(lastPoint.r, curPoint.r, canvas, lastX, curX,
        //     this.chartColors.chartStudyColors.wrColors[0], scaleX);
        break;
      case SecondaryState.CCI:
        for (int i = 0; i < (curPoint.cci?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.cci[i] != 0) {
            drawLine(lastPoint.cci[i], curPoint.cci[i], canvas, lastX, curX,
                studyDef.colors[0], scaleX);
          }
        }

        break;
      case SecondaryState.ADX:
        for (int i = 0; i < (curPoint.Adxup?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.Adxup[i] != 0)
            drawLine(lastPoint.Adxup[i], curPoint.Adxup[i], canvas, lastX, curX,
                studyDef.colors[0], scaleX);
        }
        for (int i = 0; i < (curPoint.Adxmb?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.Adxmb[i] != 0)
            drawLine(lastPoint.Adxmb[i], curPoint.Adxmb[i], canvas, lastX, curX,
                studyDef.colors[1], scaleX);
        }
        for (int i = 0; i < (curPoint.Adxdn?.length ?? 0); i++) {
          if (i != studyDef.outCols[0]) continue;
          if (lastPoint.Adxdn[i] != 0)
            drawLine(lastPoint.Adxdn[i], curPoint.Adxdn[i], canvas, lastX, curX,
                studyDef.colors[2], scaleX);
        }
        break;
      default:
        break;
    }
  }

  void drawChartPrimaryStudy(MACDEntity lastPoint, MACDEntity curPoint,
      double lastX, double curX, Size size, Canvas canvas) {}

  void drawMACD(MACDEntity curPoint, Canvas canvas, double curX,
      MACDEntity lastPoint, double lastX) {
    for (int i = 0; i < (curPoint.macd?.length ?? 0); i++) {
      if (i != studyDef.outCols[0]) continue;
      // final macd = curPoint.macd[i] ?? 0;
      // double macdY = getY(macd);
      // double r = mMACDWidth / 2;
      // double zeroy = getY(0);
      /*if (macd > 0) {
        canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
            chartPaint..color = this.chartColors.upColor);
      } else {
        canvas.drawRect(Rect.fromLTRB(curX - r, zeroy, curX + r, macdY),
            chartPaint..color = this.chartColors.dnColor);
      }*/
      if (lastPoint.dif[i] != 0) {
        drawLine(lastPoint.dif[i], curPoint.dif[i], canvas, lastX, curX,
            studyDef.colors[0] /*this.chartColors.difColor*/, scaleX);
      }
      /*if (lastPoint.dea[i] != 0) {
        drawLine(lastPoint.dea[i], curPoint.dea[i], canvas, lastX, curX,
            this.chartColors.deaColor, scaleX);
      }*/
    }
  }

  @override
  void drawText(Canvas canvas, MACDEntity data, MACDEntity dataPrev, double x,
      String symbol) {
    List<TextSpan> children;
    Color textColor = bgColor.computeLuminance() > 0.5
        ? this.chartColors.studyLabelTextColorLight
        : this.chartColors.studyLabelTextColor;
    switch (state) {
      case SecondaryState.MACD:
        children = [
          TextSpan(text: studyDef.displayText, style: getTextStyle(textColor)),
          TextSpan(
              text: "${format(data.dif[studyDef.outCols[0]])}    ",
              style: getTextStyle(studyDef.colors[0])),
        ];
        break;
      case SecondaryState.ATR:
        children = [
          TextSpan(text: studyDef.displayText, style: getTextStyle(textColor)),
          TextSpan(
              text: "${format(data.atr[studyDef.outCols[0]])}    ",
              style: getTextStyle(studyDef.colors[0])),
        ];
        break;

      case SecondaryState.KDJ:
        children = [
          TextSpan(
              text: "KDJ(9,1,3)    ",
              style: getTextStyle(this.chartColors.defaultTextColor)),
          if (data.k != 0)
            TextSpan(
                text: "K:${format(data.k)}    ",
                style: getTextStyle(this.chartColors.kColor)),
          if (data.d != 0)
            TextSpan(
                text: "D:${format(data.d)}    ",
                style: getTextStyle(this.chartColors.dColor)),
          if (data.j != 0)
            TextSpan(
                text: "J:${format(data.j)}    ",
                style: getTextStyle(this.chartColors.jColor)),
        ];
        break;
      case SecondaryState.RSI:
        children = [
          TextSpan(text: studyDef.displayText, style: getTextStyle(textColor)),
          TextSpan(
              text: "${format(data.rsi[studyDef.outCols[0]])}    ",
              style: getTextStyle(studyDef.colors[0])),
        ];
        break;
      case SecondaryState.WR:
        children = [
          TextSpan(text: studyDef.displayText, style: getTextStyle(textColor)),
          TextSpan(
              text: "${format(data.r[studyDef.outCols[0]])}    ",
              style: getTextStyle(studyDef.colors[0])),
        ];
        break;
      case SecondaryState.CCI:
        children = [
          TextSpan(text: studyDef.displayText, style: getTextStyle(textColor)),
          TextSpan(
              text: "${format(data.cci[studyDef.outCols[0]])}    ",
              style: getTextStyle(studyDef.colors[0])),
        ];
        break;
      case SecondaryState.ADX:
        children = [
          TextSpan(
              text: studyDef.displayText,
              style: getTextStyle(bgColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white)),
          TextSpan(
              text: "${format(data.Adxup[studyDef.outCols[0]])} ",
              style: getTextStyle(studyDef.colors[0])),
          TextSpan(
              text: "${format(data.Adxmb[studyDef.outCols[0]])} ",
              style: getTextStyle(studyDef.colors[1])),
          TextSpan(
              text: "${format(data.Adxdn[studyDef.outCols[0]])}",
              style: getTextStyle(studyDef.colors[2])),
        ];
        break;
      default:
        break;
    }
    TextPainter tp = TextPainter(
        text: TextSpan(children: children ?? []),
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    bool obL = studyDef.overBSLines == 0;

    TextStyle txtStyle = textStyle;
    gridRows = chartRect.height > 30 ? 4 : 2;
    if (gridRows == 2) {
      txtStyle =
          TextStyle(fontSize: txtStyle.fontSize - 0.5, color: txtStyle.color);
    }
    //double y1R, y2R;
    double y2 = 0;
    double displayOBS;
    double mOBValue = studyDef.overBLevel;
    /*y1R = */ y2 = getY(mOBValue) - topPadding / 2;
    if (y2 > chartRect.top - topPadding / 2)
      displayOBS = mOBValue;
    else
      displayOBS = maxValue;

    if (obL) displayOBS = maxValue;

    TextPainter maxTp = TextPainter(
        text: TextSpan(
            text: "${format(displayOBS)}",
            style:
                txtStyle), //TextSpan(text: "${format(maxValue)}", style: textStyle),
        textDirection: TextDirection.ltr);
    maxTp.layout();

    if (displayOBS == mOBValue) {
      maxTp.paint(canvas, Offset(chartRect.width - maxTp.width, y2));
    } else {
      maxTp.paint(canvas,
          Offset(chartRect.width - maxTp.width, chartRect.top - topPadding));
    }
    if (studyDef.zeroBase) return;
    double mOSValue = studyDef.overSLevel;
    /*y2R = */ y2 = getY(mOSValue) - maxTp.height / 2;
    if (y2 < chartRect.bottom - maxTp.height / 2)
      displayOBS = mOSValue;
    else
      displayOBS = minValue;
    if (obL) displayOBS = minValue;
    TextPainter minTp = TextPainter(
        text: TextSpan(
            text: "${format(displayOBS)}",
            style:
                txtStyle), //TextSpan(text: "${format(minValue)}", style: textStyle),
        textDirection: TextDirection.ltr);
    minTp.layout();

    if (displayOBS == mOSValue) {
      minTp.paint(canvas, Offset(chartRect.width - minTp.width, y2));
    } else {
      minTp.paint(
          canvas,
          Offset(
              chartRect.width - minTp.width, chartRect.bottom - minTp.height));
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns, bool isDotted,
      bool verticalLine, bool horizontalLine) {
    canvas.drawLine(Offset(0, chartRect.top),
        Offset(chartRect.width, chartRect.top), gridPaint);
    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= columnSpace; i++) {
      //mSecondaryRect Vertical line
      canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }

  @override
  void drawGridCalendar(MACDEntity lastPoint, MACDEntity curPoint,
      Canvas canvas, double curX, bool isDotted) {}

  @override
  void drawScaleLine(Canvas canvas) {
    Paint _gridPaint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 0.5
      ..color = Color.fromARGB(255, 145, 145, 150);
    canvas.drawLine(
        Offset(chartRect.width - scaleMargin,
            chartRect.top - 12 /*topPadding / 3*/),
        Offset(chartRect.width - scaleMargin, chartRect.bottom),
        _gridPaint);
    canvas.drawLine(Offset(chartRect.left - 00, chartRect.bottom),
        Offset(chartRect.width - 00, chartRect.bottom), _gridPaint);
  }
}
