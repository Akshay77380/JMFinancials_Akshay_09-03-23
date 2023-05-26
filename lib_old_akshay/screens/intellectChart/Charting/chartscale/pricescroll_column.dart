
import 'dart:math';
import 'package:flutter/material.dart';

import '../../Constant/GlobalValues.dart';
class PriceColumn extends StatefulWidget {
  const PriceColumn({
    Key key,
    this.low,
    this.high,
    this.priceScale,
    this.width,
    this.chartHeight,
    this.lastCandleclose,
    // required this.onScale,
    this.additionalVerticalPadding,
  }) : super(key: key);

  final double low;
  final double high;
  final double priceScale;
  final double width;
  final double chartHeight;
  final double lastCandleclose;
  final double additionalVerticalPadding;
  // final void Function(double) onScale;

  @override
  State<PriceColumn> createState() => _PriceColumnState();
}

class _PriceColumnState extends State<PriceColumn> {
  ScrollController scrollController = ScrollController();

  double calcutePriceIndicatorTopPadding(
      double chartHeight, double low, double high) {
    return chartHeight +
        50 -
        (widget.lastCandleclose - low) / (high - low) * chartHeight;
  }

  @override
  Widget build(BuildContext context) {
    const double PRICE_BAR_WIDTH = 50;
    const double DATE_BAR_HEIGHT = 20;
    const double MIN_PRICETILE_HEIGHT = 50;
    const double MAIN_CHART_VERTICAL_PADDING = 50;
    const double PRICE_INDICATOR_HEIGHT = 20;

    const grayColor = Color(0xFF848E9C);
    const scaleNumbersColor = Color.fromARGB(225, 211, 210, 210);

    if (widget.high <= 0) return Text('');

    final double priceScaleF =
        calcutePriceScale(widget.chartHeight * 0.75, widget.high, widget.low);
    // widget.priceScale =
    //     calcutePriceScale(widget.chartHeight, widget.high, widget.low);

    final double priceTileHeight =
        widget.chartHeight / ((widget.high - widget.low) / priceScaleF);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // widget.onScale(details.delta.dy);
      },
      child: AbsorbPointer(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: widget.additionalVerticalPadding),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1),
                top: MAIN_CHART_VERTICAL_PADDING - priceTileHeight / 2,
                height: widget.chartHeight +
                    MAIN_CHART_VERTICAL_PADDING +
                    priceTileHeight / 2,
                width: PRICE_BAR_WIDTH, //widget.width,
                child: ListView(
                  controller: scrollController,
                  children: List<Widget>.generate(20, (i) {
                    return AnimatedContainer(
                      // color: Colors.yellow,
                      duration: const Duration(milliseconds: 1),
                      height: priceTileHeight,
                      width: double.infinity,
                      child: Center(
                        child: Row(
                          children: [
                            // Container(
                            //   width: widget.width - PRICE_BAR_WIDTH,
                            //   height: 0.05,
                            //   color: grayColor,
                            // ),
                            Expanded(
                              child: Text(
                                priceToString(
                                    ((widget.high ~/ priceScaleF + 1) *
                                            priceScaleF) -
                                        priceScaleF * i),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: scaleNumbersColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // drawLastCloseOnScale(PRICE_BAR_WIDTH, PRICE_INDICATOR_HEIGHT),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawLastCloseOnScale(double pWidth, double pHeight) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 1),
      right: 0,
      top: calcutePriceIndicatorTopPadding(
            widget.chartHeight,
            widget.low,
            widget.high,
          ) +
          15,
      child: Row(
        children: [
          Container(
            color: Colors.red,
            child: Center(
              child: Text(
                priceToString(Global.chartClose),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
            width: pWidth,
            height: pHeight,
          ),
        ],
      ),
    );
  }

  static String priceToString(double price) {
    return price > 1000
        ? price.toStringAsFixed(2)
        : price > 100
            ? price.toStringAsFixed(3)
            : price > 10
                ? price.toStringAsFixed(4)
                : price > 1
                    ? price.toStringAsFixed(5)
                    : price.toStringAsFixed(7);
  }

  static double log10(num x) => log(x) / ln10;

  static double getRoof(double number) {
    int log = log10(number).floor();
    return (number ~/ pow(10, log) + 1) * pow(10, log).toDouble();
  }

  static String addMetricPrefix(double price) {
    if (price < 1) price = 1;
    int log = log10(price).floor();
    if (log > 9)
      return "${price ~/ 1000000000}B";
    else if (log > 6)
      return "${price ~/ 1000000}M";
    else if (log > 3)
      return "${price ~/ 1000}K";
    else
      return "${price.toStringAsFixed(0)}";
  }

  double calcutePriceScale(double height, double high, double low) {
    int minTiles = (height / 50).floor();
    minTiles = max(2, minTiles);
    // minTiles = 5;
    double sizeRange = high - low;
    double minStepSize = sizeRange / minTiles;
    double base = pow(10, log10(minStepSize).floor()).toDouble();

    if (2 * base > minStepSize) return 2 * base;
    if (5 * base > minStepSize) return 5 * base;
    return 10 * base;
  }
}
