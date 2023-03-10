import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/controllers/netPositionController.dart';
import 'package:markets/jmScreens/orders/OrderModification/modify_currency_order_screen.dart';
import 'package:markets/jmScreens/orders/OrderPlacement/spread_order_screen.dart';

import '../../../model/existingOrderDetails.dart';
import '../../../model/scrip_info_model.dart';
import '../../../screens/scrip_details_screen.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/InAppSelections.dart';
import '../../../util/Utils.dart';
import '../../../widget/scripdetail_optionChain.dart';
import '../../CommonWidgets/switch.dart';
import '../../profile/LimitScreen.dart';
import '../OrderModification/modify_commodity_order_screen.dart';
import '../OrderModification/modify_derivative_order_screen.dart';
import '../OrderModification/modify_equity_order_screen.dart';
import '../bid_ask_screen.dart';
import '../positions_screen.dart';
import 'commodity_order_screen.dart';
import 'convert_order_screen.dart';
import 'currency_order_screen.dart';
import 'derivative_order_screen.dart';
import 'equity_order_screen.dart';

class OrderPlacementScreen extends StatefulWidget {
  ScripInfoModel model;
  final ScripDetailType orderType;
  final isBuy;
  final ExistingNewOrderDetails orderModel;
  String selectedExch;
  final Stream<bool> stream;

  OrderPlacementScreen({
    @required this.model,
    @required this.orderType,
    @required this.isBuy,
    this.orderModel,
    this.selectedExch,
    this.stream,
  });

  @override
  State<OrderPlacementScreen> createState() => _OrderPlacementScreenState();
}

enum NseBse { nse, bse }

class _OrderPlacementScreenState extends State<OrderPlacementScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  NseBse selectedModel;
  static List<Widget> _pages;
  List<int> optionDates;
  ScripInfoModel nseModel, bseModel;
  bool orderFlow;
  var _orderFlowController = ValueNotifier<bool>(false);

  @override
  void initState() {
    Dataconstants.iqsClient.sendLTPRequest(widget.model, true);
    _orderFlowController.addListener(() {
      setState(() {
        if (_orderFlowController.value == true)
          onActionToggle(false);
        else
          onActionToggle(true);
      });
    });
    if (NetPositionController.openPositionList.isEmpty && NetPositionController.closePositionList.isEmpty) {
      // Dataconstants.todaysPositionController.fetchTodaysPosition();
      Dataconstants.netPositionController.fetchNetPosition();
    }
    orderFlow = widget.isBuy;
    if (orderFlow == true)
      _orderFlowController.value = false;
    else
      _orderFlowController.value = true;
    InAppSelection.orderPlacementScreenIndex = 0;
    if (widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity) {
      if (widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.convertPosition) widget.selectedExch = widget.orderModel.exch;
      if (widget.model.alternateModel != null) {
        nseModel = null;
        bseModel = null;
        if (widget.selectedExch == "N") {
          selectedModel = NseBse.nse;
          nseModel = widget.model;
          bseModel = widget.model.alternateModel;
        }
        if (widget.selectedExch == "B") {
          selectedModel = NseBse.bse;
          nseModel = widget.model.alternateModel;
          bseModel = widget.model;
        }
        Dataconstants.iqsClient.sendScripRequestToIQS(
          widget.model.alternateModel,
          true,
        );
      } else {
        if (widget.model.exch == 'B') {
          bseModel = widget.model;
          selectedModel = NseBse.bse;
        } else {
          nseModel = widget.model;
          selectedModel = NseBse.nse;
        }
      }
      if (widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.convertPosition) {
        widget.orderModel.exch == 'N' ? selectedModel = NseBse.nse : selectedModel = NseBse.bse;
      }
      // } else if (widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions) {
    } else {
      if (widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.convertPosition)
        widget.selectedExch = widget.orderModel.exch;
      else
        widget.selectedExch = widget.model.exch;
      if (widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.convertPosition) {
        widget.orderModel.exch == 'N' ? selectedModel = NseBse.nse : selectedModel = NseBse.bse;
        widget.orderModel.exch == 'N' ? nseModel = widget.model : bseModel = widget.model;
      } else {
        widget.model.exch == 'N' ? selectedModel = NseBse.nse : selectedModel = NseBse.bse;
        widget.model.exch == 'N' ? nseModel = widget.model : bseModel = widget.model;
      }
    }
    getOptionChain();
    _pages = getPages();
    widget.stream.listen((seconds) {
      _updateSeconds();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // Dataconstants.iqsClient
    //     .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
  }

  void _updateSeconds() {
    if (mounted) setState(() {});
  }

  void onToggle(var value, bool isExchNse) async {
    if (isExchNse) {
      if (nseModel == null || widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.positionExit || widget.orderType == ScripDetailType.holdingExit) return;
      widget.model = selectedModel == NseBse.nse && nseModel.exch == 'N'
          ? bseModel
          : selectedModel == NseBse.bse && bseModel.exch == 'B'
              ? nseModel
              : widget.model;
      setState(() {
        selectedModel = value;
      });
      Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    } else {
      if (bseModel == null || widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.positionExit || widget.orderType == ScripDetailType.holdingExit) return;
      widget.model = selectedModel == NseBse.nse && nseModel.exch == 'N'
          ? bseModel
          : selectedModel == NseBse.bse && bseModel.exch == 'B'
              ? nseModel
              : widget.model;
      setState(() {
        selectedModel = value;
      });
      Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    }
    getOptionChain();
    _pages = await getPages();
    Dataconstants.pageController.add(true);
  }

  void onActionToggle(bool isBuy) {
    orderFlow = isBuy;
    _pages = getPages();
    Dataconstants.pageController.add(true);
    // Navigator.of(context).pop();
  }

  void getOptionChain() {
    ScripInfoModel currentModel = selectedModel == NseBse.nse ? nseModel : bseModel;
    if (currentModel.exchCategory == ExchCategory.nseEquity || currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
      optionDates = Dataconstants.exchData[1].getDatesForOptions(currentModel);
    } else if (currentModel.exchCategory == ExchCategory.mcxFutures || currentModel.exchCategory == ExchCategory.mcxOptions) {
      optionDates = Dataconstants.exchData[5].getDatesForOptionsMcx(currentModel.ulToken);
    } else {
      int exchPos;
      if (currentModel.exchCategory == ExchCategory.currenyFutures || currentModel.exchCategory == ExchCategory.currenyOptions)
        exchPos = 3;
      else
        exchPos = 4;
      optionDates = Dataconstants.exchData[exchPos].getDatesForOptionsCurr(currentModel.ulToken);
    }
  }

  List<Widget> getPages() {
    return [
      widget.orderType == ScripDetailType.modify || widget.orderType == ScripDetailType.positionExit || widget.orderType == ScripDetailType.holdingExit
          ? widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity
              ? ModifyEquityOrderScreen(
                  model: selectedModel == NseBse.nse ? nseModel : bseModel,
                  orderType: widget.orderType,
                  isBuy: widget.isBuy,
                  orderModel: widget.orderModel,
                  stream: Dataconstants.pageController.stream,
                )
              : widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions
                  ? ModifyDerivativeOrderScreen(
                      model: widget.model,
                      orderType: widget.orderType,
                      isBuy: widget.isBuy,
                      orderModel: widget.orderModel,
                      stream: Dataconstants.pageController.stream,
                    )
                  : widget.model.exchCategory == ExchCategory.mcxFutures || widget.model.exchCategory == ExchCategory.mcxOptions
                      ? ModifyCommodityOrderScreen(
                          model: widget.model,
                          orderType: widget.orderType,
                          isBuy: widget.isBuy,
                          orderModel: widget.orderModel,
                          stream: Dataconstants.pageController.stream,
                        )
                      : ModifyCurrencyOrderScreen(
                          model: widget.model,
                          orderType: widget.orderType,
                          isBuy: widget.isBuy,
                          orderModel: widget.orderModel,
                          stream: Dataconstants.pageController.stream,
                        )
          : widget.orderType == ScripDetailType.convertPosition
              ? ConvertOrderScreen(
                  model: widget.model,
                  isBuy: widget.isBuy,
                  orderModel: widget.orderModel,
                )
              : widget.model.isSpread == true
                  ? SpreadOrderScreen(
                      model: selectedModel == NseBse.nse ? nseModel : bseModel,
                      isBuy: widget.isBuy,
                      orderType: widget.orderType,
                      stream: Dataconstants.pageController.stream,
                    )
                  : widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity
                      ? EquityOrderScreen(
                          model: selectedModel == NseBse.nse ? nseModel : bseModel,
                          orderType: widget.orderType,
                          isBuy: orderFlow,
                          // isBuy: widget.isBuy,
                          orderModel: widget.orderModel,
                          stream: Dataconstants.pageController.stream,
                        )
                      : widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions
                          ? DerivativeOrderScreen(
                              model: widget.model,
                              orderType: widget.orderType,
                              isBuy: orderFlow,
                              // isBuy: widget.isBuy,
                              orderModel: widget.orderModel,
                              stream: Dataconstants.pageController.stream,
                            )
                          : widget.model.exchCategory == ExchCategory.mcxFutures || widget.model.exchCategory == ExchCategory.mcxOptions
                              ? CommodityOrderScreen(
                                  model: widget.model,
                                  orderType: widget.orderType,
                                  isBuy: orderFlow,
                                  // isBuy: widget.isBuy,
                                  orderModel: widget.orderModel,
                                  stream: Dataconstants.pageController.stream,
                                )
                              : CurrencyOrderScreen(
                                  model: widget.model,
                                  orderType: widget.orderType,
                                  isBuy: orderFlow,
                                  // isBuy: widget.isBuy,
                                  orderModel: widget.orderModel,
                                  stream: Dataconstants.pageController.stream,
                                ),
      BidAskScreen(selectedModel == NseBse.nse ? nseModel : bseModel),
      // MarketDepth(selectedModel == NseBse.nse ? nseModel : bseModel,),
      // EquityOrderScreen(
      //   model: widget.model,
      //   orderType: widget.orderType,
      //   isBuy: widget.isBuy,
      //   stream: Dataconstants.pageController.stream,),
      optionDates.length > 0
          ? ScripdetailOptionChain(selectedModel == NseBse.nse ? nseModel : bseModel, optionDates, 0, "0")
          : Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
      PositionsScreen(),
      LimitScreen(),
    ];
  }

  Future<bool> handleWillPop(BuildContext context) async {
    if (Dataconstants.showOrderFormKeyboard == true) {
      setState(() {
        Dataconstants.showOrderFormKeyboard = false;
        Dataconstants.pageController.add(true);
        return false;
      });
    } else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        // resizeToAvoidBottomInset: false,
        appBar: widget.orderType == ScripDetailType.convertPosition
            ? InAppSelection.orderPlacementScreenIndex == 1
                ? AppBar(
                    leadingWidth: 30.0,
                    leading: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      // color: Colors.white,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    elevation: 0,
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                          ),
                          child: Text(widget.isBuy ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(
                          width: size.width - 145,
                          child: Text(
                            widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity ? widget.model.desc : widget.model.marketWatchName,
                            style: Utils.fonts(size: 15.0, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Utils.greyColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                onToggle(NseBse.nse, true);
                              },
                              child: Container(
                                width: size.width * 0.46,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                decoration: BoxDecoration(
                                    color: selectedModel == NseBse.nse ? Utils.lightGreyColor.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedModel == NseBse.nse ? Utils.lightGreyColor.withOpacity(0.5) : Colors.transparent,
                                    )),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'NSE',
                                          style: Utils.fonts(
                                            size: 14.0,
                                            color: Utils.blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        FittedBox(
                                          child: Observer(
                                            builder: (_) => Text(
                                                /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                                nseModel == null
                                                    ? '0.00'
                                                    : nseModel.close == 0.00
                                                        ? nseModel.prevDayClose.toStringAsFixed(2)
                                                        : nseModel.close.toStringAsFixed(2),
                                                style: Utils.fonts(
                                                  size: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedModel == NseBse.nse ? Utils.blackColor : Utils.blackColor.withOpacity(0.5),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Radio(
                                            activeColor: Utils.greyColor,
                                            value: NseBse.nse,
                                            groupValue: selectedModel,
                                            onChanged: (value) {
                                              onToggle(value, true);
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Observer(
                                              builder: (_) => nseModel == null
                                                  ? Text(
                                                      '0.00',
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                      ),
                                                    )
                                                  : Text(
                                                      /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                      nseModel.close == 0.00 ? '0.00' : nseModel.priceChangeText,
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: selectedModel == NseBse.nse
                                                            ? nseModel.priceChange > 0
                                                                ? Utils.mediumGreenColor
                                                                : nseModel.priceChange < 0
                                                                    ? Utils.mediumRedColor
                                                                    : theme.textTheme.bodyText1.color
                                                            : nseModel.priceChange > 0
                                                                ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                : nseModel.priceChange < 0
                                                                    ? Utils.mediumRedColor.withOpacity(0.5)
                                                                    : theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(width: 5),
                                            FittedBox(
                                              child: Observer(
                                                builder: (_) => nseModel == null
                                                    ? Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                        child: Text(
                                                          '0.00%',
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Utils.whiteColor,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(2),
                                                            color: selectedModel == NseBse.nse
                                                                ? nseModel.priceChange > 0
                                                                    ? Utils.mediumGreenColor
                                                                    : nseModel.priceChange < 0
                                                                        ? Utils.mediumRedColor
                                                                        : theme.textTheme.bodyText1.color
                                                                : nseModel.priceChange > 0
                                                                    ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                    : nseModel.priceChange < 0
                                                                        ? Utils.mediumRedColor.withOpacity(0.5)
                                                                        : theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                        child: Text(
                                                          /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                          nseModel.close == 0.00 ? '0.00%' : '${nseModel.percentChange.toStringAsFixed(nseModel.precision)}%',
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Utils.whiteColor,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onToggle(NseBse.bse, true);
                              },
                              child: Container(
                                width: size.width * 0.46,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                decoration: BoxDecoration(
                                    color: selectedModel == NseBse.bse ? Utils.lightGreyColor.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedModel == NseBse.bse ? Utils.lightGreyColor.withOpacity(0.5) : Colors.transparent,
                                    )),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'BSE',
                                          style: Utils.fonts(
                                            size: 14.0,
                                            color: Utils.blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        FittedBox(
                                          child: Observer(
                                            builder: (_) => Text(
                                                /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                                bseModel == null
                                                    ? '0.00'
                                                    : bseModel.close == 0.00
                                                        ? bseModel.prevDayClose.toStringAsFixed(2)
                                                        : bseModel.close.toStringAsFixed(2),
                                                style: Utils.fonts(
                                                  size: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedModel == NseBse.bse ? Utils.blackColor : Utils.blackColor.withOpacity(0.5),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Radio(
                                            activeColor: Utils.greyColor,
                                            value: NseBse.bse,
                                            groupValue: selectedModel,
                                            onChanged: (value) {
                                              onToggle(value, false);
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Observer(
                                              builder: (_) => bseModel == null
                                                  ? Text(
                                                      '0.00',
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                      ),
                                                    )
                                                  : Text(
                                                      /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                      bseModel.close == 0.00 ? '0.00' : bseModel.priceChangeText,
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: selectedModel == NseBse.bse
                                                            ? bseModel.priceChange > 0
                                                                ? Utils.mediumGreenColor
                                                                : bseModel.priceChange < 0
                                                                    ? Utils.mediumRedColor
                                                                    : theme.textTheme.bodyText1.color
                                                            : bseModel.priceChange > 0
                                                                ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                : bseModel.priceChange < 0
                                                                    ? Utils.mediumRedColor.withOpacity(0.5)
                                                                    : theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(width: 5),
                                            FittedBox(
                                              child: Observer(
                                                builder: (_) => bseModel == null
                                                    ? Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                        child: Text(
                                                          '0.00%',
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Utils.whiteColor,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(2),
                                                            color: selectedModel == NseBse.bse
                                                                ? bseModel.priceChange > 0
                                                                    ? Utils.mediumGreenColor
                                                                    : bseModel.priceChange < 0
                                                                        ? Utils.mediumRedColor
                                                                        : theme.textTheme.bodyText1.color
                                                                : bseModel.priceChange > 0
                                                                    ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                    : bseModel.priceChange < 0
                                                                        ? Utils.mediumRedColor.withOpacity(0.5)
                                                                        : theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                        child: Text(
                                                          /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                          bseModel.close == 0.00 ? '0.00%' : '${bseModel.percentChange.toStringAsFixed(bseModel.precision)}%',
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Utils.whiteColor,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : InAppSelection.orderPlacementScreenIndex == 3
                    ? AppBar(
                        leadingWidth: 30.0,
                        leading: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                          // color: Colors.white,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        elevation: 0,
                        title: Text(
                          'POSITIONS',
                          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                        ),
                      )
                    : null
            : InAppSelection.orderPlacementScreenIndex == 4
                ? null
                : InAppSelection.orderPlacementScreenIndex == 3
                    ? AppBar(
                        leadingWidth: 30.0,
                        leading: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                          // color: Colors.white,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        elevation: 0,
                        title: Text(
                          'POSITIONS',
                          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                        ),
                      )
                    : widget.model.isSpread == true
                        ? AppBar(
                            leadingWidth: 20.0,
                            leading: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Icon(Icons.arrow_back_ios),
                              ),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            elevation: 0,
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                                      ),
                                      child: Text(widget.isBuy ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Observer(
                                      builder: (_) => Text(
                                        widget.model.close.toStringAsFixed(widget.model.precision),
                                        style: Utils.fonts(color: Utils.blackColor, size: 12.0, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.model.name,
                                          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          widget.model.expiryDateString,
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          widget.model.isOption == true ? 'OPT' : 'FUT',
                                          style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(color: Utils.greyColor, borderRadius: BorderRadius.circular(3)),
                                      child: Text(
                                        'Spread' +
                                            ' ' +
                                            widget.model.desc.split(' ')[1] +
                                            ' ' +
                                            widget.model.desc.split(' ')[2] +
                                            ' - ' +
                                            widget.model.desc.split(' ')[4] +
                                            ' ' +
                                            widget.model.desc.split(' ')[5] +
                                            ' Fut',
                                        style: Utils.fonts(size: 12.0, color: Utils.whiteColor, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            actions: [
                              InkWell(
                                radius: 25,
                                onTap: () {
                                  //TODO:
                                },
                                child: Icon(
                                  Icons.more_vert,
                                  color: Utils.greyColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        : widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity
                            ? AppBar(
                                leadingWidth: 30.0,
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: const Icon(Icons.arrow_back_ios),
                                  ),
                                  // color: Colors.white,
                                  onTap: () => Navigator.of(context).pop(),
                                ),
                                elevation: 0,
                                title: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: orderFlow ? Utils.brightGreenColor : Utils.brightRedColor,
                                      ),
                                      child: Text(orderFlow ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w700)),
                                    ),
                                    Expanded(
                                      child: AutoSizeText(
                                        widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity ? widget.model.desc : widget.model.marketWatchName,
                                        maxLines: 1,
                                        style: Utils.fonts(size: 15.0, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Visibility(
                                    visible: widget.orderType == ScripDetailType.none,
                                    child: InkWell(
                                      radius: 25,
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(top: size.height - 120),
                                                child: AlertDialog(
                                                  // shape:
                                                  insetPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  content: SizedBox(
                                                    width: size.width,
                                                    child: Row(
                                                      children: [
                                                        Text('Action'),
                                                        Spacer(),
                                                        Container(
                                                          color: Utils.brightGreenColor,
                                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                          child: Text(
                                                            'BUY',
                                                            style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        ToggleSwitch(
                                                          switchController: _orderFlowController,
                                                          isBorder: true,
                                                          activeColor: Utils.whiteColor,
                                                          inactiveColor: Utils.whiteColor,
                                                          thumbColor: Utils.blackColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          color: Utils.brightRedColor,
                                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                          child: Text(
                                                            'SELL',
                                                            style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(50),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Utils.greyColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                          visible: nseModel != null,
                                          child: GestureDetector(
                                            onTap: () {
                                              onToggle(NseBse.nse, true);
                                            },
                                            child: Container(
                                              width: bseModel != null ? size.width * 0.46 : size.width * 0.93,
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                              decoration: BoxDecoration(
                                                  color: selectedModel == NseBse.nse ? Utils.lightGreyColor.withOpacity(0.2) : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: selectedModel == NseBse.nse ? Utils.lightGreyColor.withOpacity(0.5) : Colors.transparent,
                                                  )),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'NSE',
                                                        style: Utils.fonts(
                                                          size: 14.0,
                                                          color: Utils.blackColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      FittedBox(
                                                        child: Observer(
                                                          builder: (_) => Text(
                                                              /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                                              nseModel == null
                                                                  ? '0.00'
                                                                  : nseModel.close == 0.00
                                                                      ? nseModel.prevDayClose.toStringAsFixed(2)
                                                                      : nseModel.close.toStringAsFixed(2),
                                                              style: Utils.fonts(
                                                                size: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: selectedModel == NseBse.nse ? Utils.blackColor : Utils.blackColor.withOpacity(0.5),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: Radio(
                                                          activeColor: Utils.greyColor,
                                                          value: NseBse.nse,
                                                          groupValue: selectedModel,
                                                          onChanged: (value) {
                                                            onToggle(value, true);
                                                          },
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Observer(
                                                            builder: (_) => nseModel == null
                                                                ? Text(
                                                                    '0.00',
                                                                    style: Utils.fonts(
                                                                      size: 12.0,
                                                                      color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                                    nseModel.close == 0.00 ? '0.00' : nseModel.priceChangeText,
                                                                    style: Utils.fonts(
                                                                      size: 12.0,
                                                                      color: selectedModel == NseBse.nse
                                                                          ? nseModel.priceChange > 0
                                                                              ? Utils.mediumGreenColor
                                                                              : nseModel.priceChange < 0
                                                                                  ? Utils.mediumRedColor
                                                                                  : theme.textTheme.bodyText1.color
                                                                          : nseModel.priceChange > 0
                                                                              ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                              : nseModel.priceChange < 0
                                                                                  ? Utils.mediumRedColor.withOpacity(0.5)
                                                                                  : theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          FittedBox(
                                                            child: Observer(
                                                              builder: (_) => nseModel == null
                                                                  ? Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                                      child: Text(
                                                                        '0.00%',
                                                                        style: Utils.fonts(
                                                                          size: 12.0,
                                                                          color: Utils.whiteColor,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(2),
                                                                          color: selectedModel == NseBse.nse
                                                                              ? nseModel.priceChange > 0
                                                                                  ? Utils.mediumGreenColor
                                                                                  : nseModel.priceChange < 0
                                                                                      ? Utils.mediumRedColor
                                                                                      : theme.textTheme.bodyText1.color
                                                                              : nseModel.priceChange > 0
                                                                                  ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                                  : nseModel.priceChange < 0
                                                                                      ? Utils.mediumRedColor.withOpacity(0.5)
                                                                                      : theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                                      child: Text(
                                                                        /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                                        nseModel.close == 0.00 ? '0.00%' : '${nseModel.percentChange.toStringAsFixed(nseModel.precision)}%',
                                                                        style: Utils.fonts(
                                                                          size: 12.0,
                                                                          color: Utils.whiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: bseModel != null,
                                          child: GestureDetector(
                                            onTap: () {
                                              onToggle(NseBse.bse, true);
                                            },
                                            child: Container(
                                              width: nseModel != null ? size.width * 0.46 : size.width * 0.93,
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                              decoration: BoxDecoration(
                                                  color: selectedModel == NseBse.bse ? Utils.lightGreyColor.withOpacity(0.2) : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: selectedModel == NseBse.bse ? Utils.lightGreyColor.withOpacity(0.5) : Colors.transparent,
                                                  )),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'BSE',
                                                        style: Utils.fonts(
                                                          size: 14.0,
                                                          color: Utils.blackColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      FittedBox(
                                                        child: Observer(
                                                          builder: (_) => Text(
                                                              /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                                              bseModel == null
                                                                  ? '0.00'
                                                                  : bseModel.close == 0.00
                                                                      ? bseModel.prevDayClose.toStringAsFixed(2)
                                                                      : bseModel.close.toStringAsFixed(2),
                                                              style: Utils.fonts(
                                                                size: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: selectedModel == NseBse.bse ? Utils.blackColor : Utils.blackColor.withOpacity(0.5),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: Radio(
                                                          activeColor: Utils.greyColor,
                                                          value: NseBse.bse,
                                                          groupValue: selectedModel,
                                                          onChanged: (value) {
                                                            onToggle(value, false);
                                                          },
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Observer(
                                                            builder: (_) => bseModel == null
                                                                ? Text(
                                                                    '0.00',
                                                                    style: Utils.fonts(
                                                                      size: 12.0,
                                                                      color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                                    bseModel.close == 0.00 ? '0.00' : bseModel.priceChangeText,
                                                                    style: Utils.fonts(
                                                                      size: 12.0,
                                                                      color: selectedModel == NseBse.bse
                                                                          ? bseModel.priceChange > 0
                                                                              ? Utils.mediumGreenColor
                                                                              : bseModel.priceChange < 0
                                                                                  ? Utils.mediumRedColor
                                                                                  : theme.textTheme.bodyText1.color
                                                                          : bseModel.priceChange > 0
                                                                              ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                              : bseModel.priceChange < 0
                                                                                  ? Utils.mediumRedColor.withOpacity(0.5)
                                                                                  : theme.textTheme.bodyText1.color.withOpacity(0.5),
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          FittedBox(
                                                            child: Observer(
                                                              builder: (_) => bseModel == null
                                                                  ? Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                                      child: Text(
                                                                        '0.00%',
                                                                        style: Utils.fonts(
                                                                          size: 12.0,
                                                                          color: Utils.whiteColor,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(2),
                                                                          color: selectedModel == NseBse.bse
                                                                              ? bseModel.priceChange > 0
                                                                                  ? Utils.mediumGreenColor
                                                                                  : bseModel.priceChange < 0
                                                                                      ? Utils.mediumRedColor
                                                                                      : theme.textTheme.bodyText1.color
                                                                              : bseModel.priceChange > 0
                                                                                  ? Utils.mediumGreenColor.withOpacity(0.5)
                                                                                  : bseModel.priceChange < 0
                                                                                      ? Utils.mediumRedColor.withOpacity(0.5)
                                                                                      : theme.textTheme.bodyText1.color.withOpacity(0.5)),
                                                                      child: Text(
                                                                        /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                                        bseModel.close == 0.00 ? '0.00%' : '${bseModel.percentChange.toStringAsFixed(bseModel.precision)}%',
                                                                        style: Utils.fonts(
                                                                          size: 12.0,
                                                                          color: Utils.whiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions
                                ? AppBar(
                                    leadingWidth: 30.0,
                                    leading: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: const Icon(Icons.arrow_back_ios),
                                      ),
                                      onTap: () => Navigator.of(context).pop(),
                                    ),
                                    elevation: 0,
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: orderFlow ? Utils.brightGreenColor : Utils.brightRedColor,
                                              ),
                                              child: Text(orderFlow ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.model.name,
                                              style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.model.expiryDateString,
                                              style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              widget.model.exchCategory == ExchCategory.nseFuture ? 'FUT' : '',
                                              style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                            ),
                                            Visibility(
                                                visible: widget.model.exchCategory == ExchCategory.nseOptions,
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      widget.model.strikePrice.toStringAsFixed(0),
                                                      style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                )),
                                            Visibility(
                                                visible: widget.model.exchCategory == ExchCategory.nseOptions,
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      widget.model.cpType == 3 ? 'CE' : 'PE',
                                                      style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Observer(
                                              builder: (_) => Text(
                                                widget.model.close.toStringAsFixed(widget.model.precision),
                                                style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Observer(
                                              builder: (_) => Text(
                                                /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                widget.model.close == 0.00 ? '0.00' : widget.model.priceChangeText,
                                                style: Utils.fonts(
                                                  size: 11.0,
                                                  color: widget.model.priceChange > 0
                                                      ? Utils.mediumGreenColor
                                                      : widget.model.priceChange < 0
                                                          ? Utils.mediumRedColor
                                                          : theme.textTheme.bodyText1.color,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Observer(
                                              builder: (_) => Container(
                                                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(2),
                                                    color: widget.model.priceChange > 0
                                                        ? Utils.mediumGreenColor
                                                        : widget.model.priceChange < 0
                                                            ? Utils.mediumRedColor
                                                            : theme.textTheme.bodyText1.color),
                                                child: Text(
                                                  /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                  widget.model.close == 0.00 ? '0.00%' : '${widget.model.percentChange.toStringAsFixed(widget.model.precision)}%',
                                                  style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Visibility(
                                        visible: widget.orderType == ScripDetailType.none,
                                        child: InkWell(
                                          radius: 25,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(top: size.height - 120),
                                                    child: AlertDialog(
                                                      // shape:
                                                      insetPadding: EdgeInsets.symmetric(horizontal: 0),
                                                      content: SizedBox(
                                                        width: size.width,
                                                        child: Row(
                                                          children: [
                                                            Text('Action'),
                                                            Spacer(),
                                                            Container(
                                                              color: Utils.brightGreenColor,
                                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                              child: Text(
                                                                'BUY',
                                                                style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            ToggleSwitch(
                                                              switchController: _orderFlowController,
                                                              isBorder: true,
                                                              activeColor: Utils.whiteColor,
                                                              inactiveColor: Utils.whiteColor,
                                                              thumbColor: Utils.blackColor,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              color: Utils.brightRedColor,
                                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                              child: Text(
                                                                'SELL',
                                                                style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Utils.greyColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : widget.model.exchCategory == ExchCategory.mcxFutures || widget.model.exchCategory == ExchCategory.mcxOptions
                                    ? AppBar(
                                        leadingWidth: 30.0,
                                        leading: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: const Icon(Icons.arrow_back_ios),
                                          ),
                                          onTap: () => Navigator.of(context).pop(),
                                        ),
                                        elevation: 0,
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: orderFlow ? Utils.brightGreenColor : Utils.brightRedColor,
                                                  ),
                                                  child: Text(orderFlow ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  widget.model.name,
                                                  style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  widget.model.expiryDateString,
                                                  style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  widget.model.exchCategory == ExchCategory.mcxFutures ? 'FUT' : '',
                                                  style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                                ),
                                                Visibility(
                                                    visible: widget.model.exchCategory == ExchCategory.mcxOptions,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          widget.model.strikePrice.toStringAsFixed(0),
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    )),
                                                Visibility(
                                                    visible: widget.model.exchCategory == ExchCategory.mcxOptions,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          widget.model.cpType == 3 ? 'CE' : 'PE',
                                                          style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Observer(
                                                  builder: (_) => Text(
                                                    widget.model.close.toStringAsFixed(widget.model.precision),
                                                    style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Observer(
                                                  builder: (_) => Text(
                                                    /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                    widget.model.close == 0.00 ? '0.00' : widget.model.priceChangeText,
                                                    style: Utils.fonts(
                                                      size: 11.0,
                                                      color: widget.model.priceChange > 0
                                                          ? Utils.mediumGreenColor
                                                          : widget.model.priceChange < 0
                                                              ? Utils.mediumRedColor
                                                              : theme.textTheme.bodyText1.color,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Observer(
                                                  builder: (_) => Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(2),
                                                        color: widget.model.priceChange > 0
                                                                ? Utils.mediumGreenColor
                                                                : widget.model.priceChange < 0
                                                                    ? Utils.mediumRedColor
                                                                    : theme.textTheme.bodyText1.color),
                                                    child: Text(
                                                      /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                      widget.model.close == 0.00 ? '0.00%' : '${widget.model.percentChange.toStringAsFixed(widget.model.precision)}%',
                                                      style: Utils.fonts(
                                                        size: 11.0,
                                                        color: Utils.whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Visibility(
                                            visible: widget.orderType == ScripDetailType.none,
                                            child: InkWell(
                                              radius: 25,
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(top: size.height - 120),
                                                        child: AlertDialog(
                                                          // shape:
                                                          insetPadding: EdgeInsets.symmetric(horizontal: 0),
                                                          content: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Text('Action'),
                                                                Spacer(),
                                                                Container(
                                                                  color: Utils.brightGreenColor,
                                                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                  child: Text(
                                                                    'BUY',
                                                                    style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ToggleSwitch(
                                                                  switchController: _orderFlowController,
                                                                  isBorder: true,
                                                                  activeColor: Utils.whiteColor,
                                                                  inactiveColor: Utils.whiteColor,
                                                                  thumbColor: Utils.blackColor,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  color: Utils.brightRedColor,
                                                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                  child: Text(
                                                                    'SELL',
                                                                    style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Utils.greyColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      )
                                    : AppBar(
                                        leadingWidth: 30.0,
                                        leading: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: const Icon(Icons.arrow_back_ios),
                                          ),
                                          onTap: () => Navigator.of(context).pop(),
                                        ),
                                        elevation: 0,
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: orderFlow ? Utils.brightGreenColor : Utils.brightRedColor,
                                                  ),
                                                  child: Text(orderFlow ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  widget.model.name,
                                                  style: Utils.fonts(size: 16.0, color: Utils.blackColor),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  widget.model.expiryDateString,
                                                  style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  widget.model.exchCategory == ExchCategory.currenyFutures || widget.model.exchCategory == ExchCategory.bseCurrenyFutures ? 'FUT' : '',
                                                  style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                                ),
                                                Visibility(
                                                    visible: widget.model.exchCategory == ExchCategory.currenyOptions || widget.model.exchCategory == ExchCategory.bseCurrenyOptions,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          widget.model.strikePrice.toStringAsFixed(0),
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    )),
                                                Visibility(
                                                    visible: widget.model.exchCategory == ExchCategory.currenyOptions || widget.model.exchCategory == ExchCategory.bseCurrenyOptions,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          widget.model.cpType == 3 ? 'CE' : 'PE',
                                                          style: Utils.fonts(size: 14.0, color: Utils.primaryColor, fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Observer(
                                                  builder: (_) => Text(
                                                    widget.model.close.toStringAsFixed(widget.model.precision),
                                                    style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Observer(
                                                  builder: (_) => Text(
                                                    /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                    widget.model.close == 0.00 ? '0.00' : widget.model.priceChangeText,
                                                    style: Utils.fonts(
                                                      size: 11.0,
                                                      color: widget.model.priceChange > 0
                                                          ? Utils.mediumGreenColor
                                                          : widget.model.priceChange < 0
                                                          ? Utils.mediumRedColor
                                                          : theme.textTheme.bodyText1.color,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Observer(
                                                  builder: (_) => Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(2),
                                                        color: widget.model.priceChange > 0
                                                            ? Utils.mediumGreenColor
                                                            : widget.model.priceChange < 0
                                                            ? Utils.mediumRedColor
                                                            : theme.textTheme.bodyText1.color),
                                                    child: Text(
                                                      /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                      widget.model.close == 0.00 ? '0.00%' : '${widget.model.percentChange.toStringAsFixed(widget.model.precision)}%',
                                                      style: Utils.fonts(
                                                        size: 11.0,
                                                        color: Utils.whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Visibility(
                                            visible: widget.orderType == ScripDetailType.none,
                                            child: InkWell(
                                              radius: 25,
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(top: size.height - 120),
                                                        child: AlertDialog(
                                                          // shape:
                                                          insetPadding: EdgeInsets.symmetric(horizontal: 0),
                                                          content: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Text('Action'),
                                                                Spacer(),
                                                                Container(
                                                                  color: Utils.brightGreenColor,
                                                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                  child: Text(
                                                                    'BUY',
                                                                    style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ToggleSwitch(
                                                                  switchController: _orderFlowController,
                                                                  isBorder: true,
                                                                  activeColor: Utils.whiteColor,
                                                                  inactiveColor: Utils.whiteColor,
                                                                  thumbColor: Utils.blackColor,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  color: Utils.brightRedColor,
                                                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                  child: Text(
                                                                    'SELL',
                                                                    style: Utils.fonts(size: 14.0, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Utils.greyColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
        body: Builder(
          builder: (context) => WillPopScope(
            onWillPop: () => handleWillPop(context),
            child: _pages.elementAt(
              InAppSelection.orderPlacementScreenIndex,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          selectedLabelStyle: Utils.fonts(
            size: 10.0,
            fontWeight: FontWeight.w200,
          ),
          unselectedLabelStyle: Utils.fonts(
            size: 10.0,
            fontWeight: FontWeight.w200,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/appImages/buysell.svg', color: InAppSelection.orderPlacementScreenIndex == 0 ? Utils.primaryColor : Utils.greyColor),
              label: 'B/S',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/appImages/bidask.svg', color: InAppSelection.orderPlacementScreenIndex == 1 ? Utils.primaryColor : Utils.greyColor),
              label: 'BID/ASK',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/appImages/optionChain.svg', color: InAppSelection.orderPlacementScreenIndex == 2 ? Utils.primaryColor : Utils.greyColor),
              label: 'OPTION CHAIN',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/appImages/positions.svg', color: InAppSelection.orderPlacementScreenIndex == 3 ? Utils.primaryColor : Utils.greyColor),
              label: 'POSITION',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/appImages/funds.svg', color: InAppSelection.orderPlacementScreenIndex == 4 ? Utils.primaryColor : Utils.greyColor),
              label: 'FUNDS',
            ),
          ],
          currentIndex: InAppSelection.orderPlacementScreenIndex,
          onTap: (index) {
            setState(() {
              InAppSelection.orderPlacementScreenIndex = index;
            });
          },
        ),
      ),
    );
  }
}
