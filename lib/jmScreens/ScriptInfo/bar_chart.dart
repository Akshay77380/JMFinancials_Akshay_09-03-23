import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../util/Utils.dart';

class BarChartWidget extends StatefulWidget {

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {

  List<Data> barData = [
    Data(
      id: 0,
      name: 'Mon',
      y: -15,
      color: Color(0xff19bfff)
    ),
    Data(
        id: 0,
        name: 'Mon',
        y: -15,
        color: Color(0xff19bfff)
    ),
    Data(
        id: 0,
        name: 'Mon',
        y: -15,
        color: Color(0xff19bfff)
    ),
    Data(
        id: 0,
        name: 'Mon',
        y: -15,
        color: Utils.primaryColor
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BarChart(
        BarChartData(
          titlesData: null,
          borderData: FlBorderData(
              show: false,
          ),
          backgroundColor: Colors.white,
          barGroups: [
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                    toY: 4,
                    color: Utils.primaryColor,
                    width: 10,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)
                    )
                ),
              ]
          ),
            BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                      toY: 5,
                      color: Utils.primaryColor,
                      width: 10,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)
                      )
                  ),
                ]
            ),
            BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                      toY: 5,
                      color: Utils.primaryColor,
                      width: 10,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)
                      )
                  ),
                ]
            ),
            BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                      toY:7,
                      color: Utils.primaryColor,
                      width: 10,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)
                      )
                  ),
                ]
            ),
            BarChartGroupData(
                x: 76,
                barRods: [
                  BarChartRodData(
                      toY: 10,
                      color: Utils.primaryColor,
                      width: 10,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)
                      )
                  ),
                ]
            ),
          ]
        ),

    );
  }
}


class Data{
  int id;
  String name;
  double y;
  Color color;

  Data({@required this.id, @required this.name, @required this.y, @required this.color});
}