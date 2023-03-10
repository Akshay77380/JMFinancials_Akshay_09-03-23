import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../jmScreens/ScriptInfo/ScriptInfo.dart';
import '../model/scrip_info_model.dart';
import '../screens/scrip_details_screen.dart';
import '../style/theme.dart';
import '../util/Dataconstants.dart';
import '../util/DateUtil.dart';
import '../widget/scripdetail_future.dart';

class ScripdetailOptionChain extends StatefulWidget {
  final ScripInfoModel currentModel;
  final List<int> optionDates;
  final String comingFrom;
  final int strikeCount;
  final int currentDate;

  ScripdetailOptionChain(this.currentModel, this.optionDates, [this.currentDate = 0, this.comingFrom, this.strikeCount = 4]);

  @override
  _ScripdetailOptionChainState createState() => _ScripdetailOptionChainState();
}

class _ScripdetailOptionChainState extends State<ScripdetailOptionChain> {
  Map<String, List<OptionChainScripData>> options;
  Timer maxMinOiTimer;
  static const double rowHeight = 54;
  bool minExtendReached = false, maxExtendReached = false;
  int maxOICall = 0,
      maxOIPut = 0,
      waitCounter = 0,
      optionIndex = 0,
      lessLength = 0,
      moreLength = 0;
  ScrollController _scrollController;
  List<String> optionDatesTemp;
  ValueNotifier<int> spotButton = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    maxMinOiTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      fillMaxOI();
    });
    _scrollController = new ScrollController();
    if (widget.currentModel.exchCategory == ExchCategory.mcxFutures ||
        widget.currentModel.exchCategory == ExchCategory.mcxOptions)
      optionDatesTemp = widget.optionDates
          .map((e) => DateUtil.getMcxDateWithFormat(e, 'dd MMM yyyy'))
          .toList();
    else
      optionDatesTemp = widget.optionDates
          .map((e) => DateUtil.getDateWithFormat(e, 'dd MMM yyyy'))
          .toList();
    if (widget.currentDate != 0) {
      optionIndex = widget.optionDates
          .indexWhere((element) => element == widget.currentDate);
      if (optionIndex < 0) optionIndex = 0;
    }
    if (widget.currentModel.close == 0) {
      getStrikePrice();
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (waitCounter >= 3) {
          timer.cancel();
          getStrikePrice();
        } else if (widget.currentModel.close != 0) {
          waitCounter++;
          getStrikePrice();
        }
      });
    } else
      getStrikePrice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCenterAndListen();
      sendReqIfInViewPort();
    });
    // //print("option chain data-> ${options.length}");
  }

  @override
  void dispose() {
    maxMinOiTimer.cancel();
    maxMinOiTimer = null;
    stopLiveData();
    _scrollController.removeListener(sendReqIfInViewPort);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToCenterAndListen() {
    try {
      minExtendReached = false;
      maxExtendReached = false;
      _scrollController.jumpTo(
        rowHeight * (options['LessCE'].length - widget.strikeCount),
      );
      _scrollController.addListener(sendReqIfInViewPort);
    } catch (e) {
      // //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Expiry", style: theme.textTheme.headline6),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ScripdetailFOPicker(
                        optionDatesTemp, changeOptionIndex, false, optionIndex),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      optionDatesTemp[optionIndex],
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(Icons.expand_more),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          thickness: 2,
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              //alignment: Alignment.centerLeft,
              child: Text('CALL'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              //alignment: Alignment.centerLeft,
              child: Text('PUT'),
            ),
          ],
        ),
        Divider(
          thickness: 2,
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                alignment: Alignment.centerLeft,
                // child: Text('OI (lakhs)'),
                child: Text(
                    'OI ${widget.currentModel.exchCategory == ExchCategory.mcxFutures || widget.currentModel.exchCategory == ExchCategory.mcxOptions ? '(LOTS)' : '(lakhs)'}'),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                alignment: Alignment.centerLeft,
                child: Text('LTP'),
              ),
            ),
            Expanded(
              child: Container(
                color: theme.cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                alignment: Alignment.center,
                child: Text('Strike'),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                alignment: Alignment.centerRight,
                child: Text('LTP'),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                alignment: Alignment.centerRight,
                // child: Text('OI (lakhs)'),
                child: Text(
                    'OI ${widget.currentModel.exchCategory == ExchCategory.mcxFutures || widget.currentModel.exchCategory == ExchCategory.mcxOptions ? '(LOTS)' : '(lakhs)'}'),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 2,
          height: 2,
        ),
        Expanded(
          child: options == null
              ? Center(child: Text('No data available.'))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: lessLength + moreLength + 1,
                        itemBuilder: (context, index) {
                          if (index < lessLength)
                            return OptionChainRow(
                                options['LessCE'][index].model,
                                options['LessPE'][index].model,
                                maxOICall,
                                maxOIPut,
                                true,
                                widget.comingFrom);
                          else if (index == lessLength)
                            return Divider(
                              color: theme.textTheme.bodyText1.color,
                              thickness: 1,
                              height: 1,
                            );
                          else
                            return OptionChainRow(
                                options['MoreCE'][index - lessLength - 1].model,
                                options['MorePE'][index - lessLength - 1].model,
                                maxOICall,
                                maxOIPut,
                                false,
                                widget.comingFrom);
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: spotButton,
                        builder: (context, value, child) {
                          if (value == 0)
                            return SizedBox.shrink();
                          else
                            return Align(
                              alignment: value == -1
                                  ? Alignment.topCenter
                                  : Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 35,
                                  horizontal: 18,
                                ),
                                child: SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                    ),
                                    child: Text(
                                      'Go to Spot',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _scrollController.animateTo(
                                        rowHeight *
                                            (options['LessCE'].length - 4),
                                        duration: Duration(milliseconds: 1000),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void getStrikePrice() {
    try {
      if (widget.currentModel.exchCategory == ExchCategory.mcxFutures ||
          widget.currentModel.exchCategory == ExchCategory.mcxOptions)
        options = Dataconstants.exchData[5].getOptionModelsMcx(
            widget.currentModel, widget.optionDates[optionIndex]);
      else if (widget.currentModel.exchCategory ==
              ExchCategory.currenyFutures ||
          widget.currentModel.exchCategory == ExchCategory.currenyOptions)
        options = Dataconstants.exchData[3].getOptionModelsCurr(
            widget.currentModel, widget.optionDates[optionIndex]);
      else if (widget.currentModel.exchCategory ==
              ExchCategory.bseCurrenyFutures ||
          widget.currentModel.exchCategory == ExchCategory.bseCurrenyOptions)
        options = Dataconstants.exchData[4].getOptionModelsCurr(
            widget.currentModel, widget.optionDates[optionIndex]);
      else
        options = Dataconstants.exchData[1].getOptionModels(
            widget.currentModel, widget.optionDates[optionIndex]);
      lessLength = options['LessCE'].length;
      moreLength = options['MoreCE'].length;

      for (int i = lessLength - 1; i >= lessLength - 5; i--) {
        Dataconstants.iqsClient.sendLTPRequest(
          options['LessCE'][i].model,
          true,
        );
        Dataconstants.iqsClient.sendLTPRequest(
          options['LessPE'][i].model,
          true,
        );
        options['LessCE'][i].requestSent = true;
        options['LessPE'][i].requestSent = true;
      }
      for (int i = 0; i <= 5; i++) {
        Dataconstants.iqsClient.sendLTPRequest(
          options['MoreCE'][i].model,
          true,
        );
        Dataconstants.iqsClient.sendLTPRequest(
          options['MorePE'][i].model,
          true,
        );
        options['MoreCE'][i].requestSent = true;
        options['MorePE'][i].requestSent = true;
      }
    } catch (e) {
      // //print(e);
    }
  }

  void sendReqIfInViewPort() {
    try {
      double window = _scrollController.position.pixels +
          _scrollController.position.viewportDimension;
      int first = _scrollController.position.pixels ~/ rowHeight;
      int last = window ~/ rowHeight;
      double spotPixelLocation = rowHeight * lessLength;
      if (window < spotPixelLocation)
        spotButton.value = -1;
      else if (spotPixelLocation < _scrollController.position.pixels)
        spotButton.value = 1;
      else
        spotButton.value = 0;
      if (minExtendReached && maxExtendReached) return;
      if (first < 0) first = 0;
      if (last > lessLength + moreLength + 1)
        last = lessLength + moreLength + 1;
      for (int i = first; i <= last; i++) {
        if (i < lessLength) {
          if (minExtendReached) continue;
          if (!options['LessCE'][i].requestSent) {
            Dataconstants.iqsClient.sendLTPRequest(
              options['LessCE'][i].model,
              true,
            );
            options['LessCE'][i].requestSent = true;
          }
          if (!options['LessPE'][i].requestSent) {
            Dataconstants.iqsClient.sendLTPRequest(
              options['LessPE'][i].model,
              true,
            );
            options['LessPE'][i].requestSent = true;
          }
        } else if (i == lessLength)
          continue;
        else {
          if (maxExtendReached) continue;
          if (!options['MoreCE'][i - lessLength - 1].requestSent) {
            Dataconstants.iqsClient.sendLTPRequest(
              options['MoreCE'][i - lessLength - 1].model,
              true,
            );
            options['MoreCE'][i - lessLength - 1].requestSent = true;
          }
          if (!options['MorePE'][i - lessLength - 1].requestSent) {
            Dataconstants.iqsClient.sendLTPRequest(
              options['MorePE'][i - lessLength - 1].model,
              true,
            );
            options['MorePE'][i - lessLength - 1].requestSent = true;
          }
        }
      }
      if (first <= 0) minExtendReached = true;
      if (last >= lessLength + moreLength) maxExtendReached = true;
    } catch (e) {
      // //print(e);
    }
  }

  void fillMaxOI() {
    try {
      var newMaxOICall = maxOICall, newMaxOIPut = maxOIPut;
      for (var option in options['LessCE']) {
        if (newMaxOICall < option.model.openInterest)
          newMaxOICall = option.model.openInterest;
      }
      for (var option in options['MoreCE']) {
        if (newMaxOICall < option.model.openInterest)
          newMaxOICall = option.model.openInterest;
      }
      for (var option in options['LessPE']) {
        if (newMaxOIPut < option.model.openInterest)
          newMaxOIPut = option.model.openInterest;
      }
      for (var option in options['MorePE']) {
        if (newMaxOIPut < option.model.openInterest)
          newMaxOIPut = option.model.openInterest;
      }
      if (maxOICall != newMaxOICall || maxOIPut != newMaxOIPut) {
        if (mounted) {
          setState(() {
            maxOICall = newMaxOICall;
            maxOIPut = newMaxOIPut;
          });
        }
      }
    } catch (e) {
      // //print(e);
    }
  }

  void stopLiveData() {
    try {
      for (var option in options['LessCE']) {
        if (option.requestSent)
          Dataconstants.iqsClient.sendLTPRequest(option.model, false);
      }
      for (var option in options['MoreCE']) {
        if (option.requestSent)
          Dataconstants.iqsClient.sendLTPRequest(option.model, false);
      }
      for (var option in options['LessPE']) {
        if (option.requestSent)
          Dataconstants.iqsClient.sendLTPRequest(option.model, false);
      }
      for (var option in options['MorePE']) {
        if (option.requestSent)
          Dataconstants.iqsClient.sendLTPRequest(option.model, false);
      }
    } catch (e) {
      // //print(e);
    }
  }

  void changeOptionIndex(int currIndex) {
    stopLiveData();
    setState(() {
      optionIndex = currIndex;
    });
    getStrikePrice();
    scrollToCenterAndListen();
  }
}

class OptionChainRow extends StatelessWidget {
  final ScripInfoModel callModel, putModel;
  final double verticalPadding = 8, horizontalPadding = 5;
  final int maxOICall, maxOIPut;
  final bool leftHighlight;
  final String comingFrom;

  OptionChainRow(
    this.callModel,
    this.putModel,
    this.maxOICall,
    this.maxOIPut,
    this.leftHighlight,
    this.comingFrom,
  );

  double getOIWidthFactor(int oi, bool isCall) {
    if (oi <= 0) return 0;
    var max = isCall ? maxOICall : maxOIPut;
    return oi / max;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: 54,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                color:
                    leftHighlight ? theme.primaryColor.withOpacity(0.15) : null,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: verticalPadding,
                  bottom: verticalPadding,
                  right: horizontalPadding,
                ),
                child: Observer(
                  builder: (context) => callModel.openInterest == 0
                      ? Text('--')
                      : Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ThemeConstants.buyColor.withOpacity(0.7),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: getOIWidthFactor(
                                      callModel.openInterest, true),
                                  heightFactor: 0.6,
                                ),
                              ),
                            ),
                            Text(
                              callModel.openInterestText,
                            ),
                          ],
                        ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScriptInfo(
                        callModel),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                color:
                    leftHighlight ? theme.primaryColor.withOpacity(0.15) : null,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Observer(
                  builder: (context) {
                    if (callModel.close == 0)
                      return Text('--');
                    else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            callModel.close
                                .toStringAsFixed(callModel.precision),
                          ),
                          Text(
                            callModel.optionChainPercentChangeText,
                            style: TextStyle(color: Colors.grey[600], fontSize: 11),
                          )
                        ],
                      );
                  },
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScriptInfo(
                        callModel),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: theme.cardColor,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              child: FittedBox(
                child: Text(
                  callModel.strikePrice.toStringAsFixed(callModel.precision),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                color:
                    leftHighlight ? null : theme.primaryColor.withOpacity(0.15),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Observer(
                  builder: (context) {
                    if (putModel.close == 0)
                      return Text('--');
                    else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(putModel.close
                              .toStringAsFixed(putModel.precision)),
                          Text(
                            putModel.optionChainPercentChangeText,
                            style: TextStyle(color: Colors.grey[600], fontSize: 11),
                          )
                        ],
                      );
                  },
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScriptInfo(
                       putModel),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                color:
                    leftHighlight ? null : theme.primaryColor.withOpacity(0.15),
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: verticalPadding,
                  top: verticalPadding,
                  left: horizontalPadding,
                ),
                child: Observer(
                  builder: (context) => putModel.openInterest == 0
                      ? Text('--')
                      : Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      ThemeConstants.sellColor.withOpacity(0.7),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: getOIWidthFactor(
                                      putModel.openInterest, false),
                                  heightFactor: 0.6,
                                ),
                              ),
                            ),
                            Text(
                              putModel.openInterestText,
                            ),
                          ],
                        ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScriptInfo(
                        putModel),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptionChainScripData {
  final ScripInfoModel model;
  bool requestSent = false;

  OptionChainScripData(this.model);
}
