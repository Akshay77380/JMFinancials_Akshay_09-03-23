import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/jmScreens/ScriptInfo/ScriptInfo.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../model/scrip_info_model.dart';
import '../screens/scrip_details_screen.dart';
import '../style/theme.dart';
import '../util/Dataconstants.dart';

class ScripdetailFuture extends StatefulWidget {
  final List<ScripInfoModel> futures;
  final int currentDate;
  final String comingFrom;
  final ScripInfoModel model;

  ScripdetailFuture(this.futures, this.model,
      [this.currentDate = 0, this.comingFrom]);

  @override
  _ScripdetailFutureState createState() => _ScripdetailFutureState();
}

class _ScripdetailFutureState extends State<ScripdetailFuture> {
  int futureIndex = 0;

  @override
  void initState() {
    if (widget.currentDate != 0) {
      futureIndex = widget.futures
          .indexWhere((element) => element.expiry == widget.currentDate);
      if (futureIndex < 0) futureIndex = 0;
    }
    Dataconstants.iqsClient.sendLTPRequest(widget.futures[futureIndex], true);
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.futures[futureIndex].exch,
        widget.futures[futureIndex].exchCode,
        true);
    super.initState();
  }

  @override
  void dispose() {
    Dataconstants.iqsClient.sendLTPRequest(widget.futures[futureIndex], false);
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.futures[futureIndex].exch,
        widget.futures[futureIndex].exchCode,
        false);
    Dataconstants.iqsClient
        .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Expiry", style: theme.textTheme.headline6),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ScripdetailFOPicker(
                        widget.futures.map((e) => e.expiryDateString).toList(),
                        changeFutureIndex,
                        true,
                        futureIndex,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        widget.futures[futureIndex].expiryDateString,
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(Icons.expand_more),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Observer(
            builder: (_) => dataRow(
              'Last Traded Price',
              widget.futures[futureIndex].close,
              false,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Price Change',
              widget.futures[futureIndex].priceChangeText,
              true,
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.futures[futureIndex].priceChange > 0
                    ? ThemeConstants.buyColor
                    : widget.futures[futureIndex].priceChange < 0
                        ? ThemeConstants.sellColor
                        : theme.textTheme.bodyText1.color,
              ),
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Percent Change',
              widget.futures[futureIndex].percentChangeText,
              false,
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.futures[futureIndex].percentChange > 0
                    ? ThemeConstants.buyColor
                    : widget.futures[futureIndex].percentChange < 0
                        ? ThemeConstants.sellColor
                        : theme.textTheme.bodyText1.color,
              ),
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Avg. Traded Price',
              widget.futures[futureIndex].avgTradePrice,
              true,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Open',
              widget.futures[futureIndex].open,
              false,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'High',
              widget.futures[futureIndex].high,
              true,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Low',
              widget.futures[futureIndex].low,
              false,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Volume',
              widget.futures[futureIndex].exchQty,
              true,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Last Traded Qty',
              widget.futures[futureIndex].lastTickQtyText,
              false,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Last Traded Time',
              widget.futures[futureIndex].lastTradeTimeText,
              true,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Lower Circuit',
              widget.futures[futureIndex].lowerCktLimit,
              false,
            ),
          ),
          Observer(
            builder: (_) => dataRow(
              'Upper Circuit',
              widget.futures[futureIndex].upperCktLimit,
              true,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.primaryColor),
                ),
                child: Text('Overview', style: TextStyle(color: theme.primaryColor)),
                onPressed: () {
                  // Dataconstants.itsClient.fnoEvent(
                  //     eventCategory: widget.comingFrom,
                  //     eventAction: "${widget.model.name}_${widget.model.marketWatchDesc}",
                  //     eventLabel: Dataconstants.lastBottomTab,
                  //     logEvent: "future_overview_selection",
                  //     navigationMenu: widget.comingFrom == 'watchlist_screen' ? 'watchlist' : 'predefined',
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ScriptInfo(widget.futures[futureIndex]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dataRow(String text, dynamic value, bool highlight,
      [TextStyle style]) {
    var finalVal;
    if (value is String)
      finalVal = value;
    else if (value is int)
      finalVal = value.toString();
    else
      finalVal = (value as double)
          .toStringAsFixed(widget.futures[futureIndex].precision);
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
              style: style != null
                  ? style
                  : TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void changeFutureIndex(int currIndex) {
    Dataconstants.iqsClient.sendLTPRequest(widget.futures[futureIndex], false);
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.futures[futureIndex].exch,
        widget.futures[futureIndex].exchCode,
        false);
    setState(() {
      futureIndex = currIndex;
    });
    Dataconstants.iqsClient.sendLTPRequest(widget.futures[currIndex], true);
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.futures[currIndex].exch,
        widget.futures[currIndex].exchCode,
        true);
  }
}

class ScripdetailFOPicker extends StatelessWidget {
  final List<String> dates;
  final Function changeIndex;
  final bool isFuture;
  final int currentIndex;

  ScripdetailFOPicker(
      this.dates, this.changeIndex, this.isFuture, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                changeIndex(index);
                Navigator.of(context).pop();
              },
              leading: index == currentIndex
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : SizedBox.shrink(),
              title: Text(
                dates[index],
              ),
            ),
            Divider(
              height: 1,
            )
          ],
        );
      },
    );
  }
}
