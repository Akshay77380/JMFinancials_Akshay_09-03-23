import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/netPositionController.dart';
import 'package:markets/model/jmModel/netPosition.dart';
import '../../controllers/positionFilterController.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'today_position_details.dart';

class OpenPositions extends StatefulWidget {
  @override
  _OpenPositionsState createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> {
  bool squareOffLoading = false;

  @override
  void initState() {
    Dataconstants.showSquareOffAll = false;
    // Dataconstants.netPositionController.fetchNetPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Obx(
            () {
              if (NetPositionController.isLoading.value || PositionFilterController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else
                return RefreshIndicator(
                    color: theme.primaryColor,
                    onRefresh: () {
                      Dataconstants.netPositionController.fetchNetPosition();
                      return Future.value(true);
                    },
                    child: NetPositionController.openPositionList.length == 0
                        ? (PositionFilterController.isPositionSearch.value || PositionFilterController.isPositionFilter.value) && NetPositionController.openPositionList.length != 0
                            ? Center(
                                child: Text(
                                  "No records found",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset('assets/appImages/noPositions.svg'),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "You have no Open Positions",
                                        style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          color: theme.primaryColor,
                                          padding: EdgeInsets.symmetric(horizontal: 50),
                                          child: Text(
                                            'GO TO WATCHLIST',
                                            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            InAppSelection.mainScreenIndex = 1;
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (_) => MainScreen(
                                                      toChangeTab: false,
                                                    )));
                                          })
                                    ],
                                  ),
                                ),
                              )
                        : Obx(() {
                            if (NetPositionController.isLoading.value || PositionFilterController.isLoading.value)
                              return Center(child: CircularProgressIndicator());
                            else
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: NetPositionController.openPositionList.length,
                                      itemBuilder: (ctx, index) => NetPositionTodayRow(
                                        theme: theme,
                                        netPositionRecord: NetPositionController.openPositionList[index],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CommonFunction.message('That’s all we have for you today'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Visibility(
                                        visible: NetPositionController.openPositionList.length > 1,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                if (Dataconstants.showSquareOffAll == false) {
                                                  setState(() {
                                                    Dataconstants.showSquareOffAll = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    // squareOffLoading = true;
                                                    Dataconstants.showSquareOffAll = false;
                                                  });
                                                  // if (squareOffLoading == true) {
                                                  //   showDialog(
                                                  //     context: context,
                                                  //     builder: (_) => Material(
                                                  //       type: MaterialType.transparency,
                                                  //       child: Center(child: CircularProgressIndicator()),
                                                  //     ),
                                                  //   );
                                                  // }
                                                  NetPositionController.openPositionList.forEach((element) async {
                                                    if (element.squareOff) {
                                                      if (element.netqty != '0' || element.producttype != 'COVER' || element.producttype != 'BRACKET') {
                                                        // if (element.model.exchCategory == ExchCategory.nseEquity || element.model.exchCategory == ExchCategory.bseEquity) {
                                                        var jsons = {
                                                          "exchangeseg": element.exchange,
                                                          "producttype": element.producttype,
                                                          "Netqty": element.netqty,
                                                          "symboltoken": element.model.exchCode.toString(),
                                                          "symbolname": element.model.tradingSymbol,
                                                          "OrderSource": "MOB"
                                                        };
                                                        log(jsons.toString());
                                                        var response = await CommonFunction.squareOfPosition(jsons);
                                                        //log("squareoff Order Response => $response");
                                                        try {
                                                          var responseJson = json.decode(response.toString());
                                                          if (responseJson["status"] == false) {
                                                            CommonFunction.showBasicToast(responseJson["emsg"]);
                                                          } else {
                                                            Dataconstants.netPositionController.fetchNetPosition();
                                                          }
                                                        } catch (e) {}
                                                      }
                                                    }
                                                    // }
                                                  });
                                                  Dataconstants.orderBookData.fetchOrderBook();
                                                  // Dataconstants.netPositionController.fetchNetPosition().then((value) {
                                                  //   setState(() {
                                                  //     squareOffLoading = false;
                                                  //   });
                                                  //   Navigator.pop(context);
                                                  // });
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Card(
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Dataconstants.showSquareOffAll == true ? Utils.primaryColor : Utils.primaryColor.withOpacity(0.2),
                                                        ),
                                                        child: Text(
                                                          Dataconstants.showSquareOffAll == true ? 'Square Off All (${NetPositionController.squareOffCount})' : 'Square Off',
                                                          style: Utils.fonts(
                                                              size: 12.0, fontWeight: FontWeight.w500, color: Dataconstants.showSquareOffAll == true ? Utils.whiteColor : Utils.primaryColor),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              );
                          }));
            },
          ),
        ),
      ],
    );
  }
}

class NetPositionTodayRow extends StatefulWidget {
  const NetPositionTodayRow({
    @required this.netPositionRecord,
    @required this.theme,
  });

  final NetPositionDatum netPositionRecord;
  final ThemeData theme;

  @override
  State<NetPositionTodayRow> createState() => _NetPositionTodayRowState();
}

class _NetPositionTodayRowState extends State<NetPositionTodayRow> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        children: [
          if (Dataconstants.showSquareOffAll)
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: Utils.primaryColor,
                value: widget.netPositionRecord.squareOff,
                shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                onChanged: (value) {
                  setState(() {
                    widget.netPositionRecord.squareOff = value;
                    NetPositionController.squareOffCount.value = NetPositionController.openPositionList.where((element) => element.squareOff == true).toList().length;
                  });
                },
              ),
            ),
          if (Dataconstants.showSquareOffAll)
            const SizedBox(
              width: 8,
            ),
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => TodayPositionDetails(widget.netPositionRecord));
              },
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* Displaying the Script name */
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: int.parse(widget.netPositionRecord.netqty) > 0
                                    ? Utils.brightGreenColor
                                    : int.parse(widget.netPositionRecord.netqty) < 0
                                        ? Utils.brightRedColor
                                        : Utils.greyColor),
                            child: Text(
                              int.parse(widget.netPositionRecord.netqty) > 0
                                  ? "BUY"
                                  : int.parse(widget.netPositionRecord.netqty) < 0
                                      ? "SELL"
                                      : 'CLOSE',
                              style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                          /* Displaying the Script Description */
                          Observer(
                            builder: (_) => Row(
                              children: [
                                Text("LTP", style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.netPositionRecord.model.close == 0.00
                                      ? widget.netPositionRecord.model.prevDayClose.toStringAsFixed(widget.netPositionRecord.model.precision)
                                      : widget.netPositionRecord.model.close.toStringAsFixed(widget.netPositionRecord.model.precision),
                                  style: Utils.fonts(
                                      color: widget.netPositionRecord.model.close > widget.netPositionRecord.model.prevTickRate
                                          ? Utils.mediumGreenColor
                                          : widget.netPositionRecord.model.close < widget.netPositionRecord.model.prevTickRate
                                              ? Utils.mediumRedColor
                                              : Utils.greyColor,
                                      size: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Icon(
                                    widget.netPositionRecord.model.close > widget.netPositionRecord.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                    color: widget.netPositionRecord.model.close > widget.netPositionRecord.model.prevTickRate ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.netPositionRecord.model.name, style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)
                              // TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                          Text(
                              widget.netPositionRecord.netqty +
                                  ' @ ' +
                                  "${int.parse(widget.netPositionRecord.netqty) > 0 ? widget.netPositionRecord.buyavgprice : widget.netPositionRecord.sellavgprice}",
                              style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                        ],
                      ),
                      // /* Displaying the Script Description */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: widget.netPositionRecord.exchange == 'NSE'
                                        ? widget.netPositionRecord.exchange.toUpperCase()
                                        : widget.netPositionRecord.exchange == 'BSE'
                                            ? widget.netPositionRecord.exchange.toUpperCase()
                                            : widget.netPositionRecord.expirydate.split('-')[0].toUpperCase() + ' ' + widget.netPositionRecord.expirydate.split('-')[1].toUpperCase(),
                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                    children: [
                                      if (widget.netPositionRecord.model.exchCategory != ExchCategory.nseEquity || widget.netPositionRecord.model.exchCategory != ExchCategory.bseEquity)
                                        TextSpan(text: ' '),
                                      if (widget.netPositionRecord.model.exchCategory != ExchCategory.nseEquity || widget.netPositionRecord.model.exchCategory != ExchCategory.bseEquity)
                                        TextSpan(
                                          text: widget.netPositionRecord.model.exchCategory == ExchCategory.nseFuture ||
                                                  widget.netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                                  widget.netPositionRecord.model.exchCategory == ExchCategory.currenyFutures ||
                                                  widget.netPositionRecord.model.exchCategory == ExchCategory.mcxFutures
                                              ? 'FUT'
                                              : widget.netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.mcxOptions
                                                  ? widget.netPositionRecord.strikeprice.split('.')[0]
                                                  : '',
                                          style: Utils.fonts(
                                              size: 12.0,
                                              fontWeight: FontWeight.w400,
                                              color: widget.netPositionRecord.model.exchCategory == ExchCategory.nseFuture ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.currenyFutures ||
                                                      widget.netPositionRecord.model.exchCategory == ExchCategory.mcxFutures
                                                  ? Utils.primaryColor
                                                  : Utils.greyColor),
                                        ),
                                      if (widget.netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.mcxOptions)
                                        TextSpan(text: ' '),
                                      if (widget.netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                          widget.netPositionRecord.model.exchCategory == ExchCategory.mcxOptions)
                                        TextSpan(
                                          text: widget.netPositionRecord.model.cpType == 3 ? 'CE' : 'PE',
                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: widget.netPositionRecord.model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
                                        )
                                    ]),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(height: 3, width: 3, decoration: BoxDecoration(
                                  color: Utils.greyColor, shape: BoxShape.circle)),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(widget.netPositionRecord.producttype.toUpperCase(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                            ],
                          ),
                          /* Displaying the price change and percentage change of the script */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /* Displaying the price change of the script */
                              Observer(
                                builder: (_) => Text(
                                  "${widget.netPositionRecord.model.close == 0.00 ? "0.00" : widget.netPositionRecord.pl.toStringAsFixed(2)}",
                                  style: Utils.fonts(
                                      color: widget.netPositionRecord.model.percentChange > 0
                                          ? Utils.mediumGreenColor
                                          : widget.netPositionRecord.model.percentChange < 0
                                              ? Utils.mediumRedColor
                                              : theme.errorColor,
                                      size: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              /* Displaying the percentage change of the script */
                              Observer(
                                builder: (_) => Text(
                                    /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                    widget.netPositionRecord.model.close == 0.00 ? "(0.00%)" : widget.netPositionRecord.model.percentChangeText,
                                    style: Utils.fonts(
                                      size: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: widget.netPositionRecord.model.percentChange > 0
                                          ? Utils.mediumGreenColor
                                          : widget.netPositionRecord.model.percentChange < 0
                                              ? Utils.mediumRedColor
                                              : theme.errorColor,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // /* Displaying the Script buy sell status */
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
