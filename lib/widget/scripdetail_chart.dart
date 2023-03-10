import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../style/theme.dart';

class ScripdetailChart extends StatelessWidget {
  // final int index;
  final List<FlSpot> seriesList;
  final double prevClose;
  final bool animate;

  ScripdetailChart({
    this.seriesList,
    this.prevClose,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: seriesList.isEmpty
          ? SizedBox(
              width: double.infinity,
              height: 260,
            )
          : SizedBox(
              width: double.infinity,
              height: 260,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Theme.of(context).cardColor,
                      fitInsideVertically: true,
                      fitInsideHorizontally: true,
                      tooltipRoundedRadius: 5,
                    ),
                    touchCallback: (FlTouchEvent e, LineTouchResponse touchResponse) {},
                    handleBuiltInTouches: true,
                  ),
                  gridData: FlGridData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    show: false,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: seriesList,
                      dotData: FlDotData(
                        show: false,
                      ),
                      barWidth: 2,
                      isCurved: true,
                      isStrokeCapRound: false,
                      color: seriesList.last.y > prevClose
                          ? ThemeConstants.buyColor
                          : seriesList.last.y < prevClose
                              ? ThemeConstants.sellColor
                              : Colors.grey,
                      belowBarData: BarAreaData(
                          show: true,
                          color: seriesList.last.y > prevClose
                              ? ThemeConstants.buyColor.withOpacity(0.7)
                              : seriesList.last.y < prevClose
                                  ? ThemeConstants.sellColor.withOpacity(0.7)
                                  : seriesList.last.y > prevClose
                                      ? ThemeConstants.buyColor.withOpacity(0.01)
                                      : seriesList.last.y < prevClose
                                          ? ThemeConstants.sellColor.withOpacity(0.01)
                                          : Colors.grey.withOpacity(0.01),
                          // seriesList.last.y > prevClose
                          //     ? ThemeConstants.buyColor.withOpacity(0.7)
                          //     : seriesList.last.y < prevClose
                          //         ? ThemeConstants.sellColor.withOpacity(0.7)
                          //         : Colors.grey.withOpacity(0.7),
                          // seriesList.last.y > prevClose
                          //     ? ThemeConstants.buyColor.withOpacity(0.01)
                          //     : seriesList.last.y < prevClose
                          //         ? ThemeConstants.sellColor.withOpacity(0.01)
                          //         : Colors.grey.withOpacity(0.01),
                          // gradientFrom: Offset(0, 0),
                          // gradientTo: Offset(0, 1),
                          // gradientColorStops: [0.0, 1.0],
                          gradient: LinearGradient(colors: [
                            seriesList.last.y > prevClose
                                ? ThemeConstants.buyColor.withOpacity(0.7)
                                : seriesList.last.y < prevClose
                                    ? ThemeConstants.sellColor.withOpacity(0.7)
                                    : Colors.grey.withOpacity(0.7),
                            seriesList.last.y > prevClose
                                ? ThemeConstants.buyColor.withOpacity(0.01)
                                : seriesList.last.y < prevClose
                                    ? ThemeConstants.sellColor.withOpacity(0.01)
                                    : Colors.grey.withOpacity(0.01),
                          ], stops: [
                            0.0,
                            1.0
                          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    ),
                    LineChartBarData(
                      spots: [FlSpot(0, prevClose), FlSpot((seriesList.length - 1).toDouble(), prevClose)],
                      dotData: FlDotData(
                        show: false,
                      ),
                      barWidth: 1.5,
                      dashArray: [4, 4],
                      isStrokeCapRound: false,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
