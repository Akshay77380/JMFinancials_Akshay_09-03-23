import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/algoscreen/custom_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/AlgoModels/fetchAlgo_Model.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/search_bar_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/algoWidget/algoNumberField.dart';
import '../../widget/decimal_text.dart';
import 'advanceOrder_Review.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AdvanceOrder extends StatefulWidget {
  final String name;
  final int id;
  final String phrase;
  final String type;
  final String segment;
  final ScripInfoModel modifyModel;
  final List<AlgoParam> paramModel;
  final bool algoPriceBetterment;

  const AdvanceOrder({this.name, this.id, this.phrase, this.type, this.segment, this.modifyModel, this.paramModel, this.algoPriceBetterment});

  @override
  _AdvanceOrderState createState() => _AdvanceOrderState(name, id, phrase, type, segment, paramModel);
}

class _AdvanceOrderState extends State<AdvanceOrder> with TickerProviderStateMixin {
  _AdvanceOrderState(name, id, phrase, type, segment, paramModel);

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _atMarket = TextEditingController();
  TextEditingController _qtyContoller = TextEditingController();
  TextEditingController _slicingController = TextEditingController();
  TextEditingController _limitController = TextEditingController();
  TextEditingController _priceLowController = TextEditingController();
  TextEditingController _priceHighController = TextEditingController();
  TextEditingController _averagingEntryDifference = TextEditingController();
  TextEditingController _averagingExitDifference = TextEditingController();

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey _orderSlicingKey = GlobalKey();
  GlobalKey _orderSlicingKey1 = GlobalKey();
  GlobalKey _orderSlicingKey2 = GlobalKey();
  GlobalKey _orderSlicingKey3 = GlobalKey();
  GlobalKey _priceBandKey4 = GlobalKey();
  GlobalKey _priceBandKey5 = GlobalKey();
  GlobalKey _averagingKey6 = GlobalKey();
  GlobalKey _averagingKey7 = GlobalKey();
  GlobalKey _averagingKey8 = GlobalKey(); //ssss

  bool firstLoginOrderSliceBackPress;
  bool firstLoginPriceBandBackPress;
  bool firstLoginAveragingBackPress;

  DateTime ExchStartDate = new DateTime(1980, 1, 1, 0, 0, 0);
  int starrrtdatee;

  int date;

  final FocusNode _oldPassFocus = FocusNode();
  DateTime _dateTime = DateTime.now();
  int _currentMinute = DateTime.now().minute;

  TimeOfDay _timeInterval = TimeOfDay(hour: 00, minute: 00);

  //------------->start time-------------------//

  TimeOfDay _startTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  String startTime = Dataconstants.isAwaitingAlgoModify == true
      ?
      // Dataconstants.awaitinggAlgoToAdvanceScreen.startTime
      DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.startTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
      : Dataconstants.isFinishedAlgoModify == true
          ?
          // Dataconstants.finishedAlgoToAdvanceScreen.startTime??
          DateUtil.getDateWithFormatForAlgoDate(Dataconstants.finishedAlgoToAdvanceScreen.startTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
          : "${(DateTime.now().hour).toString().padLeft(2, '0')}:${(DateTime.now().minute).toString().padLeft(2, '0')}"; // :${DateTime.now().second}

  //------end Time controller----//

  TimeOfDay _endTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  String endTime = Dataconstants.isAwaitingAlgoModify == true
      ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.endTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
      : Dataconstants.isFinishedAlgoModify == true
          ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.finishedAlgoToAdvanceScreen.endTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
          : "${(DateTime.now().hour).toString().padLeft(2, '0')}:${(DateTime.now().minute).toString().padLeft(2, '0')}";

  String timeInterval = Dataconstants.isAwaitingAlgoModify == true
      ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy mm:ss").toString().split(' ')[1].split(".")[0] ?? " "
      : Dataconstants.isFinishedAlgoModify == true
          ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.finishedAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy mm:ss").toString().split(' ')[1].split(".")[0] ?? " "
          : "00.00"; //"${(_timeInterval.hour)}:${_timeInterval.minute}";

  int timeIntervalConverted = 0;

  int startTimeConverted = DateTime.now().second;
  int endTimeConverted = DateTime.now().second;
  bool isStartTime;
  bool isPlay = true;

  var model;
  String stock;
  int _exchTogglePosition = 0, _newsNseCode = 0, atMarket = 0, productType = 1, radioButton = 2, groupValue = 0;

  bool modelFlipped = false;
  ScripInfoModel currentModel;
  TabController _tabController;
  List<int> pos = [-1, -1, -1, -1];
  List<ScripInfoModel> futures;
  List<int> optionDates;
  bool addedToWatchlist = false;
  ScripInfoModel underlyingModel;
  String totalQty;

  String radioButtonItem = 'ONE';

  String dropdownvalue = '1 minute';
  var items = [
    '1 minute',
    '2 minute',
    '5 minute',
    '15 minute',
    '30 minute',
    '60 minute',
  ];
  List<dynamic> newParam;
  var paramName;
  var finalValues;

  isMultipleOf(val, tickSize) {
    return !((double.parse(val) / tickSize).round() / (1 / tickSize) == double.parse(val));
  }

  // isMultipleOf = function (x, y) {
  //    return Math.round(parseFloat(x) / y) / (1 / y) === parseFloat(x);
  //  };

  //ssss
  @override
  void initState() {
    Dataconstants.isFromBasketOrder = false;
    super.initState();

    //--------------initial start time for picker ------------

    _startTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

    //--------------initial end Time for picker -----------------

    _endTime = _currentMinute >= 45 ? TimeOfDay(hour: DateTime.now().hour + 1, minute: DateTime.now().minute - 45) : TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 15);
    //------------**********************---------------------

    //----------------initial start Time --------------------
    startTime = Dataconstants.isAwaitingAlgoModify == true
        ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.startTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
        : Dataconstants.isFinishedAlgoModify == true
            ? "${(DateTime.now().hour).toString().padLeft(2, '0')}:${(DateTime.now().minute.toString().padLeft(2, '0'))}"
            : "${(DateTime.now().hour.toString().padLeft(2, '0'))}:${(DateTime.now().minute.toString().padLeft(2, '0'))}";

//----------------- initial end time --------------------------

    endTime = Dataconstants.isAwaitingAlgoModify == true
        ? DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.endTime, "dd-MM-yyyy HH:mm").toString().split(' ')[1].split(".")[0] ?? "00:00"
        : Dataconstants.isFinishedAlgoModify == true
            ? (_currentMinute >= 45)
                ? "${(DateTime.now().hour + 1).toString().padLeft(2, '0')}" ":${(DateTime.now().minute - 45).toString().padLeft(2, '0')}"
                : "${DateTime.now().hour}:${(DateTime.now().minute + 15).toString().padLeft(2, '0')}"
            : (_currentMinute >= 45)
                ? "${(DateTime.now().hour + 1).toString().padLeft(2, '0')}" ":${(DateTime.now().minute - 45).toString().padLeft(2, '0')}"
                : "${(DateTime.now().hour).toString().padLeft(2, '0')}:${(DateTime.now().minute + 15).toString().padLeft(2, '0')}";

    //---------------initial Time Interval-----------------------------

    _timeInterval = Dataconstants.isAwaitingAlgoModify == true
        ? TimeOfDay(
            hour: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy mm").toString().split(' ')[1].split(".")[0]),
            minute: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy ss").toString().split(' ')[1].split(".")[0]))
        : Dataconstants.isFinishedAlgoModify == true
            ? TimeOfDay(
                hour: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.finishedAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy mm").toString().split(' ')[1].split(".")[0]),
                minute: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.finishedAlgoToAdvanceScreen.timeInterval, "dd-MM-yyyy ss").toString().split(' ')[1].split(".")[0]))
            : TimeOfDay(hour: 00, minute: 00);

    //-----------end Time interval_---------------------------

    uiList = [];
    finalValues = List.filled(widget.paramModel.length, "");
    _averagingEntryDifference.text = Dataconstants.isAwaitingAlgoModify == true
        ? Dataconstants.awaitinggAlgoToAdvanceScreen.avgEntryDiff.toString() ?? "0.0"
        : Dataconstants.isFinishedAlgoModify == true
            ? Dataconstants.finishedAlgoToAdvanceScreen.avgEntryDiff.toString() ?? "0.0"
            : "0.0";

    _averagingExitDifference.text = Dataconstants.isAwaitingAlgoModify == true
        ? Dataconstants.awaitinggAlgoToAdvanceScreen.avgExitDiff.toString() ?? "0"
        : Dataconstants.isFinishedAlgoModify == true
            ? Dataconstants.finishedAlgoToAdvanceScreen.avgExitDiff.toString() ?? "0.0"
            : "0.0";
    _tabController = TabController(length: 4, vsync: this);

    if (Dataconstants.algoScriptModel != null) {
      _exchTogglePosition = Dataconstants.algoScriptModel.exch == 'N' ? 0 : 1;
    }
    if (Dataconstants.isAwaitingAlgoModify == true || Dataconstants.isFinishedAlgoModify == true || Dataconstants.isFromScripDetailToAdvanceScreen == true) {
      Dataconstants.algoScriptModel = widget.modifyModel;
      currentModel = Dataconstants.algoScriptModel;
      _exchTogglePosition = currentModel.exch == 'N' ? 0 : 1;

      if (Dataconstants.isFinishedAlgoModify == true) {
        groupValue = Dataconstants.finishedAlgoToAdvanceScreen.buySell == "B" ? 0 : 1;
        productType = Dataconstants.finishedAlgoToAdvanceScreen.orderType == "D" ? 1 : 0;
        radioButton = Dataconstants.finishedAlgoToAdvanceScreen.avgDirection == "U" ? 1 : 2;
        atMarket = Dataconstants.finishedAlgoToAdvanceScreen.atMarket == "M" ? 0 : 1;

        timeIntervalConverted = _timeInterval.hour * 60 + _timeInterval.minute;

        int _currentMinute = DateTime.now().minute;

        _startTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

        _endTime = _currentMinute >= 45 ? TimeOfDay(hour: DateTime.now().hour + 1, minute: DateTime.now().minute - 45) : TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 15);
      } else if (Dataconstants.isAwaitingAlgoModify == true) {
        groupValue = Dataconstants.awaitinggAlgoToAdvanceScreen.buySell == "B" ? 0 : 1;
        productType = Dataconstants.awaitinggAlgoToAdvanceScreen.orderType == "D" ? 1 : 0;
        radioButton = Dataconstants.awaitinggAlgoToAdvanceScreen.avgDirection == "U" ? 1 : 2;
        atMarket = Dataconstants.awaitinggAlgoToAdvanceScreen.atMarket == "M" ? 0 : 1;
        // dropdownvalue =
        // "${Dataconstants.awaitinggAlgoToAdvanceScreen.histSize
        //     .toString()} minute";

        timeIntervalConverted = _timeInterval.hour * 60 + _timeInterval.minute;

        _currentMinute = int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.startTime, "dd-MM-yyyy mm").toString().split(' ')[1].split(".")[0]);

        _startTime = TimeOfDay(
          hour: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.startTime, "dd-MM-yyyy HH").toString().split(' ')[1].split(".")[0]),
          minute: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.startTime, "dd-MM-yyyy mm").toString().split(' ')[1].split(".")[0]),
        );
        _endTime = TimeOfDay(
            hour: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.endTime, "dd-MM-yyyy HH").toString().split(' ')[1].split(".")[0]),
            minute: int.tryParse(DateUtil.getDateWithFormatForAlgoDate(Dataconstants.awaitinggAlgoToAdvanceScreen.endTime, "dd-MM-yyyy mm").toString().split(' ')[1].split(".")[0]));
      }
    }

    startTimeConverted = _startTime.hour * 60 * 60 + _startTime.minute * 60;
    endTimeConverted = _endTime.hour * 60 * 60 + _endTime.minute * 60;
    CommonFunction.changeStatusBar();
  }

  void firstLoginOrderSlice() async {
    var prefs = await SharedPreferences.getInstance();
    var firstLoginOrderSlice = prefs.getBool("firstLoginOrderSlice");
    if (firstLoginOrderSlice == null || firstLoginOrderSlice == false) {
      initTargets();
      WidgetsBinding.instance.addPostFrameCallback(_layout);
    }
  }

  void firstLoggedInPriceBand() async {
    var prefs = await SharedPreferences.getInstance();
    var firstLoggedInPriceBand = prefs.getBool("firstLoggedInPriceBand");
    if (firstLoggedInPriceBand == null || firstLoggedInPriceBand == false) {
      initTargets();
      WidgetsBinding.instance.addPostFrameCallback(_layout);
    }
  }

  void firstLoggedInAveraging() async {
    var prefs = await SharedPreferences.getInstance();
    var firstLoggedInAveraging = prefs.getBool("firstLoggedInAveraging");
    if (firstLoggedInAveraging == null || firstLoggedInAveraging == false) {
      initTargets();
      WidgetsBinding.instance.addPostFrameCallback(_layout);
    }
  }

  void _layout(_) {
    Future.delayed(Duration(milliseconds: 500), () {
      showTutorial();
    });
  }

  void showTutorial() {
    //SSSS
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.9,
      pulseEnable: false,
      hideSkip: true,
      onSkip: () {},
    )..show();
    tutorialCoachMark..next();
  }

  void initTargets() {
    targets = [];

    targets.add(
      //SSSS

      TargetFocus(
        identify: "Target 0",
        keyTarget: _orderSlicingKey,
        enableOverlayTab: false,
        enableTargetTab: false,
        color: Colors.black,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),

          TargetContent(
              align: ContentAlign.top,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "This is the total quantity you want to buy / sell",
                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.id == 1 ? "1/4" : "1/6",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )),

          TargetContent(
            align: ContentAlign.bottom,
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                // shape :
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(40),
                // ),
                // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),

                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Utils.greyColor)))),
                onPressed: () {
                  tutorialCoachMark..next();
                },
                child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    height: 40,
                    width: 145,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                    )),
              ),
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
        // radius: 28,
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: false,
        enableTargetTab: false,
        identify: "Target 1",
        keyTarget: _orderSlicingKey1,
        color: Colors.black,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 290),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.id == 3
                          ? "This is the quantity that will be placed once the averaging conditions are met"
                          : "This is the quantity which will be placed periodically till you touch the total quantity or the end time",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.id == 1 ? "2/4" : "2/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    // SizedBox(height: 5,),
                  ],
                ),
              )),
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          tutorialCoachMark..previous();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                        ),
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                        // highlightedBorderColor: Colors.white,
                        // focusColor: Colors.white,
                        // borderSide: BorderSide(
                        //   width: 1.0,
                        //   color: Colors.white,
                        //   style: BorderStyle.solid,
                        // // ),

                        child: Text(
                          "Previous",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(40),
                        // ),
                        // color: Color(0xFF5367FC),
                        onPressed: () {
                          tutorialCoachMark..next();
                        },
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                            // height: 40,
                            width: 70,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Next ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                            )),
                      ),
                    ],
                  ),
                ],
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    if (widget.id != 3)
      targets.add(TargetFocus(
        enableOverlayTab: false,
        enableTargetTab: false,
        identify: "Target 2",
        keyTarget: _orderSlicingKey2,
        color: Colors.black,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 355),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "This is the time difference you want to keep between two slices",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.id == 1 ? "3/4" : "3/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              )),
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          tutorialCoachMark..previous();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                        ),
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                        // highlightedBorderColor: Colors.white,
                        // focusColor: Colors.white,
                        // borderSide: BorderSide(
                        //   width: 1.0,
                        //   color: Colors.white,
                        //   style: BorderStyle.solid,
                        // ),
                        child: Text(
                          "Previous",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        //  shape: RoundedRectangleBorder(
                        //    borderRadius: BorderRadius.circular(40),
                        //  ),
                        // //  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                        //  color: Color(0xFF5367FC),
                        onPressed: () {
                          tutorialCoachMark..next();
                        },
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                            // height: 40,
                            width: 70,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(" Next ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                            )),
                      ),
                    ],
                  ),
                ],
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ));
    // if (widget.id == 3)
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: _orderSlicingKey3,
      color: Colors.black,
      enableOverlayTab: false,
      enableTargetTab: false,
      contents: [
        //Skip
        TargetContent(
            align: ContentAlign.top,
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.id == 3 ? 365 : 395),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    tutorialCoachMark.skip();
                    if (widget.id == 1) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('firstLoginOrderSlice', true);
                    }
                    if (widget.id == 2) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('firstLoggedInPriceBand', true);
                    }
                    if (widget.id == 3) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('firstLoggedInAveraging', true);
                    }
                  },
                  child: Container(
                    child: Text(
                      "Skip",
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            )),
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "This is the time between which the algorithm will execute",
                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                ),
                // Text("will execute",
                //   style: TextStyle(fontWeight: FontWeight.w400, color:Colors.white, fontSize: 17.0),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.id == 1
                            ? "4/4"
                            : widget.id == 3
                                ? "3/6"
                                : "4/6",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                // SizedBox(height: 5,),
              ],
            )),
        TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if(widget.id!=1)
                    OutlinedButton(
                      onPressed: () async {
                        tutorialCoachMark..previous();
                      },
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                      // highlightedBorderColor: Colors.white,
                      // focusColor: Colors.white,
                      // borderSide: BorderSide(
                      //   width: 1.0,
                      //   color: Colors.white,
                      //   style: BorderStyle.solid,
                      // ),
                      child: Text(
                        "Previous",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(40),
                      // ),
                      //
                      // color: Color(0xFF5367FC),
                      onPressed: () async {
                        widget.id == 1 ? tutorialCoachMark.finish() : tutorialCoachMark.next();
                        if (widget.id == 1) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('firstLoginOrderSlice', true);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                          // height: 40,
                          width: 70,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(widget.id == 1 ? "Got it" : " Next ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                          )),
                    ),
                  ],
                ),
              ],
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));

    if (widget.id == 2)
      targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: _priceBandKey4,
        color: Colors.black,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 530),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "This is the price below "
                      "which you do not want the Last Traded Price to go, while placing an order",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "5/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            tutorialCoachMark..previous();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                          ),
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                          // highlightedBorderColor: Colors.white,
                          // focusColor: Colors.white,
                          // borderSide: BorderSide(
                          //   width: 1.0,
                          //   color: Colors.white,
                          //   style: BorderStyle.solid,
                          // ),
                          child: Text(
                            "Previous",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(40),
                          // ),
                          // color: Color(0xFF5367FC),
                          onPressed: () {
                            tutorialCoachMark..next();
                          },
                          child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                              // height: 40,
                              width: 70,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
        shape: ShapeLightFocus.RRect,
      ));
    if (widget.id == 2)
      targets.add(TargetFocus(
        identify: "Target 5",
        keyTarget: _priceBandKey5,
        color: Colors.black,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 445),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "This is the price above "
                      "which you do not want the Last Traded Price to go, while placing an order",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "6/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              tutorialCoachMark..previous();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                            ),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                            // highlightedBorderColor: Colors.white,
                            // focusColor: Colors.white,
                            // borderSide: BorderSide(
                            //   width: 1.0,
                            //   color: Colors.white,
                            //   style: BorderStyle.solid,
                            // ),
                            child: Text(
                              "Previous",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                            //
                            // color: Color(0xFF5367FC),
                            onPressed: () async {
                              tutorialCoachMark..finish();
                              if (widget.id == 2) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('firstLoggedInPriceBand', true);
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                // height: 40,
                                width: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Got it", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
        shape: ShapeLightFocus.RRect,
      ));

    if (widget.id == 3)
      targets.add(TargetFocus(
        identify: "Target 6",
        keyTarget: _averagingKey6,
        color: Colors.black,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: EdgeInsets.only(bottom: 415),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "This is the desired direction in which you want the market to move",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "4/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    // SizedBox(height: 5,),
                  ],
                ),
              )),
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          tutorialCoachMark..previous();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                        ),
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                        // highlightedBorderColor: Colors.white,
                        // focusColor: Colors.white,
                        // borderSide: BorderSide(
                        //   width: 1.0,
                        //   color: Colors.white,
                        //   style: BorderStyle.solid,
                        // ),
                        child: Text(
                          "Previous",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(40),
                        // ),
                        //
                        // color: Color(0xFF5367FC),
                        onPressed: () {
                          tutorialCoachMark..next();
                        },
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                            // height: 40,
                            width: 70,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(" Next ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                            )),
                      ),
                    ],
                  ),
                ],
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ));

    if (widget.id == 3)
      targets.add(TargetFocus(
        identify: "Target 7",
        keyTarget: _averagingKey7,
        color: Colors.black,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 472),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "This is the minimum drop/rise in price wrt Averaging reference price",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 17.0),
                    ),
                    // Text("reference price",
                    //   style: TextStyle(fontWeight: FontWeight.w400, color:Colors.white, fontSize: 17.0),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "5/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              tutorialCoachMark..previous();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                            ),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                            // highlightedBorderColor: Colors.white,
                            // focusColor: Colors.white,
                            // borderSide: BorderSide(
                            //   width: 1.0,
                            //   color: Colors.white,
                            //   style: BorderStyle.solid,
                            // ),
                            child: Text(
                              "Previous",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(40),
                            // ),
                            // color: Color(0xFF5367FC),
                            onPressed: () {
                              tutorialCoachMark..next();
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                                // height: 40,
                                width: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(" Next ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
        shape: ShapeLightFocus.RRect,
      ));
    if (widget.id == 3)
      targets.add(TargetFocus(
        identify: "Target 8",
        keyTarget: _averagingKey8,
        color: Colors.black,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          //Skip
          TargetContent(
              align: ContentAlign.top,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 520),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      tutorialCoachMark.skip();
                      if (widget.id == 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoginOrderSlice', true);
                      }
                      if (widget.id == 2) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInPriceBand', true);
                      }
                      if (widget.id == 3) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLoggedInAveraging', true);
                      }
                    },
                    child: Container(
                      child: Text(
                        "Skip",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              )),
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "At Market: the first order is executed on market level immediately ",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "At Average Start: the first order is placed only when the level mentioned by user is reached",
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "6/6",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              tutorialCoachMark..previous();
                            },
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                            // highlightedBorderColor: Colors.white,
                            // focusColor: Colors.white,
                            // borderSide: BorderSide(
                            //   width: 1.0,
                            //   color: Colors.white,
                            //   style: BorderStyle.solid,
                            // ),
                            child: Text(
                              "Previous",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: Color(0xFF5367FC))))),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                            // color: Color(0xFF5367FC),
                            onPressed: () async {
                              tutorialCoachMark..finish();
                              if (widget.id == 3) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('firstLoggedInAveraging', true);
                              }
                            },
                            child: Container(
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                                // height: 40,
                                width: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(" Got it ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
        shape: ShapeLightFocus.RRect,
      ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    // Dataconstants.iqsClient.sendScripDetailsRequest(
    //     currentModel.exch, currentModel.exchCode, false);
  }

  void checkIfModelInWatchlist() {
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == currentModel.exch && element.exchCode == currentModel.exchCode);
    }
    addedToWatchlist = pos.any((element) => element > -1);
  }

  void checkFutureOptions() {
    if (currentModel.exchCategory == ExchCategory.nseEquity || currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
      if (currentModel.exchCategory == ExchCategory.nseEquity)
        underlyingModel = currentModel;
      else
        underlyingModel = CommonFunction.getScripDataModel(exch: currentModel.exch, exchCode: currentModel.ulToken);
      futures = Dataconstants.exchData[1].getFutureModels(underlyingModel);
      optionDates = Dataconstants.exchData[1].getDatesForOptions(underlyingModel);
    } else if (currentModel.exchCategory == ExchCategory.mcxFutures || currentModel.exchCategory == ExchCategory.mcxOptions) {
      if (currentModel.exchCategory == ExchCategory.mcxFutures)
        underlyingModel = currentModel;
      else
        underlyingModel = CommonFunction.getScripDataModelForUnderlyingMcx(currentModel);
      futures = Dataconstants.exchData[5].getFutureModelsForMcx(currentModel.ulToken);
      optionDates = Dataconstants.exchData[5].getDatesForOptionsMcx(currentModel.ulToken);
    } else {
      int exchPos;
      if (currentModel.exchCategory == ExchCategory.currenyFutures || currentModel.exchCategory == ExchCategory.currenyOptions)
        exchPos = 3;
      else
        exchPos = 4;
      if (currentModel.exchCategory == ExchCategory.currenyFutures || currentModel.exchCategory == ExchCategory.bseCurrenyFutures)
        underlyingModel = currentModel;
      else
        underlyingModel = CommonFunction.getScripDataModelForUnderlyingCurr(currentModel);
      futures = Dataconstants.exchData[exchPos].getFutureModelsForCurr(currentModel.ulToken);
      optionDates = Dataconstants.exchData[exchPos].getDatesForOptionsCurr(currentModel.ulToken);
    }
    if (Dataconstants.algoScriptModel.exchCategory == ExchCategory.nseEquity)
      _newsNseCode = Dataconstants.algoScriptModel.exchCode;
    else if (Dataconstants.algoScriptModel.exchCategory == ExchCategory.nseFuture || Dataconstants.algoScriptModel.exchCategory == ExchCategory.nseOptions)
      _newsNseCode = Dataconstants.algoScriptModel.ulToken;
    else if (Dataconstants.algoScriptModel.exchCategory == ExchCategory.bseEquity && Dataconstants.algoScriptModel.alternateModel != null)
      _newsNseCode = Dataconstants.algoScriptModel.alternateModel.exchCode;
  }

  _selectTime(
    ThemeData themeData,
    int isStartTime,
  ) async {
    TimeOfDay newTime = TimeOfDay.now();
    if (isStartTime == 1) {
      newTime = await customShowTimePicker(
        context: context,
        initialTime: isStartTime == 0
            ? _startTime
            : isStartTime == 1
                ? _timeInterval
                : _endTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeConstants.themeMode.value == ThemeMode.light
                ? ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.black,
                      background: Color(0xFF13161A),
                      surface: Color(0xFFF2F4F7),
                      // change the text color
                      onSurface: Colors.black,
                    ),
                    // button colors
                    buttonTheme: ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green,
                      ),
                    ),
                  )
                : ThemeConstants.amoledThemeMode.value == false
                    ? ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.white,
                          background: Color(0xFF13161A),
                          surface: Color(0xFF13161A),
                          // change the text color
                          onSurface: Colors.white,
                        ),
                        // button colors
                        buttonTheme: ButtonThemeData(
                          colorScheme: ColorScheme.light(
                            primary: Colors.green,
                          ),
                        ),
                      )
                    : ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.grey,
                          background: Color(0xFF13161A),
                          surface: Color(0xFF13161A),
                          // change the text color
                          onSurface: Colors.white,
                        ),
                        // button colors
                        buttonTheme: ButtonThemeData(
                          colorScheme: ColorScheme.light(
                            primary: Colors.green,
                          ),
                        ),
                      ),
            child: MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
          );
        },
        initialEntryMode: CustomTimePickerEntryMode.input,
      );
    } else {
      newTime = await showTimePicker(
          context: context,
          initialTime: isStartTime == 2 ? _startTime : _endTime,
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeConstants.themeMode.value == ThemeMode.light
                  ? ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                          primary: Colors.black,
                          background: Colors.white,
                          surface: Color(0xFFF2F4F7),
                          // change the text color
                          onSurface: Colors.black,
                          brightness: Brightness.light),
                      // button colors
                      buttonTheme: ButtonThemeData(
                        colorScheme: ColorScheme.light(
                          primary: Colors.green,
                        ),
                      ),
                    )
                  : ThemeConstants.amoledThemeMode.value == false
                      ? ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.white,
                            background: Color(0xFF13161A),
                            surface: Color(0xFF13161A),
                            onPrimary: Colors.black,
                            // change the text color
                            brightness: Brightness.dark,
                            onSurface: Colors.grey,
                          ),
                          // button colors
                          buttonTheme: ButtonThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Colors.green,
                            ),
                          ),
                        )
                      : ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.white,
                            background: Color(0xFF13161A),
                            surface: Color(0xFF13161A),
                            // change the text color
                            onPrimary: Colors.black,
                            brightness: Brightness.dark,
                            onSurface: Colors.grey,
                          ),
                          // button colors
                          buttonTheme: ButtonThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Colors.green,
                            ),
                          ),
                        ),
              child: MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
            );
          },
          initialEntryMode: TimePickerEntryMode.dial);
    }
    if (newTime != null) {
      setState(() {
        isStartTime == 1
            ? _timeInterval = newTime
            : isStartTime == 2
                ? _startTime = newTime
                : _endTime = newTime;
      });
    }
  }

  selectStartTime() {
    TimeOfDay newTime = TimeOfDay.now();
  }

  List<Widget> uiList;
  var uiCreated = false;
  var priceRangeLowValidation;

  Valuechanged(value, i) {
    finalValues[i] = value;
    //print(finalValues);
  }

  createUI(BuildContext context) {
    var theme = Theme.of(context);
    if (!uiCreated) {
      uiList = [];
      for (var i = 0; i < widget.paramModel.length; i++) {
        if (widget.paramModel[i].paramName == 'Direction') {
          finalValues[i] = radioButton == 1 ? "U" : "D";
          uiList.add(Row(
            key: _averagingKey6,
            children: [
              Text(widget.name == "Averaging" ? 'DIRECTION' : "PRICE DIRECTION"),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: radioButton,
                        onChanged: (value) {
                          setState(() {
                            radioButtonItem = 'Up';
                            radioButton = value;
                            uiCreated = false;
                          });
                          finalValues[i] = "U";
                          //print(finalValues);
                        },
                      ),
                      Text(
                        'Up',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                      Radio(
                        value: 2,
                        groupValue: radioButton,
                        onChanged: (value) {
                          setState(() {
                            radioButtonItem = 'Down';
                            radioButton = value;
                            uiCreated = false;
                          });
                          finalValues[i] = "D";
                          //print(finalValues);
                        },
                      ),
                      Text(
                        'Down',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                    ],
                  )),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Price Range Low") {
          priceRangeLowValidation = widget.paramModel[i].algoId;

          finalValues[i] = Dataconstants.isAwaitingAlgoModify == true
              ? Dataconstants.awaitinggAlgoToAdvanceScreen.priceRangeLow.toString() ?? "0.00"
              : Dataconstants.isFinishedAlgoModify == true
                  ? Dataconstants.finishedAlgoToAdvanceScreen.priceRangeLow.toString() ?? "0.00"
                  : "0.00";
          uiList.add(Column(
            key: _priceBandKey4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text('PRICE RANGE LOW'),
              SizedBox(height: 5),
              AlgoNumberField(
                onChangedValue: Valuechanged,
                changedIndex: i,
                doubleDefaultValue: Dataconstants.isAwaitingAlgoModify == true
                    ? Dataconstants.awaitinggAlgoToAdvanceScreen.priceRangeLow.toDouble() ?? 00.00
                    : Dataconstants.isFinishedAlgoModify == true
                        ? Dataconstants.finishedAlgoToAdvanceScreen.priceRangeLow.toDouble() ?? 00.00
                        : 00.00,
                doubleIncrement: currentModel != null ? currentModel.incrementTicksize() : 0.05,
                // 1,
                maxLength: 9,
                numberController: _priceLowController,
                //_priceHighController,
                hint: 'Price Range Low',
                // isInteger: true,
              ),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Price Range High") {
          finalValues[i] = Dataconstants.isAwaitingAlgoModify == true
              ? Dataconstants.awaitinggAlgoToAdvanceScreen.priceRangeHigh.toString() ?? "0.00"
              : Dataconstants.isFinishedAlgoModify == true
                  ? Dataconstants.finishedAlgoToAdvanceScreen.priceRangeHigh.toString() ?? "0.00"
                  : "0.00";
          uiList.add(Column(
            key: _priceBandKey5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text('PRICE RANGE HIGH'),
              SizedBox(height: 5),
              AlgoNumberField(
                onChangedValue: Valuechanged,
                changedIndex: i,
                doubleDefaultValue: Dataconstants.isAwaitingAlgoModify == true
                    ? Dataconstants.awaitinggAlgoToAdvanceScreen.priceRangeHigh.toDouble() ?? 00.00
                    : Dataconstants.isFinishedAlgoModify == true
                        ? Dataconstants.finishedAlgoToAdvanceScreen.priceRangeHigh.toDouble() ?? 00.00
                        : 00.00,
                doubleIncrement: currentModel != null ? currentModel.incrementTicksize() : 0.05,
                //1,
                maxLength: 9,
                numberController: _priceHighController,
                hint: 'Price Range High',
                // isInteger: true,
              ),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Entry Diff") {
          finalValues[i] = Dataconstants.isFinishedAlgoModify == true ? Dataconstants.finishedAlgoToAdvanceScreen.avgEntryDiff.toString() ?? "" : _averagingEntryDifference.text.toString();
          uiList.add(Column(
            children: [
              Row(
                key: _averagingKey7,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'AVERAGE ENTRY DIFFERENCE',
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 2),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],

                        controller: _averagingEntryDifference,
                        maxLength: 7,
                        //  initialValue: "0.0",
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(r':[0-9]')),
                        // ],
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          finalValues[i] = value.toString();
                          //print(finalValues);
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x4D8E8E93),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Exit Diff") {
          finalValues[i] = Dataconstants.isFinishedAlgoModify == true ? Dataconstants.finishedAlgoToAdvanceScreen.avgExitDiff.toString() ?? ' ' : _averagingExitDifference.text.toString();
          uiList.add(Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'AVERAGE EXIT DIFFERENCE',
                  ),
                  Spacer(),
                  // SizedBox(
                  //   width: 200,
                  // ),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 2),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        // ],
                        controller: _averagingExitDifference,
                        maxLength: 7,
                        //   initialValue: "0.0",
                        keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(r':[0-9]')),
                        // ],
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          finalValues[i] = value.toString();
                          //print(finalValues);
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x4D8E8E93),
                    ),
                  )
                ],
              ),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Limit Price") {
          // finalValues[i] =
          // Dataconstants.isAwaitingAlgoModify ==
          //     true
          //     ? Dataconstants.awaitinggAlgoToAdvanceScreen.limitPrice
          //     .toString() ??
          //     "00.00"
          //     : Dataconstants.isFinishedAlgoModify == true
          //     ? Dataconstants
          //     .finishedAlgoToAdvanceScreen.limitPrice
          //     .toString() ??
          //     "00.00"
          //     : _limitController.text.toString();

          finalValues[i] = atMarket == 0 ? "atmarket" : "notatmarket";

          // finalValues[i] = atMarket == 1
          //     ? _atMarket.text == ""
          //         ? "0"
          //         : _atMarket.text
          //     : currentModel != null
          //         ? currentModel.close.toStringAsFixed(currentModel.precision)
          //         : "";
          uiList.add(Column(
            children: [
              SizedBox(height: 10),
              Row(
                key: _averagingKey8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AVERAGING START PRICE'),
                  CupertinoSlidingSegmentedControl(
                      thumbColor: theme.accentColor,
                      //Color(0xFF2E4052),
                      children: {
                        0: Container(
                          height: 35,
                          child: Center(
                            child: Text(
                              'AT MARKET',
                              style: TextStyle(
                                color: atMarket == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                        ),
                        1: Container(
                          height: 35,
                          child: Center(
                            child: Text(
                              'AVG. START',
                              style: TextStyle(
                                color: atMarket == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                // ? Color(0xFFD75B1F)
                                // : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      },
                      groupValue: atMarket,
                      onValueChanged: (newValue) {
                        setState(() {
                          atMarket = newValue;
                          _atMarket.text = currentModel != null ? currentModel.close.toStringAsFixed(2) : "0.0";
                          uiCreated = false;
                        });
                      })
                ],
              ),
              AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(animation);
                  return ClipRect(
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                duration: const Duration(milliseconds: 250),
                child: atMarket == 1
                    ? Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          AlgoNumberField(
                            onChangedValue: Valuechanged,
                            changedIndex: i,
                            doubleDefaultValue: Dataconstants.isAwaitingAlgoModify == true
                                ? Dataconstants.awaitinggAlgoToAdvanceScreen.avgLimitPrice.toDouble() ?? //ssss
                                    00.00
                                : Dataconstants.isFinishedAlgoModify == true
                                    ? Dataconstants.finishedAlgoToAdvanceScreen.avgLimitPrice.toDouble() ?? 00.00
                                    : currentModel != null
                                        ? currentModel.close == 0.0 //aaaaa
                                            ? double.parse(currentModel.prevDayClose.toStringAsFixed(2))
                                            : double.parse(currentModel.close.toStringAsFixed(2))
                                        : 00.00,
                            maxLength: 10,
                            numberController: _atMarket,
                            doubleIncrement: currentModel != null ? currentModel.incrementTicksize() : 0.05,
                            // 1,
                            hint: 'Averaging Start Price',
                            isInteger: false,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ));
        }

        if (widget.paramModel[i].paramName == "Historical Size") {
          finalValues[i] = dropdownvalue.toString().split(" ")[0];
          uiList.add(Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('HISTORICAL SIZE'),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: DropdownButton(
                      value: dropdownvalue,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                          uiCreated = false;
                        });

                        finalValues[i] = newValue.toString().split(" ")[0];
                        //print(finalValues);
                      },
                    ),
                  )
                ],
              ),
            ],
          ));
        }

        //print("finalValues $finalValues");
      }
      uiCreated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (widget.id == 1) {
      firstLoginOrderSlice();
    }
    if (widget.id == 2) {
      firstLoggedInPriceBand();
    }
    if (widget.id == 3) {
      firstLoggedInAveraging();
    }
    createUI(context);
    return Platform.isIOS
        ? GestureDetector(
            // ssss
            onHorizontalDragUpdate: (details) async {
              var prefs = await SharedPreferences.getInstance();
              var firstLoginOrderSlice = prefs.getBool("firstLoginOrderSlice");
              var firstLoggedInPriceBand = prefs.getBool("firstLoggedInPriceBand");
              var firstLoggedInAveraging = prefs.getBool("firstLoggedInAveraging");

              if (widget.id == 1 && firstLoginOrderSlice == true) {
                return Future.value(true);
              } else if (widget.id == 2 && firstLoggedInPriceBand == true) {
                return Future.value(true);
              } else if (widget.id == 3 && firstLoggedInAveraging == true) {
                return Future.value(true);
              } else {
                if (details.delta.direction > 0) {
                  Navigator.of(context).pop();
                }

                return Future.value(false);
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                systemOverlayStyle: Dataconstants.overlayStyle,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Dataconstants.isAwaitingAlgoModify = false;
                    }),
                elevation: 0,
                backgroundColor: groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                title: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      child: Text(
                        widget.segment,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 45,
                        color: groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                      ),
                      Container(
                        height: 70,
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () async {
                                // if (Dataconstants.isAwaitingAlgoModify == false)
                                // {
                                Dataconstants.isFromAlgo = true;
                                await showSearch(
                                  context: context,
                                  delegate: SearchBarScreen(InAppSelection.marketWatchID),
                                ).then((value) {
                                  try {
                                    setState(() {
                                      currentModel = Dataconstants.algoScriptModel;
                                      _exchTogglePosition = Dataconstants.algoScriptModel.exch == 'N' ? 0 : 1;
                                      Dataconstants.isFromAlgo = false;
                                      if (currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
                                        _qtyContoller.text = currentModel.minimumLotQty.toString();
                                        _slicingController.text = "0";
                                      } else {
                                        _qtyContoller.text = "0";
                                        _slicingController.text = "0";
                                      }

                                      _priceHighController.text = "0.00";
                                      _priceLowController.text = "0.00";
                                      atMarket = 0; // TODO
                                      uiCreated = false;
                                    });
                                  } catch (e) {
                                    //print(e);
                                  }
                                });
                                // }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 25,
                                      decoration: BoxDecoration(color: Colors.transparent),
                                      child: FittedBox(
                                        child: Text(
                                          (Dataconstants.algoScriptModel == null || Dataconstants.algoScriptModel.name == null || Dataconstants.algoScriptModel.name == "")
                                              ? Dataconstants.isAwaitingAlgoModify == true
                                                  ? Dataconstants.awaitinggAlgoToAdvanceScreen.model.name ?? "Select Stock"
                                                  : Dataconstants.isFinishedAlgoModify == true
                                                      ? Dataconstants.finishedAlgoToAdvanceScreen.model.name ?? "Select Stock"
                                                      : 'Select Stock'
                                              : Dataconstants.algoScriptModel.marketWatchName,
                                          style: TextStyle(fontSize: 18, color: theme.textTheme.bodyText1.color, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (currentModel != null)
                                    Observer(
                                      builder: (_) => DecimalText(
                                          currentModel.close == 0.0 ? currentModel.prevDayClose.toStringAsFixed(currentModel.precision) : currentModel.close.toStringAsFixed(currentModel.precision),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //
                            //
                            //
                            //
                            //     Text('EXCHANGE'),
                            //
                            //
                            //
                            //
                            //     Spacer(),
                            //     Container(
                            //       // height: 35,
                            //       // width: 55,
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 2, horizontal: 2),
                            //       decoration: BoxDecoration(
                            //           color: Color(0x4D8E8E93),
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(8))),
                            //       child: Container(
                            //         width: 55,
                            //         height: 35,
                            //         decoration: BoxDecoration(
                            //             color: theme.accentColor,
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(8))
                            //         ),
                            //         child: Center(
                            //
                            //           child: Text(
                            //             'NSE',
                            //             style: TextStyle(color: theme.primaryColor),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // height: 35,
                                  // width: 55,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Container(
                                    width: 55,
                                    height: 35,
                                    decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Center(
                                      child: Text(
                                        'NSE',
                                        style: TextStyle(color: theme.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //    widget.id == 4
                                //       ? 'START WITH'
                                //       : 'BUY/SELL',
                                //   style: TextStyle(fontSize: 14.5),
                                // ),
                                CupertinoSlidingSegmentedControl(
                                    thumbColor: theme.accentColor,
                                    children: {
                                      0: Container(
                                        height: 35,
                                        width: 35,
                                        child: Center(
                                          child: Text(
                                            'BUY',
                                            style: TextStyle(
                                              color: groupValue == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      1: Container(
                                        height: 35,
                                        width: 35,
                                        child: Center(
                                          child: Text(
                                            'SELL',
                                            style: TextStyle(
                                              color: groupValue == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    },
                                    groupValue: groupValue,
                                    onValueChanged: (newValue) {
                                      setState(() {
                                        groupValue = newValue;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('EXCHANGE'),
                            //     CupertinoSlidingSegmentedControl(
                            //       thumbColor: theme.accentColor,
                            //       children: {
                            //         0: Container(
                            //           height: 35,
                            //           width: 35,
                            //           child: Center(
                            //             child: Text(
                            //               'NSE',
                            //               style: TextStyle(
                            //                 color: _exchTogglePosition ==
                            //                         0 //groupValue == 0
                            //                     ? theme.primaryColor
                            //                     : theme.textTheme.bodyText1.color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         1: Container(
                            //           height: 35,
                            //           width: 35,
                            //           child: Center(
                            //             child: Text(
                            //               'BSE',
                            //               style: TextStyle(
                            //                 color: _exchTogglePosition ==
                            //                         1 // groupValue == 1
                            //                     ? theme.primaryColor
                            //                     : theme.textTheme.bodyText1.color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       },
                            //       groupValue: _exchTogglePosition,
                            //       onValueChanged: (newValue) {
                            //         return;
                            //         if (newValue != _exchTogglePosition)
                            //           modelFlipped = !modelFlipped;
                            //         if (modelFlipped) {
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants.algoScriptModel.exch,
                            //             Dataconstants.algoScriptModel.exchCode,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel.alternateModel,
                            //             true,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exch,
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exchCode,
                            //             true,
                            //           );
                            //         } else {
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel.alternateModel,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exch,
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exchCode,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel,
                            //             true,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants.algoScriptModel.exch,
                            //             Dataconstants.algoScriptModel.exchCode,
                            //             true,
                            //           );
                            //         }
                            //
                            //         setState(() {
                            //           _tabController.index = 0;
                            //           currentModel = modelFlipped
                            //               ? Dataconstants.algoScriptModel.alternateModel
                            //               : Dataconstants.algoScriptModel;
                            //           _exchTogglePosition = newValue;
                            //           checkIfModelInWatchlist();
                            //           checkFutureOptions();
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('PRODUCT'),
                                    SizedBox(width: 5),
                                    InkWell(
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Platform.isIOS
                                              ? CupertinoAlertDialog(
                                                  title: Text('Product Information'),
                                                  content: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      // Text('DELIVERY - Cash'),
                                                      // SizedBox(height: 10),
                                                      Text('INTRADAY - Margin'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                          color: theme.primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : AlertDialog(
                                                  title: Text('Product Information'),
                                                  content: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('DELIVERY - Cash'),
                                                      SizedBox(height: 10),
                                                      Text('INTRADAY - Margin'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                          color: theme.primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                if (widget.id == 4)
                                  Container(
                                    // height: 35,
                                    // width: 55,
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                    decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Container(
                                      width: 75,
                                      height: 35,
                                      decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          'INTRADAY',
                                          style: TextStyle(color: theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.id != 4)
                                  if (currentModel == null || currentModel.exchCategory != ExchCategory.nseOptions)
                                    CupertinoSlidingSegmentedControl(
                                        thumbColor: theme.accentColor,
                                        children: {
                                          0: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'INTRADAY',
                                                style: TextStyle(
                                                  color: productType == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture) ? 'NORMAL' : 'DELIVERY',
                                                style: TextStyle(
                                                  color: productType == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue: productType,
                                        onValueChanged: (newValue) {
                                          setState(() {
                                            productType = newValue;
                                          });
                                        }),
                                if (currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                  Container(
                                    // height: 35,
                                    // width: 55,
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                    decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Container(
                                      width: 70,
                                      height: 35,
                                      decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          'NORMAL',
                                          style: TextStyle(color: theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  widget.id == 4
                                      ? 'MAX. OPEN QUANTITY' //
                                      : 'TOTAL QUANTITY',
                                ),
                                Spacer(),
                                if (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture || currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Lot ${currentModel.minimumLotQty.toString()}")
                                    ],
                                  )
                                else
                                  SizedBox.shrink()
                              ],
                            ),

                            SizedBox(height: 10),
                            SizedBox(
                              key: _orderSlicingKey, //SSSS,
                              child: AlgoNumberField(
                                // isDisabled: true,

                                defaultValue: // 0,
                                    Dataconstants.isAwaitingAlgoModify == true
                                        ? Dataconstants.awaitinggAlgoToAdvanceScreen.totalQty ?? 0
                                        : Dataconstants.isFinishedAlgoModify == true
                                            ? Dataconstants.finishedAlgoToAdvanceScreen.totalQty ?? 0
                                            : currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture
                                                ? currentModel.minimumLotQty
                                                : 0,
                                maxLength: 9,
                                numberController: _qtyContoller,
                                increment: currentModel != null ? currentModel.minimumLotQty : 1,
                                hint: widget.id == 4 ? 'Max. Open Quantity' : 'Total Quantity',
                                isInteger: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.id == 3 || widget.id == 4 ? "AVERAGING QUANTITY" : 'SLICING QUANTITY',
                            ),
                            SizedBox(height: 10),
                            Container(
                              key: _orderSlicingKey1,

                              /// coach marker 2-order slice
                              child: AlgoNumberField(
                                defaultValue: Dataconstants.isAwaitingAlgoModify == true
                                    ? Dataconstants.awaitinggAlgoToAdvanceScreen.slicingQty ?? 0
                                    : Dataconstants.isFinishedAlgoModify == true
                                        ? Dataconstants.finishedAlgoToAdvanceScreen.slicingQty ?? 0
                                        : 0,
                                maxLength: 9,
                                numberController: _slicingController,
                                increment: currentModel != null ? currentModel.minimumLotQty : 1,
                                hint: widget.id == 3 || widget.id == 4 ? "Averaging Quantity" : 'Slicing Quantity',
                                isInteger: true,
                              ),
                            ),
                            SizedBox(height: 14),
                            if (widget.id != 3 && widget.id != 4)
                              Row(
                                key: _orderSlicingKey2,

                                /// coach marker 3-order slice
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'TIME INTERVAL',
                                  ),
                                  Spacer(),
                                  InkWell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 100,
                                        child: Text(
                                          timeInterval,

                                          // "${_timeInterval.hour..toString().padLeft(2, '0')}:${_timeInterval.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0x4D8E8E93),
                                        ),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        await _selectTime(theme, 1);
                                        setState(() {
                                          timeInterval = "${(_timeInterval.hour.toString().padLeft(2, '0'))}:${_timeInterval.minute.toString().padLeft(2, '0')}";

                                          timeIntervalConverted = _timeInterval.hour * 60 + _timeInterval.minute;
                                        });
                                      })
                                ],
                              )
                            else
                              SizedBox.shrink(),
                            SizedBox(height: 12),
                            Row(
                              key: _orderSlicingKey3,

                              /// coach marker 4 -order slice
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'START TIME',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 100,
                                          child: Text(
                                            startTime,
                                            //    _dateTime.hour.toString().padLeft(2, '0') + ':' + _dateTime.minute.toString().padLeft(2, '0') + ':' + _dateTime.second.toString().padLeft(2, '0'),
                                            //  startTime,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0x4D8E8E93),
                                          ),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(new FocusNode()); //remove focus

                                          await _selectTime(theme, 2);

                                          setState(() {
                                            startTime =
                                                "${(_startTime.hour).toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}"; //:${DateTime.now().second.toString().padLeft(2, '0')}

                                            startTimeConverted = _startTime.hour * 60 * 60 + _startTime.minute * 60;

                                            //Convert.toInt32((startTime - ExchStartDate).TotalSeconds)
                                          });
                                        })
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'END TIME',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 100,
                                          child: Text(
                                            endTime,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0x4D8E8E93),
                                          ),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          await _selectTime(theme, 3);
                                          setState(() {
                                            endTime = "${(_endTime.hour).toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}";
                                            endTimeConverted = _endTime.hour * 60 * 60 + _endTime.minute * 60;
                                          });
                                        })
                                  ],
                                ),
                              ],
                            ),
                            (uiList == null || uiList.isEmpty)
                                ? SizedBox.shrink()
                                : Column(
                                    children: uiList,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // if(widget.id!=1)
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 10, right: 30, top: 5),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //
                      //
                      //     child: InkWell(
                      //       onTap: () {
                      //         if (widget.id == 1) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView(
                      //                       "TWAP - Order Slicing Help",
                      //                       BrokerInfo.tWAPOrderSlicing)));
                      //           // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //         }
                      //         if (widget.id == 2) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView(
                      //                       "TWAP - Price Band Help",
                      //                       BrokerInfo.tWAPriceBand)));
                      //           // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //         }
                      //         if (widget.id == 3) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView("Averaging Help",
                      //                       BrokerInfo.averaging)));
                      //           // CommonFunction.launchURL(BrokerInfo.averaging);
                      //         }
                      //       },
                      //       child: Container(
                      //         width: 28,
                      //         height: 28,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: theme.primaryColor,
                      //         ),
                      //         child: Center(
                      //           child: Text(
                      //             "?",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w500),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //
                      //
                      //     // child: InkWell(
                      //     //     onTap: () {
                      //     //       if (widget.id == 1) {
                      //     //         Navigator.push(context, MaterialPageRoute(
                      //     //             builder: (context) =>
                      //     //                 InAppIciciWebView(
                      //     //                     "TWAP - Order Slicing Help",
                      //     //                     BrokerInfo.tWAPOrderSlicing)));
                      //     //         // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //     //       }
                      //     //       if (widget.id == 2) {
                      //     //         Navigator.push(context, MaterialPageRoute(
                      //     //             builder: (context) =>
                      //     //                 InAppIciciWebView(
                      //     //                     "TWAP - Price Band Help",
                      //     //                     BrokerInfo.tWAPriceBand)));
                      //     //         // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //     //       }
                      //     //       if (widget.id == 3) {
                      //     //         Navigator.push(context, MaterialPageRoute(
                      //     //             builder: (context) =>
                      //     //                 InAppIciciWebView("Averaging Help",
                      //     //                     BrokerInfo.averaging)));
                      //     //         // CommonFunction.launchURL(BrokerInfo.averaging);
                      //     //       }
                      //     //     },
                      //     //     child: Text("Help?", style: TextStyle(
                      //     //         color: theme.primaryColor,
                      //     //         fontSize: 16,
                      //     //         fontWeight: FontWeight.w500),))
                      //   ),
                      // ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30) : const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 6),
                        child: ElevatedButton(

                            // disabledColor: groupValue == 0
                            //     ? ThemeConstants.buyColor
                            //     : ThemeConstants.sellColorOld,
                            // color: groupValue == 0
                            //     ? ThemeConstants.buyColor
                            //     : ThemeConstants.sellColorOld,
                            // padding: const EdgeInsets.symmetric(
                            //     vertical: 17, horizontal: 20),
                            // color: Theme.of(context).colorScheme.primary,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(theme.primaryColor),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: theme.primaryColor)))),
                            // shape: StadiumBorder(),
                            child: Text(
                              Dataconstants.isAwaitingAlgoModify == true ? "Modify" : 'START',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: () async {
                              //print("_currentMinute $_currentMinute");
                              //print('timeInterval $timeInterval');
                              //print(
                              //     'timeInterval Converted  $timeIntervalConverted');
                              //print('startTime Converted $startTimeConverted');
                              //print('endTime Converted $endTimeConverted');
                              //print(
                              //     'start Time & endTime difference   ${endTimeConverted -
                              //         startTimeConverted}');
                              //print(
                              //     'priceRangeLowValidation : $priceRangeLowValidation');

                              DateTime ExchStartDate = new DateTime(1980, 1, 1, 0, 0, 0);

                              DateTime st = DateTime.now();
                              //print('exchange date $ExchStartDate');
                              var currentDateTime = DateUtil.getAnyFormattedDate(st, "dd-MMM-yyyy");
                              //print('currentDateTime  $currentDateTime');
                              var newexchDAtes = DateUtil.getAnyFormattedDate(ExchStartDate, "dd-MMM-yyyy HH:mm:ss");

                              //-----------------------> exchange converted<---------------------------------------//

                              var dateexchsec = DateUtil.getIntFromDate1(newexchDAtes);
                              //print(' ExchangeDate Converted $dateexchsec');

                              //--------------------------> newStartTimePass<-------------------------------------------//

                              var newStartDate = DateUtil.getAnyFormattedExchDate(startTimeConverted, "HH:mm:ss");
                              var finalDate = currentDateTime + " " + newStartDate;
                              //print('present date time $finalDate');

                              var dateinsec = DateUtil.getIntFromDate1(finalDate);

                              //print(' converted new startTimePass $dateinsec');

                              int startTimePass = dateinsec - dateexchsec;

                              //print(' start time pass  $startTimePass');

                              //-----------------------------------> endtimePass <-------------------------------------------//

                              var newEndDate = DateUtil.getAnyFormattedExchDate(endTimeConverted, "HH:mm:ss");

                              var finalDate1 = currentDateTime + " " + newEndDate;
                              //print('present date time $finalDate');

                              var dateinsec1 = DateUtil.getIntFromDate1(finalDate1);

                              //print(' converted new EndTimePass $dateinsec1');

                              int endTimePass = dateinsec1 - dateexchsec;

                              //print(' end time pass  $endTimePass');

                              //-----------------------------------------Validations-----------------------------------------------//
                              if (Dataconstants.algoScriptModel == null || Dataconstants.algoScriptModel.name == null || Dataconstants.algoScriptModel.name == "") {
                                CommonFunction.showSnackBarKey(
                                  key: _scaffoldKey,
                                  context: context,
                                  text: 'Please select Stock ',
                                  color: Colors.red,
                                );
                                return;
                              }
                              if (int.tryParse(_qtyContoller.text) == 0 || int.tryParse(_qtyContoller.text) < 1) {
                                //_slicingController
                                CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Please enter Total quantity');
                                return;
                              }

                              if (int.parse(_slicingController.text) == 0 || int.parse(_slicingController.text) < 1 || _slicingController.text == " ") {
                                //_slicingController
                                CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Please enter Slicing quantity');
                                return;
                              }

                              if (currentModel.exchCategory == ExchCategory.nseFuture) {
                                int totalQty = int.tryParse(_qtyContoller.text) ?? null;
                                int slicingQty = int.tryParse(_slicingController.text) ?? null;
                                if (totalQty % currentModel.minimumLotQty != 0) {
                                  CommonFunction.showBasicToast('Please enter Total quantity in the lot size of ${currentModel.minimumLotQty}');
                                  return;
                                }

                                if (slicingQty % currentModel.minimumLotQty != 0) {
                                  CommonFunction.showBasicToast('Please enter Slicing quantity in the lot size of ${currentModel.minimumLotQty}');
                                  return;
                                }
                              }
                              if (double.tryParse(_qtyContoller.text) <= double.tryParse(_slicingController.text)) {
                                //_slicingController
                                CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Slicing quantity cannot be greater than or equal to Total quantity');
                                return;
                              }

                              if (double.tryParse(_slicingController.text) > Dataconstants.maxOrderQty) {
                                CommonFunction.showSnackBarKey(
                                    key: _scaffoldKey,
                                    color: Colors.red,
                                    context: context,
                                    text: (widget.id != 3 && widget.id != 4) ? 'Max slice  qty allowed is ${Dataconstants.maxOrderQty}' : 'Max averaging  qty allowed is ${Dataconstants.maxOrderQty}');
                                return;
                              }

                              if (widget.id != 3 && widget.id != 4) {
                                if (timeIntervalConverted == 0) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Time interval cannot be zero ');
                                  return;
                                }
                              }
                              if (startTimeConverted >= endTimeConverted) {
                                //_slicingController
                                CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Start time cannot be greater than or equal to End Time');
                                return;
                              }
                              if (widget.id != 3 && widget.id != 4) {
                                if (timeIntervalConverted > (endTimeConverted - startTimeConverted)) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey, color: Colors.red, context: context, text: 'Time interval cannot be greater than the difference between Algo Start and End time');
                                  return;
                                }
                              }

                              // if (Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesOpen) {
                              //   //_slicingController
                              //   CommonFunction.showSnackBarKey(
                              //       key: _scaffoldKey,
                              //       color: Colors.red,
                              //       context: context,
                              //       text:
                              //       'Market Closed');
                              //   return;
                              // }

                              if (widget.id == 2) {
                                if (double.parse(_priceLowController.text) == 0.0) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price  range low cannot be zero ');
                                  return;
                                }
                                if (double.parse(_priceHighController.text) == 0.0) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range high cannot be zero ');
                                  return;
                                }
                                if (currentModel != null) if (isMultipleOf(_priceHighController.text, currentModel.incrementTicksize())) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range high should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                  return;
                                }
                              }
                              //----------------If Buy  -----********--------

                              if (widget.id == 2) {
                                if (double.tryParse(_priceLowController.text) >= double.tryParse(_priceHighController.text)) {
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range low cannot be greater or equal to  Price range high');
                                  return;
                                }
                                if (double.tryParse(_slicingController.text) * double.tryParse(_priceHighController.text) > Dataconstants.maxDerivOrderValue) {
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Slice order value allowed is ${Dataconstants.maxDerivOrderValue}');
                                  return;
                                }

                                if (currentModel != null) if (isMultipleOf(_priceLowController.text, currentModel.incrementTicksize())) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range low should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                  return;
                                }
                              }
                              //--------------------If sell -----********--------
                              // if (widget.id == 2 && groupValue == 1) {
                              //   if (double.tryParse(_priceLowController.text) <
                              //       double.tryParse(_priceHighController.text)) {
                              //     CommonFunction.showSnackBarKey(
                              //         key: _scaffoldKey,
                              //         color: Colors.red,
                              //         context: context,
                              //         text:
                              //         'Price range low cannot be less than price range high');
                              //     return;
                              //   }
                              //   if (double.tryParse(_slicingController.text) *
                              //       double.tryParse(_priceHighController.text) >
                              //       Dataconstants.maxCashOrderValue) {
                              //     CommonFunction.showSnackBarKey(
                              //         key: _scaffoldKey,
                              //         color: Colors.red,
                              //         context: context,
                              //         text:
                              //         'Max Cash Order value allowed is Rs.  ${Dataconstants
                              //             .maxCashOrderValue}');
                              //     return;
                              //   }
                              // }

                              // end pricing band validation

                              if (widget.name == "Averaging" || widget.name == "Averaging Scalper") {
                                if (double.parse(_averagingEntryDifference.text) == 0.0) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging entry difference cannot be zero');
                                  return;
                                }
                                if (currentModel != null) if (isMultipleOf(_averagingEntryDifference.text, currentModel.incrementTicksize())) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging entry difference should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                  return;
                                }
                                if (atMarket == 1) {
                                  if (currentModel != null) if (isMultipleOf(_atMarket.text, currentModel.incrementTicksize()))
                                  // if ((double.parse(_atMarket.text) * 100) % (currentModel.incrementTicksize() * 100) >= 0.01)
                                  {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging Start Price should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                    return;
                                  }
                                }
                              }

                              if (widget.name == "Averaging Scalper") {
                                if (double.parse(_averagingExitDifference.text) == 0.0) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging exit difference cannot be zero');
                                  return;
                                }
                                if (currentModel != null) if (isMultipleOf(_averagingExitDifference.text, currentModel.incrementTicksize())) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging exit difference should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                  return;
                                }
                              }

                              // --------------------------------validation end----------------------------------------------------//

                              var valueIsToDisplay = [];
                              var valueIsToDisplay2 = [];

                              for (var i = 0; i < widget.paramModel.length; i++) {
                                if (widget.paramModel[i].paramName == "Limit Price")
                                  finalValues[i] = atMarket == 1
                                      ? _atMarket.text == ""
                                          ? "0"
                                          : _atMarket.text
                                      : "0";
                                // currentModel != null
                                //     ? currentModel.close.toStringAsFixed(
                                //     currentModel.precision)
                                //     : "";

                                valueIsToDisplay.add([widget.paramModel[i].requestKey.toString(), finalValues[i].toString()]);
                                // valueIsToDisplay2.add([
                                //   widget.paramModel[i].displayKey.toString(),
                                //   finalValues[i].toString()
                                // ]);
                              }

                              for (var i = 0; i < widget.paramModel.length; i++) {
                                if (widget.paramModel[i].paramName == "Limit Price")
                                  finalValues[i] = atMarket == 1
                                      ? _atMarket.text == ""
                                          ? "0"
                                          : _atMarket.text
                                      : currentModel != null
                                          ? "Mkt"
                                          : "";
                                valueIsToDisplay2.add([widget.paramModel[i].displayKey.toString(), finalValues[i].toString()]);
                              }
                              // //print('valueIsToDisplay : ${widget.paramModel[0].requestKey}');
                              //print('valueIsToDisplay : $valueIsToDisplay');
                              Dataconstants.algoSubmitted = true;
                              //print(
                              //     'valueIsToDisplay222222222 : $valueIsToDisplay2');

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdvanceOrderReviewScreen(
                                          stock: Dataconstants.algoScriptModel.name,
                                          algoName: widget.name,
                                          orderType: groupValue == 0 ? "BUY" : "SELL",
                                          exchange: _exchTogglePosition == 0 ? "NSE" : "BSE",
                                          productType: (currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                              ? "NORMAL"
                                              : productType == 0
                                                  ? "INTRADAY"
                                                  : (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture)
                                                      ? 'NORMAL'
                                                      : 'DELIVERY',
                                          totalQuantity: _qtyContoller.text,
                                          slicingQuantity: _slicingController.text,
                                          startTime: startTime,
                                          startTimeConverted: startTimePass,
                                          endTime: endTime,
                                          endTimeConverted: endTimePass,
                                          timeInterval: timeInterval,
                                          timeIntervalConverted: timeIntervalConverted,
                                          algoId: widget.id,
                                          model: currentModel,
                                          atMarket: atMarket == 1 ? false : true,
                                          dynamicValue: valueIsToDisplay,
                                          dynamicValue2: valueIsToDisplay2)));
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : WillPopScope(
            // ssss
            onWillPop: () async {
              var prefs = await SharedPreferences.getInstance();
              var firstLoginOrderSlice = prefs.getBool("firstLoginOrderSlice");
              var firstLoggedInPriceBand = prefs.getBool("firstLoggedInPriceBand");
              var firstLoggedInAveraging = prefs.getBool("firstLoggedInAveraging");

              if (widget.id == 1 && firstLoginOrderSlice == true) {
                return Future.value(true);
              } else if (widget.id == 2 && firstLoggedInPriceBand == true) {
                return Future.value(true);
              } else if (widget.id == 3 && firstLoggedInAveraging == true) {
                return Future.value(true);
              } else {
                return Future.value(false);
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                systemOverlayStyle: Dataconstants.overlayStyle,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Dataconstants.isAwaitingAlgoModify = false;
                    }),
                elevation: 0,
                backgroundColor: groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                title: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      child: Text(
                        widget.segment,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 45,
                        color: groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                      ),
                      Container(
                        height: 70,
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () async {
                                // if (Dataconstants.isAwaitingAlgoModify == false)
                                // {
                                Dataconstants.isFromAlgo = true;
                                await showSearch(
                                  context: context,
                                  delegate: SearchBarScreen(InAppSelection.marketWatchID),
                                ).then((value) {
                                  try {
                                    setState(() {
                                      currentModel = Dataconstants.algoScriptModel;
                                      _exchTogglePosition = Dataconstants.algoScriptModel.exch == 'N' ? 0 : 1;
                                      Dataconstants.isFromAlgo = false;
                                      if (currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
                                        _qtyContoller.text = currentModel.minimumLotQty.toString();
                                        _slicingController.text = "0";
                                      } else {
                                        _qtyContoller.text = "0";
                                        _slicingController.text = "0";
                                      }

                                      _priceHighController.text = "0.00";
                                      _priceLowController.text = "0.00";
                                      atMarket = 0; // TODO
                                      uiCreated = false;
                                    });
                                  } catch (e) {
                                    //print(e);
                                  }
                                });
                                // }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 25,
                                      decoration: BoxDecoration(color: Colors.transparent),
                                      child: FittedBox(
                                        child: Text(
                                          (Dataconstants.algoScriptModel == null || Dataconstants.algoScriptModel.name == null || Dataconstants.algoScriptModel.name == "")
                                              ? Dataconstants.isAwaitingAlgoModify == true
                                                  ? Dataconstants.awaitinggAlgoToAdvanceScreen.model.name ?? "Select Stock"
                                                  : Dataconstants.isFinishedAlgoModify == true
                                                      ? Dataconstants.finishedAlgoToAdvanceScreen.model.name ?? "Select Stock"
                                                      : 'Select Stock'
                                              : Dataconstants.algoScriptModel.marketWatchName,
                                          style: TextStyle(fontSize: 18, color: theme.textTheme.bodyText1.color, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (currentModel != null)
                                    Observer(
                                      builder: (_) => DecimalText(
                                          currentModel.close == 0.0 ? currentModel.prevDayClose.toStringAsFixed(currentModel.precision) : currentModel.close.toStringAsFixed(currentModel.precision),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //
                            //
                            //
                            //
                            //     Text('EXCHANGE'),
                            //
                            //
                            //
                            //
                            //     Spacer(),
                            //     Container(
                            //       // height: 35,
                            //       // width: 55,
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 2, horizontal: 2),
                            //       decoration: BoxDecoration(
                            //           color: Color(0x4D8E8E93),
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(8))),
                            //       child: Container(
                            //         width: 55,
                            //         height: 35,
                            //         decoration: BoxDecoration(
                            //             color: theme.accentColor,
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(8))
                            //         ),
                            //         child: Center(
                            //
                            //           child: Text(
                            //             'NSE',
                            //             style: TextStyle(color: theme.primaryColor),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // height: 35,
                                  // width: 55,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                  child: Container(
                                    width: 55,
                                    height: 35,
                                    decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Center(
                                      child: Text(
                                        'NSE',
                                        style: TextStyle(color: theme.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //    widget.id == 4
                                //       ? 'START WITH'
                                //       : 'BUY/SELL',
                                //   style: TextStyle(fontSize: 14.5),
                                // ),
                                CupertinoSlidingSegmentedControl(
                                    thumbColor: theme.accentColor,
                                    children: {
                                      0: Container(
                                        height: 35,
                                        width: 35,
                                        child: Center(
                                          child: Text(
                                            'BUY',
                                            style: TextStyle(
                                              color: groupValue == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      1: Container(
                                        height: 35,
                                        width: 37,
                                        child: Center(
                                          child: Text(
                                            'SELL',
                                            style: TextStyle(
                                              color: groupValue == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    },
                                    groupValue: groupValue,
                                    onValueChanged: (newValue) {
                                      setState(() {
                                        groupValue = newValue;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('EXCHANGE'),
                            //     CupertinoSlidingSegmentedControl(
                            //       thumbColor: theme.accentColor,
                            //       children: {
                            //         0: Container(
                            //           height: 35,
                            //           width: 35,
                            //           child: Center(
                            //             child: Text(
                            //               'NSE',
                            //               style: TextStyle(
                            //                 color: _exchTogglePosition ==
                            //                         0 //groupValue == 0
                            //                     ? theme.primaryColor
                            //                     : theme.textTheme.bodyText1.color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         1: Container(
                            //           height: 35,
                            //           width: 35,
                            //           child: Center(
                            //             child: Text(
                            //               'BSE',
                            //               style: TextStyle(
                            //                 color: _exchTogglePosition ==
                            //                         1 // groupValue == 1
                            //                     ? theme.primaryColor
                            //                     : theme.textTheme.bodyText1.color,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       },
                            //       groupValue: _exchTogglePosition,
                            //       onValueChanged: (newValue) {
                            //         return;
                            //         if (newValue != _exchTogglePosition)
                            //           modelFlipped = !modelFlipped;
                            //         if (modelFlipped) {
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants.algoScriptModel.exch,
                            //             Dataconstants.algoScriptModel.exchCode,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel.alternateModel,
                            //             true,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exch,
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exchCode,
                            //             true,
                            //           );
                            //         } else {
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel.alternateModel,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exch,
                            //             Dataconstants
                            //                 .algoScriptModel.alternateModel.exchCode,
                            //             false,
                            //           );
                            //           Dataconstants.iqsClient.sendLTPRequest(
                            //             Dataconstants.algoScriptModel,
                            //             true,
                            //           );
                            //           Dataconstants.iqsClient.sendMarketDepthRequest(
                            //             Dataconstants.algoScriptModel.exch,
                            //             Dataconstants.algoScriptModel.exchCode,
                            //             true,
                            //           );
                            //         }
                            //
                            //         setState(() {
                            //           _tabController.index = 0;
                            //           currentModel = modelFlipped
                            //               ? Dataconstants.algoScriptModel.alternateModel
                            //               : Dataconstants.algoScriptModel;
                            //           _exchTogglePosition = newValue;
                            //           checkIfModelInWatchlist();
                            //           checkFutureOptions();
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('PRODUCT'),
                                    SizedBox(width: 5),
                                    InkWell(
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Platform.isIOS
                                              ? CupertinoAlertDialog(
                                                  title: Text('Product Information'),
                                                  content: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('DELIVERY - Cash'),
                                                      SizedBox(height: 10),
                                                      Text('INTRADAY - Margin'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                          color: theme.primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : AlertDialog(
                                                  title: Text('Product Information'),
                                                  content: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text('DELIVERY - Cash'),
                                                      SizedBox(height: 10),
                                                      Text('INTRADAY - Margin'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                          color: theme.primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                if (widget.id == 4)
                                  Container(
                                    // height: 35,
                                    // width: 55,
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                    decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Container(
                                      width: 75,
                                      height: 35,
                                      decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          'INTRADAY',
                                          style: TextStyle(color: theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.id != 4)
                                  if (currentModel == null || currentModel.exchCategory != ExchCategory.nseOptions)
                                    CupertinoSlidingSegmentedControl(
                                        thumbColor: theme.accentColor,
                                        children: {
                                          0: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'INTRADAY',
                                                style: TextStyle(
                                                  color: productType == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture) ? 'NORMAL' : 'DELIVERY',
                                                style: TextStyle(
                                                  color: productType == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue: productType,
                                        onValueChanged: (newValue) {
                                          setState(() {
                                            productType = newValue;
                                          });
                                        }),
                                if (currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                  Container(
                                    // height: 35,
                                    // width: 55,
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                    decoration: BoxDecoration(color: Color(0x4D8E8E93), borderRadius: BorderRadius.all(Radius.circular(8))),
                                    child: Container(
                                      width: 70,
                                      height: 35,
                                      decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          'NORMAL',
                                          style: TextStyle(color: theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  widget.id == 4
                                      ? 'MAX. OPEN QUANTITY' //
                                      : 'TOTAL QUANTITY',
                                ),
                                Spacer(),
                                if (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture || currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Lot ${currentModel.minimumLotQty.toString()}")
                                    ],
                                  )
                                else
                                  SizedBox.shrink()
                              ],
                            ),

                            SizedBox(height: 10),
                            SizedBox(
                              key: _orderSlicingKey, //SSSS,
                              child: AlgoNumberField(
                                // isDisabled: true,

                                defaultValue: // 0,
                                    Dataconstants.isAwaitingAlgoModify == true
                                        ? Dataconstants.awaitinggAlgoToAdvanceScreen.totalQty ?? 0
                                        : Dataconstants.isFinishedAlgoModify == true
                                            ? Dataconstants.finishedAlgoToAdvanceScreen.totalQty ?? 0
                                            : currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture
                                                ? currentModel.minimumLotQty
                                                : 0,
                                maxLength: 9,
                                numberController: _qtyContoller,
                                increment: currentModel != null ? currentModel.minimumLotQty : 1,
                                hint: widget.id == 4 ? 'Max. Open Quantity' : 'Total Quantity',
                                isInteger: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.id == 3 || widget.id == 4 ? "AVERAGING QUANTITY" : 'SLICING QUANTITY',
                            ),
                            SizedBox(height: 10),
                            Container(
                              key: _orderSlicingKey1,

                              /// coach marker 2-order slice
                              child: AlgoNumberField(
                                defaultValue: Dataconstants.isAwaitingAlgoModify == true
                                    ? Dataconstants.awaitinggAlgoToAdvanceScreen.slicingQty ?? 0
                                    : Dataconstants.isFinishedAlgoModify == true
                                        ? Dataconstants.finishedAlgoToAdvanceScreen.slicingQty ?? 0
                                        : 0,
                                maxLength: 9,
                                numberController: _slicingController,
                                increment: currentModel != null ? currentModel.minimumLotQty : 1,
                                hint: widget.id == 3 || widget.id == 4 ? "Averaging Quantity" : 'Slicing Quantity',
                                isInteger: true,
                              ),
                            ),
                            SizedBox(height: 14),
                            if (widget.id != 3 && widget.id != 4)
                              Row(
                                key: _orderSlicingKey2,

                                /// coach marker 3-order slice
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'TIME INTERVAL',
                                  ),
                                  Spacer(),
                                  InkWell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 100,
                                        child: Text(
                                          timeInterval,

                                          // "${_timeInterval.hour..toString().padLeft(2, '0')}:${_timeInterval.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0x4D8E8E93),
                                        ),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        await _selectTime(theme, 1);
                                        setState(() {
                                          timeInterval = "${(_timeInterval.hour.toString().padLeft(2, '0'))}:${_timeInterval.minute.toString().padLeft(2, '0')}";

                                          timeIntervalConverted = _timeInterval.hour * 60 + _timeInterval.minute;
                                        });
                                      })
                                ],
                              )
                            else
                              SizedBox.shrink(),
                            SizedBox(height: 12),
                            Row(
                              key: _orderSlicingKey3,

                              /// coach marker 4 -order slice
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'START TIME',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 100,
                                          child: Text(
                                            startTime,
                                            //    _dateTime.hour.toString().padLeft(2, '0') + ':' + _dateTime.minute.toString().padLeft(2, '0') + ':' + _dateTime.second.toString().padLeft(2, '0'),
                                            //  startTime,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0x4D8E8E93),
                                          ),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(new FocusNode()); //remove focus

                                          await _selectTime(theme, 2);

                                          setState(() {
                                            startTime =
                                                "${(_startTime.hour).toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}"; //:${DateTime.now().second.toString().padLeft(2, '0')}

                                            startTimeConverted = _startTime.hour * 60 * 60 + _startTime.minute * 60;

                                            //Convert.toInt32((startTime - ExchStartDate).TotalSeconds)
                                          });
                                        })
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'END TIME',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 100,
                                          child: Text(
                                            endTime,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0x4D8E8E93),
                                          ),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          await _selectTime(theme, 3);
                                          setState(() {
                                            endTime = "${(_endTime.hour).toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}";
                                            endTimeConverted = _endTime.hour * 60 * 60 + _endTime.minute * 60;
                                          });
                                        })
                                  ],
                                ),
                              ],
                            ),
                            (uiList == null || uiList.isEmpty)
                                ? SizedBox.shrink()
                                : Column(
                                    children: uiList,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // if(widget.id!=1)
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 10, right: 30, top: 5),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: InkWell(
                      //       onTap: () {
                      //         if (widget.id == 1) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView(
                      //                       "TWAP - Order Slicing Help",
                      //                       BrokerInfo.tWAPOrderSlicing)));
                      //           // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //         }
                      //         if (widget.id == 2) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView(
                      //                       "TWAP - Price Band Help",
                      //                       BrokerInfo.tWAPriceBand)));
                      //           // CommonFunction.launchURL(BrokerInfo.tWAPriceBand);
                      //         }
                      //         if (widget.id == 3) {
                      //           Navigator.push(context, MaterialPageRoute(
                      //               builder: (context) =>
                      //                   InAppIciciWebView("Averaging Help",
                      //                       BrokerInfo.averaging)));
                      //           // CommonFunction.launchURL(BrokerInfo.averaging);
                      //         }
                      //       },
                      //       child: Container(
                      //         width: 28,
                      //         height: 28,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: theme.primaryColor,
                      //         ),
                      //         child: Center(
                      //           child: Text(
                      //             "?",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w500),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //
                      //
                      //   ),
                      // ),

                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30) : const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 6),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      side: BorderSide(
                                        color: groupValue == 0 ? ThemeConstants.buyColor : ThemeConstants.sellColorOld,
                                      )))),
                              // disabledColor: groupValue == 0
                              //     ? ThemeConstants.buyColor
                              //     : ThemeConstants.sellColorOld,
                              // color: groupValue == 0
                              //     ? ThemeConstants.buyColor
                              //     : ThemeConstants.sellColorOld,
                              // padding: const EdgeInsets.symmetric(
                              //     vertical: 17, horizontal: 20),
                              // color: Theme.of(context).colorScheme.primary,
                              // shape: StadiumBorder(),
                              child: Text(
                                Dataconstants.isAwaitingAlgoModify == true ? "Modify" : 'START',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              onPressed: () async {
                                // CommonFunction.firebaselogEvent(true,Dataconstants.isAwaitingAlgoModify == true
                                //     ? "Modify"
                                //     : 'START',"_Click",Dataconstants.isAwaitingAlgoModify == true
                                //     ? "Modify"
                                //     : 'START',);
                                //print("_currentMinute $_currentMinute");
                                //print('timeInterval $timeInterval');
                                //print(
                                //     'timeInterval Converted  $timeIntervalConverted');
                                //print('startTime Converted $startTimeConverted');
                                //print('endTime Converted $endTimeConverted');
                                //print(
                                //     'start Time & endTime difference   ${endTimeConverted -
                                //         startTimeConverted}');
                                //print(
                                //     'priceRangeLowValidation : $priceRangeLowValidation');

                                DateTime ExchStartDate = new DateTime(1980, 1, 1, 0, 0, 0);

                                DateTime st = DateTime.now();
                                //print('exchange date $ExchStartDate');
                                var currentDateTime = DateUtil.getAnyFormattedDate(st, "dd-MMM-yyyy");
                                //print('currentDateTime  $currentDateTime');
                                var newexchDAtes = DateUtil.getAnyFormattedDate(ExchStartDate, "dd-MMM-yyyy HH:mm:ss");

                                //-----------------------> exchange converted<---------------------------------------//

                                var dateexchsec = DateUtil.getIntFromDate1(newexchDAtes);
                                //print(' ExchangeDate Converted $dateexchsec');

                                //--------------------------> newStartTimePass<-------------------------------------------//

                                var newStartDate = DateUtil.getAnyFormattedExchDate(startTimeConverted, "HH:mm:ss");
                                var finalDate = currentDateTime + " " + newStartDate;
                                //print('present date time $finalDate');

                                var dateinsec = DateUtil.getIntFromDate1(finalDate);

                                //print(' converted new startTimePass $dateinsec');

                                int startTimePass = dateinsec - dateexchsec;

                                //print(' start time pass  $startTimePass');

                                //-----------------------------------> endtimePass <-------------------------------------------//

                                var newEndDate = DateUtil.getAnyFormattedExchDate(endTimeConverted, "HH:mm:ss");

                                var finalDate1 = currentDateTime + " " + newEndDate;
                                //print('present date time $finalDate');

                                var dateinsec1 = DateUtil.getIntFromDate1(finalDate1);

                                //print(' converted new EndTimePass $dateinsec1');

                                int endTimePass = dateinsec1 - dateexchsec;

                                //print(' end time pass  $endTimePass');

                                //-----------------------------------------Validations-----------------------------------------------//
                                if (Dataconstants.algoScriptModel == null || Dataconstants.algoScriptModel.name == null || Dataconstants.algoScriptModel.name == "") {
                                  CommonFunction.showSnackBarKey(
                                    key: _scaffoldKey,
                                    context: context,
                                    text: 'Please select Stock ',
                                    color: Colors.red,
                                  );
                                  return;
                                }
                                if (int.tryParse(_qtyContoller.text) == 0 || int.tryParse(_qtyContoller.text) < 1) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Please enter Total quantity');
                                  return;
                                }

                                if (int.parse(_slicingController.text) == 0 || int.parse(_slicingController.text) < 1 || _slicingController.text == " ") {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Please enter Slicing quantity');
                                  return;
                                }

                                if (currentModel.exchCategory == ExchCategory.nseFuture) {
                                  int totalQty = int.tryParse(_qtyContoller.text) ?? null;
                                  int slicingQty = int.tryParse(_slicingController.text) ?? null;
                                  if (totalQty % currentModel.minimumLotQty != 0) {
                                    CommonFunction.showBasicToast('Please enter Total quantity in the lot size of ${currentModel.minimumLotQty}');
                                    return;
                                  }

                                  if (slicingQty % currentModel.minimumLotQty != 0) {
                                    CommonFunction.showBasicToast('Please enter Slicing quantity in the lot size of ${currentModel.minimumLotQty}');
                                    return;
                                  }
                                }
                                if (double.tryParse(_qtyContoller.text) <= double.tryParse(_slicingController.text)) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Slicing quantity cannot be greater than or equal to Total quantity');
                                  return;
                                }

                                if (double.tryParse(_slicingController.text) > Dataconstants.maxOrderQty) {
                                  CommonFunction.showSnackBarKey(
                                      key: _scaffoldKey,
                                      color: Colors.red,
                                      context: context,
                                      text:
                                          (widget.id != 3 && widget.id != 4) ? 'Max slice  qty allowed is ${Dataconstants.maxOrderQty}' : 'Max averaging  qty allowed is ${Dataconstants.maxOrderQty}');
                                  return;
                                }

                                if (widget.id != 3 && widget.id != 4) {
                                  if (timeIntervalConverted == 0) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Time interval cannot be zero ');
                                    return;
                                  }
                                }
                                if (startTimeConverted >= endTimeConverted) {
                                  //_slicingController
                                  CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Start time cannot be greater than or equal to End Time');
                                  return;
                                }
                                if (widget.id != 3 && widget.id != 4) {
                                  if (timeIntervalConverted > (endTimeConverted - startTimeConverted)) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey, color: Colors.red, context: context, text: 'Time interval cannot be greater than the difference between Algo Start and End time');
                                    return;
                                  }
                                }

                                // if (Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesOpen) {
                                //   //_slicingController
                                //   CommonFunction.showSnackBarKey(
                                //       key: _scaffoldKey,
                                //       color: Colors.red,
                                //       context: context,
                                //       text:
                                //       'Market Closed');
                                //   return;
                                // }

                                if (widget.id == 2) {
                                  if (double.parse(_priceLowController.text) == 0.0) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price  range low cannot be zero ');
                                    return;
                                  }
                                  if (double.parse(_priceHighController.text) == 0.0) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range high cannot be zero ');
                                    return;
                                  }
                                  if (currentModel != null) if (isMultipleOf(_priceHighController.text, currentModel.incrementTicksize())) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range high should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                    return;
                                  }
                                }
                                //----------------If Buy  -----********--------

                                if (widget.id == 2) {
                                  if (double.tryParse(_priceLowController.text) >= double.tryParse(_priceHighController.text)) {
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range low cannot be greater or equal to  Price range high');
                                    return;
                                  }
                                  if (double.tryParse(_slicingController.text) * double.tryParse(_priceHighController.text) > Dataconstants.maxDerivOrderValue) {
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Slice order value allowed is ${Dataconstants.maxDerivOrderValue}');
                                    return;
                                  }

                                  if (currentModel != null) if (isMultipleOf(_priceLowController.text, currentModel.incrementTicksize())) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey, color: Colors.red, context: context, text: 'Price range low should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                    return;
                                  }
                                }
                                //--------------------If sell -----********--------
                                // if (widget.id == 2 && groupValue == 1) {
                                //   if (double.tryParse(_priceLowController.text) <
                                //       double.tryParse(_priceHighController.text)) {
                                //     CommonFunction.showSnackBarKey(
                                //         key: _scaffoldKey,
                                //         color: Colors.red,
                                //         context: context,
                                //         text:
                                //         'Price range low cannot be less than price range high');
                                //     return;
                                //   }
                                //   if (double.tryParse(_slicingController.text) *
                                //       double.tryParse(_priceHighController.text) >
                                //       Dataconstants.maxCashOrderValue) {
                                //     CommonFunction.showSnackBarKey(
                                //         key: _scaffoldKey,
                                //         color: Colors.red,
                                //         context: context,
                                //         text:
                                //         'Max Cash Order value allowed is Rs.  ${Dataconstants
                                //             .maxCashOrderValue}');
                                //     return;
                                //   }
                                // }

                                // end pricing band validation

                                if (widget.name == "Averaging" || widget.name == "Averaging Scalper") {
                                  if (double.parse(_averagingEntryDifference.text) == 0.0) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging entry difference cannot be zero');
                                    return;
                                  }
                                  if (currentModel != null) if (isMultipleOf(_averagingEntryDifference.text, currentModel.incrementTicksize())) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey,
                                        color: Colors.red,
                                        context: context,
                                        text: 'Averaging entry difference should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                    return;
                                  }
                                  if (atMarket == 1) {
                                    if (currentModel != null) if (isMultipleOf(_atMarket.text, currentModel.incrementTicksize()))
                                    // if ((double.parse(_atMarket.text) * 100) % (currentModel.incrementTicksize() * 100) >= 0.01)
                                    {
                                      //_slicingController
                                      CommonFunction.showSnackBarKey(
                                          key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging Start Price should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                      return;
                                    }
                                  }
                                }

                                if (widget.name == "Averaging Scalper") {
                                  if (double.parse(_averagingExitDifference.text) == 0.0) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Averaging exit difference cannot be zero');
                                    return;
                                  }
                                  if (currentModel != null) if (isMultipleOf(_averagingExitDifference.text, currentModel.incrementTicksize())) {
                                    //_slicingController
                                    CommonFunction.showSnackBarKey(
                                        key: _scaffoldKey,
                                        color: Colors.red,
                                        context: context,
                                        text: 'Averaging exit difference should be in Tick size(${currentModel.incrementTicksize()}) multiples');
                                    return;
                                  }
                                }

                                // --------------------------------validation end----------------------------------------------------//

                                var valueIsToDisplay = [];
                                var valueIsToDisplay2 = [];

                                for (var i = 0; i < widget.paramModel.length; i++) {
                                  if (widget.paramModel[i].paramName == "Limit Price")
                                    finalValues[i] = atMarket == 1
                                        ? _atMarket.text == ""
                                            ? "0"
                                            : _atMarket.text
                                        : "0";
                                  // currentModel != null
                                  //     ? currentModel.close.toStringAsFixed(
                                  //     currentModel.precision)
                                  //     : "";

                                  valueIsToDisplay.add([widget.paramModel[i].requestKey.toString(), finalValues[i].toString()]);
                                  // valueIsToDisplay2.add([
                                  //   widget.paramModel[i].displayKey.toString(),
                                  //   finalValues[i].toString()
                                  // ]);
                                }

                                for (var i = 0; i < widget.paramModel.length; i++) {
                                  if (widget.paramModel[i].paramName == "Limit Price")
                                    finalValues[i] = atMarket == 1
                                        ? _atMarket.text == ""
                                            ? "0"
                                            : _atMarket.text
                                        : currentModel != null
                                            ? "Mkt"
                                            : "";
                                  valueIsToDisplay2.add([widget.paramModel[i].displayKey.toString(), finalValues[i].toString()]);
                                }
                                // //print('valueIsToDisplay : ${widget.paramModel[0].requestKey}');
                                //print('valueIsToDisplay : $valueIsToDisplay');
                                Dataconstants.algoSubmitted = true;
                                //print(
                                //     'valueIsToDisplay222222222 : $valueIsToDisplay2');

                                var response = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdvanceOrderReviewScreen(
                                            stock: Dataconstants.algoScriptModel.name,
                                            algoName: widget.name,
                                            orderType: groupValue == 0 ? "BUY" : "SELL",
                                            exchange: _exchTogglePosition == 0 ? "NSE" : "BSE",
                                            productType: (currentModel != null && currentModel.exchCategory == ExchCategory.nseOptions)
                                                ? "NORMAL"
                                                : productType == 0
                                                    ? "INTRADAY"
                                                    : (currentModel != null && currentModel.exchCategory == ExchCategory.nseFuture)
                                                        ? 'NORMAL'
                                                        : widget.id == 4
                                                            ? "INTRADAY"
                                                            : 'DELIVERY',
                                            totalQuantity: _qtyContoller.text,
                                            slicingQuantity: _slicingController.text,
                                            startTime: startTime,
                                            startTimeConverted: startTimePass,
                                            endTime: endTime,
                                            endTimeConverted: endTimePass,
                                            timeInterval: timeInterval,
                                            timeIntervalConverted: timeIntervalConverted,
                                            algoId: widget.algoPriceBetterment == true ? 6 : widget.id,
                                            model: currentModel,
                                            atMarket: atMarket == 1 ? false : true,
                                            dynamicValue: valueIsToDisplay,
                                            dynamicValue2: valueIsToDisplay2)));
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  hourMinuteSecond() {
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
