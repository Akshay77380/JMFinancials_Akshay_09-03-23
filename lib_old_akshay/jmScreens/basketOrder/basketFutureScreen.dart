import 'dart:io';
import 'dart:math';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../screens/scrip_details_screen.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../widget/decimal_text.dart';

import '../../model/scrip_info_model.dart';
import '../CommonWidgets/number_field.dart';
import 'instrumentViewScreen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BasketFutureOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  bool isBuy;
  final ReportCalledFrom reportCalledFrom;
  final bool isResearch;

  BasketFutureOrderScreen({
    @required this.model,
    @required this.isBuy,
    @required this.reportCalledFrom,
    this.isResearch,
    String comingFrom,
  });

  @override
  _BasketFutureOrderScreenState createState() =>
      _BasketFutureOrderScreenState();
}

class _BasketFutureOrderScreenState extends State<BasketFutureOrderScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _qtyContoller, _limitController, _triggerController;
  double finalOrderMargin = 0.00;
  bool _isValidityEnabled = true, isOpen = false, showVTCDate = false;
  ValueNotifier<bool> slCalculating = ValueNotifier(false);
  String coverLimitPrice = '0.00';
  // bool isSpan = Dataconstants
  //         .accountInfo[Dataconstants.currentSelectedAccount].isSpan,
   bool   showButton = true;
  String oldSLValue = "0.00";
  String viewMarginCover = "0.00", vtcDateText;
  DateTime vtcDate, maxVtcDate;
  var marginRecords;
  String calculativeMargin = '0.00';
  int validity = 0;
  var result;
  var isLight;

  @override
  void initState() {
    _qtyContoller = TextEditingController();
    _limitController = TextEditingController();
    _triggerController = TextEditingController();
    super.initState();
    widget.isBuy = InAppSelection.buySellBasketorder == 0 ? true : false;
    isLight = ThemeConstants.themeMode.value == ThemeMode.light;
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.model.exch, widget.model.exchCode, true);
    _qtyContoller.text = widget.model.minimumLotQty.toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          _limitController.text =
              CommonFunction.getMarketRate(widget.model, widget.isBuy)
                  .toStringAsFixed(widget.model.precision);
        });
      }
      _qtyContoller.addListener(() {
        if (mounted) setState(() {});
      });
      _limitController.addListener(() {
        if (mounted) setState(() {});
      });
    });
    CommonFunction.changeStatusBar();
    callLimit();
  }

  callLimit() async {
    if (InAppSelection.buyFutureOrderDelIntra == 2 ||
        InAppSelection.sellFutureOrderDelIntra == 2) {
      await calculateSLValue();
      await Future.delayed(Duration(milliseconds: 500));
      await calcCoverLimit();
    }
    _limitController.text = await getMarketRate(widget.model, widget.isBuy);
    print("limit => ${_limitController.text}");
    //
    // await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
    // await calcCoverLimit();
  }

  Future getMarketRate(ScripInfoModel model, bool isBuy) async {
    double rate = 0.00;

    if (isBuy) {
      rate = model.offerRate1;
      if (rate < 0.05) rate = model.bidRate1;
    } else {
      rate = model.bidRate1;
      if (rate < 0.05) rate = model.offerRate1;
    }
    if (rate < 0.05) rate = model.close;
    if (rate < 0.05) rate = model.prevDayClose;
    return rate.toStringAsFixed(model.precision);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          systemOverlayStyle: Dataconstants.overlayStyle,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor:
              widget.isBuy ? ThemeConstants.buyColor : ThemeConstants.sellColor,
          title: Text(
            widget.model.exchCategory == ExchCategory.nseEquity ||
                    widget.model.exchCategory == ExchCategory.bseEquity
                ? widget.model.desc
                : widget.model.marketWatchName,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 45,
                  color: widget.isBuy
                      ? ThemeConstants.buyColor
                      : ThemeConstants.sellColor,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.model.name,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${widget.model.exchName.toUpperCase()} ${widget.model.series.toUpperCase()}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Observer(
                              builder: (_) => DecimalText(
                                  widget.model.close == 0.00
                                      ? widget.model.prevDayClose
                                          .toStringAsFixed(2)
                                      : widget.model.close.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: widget.model.priceColor == 1
                                        ? ThemeConstants.buyColor
                                        : widget.model.priceColor == 2
                                            ? ThemeConstants.sellColor
                                            : theme.textTheme.bodyText1.color,
                                  )),
                            ),
                            Row(
                              children: [
                                Observer(
                                  builder: (_) => Text(
                                    widget.model.close == 0.00
                                        ? '0.00'
                                        : widget.model.priceChangeText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.model.percentChange > 0
                                          ? ThemeConstants.buyColor
                                          : widget.model.percentChange < 0
                                              ? ThemeConstants.sellColor
                                              : theme.textTheme.bodyText1.color,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Observer(
                                  builder: (_) => Text(
                                    widget.model.close == 0.00
                                        ? '(0.00%)'
                                        : widget.model.percentChangeText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.model.percentChange > 0
                                          ? ThemeConstants.buyColor
                                          : widget.model.percentChange < 0
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
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('NORMAL - Future'),
                                            SizedBox(height: 10),
                                            Text('INTRADAY - Future Plus'),
                                            SizedBox(height: 10),
                                            Text(
                                                'COVER - Cover Order (Future Plus SLTP)'),
                                            SizedBox(height: 10),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('NORMAL - Future'),
                                            SizedBox(height: 10),
                                            Text('INTRADAY - Future Plus'),
                                            SizedBox(height: 10),
                                            Text(
                                                'COVER - Cover Order (Future Plus SLTP)'),
                                            SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: widget.isBuy
                                    ? CupertinoSlidingSegmentedControl(
                                        thumbColor: theme.accentColor,
                                        children: {
                                          0: Tooltip(
                                            message: 'Normal',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'NORMAL',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .buyFutureOrderDelIntra ==
                                                            0
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Tooltip(
                                            message: 'Future Plus',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'INTRADAY',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .buyFutureOrderDelIntra ==
                                                            1
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          2: Tooltip(
                                            message: 'Future Plus SLTP',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'COVER',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .buyFutureOrderDelIntra ==
                                                            2
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue: InAppSelection
                                            .buyFutureOrderDelIntra,
                                        onValueChanged: (newValue) async {

                                          if (widget.isBuy) {
                                            if (newValue ==
                                                InAppSelection
                                                    .buyFutureOrderDelIntra)
                                              return;

                                            setState(() {
                                              InAppSelection
                                                      .buyFutureOrderDelIntra =
                                                  newValue;
                                            });
                                          } else {
                                            setState(() {
                                              InAppSelection
                                                      .sellFutureOrderDelIntra =
                                                  newValue;
                                            });
                                          }
                                          if (newValue == 2) {
                                            await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                            await  calcCoverLimit();
                                          }


                                        },
                                      )
                                    : CupertinoSlidingSegmentedControl(
                                        thumbColor: theme.accentColor,
                                        children: {
                                          0: Tooltip(
                                            message: 'Normal',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'NORMAL',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .sellFutureOrderDelIntra ==
                                                            0
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Tooltip(
                                            message: 'Future Plus',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'INTRADAY',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .sellFutureOrderDelIntra ==
                                                            1
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          2: Tooltip(
                                            message: 'Future Plus SLTP',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'COVER',
                                                  style: TextStyle(
                                                    color: InAppSelection
                                                                .sellFutureOrderDelIntra ==
                                                            2
                                                        ? theme.primaryColor
                                                        : theme.textTheme
                                                            .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue: InAppSelection
                                            .sellFutureOrderDelIntra,
                                        onValueChanged: (newValue) async {

                                          if (widget.isBuy) {
                                            if (newValue ==
                                                InAppSelection
                                                    .buyFutureOrderDelIntra)
                                              return;

                                            setState(() {
                                              InAppSelection
                                                      .buyFutureOrderDelIntra =
                                                  newValue;
                                            });
                                          } else {
                                            setState(() {
                                              InAppSelection
                                                      .sellFutureOrderDelIntra =
                                                  newValue;
                                            });
                                          }
                                          if (newValue == 2) {
                                            await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                            await  calcCoverLimit();
                                          }
                                          // if (newValue ==
                                          //     InAppSelection
                                          //         .sellFutureOrderDelIntra)
                                          //   return;
                                          //
                                          // setState(() {
                                          //   InAppSelection
                                          //           .sellFutureOrderDelIntra =
                                          //       newValue;
                                          // });


                                        },
                                      )),
                          ],
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: widget.isBuy
                                    ? CupertinoSlidingSegmentedControl(
                                        thumbColor: widget.isBuy
                                            ? ThemeConstants.buyColor
                                            : ThemeConstants.sellColor,
                                        children: {
                                          0: Tooltip(
                                            message: 'BUY',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'BUY',
                                                  style: TextStyle(
                                                    color: theme.textTheme
                                                        .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Tooltip(
                                            message: 'SELL',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'SELL',
                                                  style: TextStyle(
                                                      color: theme.textTheme
                                                          .bodyText1.color),
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue:
                                            InAppSelection.buySellBasketorder,
                                        onValueChanged: (newValue) async {
                                          print("buy sell => $newValue");
                                          setState(() {
                                            InAppSelection.buySellBasketorder =
                                                newValue;
                                            widget.isBuy =
                                                newValue == 0 ? true : false;
                                          });
                                          await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                          await calcCoverLimit();
                                          setState(() {});
                                        },
                                      )
                                    : CupertinoSlidingSegmentedControl(
                                        thumbColor: widget.isBuy
                                            ? ThemeConstants.buyColor
                                            : ThemeConstants.sellColor,
                                        children: {
                                          0: Tooltip(
                                            message: 'BUY',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'BUY',
                                                  style: TextStyle(
                                                    color: theme.textTheme
                                                        .bodyText1.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          1: Tooltip(
                                            message: 'SELL',
                                            child: Container(
                                              height: 35,
                                              child: Center(
                                                child: Text(
                                                  'SELL',
                                                  style: TextStyle(
                                                      color: theme.textTheme
                                                          .bodyText1.color),
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                        groupValue:
                                            InAppSelection.buySellBasketorder,
                                        onValueChanged: (newValue) async {
                                          setState(() {
                                            InAppSelection.buySellBasketorder =
                                                newValue;
                                            widget.isBuy =
                                                newValue == 0 ? true : false;
                                          });
                                         await  calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                          await calcCoverLimit();
                                          setState(() {});
                                        },
                                      )),
                          ],
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'QUANTITY',
                          ),
                          Text(
                            'Lot: ${widget.model.minimumLotQty}',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      NumberField(
                        defaultValue: widget.model.minimumLotQty,
                        maxLength: 10,
                        numberController: _qtyContoller,
                        increment: widget.model.minimumLotQty,
                        hint: 'Quantity',
                        isInteger: true,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ORDER TYPE'),
                          widget.isBuy
                              ? CupertinoSlidingSegmentedControl(
                                  thumbColor: theme.accentColor,
                                  children: {
                                    0: Container(
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'MARKET',
                                          style: TextStyle(
                                            color: InAppSelection
                                                        .buyFutureOrderMarketLimit ==
                                                    0
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    1: Container(
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'LIMIT',
                                          style: TextStyle(
                                            color: InAppSelection
                                                        .buyFutureOrderMarketLimit ==
                                                    1
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  groupValue:
                                      InAppSelection.buyFutureOrderMarketLimit,
                                  onValueChanged: (newValue)async {
                                    if(newValue==1){
                                       await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                      await calcCoverLimit();
                                    }

                                    setState(() {

                                      InAppSelection.sellFutureOrderMarketLimit = 0;
                                      InAppSelection.buyFutureOrderMarketLimit =
                                          newValue;

                                      if (newValue == 0)
                                        InAppSelection.buyFutureOrderSL = false;
                                    });
                                  })
                              : CupertinoSlidingSegmentedControl(
                                  thumbColor: theme.accentColor,
                                  children: {
                                    0: Container(
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'MARKET',
                                          style: TextStyle(
                                            color: InAppSelection
                                                        .sellFutureOrderMarketLimit ==
                                                    0
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    1: Container(
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'LIMIT',
                                          style: TextStyle(
                                            color: InAppSelection
                                                        .sellFutureOrderMarketLimit ==
                                                    1
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  groupValue:
                                      InAppSelection.sellFutureOrderMarketLimit,
                                  onValueChanged: (newValue) async{
                                    if(newValue==1){
                                      await calculateSLValue();await Future.delayed(Duration(milliseconds: 500));
                                      await calcCoverLimit();
                                    }
                                    setState(() {
                                      InAppSelection.buyFutureOrderMarketLimit = 0;
                                      InAppSelection
                                              .sellFutureOrderMarketLimit =
                                          newValue;

                                      if (newValue == 0)
                                        InAppSelection.sellFutureOrderSL =
                                            false;
                                    });
                                  }),
                        ],
                      ),
                      AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          final offsetAnimation = Tween<Offset>(
                                  begin: Offset(0.0, -1.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation);
                          return ClipRect(
                            child: SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            ),
                          );
                        },
                        duration: const Duration(milliseconds: 250),
                        child: (widget.isBuy &&
                                    InAppSelection.buyFutureOrderMarketLimit ==
                                        1) ||
                                (!widget.isBuy &&
                                    InAppSelection.sellFutureOrderMarketLimit ==
                                        1)
                            ? Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: theme.primaryColor,
                                      ),
                                      child: Text('Market Depth'),
                                      onPressed: () async {
                                        String data =
                                            await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Market Depth',
                                                      style: theme
                                                          .textTheme.headline6,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  MarketDepth(
                                                    widget.model,
                                                    elevation: 0,
                                                    modalContext: context,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        if (data != null) {
                                          setState(() {
                                            _limitController.text = data;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Observer(builder: (context) {
                                    return NumberField(
                                      doubleDefaultValue: widget.model.close,
                                      doubleIncrement:
                                          widget.model.incrementTicksize(),
                                      maxLength: 10,
                                      numberController: _limitController,
                                      hint: 'Limit',
                                    );
                                  }),
                                ],
                              )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(height: 10),
                      (widget.model.exchCategory == ExchCategory.nseFuture &&
                              (InAppSelection.buyFutureOrderDelIntra == 2 ||
                                  InAppSelection.sellFutureOrderDelIntra == 2))
                          ? Builder(builder: (context) {
                              if ((widget.isBuy &&
                                      InAppSelection.buyFutureOrderDelIntra ==
                                          2) ||
                                  (!widget.isBuy &&
                                      InAppSelection.sellFutureOrderDelIntra ==
                                          2)) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(thickness: 1),
                                    SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            widget.isBuy
                                                ? 'SELL COVER ORDER'
                                                : 'BUY COVER ORDER',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: widget.isBuy
                                                    ? ThemeConstants.sellColor
                                                    : ThemeConstants.buyColor),
                                          ),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: Icon(
                                              Icons.info_outline,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            onTap: () {
                                              CommonFunction.showAlert(
                                                  context,
                                                  'Cover Order',
                                                  'Stop Loss should be ${widget.isBuy ? 'lower' : 'higer'} than Limit Price of Fresh Order and Last Traded Price',
                                                  'Close');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text('STOP LOSS'),
                                    // SizedBox(height: 10),
                                    // TriggerNumberField(
                                    //   triggerFunction: calcCoverLimit,
                                    //   doubleDefaultValue: widget.model.close,
                                    //   doubleIncrement:
                                    //       widget.model.incrementTicksize(),
                                    //   maxLength: 10,
                                    //   numberController: _triggerController,
                                    //   hint: 'Trigger',
                                    // ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('LIMIT'),
                                    Row(
                                      children: [
                                        DecimalText(
                                          coverLimitPrice,
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: slCalculating,
                                          builder: (context, value, child) =>
                                              IconButton(
                                            icon: value
                                                ? SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                    Center(
                                                      child: CircularProgressIndicator(),)
                                                  )
                                                : Icon(Icons.refresh),
                                            onPressed: () {
                                              calcCoverLimit();
                                              setState(() {});
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    // if ((widget.isBuy &&
                                    //     InAppSelection
                                    //         .buyFutureOrderMarketLimit ==
                                    //         1) ||
                                    //     (!widget.isBuy &&
                                    //         InAppSelection
                                    //             .sellFutureOrderMarketLimit ==
                                    //             1))
                                    //   Row(
                                    //     mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text('STOP LOSS3'),
                                    //       CupertinoSwitch(
                                    //         activeColor: widget.isBuy
                                    //             ? ThemeConstants.buyColor
                                    //             : ThemeConstants.sellColor,
                                    //         value: widget.isBuy
                                    //             ? InAppSelection
                                    //             .buyFutureOrderSL
                                    //             : InAppSelection
                                    //             .sellFutureOrderSL,
                                    //         onChanged: (val) {
                                    //           setState(() {
                                    //             if (widget.isBuy) {
                                    //               InAppSelection
                                    //                   .buyFutureOrderSL = val;
                                    //               if (val) {
                                    //                 validity = 0;
                                    //                 _isValidityEnabled = false;
                                    //               } else
                                    //                 _isValidityEnabled = true;
                                    //             } else {
                                    //               InAppSelection
                                    //                   .sellFutureOrderSL = val;
                                    //               if (val) {
                                    //                 validity = 0;
                                    //                 _isValidityEnabled = false;
                                    //               } else
                                    //                 _isValidityEnabled = true;
                                    //             }
                                    //           });
                                    //         },
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if ((widget.isBuy &&
                                    //         InAppSelection
                                    //                 .buyFutureOrderDelIntra !=
                                    //             2) ||
                                    //     (!widget.isBuy &&
                                    //         InAppSelection
                                    //                 .sellFutureOrderDelIntra !=
                                    //             2))
                                    //   SizedBox(
                                    //       height:
                                    //           InAppSelection.buyFutureOrderSL
                                    //               ? 15
                                    //               : 0),
                                    // AnimatedSwitcher(
                                    //   transitionBuilder: (Widget child,
                                    //       Animation<double> animation) {
                                    //     final offsetAnimation = Tween<Offset>(
                                    //             begin: Offset(0.0, -1.0),
                                    //             end: Offset(0.0, 0.0))
                                    //         .animate(animation);
                                    //     return ClipRect(
                                    //       child: SlideTransition(
                                    //         position: offsetAnimation,
                                    //         child: child,
                                    //       ),
                                    //     );
                                    //   },
                                    //   duration:
                                    //       const Duration(milliseconds: 250),
                                    //   child: (widget.isBuy &&
                                    //               InAppSelection
                                    //                   .buyFutureOrderSL) ||
                                    //           (!widget.isBuy &&
                                    //               InAppSelection
                                    //                   .sellFutureOrderSL)
                                    //       ? NumberField(
                                    //           doubleDefaultValue:
                                    //               widget.model.close,
                                    //           doubleIncrement: widget.model
                                    //               .incrementTicksize(),
                                    //           maxLength: 10,
                                    //           numberController:
                                    //               _triggerController,
                                    //           hint: 'Trigger2',
                                    //         )
                                    //       : SizedBox.shrink(),
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Text(
                                    //       isOpen ? 'Less' : 'More',
                                    //       style: TextStyle(
                                    //         fontSize: 18,
                                    //         color: Colors.grey,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     IconButton(
                                    //       icon: Icon(isOpen
                                    //           ? Icons.expand_less
                                    //           : Icons.expand_more),
                                    //       onPressed: () {
                                    //         setState(() {
                                    //           isOpen = !isOpen;
                                    //         });
                                    //       },
                                    //     ),
                                    //   ],
                                    // ),
                                    // Visibility(
                                    //   visible: isOpen,
                                    //   child: Column(
                                    //     children: [
                                    //       Container(
                                    //         width: double.infinity,
                                    //         child: Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment
                                    //                   .spaceBetween,
                                    //           children: [
                                    //             Expanded(
                                    //                 child: Text('VALIDITY')),
                                    //             Expanded(
                                    //               child: AbsorbPointer(
                                    //                 absorbing:
                                    //                     !_isValidityEnabled,
                                    //                 child: widget.isBuy
                                    //                     ? CupertinoSlidingSegmentedControl(
                                    //                         thumbColor: theme
                                    //                             .accentColor,
                                    //                         children: {
                                    //                           0: Container(
                                    //                             height: 35,
                                    //                             child: Center(
                                    //                               child: Text(
                                    //                                 'DAY',
                                    //                                 style:
                                    //                                     TextStyle(
                                    //                                   color: InAppSelection
                                    //                                           .buyFutureOrderSL
                                    //                                       ? Colors
                                    //                                           .grey
                                    //                                       : validity == 0
                                    //                                           ? theme.primaryColor
                                    //                                           : theme.textTheme.bodyText1.color,
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           1: Container(
                                    //                             height: 35,
                                    //                             child: Center(
                                    //                               child: Text(
                                    //                                 'IOC',
                                    //                                 style:
                                    //                                     TextStyle(
                                    //                                   decoration: InAppSelection
                                    //                                           .buyFutureOrderSL
                                    //                                       ? TextDecoration
                                    //                                           .lineThrough
                                    //                                       : null,
                                    //                                   decorationThickness:
                                    //                                       InAppSelection.buyFutureOrderSL
                                    //                                           ? 1
                                    //                                           : 0,
                                    //                                   color: InAppSelection
                                    //                                           .buyFutureOrderSL
                                    //                                       ? Colors
                                    //                                           .grey
                                    //                                       : validity == 1
                                    //                                           ? theme.primaryColor
                                    //                                           : theme.textTheme.bodyText1.color,
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           if (showVTCDate)
                                    //                             2: Container(
                                    //                               height: 35,
                                    //                               child: Stack(
                                    //                                 children: [
                                    //                                   if (validity ==
                                    //                                       2)
                                    //                                     Align(
                                    //                                       alignment:
                                    //                                           Alignment.centerRight,
                                    //                                       child:
                                    //                                           GestureDetector(
                                    //                                         behavior:
                                    //                                             HitTestBehavior.opaque,
                                    //                                         child:
                                    //                                             Icon(
                                    //                                           Icons.info_outline,
                                    //                                           size: 17,
                                    //                                           color: Colors.grey,
                                    //                                         ),
                                    //                                         onTap:
                                    //                                             () {
                                    //                                           CommonFunction.showAlert(context, 'VTC', 'Keep your limit orders valid for a period of time until cancelled or executed', 'Close');
                                    //                                         },
                                    //                                       ),
                                    //                                     ),
                                    //                                   Center(
                                    //                                     child:
                                    //                                         Text(
                                    //                                       'VTC',
                                    //                                       style:
                                    //                                           TextStyle(
                                    //                                         decoration: InAppSelection.buyFutureOrderSL
                                    //                                             ? TextDecoration.lineThrough
                                    //                                             : null,
                                    //                                         decorationThickness: InAppSelection.buyFutureOrderSL
                                    //                                             ? 1
                                    //                                             : 0,
                                    //                                         color: validity == 2
                                    //                                             ? theme.primaryColor
                                    //                                             : theme.textTheme.bodyText1.color,
                                    //                                       ),
                                    //                                     ),
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                             ),
                                    //                         },
                                    //                         groupValue:
                                    //                             _isValidityEnabled
                                    //                                 ? validity
                                    //                                 : 0,
                                    //                         onValueChanged:
                                    //                             (newValue) {
                                    //                           setState(() {
                                    //                             validity =
                                    //                                 newValue;
                                    //                           });
                                    //                         },
                                    //                       )
                                    //                     : CupertinoSlidingSegmentedControl(
                                    //                         thumbColor: theme
                                    //                             .accentColor,
                                    //                         children: {
                                    //                           0: Container(
                                    //                             height: 35,
                                    //                             child: Center(
                                    //                               child: Text(
                                    //                                 'DAY',
                                    //                                 style:
                                    //                                     TextStyle(
                                    //                                   color: InAppSelection
                                    //                                           .sellFutureOrderSL
                                    //                                       ? Colors
                                    //                                           .grey
                                    //                                       : validity == 0
                                    //                                           ? theme.primaryColor
                                    //                                           : theme.textTheme.bodyText1.color,
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           1: Container(
                                    //                             height: 35,
                                    //                             child: Center(
                                    //                               child: Text(
                                    //                                 'IOC',
                                    //                                 style:
                                    //                                     TextStyle(
                                    //                                   decoration: InAppSelection
                                    //                                           .sellFutureOrderSL
                                    //                                       ? TextDecoration
                                    //                                           .lineThrough
                                    //                                       : null,
                                    //                                   decorationThickness:
                                    //                                       InAppSelection.sellFutureOrderSL
                                    //                                           ? 1
                                    //                                           : 0,
                                    //                                   color: InAppSelection
                                    //                                           .sellFutureOrderSL
                                    //                                       ? Colors
                                    //                                           .grey
                                    //                                       : validity == 1
                                    //                                           ? theme.primaryColor
                                    //                                           : theme.textTheme.bodyText1.color,
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           if (showVTCDate)
                                    //                             2: Container(
                                    //                               height: 35,
                                    //                               child: Stack(
                                    //                                 children: [
                                    //                                   if (validity ==
                                    //                                       2)
                                    //                                     Align(
                                    //                                       alignment:
                                    //                                           Alignment.centerRight,
                                    //                                       child:
                                    //                                           GestureDetector(
                                    //                                         behavior:
                                    //                                             HitTestBehavior.opaque,
                                    //                                         child:
                                    //                                             Icon(
                                    //                                           Icons.info_outline,
                                    //                                           size: 17,
                                    //                                           color: Colors.grey,
                                    //                                         ),
                                    //                                         onTap:
                                    //                                             () {
                                    //                                           CommonFunction.showAlert(context, 'VTC', 'Keep your limit orders valid for a period of time until cancelled or executed', 'Close');
                                    //                                         },
                                    //                                       ),
                                    //                                     ),
                                    //                                   Center(
                                    //                                     child:
                                    //                                         Text(
                                    //                                       'VTC',
                                    //                                       style:
                                    //                                           TextStyle(
                                    //                                         decoration: InAppSelection.sellFutureOrderSL
                                    //                                             ? TextDecoration.lineThrough
                                    //                                             : null,
                                    //                                         decorationThickness: InAppSelection.sellFutureOrderSL
                                    //                                             ? 1
                                    //                                             : 0,
                                    //                                         color: validity == 2
                                    //                                             ? theme.primaryColor
                                    //                                             : theme.textTheme.bodyText1.color,
                                    //                                       ),
                                    //                                     ),
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                             ),
                                    //                         },
                                    //                         groupValue:
                                    //                             _isValidityEnabled
                                    //                                 ? validity
                                    //                                 : 0,
                                    //                         onValueChanged:
                                    //                             (newValue) {
                                    //                           setState(() {
                                    //                             validity =
                                    //                                 newValue;
                                    //                           });
                                    //                         },
                                    //                       ),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(height: 10),
                                    //       if (showVTCDate &&
                                    //           ((widget.isBuy &&
                                    //                   validity == 2) ||
                                    //               (!widget.isBuy &&
                                    //                   validity == 2)))
                                    //         Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               'VTC Date',
                                    //             ),
                                    //             SizedBox(height: 10),
                                    //             InkWell(
                                    //               child: Container(
                                    //                 height: 55,
                                    //                 padding:
                                    //                     EdgeInsets.symmetric(),
                                    //                 decoration: BoxDecoration(
                                    //                   border: Border.all(
                                    //                     color: Theme.of(context)
                                    //                         .dividerColor,
                                    //                   ),
                                    //                 ),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Expanded(
                                    //                       flex: 1,
                                    //                       child:
                                    //                           SizedBox.shrink(),
                                    //                     ),
                                    //                     Expanded(
                                    //                       flex: 5,
                                    //                       child: Text(
                                    //                         vtcDateText,
                                    //                         textAlign: TextAlign
                                    //                             .center,
                                    //                         style: TextStyle(
                                    //                           fontSize: 22,
                                    //                           fontWeight:
                                    //                               FontWeight
                                    //                                   .w700,
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                     Expanded(
                                    //                         flex: 1,
                                    //                         child: Icon(Icons
                                    //                             .date_range)),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               onTap: () async {
                                    //                 DateTime tempDate =
                                    //                     await showDatePicker(
                                    //                   context: context,
                                    //                   initialDate: vtcDate,
                                    //                   builder:
                                    //                       (BuildContext context,
                                    //                           Widget child) {
                                    //                     return Theme(
                                    //                       data:
                                    //                           ThemeData.light()
                                    //                               .copyWith(
                                    //                         colorScheme:
                                    //                             ColorScheme
                                    //                                 .fromSwatch(
                                    //                           primarySwatch:
                                    //                               Colors.red,
                                    //                         ),
                                    //                       ),
                                    //                       child: child,
                                    //                     );
                                    //                   },
                                    //                   firstDate: DateTime.now(),
                                    //                   lastDate: maxVtcDate,
                                    //                 );
                                    //                 if (tempDate != null) {
                                    //                   vtcDate = tempDate;
                                    //                   setState(() {
                                    //                     vtcDateText = DateFormat(
                                    //                             "dd-MMM-yyyy")
                                    //                         .format(vtcDate);
                                    //                   });
                                    //                 }
                                    //               },
                                    //             ),
                                    //           ],
                                    //         )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                );
                              }
                            })
                          : SizedBox.shrink(),
                      ((widget.model.exchCategory == ExchCategory.nseFuture &&
                              ((widget.isBuy &&
                                      InAppSelection.buyFutureOrderDelIntra !=
                                          2) ||
                                  (!widget.isBuy &&
                                      InAppSelection.sellFutureOrderDelIntra !=
                                          2))))
                          ? Column(
                              children: [
                                if ((widget.isBuy &&
                                        InAppSelection
                                                .buyFutureOrderMarketLimit ==
                                            1) ||
                                    (!widget.isBuy &&
                                        InAppSelection
                                                .sellFutureOrderMarketLimit ==
                                            1))
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('STOP LOSS'),
                                      CupertinoSwitch(
                                        activeColor: widget.isBuy
                                            ? ThemeConstants.buyColor
                                            : ThemeConstants.sellColor,
                                        value: widget.isBuy
                                            ? InAppSelection.buyFutureOrderSL
                                            : InAppSelection.sellFutureOrderSL,
                                        onChanged: (val) {
                                          setState(() {
                                            if (widget.isBuy) {
                                              InAppSelection.buyFutureOrderSL =
                                                  val;
                                              if (val) {
                                                validity = 0;
                                                _isValidityEnabled = false;
                                              } else
                                                _isValidityEnabled = true;
                                            } else {
                                              InAppSelection.sellFutureOrderSL =
                                                  val;
                                              if (val) {
                                                validity = 0;
                                                _isValidityEnabled = false;
                                              } else
                                                _isValidityEnabled = true;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                if ((widget.isBuy &&
                                        InAppSelection.buyFutureOrderDelIntra !=
                                            2) ||
                                    (!widget.isBuy &&
                                        InAppSelection
                                                .sellFutureOrderDelIntra !=
                                            2))
                                  SizedBox(
                                      height: InAppSelection.buyFutureOrderSL
                                          ? 15
                                          : 0),
                                AnimatedSwitcher(
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    final offsetAnimation = Tween<Offset>(
                                            begin: Offset(0.0, -1.0),
                                            end: Offset(0.0, 0.0))
                                        .animate(animation);
                                    return ClipRect(
                                      child: SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  duration: const Duration(milliseconds: 250),
                                  child: (widget.isBuy &&
                                              InAppSelection
                                                  .buyFutureOrderSL) ||
                                          (!widget.isBuy &&
                                              InAppSelection.sellFutureOrderSL)
                                      ? NumberField(
                                          doubleDefaultValue:
                                              widget.model.close,
                                          doubleIncrement:
                                              widget.model.incrementTicksize(),
                                          maxLength: 10,
                                          numberController: _triggerController,
                                          hint: 'Trigger',
                                        )
                                      : SizedBox.shrink(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isOpen ? 'Less' : 'More',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(isOpen
                                          ? Icons.expand_less
                                          : Icons.expand_more),
                                      onPressed: () {
                                        setState(() {
                                          isOpen = !isOpen;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: isOpen,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text('VALIDITY')),
                                            Expanded(
                                              child: AbsorbPointer(
                                                absorbing: !_isValidityEnabled,
                                                child: widget.isBuy
                                                    ? CupertinoSlidingSegmentedControl(
                                                        thumbColor:
                                                            theme.accentColor,
                                                        children: {
                                                          0: Container(
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'DAY',
                                                                style:
                                                                    TextStyle(
                                                                  color: InAppSelection
                                                                          .buyFutureOrderSL
                                                                      ? Colors
                                                                          .grey
                                                                      : validity ==
                                                                              0
                                                                          ? theme
                                                                              .primaryColor
                                                                          : theme
                                                                              .textTheme
                                                                              .bodyText1
                                                                              .color,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          1: Container(
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'IOC',
                                                                style:
                                                                    TextStyle(
                                                                  decoration: InAppSelection
                                                                          .buyFutureOrderSL
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : null,
                                                                  decorationThickness:
                                                                      InAppSelection
                                                                              .buyFutureOrderSL
                                                                          ? 1
                                                                          : 0,
                                                                  color: InAppSelection
                                                                          .buyFutureOrderSL
                                                                      ? Colors
                                                                          .grey
                                                                      : validity ==
                                                                              1
                                                                          ? theme
                                                                              .primaryColor
                                                                          : theme
                                                                              .textTheme
                                                                              .bodyText1
                                                                              .color,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (showVTCDate)
                                                            2: Container(
                                                              height: 35,
                                                              child: Stack(
                                                                children: [
                                                                  if (validity ==
                                                                      2)
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          GestureDetector(
                                                                        behavior:
                                                                            HitTestBehavior.opaque,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .info_outline,
                                                                          size:
                                                                              17,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          CommonFunction.showAlert(
                                                                              context,
                                                                              'VTC',
                                                                              'Keep your limit orders valid for a period of time until cancelled or executed',
                                                                              'Close');
                                                                        },
                                                                      ),
                                                                    ),
                                                                  Center(
                                                                    child: Text(
                                                                      'VTC',
                                                                      style:
                                                                          TextStyle(
                                                                        decoration: InAppSelection.buyFutureOrderSL
                                                                            ? TextDecoration.lineThrough
                                                                            : null,
                                                                        decorationThickness: InAppSelection.buyFutureOrderSL
                                                                            ? 1
                                                                            : 0,
                                                                        color: validity ==
                                                                                2
                                                                            ? theme.primaryColor
                                                                            : theme.textTheme.bodyText1.color,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        },
                                                        groupValue:
                                                            _isValidityEnabled
                                                                ? validity
                                                                : 0,
                                                        onValueChanged:
                                                            (newValue) {
                                                          setState(() {
                                                            validity = newValue;
                                                          });
                                                        },
                                                      )
                                                    : CupertinoSlidingSegmentedControl(
                                                        thumbColor:
                                                            theme.accentColor,
                                                        children: {
                                                          0: Container(
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'DAY',
                                                                style:
                                                                    TextStyle(
                                                                  color: InAppSelection
                                                                          .sellFutureOrderSL
                                                                      ? Colors
                                                                          .grey
                                                                      : validity ==
                                                                              0
                                                                          ? theme
                                                                              .primaryColor
                                                                          : theme
                                                                              .textTheme
                                                                              .bodyText1
                                                                              .color,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          1: Container(
                                                            height: 35,
                                                            child: Center(
                                                              child: Text(
                                                                'IOC',
                                                                style:
                                                                    TextStyle(
                                                                  decoration: InAppSelection
                                                                          .sellFutureOrderSL
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : null,
                                                                  decorationThickness:
                                                                      InAppSelection
                                                                              .sellFutureOrderSL
                                                                          ? 1
                                                                          : 0,
                                                                  color: InAppSelection
                                                                          .sellFutureOrderSL
                                                                      ? Colors
                                                                          .grey
                                                                      : validity ==
                                                                              1
                                                                          ? theme
                                                                              .primaryColor
                                                                          : theme
                                                                              .textTheme
                                                                              .bodyText1
                                                                              .color,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (showVTCDate)
                                                            2: Container(
                                                              height: 35,
                                                              child: Stack(
                                                                children: [
                                                                  if (validity ==
                                                                      2)
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          GestureDetector(
                                                                        behavior:
                                                                            HitTestBehavior.opaque,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .info_outline,
                                                                          size:
                                                                              17,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          CommonFunction.showAlert(
                                                                              context,
                                                                              'VTC',
                                                                              'Keep your limit orders valid for a period of time until cancelled or executed',
                                                                              'Close');
                                                                        },
                                                                      ),
                                                                    ),
                                                                  Center(
                                                                    child: Text(
                                                                      'VTC',
                                                                      style:
                                                                          TextStyle(
                                                                        decoration: InAppSelection.sellFutureOrderSL
                                                                            ? TextDecoration.lineThrough
                                                                            : null,
                                                                        decorationThickness: InAppSelection.sellFutureOrderSL
                                                                            ? 1
                                                                            : 0,
                                                                        color: validity ==
                                                                                2
                                                                            ? theme.primaryColor
                                                                            : theme.textTheme.bodyText1.color,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        },
                                                        groupValue:
                                                            _isValidityEnabled
                                                                ? validity
                                                                : 0,
                                                        onValueChanged:
                                                            (newValue) {
                                                          setState(() {
                                                            validity = newValue;
                                                          });
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (showVTCDate &&
                                          ((widget.isBuy && validity == 2) ||
                                              (!widget.isBuy && validity == 2)))
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'VTC Date',
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              child: Container(
                                                height: 55,
                                                padding: EdgeInsets.symmetric(),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: SizedBox.shrink(),
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        vtcDateText,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                            Icons.date_range)),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                DateTime tempDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: vtcDate,
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return Theme(
                                                      data: ThemeData.light()
                                                          .copyWith(
                                                        colorScheme: ColorScheme
                                                            .fromSwatch(
                                                          primarySwatch:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                                  firstDate: DateTime.now(),
                                                  lastDate: maxVtcDate,
                                                );
                                                if (tempDate != null) {
                                                  vtcDate = tempDate;
                                                  setState(() {
                                                    vtcDateText = DateFormat(
                                                            "dd-MMM-yyyy")
                                                        .format(vtcDate);
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ((widget.model.exchCategory ==
                                      ExchCategory.nseOptions &&
                                  ((widget.isBuy &&
                                          InAppSelection
                                                  .buyOptionOrderDelIntra !=
                                              1) ||
                                      (!widget.isBuy &&
                                          InAppSelection
                                                  .sellOptionOrderDelIntra !=
                                              1))))
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('STOP LOSS'),
                                        CupertinoSwitch(
                                          activeColor: widget.isBuy
                                              ? ThemeConstants.buyColor
                                              : ThemeConstants.sellColor,
                                          value: widget.isBuy
                                              ? InAppSelection.buyFutureOrderSL
                                              : InAppSelection
                                                  .sellFutureOrderSL,
                                          onChanged: (val) {
                                            setState(() {
                                              if (widget.isBuy) {
                                                InAppSelection
                                                    .buyFutureOrderSL = val;
                                                if (val) {
                                                  validity = 0;
                                                  _isValidityEnabled = false;
                                                } else
                                                  _isValidityEnabled = true;
                                              } else {
                                                InAppSelection
                                                    .sellFutureOrderSL = val;
                                                if (val) {
                                                  validity = 0;
                                                  _isValidityEnabled = false;
                                                } else
                                                  _isValidityEnabled = true;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    if ((widget.isBuy &&
                                            InAppSelection
                                                    .buyFutureOrderDelIntra !=
                                                2) ||
                                        (!widget.isBuy &&
                                            InAppSelection
                                                    .sellFutureOrderDelIntra !=
                                                2))
                                      SizedBox(
                                          height:
                                              InAppSelection.buyFutureOrderSL
                                                  ? 15
                                                  : 0),
                                    AnimatedSwitcher(
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        final offsetAnimation = Tween<Offset>(
                                                begin: Offset(0.0, -1.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation);
                                        return ClipRect(
                                          child: SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: (widget.isBuy &&
                                                  InAppSelection
                                                      .buyFutureOrderSL) ||
                                              (!widget.isBuy &&
                                                  InAppSelection
                                                      .sellFutureOrderSL)
                                          ? NumberField(
                                              doubleDefaultValue:
                                                  widget.model.close,
                                              doubleIncrement: widget.model
                                                  .incrementTicksize(),
                                              maxLength: 10,
                                              numberController:
                                                  _triggerController,
                                              hint: 'Trigger',
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isOpen ? 'Less' : 'More',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(isOpen
                                              ? Icons.expand_less
                                              : Icons.expand_more),
                                          onPressed: () {
                                            setState(() {
                                              isOpen = !isOpen;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: isOpen,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text('VALIDITY')),
                                                Expanded(
                                                  child: AbsorbPointer(
                                                    absorbing:
                                                        !_isValidityEnabled,
                                                    child: widget.isBuy
                                                        ? CupertinoSlidingSegmentedControl(
                                                            thumbColor: theme
                                                                .accentColor,
                                                            children: {
                                                              0: Container(
                                                                height: 35,
                                                                child: Center(
                                                                  child: Text(
                                                                    'DAY',
                                                                    style:
                                                                        TextStyle(
                                                                      color: InAppSelection
                                                                              .buyFutureOrderSL
                                                                          ? Colors
                                                                              .grey
                                                                          : validity == 0
                                                                              ? theme.primaryColor
                                                                              : theme.textTheme.bodyText1.color,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              1: Container(
                                                                height: 35,
                                                                child: Center(
                                                                  child: Text(
                                                                    'IOC',
                                                                    style:
                                                                        TextStyle(
                                                                      decoration: InAppSelection
                                                                              .buyFutureOrderSL
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : null,
                                                                      decorationThickness:
                                                                          InAppSelection.buyFutureOrderSL
                                                                              ? 1
                                                                              : 0,
                                                                      color: InAppSelection
                                                                              .buyFutureOrderSL
                                                                          ? Colors
                                                                              .grey
                                                                          : validity == 1
                                                                              ? theme.primaryColor
                                                                              : theme.textTheme.bodyText1.color,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (showVTCDate)
                                                                2: Container(
                                                                  height: 35,
                                                                  child: Stack(
                                                                    children: [
                                                                      if (validity ==
                                                                          2)
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              GestureDetector(
                                                                            behavior:
                                                                                HitTestBehavior.opaque,
                                                                            child:
                                                                                Icon(
                                                                              Icons.info_outline,
                                                                              size: 17,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              CommonFunction.showAlert(context, 'VTC', 'Keep your limit orders valid for a period of time until cancelled or executed', 'Close');
                                                                            },
                                                                          ),
                                                                        ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'VTC',
                                                                          style:
                                                                              TextStyle(
                                                                            decoration: InAppSelection.buyFutureOrderSL
                                                                                ? TextDecoration.lineThrough
                                                                                : null,
                                                                            decorationThickness: InAppSelection.buyFutureOrderSL
                                                                                ? 1
                                                                                : 0,
                                                                            color: validity == 2
                                                                                ? theme.primaryColor
                                                                                : theme.textTheme.bodyText1.color,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            },
                                                            groupValue:
                                                                _isValidityEnabled
                                                                    ? validity
                                                                    : 0,
                                                            onValueChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                validity =
                                                                    newValue;
                                                              });
                                                            },
                                                          )
                                                        : CupertinoSlidingSegmentedControl(
                                                            thumbColor: theme
                                                                .accentColor,
                                                            children: {
                                                              0: Container(
                                                                height: 35,
                                                                child: Center(
                                                                  child: Text(
                                                                    'DAY',
                                                                    style:
                                                                        TextStyle(
                                                                      color: InAppSelection
                                                                              .sellFutureOrderSL
                                                                          ? Colors
                                                                              .grey
                                                                          : validity == 0
                                                                              ? theme.primaryColor
                                                                              : theme.textTheme.bodyText1.color,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              1: Container(
                                                                height: 35,
                                                                child: Center(
                                                                  child: Text(
                                                                    'IOC',
                                                                    style:
                                                                        TextStyle(
                                                                      decoration: InAppSelection
                                                                              .sellFutureOrderSL
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : null,
                                                                      decorationThickness:
                                                                          InAppSelection.sellFutureOrderSL
                                                                              ? 1
                                                                              : 0,
                                                                      color: InAppSelection
                                                                              .sellFutureOrderSL
                                                                          ? Colors
                                                                              .grey
                                                                          : validity == 1
                                                                              ? theme.primaryColor
                                                                              : theme.textTheme.bodyText1.color,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (showVTCDate)
                                                                2: Container(
                                                                  height: 35,
                                                                  child: Stack(
                                                                    children: [
                                                                      if (validity ==
                                                                          2)
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              GestureDetector(
                                                                            behavior:
                                                                                HitTestBehavior.opaque,
                                                                            child:
                                                                                Icon(
                                                                              Icons.info_outline,
                                                                              size: 17,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              CommonFunction.showAlert(context, 'VTC', 'Keep your limit orders valid for a period of time until cancelled or executed', 'Close');
                                                                            },
                                                                          ),
                                                                        ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'VTC',
                                                                          style:
                                                                              TextStyle(
                                                                            decoration: InAppSelection.sellFutureOrderSL
                                                                                ? TextDecoration.lineThrough
                                                                                : null,
                                                                            decorationThickness: InAppSelection.sellFutureOrderSL
                                                                                ? 1
                                                                                : 0,
                                                                            color: validity == 2
                                                                                ? theme.primaryColor
                                                                                : theme.textTheme.bodyText1.color,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            },
                                                            groupValue:
                                                                _isValidityEnabled
                                                                    ? validity
                                                                    : 0,
                                                            onValueChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                validity =
                                                                    newValue;
                                                              });
                                                            },
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          if (showVTCDate &&
                                              ((widget.isBuy &&
                                                      validity == 2) ||
                                                  (!widget.isBuy &&
                                                      validity == 2)))
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'VTC Date',
                                                ),
                                                SizedBox(height: 10),
                                                InkWell(
                                                  child: Container(
                                                    height: 55,
                                                    padding:
                                                        EdgeInsets.symmetric(),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              SizedBox.shrink(),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text(
                                                            vtcDateText,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(Icons
                                                                .date_range)),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    DateTime tempDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: vtcDate,
                                                      builder:
                                                          (BuildContext context,
                                                              Widget child) {
                                                        return Theme(
                                                          data:
                                                              ThemeData.light()
                                                                  .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .fromSwatch(
                                                              primarySwatch:
                                                                  Colors.red,
                                                            ),
                                                          ),
                                                          child: child,
                                                        );
                                                      },
                                                      firstDate: DateTime.now(),
                                                      lastDate: maxVtcDate,
                                                    );
                                                    if (tempDate != null) {
                                                      vtcDate = tempDate;
                                                      setState(() {
                                                        vtcDateText = DateFormat(
                                                                "dd-MMM-yyyy")
                                                            .format(vtcDate);
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink()
                      // if((widget.isBuy && (InAppSelection.buyFutureOrderDelIntra!=2 ) ||(!widget.isBuy &&InAppSelection.sellFutureOrderDelIntra!=1) ))
                    ],
                  ),
                ),
              ),
            ),
            showButton
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: Platform.isIOS
                                    ? const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 30)
                                    : const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 30),
                                child: SizedBox(
                                  width: size.width,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            widget.isBuy
                                                ? ThemeConstants.buyColor
                                                : ThemeConstants.sellColor,
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(EdgeInsets.all(20)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28.0),
                                          ))),
                                      child:
                                          // widget.isBuy
                                          //     ? Text(
                                          //         'Add To Basket',
                                          //         style: TextStyle(
                                          //             fontSize: 18, color: Colors.white),
                                          //       )
                                          //     :
                                          Text(
                                        'Add To Basket',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        try {
                                          int qty = int.tryParse(
                                                  _qtyContoller.text) ??
                                              null;
                                          if (qty == null || qty < 1) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text: 'Invalid Order Quantity');
                                            return;
                                          }
                                          List<String> val =
                                              _limitController.text.split('.');
                                          // print('this is val => $val');
                                          if (val.length > 1) {
                                            if (val[1].length == 1)
                                              _limitController.text += '0';
                                          } else {
                                            _limitController.text += '.00';
                                          }
                                          if (qty %
                                                  widget.model.minimumLotQty !=
                                              0) {
                                            CommonFunction.showBasicToast(
                                                'Please enter quantity in the lot size of ${widget.model.minimumLotQty}');
                                            return;
                                          }
                                          if ((InAppSelection
                                                          .buyFutureOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .sellFutureOrderMarketLimit ==
                                                      1) &&
                                              !CommonFunction.isValidTickSize(
                                                  _limitController.text,
                                                  widget.model)) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Kindly enter price in multiple of 0.05');
                                            return;
                                          }
                                          if (!CommonFunction.isValidTickSize(
                                              _triggerController.text,
                                              widget.model)) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Kindly enter price in multiple of 0.05');
                                            return;
                                          }

                                          List<String> val1 = _triggerController
                                              .text
                                              .split('.');
                                          // print('this is val1 => $val1');
                                          if (val1.length > 1) {
                                            if (val1[1].length == 1)
                                              _triggerController.text += '0';
                                          } else {
                                            _triggerController.text += '.00';
                                          }
                                          if ((InAppSelection
                                                      .buyFutureOrderSL ||
                                                  InAppSelection
                                                      .sellFutureOrderSL) &&
                                              !CommonFunction.isValidTickSize(
                                                  _triggerController.text,
                                                  widget.model)) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Kindly enter price in multiple of 0.05');
                                            return;
                                          }
                                          double limit = double.tryParse(
                                                  _limitController.text) ??
                                              0.0;
                                          double trigger = double.tryParse(
                                                  _triggerController.text) ??
                                              0.0;

                                          if (qty > widget.model.freezQty &&
                                              widget.model.freezQty != 0) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Max Order Qty allowed is ${widget.model.freezQty}');
                                            return;
                                          }
                                          if (qty * limit >
                                              Dataconstants
                                                  .maxDerivOrderValue) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Max Deriv Order value allowed is Rs. ${Dataconstants.maxDerivOrderValue}');
                                            return;
                                          }

                                          if ((widget.model.lowerCktLimit !=
                                                      0 ||
                                                  widget.model.upperCktLimit !=
                                                      0) &&
                                              (InAppSelection
                                                          .buyFutureOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .sellFutureOrderMarketLimit ==
                                                      1) &&
                                              !CommonFunction.rateWithin(
                                                widget.model.lowerCktLimit,
                                                widget.model.upperCktLimit,
                                                limit,
                                              )) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                context: context,
                                                color: Colors.red,
                                                text:
                                                    'Limit Rate not within reasonable limits');
                                            return;
                                          }

                                          if ((widget.model.lowerCktLimit !=
                                                      0 ||
                                                  widget.model.upperCktLimit !=
                                                      0) &&
                                              (InAppSelection
                                                      .buyFutureOrderSL ||
                                                  InAppSelection
                                                      .sellFutureOrderSL) &&
                                              !CommonFunction.rateWithin(
                                                widget.model.lowerCktLimit,
                                                widget.model.upperCktLimit,
                                                trigger,
                                              )) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text:
                                                    'Trigger Rate not within reasonable limits');
                                            return;
                                          }

                                          if ((InAppSelection
                                                          .buyFutureOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .sellFutureOrderMarketLimit ==
                                                      1) &&
                                              limit < 0.01) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text: 'Invalid Limit Price');
                                            return;
                                          }
                                          if ((InAppSelection
                                                      .buyFutureOrderSL ||
                                                  InAppSelection
                                                      .sellFutureOrderSL) &&
                                              trigger < 0.01) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text: 'Invalid Trigger Price');
                                            return;
                                          }

                                          if ((InAppSelection
                                                          .buyFutureOrderMarketLimit ==
                                                      1 ) &&
                                              (InAppSelection
                                                      .buyFutureOrderSL)) {
                                            if (trigger > limit) {
                                              CommonFunction.showSnackBarKey(
                                                  key: _scaffoldKey,
                                                  color: Colors.red,
                                                  context: context,
                                                  text:
                                                      'Trigger Price cannot be greater than Limit Price');
                                              return;
                                            }
                                          }
                                        } catch (e, s) {
                                          FirebaseCrashlytics.instance
                                              .recordError(e, s);
                                        }
                                        // if (widget.isBuy) {
                                        //   processBuy();
                                        // } else {
                                        //   processSell();
                                        // }
                                        setState(() {
                                          showButton = false;
                                        });
                                        // var result = await Dataconstants.itsClient.addContractToBasket(
                                        //     model: widget.model,
                                        //     productType: widget.isBuy
                                        //         ? InAppSelection.buyFutureOrderDelIntra == 0
                                        //             ? 'F'
                                        //             : InAppSelection.buyFutureOrderDelIntra == 1
                                        //                 ? 'P'
                                        //                 : InAppSelection.buyFutureOrderDelIntra == 2
                                        //                     ? 'U'
                                        //                     : 'F':
                                        //         InAppSelection.sellFutureOrderDelIntra == 0
                                        //         ? 'F'
                                        //         : InAppSelection.sellFutureOrderDelIntra == 1
                                        //         ? 'P'
                                        //         : 'U',
                                        //     requestType: 'H',
                                        //     strikePrice: widget.model.exchCategory == ExchCategory.nseFuture ? widget.model.strikePrice.toString() : (widget.model.strikePrice * 100).toString(),
                                        //     qty: _qtyContoller.text,
                                        //     currentRate: InAppSelection.buyFutureOrderMarketLimit == 0
                                        //         ? (widget.model.close *100).toStringAsFixed(2)
                                        //         : ((InAppSelection.buyFutureOrderDelIntra == 2) && InAppSelection.buyFutureOrderMarketLimit == 1)
                                        //             ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //             : (widget.model.close *100).toStringAsFixed(2),
                                        //     // currentRate: InAppSelection.buyFutureOrderMarketLimit == 0
                                        //     //     ? ''
                                        //     //     : widget.model.close.toString(),
                                        //     limitMarketFlag: InAppSelection.buyFutureOrderMarketLimit == 1 || InAppSelection.sellFutureOrderMarketLimit == 1 ? 'L' : 'M',
                                        //     // limitMarketFlag: InAppSelection.buyFutureOrderMarketLimit == 1 ||
                                        //     //         InAppSelection.sellFutureOrderMarketLimit ==
                                        //     //             1
                                        //     //     ? 'L'
                                        //     //     : ((widget.isBuy && InAppSelection.buyFutureOrderDelIntra == 2 || InAppSelection.buyOptionOrderDelIntra == 1) ||
                                        //     //             (!widget.isBuy && InAppSelection.sellFutureOrderDelIntra == 2 ||
                                        //     //                 InAppSelection.buyOptionOrderDelIntra == 1))
                                        //     //         ? 'S'
                                        //     //         : 'M',
                                        //     // limitMarketFlag: InAppSelection.buyFutureOrderMarketLimit == 1 ||
                                        //     //         InAppSelection.sellFutureOrderMarketLimit ==
                                        //     //             1
                                        //     //     ? 'L'
                                        //     //     : InAppSelection.buyFutureOrderSL
                                        //     //         ? 'S'
                                        //     //         : 'M',
                                        //     limitRate: widget.isBuy
                                        //         ? ((InAppSelection.buyFutureOrderDelIntra == 2) && InAppSelection.buyFutureOrderMarketLimit == 1)
                                        //             // ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //             ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //             : (InAppSelection.buyFutureOrderMarketLimit == 0 || InAppSelection.buyFutureOrderMarketLimit == 1) && (InAppSelection.buyFutureOrderDelIntra == 2 )
                                        //                 ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //                 : InAppSelection.buyFutureOrderMarketLimit == 0
                                        //                     ? ''
                                        //                     : ((InAppSelection.buyFutureOrderDelIntra == 1 || InAppSelection.buyFutureOrderDelIntra == 0) && InAppSelection.buyFutureOrderMarketLimit == 1)
                                        //                         ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //                         : (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //         : ((InAppSelection.sellFutureOrderDelIntra == 2) && InAppSelection.sellFutureOrderMarketLimit == 1)
                                        //             // ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //             ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //             : (InAppSelection.sellFutureOrderMarketLimit == 0 || InAppSelection.sellFutureOrderMarketLimit == 1) && (InAppSelection.sellFutureOrderDelIntra == 2 )
                                        //                 ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //                 : InAppSelection.sellFutureOrderMarketLimit == 0
                                        //                     ? ''
                                        //                     : ((InAppSelection.sellFutureOrderDelIntra == 1 || InAppSelection.sellFutureOrderDelIntra == 0) && InAppSelection.sellFutureOrderMarketLimit == 1)
                                        //                         ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //                         : (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2),
                                        //     // limitRate: ((InAppSelection.buyFutureOrderDelIntra == 2 || InAppSelection.buyOptionOrderDelIntra == 1) && InAppSelection.buyFutureOrderMarketLimit == 1)
                                        //     //     ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //     //     : InAppSelection.buyFutureOrderMarketLimit == 0
                                        //     //         ? ''
                                        //     //         : ((InAppSelection.buyFutureOrderDelIntra == 1 || InAppSelection.buyOptionOrderDelIntra == 0) && InAppSelection.buyFutureOrderMarketLimit == 1)
                                        //     //             ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //     //             : (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2),
                                        //     minLotQty: widget.model.minimumLotQty.toString(),
                                        //     optType: widget.model.cpType == 3
                                        //         ? 'CE'
                                        //         : widget.model.cpType == 4
                                        //             ? 'PE'
                                        //             : '*',
                                        //     orderFlow: widget.isBuy ? 'B' : 'S',
                                        //     orderType: validity == 0 ? "T" : "I",
                                        //     sltpPrice: InAppSelection.buyFutureOrderDelIntra == 2 || InAppSelection.sellFutureOrderDelIntra == 2 ? (double.tryParse(_triggerController.text)*100).toStringAsFixed(2) : "");
                                        // sltpPrice: InAppSelection.buyFutureOrderSL
                                        //     ? _triggerController.text
                                        //     : InAppSelection.buyOptionOrderDelIntra == 1
                                        //         ? _triggerController.text
                                        //         : "");

                                        if (result['Status'] == 200) {
                                          // await Dataconstants.itsClient.basketOrderForFno(
                                          //     requestType: 'F',
                                          //     exchCode: 'NFO',
                                          //     routeCrt: '333',
                                          //     symbol: Dataconstants
                                          //             .isComingFromBasketGetQuote
                                          //         ? Dataconstants
                                          //             .basketForAddingContractFromGetQuuote
                                          //         : Dataconstants.basketName,
                                          //     series: Dataconstants
                                          //             .isComingFromBasketGetQuote
                                          //         ? Dataconstants
                                          //             .seriesForAddingContractFromGetQuuote
                                          //         : Dataconstants.series);
                                          //
                                          // await Dataconstants.itsClient
                                          //     .basketOrderForFno(
                                          //         requestType: 'E',
                                          //         exchCode: 'NFO',
                                          //         routeCrt: '111',
                                          //         symbol: '',
                                          //         series: '');
                                          setState(() {
                                            showButton = true;
                                          });

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // if (Dataconstants.basketModel
                                          //         .filteredContractListOfBasket
                                          //         .length !=
                                          //     0) {
                                          //   CommonFunction.margin(Dataconstants
                                          //       .globalIncludeOpenPosition);
                                          // }
                                          if (Dataconstants
                                              .isComingFromBasketGetQuote) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllInstrumentScreen(
                                                          series: Dataconstants
                                                              .seriesForAddingContractFromGetQuuote,
                                                          basketName: Dataconstants
                                                              .basketForAddingContractFromGetQuuote,
                                                          date: Dataconstants
                                                              .dateForAddingContractFromGetQuuote,
                                                          noOfInstruments:
                                                              Dataconstants
                                                                  .noInstrForAddingContractFromGetQuuote,
                                                        )));
                                            // Navigator.of(context).pop();
                                            Dataconstants.basketModelForFno =
                                                null;
                                            Dataconstants
                                                    .isComingFromBasketGetQuote =
                                                false;
                                            // Navigator.of(context).pop();
                                          }
                                        } else {
                                          CommonFunction.showBasicToast(
                                              result["Error"]);
                                          setState(() {
                                            showButton = true;
                                          });
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: Platform.isIOS
                        ? const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 30)
                        : const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 30),
                    child:  Center(
                      child: CircularProgressIndicator(),)
                  )
          ],
        ),
      ),
    );
  }



   calculateSLValue() {
    try {
      var calcSLforCover =
          CommonFunction.getMarketRate(widget.model, widget.isBuy);
      if (widget.isBuy) {
        _triggerController.text = (calcSLforCover - calcSLforCover * 0.01)
            .round()
            .toStringAsFixed(widget.model.precision);
      } else {
        _triggerController.text = (calcSLforCover + calcSLforCover * 0.01)
            .round()
            .toStringAsFixed(widget.model.precision);
      }
      return ;
    } catch (e) {
      // print(e);
    }
  }

  Future calcCoverLimit() async {
    try {
      if (oldSLValue == _triggerController.text) return;
      finalOrderMargin = 0.00;

      oldSLValue = _triggerController.text;
      slCalculating.value = true;

      bool isBuy = widget.isBuy;
      if (widget.isBuy && InAppSelection.buyFutureOrderDelIntra == 2)
        isBuy = false;
      else if (!widget.isBuy && InAppSelection.sellFutureOrderDelIntra == 2)
        isBuy = true;
      // var result = await Dataconstants.itsClient.getFnolimitCalculation(
      //     slValue: _triggerController.text,
      //     isBuy: isBuy,
      //     isModify: false,
      //     model: widget.model);
      if (result['success'] == false) oldSLValue = '0.00';
      setState(() {
        coverLimitPrice = result['value'] ?? '0.00';
      });

      slCalculating.value = false;
      return;
    } catch (e) {
      // print(e);
    }
  }

  void showAllocateFunds({double amount}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          // return AllocateFunds(
          //   segment: 1,
          //   amount: amount != null ? amount : null,
          // );
        });
    setState(() {});
  }

  double calculateRequiredMargin(ScripInfoModel model) {
    try {
      double result;
      int qty = int.tryParse(_qtyContoller.text);
      double limit = ((widget.isBuy &&
                  InAppSelection.buyFutureOrderMarketLimit == 1) ||
              (!widget.isBuy && InAppSelection.sellFutureOrderMarketLimit == 1))
          ? double.tryParse(_limitController.text)
          : model.close;
      if (qty == null || limit == null)
        return 0.00;
      else {
        result = qty * limit;
        return result;
      }
    } catch (e) {
      // print(e);
      return 0.00;
    }
  }

  //
  ////

  @override
  void dispose() {
    _qtyContoller.dispose();
    _limitController.dispose();
    _triggerController.dispose();
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.model.exch, widget.model.exchCode, false);
    Dataconstants.iqsClient
        .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    super.dispose();
  }
}
