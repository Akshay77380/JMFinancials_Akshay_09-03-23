import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/model/existingOrderDetails.dart';
import 'package:markets/model/scrip_info_model.dart';
import 'package:markets/screens/scrip_details_screen.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/util/InAppSelections.dart';
import '../../../controllers/orderBookController.dart';
import '../../../screens/JMOrderPlacedAnimationScreen.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/Utils.dart';
import '../../mainScreen/MainScreen.dart';
import '../../watchlist/jmWatchlistScreen.dart';
import '../order_status_details.dart';

class DerivativeOrderReviewScreen extends StatefulWidget {
  final ScripInfoModel model;
  final bool orderType;
  final bool isBuy;
  final ExistingNewOrderDetails orderModel;
  final bool isLimit;
  final String isSL;
  final String intraDel;
  final String quantity;
  final String limitPrice;
  final String triggerPrice;
  final String orderValue;
  final String validityType;
  final String disclosedQty;
  final String convertriggerPrice;

  final String squareoffvalue;
  final String stoplossvalue;
  final String trailingstoplossflag;
  final String trailingstoplossvalue;
  final String selectedFormatDate;

  bool isSLTPOrder = false, isCoverOrder = false, isBracketOrder = false, isCoverRangeOpen = false, isOpen = false;
  var orderTypeController = ValueNotifier<bool>(false); // true = Market, false = Limit
  var afterMarketController = ValueNotifier<bool>(false);

  DerivativeOrderReviewScreen(
      {@required this.model,
      @required this.orderType,
      @required this.isBuy,
      this.orderModel,
      this.isLimit,
      this.isSL,
      this.intraDel,
      this.quantity,
      this.limitPrice,
      this.triggerPrice,
      this.orderValue,
      this.validityType,
      this.disclosedQty,
      this.isSLTPOrder,
      this.isCoverOrder,
      this.isBracketOrder,
      this.isCoverRangeOpen,
      this.isOpen,
      this.orderTypeController,
      this.afterMarketController,
      this.squareoffvalue,
      this.stoplossvalue,
      this.trailingstoplossflag,
      this.trailingstoplossvalue,
      this.selectedFormatDate,
      this.convertriggerPrice});

  @override
  State<DerivativeOrderReviewScreen> createState() => _DerivativeOrderReviewScreenState();
}

class _DerivativeOrderReviewScreenState extends State<DerivativeOrderReviewScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    List<OrderReviewData> listDetails = [
      OrderReviewData('ORDER TYPE', widget.isSL),
      OrderReviewData('PRODUCT', widget.intraDel),
    ];
    listDetails.add(
      OrderReviewData(
        'QUANTITY',
        widget.quantity,
      ),
    );
    if (widget.isLimit)
      listDetails.add(
        OrderReviewData(
          'PRICE',
          widget.limitPrice,
        ),
      );
    else
      listDetails.add(
        OrderReviewData(
          'PRICE',
          'MKT',
        ),
      );

    // if (isSL)
    //   listDetails.add(
    //     OrderReviewData(
    //       'TRIGGER PRICE',
    //       triggerPrice,
    //     ),
    //   );

    // if (orderValue != "0" && orderValue != null) {
    //   if (isLimit)
    //     listDetails.add(
    //       OrderReviewData(
    //         'ORDER VALUE',
    //         orderValue,
    //       ),
    //     );
    //   else
    //     listDetails.add(
    //       OrderReviewData(
    //         'ORDER VALUE',
    //         'MKT',
    //       ),
    //     );
    // }

    if (widget.orderType != ScripDetailType.cancel) {
      listDetails.add(
        OrderReviewData(
          'VALIDITY',
          widget.validityType,
        ),
      );
      if (widget.disclosedQty == "0" || widget.disclosedQty == " " || widget.disclosedQty == "") {
      } else {
        if (widget.validityType == 0)
          listDetails.add(
            OrderReviewData(
              'DISCLOSED QTY',
              widget.disclosedQty,
            ),
          );
      }
    }

    if (widget.orderType != ScripDetailType.cancel) {
      listDetails.add(
        OrderReviewData(
          'ORDER VALUE',
          widget.orderValue,
        ),
      );
      if (widget.disclosedQty == "0" || widget.disclosedQty == " " || widget.disclosedQty == "") {
      } else {
        if (widget.validityType == 0)
          listDetails.add(
            OrderReviewData(
              'DISCLOSED QTY',
              widget.disclosedQty,
            ),
          );
      }
    }

    Future<bool> _onWillPop() async {
      setState(() {
        Dataconstants.equityTransactionButton = true;
      });
      return Dataconstants.equityTransactionButton;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: widget.isBuy ? ThemeConstants.buyColor : ThemeConstants.sellColor,
          title: Text(
            widget.orderType == ScripDetailType.cancel
                ? 'Cancel Order : ${widget.isBuy ? 'BUY' : 'SELL'}'
                : widget.orderType == ScripDetailType.modify
                    ? 'Modify Order : ${widget.isBuy ? 'BUY' : 'SELL'}'
                    : widget.orderType == ScripDetailType.convertPosition
                        ? 'Convert position : ${widget.isBuy ? 'BUY' : 'SELL'}'
                        : 'Confirm Order : ${widget.isBuy ? 'BUY' : 'SELL'}',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.66,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.model.desc,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text('${widget.model.exchName} ${widget.model.series}'),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                        widget.model.close == 0.00 ? widget.model.prevDayClose.toStringAsFixed(widget.model.precision) : widget.model.close.toStringAsFixed(widget.model.precision),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: widget.model.priceColor == 1
                                              ? ThemeConstants.buyColor
                                              : widget.model.priceColor == 2
                                                  ? ThemeConstants.sellColor
                                                  : theme.textTheme.bodyText1.color,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Observer(
                                          builder: (_) => Text(
                                            /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                            widget.model.close == 0.00 ? '0.00' : widget.model.priceChangeText,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: widget.model.priceChange > 0
                                                  ? ThemeConstants.buyColor
                                                  : widget.model.priceChange < 0
                                                      ? ThemeConstants.sellColor
                                                      : theme.textTheme.bodyText1.color,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Observer(
                                          builder: (_) => Text(
                                            /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                            widget.model.close == 0.00 ? '(0.00%)' : widget.model.percentChangeText,
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
                          const Divider(),
                          Expanded(
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(30),
                              itemCount: listDetails.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 2, crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listDetails[index].title,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      listDetails[index].value ?? "",
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                  ],
                                );
                              },
                            ),
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
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
                child: Container(
                  width: size.width * 0.85,
                  margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(Size(size.width - 0.05, 55)),
                        backgroundColor: widget.isBuy && Dataconstants.equityTransactionButton
                            ? MaterialStateProperty.all<Color>(Utils.brightGreenColor)
                            : widget.isBuy && Dataconstants.equityTransactionButton == false
                                ? MaterialStateProperty.all<Color>(Utils.brightGreenColor.withOpacity(0.5))
                                : widget.isBuy == false && Dataconstants.equityTransactionButton
                                    ? MaterialStateProperty.all<Color>(Utils.brightRedColor)
                                    : widget.isBuy == false && Dataconstants.equityTransactionButton
                                        ? MaterialStateProperty.all<Color>(Utils.brightRedColor.withOpacity(0.5))
                                        : MaterialStateProperty.all<Color>(Utils.brightRedColor.withOpacity(0.5)),
                        foregroundColor: MaterialStateProperty.all<Color>(Utils.whiteColor),
                        textStyle: MaterialStateProperty.all<TextStyle>(Utils.fonts(size: 18.0, color: Utils.whiteColor)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
                    onPressed: Dataconstants.derivativeTransactionButton
                        ? () {
                            setState(() {
                              if (Dataconstants.derivativeTransactionButton) {
                                Dataconstants.derivativeTransactionButton = false;
                              } else {
                                Dataconstants.derivativeTransactionButton = true;
                              }
                            });
                            //TODO:Confirmation
                            processPlace(context);
                          }
                        : null,
                    child: Text('${widget.isBuy ? 'Confirm BUY' : 'Confirm SELL'}'),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void processPlace(BuildContext context) async {
    if (widget.isBracketOrder) {
      var jsons = {
        "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
        "symboltoken": widget.model.exchCode.toString(),
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "quantity": widget.quantity,
        "duration": widget.validityType,
        "disclosedquantity": widget.disclosedQty,
        "price": !widget.orderTypeController.value ? widget.limitPrice : "0",
        "ltporatp": "LTP",
        "squareofftype": "Absolute",
        "squareoffvalue": widget.squareoffvalue,
        "stoplosstype": "Absolute",
        "stoplossvalue": widget.stoplossvalue,
        "trailingstoplossflag": widget.trailingstoplossflag.isEmpty || widget.trailingstoplossflag == '' ? "N" : "Y",
        "trailingstoplossvalue": widget.trailingstoplossvalue,
        "orderSource": "MOB",
        "userTag": "MOB"
      };
      log(jsons.toString());
      var response = await CommonFunction.placeBracketOrder(jsons);
      //log("Bracket Order Response => $response");
      try {
        var responseJson = json.decode(response.toString());
        if (responseJson["status"] == false) {
          CommonFunction.showBasicToast(responseJson["emsg"]);
        } else {
          HapticFeedback.vibrate();
          var data = await showDialog(
            context: context,
            builder: (_) => Material(
              type: MaterialType.transparency,
              child: OrderPlacedAnimationScreen('Order Placed'),
            ),
          );
          if (data['result'] == true) {
            Dataconstants.orderBookData.fetchOrderBook().then((value) {
              return showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => OrderStatusDetails(
                        OrderBookController.OrderBookList.value.data[0],
                      ));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => JmWatchlistScreen()));
          }
        }
      } catch (e) {}
    } else if (widget.validityType == 'GTC' || widget.validityType == 'GTD') {
      var jsons = {
        "tradingsymbol": widget.model.tradingSymbol,
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
        "ordertype": "LIMIT",
        "producttype": widget.intraDel,
        "duration": widget.validityType.toUpperCase(),
        "price": widget.limitPrice,
        "quantity": widget.quantity,
        "triggerprice": "0.00",
        "datedays": widget.validityType == 'GTD' ? widget.selectedFormatDate.replaceAll("/", '-') : '',
        "operation": "<=",
        "src_Expr": "1",
        "target_id": "11"
      };
      log(jsons.toString());
      var response = await CommonFunction.placeGtcGtd(jsons);
      //log("Order Response => $response");
      try {
        var responseJson = json.decode(response.toString());
        if (responseJson["status"] == false) {
          CommonFunction.showBasicToast(responseJson["emsg"]);
        } else {
          HapticFeedback.vibrate();
          var data = await showDialog(
            context: context,
            builder: (_) => Material(
              type: MaterialType.transparency,
              child: OrderPlacedAnimationScreen('Order Placed'),
            ),
          );
          if (data['result'] == true) {
            Dataconstants.orderBookData.fetchOrderBook().then((value) {
              return showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => OrderStatusDetails(
                        OrderBookController.OrderBookList.value.data[0],
                      ));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => JmWatchlistScreen()));
          }
        }
      } catch (e) {}
    } else {
      if (int.parse(widget.quantity) > widget.model.freezQty) {
        var pendingQty = int.parse(widget.quantity);
        var itemCount = (int.parse(widget.quantity) / widget.model.freezQty).floor();
        for (int i = 0; i < itemCount; i++) {
          var jsons = {
            "variety": widget.afterMarketController.value == true ? "AMO" : "NORMAL",
            "tradingsymbol": widget.model.tradingSymbol,
            "symboltoken": widget.model.exchCode.toString(),
            "transactiontype": widget.isBuy ? "BUY" : "SELL",
            "exchange": "NFO",
            "ordertype": widget.isSLTPOrder
                ? !widget.orderTypeController.value
                    ? "STOPLOSS_LIMIT"
                    : "STOPLOSS_MARKET"
                : !widget.orderTypeController.value
                    ? "LIMIT"
                    : "MARKET",
            "producttype": widget.isCoverOrder ? 'COVER' : widget.intraDel.toUpperCase(),
            "duration": widget.validityType.toUpperCase(),
            "price": !widget.orderTypeController.value ? widget.limitPrice : "0",
            "squareoff": "0",
            "stoploss": "0",
            "quantity": widget.model.freezQty.toString(),
            "triggerprice": widget.isSLTPOrder
                ? widget.triggerPrice
                : widget.isCoverOrder
                    ? widget.convertriggerPrice
                    : "0.00",
          };
          log(jsons.toString());
          var response = await CommonFunction.placeOrder(jsons);
          var responseJson = json.decode(response.toString());
          if (responseJson["status"] == false) {
            CommonFunction.showBasicToast(responseJson["emsg"]);
            return;
          }
          //log("fno Order Response => $response");
          pendingQty -= widget.model.freezQty;
        }
        if (pendingQty > 0) {
          var jsons = {
            "variety": widget.afterMarketController.value == true ? "AMO" : "NORMAL",
            "tradingsymbol": widget.model.tradingSymbol,
            "symboltoken": widget.model.exchCode.toString(),
            "transactiontype": widget.isBuy ? "BUY" : "SELL",
            "exchange": "NFO",
            "ordertype": widget.isSLTPOrder
                ? !widget.orderTypeController.value
                    ? "STOPLOSS_LIMIT"
                    : "STOPLOSS_MARKET"
                : !widget.orderTypeController.value
                    ? "LIMIT"
                    : "MARKET",
            "producttype": widget.isCoverOrder ? 'COVER' : widget.intraDel.toUpperCase(),
            "duration": widget.validityType.toUpperCase(),
            "price": !widget.orderTypeController.value ? widget.limitPrice : "0",
            "squareoff": "0",
            "stoploss": "0",
            "quantity": pendingQty.toString(),
            "triggerprice": widget.isSLTPOrder
                ? widget.triggerPrice
                : widget.isCoverOrder
                    ? widget.convertriggerPrice
                    : "0.00",
          };
          log(jsons.toString());
          var response = await CommonFunction.placeOrder(jsons);
          var responseJson = json.decode(response.toString());
          if (responseJson["status"] == false) {
            CommonFunction.showBasicToast(responseJson["emsg"]);
            return;
          }
          //log("fno Order Response => $response");
        }
        HapticFeedback.vibrate();
        var data = await showDialog(
          context: context,
          builder: (_) => Material(
            type: MaterialType.transparency,
            child: OrderPlacedAnimationScreen('Order Placed'),
          ),
        );
        if (data['result'] == true) {
          Dataconstants.orderBookData.fetchOrderBook().then((value) {
            return showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => OrderStatusDetails(
                      OrderBookController.OrderBookList.value.data[0],
                      qty: widget.quantity.toString(),
                    ));
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) => JmWatchlistScreen()));
        }
      } else {
        var jsons = {
          "variety":
              // _afterMarketController.value == true ? "AMO" :
              "NORMAL",
          "tradingsymbol": widget.model.tradingSymbol,
          "symboltoken": widget.model.exchCode.toString(),
          "transactiontype": widget.isBuy ? "BUY" : "SELL",
          "exchange": "NFO",
          "ordertype": widget.isSLTPOrder
              ? !widget.orderTypeController.value
                  ? "STOPLOSS_LIMIT"
                  : "STOPLOSS_MARKET"
              : !widget.orderTypeController.value
                  ? "LIMIT"
                  : "MARKET",
          "producttype": widget.isCoverOrder ? 'COVER' : widget.intraDel.toUpperCase(),
          "duration": widget.validityType.toUpperCase(),
          "price": !widget.orderTypeController.value ? widget.limitPrice : "0",
          "squareoff": "0",
          "stoploss": "0",
          "quantity": widget.quantity,
          "triggerprice": widget.isSLTPOrder
              ? widget.triggerPrice
              : widget.isCoverOrder
                  ? widget.convertriggerPrice
                  : "0.00",
        };
        log(jsons.toString());
        var response = await CommonFunction.placeOrder(jsons);
        //log("fno Order Response => $response");
        try {
          var responseJson = json.decode(response.toString());
          if (responseJson["status"] == false) {
            CommonFunction.showBasicToast(responseJson["emsg"]);
          } else {
            HapticFeedback.vibrate();
            var data = await showDialog(
              context: context,
              builder: (_) => Material(
                type: MaterialType.transparency,
                child: OrderPlacedAnimationScreen('Order Placed'),
              ),
            );
            if (data['result'] == true) {
              Dataconstants.orderBookData.fetchOrderBook().then((value) {
                return showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => OrderStatusDetails(
                          OrderBookController.OrderBookList.value.data[0],
                        ));
              });

              Navigator.push(context, MaterialPageRoute(builder: (context) => JmWatchlistScreen()));
            }
          }
        } catch (e) {}
      }
    }
  }
}

// Widget swipeToAction(Size size, ThemeData theme, double width) {
//   return Container(
//     width: size.width * width,
//     margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
//     child: TextButton(
//       style: ButtonStyle(
//           fixedSize: MaterialStateProperty.all<Size>(Size(size.width * width - 0.05, 55)),
//           backgroundColor: widget.isBuy ? MaterialStateProperty.all<Color>(Utils.brightGreenColor) : MaterialStateProperty.all<Color>(Utils.brightRedColor),
//           foregroundColor: MaterialStateProperty.all<Color>(Utils.whiteColor),
//           textStyle: MaterialStateProperty.all<TextStyle>(Utils.fonts(size: 18.0, color: Utils.whiteColor)),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
//       onPressed: () {
//         //TODO:Confirmation
//         processPlace();
//       },
//       child: Text('${widget.isBuy ? 'BUY' : 'SELL'}'),
//     ),
//   );
// }

// void processPlace() async {
//   if (Dataconstants.passwordChangeRequired) {
//     CommonFunction.changePasswordPopUp(context, Dataconstants.passwordChangeMessage);
//     return;
//   }
//   if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be zero');
//     return;
//   }
//   if (_isSLTPOrder) _discQtyContoller.text = '0';
//   int dQty = int.tryParse(_discQtyContoller.text) ?? 0;
//   int qty = int.tryParse(_qtyContoller.text) ?? 1;
//   double limit = double.tryParse(_limitController.text) ?? 0.0;
//   double trigger = double.tryParse(_triggerController.text) ?? 0.0;
//   List<String> val = _limitController.text.split('.');
//   // //print('this is val => $val');
//   if (val.length > 1) {
//     if (val[1].length == 1) _limitController.text += '0';
//   } else {
//     _limitController.text += '.00';
//   }
//   if (!_orderTypeController.value && !CommonFunction.isValidTickSize(_limitController.text, widget.model)) {
//     CommonFunction.showSnackBarKey(
//         key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
//     return;
//   }
//   List<String> val2 = _triggerController.text.split('.');
//   // //print('this is val2 => $val2');
//   if (val2.length > 1) {
//     if (val2[1].length == 1) _triggerController.text += '0';
//   } else {
//     _triggerController.text += '.00';
//   }
//   if (_isSLTPOrder && !CommonFunction.isValidTickSize(_triggerController.text, widget.model)) {
//     CommonFunction.showSnackBarKey(
//         key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
//     return;
//   }
//   if (_limitController.text == '0.00' && !_orderTypeController.value) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Please Enter Valid Price');
//     return;
//   }
//   if (_limitController.text == '' && !_orderTypeController.value) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Price field cannot be blank');
//     return;
//   }
//   if (!_orderTypeController.value &&
//       !CommonFunction.rateWithin(
//         widget.model.lowerCktLimit,
//         widget.model.upperCktLimit,
//         limit,
//       )) {
//     CommonFunction.showSnackBarKey(
//         key: _scaffoldKey,
//         context: context,
//         color: Colors.red,
//         text:
//         'The Limit Price is outside the limit defined by exchange. Limit Price should fall between ${widget.model.lowerCktLimit.toStringAsFixed(2)} - ${widget.model.upperCktLimit.toStringAsFixed(2)}');
//     return;
//   }
//   //-----------> Updated <--------------------
//
//   if (_isSLTPOrder && _triggerController.text.isEmpty) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
//     return;
//   }
//   //-----------> Updated <--------------------
//
//   if (_isSLTPOrder && _triggerController.text == '0') {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be zero');
//     return;
//   }
//   //-----------> Updated <--------------------
//
//   if (_isSLTPOrder && _triggerController.text[0] == '0') {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot start with zero');
//     return;
//   }
//
//   if (_isSLTPOrder &&
//       !CommonFunction.rateWithin(
//         widget.model.lowerCktLimit,
//         widget.model.upperCktLimit,
//         trigger,
//       )) {
//     CommonFunction.showSnackBarKey(
//         key: _scaffoldKey,
//         color: Colors.red,
//         context: context,
//         text:
//         'Trigger Price is outside the limit defined by exchange. Trigger Price should fall between ${widget.model.lowerCktLimit.toStringAsFixed(2)} - ${widget.model.upperCktLimit.toStringAsFixed(2)}');
//     return;
//   }
//
//   //------------------------> S/M (Market) Order Logic <---------------------------------------------
//
//   // if (widget.isBuy) {
//   //   if (_isSLTPOrder &&
//   //       double.parse(_triggerController.text) <
//   //           double.parse(widget.model.close.toString())) {
//   //     CommonFunction.showSnackBarKey(
//   //         key: _scaffoldKey,
//   //         color: Colors.red,
//   //         context: context,
//   //         text: 'Trigger Price should be greater than LTP');
//   //     return;
//   //   }
//   // } else {
//   //   if (_isSLTPOrder &&
//   //       double.parse(_triggerController.text) >
//   //           double.parse(widget.model.close.toString())) {
//   //     CommonFunction.showSnackBarKey(
//   //         key: _scaffoldKey,
//   //         color: Colors.red,
//   //         context: context,
//   //         text: 'Trigger Price should be less than LTP');
//   //     return;
//   //   }
//   // }
//
//   //---------------------> S/L (Limit) Order Logic<---------------------
//
//   if (widget.isBuy) {
//     if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) >= double.parse(_limitController.text)) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be less than limit price');
//       return;
//     }
//   } else {
//     if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) <= double.parse(_limitController.text)) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be greater than limit price');
//       return;
//     }
//   }
//
//   if (dQty < 0) _discQtyContoller.text = '0';
//
//   if (dQty > 0 && widget.orderType == ScripDetailType.modify) {
//     if (dQty > qty) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
//       return;
//     }
//     if (dQty > 0) {
//       int minDQ = (0.1 * qty).round();
//       if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
//       if (dQty < minDQ) {
//         CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
//         return;
//       }
//     }
//     if (dQty > 0) {
//       int minDQ = (0.1 * (qty - widget.orderModel.qty)).round();
//       if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
//       if (dQty < minDQ) {
//         CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
//         return;
//       }
//     }
//   } else if (dQty > 0) {
//     if (dQty > qty) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
//       return;
//     }
//     if (dQty > 0) {
//       int minDQ = (0.1 * qty).ceil();
//       if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
//       if (dQty < minDQ) {
//         CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
//         return;
//       }
//     }
//   }
//   if (widget.model.exch == 'N') {
//     bool check = false;
//     if (widget.orderModel != null) check = (qty + widget.orderModel.qty) == dQty;
//     if (qty == dQty || check) _discQtyContoller.text = '0';
//   }
//   if (qty < 1) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Order Quantity');
//     return;
//   }
//   if (!_orderTypeController.value && limit < 0.01) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Limit Price');
//     return;
//   }
//   if (_isSLTPOrder && trigger < 0.01) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Trigger Price');
//     return;
//   }
//   if (!_orderTypeController.value && _isSLTPOrder) {
//     if (widget.isBuy && trigger > limit) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be greater than Limit Price');
//       return;
//     } else if (!widget.isBuy && trigger < limit) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price cannot be greater than Trigger Price');
//       return;
//     }
//   }
//   if (qty > Dataconstants.maxOrderQty) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order Qty allowed is ${Dataconstants.maxOrderQty}');
//     return;
//   }
//   if (qty * limit > Dataconstants.maxCashOrderValue) {
//     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Cash Order value allowed is Rs. ${Dataconstants.maxCashOrderValue}');
//     return;
//   }
//   if (_isCoverOrder) {
//     double upperBuyRange, lowerBuyRange, upperSellRange, lowerSellRange;
//     upperBuyRange = double.parse(coverBuyRange.split(" ")[2]);
//     lowerBuyRange = double.parse(coverBuyRange.split(" ")[0]);
//     upperSellRange = double.parse(coverSellRange.split(" ")[2]);
//     lowerSellRange = double.parse(coverSellRange.split(" ")[0]);
//     if (_coverTriggerController.text.isEmpty) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price cannot be empty');
//       return;
//     }
//     if (!widget.isBuy) {
//       if (!_orderTypeController.value) {
//         if (limit <= lowerSellRange || limit >= upperSellRange) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Sell Order Price should be within sell price range');
//           return;
//         }
//         if (double.tryParse(_coverTriggerController.text) <= double.parse(_limitController.text)) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than sell order price');
//           return;
//         }
//       } else {
//         if (double.tryParse(_coverTriggerController.text) <= widget.model.close) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than LTP');
//           return;
//         }
//       }
//     } else {
//       if (!_orderTypeController.value) {
//         if (limit <= lowerBuyRange || limit >= upperBuyRange) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Buy Order Price should be within buy price range');
//           return;
//         }
//         if (double.tryParse(_coverTriggerController.text) >= double.parse(_limitController.text)) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than buy order price');
//           return;
//         }
//       } else {
//         if (double.tryParse(_coverTriggerController.text) >= widget.model.close) {
//           CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than LTP');
//           return;
//         }
//       }
//     }
//   }
//   if (_isBracketOrder) {
//     if (_squareOffTextController.text.isEmpty || _squareOffTextController.text == '') {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price cannot be blank');
//       return;
//     }
//     if (!CommonFunction.isValidTickSize(_squareOffTextController.text, widget.model)) {
//       CommonFunction.showSnackBarKey(
//           key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
//       return;
//     }
//     if (_slBracketTextController.text.isEmpty || _slBracketTextController.text == '') {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
//       return;
//     }
//
//   }
//   if (_validityType == 'GTC' || _validityType == 'GTD') {
//     if (qty * limit < 10000) {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order value allowed for GTD/GTC is Rs. 10000');
//       return;
//     }
//   }
//   if (_productType == 'MTF') {
//     if (widget.model.exch == 'B') {
//       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'MTF product is not allowed for BSE segment');
//       return;
//     }
//   }
//   if (_isBracketOrder) {
//
//
//     var jsons = {
//       "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
//       "symboltoken": widget.model.exchCode.toString(),
//       "transactiontype": widget.isBuy ? "BUY" : "SELL",
//       "quantity": _qtyContoller.text,
//       "duration": _validityType.toUpperCase(),
//       "disclosedquantity": _discQtyContoller.text,
//       "price": !_orderTypeController.value ? _limitController.text : "0",
//       "ltporatp": "LTP",
//       "squareofftype": "Absolute",
//       "squareoffvalue": _squareOffTextController.text,
//       "stoplosstype": "Absolute",
//       "stoplossvalue": _slBracketTextController.text,
//       "trailingstoplossflag": _trailSLTextController.text.isEmpty || _trailSLTextController.text == '' ? "N" : "Y",
//       "trailingstoplossvalue": _trailSLTextController.text,
//       "orderSource": "MOB",
//       "userTag": "MOB"
//     };
//     log(jsons.toString());
//     var response = await CommonFunction.placeBracketOrder(jsons);
//     //log("Bracket Order Response => $response");
//     try {
//       var responseJson = json.decode(response.toString());
//       if (responseJson["status"] == false) {
//         CommonFunction.showBasicToast(responseJson["emsg"]);
//       } else {
//         HapticFeedback.vibrate();
//         var data = await showDialog(
//           context: context,
//           builder: (_) => Material(
//             type: MaterialType.transparency,
//             child: OrderPlacedAnimationScreen('Order Placed'),
//           ),
//         );
//         if (data['result'] == true) {
//           Dataconstants.orderBookData.fetchOrderBook().then((value) {
//             return showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => OrderStatusDetails(
//                   OrderBookController.OrderBookList.value.data[0],
//                 )
//             );
//           });
//         }
//       }
//     } catch (e) {}
//   } else if (_validityType == 'GTC' || _validityType == 'GTD') {
//     var jsons = {
//       "tradingsymbol": widget.model.tradingSymbol,
//       "transactiontype": widget.isBuy ? "BUY" : "SELL",
//       "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
//       "ordertype": "LIMIT",
//       "producttype": _productType,
//       "duration": _validityType.toUpperCase(),
//       "price": _limitController.text,
//       "quantity": _qtyContoller.text,
//       "triggerprice": "0.00",
//       "datedays": _validityType == 'GTD' ? selectedFormatDate.replaceAll("/", '-') : '',
//       "operation": "<=",
//       "src_Expr": "1",
//       "target_id": "11"
//     };
//     log(jsons.toString());
//     var response = await CommonFunction.placeGtcGtd(jsons);
//     //log("Order Response => $response");
//     try {
//       var responseJson = json.decode(response.toString());
//       if (responseJson["status"] == false) {
//         CommonFunction.showBasicToast(responseJson["emsg"]);
//       } else {
//         HapticFeedback.vibrate();
//         var data = await showDialog(
//           context: context,
//           builder: (_) => Material(
//             type: MaterialType.transparency,
//             child: OrderPlacedAnimationScreen('Order Placed'),
//           ),
//         );
//         if (data['result'] == true) {
//           Dataconstants.orderBookData.fetchOrderBook().then((value) {
//             return showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => OrderStatusDetails(
//                   OrderBookController.OrderBookList.value.data[0],
//                 )
//             );
//           });
//         }
//       }
//     } catch (e) {}
//   } else {
//     var jsons = {
//       "variety": _afterMarketController.value == true ? "AMO" : "NORMAL",
//       "tradingsymbol": widget.model.tradingSymbol,
//       "symboltoken": widget.model.exchCode.toString(),
//       "transactiontype": widget.isBuy ? "BUY" : "SELL",
//       "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
//       "ordertype": _isSLTPOrder
//           ? !_orderTypeController.value
//           ? "STOPLOSS_LIMIT"
//           : "STOPLOSS_MARKET"
//           : !_orderTypeController.value
//           ? "LIMIT"
//           : "MARKET",
//       "producttype": _isCoverOrder ? 'COVER' : _productType.toUpperCase(),
//       "duration": _validityType.toUpperCase(),
//       "price": !_orderTypeController.value ? _limitController.text : "0",
//       "squareoff": "0",
//       "stoploss": "0",
//       "quantity": _qtyContoller.text,
//       "disclosedquantity": _discQtyContoller.text,
//       "triggerprice": _isSLTPOrder
//           ? _triggerController.text
//           : _isCoverOrder
//           ? _coverTriggerController.text
//           : "0.00"
//     };
//     log(jsons.toString());
//     var response = await CommonFunction.placeOrder(jsons);
//     //log("Order Response => $response");
//     try {
//       var responseJson = json.decode(response.toString());
//       if (responseJson["status"] == false) {
//         CommonFunction.showBasicToast(responseJson["emsg"]);
//       } else {
//         HapticFeedback.vibrate();
//         var data = await showDialog(
//           context: context,
//           builder: (_) => Material(
//             type: MaterialType.transparency,
//             child: OrderPlacedAnimationScreen('Order Placed'),
//           ),
//         );
//         if (data['result'] == true) {
//           Dataconstants.orderBookData.fetchOrderBook().then((value) {
//             return showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => OrderStatusDetails(
//                   OrderBookController.OrderBookList.value.data[0],
//                 ));
//           });
//         }
//       }
//     } catch (e) {}
//   }
// }

class OrderReviewData {
  final String title;
  final String value;

  const OrderReviewData(this.title, this.value);
}
