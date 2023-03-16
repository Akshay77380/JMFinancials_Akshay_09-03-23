import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:markets/util/CommonFunctions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../jmScreens/CommonWidgets/number_field.dart';
import '../../model/exchData.dart';
import '../../model/scrip_info_model.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../style/theme.dart';
import '../../util/DateUtil.dart';
import 'Charting/chart_style.dart';
import 'Charting/chart_widget.dart';
import 'Charting/entity/studies.dart';
import 'Charting/entity/userStudySetting.dart';
import 'Charting/utils/data_util.dart';
import 'Charting/entity/k_line_entity.dart';
import 'flutterChart_model.dart';

// ignore: must_be_immutable
class SChart extends StatefulWidget {
  final String exChar;
  final String scripCode;
  final String symbol;
  final String fromDate;
  final String toDate;
  final String timeInterval;
  final String chartPeriod;
  final bool volumeHidden;
  final bool isFlashChart;
  ScripInfoModel currentModel;

  SChart(
    this.currentModel, {
    Key key,
    this.exChar,
    this.scripCode,
    this.symbol,
    this.fromDate,
    this.toDate,
    this.timeInterval,
    this.chartPeriod,
    this.volumeHidden,
    this.isFlashChart = false,
  }) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<SChart> with SingleTickerProviderStateMixin {
  // static List<KLineEntity> datas = [];
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // Dataconstants.datas = [];
  ChartStudies chartStudies;
  bool showLoading = true;
  List<MainState> _mainState = [MainState.NONE];
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.NONE;
  SecondaryState _tertiaryState = SecondaryState.NONE;
  bool isLine = false;
  bool isChinese = false;
  bool _hideGrid = false;
  bool _showNowPrice = true;
  bool isChangeUI = false;
  String exchar = 'N';
  int code = 0;
  String symbol = '';
  static String chartPeriod = 'D';
  static double chartInterval = 1.0;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();
  String periods = '1D', type = 'Candles';
  double containerHeight = 20;
  double chartHeight = 0;
  double bottomBarHeight = 30;
  String dropdownValue = 'Daily';

  List<Color> _tempBg;

  int priceGraphLimit = 5;
  int addedPriceGraphs = 0;
  int subGraphLimit = 2;
  int addedSubgraphs = 0;

  bool themeDark;

  Map<String, StudyDef> _defaultStudyMap = Map<String, StudyDef>();
  String _selectedDuration = '1';
  Timer timer;
  var actualCurrentTime;

  var actualCurrentTimeEpoch;

  var timePeriod = 1;
  bool shouldUpdate = false;
  bool buySellIconColor = false, lineOnTick = false;
  int productType = 1;
  int fastTradeType = 0;
  int limitOrder = 0;
  TextEditingController _qtyContoller;
  TextEditingController _limitController;
  bool isBuy = false;
  var lastFormedCandleTime = null;

  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  bool dataAvailable = false;

  @override
  void initState() {
    // if (Dataconstants.isFromToolsToFlashTrade == true) {
    //   Dataconstants.chartPageController = BehaviorSubject<bool>();
    //   Dataconstants.drawLineOnBuySell = BehaviorSubject<bool>();
    //   tickByTick();
    // } else
    {
      Dataconstants.chartPageController = BehaviorSubject<bool>();
      Dataconstants.chartPageControllerFlashTrade = BehaviorSubject<bool>();
      Dataconstants.drawLineOnBuySell = BehaviorSubject<bool>();
      // Dataconstants.flashTradeDataPoints.clear();
      super.initState();
      Dataconstants.isFromChart = false;
      Dataconstants.buySellButtonTickByTick = false;
      Dataconstants.defaultBuySellChartSetting = false;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      Dataconstants.curPrice = null;
      Dataconstants.lastX = null;
      Dataconstants.indexTickByTic = null;
      if (widget.isFlashChart) {
        symbol = widget.symbol;
        _ChartState.chartPeriod = widget.chartPeriod;
      }
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      // ));
      // _tempBg = ThemeConstants.themeMode.value == ThemeMode.light
      //     ? [Colors.white, Colors.white]
      //     : [Colors.black, Colors.black];
      // themeDark = ThemeConstants.themeMode.value == ThemeMode.dark ? true : false;

      ///-----------update chart-----------  ssss
      _qtyContoller = TextEditingController();
      _limitController = TextEditingController();
      actualCurrentTime = DateTime.now().minute;
      actualCurrentTimeEpoch = DateTime.now().millisecondsSinceEpoch;
      timer = Timer.periodic(const Duration(seconds: 1), updateChartData);

      ///------------------------------------------------

      chartStudies = new ChartStudies();
      chartStudies.studyList = [];
      selectedStudy.clear();
      selectedStudy.add(chartStudies.defaultstudyList[1]);
      selectedStudy.add(chartStudies.defaultstudyList[2]);

      var _tempDefaultStudyList = chartStudies.defaultstudyList
          .where((element) => element.lName.trim() != "")
          .toList();
      var _tempDefaultSortedStudyList = [];
      for (int i = 2; i < _tempDefaultStudyList.length; i++) {
        _tempDefaultSortedStudyList.add(_tempDefaultStudyList[i]);
      }
      _tempDefaultSortedStudyList.sort((a, b) => a.lName.compareTo(b.lName));
      for (int i = 0; i < _tempDefaultSortedStudyList.length; i++) {
        if (_tempDefaultSortedStudyList[i].lName == '') continue;
        _defaultStudyMap[_tempDefaultSortedStudyList[i].lName] =
            getStudyDef(_tempDefaultSortedStudyList[i].studyType.index);
      }
      if (widget.volumeHidden) {
        chartStudies.defaultstudyList[TStudyType.STVolume.index].visible =
            false;
      } else {
        chartStudies.defaultstudyList[TStudyType.STVolume.index].visible = true;
      }
      _loadStudySetting(initState: true).then((value) => {
            getDataFromServer(
                widget.exChar,
                widget.scripCode,
                widget.symbol,
                widget.fromDate,
                widget.toDate,
                widget.timeInterval,
                widget.chartPeriod),
          });
    }
  }

  @override
  void didUpdateWidget(covariant SChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFlashChart) {
      if (symbol == widget.symbol) return;
      symbol = widget.symbol;
      _ChartState.chartPeriod = widget.chartPeriod;
      _selectedDuration = widget.timeInterval;

      getDataFromServer(
          widget.exChar,
          widget.scripCode,
          widget.symbol,
          widget.fromDate,
          widget.toDate,
          widget.timeInterval,
          widget.chartPeriod);
    }
  }

  tickByTick() async {
    // timer.cancel();
    buySellIconColor = false;
    Dataconstants.chartTickByTick = true;
    TimeOfDay intraDayTime = TimeOfDay(hour: 9, minute: 0);
    final now = new DateTime.now();
    var finalIntraDayTime = DateTime(now.year, now.month, now.day,
            intraDayTime.hour, intraDayTime.minute)
        .subtract(Duration(hours: 5, minutes: 30));
    //print(" finalIntraDayTime : $finalIntraDayTime");
    var intraDayTimePass =
        DateUtil.getIntFromDate1Chart(finalIntraDayTime.toString());
    Dataconstants.modelForChart = widget.currentModel;
    await Dataconstants.iqsClient.sendChartRequest(
      widget.currentModel,
      intraDayTimePass,
    );
    //print('Chart request sent');
    showLoading = false;
    symbol = widget.symbol;

    chartStudies = new ChartStudies();
    chartStudies.studyList = [];
    selectedStudy.clear();
    selectedStudy.add(chartStudies.defaultstudyList[1]);
    selectedStudy.add(chartStudies.defaultstudyList[2]);

    var _tempDefaultStudyList = chartStudies.defaultstudyList
        .where((element) => element.lName.trim() != "")
        .toList();
    var _tempDefaultSortedStudyList = [];
    for (int i = 2; i < _tempDefaultStudyList.length; i++) {
      _tempDefaultSortedStudyList.add(_tempDefaultStudyList[i]);
    }
    _tempDefaultSortedStudyList.sort((a, b) => a.lName.compareTo(b.lName));
    for (int i = 0; i < _tempDefaultSortedStudyList.length; i++) {
      if (_tempDefaultSortedStudyList[i].lName == '') continue;
      _defaultStudyMap[_tempDefaultSortedStudyList[i].lName] =
          getStudyDef(_tempDefaultSortedStudyList[i].studyType.index);
    }
    if (widget.volumeHidden) {
      chartStudies.defaultstudyList[TStudyType.STVolume.index].visible = false;
    } else {
      chartStudies.defaultstudyList[TStudyType.STVolume.index].visible = true;
    }
    // await _loadStudySetting(initState: true);
  }

  StudyDef getStudyDef(int index) {
    StudyDef s = StudyDef.clone(chartStudies.defaultstudyList[index]);
    return s;
  }

  StudyDef getStudy(int index) {
    StudyDef s = StudyDef.clone(chartStudies.studyList[index]);
    return s;
  }

  StudyDef addStudy(int index) {
    StudyDef s = StudyDef.clone(chartStudies.defaultstudyList[index]);
    return s;
  }

  @override
  void dispose() {
    /*if (Dataconstants.isFromToolsToFlashTrade == false)*/ {
      timer.cancel();
    }
    Dataconstants.chartPageController.close();
    Dataconstants.drawLineOnBuySell.close();
    super.dispose();
  }

  alertDiealougeForChart() {
    var theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Order Placement Setting'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FAST TRADE',
                  style: TextStyle(fontSize: 14),
                ),
                CupertinoSlidingSegmentedControl(
                    thumbColor: theme.accentColor,
                    children: {
                      0: Container(
                        height: 12,
                        width: 50,
                        child: Center(
                          child: Text(
                            'DISABLE',
                            style: TextStyle(
                              fontSize: 10,
                              color: fastTradeType == 0
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                      1: Container(
                        height: 12,
                        width: 50,
                        child: Center(
                          child: Text(
                            'ENABLE',
                            style: TextStyle(
                              fontSize: 10,
                              color: fastTradeType == 1
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                    },
                    groupValue: fastTradeType,
                    onValueChanged: (newValue) {
                      setState(() {
                        fastTradeType = newValue;
                        //print("product Type :$fastTradeType");
                      });
                    }),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRODUCT',
                  style: TextStyle(fontSize: 14),
                ),
                CupertinoSlidingSegmentedControl(
                    thumbColor: theme.accentColor,
                    children: {
                      0: Container(
                        height: 12,
                        width: 50,
                        child: Center(
                          child: Text(
                            'INTRADAY',
                            style: TextStyle(
                              fontSize: 10,
                              color: productType == 0
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                      1: Container(
                        height: 12,
                        width: 50,
                        child: Center(
                          child: Text(
                            'DELIVERY',
                            style: TextStyle(
                              fontSize: 10,
                              color: productType == 1
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                    },
                    groupValue: productType,
                    onValueChanged: (newValue) {
                      setState(() {
                        productType = newValue;
                        //print("product Type :$productType");
                      });
                    }),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUANTITY',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                NumberField(
                  defaultValue: 1,
                  maxLength: 10,
                  numberController: _qtyContoller,
                  increment: 1,
                  hint: 'Quantity',
                  isInteger: true,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER TYPE',
                  style: TextStyle(fontSize: 14),
                ),
                CupertinoSlidingSegmentedControl(
                    thumbColor: theme.accentColor,
                    children: {
                      0: Container(
                        height: 12,
                        width: 45,
                        child: Center(
                          child: Text(
                            'MARKET',
                            style: TextStyle(
                              fontSize: 10,
                              color: limitOrder == 0
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                      1: Container(
                        height: 12,
                        width: 45,
                        child: Center(
                          child: Text(
                            'LIMIT',
                            style: TextStyle(
                              fontSize: 10,
                              color: limitOrder == 1
                                  ? theme.primaryColor
                                  : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                    },
                    groupValue: limitOrder,
                    onValueChanged: (newValue) {
                      setState(() {
                        limitOrder = newValue;
                        //print("order type Type :$limitOrder");
                      });
                    }),
              ],
            ),
            // SizedBox(
            //   height: 20,
            // ),
            AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                        begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                    .animate(animation);
                return ClipRect(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              duration: const Duration(milliseconds: 250),
              child: limitOrder == 1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: NumberField(
                        doubleDefaultValue: 0,
                        doubleIncrement: 0.5,
                        maxLength: 10,
                        numberController: _limitController,
                        hint: 'Limit',
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        );
      }),

      // Text('AlertDialog description'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFD75B1F)),
          ),
        ),
        TextButton(
          onPressed: () async {
            // if (fastTradeType == 0) {
            //   await Dataconstants.itsClient.placeEquityOrder(
            //     reportCalledFrom: Dataconstants.reportCalledFrom,
            //     exch: widget.currentModel.exchName,
            //     isecName: widget.currentModel.isecName,
            //     product: productType == 1 ? "CASH" : "MARGIN",
            //     type: limitOrder == 1 ? 'L' : 'M',
            //     validity: "T",
            //     //'I' ,
            //     interopsExch: widget.currentModel.exchName,
            //     vtcDate: null,
            //     qty: _qtyContoller.text,
            //     rate: limitOrder == 1 ? _limitController.text : "0",
            //     buySell: isBuy == true ? 'B' : 'S',
            //     slRate: '0',
            //     squareOffMode: null,
            //     disclosedQty: "0",
            //     password: null,
            //   );
            //
            //   ///------------ Api end------------
            //   var status = Dataconstants.responseForChart["Status"];
            //   var success = Dataconstants.responseForChart["Success"];
            //   var indicator = success["Indicator"];
            //   var message = success["Message"];
            //   Dataconstants.indicatorChart = indicator;
            //   if (indicator == "-1") {
            //     CommonFunction.showBasicToastForChar(message, 5);
            //   } else {
            //     setState(() {
            //       lineOnTick = true;
            //       setState(() {
            //         Dataconstants.buySellButtonTickByTick = true;
            //         Dataconstants.buySellPointColor =
            //             isBuy == true ? true : false;
            //       });
            //       // Dataconstants.isBuyColor.add(true);
            //       // Dataconstants.buySellButtonTickByTick2=true;
            //       // Dataconstants.closePriceTickByTick=widget.currentModel.close;
            //     });
            //
            //     // setState(() {
            //     //   lineOnTick = true;
            //     //   setState(() {
            //     //     Dataconstants.buySellButtonTickByTick = true;
            //     //     Dataconstants.buySellPointColor =isBuy==true? true:false;
            //     //   });
            //     //   // Dataconstants.isBuyColor.add(true);
            //     //   // Dataconstants.buySellButtonTickByTick2=true;
            //     //   // Dataconstants.closePriceTickByTick=widget.currentModel.close;
            //     // });
            //   }
            //
            //   _scaffoldKey.currentState.showSnackBar(SnackBar(
            //     backgroundColor:
            //         indicator == "0" ? Color(0xff089981) : Color(0xfff23645),
            //     content: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 30),
            //       child: Row(
            //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             child: Image.asset(
            //               indicator == "0"
            //                   ? "assets/images/chart/right_mark_success.gif"
            //                   : "assets/images/chart/cross_mark_failure.gif",
            //               // "assets/images/chart/cross_mark_failure.gif",
            //               height: 40,
            //               width: 70,
            //               fit: BoxFit.fill,
            //               color: theme.textTheme.bodyText1
            //                   .color, //cross_mark_failure.gif
            //             ),
            //           ),
            //           SizedBox(
            //             width: 30,
            //           ),
            //           Container(
            //             height: 40,
            //             // width: MediaQuery.of(context).size.width,
            //             child: Center(
            //               child: Text(
            //                 indicator == "0"
            //                     ? "Order Submitted"
            //                     : 'Order Rejected',
            //                 style: TextStyle(
            //                     color: theme.textTheme.bodyText1.color,
            //                     fontSize: 22,
            //                     fontWeight: FontWeight.w600),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     duration: Duration(seconds: 1),
            //   ));
            // }
            // Navigator.pop(context, 'Confirm');
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Color(0xFFD75B1F)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Dataconstants.chartTickByTick == true) {
      Dataconstants.chartPageController.stream.listen((seconds) {
        setState(() {});
      });
    }

    if (Dataconstants.defaultBuySellChartSetting == true) {
      Dataconstants.drawLineOnBuySell.stream.listen((seconds) {
        setState(() {});
      }); // Dataconstants.defaultBuySellChartSetting=true;
    }
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    setState(() {
      _tempBg = ThemeConstants.themeMode.value == ThemeMode.light
          ? [Colors.white, Colors.white]
          : [Color(0xff171b26), Color(0xff171b26)];
      themeDark =
          ThemeConstants.themeMode.value == ThemeMode.dark ? true : false;
    });

    var theme = Theme.of(context);
    Dataconstants.theme = theme;
    chartHeight = MediaQuery.of(context).size.height - 35;
    if (widget.isFlashChart) chartHeight = MediaQuery.of(context).size.height;

    // return Container(child: Text('Chart'), color: Colors.pink,);

    return widget.isFlashChart //Dataconstants.isFromToolsToFlashTrade == true
        ? Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  //  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!showLoading)
                      SafeArea(
                        child: Container(
                          // color: Colors.blue,
                          // height: chartHeight*0.65, //* 0.50, // * 0.59,
                          // width: MediaQuery.of(context).size.width,
                          //double.infinity,
                          // color: Colors.transparent,

                          // decoration: BoxDecoration(
                          // color: Colors.transparent,
                          //     // border: Border(
                          //     //   bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.2)),
                          //     // )
                          // ),
                          child: dataAvailable ? Container(
                              height: constraints.maxHeight - 25,
                              child: Center(
                                child: ChartingWidget(
                                  symbol,
                                  Dataconstants.datas,
                                  chartStyle,
                                  chartColors,
                                  chartPeriod,
                                  chartInterval,
                                  chartStudies,
                                  isLine: isLine,
                                  mainState: _mainState,
                                  volHidden: false,
                                  secondaryState: _secondaryState,
                                  tertiaryState: _tertiaryState,
                                  fixedLength: 2,
                                  timeFormat: TimeFormat.DAY_MONTH_YEAR,
                                  showNowPrice: _showNowPrice,
                                  hideGrid: _hideGrid,
                                  maDayList: [1, 100, 1000],
                                  bgColor: _tempBg,
                                  buySellButtonActivate: buySellIconColor,
                                  lineOnTick: lineOnTick,
                                  model: widget.currentModel,
                                  scaffoldKey: _scaffoldKey,
                                ),
                              )): Container( height: constraints.maxHeight - 25,
                              child: Center(
                                child:Text('No data here') ),
                              ),
                        ),
                      ),
                    if (!showLoading)
                      Container(
                        // color: themeDark ? Color(0xff171b26) : Colors.white,
                        // height: chartHeight*0.065,
                        height: 25,
                        decoration: BoxDecoration(
                            color: themeDark ? Color(0xff171b26) : Colors.white,
                            border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: themeDark
                                    ? Color.fromARGB(255, 43, 43, 43)
                                    : Color.fromARGB(255, 43, 43, 43),
                              ),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                // flex: 1,
                                child: _changeDurationButton(),
                              ),
                              Expanded(
                                // flex: 1,
                                child: _addStudiesButton(),
                              ),
                              // SizedBox(width: 15,)
                              Expanded(
                                // flex: 1,
                                child: _changeChartStyleButton(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (showLoading)
                      Container(
                          width: double.infinity,
                          height: chartHeight - 620,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator()),
                    //cccc
                  ],
                );
              }),
            ),
          )
        : MaterialApp(
            theme: Theme.of(context),
            debugShowCheckedModeBanner: false,

            home: SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  titleSpacing: 0,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  leading: InkWell(
                      onTap: () {
                        Dataconstants.chartTickByTick = false;
                        Dataconstants.buySellButtonTickByTick = false;
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: theme.textTheme.bodyText1
                            .color, //themeDark ? Colors.black : Colors.white ,
                      )),
                  backgroundColor: theme.appBarTheme.backgroundColor,
                  title: Text(
                    "Intellect Chart",
                    style: TextStyle(color: theme.textTheme.bodyText1.color),
                  ),
                  actions: [
                    if (Dataconstants.chartTickByTick == true &&
                        buySellIconColor == false)
                      Padding(
                        padding: const EdgeInsets.only(right: 25, top: 10),
                        child: InkWell(
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      alertDiealougeForChart());
                              // showDialog<String>(
                              //     context: context,
                              //     builder: (BuildContext context) =>
                              //         AlertDialog(
                              //           title: const Text('Order Placement Setting'),
                              //           content: StatefulBuilder(
                              //               builder: (BuildContext context,
                              //                   StateSetter setState) {
                              //                 return Column(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   children: [
                              //                     Row(
                              //                       mainAxisAlignment: MainAxisAlignment
                              //                           .spaceBetween,
                              //                       children: [
                              //                         Text('PRODUCT', style: TextStyle(
                              //                             fontSize: 14),),
                              //                         CupertinoSlidingSegmentedControl(
                              //                             thumbColor: theme.accentColor,
                              //                             children: {
                              //                               0: Container(
                              //                                 height: 12,
                              //                                 width: 50,
                              //                                 child: Center(
                              //                                   child: Text(
                              //                                     'INTRADAY',
                              //                                     style: TextStyle(
                              //                                       fontSize: 10,
                              //                                       color: productType ==
                              //                                           0
                              //                                           ? theme
                              //                                           .primaryColor
                              //                                           : theme
                              //                                           .textTheme
                              //                                           .bodyText1
                              //                                           .color,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               1: Container(
                              //                                 height: 12,
                              //                                 width: 50,
                              //
                              //                                 child: Center(
                              //                                   child: Text(
                              //                                     'DELIVERY',
                              //                                     style: TextStyle(
                              //                                       fontSize: 10,
                              //                                       color: productType ==
                              //                                           1
                              //                                           ? theme
                              //                                           .primaryColor
                              //                                           : theme
                              //                                           .textTheme
                              //                                           .bodyText1
                              //                                           .color,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                             },
                              //                             groupValue: productType,
                              //                             onValueChanged: (newValue) {
                              //                               setState(() {
                              //                                 productType = newValue;
                              //                                 //print(
                              //                                     "product Type :$productType");
                              //                               });
                              //                             }),
                              //                       ],
                              //                     ),
                              //                     SizedBox(height: 20),
                              //                     Column(
                              //                       crossAxisAlignment: CrossAxisAlignment
                              //                           .start,
                              //                       children: [
                              //                         Text(
                              //                           'QUANTITY',
                              //                           style: TextStyle(fontSize: 14),
                              //                         ),
                              //                         SizedBox(height: 10),
                              //                         NumberField(
                              //                           defaultValue: 1,
                              //                           maxLength: 10,
                              //                           numberController: _qtyContoller,
                              //                           increment: 1,
                              //                           hint: 'Quantity',
                              //                           isInteger: true,
                              //                         ),
                              //                       ],),
                              //                     SizedBox(height: 20,),
                              //                     Row(
                              //                       mainAxisAlignment: MainAxisAlignment
                              //                           .spaceBetween,
                              //                       children: [
                              //                         Text('ORDER TYPE',
                              //                           style: TextStyle(
                              //                               fontSize: 14),),
                              //                         CupertinoSlidingSegmentedControl(
                              //                             thumbColor: theme.accentColor,
                              //                             children: {
                              //                               0: Container(
                              //                                 height: 12,
                              //                                 width: 45,
                              //                                 child: Center(
                              //                                   child: Text(
                              //                                     'MARKET',
                              //                                     style: TextStyle(
                              //                                       fontSize: 10,
                              //                                       color: limitOrder ==
                              //                                           0
                              //                                           ? theme
                              //                                           .primaryColor
                              //                                           : theme
                              //                                           .textTheme
                              //                                           .bodyText1
                              //                                           .color,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               1: Container(
                              //                                 height: 12,
                              //                                 width: 45,
                              //
                              //                                 child: Center(
                              //                                   child: Text(
                              //                                     'LIMIT',
                              //                                     style: TextStyle(
                              //                                       fontSize: 10,
                              //                                       color: limitOrder ==
                              //                                           1
                              //                                           ? theme
                              //                                           .primaryColor
                              //                                           : theme
                              //                                           .textTheme
                              //                                           .bodyText1
                              //                                           .color,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                             },
                              //                             groupValue: limitOrder,
                              //                             onValueChanged: (newValue) {
                              //                               setState(() {
                              //                                 limitOrder = newValue;
                              //                                 //print(
                              //                                     "order type Type :$limitOrder");
                              //                               });
                              //                             }),
                              //                       ],
                              //                     ),
                              //                     SizedBox(height: 20,),
                              //                     AnimatedSwitcher(
                              //                       transitionBuilder:
                              //                           (Widget child,
                              //                           Animation<double> animation) {
                              //                         final offsetAnimation = Tween<
                              //                             Offset>(
                              //                             begin: Offset(0.0, -1.0),
                              //                             end: Offset(0.0, 0.0))
                              //                             .animate(animation);
                              //                         return ClipRect(
                              //                           child: SlideTransition(
                              //                             position: offsetAnimation,
                              //                             child: child,
                              //                           ),
                              //                         );
                              //                       },
                              //                       duration: const Duration(
                              //                           milliseconds: 250),
                              //                       child: limitOrder == 1
                              //                           ? NumberField(
                              //                         doubleDefaultValue:
                              //                         0,
                              //                         doubleIncrement: 0.5,
                              //                         maxLength: 10,
                              //                         numberController: _limitController,
                              //                         hint: 'Limit',
                              //                       )
                              //                           : SizedBox.shrink(),
                              //                     ),
                              //                   ],
                              //                 );
                              //               }
                              //           ),
                              //
                              //           // Text('AlertDialog description'),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               onPressed: () =>
                              //                   Navigator.pop(context, 'Cancel'),
                              //               child: Text('Cancel', style: TextStyle(
                              //                   color: Color(0xFFD75B1F)),),
                              //             ),
                              //             TextButton(
                              //               onPressed: () =>
                              //                   Navigator.pop(context, 'Done'),
                              //               child: const Text('Done', style: TextStyle(
                              //                   color: Color(0xFFD75B1F)),),
                              //             ),
                              //           ],
                              //         )
                              // );
                            },
                            child: Icon(Icons.settings)),
                      )
                    // DropdownButton(
                    //
                    //   // Initial Value
                    //   value: dropdownvalue,
                    //
                    //   // Down Arrow Icon
                    //   icon: const Icon(Icons.settings),
                    //
                    //   // Array list of items
                    //   items: items.map((String items) {
                    //     return DropdownMenuItem(
                    //       value: items,
                    //       child: Text(items),
                    //     );
                    //   }).toList(),
                    //   // After selecting the desired option,it will
                    //   // change button value to selected value
                    //   onChanged: ( newValue) {
                    //     setState(() {
                    //       dropdownvalue = newValue;
                    //     });
                    //   },
                    // ),
                  ],
                ),
                bottomNavigationBar: Container(
                  color: themeDark ? Colors.black : Colors.white,
                  height: 33,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: (Dataconstants.chartTickByTick == true)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: InkWell(
                                  onTap: () {
                                    lineOnTick = false;
                                    Dataconstants.buySellButtonTickByTick =
                                        false;
                                  },
                                  child: Container(
                                    // flex: 1,
                                    child: _changeDurationButton(),
                                  ),
                                ),
                              ),

                              Container(
                                height: 35,
                                width: 115,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff089981),
                                      foregroundColor: theme.textTheme.bodyText1.color,
                                    ),
                                    child: Text(
                                      'BUY',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      // isBuy = true;
                                      // if (fastTradeType == 0) {
                                      //   showDialog<String>(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           alertDiealougeForChart());
                                      // } else {
                                      //   await Dataconstants.itsClient
                                      //       .placeEquityOrder(
                                      //     reportCalledFrom:
                                      //         Dataconstants.reportCalledFrom,
                                      //     exch: widget.currentModel.exchName,
                                      //     isecName:
                                      //         widget.currentModel.isecName,
                                      //     product: productType == 1
                                      //         ? "CASH"
                                      //         : "MARGIN",
                                      //     type: limitOrder == 1 ? 'L' : 'M',
                                      //     validity: "T",
                                      //     //'I' ,
                                      //     interopsExch:
                                      //         widget.currentModel.exchName,
                                      //     vtcDate: null,
                                      //     qty: _qtyContoller.text,
                                      //     rate: limitOrder == 1
                                      //         ? _limitController.text
                                      //         : "0",
                                      //     buySell: 'B',
                                      //     slRate: '0',
                                      //     squareOffMode: null,
                                      //     disclosedQty: "0",
                                      //     password: null,
                                      //   );

                                        // ///------------ Api end------------
                                        // var status = Dataconstants
                                        //     .responseForChart["Status"];
                                        // var success = Dataconstants
                                        //     .responseForChart["Success"];
                                        // var indicator = success["Indicator"];
                                        // var message = success["Message"];
                                        // Dataconstants.indicatorChart =
                                        //     indicator;
                                        // if (indicator == "-1") {
                                        //   CommonFunction.showBasicToastForChar(
                                        //       message, 5);
                                        // } else {
                                        //   setState(() {
                                        //     lineOnTick = true;
                                        //     setState(() {
                                        //       Dataconstants
                                        //               .buySellButtonTickByTick =
                                        //           true;
                                        //       Dataconstants.buySellPointColor =
                                        //           true;
                                        //     });
                                        //     // Dataconstants.isBuyColor.add(true);
                                        //     // Dataconstants.buySellButtonTickByTick2=true;
                                        //     // Dataconstants.closePriceTickByTick=widget.currentModel.close;
                                        //   });
                                        // }
                                      // }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Container(
                                  height: 35,
                                  width: 115,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xfff23645),
                                        foregroundColor: theme.textTheme.bodyText1.color,
                                      ),
                                      child: Text(
                                        'SELL',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        // isBuy = false;
                                        // if (fastTradeType == 0) {
                                        //   showDialog<String>(
                                        //       context: context,
                                        //       builder: (BuildContext context) =>
                                        //           alertDiealougeForChart());
                                        // } else {
                                        //   await Dataconstants.itsClient
                                        //       .placeEquityOrder(
                                        //     reportCalledFrom:
                                        //         Dataconstants.reportCalledFrom,
                                        //     exch: widget.currentModel.exchName,
                                        //     isecName:
                                        //         widget.currentModel.isecName,
                                        //     product: productType == 1
                                        //         ? "CASH"
                                        //         : "MARGIN",
                                        //     type: limitOrder == 1 ? 'L' : 'M',
                                        //     validity: "T",
                                        //     //'I' ,
                                        //     interopsExch:
                                        //         widget.currentModel.exchName,
                                        //     vtcDate: null,
                                        //     qty: _qtyContoller.text,
                                        //     rate: limitOrder == 1
                                        //         ? _limitController.text
                                        //         : "0",
                                        //     buySell: 'S',
                                        //     slRate: '0',
                                        //     squareOffMode: null,
                                        //     disclosedQty: "0",
                                        //     password: null,
                                        //   );
                                        //
                                        //   ///------------ Api end------------
                                        //   var status = Dataconstants
                                        //       .responseForChart["Status"];
                                        //   var success = Dataconstants
                                        //       .responseForChart["Success"];
                                        //   var indicator = success["Indicator"];
                                        //   var message = success["Message"];
                                        //   Dataconstants.indicatorChart =
                                        //       indicator;
                                        //   if (indicator == "-1") {
                                        //     CommonFunction
                                        //         .showBasicToastForChar(
                                        //             message, 5);
                                        //   } else {
                                        //     setState(() {
                                        //       lineOnTick = true;
                                        //       setState(() {
                                        //         Dataconstants
                                        //                 .buySellButtonTickByTick =
                                        //             true;
                                        //         Dataconstants
                                        //             .buySellPointColor = false;
                                        //       });
                                        //       // Dataconstants.isBuyColor.add(true);
                                        //       // Dataconstants.buySellButtonTickByTick2=true;
                                        //       // Dataconstants.closePriceTickByTick=widget.currentModel.close;
                                        //     });
                                        //   }
                                        // }
                                        // Dataconstants.isBuyColor.add(false);
                                      }),
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(right: 30),
                              //   child: Container(
                              //     // flex: 1,
                              //     child: InkWell(
                              //       onTap: () {
                              //         setState(() {
                              //           buySellIconColor=!buySellIconColor;
                              //         });
                              //       },
                              //       child:
                              //       Container(
                              //           width: 20,
                              //           height: 35,
                              //           child: Icon(
                              //             Icons.stacked_line_chart,//.waterfall_chart,//.waterfall_chart,
                              //             color: !themeDark ?buySellIconColor?Colors.blue: Colors.black
                              //                 : buySellIconColor?Colors.blue:Colors.white,size: 30,
                              //           )
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        : Row(
                            // mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                // flex: 1,
                                child: _changeDurationButton(),
                              ),
                              Expanded(
                                // flex: 1,
                                child: _addStudiesButton(),
                              ),
                              Expanded(
                                // flex: 1,
                                child: _changeChartStyleButton(),
                              ),
                              Expanded(
                                // flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      buySellIconColor = !buySellIconColor;
                                    });
                                  },
                                  child: Container(
                                      width: 20,
                                      height: 35,
                                      child: Icon(
                                        Icons.stacked_line_chart,
                                        //.waterfall_chart,//.waterfall_chart,
                                        color: !themeDark
                                            ? buySellIconColor
                                                ? Colors.blue
                                                : Colors.black
                                            : buySellIconColor
                                                ? Colors.blue
                                                : Colors.white,
                                        size: 30,
                                      )),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                body: Container(
                  color: themeDark ? Colors.black : Colors.white,
                  child: Column(
                    children: <Widget>[
                      if (!showLoading)
                        // ignore: sized_box_for_whitespace
                        Container(
                          height: chartHeight * 0.8, //- 120,
                          width: MediaQuery.of(context)
                              .size
                              .width, //double.infinity,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: ChartingWidget(
                              symbol,
                              Dataconstants.datas,
                              chartStyle,
                              chartColors,
                              chartPeriod,
                              chartInterval,
                              chartStudies,
                              isLine: isLine,
                              mainState: _mainState,
                              volHidden: false,
                              secondaryState: _secondaryState,
                              tertiaryState: _tertiaryState,
                              fixedLength: 2,
                              timeFormat: TimeFormat.DAY_MONTH_YEAR,
                              showNowPrice: _showNowPrice,
                              hideGrid: _hideGrid,
                              maDayList: [1, 100, 1000],
                              bgColor: _tempBg,
                              buySellButtonActivate: buySellIconColor,
                              lineOnTick: lineOnTick,
                              model: widget.currentModel,
                              scaffoldKey: _scaffoldKey,
                            ),
                          ),
                        ),
                      if (showLoading)
                        Container(
                            width: double.infinity,
                            height: chartHeight - 20,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator()),
                    ],
                  ),
                ),
                /*],
              ),*/
              ),
            ),
          );
  }

  Widget durationDropDown(double extraheight) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: bottomBarHeight,
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(
            color: themeDark ? Colors.blueGrey[400] : Colors.grey[300],
            width: 1,
          ),
        ),
        child: DropdownButton<String>(
          value: dropdownValue,
          dropdownColor: Colors.grey.shade900,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(
            Icons.arrow_drop_down_outlined,
          ),
          elevation: 16,
          underline: Container(),
          onChanged: (String newValue) {
            if (newValue == "Daily") {
              getDataFromServer(
                  widget.exChar,
                  widget.scripCode,
                  widget.symbol,
                  widget.fromDate,
                  widget.toDate,
                  widget.timeInterval,
                  widget.chartPeriod);
            } else {
              getDataFromServer(
                  widget.exChar,
                  widget.scripCode,
                  widget.symbol,
                  widget.fromDate,
                  widget.toDate,
                  widget.timeInterval,
                  widget.chartPeriod);
            }
            // setState(() {
            //   dropdownValue = newValue;
            // });
          },
          items: <String>[
            'Daily',
            '1 Minute',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  backgroundColor: Colors.grey.shade900,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _changeChartStyleButton() {
    // zzzzz
    return InkWell(
      onTap: () {
        _showChartStylingBottomSheet();
      },
      child: Container(
        width: 10,
        // height: 20,
        child: Image.asset(
          // 'assets/icons8-candlestickT-chart-100.png',
          'assets/appImages/icons8-candlestickT-chart-100.png',
          color: !themeDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  void _showChartStylingBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          height: 170,
          color: themeDark
              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          child: ListView(
            children: [
              ListTile(
                title: const Text("Bar"),
                onTap: () {
                  _changeChartStyle(selectedChartType: "B");
                },
              ),
              ListTile(
                title: const Text("Candle"),
                onTap: () {
                  _changeChartStyle(selectedChartType: "C");
                },
              ),
              ListTile(
                title: const Text("Line"),
                onTap: () {
                  _changeChartStyle(selectedChartType: "L"); //zzzzz
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addStudiesButton() {
    return InkWell(
      onTap: () {
        _showStudySetting(); // zzzzz
      },
      child: Container(
        width: 20,
        // height: 20,
        child: Image.asset(
          'assets/appImages/indicators_icon.png',
          // 'assets/indicators_icon.png',
          color: !themeDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  List<String> displayStudies = [];
  List<StudyDef> selectedStudy = [];

  void _showStudySetting() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          height: 580,
          color: themeDark
              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),

            ///sssssss
            child: SingleChildScrollView(
              child: Column(
                children: mergedList(),
              ),
            ),
          ),
        );
        // return Container(
        //     height: 400,
        //   // color: themeDark ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
        //   child:
        //   Padding(
        //     padding: const EdgeInsets.only(top: 0,left: 8,right: 8,bottom: 8),  ///sssssss
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: mergedList(),
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }

  List<Widget> defaultStudiesTile({List<String> defaultStudies}) {
    List<Widget> defaultStudiesTile = [];

    defaultStudiesTile.add(
      const ListTile(
        title: Text("Indicators"),
        leading: Icon(Icons.add_circle_rounded),
        // subtitle: Text("Click on the list below to add study."),
        dense: false,
        tileColor: Color.fromARGB(195, 40, 167, 108),
        trailing: Icon(Icons.drag_indicator),
      ),
    );

    _defaultStudyMap.keys.forEach((element) {
      defaultStudiesTile.add(
        InkWell(
          onTap: () {
            if (_defaultStudyMap[element].secondaryState !=
                SecondaryState.NONE) {
              if (addedSubgraphs == subGraphLimit) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: themeDark
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.white,
                        content: Text(
                            'Maximum $subGraphLimit studies can be added on new subgraph.'),
                      );
                    });
              } else {
                _showParamDailog(_defaultStudyMap[element]);
              }
            } else {
              if (addedPriceGraphs == priceGraphLimit) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: themeDark
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.white,
                        content: Text(
                            'Maximum $priceGraphLimit studies can be added on Price subgraph.'),
                      );
                    });
              } else {
                _showParamDailog(_defaultStudyMap[element]);
              }
            }
          },
          child: ListTile(title: Text(element)),
        ),
      );
    });
    return defaultStudiesTile;
  }

  List<Widget> addedStudiesTile({List<StudyDef> selectedStudy}) {
    List<Widget> addedStudiesTile = [];
    addedStudiesTile.add(
      ListTile(
        tileColor: Colors.grey,
        title: const Text("Indicators Selection"),
        trailing: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
    );
    addedStudiesTile.add(
      const ListTile(
        title: Text("Added Indicators"),
        leading: Icon(Icons.edit),
        // subtitle: Text("Click on the list below to modify study."),
        dense: false,
        tileColor: Color.fromARGB(255, 50, 131, 179),
        trailing: Icon(Icons.drag_indicator),
      ),
    );
    for (int i = 0; i < selectedStudy.length; i++) {
      addedStudiesTile.add(ListTile(
        onTap: () {
          _showParamDailog(selectedStudy[i],
              isupdate: true, selectedStudyindex: i);
        },
        title: Row(
          children: [
            Text(selectedStudy[i].lName),
            if (i > 1)
              const SizedBox(
                width: 5,
              ),
            if (i > 1 && selectedStudy[i].parameterCnt > 0)
              Text(
                selectedStudy[i].displayText.substring(
                    selectedStudy[i].displayText.indexOf("("),
                    selectedStudy[i].displayText.length),
                style: TextStyle(color: selectedStudy[i].colors[0]),
              )
          ],
        ),
        trailing: (i == 0 || i == 1)
            ? IconButton(
                alignment: Alignment.centerRight,
                onPressed: () {},
                icon: const Icon(Icons.edit))
            : IconButton(
                alignment: Alignment.centerRight,
                onPressed: () {
                  _removeStudy(i);
                },
                icon: const Icon(Icons.clear)),
      ));
    }
    addedStudiesTile.add(const Divider(
      thickness: 1,
    ));
    return addedStudiesTile;
  }

  List<Widget> mergedList() {
    List<Widget> mergedStudieList = [];
    List<Widget> addedStudiesTileList = [];
    List<Widget> defaultStudiesTileList = [];
    addedStudiesTileList = addedStudiesTile(selectedStudy: selectedStudy);
    defaultStudiesTileList = defaultStudiesTile();
    addedStudiesTileList.addAll(defaultStudiesTileList);
    mergedStudieList.addAll(addedStudiesTileList);
    return mergedStudieList;
  }

  Color _selectedColor;

  StudyDef _tempStudyDef;

  _showParamDailog(StudyDef studyDef,
      {bool isupdate = false, int selectedStudyindex}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          backgroundColor:
              themeDark ? const Color.fromARGB(249, 34, 34, 34) : Colors.white,
          title: Center(
              child: Text(
            studyDef.lName,
          )),
          content: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return;
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: mergedSection(
                    studyDef.parameterCnt,
                    studyDef.parameters,
                    studyDef.colorCnt,
                    studyDef.colors,
                    studyDef,
                    selectedStudyindex: selectedStudyindex,
                    isupdate: isupdate),
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.textTheme.bodyText1.color),
                  ),
                  onPressed: () {
                    if (!isupdate) {
                      if (studyDef.secondaryState != SecondaryState.NONE) {
                        addedSubgraphs--;
                      } else {
                        addedPriceGraphs--;
                      }
                    }
                    Navigator.of(context).pop();
                    _tempStudyDef = null;
                  },
                ),
                TextButton(
                  child: Text(
                    isupdate ? 'Modify' : 'Add',
                    style: TextStyle(color: theme.textTheme.bodyText1.color),
                  ),
                  onPressed: () {
                    if (_tempStudyDef == null) {
                      _tempStudyDef = _getStudyDef(studyDef);
                    }

                    if (isupdate) {
                      _updateStudies(selectedStudyindex);
                    }
                    if (!isupdate) {
                      if (studyDef.secondaryState != SecondaryState.NONE) {
                        addedSubgraphs++;
                      } else {
                        addedPriceGraphs++;
                      }
                      _addNewStudy(_tempStudyDef);
                      chartStudies.studyList.add(_tempStudyDef);
                    }
                    _saveStudySettingToJson();
                    _addupdateState();
                    _tempStudyDef = null;
                    Navigator.of(context).pop();
                    _reloadChart();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _reloadChart({bool initState = false}) {
    int i;
    var d = new Map();
    for (var i = TStudyType.DSDummyFirst.index + 1;
        i < TStudyType.DSDummyLast.index;
        i++) {
      d[i] = 0;
    }
    int secStateCount = 1;
    int stI;
    _secondaryState = _tertiaryState = SecondaryState.NONE;
    for (i = 2; i < chartStudies.studyList.length; i++) {
      stI = chartStudies.studyList[i].studyType.index;
      if (chartStudies.studyList[i].studyType.index == TStudyType.STAvgE.index)
        stI = TStudyType.STAvgS.index;
      if (chartStudies.studyList[i].mainState != MainState.NONE ||
          (chartStudies.studyList[i].outColCnt > 1)) {
        if (chartStudies.studyList[i].outColCnt > 1) {
          int x = d[stI]++;
          for (int l = 0; l < chartStudies.studyList[i].outColCnt; l++) {
            chartStudies.studyList[i].outCols[l] = x;
          }
        } else {
          chartStudies.studyList[i].outCols[0] = d[stI]++;
        }
      } else if (chartStudies.studyList[i].secondaryState != MainState.NONE) {
        for (int l = 0; l < chartStudies.studyList[i].outColCnt; l++) {
          chartStudies.studyList[i].outCols[l] = d[stI]++;
        }
      }

      switch (chartStudies.studyList[i].studyType) {
        case TStudyType.DSDummyFirst:
        case TStudyType.STPrice:
        case TStudyType.STVolume:
        case TStudyType.STAvgS:
        case TStudyType.STAvgE:
        case TStudyType.STCCI:
        case TStudyType.STRsi:
        case TStudyType.STPriceTyp:
        case TStudyType.DSDummyLast:
          if (chartStudies.studyList[i].parameterCnt > 0) {
            for (int l = 0; l < chartStudies.studyList[i].parameterCnt; l++) {
              if (chartStudies.studyList[i].parameters[l].paramType != "I")
                continue;
              chartStudies.studyList[i].displayText =
                  "${chartStudies.studyList[i].outColName[0]}(${chartStudies.studyList[i].parameters[l].intParam}) ";
            }
          } else {
            chartStudies.studyList[i].displayText =
                "${chartStudies.studyList[i].outColName[0]} ";
          }
          break;
        case TStudyType.STMacd:
          {
            String ot = "(";
            for (int l = 0; l < chartStudies.studyList[i].parameterCnt; l++) {
              if (chartStudies.studyList[i].parameters[l].paramType != "I")
                continue;
              ot += "${chartStudies.studyList[i].parameters[l].intParam},";
            }
            ot = ot.substring(0, ot.length - 1);
            ot += ")";
            chartStudies.studyList[i].displayText = "Macd$ot";
          }
          break;
        case TStudyType.STSuperTrend:
          {
            String ot = "(";
            for (int l = 0; l < chartStudies.studyList[i].parameterCnt; l++) {
              if (chartStudies.studyList[i].parameters[l].paramType != "I")
                continue;
              ot += "${chartStudies.studyList[i].parameters[l].intParam},";
            }
            ot = ot.substring(0, ot.length - 1);
            ot += ")";
            chartStudies.studyList[i].displayText =
                "${chartStudies.studyList[i].outColName[0]}$ot";
          }
          break;
        case TStudyType.STBoll:
          {
            String ot = "(";
            for (int l = 0; l < chartStudies.studyList[i].parameterCnt; l++) {
              if (chartStudies.studyList[i].parameters[l].paramType != "I")
                continue;
              ot += "${chartStudies.studyList[i].parameters[l].intParam},";
            }
            ot = ot.substring(0, ot.length - 1);
            ot += ")";
            chartStudies.studyList[i].displayText = "BB$ot";
          }
          break;
        case TStudyType.STAdx:
          {
            String ot = "(";
            for (int l = 0; l < chartStudies.studyList[i].parameterCnt; l++) {
              if (chartStudies.studyList[i].parameters[l].paramType != "I")
                continue;
              ot += "${chartStudies.studyList[i].parameters[l].intParam},";
            }
            ot = ot.substring(0, ot.length - 1);
            ot += ")";
            chartStudies.studyList[i].displayText = "ADX$ot";
          }
          break;
        default:
          break;
      }
      StudyDef s = getStudy(i);
      if (chartStudies.studyList[i].secondaryState != SecondaryState.NONE) {
        if (secStateCount == 1) {
          _secondaryState = chartStudies.studyList[i].secondaryState;
          s.subGraphIndex = 2;
          secStateCount++;
        } else {
          _tertiaryState = chartStudies.studyList[i].secondaryState;
          s.subGraphIndex = 3;
        }
        chartStudies.studyList[i] = s;
      } else {
        s.subGraphIndex = 0;
        chartStudies.studyList[i] = s;
      }
    }
    if (!initState) {
      DataUtil.calculate(Dataconstants.datas, chartStudies.studyList);
      setState(() {});
    }
  }

  void _addupdateState() {
    this._mainState.clear();
    for (var i = 0; i < chartStudies.studyList.length; i++) {
      if (chartStudies.studyList[i].mainState != MainState.NONE) {
        if (!this._mainState.contains(chartStudies.studyList[i].mainState)) {
          this._mainState.add(chartStudies.studyList[i].mainState);
        }
      } else {
        switch (chartStudies.studyList[i].subGraphIndex) {
          case 2:
            _secondaryState = chartStudies.studyList[i].secondaryState;
            break;
          case 3:
            _tertiaryState = chartStudies.studyList[i].secondaryState;
            break;
        }
      }
    }
  }

  List<Widget> _sectionOne(
      int paramCount, List<TStudyParameterRecord> params, StudyDef studyDef) {
    List<Widget> sectionone = [];
    for (int i = 0; i < paramCount; i++) {
      final controller = TextEditingController();
      controller.text = _getDefaultValue(params[i]);
      sectionone.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${params[i].paramName}",
            /*style: TextStyle(color: Colors.white),*/
          ),
          SizedBox(
            width: 65,
            height: 30,
            child: Center(
              child: TextField(
                controller: controller,
                inputFormatters:
                    _getInputFormatter(params[i].paramType.toLowerCase()),
                keyboardType: params[i].paramType.toLowerCase() != 'c'
                    ? TextInputType.number
                    : TextInputType.name,
                cursorHeight: 20,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (string) {
                  if (string.isEmpty) return;
                  _tempStudyDef = _getStudyDef(studyDef);
                  _tempStudyDef.parameters.forEach((element) {
                    if (element.paramName == studyDef.parameters[i].paramName) {
                      if (element.paramType.toLowerCase() == 'c') {
                        element.charParam = string;
                      } else if (element.paramType.toLowerCase() == 'i') {
                        element.intParam = int.parse(string);
                      } else if (element.paramType.toLowerCase() == 's') {
                        element.singleParam = double.parse(string);
                      } else if (element.paramType.toLowerCase() == 'd') {
                        element.dateParam = DateTime.parse(string).second;
                      }
                    }
                  });
                },
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(3, 0, 1, 5),
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          ),
        ],
      ));
      sectionone.add(const SizedBox(
        height: 5,
      ));
    }
    sectionone.add(_seperator());

    return sectionone;
  }

  StudyDef _getStudyDef(StudyDef studyDef) {
    return StudyDef(
        studyDef.studyType,
        studyDef.mainState,
        studyDef.secondaryState,
        studyDef.sName,
        studyDef.lName,
        studyDef.category,
        studyDef.inColCnt,
        studyDef.inCols,
        studyDef.outColCnt,
        studyDef.outCols,
        studyDef.outColName,
        studyDef.onPriceSG,
        studyDef.useInScale,
        studyDef.zeroBase,
        studyDef.overBSLines,
        studyDef.overBLevel,
        studyDef.overSLevel,
        studyDef.drawStyleCnt,
        studyDef.drawStyle,
        studyDef.colorCnt,
        studyDef.colors,
        _tempStudyDef == null
            ? studyDef.parameterCnt
            : _tempStudyDef.parameterCnt,
        _tempStudyDef == null ? studyDef.parameters : _tempStudyDef.parameters,
        studyDef.extraLevels,
        studyDef.extraLevel1,
        studyDef.extraLevel2,
        studyDef.allowed,
        studyDef.visible,
        studyDef.subGraphIndex,
        studyDef.displayText);
  }

  Widget _seperator() {
    return Column(
      children: [
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  List<Widget> _sectionTwo(int colorCount, List<Color> color, StudyDef studyDef,
      {bool isupdate = false, int selectedStudyindex}) {
    List<Widget> sectionTwo = [];
    for (int i = 0; i < colorCount; i++) {
      sectionTwo.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (studyDef.studyType == TStudyType.STPrice && i == 2)
              ? const Text("Background color")

              ///backGround Color
              : Text(
                  "Color ${i + 1}",
                ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: studyDef.colors[i]),
            onPressed: () {
              ///CALLING COLOR PICKER DAILOG
              _showColorPickerDailog(i, studyDef.colors[i], studyDef,
                  isupdate: isupdate, selectedStudyindex: selectedStudyindex);
            },
            child: null,
          ),
        ],
      ));
    }
    return sectionTwo;
  }

  List<Widget> mergedSection(int paramCount, List<TStudyParameterRecord> params,
      int colorcount, List<Color> defaultcolors, StudyDef studyDef,
      {bool isupdate = false, int selectedStudyindex}) {
    List<Widget> mergedSection = [];
    List<Widget> sectiononeList = [];
    List<Widget> sectionTwoList = [];
    sectiononeList = _sectionOne(paramCount, params, studyDef);
    sectionTwoList = _sectionTwo(defaultcolors.length, defaultcolors, studyDef,
        isupdate: isupdate, selectedStudyindex: selectedStudyindex);
    sectiononeList.addAll(sectionTwoList);

    mergedSection.addAll(sectiononeList);

    return mergedSection;
  }

  List<TextInputFormatter> _getInputFormatter(String paramType) {
    if (paramType == 'f') {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
      ];
    } else if (paramType == 'c') {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
      ];
    } else {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ];
    }
  }

  String _getDefaultValue(TStudyParameterRecord param) {
    if (param.paramType.toLowerCase() == 'c') {
      return param.charParam;
    } else if (param.paramType.toLowerCase() == 'i') {
      return param.intParam.toString();
    } else if (param.paramType.toLowerCase() == 's') {
      return param.singleParam.toString();
    }
    return param.dateParam.toString();
  }

  void _addNewStudy(StudyDef studyDef) {
    //zzzzz
    selectedStudy.add(studyDef);
    Navigator.of(context).pop();
  }

  void _removeStudy(int i) {
    if (chartStudies.studyList[i].secondaryState != SecondaryState.NONE) {
      addedSubgraphs--;
    } else {
      addedPriceGraphs--;
    }
    selectedStudy.removeAt(i);
    chartStudies.studyList.removeAt(i);
    _reloadChart();
    _addupdateState();
    _saveStudySettingToJson();
    Navigator.of(context).pop();
  }

  void _showColorPickerDailog(int index, Color color, StudyDef studyDef,
      {bool isupdate = false, int selectedStudyindex}) {
    _selectedColor = color;
    showDialog(
        context: context,
        builder: (context) {
          var theme = Theme.of(context);
          return AlertDialog(
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: theme.textTheme.bodyText1.color),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Ok',
                      style: TextStyle(color: theme.textTheme.bodyText1.color),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(_selectedColor ?? color);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: color,
                  onColorChanged: (Color color) => _selectedColor = color,
                  colorPickerWidth: MediaQuery.of(context).size.width * 0.7,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: true,
                  displayThumbColor: false,
                  paletteType: PaletteType.hsv,
                  showLabel: false,
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(2.0),
                    topRight: const Radius.circular(2.0),
                  ),
                ),
              ],
            ),
          );
        }).then((value) {
      if (value != null) {
        if (_tempStudyDef == null) _tempStudyDef = _getStudyDef(studyDef);
        // _tempStudyDef.colors.clear();
        // _tempStudyDef.colors = null;
        // _tempStudyDef.colors = [];
        // _tempStudyDef.colors = studyDef.colors.map((e) => e).toList();
        _tempStudyDef.colors[index] = value;
        if (isupdate &&
            studyDef.studyType == TStudyType.STPrice &&
            index == 2) {
          if (_tempBg != null) _tempBg.clear();
          _tempBg = [value, value];
        }
        _showParamDailog(_tempStudyDef,
            isupdate: isupdate, selectedStudyindex: selectedStudyindex);
      }
    });
  }

  void _updateStudies(int selectedStudyindex) {
    chartStudies.studyList[selectedStudyindex] = _tempStudyDef;
    selectedStudy[selectedStudyindex] = _tempStudyDef;
    Navigator.of(context).pop();
  }

  Future<void> _loadStudySetting({bool initState = false}) async {
    final filename = "chart_template";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    if (!file.existsSync()) {
      StudyDef stdDef;
      chartStudies.studyList.clear();
      stdDef = getStudyDef(TStudyType.STPrice.index);
      chartStudies.studyList.add(stdDef);
      stdDef = getStudyDef(TStudyType.STVolume.index);
      chartStudies.studyList.add(stdDef);

      _addupdateState();
      _reloadChart(initState: initState);
      // if (Dataconstants.isFromToolsToFlashTrade == true) {
      //   chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSLine2;
      // } else

      {
        chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSCandle;
      }
      return;
    }
    String value = file.readAsStringSync(); //.then((value)
    if (value == "") {
      _addupdateState();
      _reloadChart(initState: initState);
      return;
    }
    var temp = json.decode("{}");
    try {
      temp = json.decode(value);
    } catch (e) {
      StudyDef stdDef;
      chartStudies.studyList.clear();
      stdDef = getStudyDef(TStudyType.STPrice.index);
      chartStudies.studyList.add(stdDef);
      stdDef = getStudyDef(TStudyType.STVolume.index);
      chartStudies.studyList.add(stdDef);
      chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSCandle;
      _addupdateState();
      _reloadChart(initState: initState);
      return;
    }

    //CHANGE PRICE AND VOLUME COLOR AND DRAWSTYLE//
    var pricetempColor = temp[0]["colors"].split("|");
    _tempBg = [];
    _tempBg.clear();
    _tempBg = [
      Color(int.parse(pricetempColor[2])),
      Color(int.parse(pricetempColor[2]))
    ];
    //CHANGE PRICE AND VOLUME COLOR AND DRAWSTYLE//
    selectedStudy.clear();
    for (int i = 0; i < temp.length; i++) {
      StudyDef temp1 = getStudyDef(temp[i][
          "tstudy_type"]); // //chartStudies.defaultstudyList[temp[i]["tstudy_type"]];

      //Getting saved parameters
      var tempParams = temp[i]["parameters"].split("|");
      for (int i = 0; i < temp1.parameterCnt; i++) {
        if (temp1.parameters[i].paramType.toLowerCase() == 'c') {
          temp1.parameters[i].charParam = tempParams[i];
        }
        if (temp1.parameters[i].paramType.toLowerCase() == 's') {
          temp1.parameters[i].singleParam = double.parse(tempParams[i]);
        }
        if (temp1.parameters[i].paramType.toLowerCase() == 'i') {
          temp1.parameters[i].intParam = int.parse(tempParams[i]);
        }
      }

      //Getting saved colors
      var tempColor = temp[i]["colors"].split("|");
      for (int i = 0; i < temp1.colorCnt; i++) {
        temp1.colors[i] = Color(int.parse(tempColor[i]));
      }

      //Getting saved drawstyle
      var drawstyle = temp[i]["drawStyle"].split("|");
      for (int i = 0; i < temp1.drawStyleCnt; i++) {
        temp1.drawStyle[i] = TDrawStyle.values[int.parse(drawstyle[i])];
      }
      if (temp1.secondaryState != SecondaryState.NONE &&
          temp1.secondaryState != SecondaryState.VOL) {
        addedSubgraphs++;
      } else if (temp1.mainState != MainState.PRICE &&
          temp1.mainState != MainState.NONE) {
        addedPriceGraphs++;
      }

      selectedStudy.add(temp1);
      chartStudies.studyList.add(temp1);

      // if (Dataconstants.isFromToolsToFlashTrade == true) {
      //   chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSLine2;
      // } else
      //{
      //  chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSCandle;
      //}
    }

    if (temp.length > 0) {
      _addupdateState();
      _reloadChart(initState: initState);
    }
  }

  void _saveStudySettingToJson() async {
    //CREATE FILE AMD STORE JSON
    var temp = [];
    UserStudySetting userStudySetting;
    final filename = "chart_template";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    String jsonString;
    for (int i = 0; i < chartStudies.studyList.length; i++) {
      //parameters
      String paramters = "";
      chartStudies.studyList[i].parameters.forEach((element) {
        if (element.paramType.toLowerCase() == "c") {
          paramters += element.charParam + "|";
        }
        if (element.paramType.toLowerCase() == "s") {
          paramters += element.singleParam.toString() + "|";
        }
        if (element.paramType.toLowerCase() == "i") {
          paramters += element.intParam.toString() + "|";
        }
      });
      //color
      String colors = "";
      chartStudies.studyList[i].colors.forEach((element) {
        colors += element.value.toString() + "|";
      });
      //DrawStyle
      String drawStyle = "";
      chartStudies.studyList[i].drawStyle.forEach((element) {
        drawStyle += element.index.toString() + "|";
      });
      if (paramters.trim().isNotEmpty) {
        paramters = paramters.substring(0, paramters.length - 1);
      }
      colors = colors.substring(0, colors.length - 1);
      drawStyle = drawStyle.substring(0, drawStyle.length - 1);

      userStudySetting = new UserStudySetting(
          i,
          chartStudies.studyList[i].studyType.index,
          chartStudies.studyList[i].subGraphIndex,
          paramters,
          colors,
          drawStyle);

      userStudySetting.toJson();
      temp.add(userStudySetting);
    }
    jsonString = json.encode(temp);

    file.writeAsString("");
    file.writeAsString(jsonString);
  }

  void _changeChartStyle({String selectedChartType}) {
    //zzzzz

    if (selectedChartType == "B") {
      chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSPriceBar;
    }
    if (selectedChartType == "C") {
      chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSCandle;
    }
    if (selectedChartType == "L") {
      chartStudies.studyList[0].drawStyle[0] = TDrawStyle.DSLine2;
    }

    _saveStudySettingToJson();
    Navigator.of(context).pop();
    setState(() {});
  }

  Widget _changeDurationButton() {
    return InkWell(
      onTap: () {
        lineOnTick = false;
        Dataconstants.buySellButtonTickByTick = false;
        _showDurationBottomSheet();
      },
      child: Container(
        width: 20,
        height: 25,
        child: Center(
          child: Text(
            _selectedDuration, //Dataconstants.chartTickByTick == true ? "0" : _selectedDuration,
            style: TextStyle(
                color: !themeDark ? Colors.black : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: "Literata"),
          ),
        ),
      ),
    );
  }

  int calcDatesRangeLeft(
    datesRangeTo,
    resolution,
  ) {
    switch (resolution) {
      case "Y":
        return datesRangeTo - 86400 * 365;
      case "6M":
        return datesRangeTo - 86400 * 180;
      case "3M":
        return datesRangeTo - 86400 * 90;
      case "1M":
        return datesRangeTo - 86400 * 30;
      case "W":
        return datesRangeTo - 86400 * 7;
      case "5D":
        return datesRangeTo - 86400 * 5;
      case "1D":
        return datesRangeTo - 86400;
    }
  }

  int calcDatesRangeLeftWithBuisnesDaySkip(datesRangeTo, resolution,
      {buzDays = 1}) {
    ///sssss

    switch (resolution) {
      case "Y":
        return datesRangeTo - (86400 * (365 + buzDays));
      case "6M":
        return datesRangeTo - (86400 * (180 + buzDays));
      case "3M":
        return datesRangeTo - (86400 * (90 + buzDays));
      case "1M":
        return datesRangeTo - (86400 * (30 + buzDays));
      case "W":
        return datesRangeTo - (86400 * (7 + buzDays));
      case "5D":
        return datesRangeTo - (86400 * (5 + buzDays));
      case "1D":
        return datesRangeTo - (86400 * buzDays);
    }
  }

  /// sssss

  int calcBusinessDays(DateTime startDate, DateTime endDate) {
    int count = 0;
    DateTime fromDate =
        new DateTime(startDate.year, startDate.month, startDate.day);
    DateTime toDate = new DateTime(endDate.year, endDate.month, endDate.day);
    while (fromDate.isBefore(toDate) || fromDate.isAtSameMomentAs(toDate)) {
      int dayOfWeek = fromDate.weekday;
      if (dayOfWeek != 6 && dayOfWeek != 7) count++;
      fromDate = fromDate.add(Duration(days: 1));
    }
    return count;

    // int count = 0;
    // while (startDate.isBefore(endDate) ) {
    //   int dayOfWeek = startDate.weekday;
    //   if (dayOfWeek != 6 && dayOfWeek != 7) count++;
    //   startDate = startDate.add(Duration(days:  1));
    // }
    // return count;
  }

  int calcBusinessDaysForDay(DateTime startDate, DateTime endDate) {
    int count = 0;
    DateTime fromDate =
        new DateTime(startDate.year, startDate.month, startDate.day);
    DateTime toDate = new DateTime(endDate.year, endDate.month, endDate.day);
    while (fromDate.isBefore(toDate)) {
      int dayOfWeek = fromDate.weekday;
      if (dayOfWeek != 6 && dayOfWeek != 7) count++;
      fromDate = fromDate.add(Duration(days: 1));
    }
    return count;
  }

  void _showDurationBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: themeDark
              ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          child: ListView(
            children: [
              ListTile(
                title: const Text("Daily"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 60 * 24;

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

                  ///-------------------------------- from to date calculation ---------------------   sssss

                  // DateTime lt = new DateTime(toDate.year, toDate.month, toDate.day-1,
                  //     9, 0).subtract(Duration(hours: 5, minutes: 30));
                  // var bzDay = calcBusinessDays(lt ,toDate);    //calcBusinessDaysForDay  calcBusinessDays
                  // lt = new DateTime(lt.year, lt.month, lt.day-(2 * 1- bzDay),
                  //     9, 0).subtract(Duration(hours: 5, minutes: 30));
                  DateTime lt =
                      new DateTime(toDate.year, toDate.month, toDate.day, 9, 0)
                          .subtract(Duration(hours: 5, minutes: 30));
                  var bzDay = calcBusinessDays(
                      lt, toDate); //calcBusinessDaysForDay  calcBusinessDays
                  lt = new DateTime(2000, lt.month, lt.day, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());

                  _changeDuration(
                      newValue: "D",
                      cPrd: "D",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '1440',
                      chartPeriod: 'D',
                      volumeHidden: false);
                },
              ),
              ListTile(
                title: const Text("Weekly"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 60 * 24 * 7;

                  ///-----------------to date pass-----------------------------------------

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 7, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var bzDay = calcBusinessDays(lt, toDate);

                  // lt = new DateTime(toDate.year, toDate.month, toDate.day-(2 * 7- bzDay),
                  //     9, 0).subtract(Duration(hours: 5, minutes: 30));

                  lt = new DateTime(2000, toDate.month, toDate.day, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());

                  _changeDuration(
                      newValue: "W",
                      cPrd: "W",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '1440',
                      chartPeriod: 'W',
                      volumeHidden: false);
                },
              ),
              ListTile(
                title: const Text("Monthly"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 60 * 24 * 30;

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

                  //------------------------ leftSide date calculate --------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var bzDay = calcBusinessDays(lt, toDate);

                  // lt = new DateTime(toDate.year, toDate.month, toDate.day-(2 * 30- bzDay), 9, 0);
                  lt = new DateTime(2000, toDate.month, toDate.day, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());

                  _changeDuration(
                      newValue: "M",
                      cPrd: "M",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '1440',
                      chartPeriod: 'M',
                      volumeHidden: false);
                },
              ),
              ListTile(
                title: const Text("Yearly"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 60 * 24 * 365;

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');
                  //------------------------ leftside date calculate --------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 365, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));

                  var bzDay = calcBusinessDays(lt, toDate);

                  // lt = new DateTime(toDate.year, toDate.month, toDate.day-(2 * 365- bzDay), 9, 0).subtract(Duration(hours: 5, minutes: 30));

                  lt = new DateTime(2000, toDate.month, toDate.day, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());

                  _changeDuration(
                      newValue: "Y",
                      cPrd: "Y",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '1440',
                      chartPeriod: 'Y',
                      volumeHidden: false);
                },
              ),
              Divider(
                thickness: 1,
              ),
              /*ListTile(
                title: const Text("0 Minute"),
                onTap: () async {
                  timer.cancel();
                  buySellIconColor = false;


                  // for(int i = selectedStudy.length-1;i>1;i--){
                  //   //print(i);
                  //   _removeStudy(i); }


                  Dataconstants.chartTickByTick = true;
                  TimeOfDay intraDayTime = TimeOfDay(hour: 9, minute: 0);
                  final now = new DateTime.now();
                  var finalIntraDayTime = DateTime(now.year, now.month, now.day,
                          intraDayTime.hour, intraDayTime.minute)
                      .subtract(Duration(hours: 5, minutes: 30));
                  //print(" finalIntraDayTime : $finalIntraDayTime");
                  var intraDayTimePass = DateUtil.getIntFromDate1Chart(
                      finalIntraDayTime.toString());
                  Dataconstants.modelForChart = widget.currentModel;
                  await Dataconstants.iqsClient.sendChartRequest(
                    widget.currentModel,
                    intraDayTimePass,
                  );
                  //print('Chart request sent');
                  showLoading = false;
                  symbol = widget.symbol;
                  _changeChartStyle(selectedChartType: "L");  //cccc

                  // Future.delayed(Duration(milliseconds: 1000), () {
                  //   setState(() {});
                  // });
                },
              ),*/
              ListTile(
                title: const Text("1 Minute"),
                onTap: () async {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  actualCurrentTimeEpoch =
                      DateTime.now().millisecondsSinceEpoch;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 1;

                  ///---------------current day from 9:00 pass---------------------------
                  TimeOfDay intraDayTime = TimeOfDay(hour: 9, minute: 0);
                  final now = new DateTime.now();
                  var finalIntraDayTime = DateTime(now.year, now.month, now.day,
                          intraDayTime.hour, intraDayTime.minute)
                      .subtract(Duration(hours: 5, minutes: 30));
                  //print(" finalIntraDayTime : $finalIntraDayTime");
                  var intraDayTimePass = DateUtil.getIntFromDate1Chart(
                      finalIntraDayTime.toString());
                  //print('intraDayTimePass  $intraDayTimePass');

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

//---------------------------- leftSideTime(FromDate)----------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());
                  //print(leftSideTime);

                  _changeDuration(
                      newValue: "1",
                      cPrd: "I",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      // calcDatesRangeLeft(toDatePass, "1D").toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '1',
                      chartPeriod: 'I',
                      volumeHidden: false);
                  //print(
                  //     "from date  received ${calcDatesRangeLeft(toDatePass, "1D")}");
                },
              ),
              ListTile(
                title: const Text("5 Minute"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  actualCurrentTimeEpoch =
                      DateTime.now().millisecondsSinceEpoch;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 5;

                  ///---------------current day from 9:00 pass---------------------------
                  TimeOfDay intraDayTime = TimeOfDay(hour: 9, minute: 0);
                  final now = new DateTime.now();
                  var finalIntraDayTime = DateTime(now.year, now.month, now.day,
                          intraDayTime.hour, intraDayTime.minute)
                      .subtract(Duration(hours: 5, minutes: 30));
                  //print(" finalIntraDayTime : $finalIntraDayTime");
                  var intraDayTimePass = DateUtil.getIntFromDate1Chart(
                      finalIntraDayTime.toString());
                  //print('intraDayTimePass  $intraDayTimePass');

                  ///-----------------to date pass-----------------------------------------`

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

//---------------------------- leftSideTime(FromDate)----------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());
                  //print(leftSideTime);
                  _changeDuration(
                      newValue: "5",
                      cPrd: "I",
                      exChar: widget.currentModel.exch,
                      //'N',
                      scripCode: widget.currentModel.exchCode.toString(),
                      // "22",
                      symbol: widget.currentModel.name.toString(),
                      // 'ACC',
                      fromDatepas2:
                          // calcDatesRangeLeft(toDatePass, "1D").toString(),
                          leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      //  "1656308532", //  toDatePass.toString(),//    '1655980175',
                      timeInterval: '5',
                      chartPeriod: 'I',
                      volumeHidden: false);
                  //print(
                  //     "from date  received 5 : ${calcDatesRangeLeft(toDatePass, "1D")}");
                },
              ),
              ListTile(
                title: const Text("15 Minute"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  actualCurrentTimeEpoch =
                      DateTime.now().millisecondsSinceEpoch;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 15;

                  ///-----------------from date pass-----------------------------------------
                  var fromDate = DateTime.now()
                      .subtract(const Duration(days: 1)); // DateTime.now();
                  //print('current date Time $fromDate');
                  var fromDatePass =
                      DateUtil.getIntFromDate1Chart(fromDate.toString());
                  //print('fromDate Pass $fromDatePass');

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');
                  //print(
                  //     "from date  received 15 :${calcDatesRangeLeft(toDatePass, "1D")}");

                  //---------------------------- leftSideTime(FromDate)----------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());
                  //print(leftSideTime);

                  _changeDuration(
                      newValue: "15",
                      cPrd: "I",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '15',
                      chartPeriod: 'I',
                      volumeHidden: false);
                },
              ),
              ListTile(
                title: const Text("30 Minute"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  actualCurrentTimeEpoch =
                      DateTime.now().millisecondsSinceEpoch;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 30;

                  ///-----------------from date pass-----------------------------------------
                  var fromDate = DateTime.now()
                      .subtract(const Duration(days: 1)); // DateTime.now();
                  //print('current date Time $fromDate');
                  var fromDatePass =
                      DateUtil.getIntFromDate1Chart(fromDate.toString());
                  //print('fromDate Pass $fromDatePass');

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

                  //---------------------------- leftSideTime(FromDate)----------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());
                  //print(leftSideTime);
                  _changeDuration(
                      newValue: "30",
                      cPrd: "I",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '30',
                      chartPeriod: 'I',
                      volumeHidden: false);
                },
              ),
              ListTile(
                title: const Text("60 Minute"),
                onTap: () {
                  Dataconstants.chartTickByTick = false;

                  ///-----------update chart-----------  ssss
                  actualCurrentTime = DateTime.now().minute;
                  timer.cancel();
                  timer = Timer.periodic(
                      const Duration(seconds: 1), updateChartData);
                  timePeriod = 60;

                  ///-----------------from date pass-----------------------------------------
                  var fromDate = DateTime.now()
                      .subtract(const Duration(days: 1)); // DateTime.now();
                  //print('current date Time $fromDate');
                  var fromDatePass =
                      DateUtil.getIntFromDate1Chart(fromDate.toString());
                  //print('fromDate Pass $fromDatePass');

                  ///-----------------to date pass----------------------------------------- `

                  var toDate =
                      DateTime.now().subtract(Duration(hours: 5, minutes: 30));
                  //print('toDate $toDate');
                  var toDatePass =
                      DateUtil.getIntFromDate1Chart(toDate.toString());
                  //print('toDate Pass $toDatePass');

//---------------------------- leftSideTime(FromDate)----------------------------------

                  DateTime lt = new DateTime(
                          toDate.year, toDate.month, toDate.day - 30, 9, 0)
                      .subtract(Duration(hours: 5, minutes: 30));
                  var leftSideTime =
                      DateUtil.getIntFromDate1Chart(lt.toString());
                  //print(leftSideTime);

                  _changeDuration(
                      newValue: "60",
                      cPrd: "I",
                      exChar: widget.currentModel.exch,
                      scripCode: widget.currentModel.exchCode.toString(),
                      symbol: widget.currentModel.name.toString(),
                      fromDatepas2: leftSideTime.toString(),
                      toDatePass2: toDatePass.toString(),
                      timeInterval: '60',
                      chartPeriod: 'I',
                      volumeHidden: false);
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  void _changeDuration({
    String newValue,
    String cPrd,
    String exChar,
    String scripCode,
    String symbol,
    String fromDatepas2,
    String toDatePass2,
    String timeInterval,
    String chartPeriod,
    bool volumeHidden,
  }) {
    _ChartState.chartPeriod = cPrd;
    // if (newValue == "Daily") {
    //16 Jun 2022 - Same API has been called in Daily and Intraday/ Change the code here to handle different time frames.
    _selectedDuration = newValue; //"D";
    getDataFromServer(
      exChar,
      scripCode,
      symbol,
      fromDatepas2,
      toDatePass2,
      timeInterval,
      chartPeriod,
      // widget.exChar,
      // widget.scripCode,
      // widget.symbol,
      // widget.fromDate,
      // widget.toDate,
      // widget.timeInterval,
      // widget.chartPeriod
    );
    // }
    // else {
    //   _selectedDuration = "I";
    //   getDataFromServer(
    //       widget.exChar,
    //       widget.scripCode,
    //       widget.symbol,
    //       widget.fromDate,
    //       widget.toDate,
    //       widget.timeInterval,
    //       widget.chartPeriod);
    // }
    Navigator.of(context).pop();
  }

  // ignore: non_constant_identifier_names
  void getDataFromServer(
      String pexChar,
      String pscripCode,
      final String psymbol,
      final String pfromDate,
      final String ptoDate,
      final String ptimeInterval,
      final String pchartPeriod) {
    dataAvailable = false;
    final Future<String> future = getDataPOST2(pexChar, pscripCode, psymbol,
        pfromDate, ptoDate, ptimeInterval, pchartPeriod);
    future.then((String result) {
      FlutterChart chartData = FlutterChart.fromJson(json.decode(result));
      KLineEntity d;
      Dataconstants.datas = [];
      for (int i = 0; i < chartData.t.length; i++) {
        ///ssss
        d = KLineEntity.fromCustom(
            open: chartData.o[i],
            close: chartData.c[i],
            high: chartData.h[i],
            low: chartData.l[i],
            vol: chartData.v[i].toDouble());
        d.time = d.datetime = chartData.t[i] * 1000;
        Dataconstants.datas.add(d);
      }

      Dataconstants.datas.reversed.toList().cast<KLineEntity>();
      DataUtil.calculate(Dataconstants.datas, chartStudies.studyList);

      // //print(Dataconstants.datas);
      showLoading = false;
      symbol = widget.symbol;
      if (chartData.t.length > 0) dataAvailable = true;
      setState(() {});
    }).catchError((e) {
      //print(e);
      showLoading = false;
      setState(() {});
    });
  }

  ///ssssss
  // var actualCurrentTime = DateTime.now().minute;
  void updateChartData(Timer timer) {
    // if (Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesOpen) {
    var currentTime = DateTime.now().minute;
    var currentTimeEpoch = DateTime.now().millisecondsSinceEpoch;
    KLineEntity d;
    if (Dataconstants.datas.length == 0) {
      dataAvailable = false;
      return;
    }
    dataAvailable = true;
    var high = widget.currentModel.close >
                Dataconstants.datas[Dataconstants.datas.length - 1].high
            ? widget.currentModel.close
            : Dataconstants.datas[Dataconstants.datas.length - 1].high,
        low = widget.currentModel.close <
                Dataconstants.datas[Dataconstants.datas.length - 1].low
            ? widget.currentModel.close
            : Dataconstants.datas[Dataconstants.datas.length - 1].low;
    var aa = lastFormedCandleTime;
    if (lastFormedCandleTime != null) {
      if (currentTime % timePeriod == 0 &&
          (currentTime != lastFormedCandleTime)) {
        lastFormedCandleTime = currentTime;
        d = KLineEntity.fromCustom(
          open: widget.currentModel.close,
          close: widget.currentModel.close,
          high: widget.currentModel.close,
          low: widget.currentModel.close,
          vol: 0.0,
          time: currentTimeEpoch, //1658578260107 //currentTimeEpoch,
          // double.parse(
          //     "${widget.currentModel.exchQty}")
        );
        high = widget.currentModel.close;
        low = widget.currentModel.close;
        // d.time= d.datetime = DateTime.now();
        Dataconstants.datas.add(d);
        var e = Dataconstants.datas.reversed.toList();
        DataUtil.calculate(Dataconstants.datas, chartStudies.studyList);
        showLoading = false;
        symbol = widget.symbol;
        setState(() {});
      }
    } else {
      lastFormedCandleTime = currentTime;
    }
    Dataconstants.datas[Dataconstants.datas.length - 1].time = currentTimeEpoch;
    Dataconstants.datas[Dataconstants.datas.length - 1].open =
        Dataconstants.datas[Dataconstants.datas.length - 1].open;
    Dataconstants.datas[Dataconstants.datas.length - 1].high = high;
    Dataconstants.datas[Dataconstants.datas.length - 1].low = low;
    Dataconstants.datas[Dataconstants.datas.length - 1].close =
        widget.currentModel.close;
    Dataconstants.datas[Dataconstants.datas.length - 1].vol +=
        double.parse("${widget.currentModel.lastTickQty}");
    Dataconstants.datas.last;
    setState(() {});
    // }
  }

  Future<String> getDataPOST(
      String pexChar,
      String pscripCode,
      final String psymbol,
      final String pfromDate,
      final String ptoDate,
      final String ptimeInterval,
      final String pchartPeriod) async {
    var url = 'http://180.149.242.215:93/api/Middleware/';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'Exch': 'N',
      //   'ScripCode': '22',
      //   'FromDate': '1649043000',
      //   'ToDate': '1649083853',
      //   'TimeInterval': '15',
      //   'ChartPeriod': 'I'
      // }),
      body: jsonEncode(<String, String>{
        'Exch': pexChar,
        'ScripCode': pscripCode,
        'FromDate': pfromDate,
        'ToDate': ptoDate,
        'TimeInterval': ptimeInterval,
        'ChartPeriod': pchartPeriod
      }),
    );

    String result;
    if (response.statusCode == 200) {
      result = response.body;
    } else {}
    return result;
  }

  Future<String> getDataPOST2(
      String pexChar,
      String pscripCode,
      final String psymbol,
      final String pfromDate,
      final String ptoDate,
      final String ptimeInterval,
      final String pchartPeriod) async {
    var url =
        'https://marketstreams.icicidirect.com/chart/api/chart/symbolhistoricaldata/';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Exch': pexChar,
        'ScripCode': pscripCode,
        'FromDate': pfromDate,
        'ToDate': ptoDate,
        'TimeInterval': ptimeInterval,
        'ChartPeriod': pchartPeriod
      }),
    );

    String result;
    if (response.statusCode == 200) {
      result = response.body;
    } else {}
    return result;
  }

  flutterChart(
      {String exch,
      int scripCode,
      int fromDate,
      int toDate,
      String timeInterval,
      String chartPeriod}) async {
    try {
      var url =
          // "https://marketstreams.icicidirect.com/chart/api/chart/symbolhistoricaldata";
      'https://${Dataconstants.iqsIP}/chart/api/chart/symbol15minchartdata';
      Map data = {
        "Exch": exch,
        "ScripCode": scripCode,
        "FromDate": fromDate,
        "ToDate": toDate,
        "TimeInterval": timeInterval,
        "ChartPeriod": chartPeriod,
      };
      var body = jsonEncode(data);

      var response = await http
          .post(Uri.parse(url),
              headers: {"Content-Type": "application/json"}, body: body)
          .timeout(const Duration(seconds: 20));

      var data2 = jsonDecode(response.body);
      //var chartDataaaa = data2["t"];
    } catch (e) {}
  }
}
