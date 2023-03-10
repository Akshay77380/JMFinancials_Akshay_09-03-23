import 'package:shared_preferences/shared_preferences.dart';
import '../jmScreens/orders/OrderPlacement/order_placement_screen.dart';
import '../util/Utils.dart';
import '../widget/decimal_text.dart';
import '../model/scrip_info_model.dart';
import '../style/theme.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../widget/custom_tab_bar.dart';
import '../widget/scripdetail_future.dart';
import '../widget/scripdetail_optionChain.dart';
import '../widget/scripdetail_overview.dart';
import '../widget/watchlist_picker_card.dart';

enum ScripDetailType {
  none,
  modify,
  cancel,
  convertPosition,
  holdingAdd,
  holdingExit,
  positionAdd,
  positionExit,
  setStopLoss
}

class ScripDetailsScreen extends StatefulWidget {
  final ScripInfoModel model;
  final String comingFrom;

  ScripDetailsScreen({@required this.model, this.comingFrom});

  @override
  _ScripDetailsScreenState createState() => _ScripDetailsScreenState();
}

class _ScripDetailsScreenState extends State<ScripDetailsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  int _exchTogglePosition = 0, _newsNseCode = 0;
  List<ScripInfoModel> futures;
  List<int> optionDates;
  List<Widget> _tabs = [];
  bool modelFlipped = false;
  ScripInfoModel currentModel;
  ScripInfoModel underlyingModel;
  int currentDate = 0;
  var chartSelectedIndex = 0;
  bool addedToWatchlist = false;
  List<int> pos = [-1, -1, -1, -1];
  var algoScripname, algoExchcode, algoClose;
  bool algoFlag = false;
  bool algoFlag2 = false;
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (widget.model.exchCategory == ExchCategory.mcxFutures ||
    //       widget.model.exchCategory == ExchCategory.mcxOptions)
    //     await Dataconstants.itsClient
    //         .commodityGqtQuote(
    //             expiry: widget.model.expiryDateString,
    //             productType:
    //                 widget.model.exchCategory == ExchCategory.mcxFutures
    //                     ? 'F'
    //                     : 'O',
    //             underlying: widget.model.isecName,
    //             strike: (widget.model.strikePrice * 100).toStringAsFixed(0),
    //             optionType: widget.model.cpType == 3
    //                 ? 'C'
    //                 : widget.model.cpType == 4
    //                     ? 'P'
    //                     : '*')
    //         .then((value) {
    //       if (value != null) {
    //         // //print("value-----$value");
    //         widget.model.upperCktLimit = double.tryParse(
    //                 value['Success'][0]['security_highpricerange'].toString()) /
    //             100;
    //         widget.model.lowerCktLimit = double.tryParse(
    //                 value['Success'][0]['security_lowpricechange'].toString()) /
    //             100;
    //       }
    //     });
    // });
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _exchTogglePosition = widget.model.exch == 'N' ? 0 : 1;
    currentModel = widget.model;
    Dataconstants.itsClient
        .getChartData(timeInterval: 5, chartPeriod: 'I', model: widget.model);
    if (widget.model.alternateModel != null)
      Dataconstants.itsClient.getChartData(
          timeInterval: 5,
          chartPeriod: 'I',
          model: widget.model.alternateModel);
    if (currentModel.alternateModel == null &&
        (currentModel.exchCategory == ExchCategory.nseEquity ||
            currentModel.exchCategory == ExchCategory.bseEquity)) {
      ScripInfoModel alternateModel = CommonFunction.getBseNseMapModel(
          currentModel.name, currentModel.exchCategory);
      if (alternateModel != null)
        currentModel.addAlternateModel(alternateModel);
    }

    ///--------------------------------------
    if (Dataconstants.isAlgo == true) {
      setState(() {
        algoScripname = widget.model.name ?? "";
        algoExchcode = widget.model.exchCode ?? int.parse("");
        algoClose = widget.model.close ?? double.parse("");
        algoFlag = true;
      });
    } else {
      if (currentModel.exchCategory == ExchCategory.nseEquity ||
          currentModel.exchCategory == ExchCategory.nseFuture ||
          currentModel.exchCategory == ExchCategory.nseOptions) {
        setState(() {
          algoScripname = widget.model.name ?? "";
          algoExchcode = widget.model.exchCode ?? int.parse("");
          algoClose = widget.model.close ?? double.parse("");
          algoFlag = true;
        });
      } else if (currentModel.exchCategory == ExchCategory.bseEquity) {
        setState(() {
          if (widget.model.alternateModel == null) {
            algoScripname = widget.model.name;
            algoExchcode = widget.model.exchCode ?? int.parse("");
            algoClose = widget.model.close ?? double.parse("");
            algoFlag = true;
          } else {
            algoScripname = widget.model.alternateModel.name;
            algoExchcode =
                widget.model.alternateModel.exchCode ?? int.parse("");
            algoClose = widget.model.alternateModel.close ?? double.parse("");
            algoFlag = true;
          }
        });
      }
    }
    setState(() {
      Dataconstants.isAlgo = false;
    });

    checkIfModelInWatchlist();
    checkFutureOptions();
    checkchartSelection();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Dataconstants.iqsClient.sendScripDetailsRequest(
    //     currentModel.exch, currentModel.exchCode, false);
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          Dataconstants.iqsClient.sendMarketDepthRequest(
              widget.model.exch, widget.model.exchCode, true);
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

  checkchartSelection() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    chartSelectedIndex = pref.getInt('selectedChart') ?? 0;
    // //print("chart selected index $chartSelectedIndex");
  }

  void checkFutureOptions() {
    if (currentModel.exchCategory == ExchCategory.nseEquity ||
        currentModel.exchCategory == ExchCategory.nseFuture ||
        currentModel.exchCategory == ExchCategory.nseOptions) {
      if (currentModel.exchCategory == ExchCategory.nseEquity)
        underlyingModel = currentModel;
      else
        underlyingModel = CommonFunction.getScripDataModel(
            exch: currentModel.exch, exchCode: currentModel.ulToken);
      futures = Dataconstants.exchData[1].getFutureModels(underlyingModel);
      optionDates =
          Dataconstants.exchData[1].getDatesForOptions(underlyingModel);
    } else if (currentModel.exchCategory == ExchCategory.mcxFutures ||
        currentModel.exchCategory == ExchCategory.mcxOptions) {
      if (currentModel.exchCategory == ExchCategory.mcxFutures)
        underlyingModel = currentModel;
      else {
        try {
          List<ScripInfoModel> list = Dataconstants.exchData[5]
              .getFutureModelsForMcx(currentModel.ulToken);
          underlyingModel = list[0];
        } catch (e, s) {}
        // underlyingModel =
        //     CommonFunction.getScripDataModelForUnderlyingMcx(currentModel);

      }
      futures =
          Dataconstants.exchData[5].getFutureModelsForMcx(currentModel.ulToken);
      optionDates =
          Dataconstants.exchData[5].getDatesForOptionsMcx(currentModel.ulToken);
    } else {
      int exchPos;
      if (currentModel.exchCategory == ExchCategory.currenyFutures ||
          currentModel.exchCategory == ExchCategory.currenyOptions)
        exchPos = 3;
      else
        exchPos = 4;
      if (currentModel.exchCategory == ExchCategory.currenyFutures ||
          currentModel.exchCategory == ExchCategory.bseCurrenyFutures) {
        underlyingModel = currentModel;
      } else {
        try {
          List<ScripInfoModel> list = Dataconstants.exchData[exchPos]
              .getFutureModelsForCurr(currentModel.ulToken);
          underlyingModel = list[0];
        } catch (e, s) {}
      }
      // underlyingModel = currentModel;
      // underlyingModel =
      //     CommonFunction.getScripDataModelForUnderlyingCurr(currentModel);
      futures = Dataconstants.exchData[exchPos]
          .getFutureModelsForCurr(currentModel.ulToken);
      optionDates = Dataconstants.exchData[exchPos]
          .getDatesForOptionsCurr(currentModel.ulToken);
    }
    if (widget.model.exchCategory == ExchCategory.nseEquity)
      _newsNseCode = widget.model.exchCode;
    else if (widget.model.exchCategory == ExchCategory.nseFuture ||
        widget.model.exchCategory == ExchCategory.nseOptions)
      _newsNseCode = widget.model.ulToken;
    else if (widget.model.exchCategory == ExchCategory.bseEquity &&
        widget.model.alternateModel != null)
      _newsNseCode = widget.model.alternateModel.exchCode;
    else if (widget.model.exchCategory == ExchCategory.mcxFutures)
      _newsNseCode = widget.model.exchCode;
    // //print("exchcode ->${_newsNseCode}");
  }

  void checkIfModelInWatchlist() {
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere(
          (element) =>
              element.exch == currentModel.exch &&
              element.exchCode == currentModel.exchCode);
    }
    addedToWatchlist = pos.any((element) => element > -1);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        brightness: ThemeConstants.themeMode.value == ThemeMode.light
            ? Brightness.light
            : Brightness.dark,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                CupertinoIcons.chevron_back,
                color: theme.textTheme.bodyText1.color,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentModel.exchCategory == ExchCategory.nseEquity ||
                            currentModel.exchCategory == ExchCategory.bseEquity
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        currentModel.name,
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyText1.color,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${currentModel.exchName.toUpperCase()} ${currentModel.marketWatchDesc.toUpperCase()}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Text(
                                  currentModel.desc.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    currentModel.marketWatchName,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyText1.color,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${currentModel.exchName.toUpperCase()} ${currentModel.marketWatchDesc.toUpperCase()}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Observer(
                          builder: (_) => DecimalText(
                              currentModel.close == 0.00
                                  ? currentModel.prevDayClose
                                      .toStringAsFixed(currentModel.precision)
                                  : currentModel.close
                                      .toStringAsFixed(currentModel.precision),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentModel.priceColor == 1
                                    ? ThemeConstants.buyColor
                                    : currentModel.priceColor == 2
                                        ? ThemeConstants.sellColor
                                        : theme.textTheme.bodyText1.color,
                              )),
                        ),
                        Row(
                          children: [
                            Observer(
                              builder: (_) => Text(
                                currentModel.close == 0.00
                                    ? '0.00'
                                    : currentModel.priceChangeText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: currentModel.priceChange > 0
                                      ? ThemeConstants.buyColor
                                      : currentModel.priceChange < 0
                                          ? ThemeConstants.sellColor
                                          : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Observer(
                              builder: (_) => Text(
                                currentModel.close == 0.00
                                    ? '(0.00%)'
                                    : currentModel.percentChangeText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: currentModel.percentChange > 0
                                      ? ThemeConstants.buyColor
                                      : currentModel.percentChange < 0
                                          ? ThemeConstants.sellColor
                                          : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            if (!CommonFunction.isIndicesScrip(
                currentModel.exch, currentModel.exchCode))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ButtonTheme(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeConstants.buyColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'BUY',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => orderNavigate(false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ButtonTheme(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeConstants.sellColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'SELL',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => orderNavigate(true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Observer(
                    builder: (_) => Visibility(
                      visible: widget.model.alternateModel != null,
                      child: CupertinoSlidingSegmentedControl(
                        thumbColor: Theme.of(context).accentColor,
                        children: {
                          0: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 35,
                            child: Center(
                              child: Text(
                                'NSE',
                                style: TextStyle(
                                  color: _exchTogglePosition == 0
                                      ? theme.primaryColor
                                      : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                          1: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 35,
                            child: Center(
                              child: Text('BSE',
                                  style: TextStyle(
                                    color: _exchTogglePosition == 1
                                        ? theme.primaryColor
                                        : theme.textTheme.bodyText1.color,
                                  )),
                            ),
                          ),
                        },
                        groupValue: _exchTogglePosition,
                        onValueChanged: (newValue) {
                          if (newValue != _exchTogglePosition)
                            modelFlipped = !modelFlipped;
                          if (modelFlipped) {
                            Dataconstants.iqsClient.sendLTPRequest(
                              widget.model,
                              false,
                            );
                            Dataconstants.iqsClient.sendMarketDepthRequest(
                              widget.model.exch,
                              widget.model.exchCode,
                              false,
                            );
                            Dataconstants.iqsClient.sendLTPRequest(
                              widget.model.alternateModel,
                              true,
                            );
                            Dataconstants.iqsClient.sendMarketDepthRequest(
                              widget.model.alternateModel.exch,
                              widget.model.alternateModel.exchCode,
                              true,
                            );
                          } else {
                            Dataconstants.iqsClient.sendLTPRequest(
                              widget.model.alternateModel,
                              false,
                            );
                            Dataconstants.iqsClient.sendMarketDepthRequest(
                              widget.model.alternateModel.exch,
                              widget.model.alternateModel.exchCode,
                              false,
                            );
                            Dataconstants.iqsClient.sendLTPRequest(
                              widget.model,
                              true,
                            );
                            Dataconstants.iqsClient.sendMarketDepthRequest(
                              widget.model.exch,
                              widget.model.exchCode,
                              true,
                            );
                          }

                          setState(() {
                            _tabController.index = 0;
                            currentModel = modelFlipped
                                ? widget.model.alternateModel
                                : widget.model;
                            _exchTogglePosition = newValue;
                            checkIfModelInWatchlist();
                            checkFutureOptions();
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Builder(
                        builder: (ctx) => IconButton(
                          color: theme.primaryColor,
                          icon: Icon(addedToWatchlist
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined),
                          onPressed: () async {
                            if (!addedToWatchlist) {
                              var result = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    WatchListPickerCard(currentModel),
                              );
                              if (result != null && result['added'] == 1) {
                                setState(() {
                                  addedToWatchlist = true;
                                });
                                pos[result['watchListId']] = Dataconstants
                                    .marketWatchListeners[result['watchListId']]
                                    .watchList
                                    .indexWhere((element) =>
                                        element.exch == currentModel.exch &&
                                        element.exchCode ==
                                            currentModel.exchCode);
                                CommonFunction.showSnackBar(
                                  context: ctx,
                                  text:
                                      'Added ${currentModel.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
                                  duration: const Duration(milliseconds: 1500),
                                );
                              } else if (result != null &&
                                  result['added'] == 2) {
                                CommonFunction.showSnackBar(
                                  context: ctx,
                                  text:
                                      'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
                                  color: Colors.red,
                                  duration: const Duration(milliseconds: 1500),
                                );
                              }
                            } else {
                              setState(() {
                                addedToWatchlist = false;
                              });
                              for (int i = 0; i < pos.length; i++) {
                                if (pos[i] > -1) {
                                  CommonFunction.showSnackBar(
                                    context: ctx,
                                    text:
                                        'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
                                    color: Colors.red,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                  );
                                  Dataconstants.marketWatchListeners[i]
                                      .removeFromWatchListIndex(pos[i]);
                                }
                              }
                              pos = [-1, -1, -1, -1];
                            }
                          },
                        ),
                      ),
                      Visibility(
                        // visible: currentModel.exch != 'M',
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.primaryColor),
                          ),
                          child: Text('Show Chart', style: TextStyle(color: theme.primaryColor),),
                          onPressed: () {
                            var segment = currentModel.exch == "M"
                                ? "COMMODITY"
                                : currentModel.series == "EQ"
                                    ? "EQUITY"
                                    : currentModel.series == "F&O"
                                        ? "DERIVATIVE"
                                        : currentModel.series == "Curr"
                                            ? "CURRENCY"
                                            : "EQUITY";
                            var exchange = currentModel.exch == "M"
                                ? "MCX"
                                : currentModel.series == "EQ"
                                    ? currentModel.exch == "N"
                                        ? "NSE"
                                        : "BSE"
                                    : currentModel.series == "F&O"
                                        ? "NFO"
                                        : currentModel.series == "Curr"
                                            ? "NDX"
                                            : currentModel.exch == "N"
                                                ? "NSE"
                                                : "BSE";
                            var expiry = currentModel.expiryDateString
                                .replaceAll(" ", "-");
                            var otherParams = "";

                            if (segment == "EQUITY") {
                              otherParams =
                                  "Ftype=N&exchange=$exchange&scrip=${currentModel.isecName}&segment=$segment&user=${Dataconstants.internalFeUserID}_chart&connectfeed=Y";
                            } else if (segment == "DERIVATIVE") {
                              var scriptname = "";
                              if (currentModel.exchCategory !=
                                  ExchCategory.nseOptions)
                                scriptname = "FUT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry;
                              else if (currentModel.cpType == 3) //call
                                scriptname = "OPT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry +
                                    "-" +
                                    currentModel.strikePrice.toString() +
                                    "-CE";
                              else
                                scriptname = "OPT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry +
                                    "-" +
                                    currentModel.strikePrice.toString() +
                                    "-PE";
                              otherParams =
                                  "Ftype=N&exchange=NFO&scrip=$scriptname&segment=DERIVATIVE&expdt=$expiry&user=${Dataconstants.internalFeUserID}_chart&lotqty=${widget.model.minimumLotQty}&ctgryindstk=S";
                            } else if (segment == "CURRENCY") {
                              var scriptname = "";
                              if (currentModel.exchCategory !=
                                  ExchCategory.currenyOptions)
                                scriptname = "FUT-" +
                                    currentModel.desc.replaceAll(" ", "-");
                              else if (currentModel.cpType == 3) {
                                //call
                                var strikeprice =
                                    currentModel.strikePrice * 100000;

                                scriptname = "OPT-" +
                                    currentModel.desc
                                        .split("CE")[0]
                                        .replaceAll(" ", "-") +
                                    strikeprice.toString() +
                                    "-CE";
                              } else {
                                var strikeprice =
                                    currentModel.strikePrice * 100000;

                                scriptname = "OPT-" +
                                    currentModel.desc
                                        .split("PE")[0]
                                        .replaceAll(" ", "-") +
                                    strikeprice.toString() +
                                    "-PE";
                              }

                              otherParams =
                                  "Ftype=N&exchange=$exchange&scrip=$scriptname&segment=$segment&expdt=$expiry&user=${Dataconstants.internalFeUserID}_chart&lotqty=1000";
                            } else if (segment == "COMMODITY") {
                              var scriptname = "";
                              if (currentModel.exchCategory !=
                                  ExchCategory.mcxOptions)
                                scriptname = "FUT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry;
                              else if (currentModel.cpType == 3) {
                                //call
                                scriptname = "OPT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry +
                                    "-" +
                                    currentModel.strikePrice.toString() +
                                    "-CE";
                              } else {
                                scriptname = "OPT-" +
                                    currentModel.isecName +
                                    "-" +
                                    expiry +
                                    "-" +
                                    (currentModel.strikePrice / 100)
                                        .toString() +
                                    "-PE";
                              }
                              otherParams =
                                  //"Ftype=N&exchange=NSE&scrip=FUT-SILMIC-28-Feb-2022&segment=COMMODITY&expdt=28-Feb-2022&user=cash10_chart&lotqty=250&ctgryindstk=S";
                                  "Ftype=N&exchange=NSE&scrip=$scriptname&segment=$segment&expdt=$expiry&user=${Dataconstants.internalFeUserID}_chart&lotqty=${widget.model.minimumLotQty}&ctgryindstk=S";
                            }

                            // chartSelectedIndex == 0 ||
                            //         chartSelectedIndex == null
                            //     ? Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => ChartIqScreen(
                            //               "TRADING VIEW", "TV", otherParams),
                            //         ),
                            //       )
                            //     : chartSelectedIndex == 2
                            //         ? Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) =>
                            //                   ChartScreen(currentModel),
                            //             ),
                            //           )
                            //         : Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => ChartIqScreen(
                            //                   "CHARTIQ",
                            //                   "CHARTIQ",
                            //                   otherParams),
                            //             ),
                            //           );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // if (!CommonFunction.isIndicesScrip(
            //     currentModel.exch, currentModel.exchCode))
            //   if (currentModel.exchCategory == ExchCategory.nseOptions ||
            //       currentModel.exchCategory == ExchCategory.nseEquity ||
            //       currentModel.exchCategory == ExchCategory.nseFuture)
            //     Row(
            //       children: [
            //         if (widget.model.exchCategory == ExchCategory.nseFuture ||
            //             widget.model.exchCategory == ExchCategory.nseOptions ||
            //             widget.model.exchCategory == ExchCategory.nseOptions)
            //           GestureDetector(
            //             onTap: () async {
            //               // Dataconstants.mainScreenIndex = 3;
            //               // Dataconstants.isFromToolsToBasketOrder = true;
            //               // Dataconstants.isComingFromGoToBasket = true;
            //               // Dataconstants.isComingFromBasketGetQuote = true;
            //               // // Navigator.of(context).pushReplacement(
            //               // //     MaterialPageRoute(
            //               // //         builder: (context) => MainScreen()));
            //               // Dataconstants.shouldShowPopForbasket = true;
            //               // Dataconstants.basketModelForFno = widget.model;
            //               //
            //               // Navigator.of(context).push(MaterialPageRoute(
            //               //     builder: (context) => BasketWatch()));
            //
            //               // setState(() {
            //               //
            //               // });
            //               // await Future.delayed(Duration(seconds: 1));
            //
            //               // Dataconstants.mainTabController.animateTo(3);
            //             },
            //             child: Row(
            //               children: [
            //                 Text("Basket Order",
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14,
            //                         color: theme.primaryColor)),
            //                 // SizedBox(
            //                 //   width: 3,
            //                 // ),
            //                 Icon(
            //                   Icons.arrow_forward_ios_rounded,
            //                   color: theme.primaryColor,
            //                   size: 12,
            //                 )
            //                 // SvgPicture.asset(
            //                 //     "assets/images/Basket/arrowBasket.svg",width: 12,height: 12,)
            //               ],
            //             ),
            //           ),
            //         SizedBox(
            //           width: 15,
            //         )
            //       ],
            //     ),

            TabBar(
              physics: CustomTabBarScrollPhysics(),
              controller: _tabController,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: Colors.grey[600],
              labelColor: theme.textTheme.bodyText1.color,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'OVERVIEW',
                ),
                Tab(
                  text: 'FUTURES',
                ),
                Tab(
                  text: 'OPTION CHAIN',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: CustomTabBarScrollPhysics(),
                children: [
                  ScripdetailOverview(currentModel),
                  futures.length > 0
                      ? ScripdetailFuture(
                          futures, currentModel, currentDate, widget.comingFrom)
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
                      ? ScripdetailOptionChain(underlyingModel, optionDates,
                          currentDate, widget.comingFrom)
                      : Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  // if (widget.model.exch != 'M')
                  //   _newsNseCode > 0 && widget.model.exch != 'M'
                  //       ? NewsScreen(_newsNseCode)
                  //       : Center(
                  //           child: Text(
                  //             'No news available',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               color: Colors.grey,
                  //             ),
                  //           ),
                  //         ),
                ],
              ),
            ),

            // child: SingleChildScrollView(
            //   child: ScripdetailOverview(currentModel),
            // ),
          ],
        ),
      ),
    );
  }

  void orderNavigate(bool isSellButton) async {
    try {
      if (currentModel.exchCategory == ExchCategory.nseEquity ||
          currentModel.exchCategory == ExchCategory.bseEquity)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OrderPlacementScreen(
                // model: currentModelNew,
                model: currentModel,
                // currentModelNew to be used only for equity nse/bse toggle
                orderType: ScripDetailType.none,
                isBuy: !isSellButton,
                selectedExch: _exchTogglePosition == 0 ? "N" : "B",
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
}

class NewMarketDepth extends StatefulWidget {
  final ScripInfoModel model;
  final double elevation;
  final BuildContext modalContext;

  NewMarketDepth(
    this.model, {
    this.elevation = 2,
    this.modalContext,
  });

  @override
  State<NewMarketDepth> createState() => _NewMarketDepthState();
}

class _NewMarketDepthState extends State<NewMarketDepth> {
  @override
  void initState() {
    Dataconstants.iqsClient
        .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 0,
            left: 0,
            right: 0,
            bottom: 20,
          ),
          height: 180,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qty',
                            style: Utils.fonts(
                              size: 12.0,
                              color: Utils.greyColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) => Text(widget.model.bidQty1.toString(),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ThemeConstants.buyColor,
                              )
                              // style: TextStyle(
                              //   color: ThemeConstants.buyColor,
                              //   fontWeight: FontWeight.w600,
                              // ),
                              ),
                        ),
                        Observer(
                          builder: (_) => Text(widget.model.bidQty2.toString(),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ThemeConstants.buyColor,
                              )),
                        ),
                        Observer(
                          builder: (_) => Text(widget.model.bidQty3.toString(),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ThemeConstants.buyColor,
                              )),
                        ),
                        Observer(
                          builder: (_) => Text(widget.model.bidQty4.toString(),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ThemeConstants.buyColor,
                              )),
                        ),
                        Observer(
                          builder: (_) => Text(widget.model.bidQty5.toString(),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ThemeConstants.buyColor,
                              )),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Ord',
                            style: Utils.fonts(
                              size: 12.0,
                              color: Utils.greyColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.bidOrder1.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.buyColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.bidOrder2.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.buyColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.bidOrder3.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.buyColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.bidOrder4.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.buyColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.bidOrder5.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.buyColor,
                                  )),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Bid',
                            style: Utils.fonts(
                              size: 12.0,
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.bidRate1
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  color: ThemeConstants.buyColor,
                                  fontWeight: FontWeight.w500,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.bidRate1
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.bidRate2
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.buyColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.bidRate2
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.bidRate3
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.buyColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.bidRate3
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.bidRate4
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.buyColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.bidRate4
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.bidRate5
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.buyColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.bidRate5
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Offer',
                            style: Utils.fonts(
                              size: 12.0,
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.offerRate1
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.sellColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.offerRate1
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.offerRate2
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.sellColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.offerRate2
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.offerRate3
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.sellColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.offerRate3
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.offerRate4
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.sellColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.offerRate4
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => InkWell(
                            child: Text(
                                widget.model.offerRate5
                                    .toStringAsFixed(widget.model.precision),
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.sellColor,
                                )),
                            onTap: () {
                              if (widget.modalContext != null) {
                                Navigator.of(widget.modalContext).pop(widget
                                    .model.offerRate5
                                    .toStringAsFixed(widget.model.precision));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Ord',
                            style: Utils.fonts(
                              size: 12.0,
                              color: Utils.greyColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerOrder1.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerOrder2.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerOrder3.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerOrder4.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerOrder5.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Qty',
                            style: Utils.fonts(
                              size: 12.0,
                              color: Utils.greyColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            )),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerQty1.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerQty2.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerQty3.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w200,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerQty4.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.offerQty5.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeConstants.sellColor,
                                  )),
                        ),
                      ],
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Observer(
                          builder: (_) => Text(
                              widget.model.totalBuyQty.toString(),
                              style: Utils.fonts(
                                  size: 13.0,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeConstants.buyColor)
                              // style: const TextStyle(
                              //   fontWeight: FontWeight.w600,
                              // ),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('Total Bid ',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Utils.greyColor)
                              // style: TextStyle(color: Colors.grey[600]),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Total Offer',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Utils.greyColor)),
                        ),
                        Observer(
                          builder: (_) =>
                              Text(widget.model.totalSellQty.toString(),
                                  style: Utils.fonts(
                                    size: 13.0,
                                    color: ThemeConstants.sellColor,
                                    fontWeight: FontWeight.w500,
                                  )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MarketDepth extends StatefulWidget {
  final ScripInfoModel model;
  final double elevation;
  final BuildContext modalContext;

  MarketDepth(
    this.model, {
    this.elevation = 2,
    this.modalContext,
  });

  @override
  _MarketDepthState createState() => _MarketDepthState();
}

class _MarketDepthState extends State<MarketDepth> {
  @override
  void initState() {
    widget.model.resetBidOffer();
    Dataconstants.iqsClient
        .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      child: Container(
        padding: const EdgeInsets.only(
          top: 0,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Orders'),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidOrder1.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidOrder2.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidOrder3.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidOrder4.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidOrder5.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${widget.model.exch == 'C' || widget.model.exch == 'M' ? "Lot" : "Qty"}'),
                      Observer(
                        builder: (_) => Text(
                          widget.model.bidQty1.toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.bidQty2 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.bidQty2).toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.bidQty3 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.bidQty3).toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.bidQty4 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.bidQty4).toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.bidQty5 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.bidQty5).toString(),
                          style: TextStyle(
                            color: ThemeConstants.buyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Bid'),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.bidRate1
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.bidRate1
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.bidRate2
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.bidRate2
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.bidRate3
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.bidRate3
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.bidRate4
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.bidRate4
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.bidRate5
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.buyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.bidRate5
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Offer'),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.offerRate1
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.offerRate1
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.offerRate2
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.offerRate2
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.offerRate3
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.offerRate3
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.offerRate4
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.offerRate4
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) => InkWell(
                          child: Text(
                            widget.model.offerRate5
                                .toStringAsFixed(widget.model.precision),
                            style: TextStyle(
                              color: ThemeConstants.sellColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (widget.modalContext != null) {
                              Navigator.of(widget.modalContext).pop(widget
                                  .model.offerRate5
                                  .toStringAsFixed(widget.model.precision));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${widget.model.exch == 'C' || widget.model.exch == 'M' ? "Lot" : "Qty"}'),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.offerQty1 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.offerQty1).toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.offerQty2 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.offerQty2).toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.offerQty3 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.offerQty3).toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.offerQty4 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.offerQty4).toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.exch == 'C'
                              ? (widget.model.offerQty5 /
                                      widget.model.minimumLotQty)
                                  .toStringAsFixed(0)
                              : (widget.model.offerQty5).toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Orders'),
                      Observer(
                        builder: (_) => Text(
                          widget.model.offerOrder1.toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.offerOrder2.toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.offerOrder3.toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.offerOrder4.toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => Text(
                          widget.model.offerOrder5.toString(),
                          style: TextStyle(
                            color: ThemeConstants.sellColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            BidAskSlider(widget.model),
          ],
        ),
      ),
    );
  }
}

class BidAskSlider extends StatelessWidget {
  final ScripInfoModel model;

  BidAskSlider(this.model);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Bid'), Text('Ask')],
        ),
        SizedBox(
          height: 5,
        ),
        Observer(
          builder: (_) => Stack(children: [
            Stack(
              children: [
                Container(
                  color: ThemeConstants.sellColor,
                  height: 22,
                  width: width,
                ),
                AnimatedContainer(
                  color: ThemeConstants.buyColor,
                  height: 22,
                  width: width * model.bidTotalVal * 0.01,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '${model.bidTotalVal.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '${model.askTotalVal.toStringAsFixed(2)}%',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ]),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'TBQ ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Observer(
                  builder: (_) => Text(
                    model.totalBuyQty.toString(),
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Observer(
                  builder: (_) => Text(
                    model.totalSellQty.toString(),
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  ' TSQ ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
