import 'dart:io';
import 'dart:math';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/exchData.dart';
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

class BasketOptionOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  bool isBuy;
  final ReportCalledFrom reportCalledFrom;
  final bool isResearch;

  BasketOptionOrderScreen({
    @required this.model,
    @required this.isBuy,
    @required this.reportCalledFrom,
    this.isResearch,
    String comingFrom,
  });

  @override
  _BasketOptionOrderScreenState createState() =>
      _BasketOptionOrderScreenState();
}

class _BasketOptionOrderScreenState extends State<BasketOptionOrderScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _qtyContoller, _limitController, _triggerController;
  double finalOrderMargin = 0.00;
  bool isComingForFirstTime = true;
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
    InAppSelection.buyOptionOrderMarketLimit=0;
    InAppSelection.sellOptionOrderMarketLimit=0;
    InAppSelection.buyOptionOrderSL=false;
    InAppSelection.sellOptionOrderSL=false;
    widget.isBuy = InAppSelection.buySellBasketorder == 0 ? true : false;
    super.initState();
    isLight = ThemeConstants.themeMode.value == ThemeMode.light;
    Dataconstants.iqsClient.sendScripDetailsRequest(
        widget.model.exch, widget.model.exchCode, true);
    _qtyContoller.text = widget.model.minimumLotQty.toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (InAppSelection.buyOptionOrderDelIntra == 1 ||
      //     InAppSelection.sellOptionOrderDelIntra == 1) calcCoverLimit();
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
    if (InAppSelection.buyOptionOrderDelIntra == 1 ||
        InAppSelection.sellOptionOrderDelIntra == 1) {
      await calculateSLValue();
      await Future.delayed(Duration(milliseconds: 500));
      await calcCoverLimit();
    }
    _limitController.text = await getMarketRate(widget.model, widget.isBuy);
    print("limit => ${_limitController.text}");
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
          title: FittedBox(
            child: Text(
              widget.model.exchCategory == ExchCategory.nseEquity ||
                      widget.model.exchCategory == ExchCategory.bseEquity
                  ? widget.model.desc
                  : widget.model.marketWatchName,
              style: TextStyle(color: Colors.white),
            ),
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Order Value (Est.)',
                      //           style: TextStyle(color: Colors.grey),
                      //         ),
                      //         SizedBox(height: 5),
                      //         ((widget.isBuy &&
                      //                     InAppSelection
                      //                             .buyOptionOrderMarketLimit ==
                      //                         1) ||
                      //                 (!widget.isBuy &&
                      //                     InAppSelection
                      //                             .sellOptionOrderMarketLimit ==
                      //                         1))
                      //             ? DecimalText(
                      //                 CommonFunction.currencyFormat(
                      //                   calculateRequiredMargin(widget.model),
                      //                 ),
                      //                 style: TextStyle(
                      //                   color: theme.primaryColor,
                      //                   fontSize: 18,
                      //                 ),
                      //               )
                      //             : Observer(
                      //                 builder: (context) => DecimalText(
                      //                   CommonFunction.currencyFormat(
                      //                       calculateRequiredMargin(
                      //                           widget.model)),
                      //                   style: TextStyle(
                      //                     color: theme.primaryColor,
                      //                     fontSize: 18,
                      //                   ),
                      //                 ),
                      //               ),
                      //       ],
                      //     ),
                      //     GestureDetector(
                      //       onTap: () => showAllocateFunds(),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.end,
                      //         children: [
                      //           Text(
                      //             'Available Limit',
                      //             style: TextStyle(color: Colors.grey),
                      //           ),
                      //           SizedBox(height: 5),
                      //           Observer(
                      //             builder: (context) => DecimalText(
                      //               CommonFunction.currencyFormat(Dataconstants
                      //                   .fnoLimit.value.availableLimit),
                      //               style: TextStyle(
                      //                 fontSize: 18,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 10),
                      Row(
                        children: [
                          Text('PRODUCT'),
                          SizedBox(width: 5),
                          // InkWell(
                          //   child: Icon(
                          //     Icons.info_outline,
                          //     color: Colors.grey,
                          //     size: 20,
                          //   ),
                          //   borderRadius: BorderRadius.all(Radius.circular(24)),
                          //   onTap: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (context) => AlertDialog(
                          //         title: Text('Product Information'),
                          //         content: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Text('NORMAL - Options'),
                          //             SizedBox(height: 10),
                          //             Text('COVER - Cover Order (Option Plus)'),
                          //             SizedBox(height: 10),
                          //           ],
                          //         ),
                          //         actions: [
                          //           TextButton(
                          //             child: Text(
                          //               'Close',
                          //               style: TextStyle(
                          //                 color: theme.primaryColor,
                          //               ),
                          //             ),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // )
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
                                          message: widget.model.exchCategory == ExchCategory.nseEquity ? "DELIVERY" :'Normal',
                                          child: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                widget.model.series=="EQ"?"DELIVERY" :'NORMAL',
                                                style: TextStyle(
                                                  color: InAppSelection.buyOptionOrderDelIntra == 0
                                                      ? theme.primaryColor
                                                      : theme.textTheme
                                                          .bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        1: Tooltip(
                                          message:"INTRADAY",
                                          child: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                               "INTRADAY",
                                                style: TextStyle(
                                                  color: InAppSelection.buyOptionOrderDelIntra == 1
                                                      ? theme.primaryColor
                                                      : theme.textTheme
                                                          .bodyText1.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      },
                                      groupValue:
                                      InAppSelection.buyOptionOrderDelIntra,
                                      onValueChanged: (newValue) async {
                                        if (newValue ==
                                            InAppSelection.buyOptionOrderDelIntra) return;
                                        setState(() {
                                          InAppSelection
                                                  .buyOptionOrderDelIntra =
                                              newValue;
                                        });

                                        if (newValue == 1) {
                                          await calculateSLValue();
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          await calcCoverLimit();
                                        }
                                        setState(() {});
                                      },
                                    )
                                  : CupertinoSlidingSegmentedControl(
                                      thumbColor: theme.accentColor,
                                      children: {
                                        0: Tooltip(
                                          message: widget.model.series=="EQ"?"DELIVERY" :'Normal',
                                          child: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                widget.model.series=="EQ"?"DELIVERY" : 'NORMAL',
                                                style: TextStyle(
                                                  color: InAppSelection
                                                              .sellOptionOrderDelIntra ==
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

                                          message:"INTRADAY" ,
                                          // message:widget.model.series=="EQ"?"INTRADAY" : 'Option Plus',

                                          child: Container(
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                "INTRADAY" ,
                                                style: TextStyle(
                                                  color: InAppSelection.sellOptionOrderDelIntra == 1
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
                                          .sellOptionOrderDelIntra,
                                      onValueChanged: (newValue) async {
                                        if (newValue ==
                                            InAppSelection
                                                .sellOptionOrderDelIntra)
                                          return;

                                        setState(() {
                                          InAppSelection
                                                  .sellOptionOrderDelIntra =
                                              newValue;
                                        });
                                        if (newValue == 1) {
                                          await calculateSLValue();
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          await calcCoverLimit();
                                        }
                                        setState(() {});
                                      },
                                    ),
                            ),
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
                                          if (InAppSelection
                                                      .sellOptionOrderDelIntra ==
                                                  1 ||
                                              InAppSelection
                                                      .buyOptionOrderDelIntra ==
                                                  1) {
                                            await calculateSLValue();
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
                                            await calcCoverLimit();
                                            setState(() {});
                                          }
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
                                          if (InAppSelection
                                                      .sellOptionOrderDelIntra ==
                                                  1 ||
                                              InAppSelection
                                                      .buyOptionOrderDelIntra ==
                                                  1) {
                                            await calculateSLValue();
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
                                            await calcCoverLimit();
                                            setState(() {});
                                          }
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
                          if(widget.model.series!="EQ")
                          Text(
                            'Lot: ${widget.model.minimumLotQty}',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      NumberField(
                        defaultValue:  widget.model.minimumLotQty,
                        maxLength: 6,
                        numberController: _qtyContoller,
                        increment: widget.model.minimumLotQty,
                        hint: 'Quantity',
                        isInteger: true,
                        isBuy: widget.isBuy,
                        isRupeeLogo: false,
                        isDisable: false,
                      ),
                      // NumberField(
                      //   isBuy: true,
                      //   defaultValue: widget.model.minimumLotQty,
                      //   maxLength: 10,
                      //   numberController: _qtyContoller,
                      //   increment: widget.model.minimumLotQty,
                      //   hint: 'Quantity',
                      //   isInteger: true,
                      // ),
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
                                            color: InAppSelection.buyOptionOrderMarketLimit == 0
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
                                          'LIMIT',
                                          style: TextStyle(
                                            color: InAppSelection.buyOptionOrderMarketLimit == 1
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  groupValue:
                                      InAppSelection.buyOptionOrderMarketLimit,
                                  onValueChanged: (newValue) async {
                                    if (newValue == 1) {
                                      await calculateSLValue();
                                      await Future.delayed(
                                          Duration(milliseconds: 500));
                                      await calcCoverLimit();
                                    }
                                    setState(() {

                                      InAppSelection.buyOptionOrderMarketLimit =
                                          newValue;

                                      if (newValue == 0)
                                        InAppSelection.buyOptionOrderSL = false;
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
                                            color: InAppSelection.sellOptionOrderMarketLimit == 0
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
                                                        .sellOptionOrderMarketLimit ==
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
                                      InAppSelection.sellOptionOrderMarketLimit,
                                  onValueChanged: (newValue) async {
                                    if (newValue == 1) {
                                      await calculateSLValue();
                                      await Future.delayed(
                                          Duration(milliseconds: 500));
                                      await calcCoverLimit();
                                    }
                                    setState(() {
                                      InAppSelection
                                              .sellOptionOrderMarketLimit =
                                          newValue;
                                      if (newValue == 0)
                                        InAppSelection.sellOptionOrderSL =
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
                        child: (widget.isBuy && InAppSelection.buyOptionOrderMarketLimit == 1) ||
                                (!widget.isBuy && InAppSelection.sellOptionOrderMarketLimit == 1)
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
                                  NumberField(
                                    doubleDefaultValue: widget.model.close,
                                    doubleIncrement: widget.model.incrementTicksize(),
                                    numberController: _limitController,
                                    hint: 'Limit',
                                    maxLength: 10,
                                    decimalPosition: 2,
                                    isBuy: widget.isBuy,
                                    isRupeeLogo: true,
                                    isDisable:  false,
                                  )
                                  // NumberField(
                                  //   doubleDefaultValue: widget.model.close,
                                  //   doubleIncrement:
                                  //       widget.model.incrementTicksize(),
                                  //   maxLength: 10,decimalPosition: 2,
                                  //   numberController: _limitController,
                                  //   hint: 'Limit',
                                  // ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(height: 10),
                      Builder(builder: (context) {
                        // if ((widget.isBuy &&
                        //         InAppSelection.buyOptionOrderDelIntra == 1) ||
                        //     (!widget.isBuy &&
                        //         InAppSelection.sellOptionOrderDelIntra == 1)) {
                        //   return Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Divider(thickness: 1),
                        //       // SizedBox(height: 5),
                        //       // Align(
                        //       //   alignment: Alignment.centerLeft,
                        //       //   child: Row(
                        //       //     children: [
                        //       //       Text(
                        //       //         widget.isBuy
                        //       //             ? 'SELL COVER ORDER'
                        //       //             : 'BUY COVER ORDER',
                        //       //         style: TextStyle(
                        //       //             fontWeight: FontWeight.w600,
                        //       //             fontSize: 16,
                        //       //             color: widget.isBuy
                        //       //                 ? ThemeConstants.sellColor
                        //       //                 : ThemeConstants.buyColor),
                        //       //       ),
                        //       //       SizedBox(width: 10),
                        //       //       GestureDetector(
                        //       //         behavior: HitTestBehavior.opaque,
                        //       //         child: Icon(
                        //       //           Icons.info_outline,
                        //       //           size: 20,
                        //       //           color: Colors.grey,
                        //       //         ),
                        //       //         onTap: () {
                        //       //           CommonFunction.showAlert(
                        //       //               context,
                        //       //               'Cover Order',
                        //       //               'Stop Loss should be ${widget.isBuy ? 'lower' : 'higer'} than Limit Price of Fresh Order and Last Traded Price',
                        //       //               'Close');
                        //       //         },
                        //       //       ),
                        //       //     ],
                        //       //   ),
                        //       // ),
                        //       SizedBox(height: 15),
                        //       Text('STOP LOSS'),
                        //       SizedBox(height: 10),
                        //       TriggerNumberField(
                        //         triggerFunction: () {
                        //           setState(() {
                        //             isComingForFirstTime = false;
                        //           });
                        //           calcCoverLimit();
                        //         },
                        //         doubleDefaultValue: widget.model.close,
                        //         doubleIncrement:
                        //             widget.model.incrementTicksize(),
                        //         maxLength: 10,
                        //         numberController: _triggerController,
                        //         hint: 'Trigger',
                        //       ),
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       Text('LIMIT'),
                        //       SizedBox(
                        //         height: 5,
                        //       ),
                        //       Row(
                        //         children: [
                        //           DecimalText(
                        //             coverLimitPrice,
                        //             style: TextStyle(
                        //               color: theme.primaryColor,
                        //               fontSize: 22,
                        //               fontWeight: FontWeight.w700,
                        //             ),
                        //           ),
                        //           ValueListenableBuilder<bool>(
                        //             valueListenable: slCalculating,
                        //             builder: (context, value, child) =>
                        //                 IconButton(
                        //               icon: value
                        //                   ? SizedBox(
                        //                       height: 15,
                        //                       width: 15,
                        //                       child:  Center(
                        //                         child: Container(
                        //                           height: 120,
                        //                           width: 120,
                        //                           decoration: BoxDecoration(
                        //                             color: theme.appBarTheme.color,
                        //                             borderRadius: BorderRadius.all(Radius.circular(20)),
                        //                           ),
                        //                           child: Image.asset(
                        //                             ThemeConstants.themeMode.value == ThemeMode.light ?
                        //                             // 'assets/images/logo/Bigul_Loader-Animation_Loop.gif'
                        //                             'assets/images/logo/Bigul-Logo_Loader-Animation_Blue.gif'
                        //                                 : 'assets/images/logo/Bigul-Logo_Loader-Animation_White.gif',
                        //
                        //                           ),
                        //                         ),)
                        //                     )
                        //                   : Icon(Icons.refresh),
                        //               onPressed: () {
                        //                 calcCoverLimit();
                        //                 setState(() {});
                        //               },
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   );
                        // }
                        // else

                        {
                          return Column(
                            children: [
                              // if ((widget.isBuy && InAppSelection.buyOptionOrderMarketLimit == 1) ||
                              //     (!widget.isBuy && InAppSelection.sellOptionOrderMarketLimit == 1))
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('STOP LOSS'),
                                    CupertinoSwitch(
                                      trackColor: Colors.grey,
                                      // thumbColor: Colors.amber,
                                      activeColor:
                                      widget.isBuy
                                          ? ThemeConstants.buyColor
                                          : ThemeConstants.sellColor,
                                      value: widget.isBuy
                                          ? InAppSelection.buyOptionOrderSL
                                          : InAppSelection.sellOptionOrderSL,
                                      onChanged: (val) {
                                        setState(() {
                                          if (widget.isBuy) {
                                            InAppSelection.buyOptionOrderSL =
                                                val;
                                            if (val) {
                                              validity = 0;
                                              _isValidityEnabled = false;
                                            } else
                                              _isValidityEnabled = true;
                                          } else {
                                            InAppSelection.sellOptionOrderSL =
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
                                      InAppSelection.buyOptionOrderDelIntra !=
                                          1) ||
                                  (!widget.isBuy &&
                                      InAppSelection.sellOptionOrderDelIntra !=
                                          1))
                                SizedBox(
                                    height: InAppSelection.buyOptionOrderSL
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
                                            InAppSelection.buyOptionOrderSL) ||
                                        (!widget.isBuy &&
                                            InAppSelection.sellOptionOrderSL)
                                    ?
                                NumberField(
                                  doubleDefaultValue: widget.model.close,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _triggerController,
                                  hint: 'Trigger',
                                  maxLength: 10,
                                  decimalPosition: 2,
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: true,
                                  isDisable:false,
                                )
                                // NumberField(
                                //         doubleDefaultValue: widget.model.close,
                                //         doubleIncrement: widget.model.incrementTicksize(),
                                //         maxLength: 10,
                                //         numberController: _triggerController,
                                //         hint: 'Trigger',
                                //       )
                                    : SizedBox.shrink(),
                              ),
                              SizedBox(height: 10),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: InkWell(
                              //     onTap: () {
                              //       Future<Map<String, double>> fut =
                              //           Dataconstants
                              //               .itsClient
                              //               .fnoMarginCalculator(
                              //                   model: widget.model,
                              //                   qty: int.parse(
                              //                       _qtyContoller.text),
                              //                   isBuy: widget.isBuy);
                              //       showModalBottomSheet(
                              //         isScrollControlled: true,
                              //         context: (context),
                              //         builder: (context) {
                              //           return DraggableScrollableSheet(
                              //             expand: false,
                              //             minChildSize: 0.3,
                              //             initialChildSize: 0.3,
                              //             maxChildSize: 0.75,
                              //             builder: (context, scrollController) {
                              //               return FutureBuilder(
                              //                   future: fut,
                              //                   builder: (context,
                              //                       AsyncSnapshot<
                              //                               Map<String, double>>
                              //                           snapshot) {
                              //                     if (snapshot.hasData)
                              //                       return Container(
                              //                         padding:
                              //                             EdgeInsets.all(10),
                              //                         child:
                              //                             SingleChildScrollView(
                              //                           controller:
                              //                               scrollController,
                              //                           child: Column(
                              //                             mainAxisSize:
                              //                                 MainAxisSize.min,
                              //                             children: [
                              //                               Center(
                              //                                 child:
                              //                                     FractionallySizedBox(
                              //                                   child:
                              //                                       Container(
                              //                                     margin: EdgeInsets
                              //                                         .symmetric(
                              //                                             vertical:
                              //                                                 7),
                              //                                     height: 5,
                              //                                     decoration: BoxDecoration(
                              //                                         color: Colors
                              //                                                 .grey[
                              //                                             700],
                              //                                         borderRadius:
                              //                                             BorderRadius.circular(
                              //                                                 5)),
                              //                                   ),
                              //                                   widthFactor:
                              //                                       0.25,
                              //                                 ),
                              //                               ),
                              //                               SizedBox(
                              //                                   height: 10),
                              //                               Align(
                              //                                 alignment: Alignment
                              //                                     .centerLeft,
                              //                                 child: Text(
                              //                                   'Margin',
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           20,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                               ),
                              //                               SizedBox(
                              //                                   height: 20),
                              //                               Row(
                              //                                 mainAxisAlignment:
                              //                                     MainAxisAlignment
                              //                                         .spaceBetween,
                              //                                 children: [
                              //                                   const Text(
                              //                                     'Order Margin',
                              //                                     style:
                              //                                         const TextStyle(
                              //                                       color: Colors
                              //                                           .grey,
                              //                                       fontSize:
                              //                                           15,
                              //                                     ),
                              //                                   ),
                              //                                   Text(
                              //                                     CommonFunction
                              //                                         .currencyFormat(
                              //                                             snapshot
                              //                                                 .data['OrderMargin']),
                              //                                     style:
                              //                                         TextStyle(
                              //                                       fontSize:
                              //                                           16,
                              //                                     ),
                              //                                   ),
                              //                                 ],
                              //                               ),
                              //                               SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                             ],
                              //                           ),
                              //                         ),
                              //                       );
                              //                     else
                              //                       return Center(
                              //                         child:
                              //                             CircularProgressIndicator(
                              //                           valueColor:
                              //                               AlwaysStoppedAnimation<
                              //                                       Color>(
                              //                                   theme
                              //                                       .primaryColor),
                              //                         ),
                              //                       );
                              //                   });
                              //             },
                              //           );
                              //         },
                              //       );
                              //     },
                              //     child: Visibility(
                              //       visible: !widget.isBuy,
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(
                              //             top: 8.0, bottom: 8.0, right: 8.0),
                              //         child: Text(
                              //           'View Margin33',
                              //           style: TextStyle(
                              //               color: Colors.blueAccent,
                              //               fontSize: 17),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                                                              style: TextStyle(
                                                                color: InAppSelection
                                                                        .buyOptionOrderSL
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
                                                              style: TextStyle(
                                                                decoration: InAppSelection
                                                                        .buyOptionOrderSL
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null,
                                                                decorationThickness:
                                                                    InAppSelection
                                                                            .buyOptionOrderSL
                                                                        ? 1
                                                                        : 0,
                                                                color: InAppSelection
                                                                        .buyOptionOrderSL
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
                                                              style: TextStyle(
                                                                color: InAppSelection
                                                                        .sellOptionOrderSL
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
                                                              style: TextStyle(
                                                                decoration: InAppSelection
                                                                        .sellOptionOrderSL
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null,
                                                                decorationThickness:
                                                                    InAppSelection
                                                                            .sellOptionOrderSL
                                                                        ? 1
                                                                        : 0,
                                                                color: InAppSelection
                                                                        .sellOptionOrderSL
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
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      })
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
                                          if (qty %
                                                  widget.model.minimumLotQty !=
                                              0) {
                                            CommonFunction.showBasicToast(
                                                'Please enter quantity in the lot size of ${widget.model.minimumLotQty}');
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
                                          if ((InAppSelection
                                                          .sellOptionOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .buyOptionOrderMarketLimit ==
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
                                                      .sellOptionOrderSL ||
                                                  InAppSelection
                                                      .buyOptionOrderSL) &&
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

                                          double limit = double.tryParse(
                                                  _limitController.text) ??
                                              0.0;
                                          double trigger = double.tryParse(
                                                  _triggerController.text) ??
                                              0.0;

                                          if (qty <
                                              widget.model.minimumLotQty) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text: 'Invalid Order Quantity');
                                            return;
                                          }
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
                                                          .sellOptionOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .buyOptionOrderMarketLimit ==
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

                                          if ((InAppSelection
                                                      .sellOptionOrderSL ||
                                                  InAppSelection
                                                      .buyOptionOrderSL) &&
                                              (widget.model.lowerCktLimit !=
                                                      0 ||
                                                  widget.model.upperCktLimit !=
                                                      0) &&
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
                                                          .sellOptionOrderMarketLimit ==
                                                      1 ||
                                                  InAppSelection
                                                          .buyOptionOrderMarketLimit ==
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
                                                      .sellOptionOrderSL ||
                                                  InAppSelection
                                                      .buyOptionOrderSL) &&
                                              trigger < 0.01) {
                                            CommonFunction.showSnackBarKey(
                                                key: _scaffoldKey,
                                                color: Colors.red,
                                                context: context,
                                                text: 'Invalid Trigger Price');
                                            return;
                                          }

                                          if ((InAppSelection.sellOptionOrderMarketLimit == 1 || InAppSelection.buyOptionOrderMarketLimit == 1) &&
                                              (InAppSelection.sellOptionOrderSL || InAppSelection.buyOptionOrderSL)) {
                                            if (trigger < limit) {
                                              CommonFunction.showSnackBarKey(
                                                  key: _scaffoldKey,
                                                  color: Colors.red,
                                                  context: context,
                                                  text:
                                                      'Limit Price cannot be greater than Trigger Price');
                                              return;
                                            }
                                          }
                                        } catch (e, s) {
                                          FirebaseCrashlytics.instance
                                              .recordError(e, s);
                                        }
                                        setState(() {
                                          showButton = false;
                                        });
                                        // var result = await Dataconstants.itsClient.addContractToBasket(
                                        //         model: widget.model,
                                        //         productType: widget.isBuy
                                        //             ? InAppSelection.buyOptionOrderDelIntra ==
                                        //                     0
                                        //                 ? 'O'
                                        //                 : 'I'
                                        //             : InAppSelection.sellOptionOrderDelIntra ==
                                        //                     0
                                        //                 ? 'O'
                                        //                 : 'I',
                                        //         requestType: 'H',
                                        //         strikePrice: widget.model.exchCategory ==
                                        //                 ExchCategory.nseFuture
                                        //             ? widget.model.strikePrice
                                        //                 .toString()
                                        //             : (widget.model.strikePrice * 100)
                                        //                 .toString(),
                                        //         qty: _qtyContoller.text,
                                        //         currentRate: widget.isBuy
                                        //             ? InAppSelection.buyOptionOrderMarketLimit ==
                                        //                     0
                                        //                 ? (widget.model.close * 100)
                                        //                     .toStringAsFixed(2)
                                        //                 : (double.tryParse(_limitController.text) * 100)
                                        //                     .toStringAsFixed(2)
                                        //             : InAppSelection.sellOptionOrderMarketLimit ==
                                        //                     0
                                        //                 ? (widget.model.close * 100)
                                        //                     .toStringAsFixed(2)
                                        //                 : (double.tryParse(_limitController.text) * 100)
                                        //                     .toStringAsFixed(2),
                                        //         // currentRate: InAppSelection
                                        //         //             .buyOptionOrderMarketLimit ==
                                        //         //         0
                                        //         //     ? (widget.model.close*100)
                                        //         //         .toStringAsFixed(2)
                                        //         //     : ((InAppSelection.buyOptionOrderDelIntra == 1) &&
                                        //         //             InAppSelection.buyOptionOrderMarketLimit ==
                                        //         //                 1)
                                        //         //         ? (double.tryParse(_limitController.text) * 100)
                                        //         //             .toStringAsFixed(2)
                                        //         //         : (widget.model.close*100)
                                        //         //             .toString(),
                                        //         // currentRate: InAppSelection.buyOptionOrderMarketLimit == 0
                                        //         //     ? ''
                                        //         //     : widget.model.close.toString(),
                                        //         limitMarketFlag:
                                        //             InAppSelection.buyOptionOrderMarketLimit == 1 ||
                                        //                     InAppSelection.sellOptionOrderMarketLimit == 1
                                        //                 ? 'L'
                                        //                 : 'M',
                                        //         // limitMarketFlag: InAppSelection.buyOptionOrderMarketLimit == 1 ||
                                        //         //         InAppSelection.sellOptionOrderMarketLimit == 1
                                        //         //     ? 'L'
                                        //         //     : (InAppSelection.buyOptionOrderDelIntra == 1)
                                        //         //         ? 'S'
                                        //         //         : 'M',
                                        //         // // limitMarketFlag: InAppSelection.buyFutureOrderMarketLimit == 1 ||
                                        //         //         InAppSelection.sellFutureOrderMarketLimit ==
                                        //         //             1
                                        //         //     ? 'L'
                                        //         //     : InAppSelection.buyOptionOrderSL
                                        //         //         ? 'S'
                                        //         //         : 'M',
                                        //         limitRate: widget.isBuy
                                        //             ? (InAppSelection.buyOptionOrderDelIntra == 1)
                                        //                 ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //                 : (InAppSelection.buyOptionOrderDelIntra == 0 && InAppSelection.buyOptionOrderMarketLimit == 1)
                                        //                     ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //                     : (widget.model.close * 100).toStringAsFixed(2)
                                        //             : (InAppSelection.sellOptionOrderDelIntra == 1)
                                        //                 ? (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //                 : (InAppSelection.sellOptionOrderDelIntra == 0 && InAppSelection.sellOptionOrderMarketLimit == 1)
                                        //                     ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //                     : (widget.model.close * 100).toStringAsFixed(2),
                                        //         // limitRate: widget.isBuy
                                        //         //     ? (InAppSelection.buyOptionOrderDelIntra == 1)
                                        //         //         ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //         //         : InAppSelection.buyOptionOrderMarketLimit == 0
                                        //         //             ? ''
                                        //         //             : (InAppSelection.buyOptionOrderDelIntra == 0 && InAppSelection.buyOptionOrderMarketLimit == 1)
                                        //         //                 ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //         //                 : (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2)
                                        //         //     : (InAppSelection.sellOptionOrderDelIntra == 1)
                                        //         //         ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //         //         : InAppSelection.sellOptionOrderMarketLimit == 0
                                        //         //             ? ''
                                        //         //             : (InAppSelection.sellOptionOrderDelIntra == 0 && InAppSelection.sellOptionOrderMarketLimit == 1)
                                        //         //                 ? (double.tryParse(_limitController.text) * 100).toStringAsFixed(2)
                                        //         //                 : (double.tryParse(coverLimitPrice) * 100).toStringAsFixed(2), // 5.11.22
                                        //         minLotQty: widget.model.minimumLotQty.toString(),
                                        //         optType: widget.model.cpType == 3
                                        //             ? 'CE'
                                        //             : widget.model.cpType == 4
                                        //                 ? 'PE'
                                        //                 : '*',
                                        //         orderFlow: widget.isBuy ? 'B' : 'S',
                                        //         orderType: validity == 0 ? "T" : "I",
                                        //         sltpPrice: InAppSelection.buyOptionOrderDelIntra == 1 || InAppSelection.sellOptionOrderDelIntra == 1 ? (double.tryParse(_triggerController.text) * 100).toStringAsFixed(2) : ""
                                        //         // sltpPrice: InAppSelection.buyOptionOrderSL
                                        //         //     ? _triggerController.text
                                        //         //     : InAppSelection.buyOptionOrderDelIntra == 1
                                        //         //         ? _triggerController.text
                                        //         //         : ""
                                        //         );

                                        var result = await Dataconstants.itsClient.addScripInBasket(
                                            variety:Dataconstants.exchData[0].exchangeStatus ==
                                                ExchangeStatus.nesClosed
                                                ? "AMO"
                                                : "NORMAL",
                                            tradingsymbol:widget.model.tradingSymbol,
                                            symboltoken:widget.model.exchCode,
                                            transactiontype:InAppSelection.buySellBasketorder==0? "BUY":"SELL",
                                            exchange:widget.model.exchCategory == ExchCategory.nseOptions|| widget.model.exchCategory == ExchCategory.nseFuture? "NFO":widget.model.exch,

                                            ordertype:

                                            widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 0&&InAppSelection.buyOptionOrderSL ? "STOPLOSS_MARKET" :
                                            !widget.isBuy&&InAppSelection.sellOptionOrderMarketLimit == 0&&InAppSelection.sellOptionOrderSL?"STOPLOSS_MARKET":
                                            widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 1&&InAppSelection.buyOptionOrderSL ? "STOPLOSS_LIMIT":
                                            !widget.isBuy&&InAppSelection.sellOptionOrderMarketLimit == 1&&InAppSelection.sellOptionOrderSL?"STOPLOSS_LIMIT":
                                            widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 0?"MARKET":
                                            !widget.isBuy&&InAppSelection.sellOptionOrderMarketLimit == 0?"MARKET":"LIMIT",

                                            // widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 1?"LIMIT":"LIMIT",


                                            // widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 0 ? "MARKET" :
                                            // (widget.isBuy&&InAppSelection.buyOptionOrderMarketLimit == 1&& InAppSelection.buyOptionOrderSL)? "STOPLOSS_LIMIT" :
                                            // !widget.isBuy&&InAppSelection.sellOptionOrderMarketLimit == 0?"MARKET":
                                            // !widget.isBuy&&InAppSelection.sellOptionOrderMarketLimit == 1&&InAppSelection.sellOptionOrderSL?"STOPLOSS_MARKET": "LIMIT",


                                            // InAppSelection.buyOptionOrderMarketLimit == 0?"MARKET":
                                            // (widget.isBuy && InAppSelection.buyOptionOrderSL) || (!widget.isBuy && InAppSelection.sellOptionOrderSL)
                                            //     ?"STOPLOSS_LIMIT":(widget.isBuy && !InAppSelection.buyOptionOrderSL) || (!widget.isBuy && !InAppSelection.sellOptionOrderSL)
                                            //     ?"STOPLOSS_MARKET": "LIMIT",

                                            producttype:InAppSelection.buyOptionOrderDelIntra==0&&widget.model.series=="EQ"?
                                            "DELIVERY": InAppSelection.buyOptionOrderDelIntra==0&&widget.model.series!="EQ"?
                                            "NORMAL":"INTRADAY",
                                            // InAppSelection.buyOptionOrderDelIntra==1&&widget.model.series=="EQ"?
                                            // "DELIVERY":
                                            // "COVER",
                                            duration: validity == 0 ? 'DAY' :validity == 1 ? 'IOC' : 'VTC',
                                            price:InAppSelection.buyOptionOrderMarketLimit == 0?"0":_limitController.text,
                                            quantity:_qtyContoller.text,
                                            triggerprice:(widget.isBuy && InAppSelection.buyOptionOrderSL) ||
                                                (!widget.isBuy && InAppSelection.sellOptionOrderSL)
                                                ?_triggerController.text:"0",
                                          scripDescription:widget.model.marketWatchName
                                        );

                                        if (result['status'] == true) {
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
                                              .isFromScripDetail) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllInstrumentScreen(
                                                          series: Dataconstants.modelFromScripDetail.exch,
                                                          basketName: Dataconstants.newBasketName,
                                                          date: Dataconstants.newDate,
                                                          noOfInstruments:"1",
                                                        )));
                                            // Navigator.of(context).pop();
                                            Dataconstants.isFromScripDetail = false;
                                           await Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId:Dataconstants.basketID);
                                            Dataconstants.basketModelForFno =
                                                null;

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
      var finaltrigger;
      var calcSLforCover =
          CommonFunction.getMarketRate(widget.model, widget.isBuy);
      if (widget.isBuy) {
        var result = (calcSLforCover -
                calcSLforCover * (isComingForFirstTime ? 0.02 : 0.01))
            .toStringAsFixed(widget.model.precision);
        List<String> x = result.split(".");
        var y = int.parse(x[1]) % 10;
        if (y > 5) {
          finaltrigger = double.parse(result).ceil();
        } else {
          finaltrigger = double.parse(result).floor();
        }
        print("resiltfdf -> $finaltrigger");
        _triggerController.text = finaltrigger;
      } else {
        var result = (calcSLforCover +
                calcSLforCover * (isComingForFirstTime ? 0.02 : 0.01))
            .toStringAsFixed(widget.model.precision);
        List<String> x = result.split(".");
        var y = int.parse(x[1]) % 10;
        if (y > 5) {
          finaltrigger = double.parse(result).ceil();
        } else {
          finaltrigger = double.parse(result).floor();
        }
        print("resiltfdf -> $finaltrigger");
        _triggerController.text = finaltrigger;
      }
      return;
    } catch (e) {
      // print(e);
    }
  }

  // void calculateSLValue() {
  //   try {
  //     var calcSLforCover =
  //         CommonFunction.getMarketRate(widget.model, widget.isBuy);
  //     if (widget.isBuy) {
  //       _triggerController.text = (calcSLforCover - calcSLforCover * 0.01)
  //           .round()
  //           .toStringAsFixed(widget.model.precision);
  //     } else {
  //       _triggerController.text = (calcSLforCover + calcSLforCover * 0.01)
  //           .round()
  //           .toStringAsFixed(widget.model.precision);
  //     }
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  Future calcCoverLimit() async {
    try {
      // if (oldSLValue == _triggerController.text) return;
      finalOrderMargin = 0.00;

      oldSLValue = _triggerController.text;
      slCalculating.value = true;

      bool isBuy = widget.isBuy;
      if (widget.isBuy && InAppSelection.buyOptionOrderDelIntra == 1)
        isBuy = false;
      else if (!widget.isBuy && InAppSelection.sellOptionOrderDelIntra == 1)
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
