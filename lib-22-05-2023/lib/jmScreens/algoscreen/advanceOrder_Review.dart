import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/AlgoModels/ApiResponse.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../widget/slider_button.dart';
import 'bigulAlgorithem.dart';
import 'order_placed_animation_screen_bigul.dart';

class AdvanceOrderReviewScreen extends StatefulWidget {
  final String stock;
  final String algoName;
  final String orderType;
  final String exchange;
  final String productType;
  final String totalQuantity;
  final String slicingQuantity;
  final String startTime;
  final int startTimeConverted;
  final String endTime;
  final int endTimeConverted;
  final String timeInterval;
  final int timeIntervalConverted;
  final int algoId;
  final ScripInfoModel model;
  final OrderType type;
  final String priceRangeLow;
  final String priceRangeHigh;
  String AvgDirection;
  String AvgLimitPrice;
  String AvgEntryDiff;
  String AvgExitDiff;
  String limitPrice;
  String historicalSize;
  List<dynamic> dynamicValue;
  List<dynamic> dynamicValue2;
  bool atMarket;

  AdvanceOrderReviewScreen(
      {Key key,
      @required this.stock,
      this.algoName,
      this.orderType,
      this.exchange,
      this.productType,
      this.totalQuantity,
      this.slicingQuantity,
      this.startTime,
      this.startTimeConverted,
      this.endTime,
      this.endTimeConverted,
      this.timeInterval,
      this.timeIntervalConverted,
      this.algoId,
      this.model,
      @required this.type,
      this.priceRangeLow,
      this.priceRangeHigh,
      this.AvgLimitPrice,
      this.AvgExitDiff,
      this.AvgEntryDiff,
      this.AvgDirection,
      this.limitPrice,
      this.historicalSize,
      this.dynamicValue,
      this.dynamicValue2,
      this.atMarket})
      : super(key: key);

  @override
  _AdvanceOrderReviewScreenState createState() =>
      _AdvanceOrderReviewScreenState(
          stock,
          algoName,
          orderType,
          exchange,
          productType,
          totalQuantity,
          slicingQuantity,
          startTime,
          startTimeConverted,
          endTime,
          endTimeConverted,
          timeInterval,
          timeIntervalConverted,
          algoId,
          model,
          type,
          priceRangeLow,
          priceRangeHigh,
          AvgLimitPrice,
          AvgExitDiff,
          AvgEntryDiff,
          AvgDirection,
          limitPrice,
          historicalSize,
          dynamicValue,
          dynamicValue2,
          atMarket);
}

class _AdvanceOrderReviewScreenState extends State<AdvanceOrderReviewScreen> {
  bool showPassword = false, _obscurePassword = true;
  TextEditingController _passwordController;

  _AdvanceOrderReviewScreenState(
      stock,
      algoName,
      orderType,
      exchange,
      productType,
      totalQuantity,
      slicingQuantity,
      startTime,
      startTimeConverted,
      endTime,
      endTimeConverted,
      timeInterval,
      timeIntervalConverted,
      algoId,
      model,
      type,
      priceRangeLow,
      priceRangeHigh,
      AvgLimitPrice,
      AvgExitDiff,
      AvgEntryDiff,
      AvgDirection,
      limitPrice,
      historicalSize,
      dynamicValue,
      dynamicValue2,
      atMarket);

  @override
  void initState() {
    super.initState();
    //  Dataconstants.itsClient.createAlgo();
    _passwordController = TextEditingController();
    CommonFunction.changeStatusBar();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    List<OrderReviewData> listDetails;
    listDetails = [
      OrderReviewData(
          widget.algoId == 4 ? 'START WITH' : 'ORDER TYPE',
          // 'BUY'
          widget.orderType),
    ];
    listDetails.add(OrderReviewData('EXCHANGE', widget.exchange
        // "NSE",
        ));
    listDetails.add(OrderReviewData(
        'PRODUCT TYPE',
        // "INTRADAY",
        widget.productType));
    listDetails.add(OrderReviewData(
        widget.algoId == 4 ? 'MAX OPEN QUANTITY' : 'TOTAL QUANTITY',
        widget.totalQuantity
        // "50",
        ));
    listDetails.add(OrderReviewData(
        widget.algoId == 4 ? 'AVERAGING QUANTITY' : 'SLICING QUANTITY',
        widget.slicingQuantity
        // "10",
        ));

    if (widget.algoId != 3 && widget.algoId != 4) {
      listDetails.add(OrderReviewData(
        'TIME INTERVAL',
        widget.timeInterval,
        // "120",
      ));
    }
    listDetails.add(OrderReviewData(
      'START TIME',
      widget.startTime,
      // "2:35",
    ));
    listDetails.add(OrderReviewData('END TIME', widget.endTime
        // "3:35",
        ));

    for (var i = 0; i < widget.dynamicValue2.length; i++) {
      listDetails.add(OrderReviewData(
          widget.dynamicValue2[i][0], widget.dynamicValue2[i][1]));
    }

    // if (widget.algoId == 2) {
    //   listDetails.add(OrderReviewData('Price Range Low', widget.priceRangeLow
    //       // "3:35",
    //       ));
    //   listDetails.add(OrderReviewData('Price Range High', widget.priceRangeHigh
    //       // "3:35",
    //       ));
    // }
    // if (widget.algoId == 3 || widget.algoId == 4) {
    //   listDetails.add(OrderReviewData('ENTRY DIRECTION', widget.AvgDirection
    //       // "3:35",
    //       ));
    //   listDetails
    //       .add(OrderReviewData('AVG ENTRY DIFFERENCE', widget.AvgEntryDiff
    //           // "3:35",
    //           ));
    //   if (widget.algoId == 3) {
    //     listDetails
    //         .add(OrderReviewData('AVG EXIT DIFFERENCE', widget.AvgExitDiff
    //             // "3:35",
    //             ));
    //   }
    // }
    // if (widget.algoId == 5) {
    //   listDetails.add(OrderReviewData('Limit Price', widget.limitPrice
    //       // "3:35",
    //       ));
    //   listDetails.add(OrderReviewData('Historical Size', widget.historicalSize
    //       // "3:35",
    //       ));
    // }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Dataconstants.overlayStyle,
        backgroundColor: widget.orderType == 'BUY'
            ? ThemeConstants.buyColor
            : ThemeConstants.sellColor,
        // backgroundColor:
        //     widget.isBuy ? ThemeConstants.buyColor : ThemeConstants.sellColor,
        title: Text(
          'CONFIRM ORDER',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(15),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stock,
                          // 'RELIANCE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(widget.algoName
                            // 'Time Slice',
                            ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: GridView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(28),
                      itemCount: listDetails.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2, crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listDetails[index].title,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Text(
                              listDetails[index].value ?? " ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
          // if (showPassword)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 10,
          //       horizontal: 20,
          //     ),
          //     child: TextFieldWidget(
          //       controller: _passwordController,
          //       textInputAction: TextInputAction.next,
          //       hintText: 'Password',
          //       obscureText: _obscurePassword,
          //       prefixIconData: Icons.lock_outline,
          //       suffixIconData:
          //           _obscurePassword ? Icons.visibility : Icons.visibility_off,
          //       onTap: () {
          //         setState(() {
          //           _obscurePassword = !_obscurePassword;
          //         });
          //       },
          //       fillColor: theme.cardColor,
          //     ),
          //   ),
          Center(
            child: Container(
              margin: Platform.isIOS
                  ? const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 70)
                  : const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 30),
              child: SliderButton(
                width: mediaQuery.size.width * 0.65,
                backgroundColor: theme.cardColor,
                backgroundColorEnd: widget.orderType == 'BUY'
                    ? ThemeConstants.buyColor
                    : ThemeConstants.sellColor,
                foregroundColor: widget.orderType == 'BUY'
                    ? ThemeConstants.buyColor
                    : ThemeConstants.sellColor,
                shimmer: true,
                shimmerHighlight: widget.orderType == 'BUY'
                    ? ThemeConstants.buyColor
                    : ThemeConstants.sellColor,
                shimmerBase: Colors.grey,
                text: //"Swipe to Confirm",
                    'Swipe to ${widget.type == OrderType.cancel ? 'Cancel' : widget.type == OrderType.modify ? 'Modify' : widget.type == OrderType.squareOff ? 'Square Off' : widget.orderType == 'BUY' ? 'Buy' : 'Sell'}',
                onConfirmation: () async {
                  // //print("at market : ${widget.atMarket}");
                  // CommonFunction.firebaselogEvent(true,widget.orderType == 'BUY' ? 'swipe_to_buy_algo': 'swipe_to_sell_algo',"_Click",
                  //     widget.orderType == 'BUY' ? 'swipe_to_buy_algo': 'swipe_to_sell_algo');

                  DateTime ExchStartDate = new DateTime(1980, 1, 1, 0, 0, 0);
                  DateTime st = DateTime.now();
                  // //print('exchange date $ExchStartDate');
                  var currentDateTime =
                      DateUtil.getAnyFormattedDate(st, "dd-MMM-yyyy");
                  // //print('currentDateTime  $currentDateTime');
                  var newexchDAtes = DateUtil.getAnyFormattedDate(
                      ExchStartDate, "dd-MMM-yyyy hh:mm:ss");
                  var dateexchsec = DateUtil.getIntFromDate1(newexchDAtes);
                  // //print(' ExchangeDate Converted $dateexchsec');
//--------------------------------->
                  var instructionDate = DateUtil.getAnyFormattedDate(
                      DateTime.now(), "dd-MMM-yyyy HH:mm:ss");
                  // //print('insTructionTime pass sdfdsf = $instructionDate');
                  var instructionDateConverted =
                      DateUtil.getIntFromDate1(instructionDate);
                  // //print(
                  //     'insTructionTime pass Converted to integer = $instructionDateConverted');
                  var instructionDateConvertedPass =
                      instructionDateConverted - dateexchsec;
                  // //print(
                  //     "instructionDateConvertedPass $instructionDateConvertedPass");
                  // DateTime ExchStartDate111 =
                  // new DateTime(1980, 1, 1, 0, 0, 0);
                  //
                  // int getIntFromDateTime(DateTime input) {
                  //   return input
                  //       .difference(ExchStartDate111)
                  //       .inSeconds;
                  // }
                  //
                  // //print(
                  //     "functionksdfnkajf ${getIntFromDateTime(DateTime(
                  //       DateTime.now().year,
                  //       DateTime.now().month,
                  //       DateTime.now().day,
                  //       DateTime.now().hour,
                  //       DateTime.now().minute,
                  //       DateTime.now().second,
                  //     ))}");
                  Dataconstants.algoSubmitted = true;

                  Future<ApiResponse> orderPlaceResponse;

                  orderPlaceResponse = Dataconstants.itsClient2.createAlgo(
                      algoId: widget.algoId,
                      exchange: widget.exchange,
                      exchangeType: widget.model.series,
                      symbol: widget.model.tradingSymbol,
                      scripCode: widget.model.exchCode,
                      totalQuantity: widget.totalQuantity,
                      slicingQuantity: widget.slicingQuantity,
                      buySell: widget.orderType,
                      timeInterval: widget.timeIntervalConverted,
                      startTime: widget.startTimeConverted,
                      endTime: widget.endTimeConverted,
                      orderType: widget.productType,
                      instructionTime: instructionDateConvertedPass,
                      // "${DateTime.now().hour}:${DateTime.now().minute}", //instructionDateConvertedPass,

                      AvgLimitPrice: widget.AvgLimitPrice,
                      dynamicValue: widget.dynamicValue,
                      atmarket: widget.atMarket
                      // startTime: widget.startTime,
                      // endTime: widget.endTime,
                      // lowerPrice: widget.priceRangeLow,
                      // uperPrice: widget.priceRangeHigh,
                      // AvgDirection: widget.AvgDirection,
                      // AvgEntryDiff: widget.AvgEntryDiff,
                      // AvgExitDiff: widget.AvgExitDiff,
                      // limitPrice: widget.limitPrice ?? "0.0",
                      // historicalSize: widget.historicalSize.split(' ')[0],
                      // //  model: widget.model,
                      //     symbol:Dataconstants.algoScriptModel.exchName,
                      //   algoID: widget.algoId,
                      //   startTime: widget.startTime,
                      //   endTime: widget.endTime,
                      //  atMarket: widget.isLimit ? 0 : 1,
                      //   exch: widget.exchange == 'N' ? "NSE" : "BSE",
                      //   slicingQty: widget.slicingQuantity,
                      //   totalQty: widget.totalQuantity,
                      //   buySell: widget.orderType,
                      //   isVTD: false,
                      //   orderType: widget.productType,
                      //  // exchType: widget.model.exchType == 0 ? 'C' : 'D',
                      //   timeInterval: widget.timeInterval,
                      //   instructionTime: 1,
                      // instructionType: widget.instructionType.toString()
                      );

                  {
                    HapticFeedback.vibrate();
                    var data = await showDialog(
                      context: context,
                      builder: (_) => Material(
                        type: MaterialType.transparency,
                        child: OrderPlacedAnimationScreenBigul(
                          'Algo Submitted',
                        ),
                      ),
                    );
                    // if (data != null || data.status != null) {
                    //     Navigator.of(context).pop(data);
                    // }

                    if (data['result'] == true) {


                      // Dataconstants.orderBookData.fetchOrderBook().then((value) {
                      //   // Navigator.of(context).push(
                      //   //   MaterialPageRoute(
                      //   //     builder: (context) {
                      //   //       return Await();
                      //   //     },
                      //   //   ),
                      //   // );
                      // });
                      // CommonFunction.firebaselogEvent(true,widget.orderType == 'BUY' ? 'swipe_to_buy_algo': 'swipe_to_sell_algo',"_Click",
                      //     widget.orderType == 'BUY' ? 'swipe_to_buy_algo': 'swipe_to_sell_algo');

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => bigulAlgorithem()));
                    }
                  }

                  // ApiResponse data = await showDialog(
                  //   context: context,
                  //   builder: (_) => Material(
                  //     type: MaterialType.transparency,
                  //     child: OrderPlacedAnimationScreen(
                  //         orderPlaceResponse, widget.orderType, widget.model),
                  //   ),
                  // );
                  // //print(data);
                  // if (data != null || data.status != null) {
                  //   if (data.algoSuccess.indicator == '1') {
                  //     if (data.algoSuccess.indicator == '1') {
                  //       setState(() {
                  //         showPassword = true;
                  //       });
                  //     }
                  //   } else
                  //     Navigator.of(context).pop(data);
                  // } else {
                  //   // //print("got null status ");
                  // }

                  if (Dataconstants.algoCreateModel.createAlgo.statusCode ==
                          100 ||
                      Dataconstants.algoCreateModel.createAlgo.status ==
                          "Error")
                    await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          var theme = Theme.of(context);
                          return Platform.isIOS
                              ? CupertinoAlertDialog(
                                  title: Text('ERROR'),
                                  content: Text(
                                    Dataconstants.algoCreateModel.createAlgo
                                        .data.message,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  //content: ChangelogScreen(),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'OK',
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
                                  title: Text('ERROR'),
                                  content: Text(
                                    Dataconstants.algoCreateModel.createAlgo
                                        .data.message,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  //content: ChangelogScreen(),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                        });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// void showAllocateFunds({double amount}) async {
//   await showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return AllocateFunds(
//           segment: 0,
//           amount: amount,
//         );
//       });
//   setState(() {});
// }
}

class OrderReviewData {
  final String title;
  final String value;

  const OrderReviewData(this.title, this.value);
}
