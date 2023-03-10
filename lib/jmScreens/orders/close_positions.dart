import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/netPositionController.dart';
import '../../controllers/positionFilterController.dart';
import '../../model/jmModel/netPosition.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'net_position_details.dart';

class ClosePositions extends StatefulWidget {
  @override
  _ClosePositionsState createState() => _ClosePositionsState();
}

class _ClosePositionsState extends State<ClosePositions> {
  bool expandNote = false;

  // @override
  // void initState() {
  //   Dataconstants.netPositionController.fetchNetPosition();
  //   super.initState();
  // }

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
                    child: NetPositionController.closePositionList.length == 0
                        ? (PositionFilterController.isPositionSearch.value || PositionFilterController.isPositionFilter.value) && NetPositionController.NetPositionLength != 0
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
                                        "You have no Closed Positions",
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
                                      itemCount: NetPositionController.closePositionList.length,
                                      itemBuilder: (ctx, index) => NetPositionExpiryRow(
                                        theme: theme,
                                        key: ObjectKey(NetPositionController.closePositionList[index]),
                                        netPositionRecord: NetPositionController.closePositionList[index],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                expandNote = !expandNote;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Note',
                                                  style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SvgPicture.asset(!expandNote ? 'assets/appImages/down_arrow.svg' : 'assets/appImages/up_arrow.svg'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Visibility(
                                            visible: expandNote,
                                            child: Text(
                                              'For Average cost price of your carried forward open positions, please go to portfolio >Derivatives>Open Positions',
                                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.lightGreyColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/appImages/bellSmall.png'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('That’s all we have for you today', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                      ],
                                    ),
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

class NetPositionExpiryRow extends StatelessWidget {
  const NetPositionExpiryRow({
    Key key,
    @required this.netPositionRecord,
    @required this.theme,
  }) : super(key: key);

  final NetPositionDatum netPositionRecord;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalBottomSheet(isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => NetPositionDetails(netPositionRecord));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              // vertical: 5,
            ),
            child: Column(
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
                          color: int.parse(netPositionRecord.netqty) > 0
                              ? Utils.brightGreenColor
                              : int.parse(netPositionRecord.netqty) < 0
                                  ? Utils.brightRedColor
                                  : Utils.greyColor),
                      child: Text(
                        int.parse(netPositionRecord.netqty) > 0
                            ? "BUY"
                            : int.parse(netPositionRecord.netqty) < 0
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
                            netPositionRecord.model.close == 0.00 ? netPositionRecord.model.prevDayClose.toStringAsFixed(netPositionRecord.model.precision) : netPositionRecord.model.close.toStringAsFixed(netPositionRecord.model.precision),
                            style: Utils.fonts(
                                color: netPositionRecord.model.close > netPositionRecord.model.prevTickRate
                                    ? Utils.mediumGreenColor
                                    : netPositionRecord.model.close < netPositionRecord.model.prevTickRate
                                    ? Utils.mediumRedColor
                                    : Utils.greyColor,
                                size: 14.0, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              netPositionRecord.model.close > netPositionRecord.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                              color: netPositionRecord.model.close > netPositionRecord.model.prevTickRate ? ThemeConstants.buyColor : ThemeConstants.sellColor,
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
                    Text(netPositionRecord.model.name, style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)
                        // TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                    Text(netPositionRecord.netqty + ' @ ' + netPositionRecord.totalbuyavgprice, style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
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
                              text: netPositionRecord.exchange == 'NSE'
                                  ? netPositionRecord.exchange.toUpperCase()
                                  : netPositionRecord.exchange == 'BSE'
                                  ? netPositionRecord.exchange.toUpperCase()
                                  : netPositionRecord.expirydate.split('-')[0].toUpperCase() + ' ' + netPositionRecord.expirydate.split('-')[1].toUpperCase(),
                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                              children: [
                                if (netPositionRecord.model.exchCategory != ExchCategory.nseEquity || netPositionRecord.model.exchCategory != ExchCategory.bseEquity) TextSpan(text: ' '),
                                if (netPositionRecord.model.exchCategory != ExchCategory.nseEquity || netPositionRecord.model.exchCategory != ExchCategory.bseEquity)
                                  TextSpan(
                                    text: netPositionRecord.model.exchCategory == ExchCategory.nseFuture ||
                                        netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                        netPositionRecord.model.exchCategory == ExchCategory.currenyFutures ||
                                        netPositionRecord.model.exchCategory == ExchCategory.mcxFutures
                                        ? 'FUT'
                                        : netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                        netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                        netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                        netPositionRecord.model.exchCategory == ExchCategory.mcxOptions
                                        ? netPositionRecord.strikeprice.split('.')[0]
                                        : '',
                                    style:
                                    Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: netPositionRecord.model.exchCategory == ExchCategory.nseFuture ||
                                        netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                        netPositionRecord.model.exchCategory == ExchCategory.currenyFutures ||
                                        netPositionRecord.model.exchCategory == ExchCategory.mcxFutures ? Utils.primaryColor : Utils.greyColor),
                                  ),
                                if (netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.mcxOptions) TextSpan(text: ' '),
                                if (netPositionRecord.model.exchCategory == ExchCategory.nseOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.currenyOptions ||
                                    netPositionRecord.model.exchCategory == ExchCategory.mcxOptions)
                                  TextSpan(
                                    text: netPositionRecord.model.cpType == 3 ? 'CE' : 'PE',
                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: netPositionRecord.model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
                                  )
                              ]),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(height: 3, width: 3, decoration: BoxDecoration(color: Utils.greyColor, shape: BoxShape.circle)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(netPositionRecord.producttype.toUpperCase(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /* Displaying the price change of the script */
                        Observer(
                          builder: (_) => Text(
                            "${netPositionRecord.model.close == 0.00 ? "0.00" : netPositionRecord.model.priceChangeText}",
                            style: Utils.fonts(
                                color: netPositionRecord.model.percentChange > 0
                                    ? Utils.mediumGreenColor
                                    : netPositionRecord.model.percentChange < 0
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
                              netPositionRecord.model.close == 0.00 ? "(0.00%)" : netPositionRecord.model.percentChangeText,
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                                color: netPositionRecord.model.percentChange > 0
                                    ? Utils.mediumGreenColor
                                    : netPositionRecord.model.percentChange < 0
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
          ),
          const Divider(),
        ],
      ),
    );
  }
}
