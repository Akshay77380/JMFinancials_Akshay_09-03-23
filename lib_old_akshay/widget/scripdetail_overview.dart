import 'package:flutter/material.dart';
import 'package:markets/util/Dataconstants.dart';
import '../screens/scrip_details_screen.dart';
import '../util/CommonFunctions.dart';
import '../widget/scripdetail_chart.dart';
import '../model/scrip_info_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ScripdetailOverview extends StatefulWidget {
  final ScripInfoModel currentModel;
  ScripdetailOverview(this.currentModel);

  @override
  _ScripdetailOverviewState createState() => _ScripdetailOverviewState();
}

class _ScripdetailOverviewState extends State<ScripdetailOverview> {
  bool showChart = false, isIndices = false;

  @override
  void initState() {
    super.initState();

    widget.currentModel.resetBidOffer();
    Dataconstants.iqsClient.sendMarketDepthRequest(
        widget.currentModel.exch, widget.currentModel.exchCode, true);
    isIndices = CommonFunction.isIndicesScrip(
        widget.currentModel.exch, widget.currentModel.exchCode);
  }

  @override
  void dispose() {
    super.dispose();
    Dataconstants.iqsClient.sendMarketDepthRequest(
        widget.currentModel.exch, widget.currentModel.exchCode, false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 15,
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: isIndices
                      ? Text("Chart", style: theme.textTheme.headline6)
                      : Row(
                          children: [
                            InkWell(
                              child: Text(
                                "Market Depth",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: showChart
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                  color: showChart
                                      ? Colors.grey[600]
                                      : theme.textTheme.bodyText1.color,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showChart = false;
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              child: Text(
                                "Chart",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: showChart
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: showChart
                                      ? theme.textTheme.bodyText1.color
                                      : Colors.grey[600],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showChart = true;
                                });
                              },
                            )
                          ],
                        )),
            ),
            isIndices
                ? Observer(
                    builder: (context) =>
                        widget.currentModel.chartMinClose[5].length > 0
                            ? ScripdetailChart(
                                seriesList: widget.currentModel.dataPoint[5],
                                prevClose: widget.currentModel.prevDayClose,
                                animate: true,
                              )
                            : SizedBox.shrink(),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(child: child, opacity: animation);
                    },
                    child: !showChart
                        ? MarketDepth(widget.currentModel)
                        : Observer(
                            builder: (context) => ScripdetailChart(
                                  seriesList: widget.currentModel.dataPoint[5],
                                  prevClose: widget.currentModel.prevDayClose,
                                  animate: true,
                                )),
                  ),
            SizedBox(height: 10),
            ohlcWidget(context),
            SizedBox(height: 10),
            otherInfoWidget(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget ohlcWidget(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Observer(
                  builder: (_) => dataTile(
                      "Open",
                      widget.currentModel.open
                          .toStringAsFixed(widget.currentModel.precision)),
                ),
                Observer(
                  builder: (_) => dataTile(
                      "High",
                      widget.currentModel.high
                          .toStringAsFixed(widget.currentModel.precision)),
                ),
                Observer(
                  builder: (_) => dataTile(
                      "Low",
                      widget.currentModel.low
                          .toStringAsFixed(widget.currentModel.precision)),
                ),
                Observer(
                  builder: (_) => dataTile(
                      "LTP",
                      widget.currentModel.close
                          .toStringAsFixed(widget.currentModel.precision)),
                ),
              ],
            ),
            SizedBox(height: 15),
            Observer(
              builder: (_) => infoSliderWidget(
                title: "Today's Low/High",
                low: widget.currentModel.low,
                high: widget.currentModel.high,
                value: widget.currentModel.close,
                context: context,
                lowColor: Color(0xffDCE35B),
                highColor: Color(0xff45B649),
              ),
            ),
            SizedBox(height: 10),
            Observer(
              builder: (_) => infoSliderWidget(
                title: '52 Week Low/High',
                low: widget.currentModel.yearlyLow,
                high: widget.currentModel.yearlyHigh,
                context: context,
                value: widget.currentModel.close,
                highColor: Color(0xfff12711),
                lowColor: Color(0xfff5af19),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataTile(String text, String value) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget dataRow(String text, dynamic value, bool highlight) {
    var finalVal;
    if (value is String)
      finalVal = value;
    else if (value is int)
      finalVal = value.toString();
    else
      finalVal =
          (value as double).toStringAsFixed(widget.currentModel.precision);
    return Container(
      color: highlight ? Colors.blueGrey.withOpacity(0.1) : Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              finalVal,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoSliderWidget({
    @required BuildContext context,
    String title,
    double low,
    double high,
    double value,
    Color lowColor,
    Color highColor,
  }) {
    var width = MediaQuery.of(context).size.width - 58;
    var percentSlider = ((value - low)) / (high - low);
    if (percentSlider.isInfinite || percentSlider.isNaN) percentSlider = 0;
    return Column(
      children: [
        Container(
          height: 25,
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 10,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [lowColor, highColor]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedPositioned(
                left: (percentSlider * width) - 12,
                bottom: 1,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.place,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              low.toStringAsFixed(widget.currentModel.precision),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              high.toStringAsFixed(widget.currentModel.precision),
            ),
          ],
        ),
      ],
    );
  }

  Widget otherInfoWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Observer(
            builder: (_) => dataRow(
              'Avg. Traded Price',
              widget.currentModel.avgTradePrice,
              true,
            ),
          ),
          dataRow(
            'Prev. Close',
            widget.currentModel.prevDayClose,
            false,
          ),
          Observer(
            builder: (_) => dataRow(
              'Volume',
              widget.currentModel.exchQty,
              true,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Last Traded Qty',
              widget.currentModel.lastTickQtyText,
              false,
            ),
          ),
          if (!isIndices)
            Observer(
              builder: (_) => dataRow(
                'Last Traded Time',
                widget.currentModel.lastTradeTimeText,
                true,
              ),
            ),
          if (widget.currentModel.exch == 'M')
            Observer(
              builder: (_) => dataRow(
                'Lower Circuit Range',
                widget.currentModel.lowerCktLimit,
                false,
              ),
            )
          else
            Observer(
              builder: (_) => dataRow(
                'Lower Circuit',
                widget.currentModel.lowerCktLimit,
                false,
              ),
            ),
          if (widget.currentModel.exch == 'M')
            Observer(
              builder: (_) => dataRow(
                'Upper Circuit Range ',
                widget.currentModel.upperCktLimit,
                true,
              ),
            )
          else
            Observer(
              builder: (_) => dataRow(
                'Upper Circuit',
                widget.currentModel.upperCktLimit,
                true,
              ),
            ),
        ],
      ),
    );
  }
}
