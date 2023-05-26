import 'dart:ui';
import 'package:flutter/material.dart';
import '../entity/volume_entity.dart';
import 'base_chart_renderer.dart';

class VolRenderer extends BaseChartRenderer<VolumeEntity> {
  double mVolWidth;
  final ChartStyle chartStyle;
  final ChartColors chartColors;
  Color bgColor;

  VolRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.bgColor)
      : super(
          chartRect: mainRect,
          maxValue: maxValue,
          minValue: minValue,
          topPadding: topPadding,
          fixedLength: fixedLength,
          gridColor: chartColors.gridColor,
        ) {
    mVolWidth = this.chartStyle.volWidth;
  }

  @override
  void drawChart(VolumeEntity lastPoint, VolumeEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    double r = mVolWidth / 2;
    double top = getVolY(curPoint.vol);
    double bottom = chartRect.bottom;
    if (curPoint.vol != 0) {
      canvas.drawRect(
          Rect.fromLTRB(curX - r, top, curX + r, bottom),
          chartPaint
            ..color = curPoint.close > curPoint.open
                ? this.chartColors.chartStudyColors.volColors[0] //.upColor
                : this.chartColors.chartStudyColors.volColors[1]); // dnColor);
    }
  }

  @override
  void drawChartPrimaryStudy(VolumeEntity lastPoint, VolumeEntity curPoint,
      double lastX, double curX, Size size, Canvas canvas) {}

  @override
  void drawGridCalendar(VolumeEntity lastPoint, VolumeEntity curPoint,
      Canvas canvas, double curX, bool isDotted) {}

  double getVolY(double value) =>
      (maxValue - value) * (chartRect.height / maxValue) + chartRect.top;

  @override
  void drawText(Canvas canvas, VolumeEntity data, VolumeEntity dataPrev,
      double x, String symbol) {
    TextSpan span = TextSpan(
      children: [
        TextSpan(
            text: "${this.chartColors.chartStudyColors.volDisplayText}  ",
            style: getTextStyle(bgColor.computeLuminance() > 0.5
                ? this.chartColors.studyLabelTextColorLight
                : this.chartColors.studyLabelTextColor)),
        TextSpan(
            text: "${format(data.vol)}    ",
            style:
                getTextStyle(this.chartColors.chartStudyColors.volColors[0])),
      ],
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    gridRows = chartRect.height > 30 ? 4 : 2;
    double rowSpace = chartRect.height / gridRows;
    for (var i = 0; i < gridRows; ++i) {
      double value = (gridRows - i) * rowSpace / scaleY + minValue;
      TextSpan span = TextSpan(text: "${format(value)}", style: textStyle);
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      if (i == 0) {
      } else {
        tp.paint(
            canvas,
            Offset(chartRect.width - tp.width - 5,
                chartRect.top + (rowSpace * i - tp.height + topPadding)));
      }
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns, bool isDotted,
      bool verticalLine, bool horizontalLine) {
    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= columnSpace; i++) {
      //vol Vertical line
      canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }

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
