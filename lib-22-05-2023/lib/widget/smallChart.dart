import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../style/theme.dart';

class SmallSimpleLineChart extends StatefulWidget {
  // final int index;
  final List<FlSpot> seriesList;
  final double prevClose;
  final bool animate;
  final String name;

  SmallSimpleLineChart(
      {this.seriesList, this.prevClose, this.animate = false, this.name});

  @override
  _SmallSimpleLineChartState createState() => _SmallSimpleLineChartState();
}

class _SmallSimpleLineChartState extends State<SmallSimpleLineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: false,
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
              spots: widget.seriesList,
              dotData: FlDotData(
                show: false,
              ),
              barWidth: 1.5,
              isCurved: true,
              isStrokeCapRound: false,
              color:
                widget.seriesList.last.y > widget.prevClose
                    ? ThemeConstants.buyColor
                    : widget.seriesList.last.y < widget.prevClose
                        ? ThemeConstants.sellColor
                        : Colors.grey,
              belowBarData: BarAreaData(
                  show: true,
                  color:
                    widget.seriesList.last.y > widget.prevClose
                        ? ThemeConstants.buyColor.withOpacity(0.7)
                        : widget.seriesList.last.y < widget.prevClose
                            ? ThemeConstants.sellColor.withOpacity(0.7)
                            : widget.seriesList.last.y > widget.prevClose
                                ? ThemeConstants.buyColor.withOpacity(0.01)
                                : widget.seriesList.last.y < widget.prevClose
                                    ? ThemeConstants.sellColor.withOpacity(0.01)
                                    : Colors.grey.withOpacity(0.01),
                  // Colors.grey.withOpacity(0.7)
                  // gradientFrom: Offset(0, 0),
                  // gradientTo: Offset(0, 1),
                  // gradientColorStops: [0.0, 1.0],
                  gradient: LinearGradient(colors: [
                    widget.seriesList.last.y > widget.prevClose
                        ? ThemeConstants.buyColor.withOpacity(0.7)
                        : widget.seriesList.last.y < widget.prevClose
                            ? ThemeConstants.sellColor.withOpacity(0.7)
                            : Colors.grey.withOpacity(0.7),
                    widget.seriesList.last.y > widget.prevClose
                        ? ThemeConstants.buyColor.withOpacity(0.01)
                        : widget.seriesList.last.y < widget.prevClose
                            ? ThemeConstants.sellColor.withOpacity(0.01)
                            : Colors.grey.withOpacity(0.01),
                  ], stops: [
                    0.0,
                    1.0
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, widget.prevClose),
                FlSpot(
                    (widget.seriesList.length - 1).toDouble(), widget.prevClose)
              ],
              dotData: FlDotData(
                show: false,
              ),
              barWidth: 1,
              dashArray: [2, 2],
              isStrokeCapRound: false,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
