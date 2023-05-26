import 'package:flutter/material.dart';

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
        10 -
        (widget.lastCandleclose - low) / (high - low) * chartHeight;
  }

  @override
  Widget build(BuildContext context) {
    const double PRICE_BAR_WIDTH = 60;
    const double DATE_BAR_HEIGHT = 20;
    const double MIN_PRICETILE_HEIGHT = 50;
    const double MAIN_CHART_VERTICAL_PADDING = 20;
    const double PRICE_INDICATOR_HEIGHT = 20;

    const grayColor = Color(0xFF848E9C);
    const scaleNumbersColor = Color.fromARGB(255, 212, 202, 202);

    final double priceTileHeight =
        widget.chartHeight / ((widget.high - widget.low) / widget.priceScale);
    return AbsorbPointer(
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: widget.additionalVerticalPadding),
        child: AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: MAIN_CHART_VERTICAL_PADDING - priceTileHeight / 2,
          height: widget.chartHeight +
              MAIN_CHART_VERTICAL_PADDING +
              priceTileHeight / 2,
          width: widget.width,
          child: ListView(
            controller: scrollController,
            children: List<Widget>.generate(20, (i) {
              return Center(
                child: Row(
                  children: [
                    // Container(
                    //   width: widget.width - PRICE_BAR_WIDTH,
                    //   height: 0.05,
                    //   color: grayColor,
                    // ),
                    Expanded(
                      child: Text(
                        priceToString(widget.high - widget.priceScale * i),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: scaleNumbersColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
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
}
