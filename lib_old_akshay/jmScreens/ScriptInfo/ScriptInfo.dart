import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/orders/OrderPlacement/order_placement_screen.dart';
import 'package:markets/widget/scripdetail_optionChain.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../controllers/CompanyQuoteBonusController.dart';
import '../../controllers/CompanyQuoteDividendController.dart';
import '../../controllers/CompanyQuoteRightsComtroller.dart';
import '../../controllers/CompanyQuoteSplitsController.dart';
import '../../controllers/SwotController.dart';
import '../../controllers/balanceSheetController.dart';
import '../../controllers/cashFlowController.dart';
import '../../controllers/profitAndLossController.dart';
import '../../controllers/shareHoldingController.dart';
import '../../model/exchData.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/intellectChart/SChart.dart';
import '../../screens/news_screen.dart';
import '../../screens/scrip_details_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../../widget/scripdetail_chart.dart';
import '../../widget/scripdetail_future.dart';
import '../../widget/watchlist_picker_card.dart';
import '../research/research_cards.dart';
import '../research/research_screen.dart';
import 'bar_chart.dart';

class ScriptInfo extends StatefulWidget {
  final ScripInfoModel model;
  final int watchListId;
  final int watchlistIndex;
  bool isFromDashboard = false;

  ScriptInfo(
    this.model,
    this.isFromDashboard, {
    this.watchListId,
    this.watchlistIndex,
  });

  @override
  State<ScriptInfo> createState() => _ScriptInfoState();
}

class _ScriptInfoState extends State<ScriptInfo> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, WidgetsBindingObserver {
  var desc;
  var finalDesc;
  var timeValue = 1;
  var yearValue;
  bool isIndices = false, showChart = false;
  var whichOption;
  var _newsNseCode = 0;
  var jsonCmotVariables;
  var scripEvents = 1;
  var cmotVariables;
  var watchCount = 0;
  var peersDropDown = "Technicals";
  var peersDropDownItems = ["Technicals", "Fundamentals"];
  bool isCompareActive = false;
  var dropdownValue = "2021";
  var dropdownValueCashFlow = "2022";
  var dropdownValueBalanceSheet = "2021";
  var standAloneAndConsolidatedPLDropDownvalue = "Standalone";
  var standAloneAndConsolidatedBSDropDownvalue = "Standalone";
  var standAloneAndConsolidatedCSDropDownvalue = "Standalone";

  ScripInfoModel model1;
  ScripInfoModel model2;

  bool pnlExpanded = false;
  bool balanceSheetExpanded = false;
  bool cashFlowExpanded = false;
  List<int> pos = [-1, -1, -1, -1];
  bool addedToWatchlist = false;
  var dictionaryIndexValue;
  int researchCount = 0;
  bool _isNse = true;
  ScripInfoModel currentModelNew;
  bool modelFlipped = false, alternateModelRequested = false;

  var list = [
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
  ];
  var list2 = [
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
  ];
  var standAloneAndConsolidated = ["Standalone", "Consolidated"];

  var listCashFlowYear = ["2021", "2022"];
  Future<dynamic> _isEmpty;
  var retailAndOthers;
  var list3InitialItem = "Promoter Holding";
  var list3 = ["Promoter Holding", "Mutual Funds", "Domestic Institutions", "Foreign Institutions", "Retail & Others"];
  int flag = 0;
  ScripInfoModel model, currentModel;
  ScripInfoModel underlyingModel;
  List<ScripInfoModel> futures;
  List<int> optionDates;
  int touchedIndex = -1;
  var mode = 1;
  TabController _tabController;
  bool futuresFlag = false;
  int _currentIndex = 0, _exchTogglePosition = 0;
  StreamController<requestResponseState> getcmotcontroller = StreamController.broadcast();

  @override
  bool get wantKeepAlive => true;
  var tabTitle = ["Overview", "Futures", "Options", "Fundamentals", "Technicals", "Research", "Price Analysis", "Delivery", "News", "Events", "Peers"];

  var leftMarketKey = [
    "Open",
    "Close",
    "Volume",
    "Market Cap",
  ];

  var rightMarketKey = [
    "ATP",
    "VWAP",
    "Lower Cir.",
    "Upper Cir.",
  ];

  var leftMarketData = [];
  var rightMarketData = [];
  TextEditingController _qtyController, _priceController;
  FocusNode qtyFocus, priceFocus = FocusNode();

  void checkFutureOptions() {
    if (currentModel.exchCategory == ExchCategory.nseEquity || currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
      if (currentModel.exchCategory == ExchCategory.nseEquity)
        // underlyingModel = currentModel;
        underlyingModel = currentModel;
      else
        underlyingModel = CommonFunction.getScripDataModel(exch: currentModel.exch, exchCode: currentModel.ulToken);
      futures = Dataconstants.exchData[1].getFutureModels(underlyingModel);
      optionDates = Dataconstants.exchData[1].getDatesForOptions(underlyingModel);
    } else if (currentModel.exchCategory == ExchCategory.mcxFutures || currentModel.exchCategory == ExchCategory.mcxOptions) {
      if (currentModel.exchCategory == ExchCategory.mcxFutures)
        underlyingModel = currentModel;
      else {
        try {
          List<ScripInfoModel> list = Dataconstants.exchData[5].getFutureModelsForMcx(currentModel.ulToken);
          underlyingModel = list[0];
        } catch (e, s) {}
        // underlyingModel =
        //     CommonFunction.getScripDataModelForUnderlyingMcx(currentModel);
      }
      futures = Dataconstants.exchData[5].getFutureModelsForMcx(currentModel.ulToken);
      optionDates = Dataconstants.exchData[5].getDatesForOptionsMcx(currentModel.ulToken);
    } else {
      int exchPos;
      if (currentModel.exchCategory == ExchCategory.currenyFutures || currentModel.exchCategory == ExchCategory.currenyOptions)
        exchPos = 3;
      else
        exchPos = 4;
      if (currentModel.exchCategory == ExchCategory.currenyFutures || currentModel.exchCategory == ExchCategory.bseCurrenyFutures) {
        underlyingModel = currentModel;
      } else {
        try {
          List<ScripInfoModel> list = Dataconstants.exchData[exchPos].getFutureModelsForCurr(currentModel.ulToken);
          underlyingModel = list[0];
        } catch (e, s) {}
      }
      // underlyingModel = currentModel;
      // underlyingModel =
      //     CommonFunction.getScripDataModelForUnderlyingCurr(currentModel);
      futures = Dataconstants.exchData[exchPos].getFutureModelsForCurr(currentModel.ulToken);
      optionDates = Dataconstants.exchData[exchPos].getDatesForOptionsCurr(currentModel.ulToken);
    }
    if (widget.model.exchCategory == ExchCategory.nseEquity)
      _newsNseCode = widget.model.exchCode;
    else if (widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions)
      _newsNseCode = widget.model.ulToken;
    else if (widget.model.exchCategory == ExchCategory.bseEquity && widget.model.alternateModel != null)
      _newsNseCode = widget.model.alternateModel.exchCode;
    else if (widget.model.exchCategory == ExchCategory.mcxFutures) _newsNseCode = widget.model.exchCode;
    // //print("exchcode ->${_newsNseCode}");
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DateUtil.getAnyFormattedExchDate(1365173705, 'dd MMM yy hh:mm:ss');

    widget.model.exchCategory == ExchCategory.nseEquity
        ? dictionaryIndexValue = 0
        : widget.model.exchCategory == ExchCategory.bseEquity
            ? dictionaryIndexValue = 2
            : widget.model.exchCategory == ExchCategory.nseFuture
                ? dictionaryIndexValue = 1
                : (widget.model.exchCategory == ExchCategory.currenyOptions || widget.model.exchCategory == ExchCategory.currenyFutures)
                    ? dictionaryIndexValue = 3
                    : (widget.model.exchCategory == ExchCategory.bseCurrenyOptions || widget.model.exchCategory == ExchCategory.bseCurrenyFutures)
                        ? dictionaryIndexValue = 4
                        : (widget.model.exchCategory == ExchCategory.mcxOptions || widget.model.exchCategory == ExchCategory.mcxFutures)
                            ? dictionaryIndexValue = 5
                            : dictionaryIndexValue = 0;



    _qtyController = TextEditingController()
      ..addListener(() {
        setState(() {
          Dataconstants.scripInfoQty = _qtyController.text;
        });
      });
    _priceController = TextEditingController()
      ..addListener(() {
        setState(() {
          Dataconstants.scripInfoPrice = _priceController.text;
        });
      });

    Dataconstants.scripInfoProduct = widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity
        ? InAppSelection.productTypeEquity == ''
            ? 'CNC'
            : InAppSelection.productTypeEquity
        : InAppSelection.productTypeDerivative == ''
            ? 'NRML'
            : InAppSelection.productTypeDerivative;
    if (Dataconstants.scripInfoProduct == 'NRML')
      flag = 1;
    else if (Dataconstants.scripInfoProduct == 'CNC')
      flag = 2;
    else
      flag = 3;
    _isEmpty = apiCall();
    retailAndOthers = 0;
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(vsync: this, length: tabTitle.length);
    model = widget.model;
    if (model.isSpread == true) {
      desc = model.desc.toString().toUpperCase().split(" ");
      finalDesc = desc[1] + " " + desc[2] + " " + desc[4] + " " + desc[5];
    } else if (model.exchCategory == ExchCategory.nseFuture) {
      desc = model.desc.toString().toUpperCase().split(" ");
      finalDesc = desc[1] + " " + desc[2];
    } else if (model.exchCategory == ExchCategory.nseOptions) {
      desc = model.desc.toString().toUpperCase().split(" ");
      whichOption = desc[4];
      finalDesc = desc[1] + " " + desc[2] + " " + desc[5].toString().split(".").first;
    } else {
      finalDesc = model.exchName.toString().toUpperCase();
    }
    leftMarketData.add(model.open.toStringAsFixed(1));
    leftMarketData.add(model.close.toStringAsFixed(1));
    leftMarketData.add(model.prevDayCumVol.toStringAsFixed(1));
    leftMarketData.add(model.prevDayCumVol.toStringAsFixed(1));

    super.initState();
    _exchTogglePosition = widget.model.exch == 'N' ? 0 : 1;
    currentModel = widget.model;

    _isNse = currentModel.exch == "N" ? true : false;

    Dataconstants.swotController.getSwot(currentModel.name);

    //*********************** watchlist ********************************

    checkIfModelInWatchlist();
    Dataconstants.itsClient.getChartData(timeInterval: 5, chartPeriod: 'I', model: widget.model);
    if (widget.model.alternateModel != null) Dataconstants.itsClient.getChartData(timeInterval: 5, chartPeriod: 'I', model: widget.model.alternateModel);
    if (currentModel.alternateModel == null && (currentModel.exchCategory == ExchCategory.nseEquity || currentModel.exchCategory == ExchCategory.bseEquity)) {
      ScripInfoModel alternateModel = CommonFunction.getBseNseMapModel(currentModel.name, currentModel.exchCategory);
      if (alternateModel != null) currentModel.addAlternateModel(alternateModel);
    }
    checkFutureOptions();
    isIndices = CommonFunction.isIndicesScrip(widget.model.exch, widget.model.exchCode);
  }

  void checkIfModelInWatchlist() {
    //DataConstants.marketWatchListeners[widget.watchlistNo].watchList.length
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == currentModel.exch && element.exchCode == currentModel.exchCode);
    }
    addedToWatchlist = pos.any((element) => element > -1);
  }

  apiCall() async {
    await Dataconstants.cashFlowController.getCashFlow(widget.model.exchCode.toString());

    await Dataconstants.pnlController.getProfitAndLoss(widget.model.exchCode.toString());

    await Dataconstants.balanceSheetController.getBalanceSheet(widget.model.exchCode.toString());

    await Dataconstants.shareHoldingController.getShareHoldings(widget.model.exchCode.toString());

    if (CashFlowController.getCashFlowListItems.isEmpty ||
        ProfitAndLossController.getProfitAndLossDetailsListItems.isEmpty ||
        BalanceSheetController.getBalanceSheetDetailsListItems.isEmpty ||
        ShareHoldingController.getShareHoldingDetailsListItems.isEmpty) {
      return false;
    } else if (CashFlowController.getCashFlowListItems.isNotEmpty ||
        ProfitAndLossController.getProfitAndLossDetailsListItems.isNotEmpty ||
        BalanceSheetController.getBalanceSheetDetailsListItems.isNotEmpty ||
        ShareHoldingController.getShareHoldingDetailsListItems.isNotEmpty) {
      return true;
    }
  }

  void orderNavigate(bool isSellButton) {
    Dataconstants.limitController.getLimitsData();
    try {
      if (currentModel.exchCategory == ExchCategory.nseEquity || currentModel.exchCategory == ExchCategory.bseEquity)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OrderPlacementScreen(
                // model: currentModelNew,
                model: currentModel,
                // currentModelNew to be used only for equity nse/bse toggle
                orderType: ScripDetailType.none,
                isBuy: !isSellButton,
                selectedExch: _isNse ? "N" : "B",
                stream: Dataconstants.pageController.stream,
              );
            },
          ),
        );
      else
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OrderPlacementScreen(
                model: currentModel,
                // currentModelNew to be used only for equity
                orderType: ScripDetailType.none,
                isBuy: !isSellButton,
                selectedExch: _exchTogglePosition == 0 ? "N" : "B",
                stream: Dataconstants.pageController.stream,
              );
            },
          ),
        );
    } catch (e) {
      //print(e);
    }
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
        }
        break;
      case AppLifecycleState.inactive:
        {}
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      //   //print("app in detached");
      //   break;
    }
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
    var width = MediaQuery.of(context).size.width - 135;
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
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              low.toStringAsFixed(widget.model.precision),
              style: TextStyle(fontSize: 14),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              high.toStringAsFixed(widget.model.precision),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // Widget infoSliderWidget({
  //   @required BuildContext context,
  //   String title,
  //   double low,
  //   double high,
  //   double value,
  //   Color lowColor,
  //   Color highColor,
  // }) {
  //   var width = MediaQuery.of(context).size.width;
  //   var percentSlider = ((value - low)) / (high - low);
  //   if (percentSlider.isInfinite || percentSlider.isNaN){
  //     percentSlider = width;
  //   }
  //   return Column(
  //     children: [
  //       Container(
  //         height: 25,
  //         alignment: Alignment.center,
  //         child: Stack(
  //           clipBehavior: Clip.none,
  //           children: [
  //             Container(
  //               height: 10,
  //               width: width,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(colors: [lowColor, highColor]),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             AnimatedPositioned(
  //               left: percentSlider * width ,//(percentSlider * width) - 200,
  //               bottom: 1,
  //               duration: Duration(milliseconds: 300),
  //               child: Icon(
  //                 Icons.place,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 5,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(low.toStringAsFixed(widget.model.precision),
  //               style: Utils.fonts(
  //                 size: 12.0,
  //                 fontWeight: FontWeight.w200,
  //               )),
  //           Text(title,
  //               style: Utils.fonts(
  //                 size: 12.0,
  //                 fontWeight: FontWeight.w200,
  //               )),
  //           Text(
  //             high.toStringAsFixed(
  //               widget.model.precision,
  //             ),
  //             style: Utils.fonts(
  //               size: 12.0,
  //               fontWeight: FontWeight.w200,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM yy hh:mm:ss');
    final String formatted = formatter.format(now);
    return _isEmpty == true
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            // appBar: AppBar(
            //   leading: InkWell(
            //     onTap: () {
            //       Navigator.pop(context);
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 8.0),
            //       child: Icon(
            //         Icons.arrow_back_ios,
            //         size: 20.0,
            //       ),
            //     ),
            //   ),
            //   title: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //             child: AutoSizeText(
            //               model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity ? model.name : model.desc,
            //               maxLines: 1,
            //               style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
            //             ),
            //           ),
            //           SizedBox(width: 10),
            //           Container(
            //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor.withOpacity(0.4)),
            //             child: Padding(
            //               padding: const EdgeInsets.all(4.0),
            //               child: Text(
            //                 "${model.exchCategory == ExchCategory.mcxFutures || model.exchCategory == ExchCategory.mcxOptions ? 'MCX' : model.exchCategory == ExchCategory.bseEquity || model.exchCategory == ExchCategory.bseCurrenyFutures || model.exchCategory == ExchCategory.bseCurrenyOptions ? 'BSE' : 'NSE'}",
            //                 style: Utils.fonts(color: Colors.white),
            //               ),
            //             ),
            //           ),
            //           Icon(
            //             Icons.notifications_active_outlined,
            //             color: Utils.primaryColor,
            //           ),
            //           SizedBox(
            //             width: 5,
            //           ),
            //           InkWell(
            //             onTap: () {
            //               if (!addedToWatchlist)
            //                 showDialog<void>(
            //                   context: context,
            //                   barrierDismissible: false,
            //                   // user must tap button!
            //                   builder: (BuildContext context) {
            //                     return StatefulBuilder(
            //                       builder: (context, setState) => AlertDialog(
            //                         title: const Text('Select Watchlist'),
            //                         content: SingleChildScrollView(
            //                             child: Column(
            //                               children: [
            //                                 Row(
            //                                   children: [
            //                                     InkWell(
            //                                       onTap: () {
            //                                         setState(() {
            //                                           watchCount = 0;
            //                                         });
            //                                       },
            //                                       child: Container(
            //                                         height: 10,
            //                                         width: 10,
            //                                         decoration: BoxDecoration(
            //                                             color: watchCount == 0 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       width: 10,
            //                                     ),
            //                                     Text(InAppSelection.tabsView[0][0].toString())
            //                                   ],
            //                                 ),
            //                                 Row(
            //                                   children: [
            //                                     InkWell(
            //                                       onTap: () {
            //                                         setState(() {
            //                                           watchCount = 1;
            //                                         });
            //                                       },
            //                                       child: Container(
            //                                         height: 10,
            //                                         width: 10,
            //                                         decoration: BoxDecoration(
            //                                             color: watchCount == 1 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       width: 10,
            //                                     ),
            //                                     Text(InAppSelection.tabsView[1][0].toString())
            //                                   ],
            //                                 ),
            //                                 Row(
            //                                   children: [
            //                                     InkWell(
            //                                       onTap: () {
            //                                         setState(() {
            //                                           watchCount = 2;
            //                                         });
            //                                       },
            //                                       child: Container(
            //                                         height: 10,
            //                                         width: 10,
            //                                         decoration: BoxDecoration(
            //                                             color: watchCount == 2 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       width: 10,
            //                                     ),
            //                                     Text(InAppSelection.tabsView[2][0].toString())
            //                                   ],
            //                                 ),
            //                                 Row(
            //                                   children: [
            //                                     InkWell(
            //                                       onTap: () {
            //                                         setState(() {
            //                                           watchCount = 3;
            //                                         });
            //                                       },
            //                                       child: Container(
            //                                         height: 10,
            //                                         width: 10,
            //                                         decoration: BoxDecoration(
            //                                             color: watchCount == 3 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       width: 10,
            //                                     ),
            //                                     Text(InAppSelection.tabsView[3][0].toString())
            //                                   ],
            //                                 ),
            //                               ],
            //                             )),
            //                         actions: <Widget>[
            //                           TextButton(
            //                             child: const Text('Add'),
            //                             onPressed: () {
            //                               // DataConstants.marketWatchListeners[]
            //                               //     .addToWatchList(widget.model);
            //                               Navigator.of(context).pop();
            //                             },
            //                           ),
            //                         ],
            //                       ),
            //                     );
            //                   },
            //                 );
            //               if (addedToWatchlist) {
            //                 var currentWatchlistLength = Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
            //
            //                 Dataconstants.marketWatchListeners[widget.watchListId].watchList.removeAt(widget.watchlistIndex);
            //
            //                 var newWatchListLength = Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
            //
            //                 Dataconstants.marketWatchListeners[widget.watchListId].updateWatchList(Dataconstants.marketWatchListeners[widget.watchListId].watchList);
            //                 if (currentWatchlistLength > newWatchListLength) {
            //                   setState(() {
            //                     addedToWatchlist = false;
            //                   });
            //                 }
            //               }
            //             },
            //             child: Icon(
            //               addedToWatchlist ? Icons.bookmark : Icons.bookmark_outline_outlined,
            //               color: Utils.primaryColor,
            //             ),
            //           ),
            //         ],
            //       ),
            //       Observer(builder: (context) {
            //         return Row(children: [
            //           Text(
            //             model.close == 0.00 ? model.prevDayClose.toStringAsFixed(model.series == 'Curr' ? 4 : 2) : model.close.toStringAsFixed(model.series == 'Curr' ? 4 : 2),
            //             style: Utils.fonts(
            //               size: 17.0,
            //               fontWeight: FontWeight.w600,
            //               color: Utils.blackColor,
            //             ),
            //           ),
            //           Container(
            //             margin: EdgeInsets.zero,
            //             padding: EdgeInsets.zero,
            //             child: IconButton(
            //               constraints: BoxConstraints(),
            //               padding: const EdgeInsets.all(0),
            //               icon: Icon(
            //                 model.close > model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
            //                 size: 30,
            //               ),
            //               color: model.close > model.prevTickRate ? ThemeConstants.buyColor : ThemeConstants.sellColor,
            //             ),
            //           ),
            //           Text(
            //             /* If the LTP is zero before or after market time, it is showing zero instead of price change */
            //               model.close == 0.00 ? "0.00" : model.priceChangeText,
            //               style: Utils.fonts(
            //                 size: 12.0,
            //                 fontWeight: FontWeight.w600,
            //                 color: model.priceChange > 0
            //                     ? ThemeConstants.buyColor
            //                     : model.priceChange < 0
            //                     ? ThemeConstants.sellColor
            //                     : theme.textTheme.bodyText1.color,
            //               )),
            //           SizedBox(
            //             width: 5,
            //           ),
            //           Text(model.close == 0.00 ? "(0.00%)" : model.percentChangeText,
            //               style: Utils.fonts(
            //                 size: 12.0,
            //                 fontWeight: FontWeight.w600,
            //                 color: model.percentChange > 0
            //                     ? ThemeConstants.buyColor
            //                     : model.percentChange < 0
            //                     ? ThemeConstants.sellColor
            //                     : theme.textTheme.bodyText1.color,
            //               )),
            //         ]);
            //       }),
            //       Text(
            //         Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesOpen ? "Open, $formatted" : "Closed, $formatted",
            //         style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
            //       ),
            //       SizedBox(
            //         height: 5,
            //       ),
            //     ],
            //   ),
            //   bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(50),
            //     child: TabBar(
            //       isScrollable: true,
            //       labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
            //       unselectedLabelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
            //       unselectedLabelColor: Colors.grey[600],
            //       labelColor: Utils.primaryColor,
            //       indicatorPadding: EdgeInsets.zero,
            //       labelPadding: EdgeInsets.symmetric(horizontal: 20),
            //       indicatorSize: TabBarIndicatorSize.tab,
            //       indicatorWeight: 0,
            //       indicator: BubbleTabIndicator(
            //         indicatorHeight: 40.0,
            //         insets: EdgeInsets.symmetric(horizontal: 2),
            //         indicatorColor: Utils.primaryColor.withOpacity(0.3),
            //         tabBarIndicatorSize: TabBarIndicatorSize.tab,
            //       ),
            //       controller: _tabController,
            //       physics: CustomTabBarScrollPhysics(),
            //       onTap: (_index) {
            //         setState(() {
            //           _currentIndex = _index;
            //         });
            //       },
            //       tabs: [
            //         for (var i = 0; i < tabTitle.length; i++)
            //           Tab(
            //             child: Text(
            //               tabTitle[i].toString(),
            //               style: Utils.fonts(
            //                 size: _currentIndex == i ? 13.0 : 12.0,
            //               ),
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),
            // ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity ? model.name : model.desc,
                            maxLines: 1,
                            style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        // SizedBox(width: 10),
                        // Container(
                        //   padding: const EdgeInsets.all(4),
                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor.withOpacity(0.4)),
                        //   child: Text(
                        //     "${model.exchCategory == ExchCategory.mcxFutures || model.exchCategory == ExchCategory.mcxOptions ? 'MCX' : model.exchCategory == ExchCategory.bseEquity || model.exchCategory == ExchCategory.bseCurrenyFutures || model.exchCategory == ExchCategory.bseCurrenyOptions ? 'BSE' : 'NSE'}",
                        //     style: Utils.fonts(color: Colors.white),
                        //   ),
                        // ),
                        Icon(
                          Icons.notifications_active_outlined,
                          color: Utils.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            //Bhavesh
                            var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) => WatchListPickerCard(currentModel),
                            );
                            //Bhavesh
                            // if (!addedToWatchlist)
                            //   showDialog<void>(
                            //     context: context,
                            //     barrierDismissible: false,
                            //     // user must tap button!
                            //     builder: (BuildContext context) {
                            //       return StatefulBuilder(
                            //         builder: (context, setState) => AlertDialog(
                            //           title: const Text('Select Watchlist'),
                            //           content: SingleChildScrollView(
                            //               child: Padding(
                            //             padding: const EdgeInsets.only(left: 20),
                            //             child: Column(
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               children: [
                            //                 // SizedBox(height: 15,),
                            //
                            //                 Row(
                            //                   children: [
                            //                     InkWell(
                            //                       onTap: () {
                            //                         setState(() {
                            //                           if (InAppSelection.tabsView[0][1] == "predefined") {
                            //                             CommonFunction.showBasicToast("cannot add in predefined watchlist");
                            //                           } else {
                            //                             watchCount = 0;
                            //                           }
                            //                         });
                            //                       },
                            //                       child: Container(
                            //                         height: 12,
                            //                         width: 12,
                            //                         decoration: BoxDecoration(
                            //                             color: watchCount == 0 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
                            //                       ),
                            //                     ),
                            //                     SizedBox(
                            //                       width: 12,
                            //                     ),
                            //                     Text(InAppSelection.tabsView[0][0].toString())
                            //                   ],
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(top: 30, bottom: 30),
                            //                   child: Row(
                            //                     children: [
                            //                       InkWell(
                            //                         onTap: () {
                            //                           setState(() {
                            //                             if (InAppSelection.tabsView[1][1] == "predefined") {
                            //                               CommonFunction.showBasicToast("cannot add in predefined watchlist");
                            //                             } else {
                            //                               watchCount = 1;
                            //                             }
                            //                           });
                            //
                            //                           // setState(() {
                            //                           //   watchCount = 1;
                            //                           // });
                            //                         },
                            //                         child: Container(
                            //                           height: 12,
                            //                           width: 12,
                            //                           decoration: BoxDecoration(
                            //                               color: watchCount == 1 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
                            //                         ),
                            //                       ),
                            //                       SizedBox(
                            //                         width: 12,
                            //                       ),
                            //                       Text(InAppSelection.tabsView[1][0].toString())
                            //                     ],
                            //                   ),
                            //                 ),
                            //                 Row(
                            //                   children: [
                            //                     InkWell(
                            //                       onTap: () {
                            //                         setState(() {
                            //                           if (InAppSelection.tabsView[2][1] == "predefined") {
                            //                             CommonFunction.showBasicToast("cannot add in predefined watchlist");
                            //                           } else {
                            //                             watchCount = 2;
                            //                           }
                            //                         });
                            //                         // setState(() {
                            //                         //   watchCount = 2;
                            //                         // });
                            //                       },
                            //                       child: Container(
                            //                         height: 12,
                            //                         width: 12,
                            //                         decoration: BoxDecoration(
                            //                             color: watchCount == 2 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
                            //                       ),
                            //                     ),
                            //                     SizedBox(
                            //                       width: 12,
                            //                     ),
                            //                     Text(InAppSelection.tabsView[2][0].toString())
                            //                   ],
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(
                            //                     top: 30,
                            //                   ),
                            //                   child: Row(
                            //                     children: [
                            //                       InkWell(
                            //                         onTap: () {
                            //                           setState(() {
                            //                             if (InAppSelection.tabsView[3][1] == "predefined") {
                            //                               CommonFunction.showBasicToast("cannot add in predefined watchlist");
                            //                             } else {
                            //                               watchCount = 3;
                            //                             }
                            //                           });
                            //                           // setState(() {
                            //                           //   watchCount = 3;
                            //                           // });
                            //                         },
                            //                         child: Container(
                            //                           height: 12,
                            //                           width: 12,
                            //                           decoration: BoxDecoration(
                            //                               color: watchCount == 3 ? Utils.blackColor : Utils.whiteColor, border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(15))),
                            //                         ),
                            //                       ),
                            //                       SizedBox(
                            //                         width: 12,
                            //                       ),
                            //                       Text(InAppSelection.tabsView[3][0].toString())
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           )),
                            //           actions: <Widget>[
                            //             TextButton(
                            //               child: Text(
                            //                 'Add',
                            //                 style: TextStyle(color: Utils.primaryColor),
                            //               ),
                            //               onPressed: () {
                            //                 //print(widget.watchListId);
                            //                 setState(() {
                            //                   Dataconstants.marketWatchListeners[widget.watchListId].addToWatchList(widget.model);
                            //                   addedToWatchlist = true;
                            //                 });
                            //                 Navigator.of(context).pop();
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ).then((value) {
                            //     setState(() {});
                            //   });
                            //
                            //
                            // if (addedToWatchlist) {
                            //   var currentWatchlistLength = Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
                            //
                            //   Dataconstants.marketWatchListeners[widget.watchListId].watchList.removeAt(widget.watchlistIndex);
                            //
                            //   var newWatchListLength = Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
                            //
                            //   Dataconstants.marketWatchListeners[widget.watchListId].updateWatchList(Dataconstants.marketWatchListeners[widget.watchListId].watchList);
                            //   if (currentWatchlistLength > newWatchListLength) {
                            //     setState(() {
                            //       addedToWatchlist = false;
                            //     });
                            //   }
                            // }
                          },
                          child: Icon(
                            addedToWatchlist ? Icons.bookmark : Icons.bookmark_outline_outlined,
                            color: Utils.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Observer(builder: (context) {
                        return Row(children: [
                          // model.exchCategory == ExchCategory.bseEquity ||
                          //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                          //         model.exchCategory == ExchCategory.bseCurrenyOptions ||
                          //         model.exchCategory == ExchCategory.nseEquity
                          //     ? SizedBox.shrink()
                          //     : Container(
                          //         padding: const EdgeInsets.all(4),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(5),
                          //             color:
                          //                 model.exchCategory == ExchCategory.bseEquity || model.exchCategory == ExchCategory.bseCurrenyFutures || model.exchCategory == ExchCategory.bseCurrenyOptions
                          //                     ? Utils.greyColor.withOpacity(0.4)
                          //                     : Utils.primaryColor.withOpacity(0.4)),
                          //         child: Text(
                          //           "${model.exchCategory == ExchCategory.mcxFutures || model.exchCategory == ExchCategory.mcxOptions ? 'MCX' : model.exchCategory == ExchCategory.bseEquity || model.exchCategory == ExchCategory.bseCurrenyFutures || model.exchCategory == ExchCategory.bseCurrenyOptions ? 'BSE' : 'NSE'}",
                          //           style: Utils.fonts(color: Colors.white),
                          //         ),
                          //       ),

                          // model.exchCategory == ExchCategory.bseEquity ||
                          //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                          //         model.exchCategory == ExchCategory.bseCurrenyOptions ||
                          //         model.exchCategory == ExchCategory.nseEquity
                          //     ? Row(children: [
                          //         InkWell(
                          //           onTap: _isNse == false
                          //               ? () {
                          //                   setState(() {
                          //                     _isNse = true;
                          //                     _exchTogglePosition = model.exch == "B" ? 1 : 0;
                          //                     if (model.alternateModel != null) model = model.alternateModel;
                          //                   });
                          //                   Dataconstants.iqsClient.sendMarketDepthRequest(model.exch,model.exchCode,true);
                          //                 }
                          //               : null,
                          //           child: Container(
                          //             padding: const EdgeInsets.all(4),
                          //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color:
                          //             _isNse ? Utils.primaryColor.withOpacity(0.7) : Utils.greyColor.withOpacity(0.7)),
                          //             child: Text(
                          //               "NSE",
                          //               style: Utils.fonts(color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //         SizedBox(width: 5),
                          //         model.exchCategory == ExchCategory.bseCurrenyFutures || model.alternateModel == null
                          //             ? SizedBox.shrink()
                          //             : InkWell(
                          //                 onTap: _isNse
                          //                     ? () {
                          //                         setState(() {
                          //                           _isNse = false;
                          //                           _exchTogglePosition = model.exch == "B" ? 1 : 0;
                          //                           model = model.alternateModel;
                          //                         });Dataconstants.iqsClient.sendMarketDepthRequest(model.exch,model.exchCode,true);
                          //                       }
                          //                     : null,
                          //                 child: Container(
                          //                   padding: const EdgeInsets.all(4),
                          //                   decoration: BoxDecoration(
                          //                       borderRadius: BorderRadius.circular(5),
                          //                       // color: model.exchCategory == ExchCategory.bseEquity ||
                          //                       //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                          //                       //         model.exchCategory == ExchCategory.bseCurrenyOptions
                          //                       //     ? Utils.primaryColor.withOpacity(0.4)
                          //                       //     : Utils.greyColor.withOpacity(0.4)),
                          //                       color: _isNse == false ? Utils.primaryColor.withOpacity(0.7) : Utils.greyColor.withOpacity(0.7)),
                          //                   child: Text(
                          //                     "BSE",
                          //                     style: Utils.fonts(color: Colors.white),
                          //                   ),
                          //                 ),
                          //               ),
                          //       ])
                          //     : SizedBox.shrink(),

                          widget.isFromDashboard
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: model.exchCategory == ExchCategory.bseEquity ||
                                      //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                      //         model.exchCategory == ExchCategory.bseCurrenyOptions
                                      //     ? Utils.primaryColor.withOpacity(0.4)
                                      //     : Utils.greyColor.withOpacity(0.4)),
                                      color: widget.isFromDashboard
                                          ? Utils.greyColor.withOpacity(0.7)
                                          : widget.model.exch == "M" || widget.model.exch == "C"
                                              ? Utils.primaryColor.withOpacity(0.7)
                                              : _isNse
                                                  ? Utils.primaryColor.withOpacity(0.7)
                                                  : Utils.greyColor.withOpacity(0.7)),
                                  child: Text(
                                    widget.model.exch == "B" ? "BSE" : "NSE",
                                    style: Utils.fonts(color: Colors.white),
                                  ),
                                )
                              : Observer(builder: (context) {
                                  return Row(children: [
                                    InkWell(
                                      onTap: widget.model.exch == "M" || widget.model.exch == "C"
                                          ? null
                                          : () {
                                              setState(() {
                                                _isNse = true;
                                                if (widget.model.exch == "N") {
                                                  model = widget.model;
                                                  currentModel = model;
                                                } else if (widget.model.alternateModel.exch == "N") {
                                                  model = widget.model.alternateModel;
                                                  currentModel = model;
                                                }

                                                Dataconstants.iqsClient.sendLTPRequest(
                                                  model,
                                                  true,
                                                );

                                                Dataconstants.iqsClient.sendMarketDepthRequest(model.exch, model.exchCode, true);

                                                checkFutureOptions();
                                              });
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            // color: model.exchCategory == ExchCategory.bseEquity ||
                                            //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                            //         model.exchCategory == ExchCategory.bseCurrenyOptions
                                            //     ? Utils.primaryColor.withOpacity(0.4)
                                            //     : Utils.greyColor.withOpacity(0.4)),
                                            color: widget.model.exch == "M" || widget.model.exch == "C"
                                                ? Utils.primaryColor.withOpacity(0.7)
                                                : _isNse
                                                    ? Utils.primaryColor.withOpacity(0.7)
                                                    : Utils.greyColor.withOpacity(0.7)),
                                        child: Text(
                                          widget.model.exch == "M"
                                              ? "MCX"
                                              : widget.model.exch == "C"
                                                  ? "CURR"
                                                  : "NSE",
                                          style: Utils.fonts(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    widget.model.alternateModel != null
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isNse = false;
                                                model = widget.model.alternateModel;
                                                if (widget.model.exch == "B") {
                                                  model = widget.model;
                                                  currentModel = widget.model;
                                                } else if (widget.model.alternateModel.exch == "B") {
                                                  model = widget.model.alternateModel;
                                                  currentModel = widget.model.alternateModel;
                                                }
                                                Dataconstants.iqsClient.sendLTPRequest(
                                                  model,
                                                  true,
                                                );

                                                Dataconstants.iqsClient.sendMarketDepthRequest(model.exch, model.exchCode, true);

                                                checkFutureOptions();
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  // color: model.exchCategory == ExchCategory.bseEquity ||
                                                  //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                                  //         model.exchCategory == ExchCategory.bseCurrenyOptions
                                                  //     ? Utils.primaryColor.withOpacity(0.4)
                                                  //     : Utils.greyColor.withOpacity(0.4)),
                                                  color: _isNse == false ? Utils.primaryColor.withOpacity(0.7) : Utils.greyColor.withOpacity(0.7)),
                                              child: Text(
                                                "BSE",
                                                style: Utils.fonts(color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ]);
                                }),

                          SizedBox(width: 10),
                          Text(
                            model.close == 0.00 ? model.prevDayClose.toStringAsFixed(model.series == 'Curr' ? 4 : 2) : model.close.toStringAsFixed(model.series == 'Curr' ? 4 : 2),
                            style: Utils.fonts(
                              size: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Utils.blackColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: IconButton(
                              constraints: BoxConstraints(),
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                model.close > model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                size: 30,
                              ),
                              color: model.close > model.prevTickRate ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                            ),
                          ),
                          Text(
                              /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                              model.close == 0.00 ? "0.00" : model.priceChangeText,
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                                color: model.priceChange > 0
                                    ? ThemeConstants.buyColor
                                    : model.priceChange < 0
                                        ? ThemeConstants.sellColor
                                        : theme.textTheme.bodyText1.color,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(model.close == 0.00 ? "(0.00%)" : model.percentChangeText,
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                                color: model.percentChange > 0
                                    ? ThemeConstants.buyColor
                                    : model.percentChange < 0
                                        ? ThemeConstants.sellColor
                                        : theme.textTheme.bodyText1.color,
                              )),
                        ]);
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(
                        // Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesOpen ? "Open, $formatted" : "Closed, $formatted",
                        Dataconstants.exchData[dictionaryIndexValue].exchangeStatus == ExchangeStatus.nesOpen
                            ? "Open, ${DateUtil.getAnyFormattedExchDate(widget.model.lastTradeTime, 'dd MMM yy hh:mm:ss')}"
                            : "Closed, ${DateUtil.getAnyFormattedExchDate(widget.model.lastTradeTime, 'dd MMM yy hh:mm:ss')}",
                        // Dataconstants.exchData[dictionaryIndexValue].exchangeStatus == ExchangeStatus.nesOpen
                        //     ? "Open, ${DateUtil.getAnyFormattedExchDate(widget.model.lastTradeTime, 'dd MMM yy hh:mm:ss')}"
                        //     : "Closed, ${DateUtil.getAnyFormattedExchDate(widget.model.lastTradeTime, 'dd MMM yy hh:mm:ss')}",
                        style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     ]
                    //       onTap: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(top: 8.0),
                    //         child: Icon(
                    //           Icons.arrow_back_ios,
                    //           size: 20.0,
                    //         ),
                    //       ),
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 AutoSizeText(
                    //                   model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity ? model.name : model.desc,
                    //                   style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                    //                 ),
                    //                 // (model.exchCategory == ExchCategory.currenyFutures ||
                    //                 //         model.exchCategory == ExchCategory.currenyOptions ||
                    //                 //         model.exchCategory == ExchCategory.bseCurrenyOptions ||
                    //                 //         model.exchCategory == ExchCategory.bseCurrenyFutures ||
                    //                 //         model.exchCategory == ExchCategory.mcxOptions ||
                    //                 //         model.exchCategory == ExchCategory.mcxFutures)
                    //                 //     ? Text(
                    //                 //         " Fut",
                    //                 //         style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                    //                 //       )
                    //                 //     : SizedBox.shrink(),
                    //                 // model.exchCategory == ExchCategory.nseOptions
                    //                 //     ? Text(
                    //                 //         " 2600 PE",
                    //                 //         style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                    //                 //       )
                    //                 //     : SizedBox.shrink(),
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(width: 10),
                    //                     Container(
                    //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor.withOpacity(0.4)),
                    //                       child: Padding(
                    //                         padding: const EdgeInsets.all(4.0),
                    //                         child: Text(
                    //                           "${model.exchCategory == ExchCategory.nseEquity ? 'NSE' : model.exchCategory == ExchCategory.bseEquity ? 'BSE' : model.expiryDateString}",
                    //                           style: Utils.fonts(color: Colors.white),
                    //                         ),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   width: 10,
                    //                 ),
                    //                 RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.greyColor))
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Icon(
                    //                   Icons.notifications_active_outlined,
                    //                   color: Utils.primaryColor,
                    //                 ),
                    //                 SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () {
                    //                     if(!addedToWatchlist)
                    //                       showDialog<void>(
                    //                         context: context,
                    //                         barrierDismissible: false,
                    //                         // user must tap button!
                    //                         builder: (BuildContext context) {
                    //                           return StatefulBuilder(
                    //                             builder: (context, setState) => AlertDialog(
                    //                               title: const Text('Select Watchlist'),
                    //                               content: SingleChildScrollView(
                    //                                   child: Column(
                    //                                     children: [
                    //                                       Row(
                    //                                         children: [
                    //                                           InkWell(
                    //                                             onTap: () {
                    //                                               setState(() {
                    //                                                 watchCount = 0;
                    //                                               });
                    //                                             },
                    //                                             child: Container(
                    //                                               height: 10,
                    //                                               width: 10,
                    //                                               decoration: BoxDecoration(
                    //                                                   color: watchCount == 0 ? Utils.blackColor : Utils.whiteColor,
                    //                                                   border: Border.all(),
                    //                                                   borderRadius: BorderRadius.all(Radius.circular(15))),
                    //                                             ),
                    //                                           ),
                    //                                           SizedBox(
                    //                                             width: 10,
                    //                                           ),
                    //                                           Text(InAppSelection.tabsView[0][0].toString())
                    //                                         ],
                    //                                       ),
                    //                                       Row(
                    //                                         children: [
                    //                                           InkWell(
                    //                                             onTap: () {
                    //                                               setState(() {
                    //                                                 watchCount = 1;
                    //                                               });
                    //                                             },
                    //                                             child: Container(
                    //                                               height: 10,
                    //                                               width: 10,
                    //                                               decoration: BoxDecoration(
                    //                                                   color: watchCount == 1 ? Utils.blackColor : Utils.whiteColor,
                    //                                                   border: Border.all(),
                    //                                                   borderRadius: BorderRadius.all(Radius.circular(15))),
                    //                                             ),
                    //                                           ),
                    //                                           SizedBox(
                    //                                             width: 10,
                    //                                           ),
                    //                                           Text(InAppSelection.tabsView[1][0].toString())
                    //                                         ],
                    //                                       ),
                    //                                       Row(
                    //                                         children: [
                    //                                           InkWell(
                    //                                             onTap: () {
                    //                                               setState(() {
                    //                                                 watchCount = 2;
                    //                                               });
                    //                                             },
                    //                                             child: Container(
                    //                                               height: 10,
                    //                                               width: 10,
                    //                                               decoration: BoxDecoration(
                    //                                                   color: watchCount == 2 ? Utils.blackColor : Utils.whiteColor,
                    //                                                   border: Border.all(),
                    //                                                   borderRadius: BorderRadius.all(Radius.circular(15))),
                    //                                             ),
                    //                                           ),
                    //                                           SizedBox(
                    //                                             width: 10,
                    //                                           ),
                    //                                           Text(InAppSelection.tabsView[2][0].toString())
                    //                                         ],
                    //                                       ),
                    //                                       Row(
                    //                                         children: [
                    //                                           InkWell(
                    //                                             onTap: () {
                    //                                               setState(() {
                    //                                                 watchCount = 3;
                    //                                               });
                    //                                             },
                    //                                             child: Container(
                    //                                               height: 10,
                    //                                               width: 10,
                    //                                               decoration: BoxDecoration(
                    //                                                   color: watchCount == 3 ? Utils.blackColor : Utils.whiteColor,
                    //                                                   border: Border.all(),
                    //                                                   borderRadius: BorderRadius.all(Radius.circular(15))),
                    //                                             ),
                    //                                           ),
                    //                                           SizedBox(
                    //                                             width: 10,
                    //                                           ),
                    //                                           Text(InAppSelection.tabsView[3][0].toString())
                    //                                         ],
                    //                                       ),
                    //                                     ],
                    //                                   )),
                    //                               actions: <Widget>[
                    //                                 TextButton(
                    //                                   child: const Text('Add'),
                    //                                   onPressed: () {
                    //                                     // DataConstants.marketWatchListeners[]
                    //                                     //     .addToWatchList(widget.model);
                    //                                     Navigator.of(context).pop();
                    //                                   },
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           );
                    //                         },
                    //                       );
                    //                     if(addedToWatchlist){
                    //                       var currentWatchlistLength=Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
                    //
                    //                       Dataconstants.marketWatchListeners[widget.watchListId].watchList.removeAt(widget.watchlistIndex);
                    //
                    //                       var newWatchListLength=Dataconstants.marketWatchListeners[widget.watchListId].watchList.length;
                    //
                    //                       Dataconstants.marketWatchListeners[widget.watchListId].updateWatchList(Dataconstants.marketWatchListeners[widget.watchListId].watchList);
                    //                       if(currentWatchlistLength>newWatchListLength){
                    //                         setState(() {
                    //                           addedToWatchlist=false;
                    //                         });
                    //                       }}},
                    //                   child: Icon(
                    //                     addedToWatchlist?Icons.bookmark:  Icons.bookmark_outline_outlined,
                    //                     color: Utils.primaryColor,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         Observer(builder: (context) {
                    //           return Row(children: [
                    //             Text(
                    //               model.close == 0.00 ? model.prevDayClose.toStringAsFixed(model.series == 'Curr' ? 4 : 2) : model.close.toStringAsFixed(model.series == 'Curr' ? 4 : 2),
                    //               style: Utils.fonts(
                    //                 size: 17.0,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: Utils.blackColor,
                    //               ),
                    //             ),
                    //             Container(
                    //               margin: EdgeInsets.zero,
                    //               padding: EdgeInsets.zero,
                    //               child: IconButton(
                    //                 constraints: BoxConstraints(),
                    //                 padding: const EdgeInsets.all(0),
                    //                 icon: Icon(
                    //                   model.close > model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    //                   size: 30,
                    //                 ),
                    //                 color: model.close > model.prevTickRate ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                    //               ),
                    //             ),
                    //             Text(
                    //                 /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                    //                 model.close == 0.00 ? "0.00" : model.priceChangeText,
                    //                 style: Utils.fonts(
                    //                   size: 12.0,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: model.priceChange > 0
                    //                       ? ThemeConstants.buyColor
                    //                       : model.priceChange < 0
                    //                           ? ThemeConstants.sellColor
                    //                           : theme.textTheme.bodyText1.color,
                    //                 )),
                    //             SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text(model.close == 0.00 ? "(0.00%)" : model.percentChangeText,
                    //                 style: Utils.fonts(
                    //                   size: 12.0,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: model.percentChange > 0
                    //                       ? ThemeConstants.buyColor
                    //                       : model.percentChange < 0
                    //                           ? ThemeConstants.sellColor
                    //                           : theme.textTheme.bodyText1.color,
                    //                 )),
                    //           ]);
                    //         }),
                    //         Text(
                    //           Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesOpen ? "Open, $formatted" : "Closed, $formatted",
                    //           style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                    //         ),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    TabBar(
                      isScrollable: true,
                      labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                      unselectedLabelColor: Colors.grey[600],
                      labelColor: Utils.primaryColor,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.symmetric(horizontal: 20),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 0,
                      indicator: BubbleTabIndicator(
                        indicatorHeight: 40.0,
                        insets: EdgeInsets.symmetric(horizontal: 2),
                        indicatorColor: Utils.primaryColor.withOpacity(0.3),
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      ),
                      controller: _tabController,
                      physics: CustomTabBarScrollPhysics(),
                      onTap: (_index) {
                        setState(() {
                          _currentIndex = _index;
                        });
                        if (_currentIndex == 5) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await CommonFunction.getResearchClientStructuredCallEntries();
                          });
                          for (var i = 0; i < Dataconstants.researchCallsModel.researchCalls.data.length; i++) {
                            if (Dataconstants.researchCallsModel.researchCalls.data[i].model.exchCode == widget.model.exchCode) {
                              researchCount++;
                            }
                          }
                        }
                        if (_currentIndex == 9) {
                          // Dataconstants.companyQuoteBonusController.getCompanyQuoteBonus(widget.model.exchCode.toString());
                          Dataconstants.companyQuoteEventsDividendController.getEventsDividend(widget.model.exchCode.toString());
                        }
                        if (_currentIndex == 1) {
                          setState(() {
                            futuresFlag = true;
                          });
                        } else {
                          setState(() {
                            futuresFlag = false;
                          });
                        }
                      },
                      tabs: [
                        for (var i = 0; i < tabTitle.length; i++)
                          Tab(
                            child: Text(
                              tabTitle[i].toString(),
                              style: Utils.fonts(
                                size: _currentIndex == i ? 13.0 : 12.0,
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: CustomTabBarScrollPhysics(),
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width,
                                color: Utils.greyColor.withOpacity(0.2),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "OP: ",
                                          style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                                        ),
                                        Observer(builder: (context) {
                                          return Text(
                                            // model.exch == "C" ? model.open.toStringAsFixed(4) : model.open.toStringAsFixed(2),
                                            model.exch == "C" ? model.open.toStringAsFixed(4) : model.open.toStringAsFixed(2),
                                            style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                          );
                                        }),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("HI: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                                        Observer(builder: (context) {
                                          return Text(
                                            model.exch == "C" ? model.high.toStringAsFixed(4) : model.high.toStringAsFixed(2),
                                            style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                          );
                                        }),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("LO: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                                        Observer(builder: (context) {
                                          return Text(
                                            model.exch == "C" ? model.low.toStringAsFixed(4) : model.low.toStringAsFixed(2),
                                            style: Utils.fonts(size: 13.0, color: Utils.lightRedColor, fontWeight: FontWeight.w500),
                                          );
                                        }),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("CL: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                                        Observer(builder: (context) {
                                          return Text(
                                            model.exch == "C" ? model.prevDayClose.toStringAsFixed(4) : model.prevDayClose.toStringAsFixed(2),
                                            style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                          );
                                        }),
                                      ],
                                    ),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         text: "Op: ",
                                    //         style: Utils.fonts(
                                    //             size: 12.0,
                                    //             color: Utils.greyColor.withOpacity(0.5)),
                                    //         children: [
                                    //       TextSpan(
                                    //         text: model.open.toStringAsFixed(1),
                                    //         style: Utils.fonts(
                                    //             size: 13.0,
                                    //             color: Utils.blackColor,
                                    //             fontWeight: FontWeight.w500),
                                    //       )
                                    //     ])),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         text: "Hi: ",
                                    //         style: Utils.fonts(
                                    //             size: 12.0,
                                    //             color: Utils.greyColor.withOpacity(0.5)),
                                    //         children: [
                                    //       TextSpan(
                                    //         text: model.high.toStringAsFixed(1),
                                    //         style: Utils.fonts(
                                    //             size: 13.0,
                                    //             color: Utils.lightGreenColor,
                                    //             fontWeight: FontWeight.w500),
                                    //       )
                                    //     ])),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         text: "Lo: ",
                                    //         style: Utils.fonts(
                                    //             size: 12.0,
                                    //             color: Utils.greyColor.withOpacity(0.5)),
                                    //         children: [
                                    //       TextSpan(
                                    //         text: model.low.toStringAsFixed(1),
                                    //         style: Utils.fonts(
                                    //             size: 13.0,
                                    //             color: Utils.lightRedColor,
                                    //             fontWeight: FontWeight.w500),
                                    //       )
                                    //     ])),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         text: "Cl: ",
                                    //         style: Utils.fonts(
                                    //             size: 12.0,
                                    //             color: Utils.greyColor.withOpacity(0.5)),
                                    //         children: [
                                    //       TextSpan(
                                    //         text: model.close.toStringAsFixed(1),
                                    //         style: Utils.fonts(
                                    //             size: 13.0,
                                    //             color: Utils.blackColor,
                                    //             fontWeight: FontWeight.w500),
                                    //       )
                                    //     ]))
                                  ],
                                ),
                              ),
                              Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width,
                                color: Utils.greyColor.withOpacity(0.2),
                              ),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? Container(child: Text(""))
                              //     :
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                        // isIndices
                                        //     ? Text("Chart",
                                        //         style: Utils.fonts(
                                        //           size: 16.0,
                                        //           fontWeight: FontWeight.w600,
                                        //         ))
                                        //     :
                                        Row(
                                      children: [
                                        Visibility(
                                          visible: !isIndices,
                                          child: InkWell(
                                            child: Text("Market Depth",
                                                style: Utils.fonts(
                                                  size: showChart ? 16.0 : 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: showChart ? Colors.grey[600] : theme.textTheme.bodyText1.color,
                                                )),
                                            onTap: () {
                                              setState(() {
                                                showChart = false;
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(color: Utils.greyColor, height: 20, width: 2),
                                        ),
                                        InkWell(
                                          child: Text("Chart",
                                              style: Utils.fonts(
                                                size: showChart ? 18.0 : 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: showChart ? theme.textTheme.bodyText1.color : Colors.grey[600],
                                              )
                                              // style: TextStyle(
                                              //   fontSize: 18,
                                              //   fontWeight: showChart
                                              //       ? FontWeight.w600
                                              //       : FontWeight.normal,
                                              //   color: showChart
                                              //       ? theme.textTheme.bodyText1.color
                                              //       : Colors.grey[600],
                                              // ),
                                              ),
                                          onTap: () {
                                            setState(() {
                                              showChart = true;
                                            });
                                          },
                                        ),
                                        Spacer(),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: theme.primaryColor),
                                          ),
                                          child: Text('Show Chart', style: TextStyle(color: theme.primaryColor)),
                                          onPressed: () {
                                            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp]);

                                            Dataconstants.chartTickByTick = false;

                                            // Dataconstants.defaultBuySellChartSetting=true;
                                            ///---------------current day from 9:00 pass-----
                                            ///----------------------
                                            TimeOfDay intraDayTime = TimeOfDay(hour: 9, minute: 0);
                                            final now = new DateTime.now();
                                            var finalIntraDayTime = DateTime(now.year, now.month, now.day, intraDayTime.hour, intraDayTime.minute).subtract(Duration(hours: 5, minutes: 30));
                                            //print(" finalIntraDayTime : $finalIntraDayTime");
                                            var intraDayTimePass = DateUtil.getIntFromDate1Chart(finalIntraDayTime.toString());
                                            //print('intraDayTimePass  $intraDayTimePass');

                                            Dataconstants.iqsClient.sendChartRequest(
                                              currentModel,
                                              intraDayTimePass,
                                            );

                                            ///-----------------from date pass-----------------------------------------

                                            var fromDate = DateTime.now().subtract(const Duration(days: 1)); // DateTime.now();
                                            //print('current date Time $fromDate');
                                            var fromDatePass = DateUtil.getIntFromDate1Chart(fromDate.toString());
                                            //print('fromDate Pass $fromDatePass');

                                            ///-----------------to date pass----------------------------------------- `
                                            var toDate = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                                            //print('toDate $toDate');
                                            var toDatePass = DateUtil.getIntFromDate1Chart(toDate.toString());
                                            //print('toDate Pass $toDatePass');

                                            //---------------------------- leftSideTime(FromDate)----------------------------------
                                            DateTime lt = new DateTime(toDate.year, toDate.month, toDate.day - 30, 9, 0).subtract(Duration(hours: 5, minutes: 30));
                                            var leftSideTime = DateUtil.getIntFromDate1Chart(lt.toString());
                                            //print(leftSideTime);

                                            // INTELLECT CHART
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SChart(
                                                  currentModel,
                                                  exChar: currentModel.exch,
                                                  //'N',
                                                  scripCode: currentModel.exchCode.toString(),
                                                  // "22",
                                                  symbol: currentModel.marketWatchName.toString(),
                                                  // 'ACC',
                                                  fromDate: leftSideTime.toString(),
                                                  // intraDayTimePass.toString(),// "1656185400",// intraDayTimePass.toString(),    // '1655839800',
                                                  toDate: toDatePass.toString(),
                                                  //  "1656308532", //  toDatePass.toString(),//    '1655980175',
                                                  timeInterval: '1',
                                                  chartPeriod: 'I',
                                                  volumeHidden: false,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                              ),
                              isIndices
                                  ? Observer(
                                      builder: (context) => widget.model.chartMinClose[5].length > 0
                                          ? ScripdetailChart(
                                              seriesList: widget.model.dataPoint[5],
                                              prevClose: widget.model.prevDayClose,
                                              animate: true,
                                            )
                                          : SizedBox.shrink(),
                                    )
                                  : AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 400),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return FadeTransition(child: child, opacity: animation);
                                      },
                                      // child: !showChart
                                      //     ? widget.model.exch == "C" || widget.model.exch == "M"
                                      //     ? MarketDepth(model) : _isNse
                                      //         ? MarketDepth(model)
                                      //         : MarketDepth(model)
                                      //     : Observer(
                                      //         builder: (context) => ScripdetailChart(
                                      //               seriesList: widget.model.dataPoint[5],
                                      //               prevClose: widget.model.prevDayClose,
                                      //               animate: true,
                                      //             )),
                                      child: !showChart
                                          ? _isNse
                                              ? MarketDepth(model)
                                              : MarketDepth(model)
                                          : Observer(
                                              builder: (context) => ScripdetailChart(
                                                    seriesList: widget.model.dataPoint[5],
                                                    prevClose: widget.model.prevDayClose,
                                                    animate: true,
                                                  )),
                                    ),
                              const SizedBox(height: 10),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     :
                              Container(
                                height: 4.0,
                                width: MediaQuery.of(context).size.width,
                                color: Utils.greyColor.withOpacity(0.2),
                              ),
                              SizedBox(height: 10),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     :
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Market Data",
                                      style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    EquityMarketData(),
                                    // (() {
                                    //   if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity) {
                                    //     return EquityMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.nseFuture) {
                                    //     return FuturesMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.mcxFutures) {
                                    //     return FuturesMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.mcxOptions) {
                                    //     return FuturesMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.nseOptions) {
                                    //     return FuturesMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.currenyFutures || model.exchCategory == ExchCategory.bseCurrenyFutures) {
                                    //     return FuturesMarketData();
                                    //   } else if (model.exchCategory == ExchCategory.currenyOptions || model.exchCategory == ExchCategory.bseCurrenyOptions) {
                                    //     return FuturesMarketData();
                                    //   }
                                    // }())
                                  ],
                                ),
                              ),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     :
                              Divider(
                                thickness: 2,
                              ),
                              // (model.ofisType == 1 || model.ofisType2 == 2) ? SizedBox.shrink() :
                              SizedBox(height: 10),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     :
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Price Range",
                                          style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                                        ),
                                        // Container(
                                        //     decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        //       child: Text(
                                        //         "1D",
                                        //         style: Utils.fonts(size: 11.0, color: Utils.greyColor.withOpacity(0.7)),
                                        //       ),
                                        //     )),
                                        // Container(
                                        //     decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        //       child: Text(
                                        //         "1W",
                                        //         style: Utils.fonts(size: 11.0, color: Utils.greyColor.withOpacity(0.7)),
                                        //       ),
                                        //     )),
                                        // Container(
                                        //     decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        //       child: Text(
                                        //         "1M",
                                        //         style: Utils.fonts(size: 11.0, color: Utils.greyColor.withOpacity(0.7)),
                                        //       ),
                                        //     )),
                                        // Container(
                                        //     decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        //       child: Text(
                                        //         "MAX",
                                        //         style: Utils.fonts(size: 11.0, color: Utils.greyColor.withOpacity(0.7)),
                                        //       ),
                                        //     ))
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [Text("Low"), SizedBox(height: 20)],
                                        ),
                                        // Expanded(
                                        //   child: Slider(
                                        //       value: 18.0,
                                        //       min: 1.0,
                                        //       max: 20.0,
                                        //       activeColor: Utils.primaryColor,
                                        //       inactiveColor: Utils.greyColor,
                                        //       thumbColor: Utils.primaryColor,
                                        //       label: 'Set volume value',
                                        //       onChanged: (double newValue) {
                                        //         setState(() {});
                                        //       },
                                        //       semanticFormatterCallback:
                                        //           (double newValue) {
                                        //         return '${newValue.round()} dollars';
                                        //       }),
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.65,
                                          child: Observer(
                                            builder: (_) => infoSliderWidget(
                                              title: "Today's Low/High",
                                              low: widget.model.low,
                                              high: widget.model.high,
                                              value: widget.model.close,
                                              context: context,
                                              lowColor: Color(0xffDCE35B),
                                              highColor: Color(0xff45B649),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [Text("High"), SizedBox(height: 20)],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [Text("Low"), SizedBox(height: 20)],
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.65,
                                          child: Observer(
                                            builder: (_) => infoSliderWidget(
                                              title: '52 Week Low/High',
                                              low: widget.model.yearlyLow,
                                              high: widget.model.yearlyHigh,
                                              context: context,
                                              value: widget.model.close,
                                              highColor: Color(0xfff12711),
                                              lowColor: Color(0xfff5af19),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [Text("High"), SizedBox(height: 20)],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Observer(builder: (context) {
                                          return Text(
                                            model.low.toStringAsFixed(2) + " " + model.percentChangeText,
                                            style: Utils.fonts(color: Utils.mediumRedColor, fontWeight: FontWeight.w500, size: 11.0),
                                          );
                                        }),
                                        Observer(builder: (context) {
                                          return Text(
                                            model.high.toStringAsFixed(2) + " " + model.percentChangeText,
                                            style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 11.0),
                                          );
                                        })
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "1 Day Return",
                                          style: Utils.fonts(size: 11.0, color: Utils.greyColor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "0.0%",
                                          style: Utils.fonts(size: 11.0, color: Utils.mediumGreenColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              // Uncomment when technical signals data available
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         "Technical Signals",
                              //         style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(left: 8.0),
                              //         child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                              //       ),
                              //       SvgPicture.asset("assets/appImages/tech_signals.svg")
                              //     ],
                              //   ),
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Column(
                              //         children: [
                              //           Container(height: 80, width: 200, child: Image.asset('assets/appImages/Vector.png')),
                              //           SizedBox(height: 10),
                              //           Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(right: 8.0),
                              //                 child: Container(height: MediaQuery.of(context).size.height * 0.02, width: MediaQuery.of(context).size.height * 0.02, color: Utils.lightGreenColor),
                              //               ),
                              //               Text(
                              //                 "Bullish 0 ",
                              //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                              //               ),
                              //               SizedBox(width: 10),
                              //               Padding(
                              //                 padding: const EdgeInsets.only(right: 8.0),
                              //                 child: Container(height: MediaQuery.of(context).size.height * 0.02, width: MediaQuery.of(context).size.height * 0.02, color: Utils.brightRedColor),
                              //               ),
                              //               Text(
                              //                 "Bearish 0",
                              //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                              //               ),
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //     VerticalDivider(color: Utils.greyColor, thickness: 2),
                              //     Padding(
                              //       padding: const EdgeInsets.only(right: 8.0),
                              //       child: Column(children: [
                              //         Row(children: [
                              //           Container(
                              //             height: MediaQuery.of(context).size.height * 0.04,
                              //             width: MediaQuery.of(context).size.height * 0.04,
                              //             decoration: BoxDecoration(
                              //                 gradient: LinearGradient(
                              //               begin: Alignment.topCenter,
                              //               end: Alignment.bottomCenter,
                              //               colors: [
                              //                 Colors.blue,
                              //                 Utils.whiteColor,
                              //               ],
                              //             )),
                              //           ),
                              //           Container(
                              //             height: MediaQuery.of(context).size.height * 0.04,
                              //             width: MediaQuery.of(context).size.height * 0.04,
                              //             decoration: BoxDecoration(
                              //                 gradient: LinearGradient(
                              //               begin: Alignment.topCenter,
                              //               end: Alignment.bottomCenter,
                              //               colors: [
                              //                 Colors.brown,
                              //                 Utils.whiteColor,
                              //               ],
                              //             )),
                              //           ),
                              //         ]),
                              //         Row(children: [
                              //           Container(
                              //             height: MediaQuery.of(context).size.height * 0.04,
                              //             width: MediaQuery.of(context).size.height * 0.04,
                              //             decoration: BoxDecoration(
                              //                 gradient: LinearGradient(
                              //               begin: Alignment.topCenter,
                              //               end: Alignment.bottomCenter,
                              //               colors: [
                              //                 Colors.orange,
                              //                 Utils.whiteColor,
                              //               ],
                              //             )),
                              //           ),
                              //           Container(
                              //             height: MediaQuery.of(context).size.height * 0.04,
                              //             width: MediaQuery.of(context).size.height * 0.04,
                              //             decoration: BoxDecoration(
                              //                 gradient: LinearGradient(
                              //               begin: Alignment.topCenter,
                              //               end: Alignment.bottomCenter,
                              //               colors: [
                              //                 Colors.blueAccent,
                              //                 Utils.whiteColor,
                              //               ],
                              //             )),
                              //           ),
                              //         ]),
                              //       ]),
                              //     ),
                              //   ],
                              // ),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : (() {
                              //         if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity) {
                              //           return EquityImage();
                              //         } else if (model.exchCategory == ExchCategory.nseFuture) {
                              //           return FutureOpenInterestAnalysis();
                              //         } else if (model.exchCategory == ExchCategory.mcxOptions) {
                              //           return FutureOpenInterestAnalysis();
                              //         } else if (model.exchCategory == ExchCategory.mcxFutures) {
                              //           return FutureOpenInterestAnalysis();
                              //         } else if (model.exchCategory == ExchCategory.nseOptions) {
                              //           return FutureOpenInterestAnalysis();
                              //         } else if (model.exchCategory == ExchCategory.currenyOptions || model.exchCategory == ExchCategory.bseCurrenyOptions) {
                              //           return FutureOpenInterestAnalysis();
                              //         } else if (model.exchCategory == ExchCategory.currenyFutures || model.exchCategory == ExchCategory.bseCurrenyFutures) {
                              //           return FutureOpenInterestAnalysis();
                              //         }
                              //       }()),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : SizedBox(
                              //         height: 10,
                              //       ),
                              // (model.ofisType == 1 || model.ofisType2 == 2 || model.ofisType == 0)
                              //     ? SizedBox.shrink()
                              //     : (() {
                              //         if (model.ofisType != 0) {
                              //           return gradientBars(false);
                              //         } else if (model.exchCategory == ExchCategory.nseFuture) {
                              //           return EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.mcxFutures) {
                              //           return EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.mcxOptions) {
                              //           return EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.nseOptions) {
                              //           return EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.currenyOptions || model.exchCategory == ExchCategory.bseCurrenyOptions) {
                              //           return EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.currenyFutures || model.exchCategory == ExchCategory.bseCurrenyFutures) {
                              //           return EquityHorizontalGraphs();
                              //         }
                              //       }()),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : Divider(
                              //         thickness: 2,
                              //       ),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : (() {
                              //         if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity) {
                              //           return SizedBox.shrink();
                              //         } else if (model.exchCategory == ExchCategory.nseFuture) {
                              //           return EquityVerticalChart();
                              //         } else if (model.exchCategory == ExchCategory.mcxFutures) {
                              //           return SizedBox.shrink();
                              //         } else if (model.exchCategory == ExchCategory.mcxOptions) {
                              //           return SizedBox.shrink();
                              //         } else if (model.exchCategory == ExchCategory.nseOptions) {
                              //           return EquityVerticalChart();
                              //         } else if (model.exchCategory == ExchCategory.currenyFutures || model.exchCategory == ExchCategory.bseCurrenyFutures) {
                              //           return EquityVerticalChart();
                              //         } else if (model.exchCategory == ExchCategory.currenyOptions || model.exchCategory == ExchCategory.bseCurrenyOptions) {
                              //           return EquityVerticalChart();
                              //         }
                              //       }()),
                              // (model.ofisType == 1 || model.ofisType2 == 2) ? SizedBox.shrink() : SizedBox(height: 20),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : (() {
                              //         if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity) {
                              //           return EquityPeersRow();
                              //         } else if (model.exchCategory == ExchCategory.nseFuture) {
                              //           return SizedBox.shrink();
                              //           EquityHorizontalGraphs();
                              //         } else if (model.exchCategory == ExchCategory.mcxFutures) {
                              //           return EquityVerticalChart();
                              //         } else if (model.exchCategory == ExchCategory.mcxOptions) {
                              //           return EquityVerticalChart();
                              //         } else if (model.exchCategory == ExchCategory.nseOptions) {
                              //           return SizedBox.shrink();
                              //         } else if (model.exchCategory == ExchCategory.currenyFutures || model.exchCategory == ExchCategory.bseCurrenyFutures) {
                              //           return SizedBox.shrink();
                              //         } else if (model.exchCategory == ExchCategory.currenyOptions || model.exchCategory == ExchCategory.bseCurrenyOptions) {
                              //           return SizedBox.shrink();
                              //         }
                              //       }()),
                              // (model.ofisType == 1 || model.ofisType2 == 1) ? SizedBox.shrink() : SizedBox(height: 20),
                              // (model.ofisType == 1 || model.ofisType2 == 1)
                              //     ? SizedBox.shrink()
                              //     : Padding(
                              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               "Margin",
                              //               style: Utils.fonts(fontWeight: FontWeight.w700, size: 16.0),
                              //             ),
                              //             Container(
                              //               width: MediaQuery.of(context).size.width * 0.35,
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Container(
                              //                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Utils.greyColor)),
                              //                     child: Padding(
                              //                       padding: const EdgeInsets.all(8.0),
                              //                       child: Text(
                              //                         "Future",
                              //                         style: Utils.fonts(fontWeight: FontWeight.w700, size: 16.0),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Utils.greyColor)),
                              //                       child: Padding(
                              //                         padding: const EdgeInsets.all(8.0),
                              //                         child: Text(
                              //                           "Cash",
                              //                           style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                              //                         ),
                              //                       )),
                              //                 ],
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              // (model.ofisType == 1 || model.ofisType2 == 2) ? marketBreadth() : SizedBox.shrink(),
                              // (model.ofisType == 1 || model.ofisType2 == 2) ? SizedBox.shrink() : SizedBox(height: 10),
                              // (model.ofisType == 1 || model.ofisType2 == 2)
                              //     ? SizedBox.shrink()
                              //     : Padding(
                              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 Text(
                              //                   "Intraday",
                              //                   style: Utils.fonts(color: Utils.greyColor),
                              //                 ),
                              //                 Text(
                              //                   "50%",
                              //                   style: Utils.fonts(fontWeight: FontWeight.w700),
                              //                 )
                              //               ],
                              //             ),
                              //             Column(
                              //               children: [
                              //                 Text(
                              //                   "Cover",
                              //                   style: Utils.fonts(color: Utils.greyColor),
                              //                 ),
                              //                 Text(
                              //                   "2x",
                              //                   style: Utils.fonts(fontWeight: FontWeight.w700),
                              //                 )
                              //               ],
                              //             ),
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.end,
                              //               children: [
                              //                 Text(
                              //                   "Delivery",
                              //                   style: Utils.fonts(color: Utils.greyColor),
                              //                 ),
                              //                 Text(
                              //                   "30%",
                              //                   style: Utils.fonts(fontWeight: FontWeight.w700),
                              //                 )
                              //               ],
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              // (model.ofisType == 1 || model.ofisType2 == 2) ? gradientBars(false) : SizedBox.shrink(),
                              SizedBox(
                                height: 150,
                              )
                            ],
                          ),
                        ),
                        futures.length > 0 && model.exch != "B"
                            ? ScripdetailFuture(futures, model, 0, "0")
                            : Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        optionDates.length > 0
                            ? ScripdetailOptionChain(model, optionDates, 0, "0")
                            : Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        SingleChildScrollView(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        timeValue = 1;
                                        Dataconstants.swotController.getSwot(currentModel.name);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: timeValue == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        bottom: timeValue == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        right: timeValue == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                        left: timeValue == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("SWOT", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: timeValue == 1 ? Utils.primaryColor : Utils.greyColor)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        timeValue = 2;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: timeValue == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        bottom: timeValue == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        right: timeValue == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                        left: timeValue == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("Key Ratios", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: timeValue == 2 ? Utils.primaryColor : Utils.greyColor)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        timeValue = 3;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: timeValue == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        bottom: timeValue == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        right: timeValue == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                        left: timeValue == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("Financials", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: timeValue == 3 ? Utils.primaryColor : Utils.greyColor)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        timeValue = 4;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: timeValue == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        bottom: timeValue == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        right: timeValue == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                        left: timeValue == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("Share Holdings", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: timeValue == 4 ? Utils.primaryColor : Utils.greyColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            timeValue == 3
                                ? EquityFinancials()
                                : timeValue == 1
                                    ? Obx(() {
                                        return SwotController.isLoading.value
                                            ? Center(child: CircularProgressIndicator())
                                            : Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        SizedBox.shrink(),
                                                        Column(
                                                          children: [
                                                            Row(children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                    height: MediaQuery.of(context).size.width * 0.35,
                                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          begin: Alignment.topCenter,
                                                                          end: Alignment.bottomCenter,
                                                                          colors: [
                                                                            Color(0xff035243),
                                                                            Color(0xffb316a086),
                                                                          ],
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(8.0)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width * 0.06,
                                                                        ),
                                                                        SvgPicture.asset(
                                                                          "assets/appImages/strength.svg",
                                                                          color: Utils.whiteColor,
                                                                          height: 50,
                                                                        ),
                                                                        Text("Strengths",
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                        Text(SwotController.getStrength.length.toString(),
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                      ],
                                                                    ))),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                    height: MediaQuery.of(context).size.width * 0.35,
                                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          begin: Alignment.topRight,
                                                                          end: Alignment.bottomLeft,
                                                                          colors: [
                                                                            Color(0xffc23a2c),
                                                                            Color(0xffb3c23a2c),
                                                                          ],
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(8.0)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width * 0.06,
                                                                        ),
                                                                        Image.asset(
                                                                          "assets/appImages/weakness.png",
                                                                          color: Utils.whiteColor,
                                                                          height: 50,
                                                                        ),
                                                                        Text("Weaknesses",
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                        Text(SwotController.getWeakness.length.toString(),
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                      ],
                                                                    ))),
                                                              )
                                                            ]),
                                                            Row(children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                    height: MediaQuery.of(context).size.width * 0.35,
                                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          begin: Alignment.topCenter,
                                                                          end: Alignment.bottomCenter,
                                                                          colors: [
                                                                            Color(0xffd38404),
                                                                            Color(0xffb3f39c11),
                                                                          ],
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(8.0)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width * 0.06,
                                                                        ),
                                                                        Image.asset(
                                                                          "assets/appImages/opportunities.png",
                                                                          color: Utils.whiteColor,
                                                                          height: 50,
                                                                        ),
                                                                        Text("Opportunities",
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                        Text(SwotController.getOpportunities.length.toString(),
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                      ],
                                                                    ))),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                    height: MediaQuery.of(context).size.width * 0.35,
                                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          begin: Alignment.topRight,
                                                                          end: Alignment.bottomLeft,
                                                                          colors: [
                                                                            Color(0xffd3004c7e),
                                                                            Color(0xffb32a7fb8),
                                                                          ],
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(8.0)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width * 0.06,
                                                                        ),
                                                                        Image.asset(
                                                                          "assets/appImages/threats.png",
                                                                          color: Utils.whiteColor,
                                                                          height: 50,
                                                                        ),
                                                                        Text("Threats",
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                        Text(SwotController.getThreats.length.toString(),
                                                                            style: Utils.fonts(
                                                                              color: Utils.whiteColor,
                                                                            )),
                                                                      ],
                                                                    ))),
                                                              )
                                                            ]),
                                                          ],
                                                        ),
                                                        SizedBox.shrink(),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset("assets/appImages/strength.svg"),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                "Strengths",
                                                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                height: 300,
                                                                child: ListView.builder(
                                                                  itemCount: SwotController.getStrength.length,
                                                                  itemBuilder: (context, index) => Column(children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                      child: Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/appImages/blue_dot.svg",
                                                                            color: Colors.green,
                                                                          ),
                                                                          SizedBox(width: 5),
                                                                          Expanded(
                                                                              child: Text(
                                                                            SwotController.getStrength[index],
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                  ]),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Image.asset("assets/appImages/weakness.png", height: 27),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                "Weaknesses",
                                                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Column(
                                                            children: [
                                                              ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount: SwotController.getWeakness.length,
                                                                itemBuilder: (context, index) => Column(children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/appImages/blue_dot.svg",
                                                                          color: Colors.red,
                                                                        ),
                                                                        SizedBox(width: 5),
                                                                        Expanded(
                                                                            child: Text(
                                                                          SwotController.getWeakness[index],
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                ]),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Image.asset("assets/appImages/opportunities.png", height: 27),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                "Opportunities",
                                                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Column(
                                                            children: [
                                                              ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount: SwotController.getOpportunities.length,
                                                                itemBuilder: (context, index) => Column(children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/appImages/blue_dot.svg",
                                                                          color: Colors.yellow,
                                                                        ),
                                                                        SizedBox(width: 5),
                                                                        Expanded(
                                                                            child: Text(
                                                                          SwotController.getOpportunities[index],
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                ]),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset("assets/appImages/threats.png"),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                "Threats",
                                                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: SwotController.getThreats.length,
                                                            itemBuilder: (context, index) => Column(children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      "assets/appImages/blue_dot.svg",
                                                                      color: Colors.green,
                                                                    ),
                                                                    SizedBox(width: 5),
                                                                    Expanded(
                                                                        child: Text(
                                                                      SwotController.getThreats[index],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(height: 140)
                                                  ],
                                                ));
                                      })
                                    : ShareHoldings()
                          ]),
                        )

                        // SingleChildScrollView(
                        //     child: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Column(
                        //     children: [
                        //       Divider(
                        //         thickness: 2,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "Technical Scanners",
                        //             style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 5),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "This stock has featured in technical scanners hit today",
                        //             style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 12.0),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10),
                        //       Column(
                        //         children: [
                        //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //             Row(
                        //               children: [
                        //                 SvgPicture.asset("assets/appImages/blue_dot.svg"),
                        //                 SizedBox(width: 5),
                        //                 Text(
                        //                   "Volume Shocker",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                        //                 ),
                        //               ],
                        //             ),
                        //             Container(
                        //               decoration: BoxDecoration(color: Utils.lightGreenColor.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(2.0))),
                        //               child: Padding(
                        //                 padding: EdgeInsets.all(8.0),
                        //                 child: Text(
                        //                   "Bullish",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             )
                        //           ]),
                        //           Row(
                        //             children: [
                        //               SizedBox(
                        //                 width: 13,
                        //               ),
                        //               Expanded(
                        //                 child: Text("Jump in volume more than 5x compared to 5 day average", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 20,
                        //       ),
                        //       Column(
                        //         children: [
                        //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //             Row(
                        //               children: [
                        //                 SvgPicture.asset("assets/appImages/blue_dot.svg"),
                        //                 SizedBox(width: 5),
                        //                 Text(
                        //                   "Open Low",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                        //                 ),
                        //               ],
                        //             ),
                        //             Container(
                        //               decoration: BoxDecoration(color: Utils.lightGreenColor.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(2.0))),
                        //               child: Padding(
                        //                 padding: EdgeInsets.all(8.0),
                        //                 child: Text(
                        //                   "Bullish",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             )
                        //           ]),
                        //           Row(
                        //             children: [
                        //               SizedBox(
                        //                 width: 13,
                        //               ),
                        //               Expanded(
                        //                 child: Text("OPening and low price of 1610.35 was same today", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 20,
                        //       ),
                        //       Column(
                        //         children: [
                        //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //             Row(
                        //               children: [
                        //                 SvgPicture.asset("assets/appImages/blue_dot.svg"),
                        //                 SizedBox(width: 5),
                        //                 Text(
                        //                   "High Breaker",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                        //                 ),
                        //               ],
                        //             ),
                        //             Container(
                        //               decoration: BoxDecoration(color: Utils.lightGreenColor.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(2.0))),
                        //               child: Padding(
                        //                 padding: EdgeInsets.all(8.0),
                        //                 child: Text(
                        //                   "Bullish",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             )
                        //           ]),
                        //           Row(
                        //             children: [
                        //               SizedBox(
                        //                 width: 17,
                        //               ),
                        //               Expanded(
                        //                 child: Text("Made a 1-month High of 1655.35. Previous high was 1624.30", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text("Resistance & Support",
                        //               style: Utils.fonts(
                        //                 fontWeight: FontWeight.w700,
                        //                 size: 13.0,
                        //               )),
                        //         ],
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 58.0),
                        //         child: SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
                        //           RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
                        //             GaugeRange(startValue: 0, endValue: 10, color: Colors.green, startWidth: 10, endWidth: 10),
                        //             GaugeRange(startValue: 10, endValue: 20, color: Colors.orange, startWidth: 10, endWidth: 10),
                        //             GaugeRange(startValue: 20, endValue: 30, color: Colors.red, startWidth: 10, endWidth: 10),
                        //             GaugeRange(startValue: 30, endValue: 40, color: Colors.green, startWidth: 10, endWidth: 10),
                        //             GaugeRange(startValue: 40, endValue: 50, color: Colors.orange, startWidth: 10, endWidth: 10),
                        //             GaugeRange(startValue: 50, endValue: 60, color: Colors.red, startWidth: 10, endWidth: 10)
                        //           ], pointers: <GaugePointer>[
                        //             NeedlePointer(value: 22)
                        //           ])
                        //         ]),
                        //       ),
                        //       Text("PIVOT POINT", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //       Text("1890.99",
                        //           style: Utils.fonts(
                        //             fontWeight: FontWeight.w700,
                        //             size: 13.0,
                        //           )),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           child: Column(
                        //             children: [
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("S1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightRedColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("S1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightRedColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("S1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightRedColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: Column(
                        //             children: [
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("R1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightGreenColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("R1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightGreenColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                 Text("R1", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //                 Text("1,807", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.lightGreenColor)),
                        //               ]),
                        //               SizedBox(height: 10),
                        //             ],
                        //           ),
                        //         )
                        //       ]),
                        //       Divider(
                        //         thickness: 2,
                        //       ),
                        //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //         Text("Moving Averages",
                        //             style: Utils.fonts(
                        //               fontWeight: FontWeight.w700,
                        //               size: 15.0,
                        //             )),
                        //         Row(children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(right: 8.0),
                        //             child: Container(height: MediaQuery.of(context).size.width * 0.03, width: MediaQuery.of(context).size.width * 0.03, color: Colors.orange.withOpacity(0.5)),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(right: 8.0),
                        //             child: Text("Bearish",
                        //                 style: Utils.fonts(
                        //                   fontWeight: FontWeight.w700,
                        //                   size: 15.0,
                        //                 )),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(right: 8.0),
                        //             child: Container(height: MediaQuery.of(context).size.width * 0.03, width: MediaQuery.of(context).size.width * 0.03, color: Colors.green.withOpacity(0.5)),
                        //           ),
                        //           Text("Bullish",
                        //               style: Utils.fonts(
                        //                 fontWeight: FontWeight.w700,
                        //                 size: 15.0,
                        //               )),
                        //         ]),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               child: Text("Period",
                        //                   style: Utils.fonts(
                        //                     size: 13.0,
                        //                   )),
                        //             ),
                        //           ),
                        //           Expanded(
                        //               flex: 2,
                        //               child: Container(
                        //                 decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Row(
                        //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //                     children: [
                        //                       Text("Simple",
                        //                           style: Utils.fonts(
                        //                             size: 13.0,
                        //                           )),
                        //                       Text("Exponential",
                        //                           style: Utils.fonts(
                        //                             size: 13.0,
                        //                           )),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ))
                        //         ],
                        //       ),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("5 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("10 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("20 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.green.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.green.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("50 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("100 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.orange.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //           flex: 1,
                        //           child: Text("200 DMA",
                        //               style: Utils.fonts(
                        //                 size: 13.0,
                        //               )),
                        //         ),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.green.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               color: Colors.green.withOpacity(0.2),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Center(
                        //                   child: Text("115.8",
                        //                       style: Utils.fonts(
                        //                         size: 13.0,
                        //                       )),
                        //                 ),
                        //               ),
                        //             )),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Divider(thickness: 2),
                        //       Row(children: [
                        //         Text("Moving Averages",
                        //             style: Utils.fonts(
                        //               fontWeight: FontWeight.w700,
                        //               size: 15.0,
                        //             )),
                        //       ]),
                        //       Row(children: [
                        //         Expanded(
                        //           child: Container(
                        //             color: Colors.orange.withOpacity(0.2),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Center(
                        //                 child: Text("Bearish",
                        //                     style: Utils.fonts(
                        //                       color: Colors.deepOrange,
                        //                       size: 13.0,
                        //                     )),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: Container(
                        //             color: Utils.primaryColor.withOpacity(0.2),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Center(
                        //                 child: Text("Neutral",
                        //                     style: Utils.fonts(
                        //                       size: 13.0,
                        //                     )),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: Container(
                        //             color: Utils.lightGreenColor.withOpacity(0.2),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Center(
                        //                 child: Text("Bearish",
                        //                     style: Utils.fonts(
                        //                       color: Utils.mediumGreenColor,
                        //                       size: 13.0,
                        //                     )),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(
                        //             child: Container(
                        //           color: Colors.orange.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.primaryColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.lightGreenColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         ))
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(child: SizedBox()),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.primaryColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.lightGreenColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         ))
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(child: SizedBox()),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.primaryColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         )),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.lightGreenColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         ))
                        //       ]),
                        //       SizedBox(height: 10),
                        //       Row(children: [
                        //         Expanded(child: SizedBox()),
                        //         SizedBox(width: 10),
                        //         Expanded(child: SizedBox()),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //             child: Container(
                        //           color: Utils.lightGreenColor.withOpacity(0.2),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Column(children: [
                        //               Text("MACD(12.36)", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //               Text("-1.06", style: Utils.fonts(color: Utils.greyColor, size: 12.0)),
                        //             ]),
                        //           ),
                        //         ))
                        //       ]),
                        //       SizedBox(
                        //         height: MediaQuery.of(context).size.height * 0.20,
                        //       ),
                        //     ],
                        //   ),
                        // )),
                        ,
                        Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // SingleChildScrollView(
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        //     child: Column(children: [
                        //       Row(
                        //         children: [
                        //           Text(
                        //             'Research Ratings',
                        //             style: Utils.fonts(fontWeight: FontWeight.w700),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             child: Text("The ratings aggregation is done based on the coverage done by domestic and international broking houses",
                        //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10),
                        //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //         Column(children: [
                        //           Text("BUY", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.mediumGreenColor)),
                        //           SizedBox(height: 10),
                        //           // Container(
                        //           //   decoration: BoxDecoration(
                        //           //     border: Border.all(
                        //           //       width: 10.0,
                        //           //     ),
                        //           //     borderRadius: BorderRadius.all(
                        //           //         Radius.circular(70.0)),
                        //           //   ),
                        //           //   height: MediaQuery.of(context).size.height *
                        //           //       0.15,
                        //           //   width: MediaQuery.of(context).size.height *
                        //           //       0.15,
                        //           // ),
                        //           // Container(height: MediaQuery.of(context).size.height *
                        //           //     0.15,
                        //           //   width: MediaQuery.of(context).size.height *
                        //           //       0.15,
                        //           //   child: SfCircularChart(
                        //           //       series: <CircularSeries>[
                        //           //         // Renders doughnut chart
                        //           //         DoughnutSeries<ChartData, String>(
                        //           //             dataSource: chartData,
                        //           //             pointColorMapper:(ChartData data,  _) => data.color,
                        //           //             xValueMapper: (ChartData data, _) => data.x,
                        //           //             yValueMapper: (ChartData data, _) => data.y
                        //           //         )
                        //           //       ]
                        //           //   ),
                        //           // )
                        //           Container(
                        //             height: MediaQuery.of(context).size.height * 0.10,
                        //             width: MediaQuery.of(context).size.height * 0.10,
                        //             child: CircularProgressIndicator(
                        //               value: 0.75,
                        //               color: Colors.green,
                        //               strokeWidth: 12.0,
                        //             ),
                        //           ),
                        //         ]),
                        //         Column(children: [
                        //           Text("HOLD", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           SizedBox(height: 10),
                        //           // Container(
                        //           //   height: MediaQuery.of(context).size.height * 0.15,
                        //           //   width: MediaQuery.of(context).size.height * 0.15,
                        //           //   child: SfCircularChart(series: <CircularSeries>[
                        //           //     // Renders doughnut chart
                        //           //     DoughnutSeries<ChartData, String>(
                        //           //       dataSource: chartData,
                        //           //       pointColorMapper: (ChartData data, _) => data.color,
                        //           //       xValueMapper: (ChartData data, _) => data.x,
                        //           //       yValueMapper: (ChartData data, _) => data.y,
                        //           //     )
                        //           //   ]),
                        //           // )
                        //           // Container(
                        //           //   height: MediaQuery.of(context).size.height *
                        //           //       0.10,
                        //           //   width: MediaQuery.of(context).size.height *
                        //           //       0.10,
                        //           //   child: CircularProgressIndicator(
                        //           //     value: 0.35,
                        //           //     color: Colors.grey,
                        //           //     strokeWidth: 12.0,
                        //           //
                        //           //   ),
                        //           // ),
                        //         ]),
                        //         Column(children: [
                        //           Text("SELL", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.darkRedColor)),
                        //           SizedBox(height: 10),
                        //           // Container(
                        //           //   height: MediaQuery.of(context).size.height *
                        //           //     0.15,
                        //           //   width: MediaQuery.of(context).size.height *
                        //           //       0.15,
                        //           //   child: SfCircularChart(
                        //           //       series: <CircularSeries>[
                        //           //         // Renders doughnut chart
                        //           //         DoughnutSeries<ChartData, String>(
                        //           //             dataSource: chartData,
                        //           //             pointColorMapper: (ChartData data,  _) => data.color,
                        //           //             xValueMapper: (ChartData data, _) => data.x,
                        //           //             yValueMapper: (ChartData data, _) => data.y
                        //           //         )
                        //           //       ]
                        //           //   ),
                        //           // )
                        //           Container(
                        //             height: MediaQuery.of(context).size.height * 0.10,
                        //             width: MediaQuery.of(context).size.height * 0.10,
                        //             child: CircularProgressIndicator(
                        //               value: 0.75,
                        //               color: Colors.red,
                        //               strokeWidth: 12.0,
                        //             ),
                        //           ),
                        //         ])
                        //       ]),
                        //       SizedBox(
                        //         height: 10,
                        //       ),
                        //       Container(
                        //         decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(2.0))),
                        //         child: Padding(
                        //           padding: EdgeInsets.all(8.0),
                        //           child: RichText(
                        //             text: new TextSpan(
                        //               // Note: Styles for TextSpans must be explicitly defined.
                        //               // Child text spans will inherit styles from parent
                        //               style: new TextStyle(
                        //                 fontSize: 14.0,
                        //                 color: Colors.black,
                        //               ),
                        //               children: <TextSpan>[
                        //                 new TextSpan(text: 'Strong Buy ', style: new TextStyle(color: Utils.mediumGreenColor, fontWeight: FontWeight.w700)),
                        //                 new TextSpan(text: 'can be inferred from the above ratings'),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text(
                        //             'Target Price Range',
                        //             style: Utils.fonts(fontWeight: FontWeight.w700),
                        //           ),
                        //         ],
                        //       ),
                        //       Container(
                        //           height: 320,
                        //           decoration: BoxDecoration(
                        //             border: Border(
                        //               bottom: BorderSide(width: 1.0, color: Utils.blackColor),
                        //             ),
                        //           ),
                        //           width: MediaQuery.of(context).size.width,
                        //           child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        //             Column(
                        //               children: [
                        //                 Spacer(),
                        //                 Text(
                        //                   "1950",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //                 Container(
                        //                   height: MediaQuery.of(context).size.width * 0.2,
                        //                   width: 40,
                        //                   decoration: BoxDecoration(
                        //                     color: Utils.primaryColor.withOpacity(0.3),
                        //                     borderRadius: BorderRadius.only(
                        //                       topRight: Radius.circular(10.0),
                        //                       topLeft: Radius.circular(10.0),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             Column(
                        //               children: [
                        //                 Spacer(),
                        //                 Text(
                        //                   "2100",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //                 Container(
                        //                   height: MediaQuery.of(context).size.width * 0.7,
                        //                   width: 40,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.only(
                        //                       topRight: Radius.circular(10.0),
                        //                       topLeft: Radius.circular(10.0),
                        //                     ),
                        //                     color: Utils.primaryColor.withOpacity(0.9),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             Column(
                        //               children: [
                        //                 Spacer(),
                        //                 Text(
                        //                   "2300",
                        //                   style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //                 Container(
                        //                   height: MediaQuery.of(context).size.width * 0.4,
                        //                   width: 40,
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.only(
                        //                       topRight: Radius.circular(10.0),
                        //                       topLeft: Radius.circular(10.0),
                        //                     ),
                        //                     color: Utils.primaryColor.withOpacity(0.3),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ])),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //         children: [
                        //           Text(
                        //             "Lowest",
                        //             style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //           ),
                        //           Text(
                        //             "Average",
                        //             style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //           ),
                        //           Text(
                        //             "Highest",
                        //             style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //           ),
                        //         ],
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //               Padding(
                        //                 padding: const EdgeInsets.only(left: 8.0),
                        //                 child: Text(
                        //                   "23%",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //               Padding(
                        //                 padding: const EdgeInsets.only(left: 8.0),
                        //                 child: Text(
                        //                   "38%",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //               Padding(
                        //                 padding: const EdgeInsets.only(left: 8.0),
                        //                 child: Text(
                        //                   "48%",
                        //                   style: Utils.fonts(color: Utils.mediumGreenColor, fontWeight: FontWeight.w500, size: 13.0),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             child: Text("% Chg mentioned above is calculated based on current market price. 23% from Low suggests there is an upside potential of 23% current price",
                        //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor)),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: MediaQuery.of(context).size.height * 0.20)
                        //     ]),
                        //   ),
                        // ),
                        // Center(
                        //   child: Text(
                        //     'No data available',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),

                        researchCount <= 0
                            ? Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Observer(builder: (BuildContext context) {
                                return Dataconstants.researchCallsModel.fetchingData
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: CircularProgressIndicator(
                                          color: Utils.primaryColor,
                                        ),
                                      )
                                    : Dataconstants.researchCallsModel.researchCalls.data.length == 0
                                        ? Center(child: Text("No Data available", style: Utils.fonts()))
                                        : Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    // if (Dataconstants.researchCallsModel.tradingSelectedChip == 0)
                                                    //   Dataconstants.researchCallsModel.intradayList.length > 0
                                                    //       ? Column(
                                                    //           children: [
                                                    //             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    //               Container(
                                                    //                 width: MediaQuery.of(context).size.width / 3,
                                                    //                 child: Text(
                                                    //                   'Symbol',
                                                    //                   textAlign: TextAlign.start,
                                                    //                   style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                                    //                 ),
                                                    //               ),
                                                    //               Container(
                                                    //                 width: MediaQuery.of(context).size.width / 3.5,
                                                    //                 child: Text(
                                                    //                   'Target',
                                                    //                   textAlign: TextAlign.center,
                                                    //                   style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                                    //                 ),
                                                    //               ),
                                                    //               Container(
                                                    //                 width: MediaQuery.of(context).size.width / 3.5,
                                                    //                 child: Text(
                                                    //                   'Exp.Return',
                                                    //                   textAlign: TextAlign.end,
                                                    //                   style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                                    //                 ),
                                                    //               ),
                                                    //             ]),
                                                    //             ListView.builder(
                                                    //                 shrinkWrap: true,
                                                    //                 itemCount:
                                                    //                     Dataconstants.researchCallsModel.researchCalls.data.length >= 4 ? 4 : Dataconstants.researchCallsModel.researchCalls.data.length,
                                                    //                 itemBuilder: (context, index) {
                                                    //                   return Padding(
                                                    //                     padding: const EdgeInsets.symmetric(vertical: 18.0),
                                                    //                     child: Column(
                                                    //                       children: [
                                                    //                         InkWell(
                                                    //                           onTap: () {
                                                    //                             // Navigator.push(
                                                    //                             //     context,
                                                    //                             //     MaterialPageRoute(
                                                    //                             //         builder: (context) => ScriptInfo(CommonFunction.getScripDataModel(
                                                    //                             //             exch: Dataconstants.researchCallsModel.researchCalls.data[index].model.exchCode >= 500000 ? "B" : "N",
                                                    //                             //             exchCode: int.parse(Dataconstants.researchCallsModel.researchCalls.data[index].model.exchCode.toString())))));
                                                    //
                                                    //                             showModalBottomSheet(
                                                    //                                 backgroundColor: Utils.containerColor,
                                                    //                                 isScrollControlled: true,
                                                    //                                 context: context,
                                                    //                                 builder: (builder) {
                                                    //                                   return OrderPlacementBottomSheet(
                                                    //                                     segment: Dataconstants.researchCallsModel.researchCalls.data[index].exchsegment,
                                                    //                                     stockName: Dataconstants.researchCallsModel.researchCalls.data[index].model.name,
                                                    //                                     isBuy: Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy" ? true : false,
                                                    //                                     currentModel: Dataconstants.researchCallsModel.researchCalls.data[index].model,
                                                    //                                   );
                                                    //                                 });
                                                    //                           },
                                                    //                           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    //                             Container(
                                                    //                               width: MediaQuery.of(context).size.width / 3,
                                                    //                               child: Padding(
                                                    //                                 padding: const EdgeInsets.symmetric(vertical: 0),
                                                    //                                 child: Row(
                                                    //                                   children: [
                                                    //                                     Container(
                                                    //                                       decoration: BoxDecoration(
                                                    //                                           borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    //                                           color: Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy"
                                                    //                                               ? ThemeConstants.buyColor
                                                    //                                               : Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Sell"
                                                    //                                                   ? ThemeConstants.sellColor
                                                    //                                                   : Utils.greyColor),
                                                    //                                       child: Padding(
                                                    //                                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                    //                                         child: Text(
                                                    //                                           Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy"
                                                    //                                               ? "BUY"
                                                    //                                               : Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Sell"
                                                    //                                                   ? "SELL"
                                                    //                                                   : "",
                                                    //                                           style: Utils.fonts(size: 10.0, color: Utils.whiteColor),
                                                    //                                         ),
                                                    //                                       ),
                                                    //                                     ),
                                                    //                                     SizedBox(
                                                    //                                       width: 5,
                                                    //                                     ),
                                                    //                                     Text('${Dataconstants.researchCallsModel.researchCalls.data[index].model.name}',
                                                    //                                         style: Utils.fonts(size: 12.0, color: Utils.blackColor), textAlign: TextAlign.center),
                                                    //                                   ],
                                                    //                                 ),
                                                    //                               ),
                                                    //                             ),
                                                    //                             Container(
                                                    //                               width: MediaQuery.of(context).size.width / 3.5,
                                                    //                               child: Padding(
                                                    //                                 padding: const EdgeInsets.symmetric(vertical: 0),
                                                    //                                 child: Text('${Dataconstants.researchCallsModel.researchCalls.data[index].targetprice}',
                                                    //                                     style: Utils.fonts(size: 14.0, color: Utils.greyColor), textAlign: TextAlign.center),
                                                    //                               ),
                                                    //                             ),
                                                    //                             Container(
                                                    //                               width: MediaQuery.of(context).size.width / 3.5,
                                                    //                               child: Padding(
                                                    //                                 padding: const EdgeInsets.symmetric(vertical: 0.0),
                                                    //                                 child: Container(
                                                    //                                   // constraints: const BoxConstraints(
                                                    //                                   //   maxWidth: 10,
                                                    //                                   // ),
                                                    //                                   decoration:
                                                    //                                       BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.lightGreenColor.withOpacity(0.2)),
                                                    //                                   child: Text(
                                                    //                                     "",
                                                    //                                     textAlign: TextAlign.end,
                                                    //                                     style: Utils.fonts(size: 14.0, color: Utils.darkGreenColor),
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               ),
                                                    //                             ),
                                                    //                           ]),
                                                    //                         ),
                                                    //                         Divider(thickness: 1)
                                                    //                       ],
                                                    //                     ),
                                                    //                   );
                                                    //                 })
                                                    //           ],
                                                    //         )
                                                    //       : Text(
                                                    //           "No Research Information Available",
                                                    //           style: TextStyle(
                                                    //               fontSize: 14,
                                                    //               fontWeight: FontWeight.w300,
                                                    //               color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                                    //         )
                                                    // else
                                                    //   Dataconstants.researchCallsModel.momentumList.length > 0
                                                    //       ? Text("JM FINANCIALS")
                                                    //       : Text(
                                                    //           "No Research Information Available",
                                                    //           style: TextStyle(
                                                    //               fontSize: 14,
                                                    //               fontWeight: FontWeight.w300,
                                                    //               color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                                    //         )
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: Dataconstants.researchCallsModel.researchCalls.data.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return Dataconstants.researchCallsModel.researchCalls.data[index].model.exchCode == widget.model.exchCode
                                                            ? TradingCard(
                                                                data: Dataconstants.researchCallsModel.researchCalls.data[0],
                                                                isScripDetailResearch: true,
                                                              )
                                                            : SizedBox.shrink();
                                                      },
                                                    ),
                                                    // TradingCard(
                                                    //   data: Dataconstants.researchCallsModel.researchCalls.data[0],
                                                    //   isScripDetailResearch: true,
                                                    // )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                              }),
                        // SingleChildScrollView(
                        //     child: Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("TIME", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("PRICE", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("TICK", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("VOLUME", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("ANALYSIS", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //         ],
                        //       ),
                        //       Divider(thickness: 1),
                        //       for (var i = 0; i < 10; i++)
                        //         Column(children: [
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text("13:30", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //               Text("1431.25", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //               SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //               Text("4653", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //               Container(
                        //                 width: MediaQuery.of(context).size.width * 0.2,
                        //                 child: Text("Surge in Volume", textAlign: TextAlign.start, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //               ),
                        //             ],
                        //           ),
                        //           Divider(
                        //             thickness: 1,
                        //           )
                        //         ])
                        //     ],
                        //   ),
                        // )),

                        Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        // SingleChildScrollView(
                        //     child: Column(
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Text(
                        //           'Summary',
                        //           style: Utils.fonts(fontWeight: FontWeight.w700, size: 16.0),
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               height: 20,
                        //               width: 20,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(5.0),
                        //                 color: Utils.primaryColor,
                        //               ),
                        //             ),
                        //             SizedBox(width: 10),
                        //             Text(
                        //               'Total Volume',
                        //               style: Utils.fonts(color: Utils.greyColor),
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               height: 20,
                        //               width: 20,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(5.0),
                        //                 color: Utils.primaryColor.withOpacity(0.4),
                        //               ),
                        //             ),
                        //             SizedBox(width: 10),
                        //             Text(
                        //               'Delivery',
                        //               style: Utils.fonts(color: Utils.greyColor),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //     Container(
                        //         height: 320,
                        //         decoration: BoxDecoration(
                        //           border: Border(
                        //             bottom: BorderSide(width: 1.0, color: Utils.blackColor),
                        //           ),
                        //         ),
                        //         width: MediaQuery.of(context).size.width,
                        //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        //           Row(
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsets.only(right: 2.0),
                        //                 child: Column(
                        //                   children: [
                        //                     Spacer(),
                        //                     Text(
                        //                       "1950",
                        //                       style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                     ),
                        //                     SizedBox(
                        //                       height: 10,
                        //                     ),
                        //                     Container(
                        //                       height: MediaQuery.of(context).size.width * 0.4,
                        //                       width: 40,
                        //                       decoration: BoxDecoration(
                        //                         color: Utils.primaryColor,
                        //                         borderRadius: BorderRadius.only(
                        //                           topRight: Radius.circular(10.0),
                        //                           topLeft: Radius.circular(10.0),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Column(
                        //                 children: [
                        //                   Spacer(),
                        //                   Text(
                        //                     "1950",
                        //                     style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                   ),
                        //                   SizedBox(
                        //                     height: 10,
                        //                   ),
                        //                   Container(
                        //                     height: MediaQuery.of(context).size.width * 0.2,
                        //                     width: 40,
                        //                     decoration: BoxDecoration(
                        //                       color: Utils.primaryColor.withOpacity(0.3),
                        //                       borderRadius: BorderRadius.only(
                        //                         topRight: Radius.circular(10.0),
                        //                         topLeft: Radius.circular(10.0),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsets.only(right: 2.0),
                        //                 child: Column(
                        //                   children: [
                        //                     Spacer(),
                        //                     Text(
                        //                       "2100",
                        //                       style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                     ),
                        //                     SizedBox(
                        //                       height: 10,
                        //                     ),
                        //                     Container(
                        //                       height: MediaQuery.of(context).size.width * 0.7,
                        //                       width: 40,
                        //                       decoration: BoxDecoration(
                        //                         borderRadius: BorderRadius.only(
                        //                           topRight: Radius.circular(10.0),
                        //                           topLeft: Radius.circular(10.0),
                        //                         ),
                        //                         color: Utils.primaryColor.withOpacity(0.9),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Column(
                        //                 children: [
                        //                   Spacer(),
                        //                   Text(
                        //                     "2100",
                        //                     style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //                   ),
                        //                   SizedBox(
                        //                     height: 10,
                        //                   ),
                        //                   Container(
                        //                     height: MediaQuery.of(context).size.width * 0.5,
                        //                     width: 40,
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.only(
                        //                         topRight: Radius.circular(10.0),
                        //                         topLeft: Radius.circular(10.0),
                        //                       ),
                        //                       color: Utils.primaryColor.withOpacity(0.3),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //           Column(
                        //             children: [
                        //               Spacer(),
                        //               Text(
                        //                 "2300",
                        //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                        //               ),
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               Container(
                        //                 height: MediaQuery.of(context).size.width * 0.4,
                        //                 width: 40,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.only(
                        //                     topRight: Radius.circular(10.0),
                        //                     topLeft: Radius.circular(10.0),
                        //                   ),
                        //                   color: Utils.primaryColor.withOpacity(0.3),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ])),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Text(
                        //           "Lowest",
                        //           style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //         ),
                        //         Text(
                        //           "Average",
                        //           style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //         ),
                        //         Text(
                        //           "Highest",
                        //           style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w500, size: 13.0),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(height: 20),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("Volume Analysis",
                        //               style: Utils.fonts(
                        //                 fontWeight: FontWeight.w500,
                        //                 size: 14.0,
                        //               )),
                        //           Text("15:59 07 Mar 22", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //         ],
                        //       ),
                        //     ),
                        //     Divider(
                        //       thickness: 1,
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("PRICE", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("TOTAL VOL", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("BUY VOL", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //           Text("SELL VOL", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //         ],
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("1440.81", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.mediumGreenColor)),
                        //           Text("46.5L",
                        //               style: Utils.fonts(
                        //                 fontWeight: FontWeight.w500,
                        //                 size: 14.0,
                        //               )),
                        //           Text("13.5L", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.mediumGreenColor)),
                        //           Text("15.5L", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.lightRedColor)),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // )),
                        Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        NewsScreen(_newsNseCode),
                        // SingleChildScrollView(
                        //     child: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Column(
                        //     children: [
                        //       for (var i = 0; i < 10; i++)
                        //         Column(
                        //           children: [
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Row(
                        //               children: [
                        //                 SvgPicture.asset(
                        //                   "assets/appImages/markets/yellow_dot.svg",
                        //                   color: Utils.brightRedColor,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 8,
                        //                 ),
                        //                 Expanded(
                        //                   child: Text("Adani Green profit rises to 14% to 49 cr", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                        //                 ),
                        //               ],
                        //             ),
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     SizedBox(
                        //                       width: 20,
                        //                     ),
                        //                     Text("Hindustan Times", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.primaryColor)),
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Text("25 Feb, 2022", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //             Divider(
                        //               thickness: 1,
                        //             )
                        //           ],
                        //         )
                        //     ],
                        //   ),
                        // )),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Dataconstants.companyQuoteEventsDividendController.getEventsDividend(widget.model.exchCode.toString());
                                              setState(() {
                                                scripEvents = 1;
                                                //print(scripEvents);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: scripEvents == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                bottom: scripEvents == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                right: scripEvents == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                                left: scripEvents == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                              )),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text("Dividend", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: scripEvents == 1 ? Utils.primaryColor : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                Dataconstants.companyQuoteBonusController.getCompanyQuoteBonus(widget.model.exchCode.toString());
                                                scripEvents = 2;
                                                //print(scripEvents);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: scripEvents == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                bottom: scripEvents == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                right: scripEvents == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                                left: scripEvents == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                              )),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text("Bonus", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: scripEvents == 2 ? Utils.primaryColor : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                Dataconstants.companyQuoteRightsController.getCompanyQuoteRights(widget.model.exchCode.toString());
                                                scripEvents = 3;
                                                //print(scripEvents);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: scripEvents == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                bottom: scripEvents == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                right: scripEvents == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                left: scripEvents == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                              )),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text("Rights", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: scripEvents == 3 ? Utils.primaryColor : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Dataconstants.companyQuoteSplitsController.getEventsSplits(widget.model.exchCode.toString());
                                              setState(() {
                                                scripEvents = 4;
                                                //print(scripEvents);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: scripEvents == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                bottom: scripEvents == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                right: scripEvents == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                                left: scripEvents == 4 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                              )),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text("Splits", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: scripEvents == 4 ? Utils.primaryColor : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                scripEvents = 5;
                                                //print(scripEvents);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: scripEvents == 5 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                bottom: scripEvents == 5 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                right: scripEvents == 5 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                                                left: scripEvents == 5 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                                              )),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text("Board Meet", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: scripEvents == 5 ? Utils.primaryColor : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (scripEvents == 1)
                                  ScripEventsDividend()
                                else if (scripEvents == 2)
                                  ScripBonus()
                                else if (scripEvents == 3)
                                  ScripRights()
                                else if (scripEvents == 4)
                                  ScripSplits()
                                else if (scripEvents == 5)
                                  ScripBoardMeet()
                              ],
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Text(
                        //     'No data available',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),
                        // isCompareActive == false
                        //     ? SingleChildScrollView(
                        //         child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Column(
                        //           children: [
                        //             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //               Text("Peers",
                        //                   style: Utils.fonts(
                        //                     fontWeight: FontWeight.w700,
                        //                     size: 14.0,
                        //                   )),
                        //               Text("Click on + to compare",
                        //                   style: Utils.fonts(
                        //                     color: Utils.greyColor,
                        //                     fontWeight: FontWeight.w700,
                        //                     size: 12.0,
                        //                   )),
                        //             ]),
                        //             Divider(thickness: 2),
                        //             Row(children: [
                        //               Expanded(
                        //                 flex: 5,
                        //                 child: Container(
                        //                   child: Text("Companies", style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                 ),
                        //               ),
                        //               Expanded(
                        //                 flex: 3,
                        //                 child: Container(
                        //                   child: Text("Price", textAlign: TextAlign.center, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                 ),
                        //               ),
                        //               Expanded(
                        //                 flex: 2,
                        //                 child: Container(
                        //                   child: Text("Companies", textAlign: TextAlign.end, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                 ),
                        //               )
                        //             ]),
                        //             Divider(thickness: 2),
                        //             for (var i = 0; i < 100; i++)
                        //               Column(
                        //                 children: [
                        //                   InkWell(
                        //                     onTap: () {
                        //                       showModalBottomSheet(
                        //                           context: context,
                        //                           isDismissible: true,
                        //                           backgroundColor: Colors.transparent,
                        //                           builder: (context) => Padding(
                        //                                 padding: const EdgeInsets.all(8.0),
                        //                                 child: Card(
                        //                                   child: Padding(
                        //                                     padding: const EdgeInsets.all(8.0),
                        //                                     child: Column(
                        //                                       children: [
                        //                                         Row(
                        //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                           children: [
                        //                                             Row(
                        //                                               children: [
                        //                                                 Text("NHPC", style: Utils.fonts(size: 18.0)),
                        //                                               ],
                        //                                             ),
                        //                                             Container(
                        //                                                 decoration: BoxDecoration(
                        //                                                     color: Utils.lightGreenColor.withOpacity(0.5), borderRadius: BorderRadius.circular(23.0), border: Border.all()),
                        //                                                 child: Padding(
                        //                                                   padding: const EdgeInsets.all(8.0),
                        //                                                   child: Text("Close", style: Utils.fonts(size: 15.0)),
                        //                                                 )),
                        //                                           ],
                        //                                         ),
                        //                                         Divider(
                        //                                           thickness: 2,
                        //                                         ),
                        //                                         Row(children: [
                        //                                           Icon(Icons.abc),
                        //                                           SizedBox(width: 10),
                        //                                           Text("View Detailed Quote",
                        //                                               style: Utils.fonts(
                        //                                                 size: 18.0,
                        //                                               )),
                        //                                         ]),
                        //                                         SizedBox(height: 10),
                        //                                         InkWell(
                        //                                           onTap: () {
                        //                                             if (isCompareActive == true)
                        //                                               isCompareActive = false;
                        //                                             else if (isCompareActive == false) isCompareActive = true;
                        //
                        //                                             setState(() {});
                        //
                        //                                             Navigator.pop(context);
                        //                                           },
                        //                                           child: Row(children: [
                        //                                             Icon(Icons.abc),
                        //                                             SizedBox(width: 10),
                        //                                             Text("Compare with Adani Green",
                        //                                                 style: Utils.fonts(
                        //                                                   size: 18.0,
                        //                                                 )),
                        //                                           ]),
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ));
                        //                     },
                        //                     child: Row(children: [
                        //                       Expanded(
                        //                         flex: 5,
                        //                         child: Row(
                        //                           children: [
                        //                             Padding(
                        //                               padding: const EdgeInsets.only(right: 4.0),
                        //                               child: SvgPicture.asset("assets/appImages/add.svg", height: 25, width: 25),
                        //                             ),
                        //                             Text("NHPC", style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       Expanded(
                        //                         flex: 3,
                        //                         child: Container(
                        //                           child: Text("2330.9", textAlign: TextAlign.center, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                         ),
                        //                       ),
                        //                       Expanded(
                        //                         flex: 2,
                        //                         child: Row(
                        //                           children: [
                        //                             SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //                             SizedBox(width: 10),
                        //                             Text("NHPC", style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                           ],
                        //                         ),
                        //                       )
                        //                     ]),
                        //                   ),
                        //                   Divider(thickness: 2),
                        //                 ],
                        //               ),
                        //             SizedBox(
                        //               height: MediaQuery.of(context).size.height * 0.15,
                        //             ),
                        //           ],
                        //         ),
                        //       ))
                        //     : SingleChildScrollView(
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Column(children: [
                        //             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //               Container(
                        //                   decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(15.0)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 28.0),
                        //                     child: Column(
                        //                       children: [
                        //                         Row(children: [
                        //                           Text("ADANIGREEN",
                        //                               style: Utils.fonts(
                        //                                 size: 12.0,
                        //                                 fontWeight: FontWeight.w700,
                        //                               )),
                        //                           Container(
                        //                             width: MediaQuery.of(context).size.width * 0.09,
                        //                           )
                        //                         ]),
                        //                         SizedBox(height: 10),
                        //                         Row(children: [
                        //                           Text("1644.34",
                        //                               style: Utils.fonts(
                        //                                 size: 12.0,
                        //                                 fontWeight: FontWeight.w700,
                        //                               )),
                        //                           Padding(
                        //                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //                             child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //                           ),
                        //                           Text("23.44%", style: Utils.fonts(size: 12.0, color: Utils.lightGreenColor)),
                        //                         ])
                        //                       ],
                        //                     ),
                        //                   )),
                        //               Container(
                        //                   decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(15.0)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 28.0),
                        //                     child: Column(
                        //                       children: [
                        //                         Row(children: [
                        //                           Text("ADANIGREEN",
                        //                               style: Utils.fonts(
                        //                                 size: 12.0,
                        //                                 fontWeight: FontWeight.w700,
                        //                               )),
                        //                           Container(
                        //                             width: MediaQuery.of(context).size.width * 0.09,
                        //                           )
                        //                         ]),
                        //                         SizedBox(height: 10),
                        //                         Row(children: [
                        //                           Text("1644.34",
                        //                               style: Utils.fonts(
                        //                                 size: 12.0,
                        //                                 fontWeight: FontWeight.w700,
                        //                               )),
                        //                           Padding(
                        //                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //                             child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                        //                           ),
                        //                           Text("23.44%", style: Utils.fonts(size: 12.0, color: Utils.lightGreenColor)),
                        //                         ])
                        //                       ],
                        //                     ),
                        //                   )),
                        //             ]),
                        //             SizedBox(height: 10),
                        //             Container(height: MediaQuery.of(context).size.width * 0.30, decoration: BoxDecoration(border: Border.all())),
                        //             Divider(thickness: 2),
                        //             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //               Expanded(
                        //                 flex: 2,
                        //                 child: Row(children: [
                        //                   DropdownButton<String>(
                        //                     value: peersDropDown,
                        //                     underline: SizedBox.shrink(),
                        //                     icon: RotatedBox(
                        //                       quarterTurns: 2,
                        //                       child: Row(
                        //                         children: [
                        //                           SizedBox(
                        //                             width: 10,
                        //                           ),
                        //                           SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     elevation: 16,
                        //                     style: Utils.fonts(
                        //                       color: Utils.primaryColor,
                        //                     ),
                        //                     onChanged: (String value) {
                        //                       var peersValue;
                        //                       // This is called when the user selects an item.
                        //                       setState(() {
                        //                         peersDropDown = value;
                        //                         if (dropdownValue == "Technicals") {
                        //                           peersValue = "Fundamentals";
                        //                         } else if (dropdownValue == "Fundamentals") {
                        //                           peersValue = "Technicals";
                        //                         }
                        //                       });
                        //                     },
                        //                     items: peersDropDownItems.map<DropdownMenuItem<String>>((String value) {
                        //                       return DropdownMenuItem<String>(
                        //                         value: value,
                        //                         child: Text(value),
                        //                       );
                        //                     }).toList(),
                        //                   ),
                        //                 ]),
                        //               ),
                        //               Expanded(
                        //                 flex: 1,
                        //                 child: Text("ADANI", textAlign: TextAlign.end, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //               ),
                        //               Expanded(
                        //                 flex: 1,
                        //                 child: Text("NHPC", textAlign: TextAlign.end, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //               ),
                        //             ]),
                        //             Divider(thickness: 2),
                        //             peersDropDown == "Technicals"
                        //                 ? Column(children: [
                        //                     for (var i = 0; i < 4; i++)
                        //                       Column(
                        //                         children: [
                        //                           Padding(
                        //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //                             child: Row(children: [
                        //                               Expanded(
                        //                                 flex: 2,
                        //                                 child: Container(
                        //                                   child: Text("Mkt Cap", style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                                 ),
                        //                               ),
                        //                               Expanded(
                        //                                 flex: 1,
                        //                                 child: Text("1.75L Cr", textAlign: TextAlign.end, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                               ),
                        //                               Expanded(
                        //                                 flex: 1,
                        //                                 child: Text("4.20 L Cr", textAlign: TextAlign.end, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                               ),
                        //                             ]),
                        //                           ),
                        //                           Divider(thickness: 1),
                        //                         ],
                        //                       ),
                        //                     SizedBox(height: MediaQuery.of(context).size.height * 0.15)
                        //                   ])
                        //                 : Column(
                        //                     children: [
                        //                       for (var i = 0; i < 10; i++)
                        //                         Column(
                        //                           children: [
                        //                             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //                               Expanded(
                        //                                 flex: 1,
                        //                                 child: Container(
                        //                                   decoration: BoxDecoration(),
                        //                                   child: Text("5 DMA", style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                                 ),
                        //                               ),
                        //                               Expanded(
                        //                                 flex: 2,
                        //                                 child: Container(
                        //                                   decoration: BoxDecoration(
                        //                                     color: Colors.orange.withOpacity(0.2),
                        //                                   ),
                        //                                   child: Padding(
                        //                                     padding: const EdgeInsets.all(8.0),
                        //                                     child: Text("1655.99", textAlign: TextAlign.center, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                        //                               Expanded(
                        //                                 flex: 2,
                        //                                 child: Container(
                        //                                   decoration: BoxDecoration(
                        //                                     color: Colors.orange.withOpacity(0.2),
                        //                                   ),
                        //                                   child: Padding(
                        //                                     padding: const EdgeInsets.all(8.0),
                        //                                     child: Text("1655.99", textAlign: TextAlign.center, style: Utils.fonts(size: 12.0, color: Utils.greyColor)),
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             ]),
                        //                             SizedBox(height: 10)
                        //                           ],
                        //                         ),
                        //                       SizedBox(height: MediaQuery.of(context).size.height * 0.15)
                        //                     ],
                        //                   )
                        //           ]),
                        //         ),
                        //       )
                        Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButton:
            extendBody: true,
            bottomSheet: widget.isFromDashboard
                ? SizedBox.shrink()
                : Container(
                    height: 80,
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
                          child: Row(
                            children: [
                              // Expanded(
                              //   flex: 3,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       Row(
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Padding(
                              //                   padding: const EdgeInsets.only(left: 8.0),
                              //                   child: InkWell(
                              //                     onTap: () {
                              //                       setState(() {
                              //                         if (flag == 1) {
                              //                           flag = 0;
                              //                           Dataconstants.scripInfoProduct = '';
                              //                         } else {
                              //                           flag = 1;
                              //                           Dataconstants.scripInfoProduct = 'NRML';
                              //                         }
                              //                       });
                              //                     },
                              //                     child: flag == 1
                              //                         ? SvgPicture.asset(
                              //                             "assets/appImages/checkbox_circle_blue.svg",
                              //                             height: 20,
                              //                             width: 20,
                              //                           )
                              //                         : Container(
                              //                             height: 20,
                              //                             width: 20,
                              //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Utils.greyColor)),
                              //                             child: Text(""),
                              //                           ),
                              //                   )),
                              //               GestureDetector(
                              //                 onTap: () {
                              //                   setState(() {
                              //                     if (flag == 1) {
                              //                       flag = 0;
                              //                       Dataconstants.scripInfoProduct = '';
                              //                     } else {
                              //                       flag = 1;
                              //                       Dataconstants.scripInfoProduct = 'NRML';
                              //                     }
                              //                   });
                              //                 },
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.only(left: 8.0),
                              //                   child: Text(
                              //                     "NRML",
                              //                     style: Utils.fonts(color: Utils.greyColor),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)
                              //             Row(
                              //               children: [
                              //                 Padding(
                              //                     padding: const EdgeInsets.only(left: 8.0),
                              //                     child: InkWell(
                              //                       onTap: () {
                              //                         setState(() {
                              //                           if (flag == 2) {
                              //                             flag = 0;
                              //                             Dataconstants.scripInfoProduct = '';
                              //                           } else {
                              //                             flag = 2;
                              //                             Dataconstants.scripInfoProduct = 'CNC';
                              //                           }
                              //                         });
                              //                       },
                              //                       child: flag == 2
                              //                           ? SvgPicture.asset(
                              //                               "assets/appImages/checkbox_circle_blue.svg",
                              //                               height: 20,
                              //                               width: 20,
                              //                             )
                              //                           : Container(
                              //                               height: 20,
                              //                               width: 20,
                              //                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Utils.greyColor)),
                              //                               child: Text(""),
                              //                             ),
                              //                     )),
                              //                 GestureDetector(
                              //                   onTap: () {
                              //                     setState(() {
                              //                       if (flag == 2) {
                              //                         flag = 0;
                              //                         Dataconstants.scripInfoProduct = '';
                              //                       } else {
                              //                         flag = 2;
                              //                         Dataconstants.scripInfoProduct = 'CNC';
                              //                       }
                              //                     });
                              //                   },
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.only(left: 8.0),
                              //                     child: Text(
                              //                       "CNC",
                              //                       style: Utils.fonts(color: Utils.greyColor),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           Row(
                              //             children: [
                              //               Padding(
                              //                   padding: const EdgeInsets.only(left: 8.0),
                              //                   child: InkWell(
                              //                     onTap: () {
                              //                       setState(() {
                              //                         if (flag == 3) {
                              //                           flag = 0;
                              //                           Dataconstants.scripInfoProduct = '';
                              //                         } else {
                              //                           flag = 3;
                              //                           Dataconstants.scripInfoProduct = 'MIS';
                              //                         }
                              //                       });
                              //                     },
                              //                     child: flag == 3
                              //                         ? SvgPicture.asset(
                              //                             "assets/appImages/checkbox_circle_blue.svg",
                              //                             height: 20,
                              //                             width: 20,
                              //                           )
                              //                         : Container(
                              //                             height: 20,
                              //                             width: 20,
                              //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Utils.greyColor)),
                              //                             child: Text(""),
                              //                           ),
                              //                   )),
                              //               GestureDetector(
                              //                 onTap: () {
                              //                   setState(() {
                              //                     if (flag == 3) {
                              //                       flag = 0;
                              //                       Dataconstants.scripInfoProduct = '';
                              //                     } else {
                              //                       flag = 3;
                              //                       Dataconstants.scripInfoProduct = 'MIS';
                              //                     }
                              //                   });
                              //                 },
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.only(left: 8.0),
                              //                   child: Text(
                              //                     "MIS",
                              //                     style: Utils.fonts(color: Utils.greyColor),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           if (model.exchCategory == ExchCategory.nseEquity)
                              //             Row(
                              //               children: [
                              //                 Padding(
                              //                     padding: const EdgeInsets.only(left: 8.0),
                              //                     child: InkWell(
                              //                       onTap: () {
                              //                         setState(() {
                              //                           if (flag == 4) {
                              //                             flag = 0;
                              //                             Dataconstants.scripInfoProduct = '';
                              //                           } else {
                              //                             flag = 4;
                              //                             Dataconstants.scripInfoProduct = 'MTF';
                              //                           }
                              //                         });
                              //                       },
                              //                       child: flag == 4
                              //                           ? SvgPicture.asset(
                              //                         "assets/appImages/checkbox_circle_blue.svg",
                              //                         height: 20,
                              //                         width: 20,
                              //                       )
                              //                           : Container(
                              //                         height: 20,
                              //                         width: 20,
                              //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Utils.greyColor)),
                              //                         child: Text(""),
                              //                       ),
                              //                     )),
                              //                 GestureDetector(
                              //                   onTap: () {
                              //                     setState(() {
                              //                       if (flag == 4) {
                              //                         flag = 0;
                              //                         Dataconstants.scripInfoProduct = '';
                              //                       } else {
                              //                         flag = 4;
                              //                         Dataconstants.scripInfoProduct = 'MTF';
                              //                       }
                              //                     });
                              //                   },
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.only(left: 8.0),
                              //                     child: Text(
                              //                       "MTF",
                              //                       style: Utils.fonts(color: Utils.greyColor),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //         ],
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       Container(
                              //         height: MediaQuery.of(context).size.height * 0.05,
                              //         child: Row(
                              //           children: [
                              //             Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(right: 30.0, left: 8.0),
                              //                 child: TextField(
                              //                     keyboardType: TextInputType.number,
                              //                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              //                     controller: _qtyController,
                              //                     focusNode: qtyFocus,
                              //                     maxLength: 10,
                              //                     onSubmitted: (_) {
                              //                       qtyFocus.unfocus();
                              //                     },
                              //                     textInputAction: TextInputAction.done,
                              //                     decoration: InputDecoration(
                              //                       counterText: "",
                              //                       contentPadding: EdgeInsets.only(top: 30.0, left: 5),
                              //                       border: OutlineInputBorder(),
                              //                       hintStyle: TextStyle(),
                              //                       hintText: 'Quantity',
                              //                     )),
                              //               ),
                              //             ),
                              //             Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(right: 8.0),
                              //                 child: TextField(
                              //                     focusNode: priceFocus,
                              //                     onSubmitted: (_) {
                              //                       priceFocus.unfocus();
                              //                     },
                              //                     textInputAction: TextInputAction.done,
                              //                     keyboardType: TextInputType.number,
                              //                     maxLength: 10,
                              //                     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                              //                     controller: _priceController,
                              //                     decoration: InputDecoration(
                              //                       contentPadding: EdgeInsets.only(top: 30.0, left: 5),
                              //                       border: OutlineInputBorder(),
                              //                       counterText: "",
                              //                       hintText: 'Price',
                              //                       hintStyle: Utils.fonts(color: Utils.greyColor),
                              //                       // suffix: Container(
                              //                       //   color: Utils.primaryColor.withOpacity(0.2),
                              //                       //   child: Text(
                              //                       //     "Market",
                              //                       //     style: Utils.fonts(color: Utils.primaryColor),
                              //                       //   ),
                              //                       // )
                              //                     )),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    GestureDetector(
                                      onTap: () => orderNavigate(false),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width * 0.45,
                                          height: MediaQuery.of(context).size.width * 0.10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: Utils.mediumGreenColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "BUY",
                                              style: Utils.fonts(color: Utils.whiteColor),
                                            ),
                                          )),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    GestureDetector(
                                      onTap: () => orderNavigate(true),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width * 0.45,
                                          height: MediaQuery.of(context).size.width * 0.10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: Utils.brightRedColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "SELL",
                                              style: Utils.fonts(color: Utils.whiteColor),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ));
  }

  Widget ScripBoardMeet() {
    return Column(
      children: [
        for (var i = 0; i < 7; i++)
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TATAMOTORS", style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.blackColor.withOpacity(0.8))),
                  Text("12 Jan, 2022", style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.blackColor.withOpacity(0.8))),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Agenda", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                      Text("Quaterly Results", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[350],
            ),
          ]),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.060,
                width: MediaQuery.of(context).size.width * 0.060,
                child: Image.asset(
                  "assets/appImages/markets/bellSmall.svg",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "This is all we have for you today",
                style: Utils.fonts(color: Utils.greyColor),
              ),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
        ),
      ],
    );
  }

  Widget ScripSplits() {
    return Obx(() {
      return Column(
        children: [
          CompanyQuoteSplits.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : CompanyQuoteSplits.getEventsSplitsListItems.length <= 0
                  ? Center(child: Text("no data available", style: Utils.fonts()))
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: CompanyQuoteSplits.getEventsSplitsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("TATAMOTORS", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    Text("10:5", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Ex-Split", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                        Text("12 Mar, 22", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Old FV", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                        Text("12 Mar, 22", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("New FV", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                        Text("5.90%", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.darkGreenColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[350],
                              ),
                            ]);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.060,
                                width: MediaQuery.of(context).size.width * 0.060,
                                child: Image.asset(
                                  "assets/appImages/markets/bellSmall.svg",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "This is all we have for you today",
                                style: Utils.fonts(color: Utils.greyColor),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.20,
                        ),
                      ],
                    ),
        ],
      );
    });
  }

  Widget ScripRights() {
    return Obx(() {
      return CompanyQuoteRightsController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : CompanyQuoteRightsController.companyQuoteRightsItems.length <= 0
              ? Center(child: Text("No Data Available", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.blackColor)))
              : Column(
                  children: [
                    ListView.builder(
                      itemCount: CompanyQuoteRightsController.companyQuoteRightsItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ex-Right", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(DateUtil.getAnyFormattedExchDate(widget.model.lastTradeTime, 'dd MMMM, yyyy'),
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Ratio", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(CompanyQuoteRightsController.companyQuoteRightsItems[index].rightsRatio,
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Premium", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(CompanyQuoteRightsController.companyQuoteRightsItems[index].premium.toStringAsFixed(2),
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.darkGreenColor)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[350],
                          ),
                        ]);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.060,
                            width: MediaQuery.of(context).size.width * 0.060,
                            child: Image.asset(
                              "assets/appImages/markets/bellSmall.png",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "This is all we have for you today",
                            style: Utils.fonts(color: Utils.greyColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                    ),
                  ],
                );
    });
  }

  Widget ScripBonus() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Utils.primaryColor.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "100 shares bought in 2004, would have become 3000 shares today  past bonus allotment",
                textAlign: TextAlign.justify,
                style: Utils.fonts(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(width: MediaQuery.of(context).size.width * 0.4, child: Text("Announcement Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text("Ex-Bonus", textAlign: TextAlign.center, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
              Container(width: MediaQuery.of(context).size.width * 0.2, child: Text("Rate", textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
            ],
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.grey[350],
        ),
        Obx(() {
          return CompanyQuoteRightsController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : CompanyQuoteBonusController.companyQuoteBonusItems.length <= 0
                  ? Center(child: Text("No Data Available", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.blackColor)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: CompanyQuoteBonusController.companyQuoteBonusItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: Text(CompanyQuoteBonusController.companyQuoteBonusItems[index].bonusDate.toString().split(" ")[0],
                                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    child: Text(CompanyQuoteBonusController.companyQuoteBonusItems[index].bonusDate.toString().split(" ")[0],
                                        textAlign: TextAlign.center, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text("1:1", textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey))),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[350],
                          ),
                        ]);
                      },
                    );
        }),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.060,
                width: MediaQuery.of(context).size.width * 0.060,
                child: Image.asset(
                  "assets/appImages/markets/bellSmall.svg",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "This is all we have for you today",
                style: Utils.fonts(color: Utils.greyColor),
              ),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
        ),
      ],
    );
  }

  Widget ScripEventsDividend() {
    return Column(children: [
      Obx(() {
        return CompanyQuoteDividendController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : CompanyQuoteDividendController.getEventsDividendListItems.isEmpty
                ? Text("No Data Available")
                : Column(children: [
                    ListView.builder(
                      itemCount: CompanyQuoteBonusController.companyQuoteBonusItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TCS", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                Text("12.50 / share", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ex Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Text("12 Mar, 22", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Record Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Text("12 Mar, 22", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Div Yield", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                    Text("5.90%", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.darkGreenColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[350],
                          ),
                        ]);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]);
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.060,
              width: MediaQuery.of(context).size.width * 0.060,
              child: Image.asset(
                "assets/appImages/markets/bellSmall.svg",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "This is all we have for you today",
              style: Utils.fonts(color: Utils.greyColor),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 110,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Review your order",
                                          style: Utils.fonts(size: 18.0),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 2,
                                                ),
                                                color: Colors.green.withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                              child: Text(
                                                "CLOSE",
                                                style: Utils.fonts(size: 14.0, color: Utils.blackColor),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'ORDER VALUE',
                                      style: Utils.fonts(size: 14.0, color: Utils.lightGreyColor),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Available Margin',
                                          style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'Required Margin',
                                          style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹ 2,32,749.50',
                                          style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '₹ 62,749.50',
                                          style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Margin Utilise", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                            Text("₹1,000.0", style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Quantity", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Product", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),

                                    // if (widget.orderType=="STOP LOSS")
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Trigger Price",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.slTriggerPrice==""?"0.00":widget.slTriggerPrice}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.dislosedQty.isNotEmpty && widget.dislosedQty!='0' && widget.dislosedQty!='')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Disclosed Qty",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text(widget.dislosedQty,
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.validty.isNotEmpty)
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Order Validity",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text(widget.validty,
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.coverTriggerPrice.isNotEmpty)
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Cover Trigger Price",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text(widget.coverTriggerPrice,
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.orderType == 'COVER')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Buy Range",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.buyRange==""?"0.00":widget.buyRange}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.orderType == 'COVER')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Sell Range",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.sellRange==""?"0.00":widget.sellRange}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.afterMarketOrder)
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("After Market Order",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text(widget.afterMarketOrder ? "Yes" : "No",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.orderType=='BRACKET')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Square Off",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.squareOff==""?"0.00":widget.squareOff}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.orderType=='BRACKET')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Bracket Stop Loss",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.boStopLoss==""?"0.00":widget.boStopLoss}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.orderType=='BRACKET')
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Trail Stop Loss",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text('${widget.trailStopLoss==""?"0.00":widget.trailStopLoss}',
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (widget.isAdvanced)
                                    //   Column(
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text("Order",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Utils.greyColor)),
                                    //           Text("${widget.orderType}",
                                    //               style: Utils.fonts(
                                    //                   size: 12.0, color: Utils.blackColor))
                                    //         ],
                                    //       ),
                                    //       SizedBox(
                                    //         height: 10,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if(widget.orderType=="BRACKET")
                                    // Column(
                                    //   children: [
                                    //     Row(
                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         Text("Book Profit",
                                    //             style: Utils.fonts(
                                    //                 size: 12.0,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 color: Utils.greyColor)),
                                    //         Text("₹1,000.0",
                                    //             style: Utils.fonts(
                                    //                 size: 12.0, color: Utils.blackColor))
                                    //       ],
                                    //     ),
                                    //     SizedBox(
                                    //       height: 10,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        child: Text(
          "What is Dividend ?",
          style: Utils.fonts(color: Utils.primaryColor),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
      ),
    ]);
  }

  Widget EquityHorizontalGraphs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        color: Utils.primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "March",
                          style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "3,46,58,000",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "(+65,323)",
                          style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                backgroundColor: Utils.greyColor.withOpacity(0.5),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Utils.primaryColor,
                                ),
                                value: 0.8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "94.56%",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "April",
                          style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "3,46,700",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "(+65)",
                          style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                backgroundColor: Utils.greyColor.withOpacity(0.5),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Utils.primaryColor,
                                ),
                                value: 0.8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "94.56%",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "May",
                          style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "300",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "(+65,323)",
                          style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                backgroundColor: Utils.greyColor.withOpacity(0.5),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Utils.primaryColor,
                                ),
                                value: 0.8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "94.56%",
                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget EquityVerticalChart() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Most Active Options",
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      "CALLS",
                      style: Utils.fonts(size: 15.0, color: Utils.greyColor.withOpacity(0.7)),
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.2)), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      "PUTS",
                      style: Utils.fonts(size: 15.0, color: Utils.greyColor.withOpacity(0.7)),
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(height: 130, width: 500, child: BarChartWidget()),
        ),
      ],
    );
  }

  Widget EquityMarketData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Open",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Close",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Volume",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AutoSizeText(
                // "Market cap",
                'LTQ  ',
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Observer(builder: (context) {
                return Text(
                  model.exch == "C" ? model.open.toStringAsFixed(4) : model.open.toStringAsFixed(2),
                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                );
              }),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    model.exch == "C" ? model.close.toStringAsFixed(4) : model.close.toStringAsFixed(2),
                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                  );
                })),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    model.exch == "C" ? model.exchQty.toStringAsFixed(4) : model.exchQty.toStringAsFixed(2),
                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                  );
                })),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    model.lastTickQtyText,
                    // model.close.toStringAsFixed(2),
                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                  );
                })),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "ATP",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "VWAP",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Lower Cir.",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Upper Cir.",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                model.avgTradePrice.toStringAsFixed(model.precision),
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "--",
                // model.v,
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    model.exch == "C" ? model.lowerCktLimit.toStringAsFixed(2) : model.lowerCktLimit.toStringAsFixed(2),
                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                  );
                })),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    model.exch == "C" ? model.upperCktLimit.toStringAsFixed(4) : model.upperCktLimit.toStringAsFixed(2),
                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),
                  );
                }))
          ],
        ),
      ],
    );
  }

  Widget FuturesMarketData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Open",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Close",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Volume",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "OI",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "OI Chg",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Prem / Disc",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "ATP",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Lot Size",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Lower Circuit",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Upper Cir",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "OI Chg%",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Days to Expire",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.8), size: 13.0),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget gradientBars(bool index) {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.50,
          width: index == false ? MediaQuery.of(context).size.width * 0.60 : MediaQuery.of(context).size.width,
          // Your gradient bars here
        ),
        (model.ofisType == 1 || model.ofisType == 1)
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Utils.darkGreenColor, Utils.lightGreenColor, Utils.whiteColor],
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "S",
                                style: Utils.fonts(size: 20.0, color: Utils.whiteColor),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.brown.withOpacity(0.5),
                                    Utils.brightRedColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "W",
                                style: Utils.fonts(size: 20.0, color: Utils.whiteColor),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.orange.withOpacity(0.7),
                                    Colors.orange.withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "O",
                                style: Utils.fonts(size: 20.0, color: Utils.whiteColor),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.indigo,
                                    Colors.white,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "T",
                                style: Utils.fonts(size: 20.0, color: Utils.whiteColor),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }

  Widget FutureOpenInterestAnalysis() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Open Interest Analysis",
                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Container(
                color: Utils.containerColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Long Buildup', style: Utils.fonts(color: Utils.brightGreenColor, fontWeight: FontWeight.w700)),
                        TextSpan(text: ' is seen in March expiry  with Ol addition of 65 lakh', style: TextStyle(color: Utils.greyColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget EquityPeersRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Peers",
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 20,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Utils.containerColor,
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "NHPC",
                                      style: Utils.fonts(fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "NSE",
                                          style: Utils.fonts(size: 10.0, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment : MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "27.95",
                                      style: Utils.fonts(fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(
                                      "assets/appImages/inverted_rectangle.svg",
                                      color: Utils.brightGreenColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "27.95%",
                                      style: Utils.fonts(fontWeight: FontWeight.w700, color: Utils.mediumGreenColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/appImages/plus.svg",
                                  color: Utils.primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Compare", style: Utils.fonts(color: Utils.greyColor))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget EquityFinancials() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (pnlExpanded == true) {
                      pnlExpanded = false;
                    } else if (pnlExpanded == false) {
                      pnlExpanded = true;
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Profit & Loss",
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    "assets/appImages/bar.svg",
                    color: Utils.primaryColor,
                    height: 15,
                    width: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Text(
                //       "Standalone",
                //       style: Utils.fonts(
                //         color: Utils.primaryColor,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                //   ],
                // ),

                DropdownButton<String>(
                  value: standAloneAndConsolidatedPLDropDownvalue,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      standAloneAndConsolidatedPLDropDownvalue = value;
                    });
                  },
                  items: standAloneAndConsolidated.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                DropdownButton<String>(
                  value: dropdownValue,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value;
                      if (dropdownValue == "2017") {
                        yearResponse = "Y201712";
                      } else if (dropdownValue == "2018") {
                        yearResponse = "Y201812";
                      } else if (dropdownValue == "2019") {
                        yearResponse = "Y201912";
                      } else if (dropdownValue == "2020") {
                        yearResponse = "Y202012";
                      } else if (dropdownValue == "2021") {
                        yearResponse = "Y202112";
                      }
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Text(
                      "YoY",
                      style: Utils.fonts(
                        color: Utils.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                  ],
                )
              ],
            ),
          ),
          pnlExpanded == true
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            physics: CustomTabBarScrollPhysics(),
                            itemCount: ProfitAndLossController.getProfitAndLossDetailsListItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          ProfitAndLossController.getProfitAndLossDetailsListItems[index].columnname.toString(),
                                          style: Utils.fonts(
                                            color: Utils.greyColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          //zzzz
                                          dropdownValue == "2017"
                                              ? ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201712.toStringAsFixed(3)
                                              : dropdownValue == "2018"
                                                  ? ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201812.toStringAsFixed(3)
                                                  : dropdownValue == "2019"
                                                      ? ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201912.toStringAsFixed(3)
                                                      : dropdownValue == "2020"
                                                          ? ProfitAndLossController.getProfitAndLossDetailsListItems[index].y202012.toStringAsFixed(3)
                                                          : ProfitAndLossController.getProfitAndLossDetailsListItems[index].y202112.toStringAsFixed(3),
                                          textAlign: TextAlign.center,
                                          style: Utils.fonts(
                                            color: Utils.greyColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Text(
                                              dropdownValue == "2017"
                                                  ? "-"
                                                  : dropdownValue == "2018"
                                                      ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201812 /
                                                              ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201712 *
                                                              100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : dropdownValue == "2019"
                                                          ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201912 /
                                                                  ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201812 *
                                                                  100)
                                                              .toStringAsFixed(3)
                                                              .toString())
                                                          : dropdownValue == "2020"
                                                              ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[index].y202012 /
                                                                      ProfitAndLossController.getProfitAndLossDetailsListItems[index].y201912 *
                                                                      100)
                                                                  .toStringAsFixed(3)
                                                                  .toString())
                                                              : "-",
                                              style: Utils.fonts(
                                                color: Utils.mediumGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20)
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: CustomTabBarScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Sales",
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      //zzzz
                                      dropdownValue == "2017"
                                          ? ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201712.toStringAsFixed(3)
                                          : dropdownValue == "2018"
                                              ? ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201812.toStringAsFixed(3)
                                              : dropdownValue == "2019"
                                                  ? ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201912.toStringAsFixed(3)
                                                  : dropdownValue == "2020"
                                                      ? ProfitAndLossController.getProfitAndLossDetailsListItems[15].y202012.toStringAsFixed(3)
                                                      : ProfitAndLossController.getProfitAndLossDetailsListItems[15].y202112.toStringAsFixed(3),
                                      textAlign: TextAlign.center,
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          dropdownValue == "2017"
                                              ? "-"
                                              : dropdownValue == "2018"
                                                  ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201812 / ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201712 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValue == "2019"
                                                      ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201912 /
                                                              ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201812 *
                                                              100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : dropdownValue == "2020"
                                                          ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[15].y202012 /
                                                                  ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201912 *
                                                                  100)
                                                              .toStringAsFixed(3)
                                                              .toString())
                                                          : "-",
                                          style: Utils.fonts(
                                            color: Utils.mediumGreenColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Expenses",
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      //zzzz
                                      dropdownValue == "2017"
                                          ? ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201712.toStringAsFixed(3)
                                          : dropdownValue == "2018"
                                              ? ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201812.toStringAsFixed(3)
                                              : dropdownValue == "2019"
                                                  ? ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201912.toStringAsFixed(3)
                                                  : dropdownValue == "2020"
                                                      ? ProfitAndLossController.getProfitAndLossDetailsListItems[1].y202012.toStringAsFixed(3)
                                                      : ProfitAndLossController.getProfitAndLossDetailsListItems[1].y202112.toStringAsFixed(3),
                                      textAlign: TextAlign.center,
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          dropdownValue == "2017"
                                              ? "-"
                                              : dropdownValue == "2018"
                                                  ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201812 / ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201712 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValue == "2019"
                                                      ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201912 /
                                                              ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201812 *
                                                              100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : dropdownValue == "2020"
                                                          ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[1].y202012 /
                                                                  ProfitAndLossController.getProfitAndLossDetailsListItems[1].y201912 *
                                                                  100)
                                                              .toStringAsFixed(3)
                                                              .toString())
                                                          : "-",
                                          style: Utils.fonts(
                                            color: Utils.mediumGreenColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "PAT",
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      //zzzz
                                      dropdownValue == "2017"
                                          ? ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201712.toStringAsFixed(3)
                                          : dropdownValue == "2018"
                                              ? ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201812.toStringAsFixed(3)
                                              : dropdownValue == "2019"
                                                  ? ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201912.toStringAsFixed(3)
                                                  : dropdownValue == "2020"
                                                      ? ProfitAndLossController.getProfitAndLossDetailsListItems[24].y202012.toStringAsFixed(3)
                                                      : ProfitAndLossController.getProfitAndLossDetailsListItems[24].y202112.toStringAsFixed(3),
                                      textAlign: TextAlign.center,
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          dropdownValue == "2017"
                                              ? "-"
                                              : dropdownValue == "2018"
                                                  ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201812 / ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201712 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValue == "2019"
                                                      ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201912 /
                                                              ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201812 *
                                                              100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : dropdownValue == "2020"
                                                          ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[24].y202012 /
                                                                  ProfitAndLossController.getProfitAndLossDetailsListItems[24].y201912 *
                                                                  100)
                                                              .toStringAsFixed(3)
                                                              .toString())
                                                          : "-",
                                          style: Utils.fonts(
                                            color: Utils.mediumGreenColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "EPS",
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      //zzzz
                                      dropdownValue == "2017"
                                          ? ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201712.toStringAsFixed(3)
                                          : dropdownValue == "2018"
                                              ? ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201812.toStringAsFixed(3)
                                              : dropdownValue == "2019"
                                                  ? ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201912.toStringAsFixed(3)
                                                  : dropdownValue == "2020"
                                                      ? ProfitAndLossController.getProfitAndLossDetailsListItems[36].y202012.toStringAsFixed(3)
                                                      : ProfitAndLossController.getProfitAndLossDetailsListItems[36].y202112.toStringAsFixed(3),
                                      textAlign: TextAlign.center,
                                      style: Utils.fonts(
                                        color: Utils.greyColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          dropdownValue == "2017"
                                              ? "-"
                                              : dropdownValue == "2018"
                                                  ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201812 / ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201712 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValue == "2019"
                                                      ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201912 /
                                                              ProfitAndLossController.getProfitAndLossDetailsListItems[36].y201812 *
                                                              100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : dropdownValue == "2020"
                                                          ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[36].y202012 /
                                                                  ProfitAndLossController.getProfitAndLossDetailsListItems[15].y201912 *
                                                                  100)
                                                              .toStringAsFixed(3)
                                                              .toString())
                                                          : "-",
                                          style: Utils.fonts(
                                            color: Utils.mediumGreenColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                if (balanceSheetExpanded == false) {
                  balanceSheetExpanded = true;
                } else if (balanceSheetExpanded == true) {
                  balanceSheetExpanded = false;
                }
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Row(children: [
                        Text(
                          "Balance Sheet",
                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                        ),
                      ])),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/appImages/bar.svg",
                      color: Utils.primaryColor,
                      height: 15,
                      width: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: standAloneAndConsolidatedBSDropDownvalue,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      standAloneAndConsolidatedBSDropDownvalue = value;
                    });
                  },
                  items: standAloneAndConsolidated.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: dropdownValueBalanceSheet,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValueBalanceSheet = value;
                      if (dropdownValueBalanceSheet == "2017") {
                        yearResponse = "Y201712";
                      } else if (dropdownValueBalanceSheet == "2018") {
                        yearResponse = "Y201812";
                      } else if (dropdownValueBalanceSheet == "2019") {
                        yearResponse = "Y201912";
                      } else if (dropdownValueBalanceSheet == "2020") {
                        yearResponse = "Y202012";
                      } else if (dropdownValueBalanceSheet == "2021") {
                        yearResponse = "Y202112";
                      }
                    });
                  },
                  items: list2.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Text(
                      "YoY",
                      style: Utils.fonts(
                        color: Utils.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                  ],
                )
              ],
            ),
          ),
          balanceSheetExpanded == true
              ? Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: CustomTabBarScrollPhysics(),
                          itemCount: BalanceSheetController.getBalanceSheetDetailsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        BalanceSheetController.getBalanceSheetDetailsListItems[index].columnname.toString(),
                                        style: Utils.fonts(
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dropdownValueBalanceSheet == "2017"
                                            ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201712.toStringAsFixed(3)
                                            : dropdownValueBalanceSheet == "2018"
                                                ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812.toStringAsFixed(3)
                                                : dropdownValueBalanceSheet == "2019"
                                                    ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912.toStringAsFixed(3)
                                                    : dropdownValueBalanceSheet == "2020"
                                                        ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y202012.toStringAsFixed(3)
                                                        : BalanceSheetController.getBalanceSheetDetailsListItems[index].y202112.toStringAsFixed(3),
                                        style: Utils.fonts(
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Text(
                                            dropdownValueBalanceSheet == "2017"
                                                ? "-"
                                                : dropdownValueBalanceSheet == "2018"
                                                    ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812 /
                                                            BalanceSheetController.getBalanceSheetDetailsListItems[index].y201712 *
                                                            100)
                                                        .toStringAsFixed(3)
                                                        .toString())
                                                    : dropdownValueBalanceSheet == "2019"
                                                        ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912 /
                                                                BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812 *
                                                                100)
                                                            .toStringAsFixed(3)
                                                            .toString())
                                                        : dropdownValueBalanceSheet == "2020"
                                                            ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y202012 /
                                                                    BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912 *
                                                                    100)
                                                                .toStringAsFixed(3)
                                                                .toString())
                                                            : "-",
                                            style: Utils.fonts(
                                              color: Utils.mediumGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20)
                              ],
                            );
                          },
                        )),
                    Divider(
                      color: Utils.greyColor,
                      thickness: 2,
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: CustomTabBarScrollPhysics(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Shareholder funds",
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  dropdownValueBalanceSheet == "2017"
                                      ? BalanceSheetController.getBalanceSheetDetailsListItems[5].y201712.toStringAsFixed(3)
                                      : dropdownValueBalanceSheet == "2018"
                                          ? BalanceSheetController.getBalanceSheetDetailsListItems[5].y201812.toStringAsFixed(3)
                                          : dropdownValueBalanceSheet == "2019"
                                              ? BalanceSheetController.getBalanceSheetDetailsListItems[5].y201912.toStringAsFixed(3)
                                              : dropdownValueBalanceSheet == "2020"
                                                  ? BalanceSheetController.getBalanceSheetDetailsListItems[5].y202012.toStringAsFixed(3)
                                                  : BalanceSheetController.getBalanceSheetDetailsListItems[5].y202112.toStringAsFixed(3),
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Text(
                                      dropdownValueBalanceSheet == "2017"
                                          ? "-"
                                          : dropdownValueBalanceSheet == "2018"
                                              ? ((BalanceSheetController.getBalanceSheetDetailsListItems[5].y201812 / BalanceSheetController.getBalanceSheetDetailsListItems[5].y201712 * 100)
                                                  .toStringAsFixed(3)
                                                  .toString())
                                              : dropdownValueBalanceSheet == "2019"
                                                  ? ((BalanceSheetController.getBalanceSheetDetailsListItems[5].y201912 / BalanceSheetController.getBalanceSheetDetailsListItems[5].y201812 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValueBalanceSheet == "2020"
                                                      ? ((BalanceSheetController.getBalanceSheetDetailsListItems[5].y202012 / BalanceSheetController.getBalanceSheetDetailsListItems[5].y201912 * 100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : "-",
                                      style: Utils.fonts(
                                        color: Utils.mediumGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Reserves & surplus",
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  dropdownValueBalanceSheet == "2017"
                                      ? BalanceSheetController.getBalanceSheetDetailsListItems[2].y201712.toStringAsFixed(3)
                                      : dropdownValueBalanceSheet == "2018"
                                          ? BalanceSheetController.getBalanceSheetDetailsListItems[2].y201812.toStringAsFixed(3)
                                          : dropdownValueBalanceSheet == "2019"
                                              ? BalanceSheetController.getBalanceSheetDetailsListItems[2].y201912.toStringAsFixed(3)
                                              : dropdownValueBalanceSheet == "2020"
                                                  ? BalanceSheetController.getBalanceSheetDetailsListItems[2].y202012.toStringAsFixed(3)
                                                  : BalanceSheetController.getBalanceSheetDetailsListItems[2].y202112.toStringAsFixed(3),
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Text(
                                      dropdownValueBalanceSheet == "2017"
                                          ? "-"
                                          : dropdownValueBalanceSheet == "2018"
                                              ? ((BalanceSheetController.getBalanceSheetDetailsListItems[2].y201812 / BalanceSheetController.getBalanceSheetDetailsListItems[2].y201712 * 100)
                                                  .toStringAsFixed(3)
                                                  .toString())
                                              : dropdownValueBalanceSheet == "2019"
                                                  ? ((BalanceSheetController.getBalanceSheetDetailsListItems[2].y201912 / BalanceSheetController.getBalanceSheetDetailsListItems[2].y201812 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValueBalanceSheet == "2020"
                                                      ? ((BalanceSheetController.getBalanceSheetDetailsListItems[2].y202012 / BalanceSheetController.getBalanceSheetDetailsListItems[2].y201912 * 100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : "-",
                                      style: Utils.fonts(
                                        color: Utils.mediumGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Current Assets",
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  dropdownValueBalanceSheet == "2017"
                                      ? BalanceSheetController.getBalanceSheetDetailsListItems[25].y201712.toStringAsFixed(3)
                                      : dropdownValueBalanceSheet == "2018"
                                          ? BalanceSheetController.getBalanceSheetDetailsListItems[25].y201812.toStringAsFixed(3)
                                          : dropdownValueBalanceSheet == "2019"
                                              ? BalanceSheetController.getBalanceSheetDetailsListItems[25].y201912.toStringAsFixed(3)
                                              : dropdownValueBalanceSheet == "2020"
                                                  ? BalanceSheetController.getBalanceSheetDetailsListItems[25].y202012.toStringAsFixed(3)
                                                  : BalanceSheetController.getBalanceSheetDetailsListItems[25].y202112.toStringAsFixed(3),
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Text(
                                      dropdownValueBalanceSheet == "2017"
                                          ? "-"
                                          : dropdownValueBalanceSheet == "2018"
                                              ? ((BalanceSheetController.getBalanceSheetDetailsListItems[25].y201812 / BalanceSheetController.getBalanceSheetDetailsListItems[25].y201712 * 100)
                                                  .toStringAsFixed(3)
                                                  .toString())
                                              : dropdownValueBalanceSheet == "2019"
                                                  ? ((BalanceSheetController.getBalanceSheetDetailsListItems[25].y201912 / BalanceSheetController.getBalanceSheetDetailsListItems[25].y201812 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValueBalanceSheet == "2020"
                                                      ? ((BalanceSheetController.getBalanceSheetDetailsListItems[25].y202012 / BalanceSheetController.getBalanceSheetDetailsListItems[25].y201912 * 100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : "-",
                                      style: Utils.fonts(
                                        color: Utils.mediumGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Current Liabilities",
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  dropdownValueBalanceSheet == "2017"
                                      ? BalanceSheetController.getBalanceSheetDetailsListItems[29].y201712.toStringAsFixed(3)
                                      : dropdownValueBalanceSheet == "2018"
                                          ? BalanceSheetController.getBalanceSheetDetailsListItems[29].y201812.toStringAsFixed(3)
                                          : dropdownValueBalanceSheet == "2019"
                                              ? BalanceSheetController.getBalanceSheetDetailsListItems[29].y201912.toStringAsFixed(3)
                                              : dropdownValueBalanceSheet == "2020"
                                                  ? BalanceSheetController.getBalanceSheetDetailsListItems[29].y202012.toStringAsFixed(3)
                                                  : BalanceSheetController.getBalanceSheetDetailsListItems[29].y202112.toStringAsFixed(3),
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Text(
                                      dropdownValueBalanceSheet == "2017"
                                          ? "-"
                                          : dropdownValueBalanceSheet == "2018"
                                              ? ((BalanceSheetController.getBalanceSheetDetailsListItems[29].y201812 / BalanceSheetController.getBalanceSheetDetailsListItems[29].y201712 * 100)
                                                  .toStringAsFixed(3)
                                                  .toString())
                                              : dropdownValueBalanceSheet == "2019"
                                                  ? ((BalanceSheetController.getBalanceSheetDetailsListItems[29].y201912 / BalanceSheetController.getBalanceSheetDetailsListItems[29].y201812 * 100)
                                                      .toStringAsFixed(3)
                                                      .toString())
                                                  : dropdownValueBalanceSheet == "2020"
                                                      ? ((BalanceSheetController.getBalanceSheetDetailsListItems[29].y202012 / BalanceSheetController.getBalanceSheetDetailsListItems[29].y201912 * 100)
                                                          .toStringAsFixed(3)
                                                          .toString())
                                                      : "-",
                                      style: Utils.fonts(
                                        color: Utils.mediumGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
          //Cash Flow
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                if (cashFlowExpanded == true) {
                  cashFlowExpanded = false;
                } else if (cashFlowExpanded == false) {
                  cashFlowExpanded = true;
                }
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Cash Flow",
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/appImages/bar.svg",
                        color: Utils.primaryColor,
                        height: 15,
                        width: 15,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: standAloneAndConsolidatedCSDropDownvalue,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      standAloneAndConsolidatedCSDropDownvalue = value;
                    });
                  },
                  items: standAloneAndConsolidated.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: dropdownValueCashFlow,
                  underline: SizedBox.shrink(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                      ],
                    ),
                  ),
                  elevation: 16,
                  style: Utils.fonts(
                    color: Utils.primaryColor,
                  ),
                  onChanged: (String value) {
                    var yearResponse;
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValueCashFlow = value;
                      if (dropdownValueCashFlow == "2021") {
                        yearResponse = "Y202112";
                      } else if (dropdownValueCashFlow == "2022") {
                        yearResponse = "Y202212";
                      }
                    });
                  },
                  items: listCashFlowYear.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Text(
                      "YoY",
                      style: Utils.fonts(
                        color: Utils.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                  ],
                )
              ],
            ),
          ),

          cashFlowExpanded == true
              ? Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: CashFlowController.getCashFlowListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        CashFlowController.getCashFlowListItems[index].columnname == null ? "-" : CashFlowController.getCashFlowListItems[index].columnname,
                                        style: Utils.fonts(
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dropdownValueCashFlow == "2022" ? "NA" : CashFlowController.getCashFlowListItems[30].y202112.toStringAsFixed(3),
                                        style: Utils.fonts(
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Text(
                                            "-",
                                            style: Utils.fonts(
                                              color: Utils.mediumGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20)
                              ],
                            );
                          },
                        )),
                    Divider(
                      color: Utils.greyColor,
                      thickness: 2,
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                )
              : Column(
                  children: [
                    Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Cash Flow from Operations",
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    dropdownValueCashFlow == "2022" ? "NA" : CashFlowController.getCashFlowListItems[3].y202112.toStringAsFixed(3),
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text(
                                        dropdownValueCashFlow == "2017"
                                            ? "-"
                                            : dropdownValueCashFlow == "2018"
                                                ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[30].y201812 / BalanceSheetController.getBalanceSheetDetailsListItems[30].y201712 * 100)
                                                    .toStringAsFixed(3)
                                                    .toString())
                                                : dropdownValueCashFlow == "2019"
                                                    ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[30].y201912 / BalanceSheetController.getBalanceSheetDetailsListItems[30].y201812 * 100)
                                                        .toStringAsFixed(3)
                                                        .toString())
                                                    : dropdownValueCashFlow == "2020"
                                                        ? ((ProfitAndLossController.getProfitAndLossDetailsListItems[27].y202012 /
                                                                BalanceSheetController.getBalanceSheetDetailsListItems[27].y201912 *
                                                                100)
                                                            .toStringAsFixed(3)
                                                            .toString())
                                                        : "-",
                                        style: Utils.fonts(
                                          color: Utils.mediumGreenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Cash flow from  Investing",
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    dropdownValueCashFlow == "2022" ? "NA" : CashFlowController.getCashFlowListItems[30].y202112.toStringAsFixed(3),
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text(
                                        "-",
                                        style: Utils.fonts(
                                          color: Utils.mediumGreenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Cash flow from   Financing",
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    dropdownValueCashFlow == "2022" ? "NA" : CashFlowController.getCashFlowListItems[30].y202112.toStringAsFixed(3),
                                    style: Utils.fonts(
                                      color: Utils.greyColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text(
                                        "-",
                                        style: Utils.fonts(
                                          color: Utils.mediumGreenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20)
                          ],
                        ),
                        Divider(
                          color: Utils.greyColor,
                          thickness: 2,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.13)
        ],
      ),
    );
  }

  Widget EquityImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Image.asset('assets/appImages/start_sip.png'),
    );
  }

  Widget CurrencyMarketData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Open",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Close",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Volume",
                style: Utils.fonts(color: Utils.greyColor, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Market cap",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "17.51M",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "9.68T",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "ATP",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "VWAP",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Lower Cir.",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Upper Cir.",
                style: Utils.fonts(color: Utils.greyColor.withOpacity(0.7), size: 13.0),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "1453.67",
                style: Utils.fonts(color: Utils.greyColor, fontWeight: FontWeight.w700, size: 13.0),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget OptionsMarketData() {}

  Widget CommodityMarketData() {}

  Widget Swot() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox.shrink(),
                Column(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff035243),
                                    Color(0xffb316a086),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.06,
                                ),
                                SvgPicture.asset(
                                  "assets/appImages/strength.svg",
                                  color: Utils.whiteColor,
                                  height: 50,
                                ),
                                Text("Strengths",
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                                Text(SwotController.getStrength.length.toString(),
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                              ],
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xffc23a2c),
                                    Color(0xffb3c23a2c),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.06,
                                ),
                                Image.asset(
                                  "assets/appImages/weakness.png",
                                  color: Utils.whiteColor,
                                  height: 50,
                                ),
                                Text("Weaknesses",
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                                Text(SwotController.getWeakness.length.toString(),
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                              ],
                            ))),
                      )
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffd38404),
                                    Color(0xffb3f39c11),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.06,
                                ),
                                Image.asset(
                                  "assets/appImages/opportunities.png",
                                  color: Utils.whiteColor,
                                  height: 50,
                                ),
                                Text("Opportunities",
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                                Text(SwotController.getOpportunities.length.toString(),
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                              ],
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xffd3004c7e),
                                    Color(0xffb32a7fb8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.06,
                                ),
                                Image.asset(
                                  "assets/appImages/threats.png",
                                  color: Utils.whiteColor,
                                  height: 50,
                                ),
                                Text("Threats",
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                                Text(SwotController.getThreats.length.toString(),
                                    style: Utils.fonts(
                                      color: Utils.whiteColor,
                                    )),
                              ],
                            ))),
                      )
                    ]),
                  ],
                ),
                SizedBox.shrink(),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset("assets/appImages/strength.svg"),
                      SizedBox(width: 10),
                      Text(
                        "Strengths",
                        style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/appImages/blue_dot.svg",
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "This stock has good delivery track record",
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/appImages/blue_dot.svg",
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "High Quality Products",
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/appImages/blue_dot.svg",
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "200 MW+ hydro plants",
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/appImages/blue_dot.svg",
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "Trusted and high product sales exposure",
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset("assets/appImages/weakness.png", height: 27),
                      SizedBox(width: 10),
                      Text(
                        "Weaknesses",
                        style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  for (var i = 0; i < 5; i++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/appImages/blue_dot.svg",
                                color: Utils.darkRedColor,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                  child: Text(
                                "This stock has good delivery track record",
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset("assets/appImages/opportunities.png", height: 27),
                      SizedBox(width: 10),
                      Text(
                        "Opportunities",
                        style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  for (var i = 0; i < 5; i++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/appImages/blue_dot.svg",
                                color: Colors.orange,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                  child: Text(
                                "This stock has good delivery track record",
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5))),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/appImages/threats.png"),
                      SizedBox(width: 10),
                      Text(
                        "Threats",
                        style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  for (var i = 0; i < 5; i++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/appImages/blue_dot.svg",
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                  child: Text(
                                "This stock has good delivery track record",
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 140)
          ],
        ));
  }

  Widget ShareHoldings() {
    return Obx(() {
      return ShareHoldingController.getShareHoldingDetailsListItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "Standalone",
                      style: Utils.fonts(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Promoter Holding",
                      style: Utils.fonts(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[0]["TotalPromoter_PerShares"] * 0.01),
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Utils.primaryColor.withOpacity(0.30)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "${ShareHoldingController.getShareHoldingDetailsListItems[0]["TotalPromoter_PerShares"].toStringAsFixed(2)} %",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Mutual Funds",
                      style: Utils.fonts(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[0]["PPIMF"] * 0.01),
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Utils.primaryColor.withOpacity(0.50)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "${ShareHoldingController.getShareHoldingDetailsListItems[0]["PPIMF"].toStringAsFixed(2)} %",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Domestic Institutions",
                      style: Utils.fonts(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[0]["PPMINDFIBK"] * 0.01),
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Utils.primaryColor.withOpacity(0.20)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "${ShareHoldingController.getShareHoldingDetailsListItems[0]["PPMINDFIBK"].toString()} %",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Foreign Institutions",
                      style: Utils.fonts(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[0]["PPFRINST"] * 0.01),
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Utils.primaryColor.withOpacity(0.80)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "${ShareHoldingController.getShareHoldingDetailsListItems[0]["PPFRINST"].toString()} %",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Retail and Others",
                      style: Utils.fonts(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (retailAndOthers * 0.01),
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: Utils.primaryColor.withOpacity(0.40)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "${retailAndOthers.toString()} %",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Shareholding History",
                      style: Utils.fonts(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)), border: Border.all()),
                  child: DropdownButton<String>(
                    value: list3InitialItem,
                    elevation: 16,
                    style: Utils.fonts(
                      color: Utils.primaryColor,
                    ),
                    underline: SizedBox.shrink(),
                    onChanged: (String value) {
                      var yearResponse;
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value;
                        if (dropdownValue == "Promoter Holding") {
                          list3InitialItem = "Promoter Holding";
                        } else if (dropdownValue == "Mutual Funds") {
                          list3InitialItem = "Mutual Funds";
                        } else if (dropdownValue == "Domestic Institutions") {
                          list3InitialItem = "Domestic Institutions";
                        } else if (dropdownValue == "Foreign Institutions") {
                          list3InitialItem = "Foreign Institutions";
                        } else if (dropdownValue == "Retail & Others") {
                          list3InitialItem = "Retail & Others";
                        }
                      });
                    },
                    items: list3.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Utils.primaryColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                        child: Text(
                      "MF have increased stake by 2.1% in the last 6 quarters",
                      style: Utils.fonts(),
                    )),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    height: 320,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Utils.blackColor),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      ListView.builder(
                        itemCount: ShareHoldingController.getShareHoldingDetailsListItems.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Column(
                                children: [
                                  Spacer(),
                                  Text(
                                    list3InitialItem == "Promoter Holding"
                                        ? ShareHoldingController.getShareHoldingDetailsListItems[index]["TotalPromoter_PerShares"].toStringAsFixed(2)
                                        : list3InitialItem == "Mutual Funds"
                                            ? ShareHoldingController.getShareHoldingDetailsListItems[index]["PPIMF"].toStringAsFixed(2)
                                            : list3InitialItem == "Domestic Institutions"
                                                ? ShareHoldingController.getShareHoldingDetailsListItems[index]["PPMINDFIBK"].toStringAsFixed(2)
                                                : list3InitialItem == "Foreign Institutions"
                                                    ? ShareHoldingController.getShareHoldingDetailsListItems[index]["PPFRINST"].toStringAsFixed(2)
                                                    : retailAndOthers.toString(),
                                    style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: list3InitialItem == "Promoter Holding"
                                        ? MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[index]["TotalPromoter_PerShares"] * 0.01)
                                        : list3InitialItem == "Mutual Funds"
                                            ? MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[index]["PPIMF"] * 0.01)
                                            : list3InitialItem == "Domestic Institutions"
                                                ? MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[index]["PPMINDFIBK"] * 0.01)
                                                : list3InitialItem == "Foreign Institutions"
                                                    ? MediaQuery.of(context).size.width * (ShareHoldingController.getShareHoldingDetailsListItems[index]["PPFRINST"] * 0.01)
                                                    : retailAndOthers * 0.01,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Utils.primaryColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10)
                            ],
                          );
                        },
                      )
                    ])),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ListView.builder(
                //         itemCount: ShareHoldingController.getShareHoldingDetailsListItems.length,
                //         shrinkWrap: true,
                //         scrollDirection: Axis.horizontal,
                //         itemBuilder: (BuildContext context, int index) {
                //           return Row(
                //             children: [
                //               Text(
                //                 "Dec 21",
                //                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                //               ),
                //               SizedBox(width: 10),
                //             ]
                //           );
                //         })
                //   ],
                // ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.40),
              ]));
    });
  }

  Widget BalanceSheet() {
    return Obx(() {
      return BalanceSheetController.getBalanceSheetDetailsListItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Balance Sheet",
                              style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Standalone",
                              style: Utils.fonts(
                                color: Utils.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                          ],
                        ),
                        DropdownButton<String>(
                          value: dropdownValueBalanceSheet,
                          icon: RotatedBox(
                            quarterTurns: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor),
                              ],
                            ),
                          ),
                          elevation: 16,
                          style: Utils.fonts(
                            color: Utils.primaryColor,
                          ),
                          onChanged: (String value) {
                            var yearResponse;
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value;
                              if (dropdownValue == "2017") {
                                yearResponse = "Y201712";
                              } else if (dropdownValue == "2018") {
                                yearResponse = "Y201812";
                              } else if (dropdownValue == "2019") {
                                yearResponse = "Y201912";
                              } else if (dropdownValue == "2020") {
                                yearResponse = "Y202012";
                              } else if (dropdownValue == "2021") {
                                yearResponse = "Y202112";
                              }
                            });
                          },
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              "YoY",
                              style: Utils.fonts(
                                color: Utils.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RotatedBox(quarterTurns: 2, child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg", color: Utils.primaryColor))
                          ],
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return CashFlowController.getCashFlowListItems.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.40,
                                          width: MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            itemCount: CashFlowController.getCashFlowListItems.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          CashFlowController.getCashFlowListItems[index].columnname.toString(),
                                                          style: Utils.fonts(
                                                            color: Utils.greyColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          //zzzz
                                                          dropdownValue == "2017"
                                                              ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201712.toStringAsFixed(3)
                                                              : dropdownValue == "2018"
                                                                  ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812.toStringAsFixed(3)
                                                                  : dropdownValue == "2019"
                                                                      ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912.toStringAsFixed(3)
                                                                      : dropdownValue == "2020"
                                                                          ? BalanceSheetController.getBalanceSheetDetailsListItems[index].y202012.toStringAsFixed(3)
                                                                          : BalanceSheetController.getBalanceSheetDetailsListItems[index].y202112.toStringAsFixed(3),
                                                          style: Utils.fonts(
                                                            color: Utils.greyColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(),
                                                            Text(
                                                              dropdownValue == "2017"
                                                                  ? "-"
                                                                  : dropdownValue == "2018"
                                                                      ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812 /
                                                                              BalanceSheetController.getBalanceSheetDetailsListItems[index].y201712 *
                                                                              100)
                                                                          .toStringAsFixed(3)
                                                                          .toString())
                                                                      : dropdownValue == "2019"
                                                                          ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912 /
                                                                                  BalanceSheetController.getBalanceSheetDetailsListItems[index].y201812 *
                                                                                  100)
                                                                              .toStringAsFixed(3)
                                                                              .toString())
                                                                          : dropdownValue == "2020"
                                                                              ? ((BalanceSheetController.getBalanceSheetDetailsListItems[index].y202012 /
                                                                                      BalanceSheetController.getBalanceSheetDetailsListItems[index].y201912 *
                                                                                      100)
                                                                                  .toStringAsFixed(3)
                                                                                  .toString())
                                                                              : "-",
                                                              style: Utils.fonts(
                                                                color: Utils.mediumGreenColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 20)
                                                ],
                                              );
                                            },
                                          ),
                                        )),
                                    Divider(
                                      color: Utils.greyColor,
                                      thickness: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              )
                            ],
                          );
                  })
                ],
              ),
            );
    });
  }

  marketBreadth() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Market Breadth",
                    style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: Utils.primaryColor,
                                  width: 1,
                                ),
                                top: BorderSide(
                                  color: Utils.primaryColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Utils.primaryColor,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Utils.primaryColor,
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Nifty 50",
                              style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Sensex",
                              style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections()),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "ADV: 20",
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "DEC: 30",
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Utils.primaryColor,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 60,
            title: '60%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
