import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/existingOrderDetails.dart';
import '../../../model/scrip_info_model.dart';
import '../../../screens/scrip_details_screen.dart';
import '../../../util/CommonFunctions.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/InAppSelections.dart';
import '../../../util/Utils.dart';
import '../../../widget/slider_button.dart';
import '../../CommonWidgets/custom_keyboard.dart';
import '../../CommonWidgets/number_field.dart';

class OfsOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  final ScripDetailType orderType;
  final isBuy;
  final ExistingNewOrderDetails orderModel;
  final Stream<bool> stream;

  OfsOrderScreen({
    @required this.model,
    @required this.orderType,
    @required this.isBuy,
    this.orderModel,
    this.stream
  });

  @override
  State<OfsOrderScreen> createState() => _OfsOrderScreenState();
}

class _OfsOrderScreenState extends State<OfsOrderScreen> {
  TextEditingController _qtyContoller, _limitController, _numPadController = TextEditingController();
  bool _showKeyboard = false, _isInt, isOpen = false;
  List<String> _productItems = ['RIC', 'NRML', 'CNC', 'MIS'];
  String _productType;

  @override
  void initState() {
    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _limitController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _qtyContoller.text = InAppSelection.equityDefaultQty.toString();
    _limitController.text = CommonFunction.getMarketRate(widget.model, widget.isBuy).toStringAsFixed(widget.model.precision);
    _productType = 'RIC';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'QUANTITY',
                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                  ),
                  const SizedBox(height: 10),
                  NumberField(
                    maxLength: 10,
                    numberController: _qtyContoller,
                    hint: 'Quantity',
                    isInteger: true,
                    isBuy: widget.isBuy,
                    isRupeeLogo: false,
                    isDisable: false,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'PRICE',
                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                  ),
                  SizedBox(height: 15),
                  NumberField(
                    doubleDefaultValue: widget.model.close,
                    doubleIncrement: widget.model.incrementTicksize(),
                    maxLength: 10,
                    numberController: _limitController,
                    hint: 'Price',
                    isBuy: widget.isBuy,
                    isRupeeLogo: true,
                    isDisable: false,
                  ),
                  const SizedBox(height: 25),
                  Text('PRODUCT', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                  const SizedBox(height: 10),
                  Container(
                    height: 55,
                    width: size.width,
                    padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1)),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        items: _productItems.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                            ),
                            onTap: () {
                              //TODO:
                            },
                          );
                        }).toList(),
                        underline: SizedBox(),
                        hint: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productType,
                              style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                            ),
                            Text(
                              'Short Description',
                              style: Utils.fonts(fontWeight: FontWeight.w500, size: 12.0, color: theme.textTheme.bodyText1.color),
                            ),
                          ],
                        ),
                        icon: Icon(
                          // Add this
                          Icons.arrow_drop_down, // Add this
                          color: Theme.of(context).textTheme.bodyText1.color, // Add this
                        ),
                        onChanged: (val) {
                          setState(() {
                            _productType = val;
                          });
                        }),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AVAILABLE MARGIN',
                        style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'REQUIRED MARGIN',
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            //TODO:
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) => CustomKeyboard(
            //     controller: _myController,
            //   ),
            // );
          },
          child: Text(
            'Order Summary',
            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color, textDecoration: TextDecoration.underline),
          ),
        ),
        Container(
          width: size.width * 0.85,
          margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
          child: SliderButton(
            height: 55,
            width: size.width * 0.80,
            text: 'SWIPE TO ${widget.isBuy ? widget.orderType == ScripDetailType.modify ? 'MODIFY BUY' : 'BUY' : widget.orderType == ScripDetailType.modify ? 'MODIFY SELL' : 'SELL'}',
            textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
            backgroundColorEnd: theme.cardColor,
            backgroundColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
            foregroundColor: Utils.whiteColor,
            iconColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
            icon: Icons.double_arrow,
            shimmer: false,
            // shimmerHighlight: Utils.whiteColor,
            // shimmerBase: Utils.whiteColor,
            onConfirmation: () async {
              processPlace();
            },
          ),
        ),
        Visibility(
          visible: _showKeyboard,
          child: NumPad(
            isInt: _isInt,
            controller: _numPadController,
            delete: () {
              var cursorPos = _numPadController.selection.base.offset;
              // //print('cursorPos -- $cursorPos');
              _numPadController.text = _numPadController.text.substring(0, cursorPos - 1) + _numPadController.text.substring(cursorPos, _numPadController.text.length);
              _numPadController.value = _numPadController.value.copyWith(selection: TextSelection.fromPosition(TextPosition(offset: cursorPos - 1)));
              // _numPadController.text =
              //     _numPadController.text.substring(0, _numPadController.text.length - 1);
            },
            onSubmit: () {
              setState(() {
                _showKeyboard = false;
              });
            },
          ),
        ),
      ],
    );
  }

  void processPlace() async {
    if (Dataconstants.passwordChangeRequired) {
      CommonFunction.changePasswordPopUp(context, Dataconstants.passwordChangeMessage);
      return;
    }
    // if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be zero');
    //   return;
    // }
    // if (_isSLTPOrder) _discQtyContoller.text = '0';
    // int dQty = int.tryParse(_discQtyContoller.text) ?? 0;
    // int qty = int.tryParse(_qtyContoller.text) ?? 1;
    // double limit = double.tryParse(_limitController.text) ?? 0.0;
    // double trigger = double.tryParse(_triggerController.text) ?? 0.0;
    // List<String> val = _limitController.text.split('.');
    // // //print('this is val => $val');
    // if (val.length > 1) {
    //   if (val[1].length == 1) _limitController.text += '0';
    // } else {
    //   _limitController.text += '.00';
    // }
    // if (!_orderTypeController.value && !CommonFunction.isValidTickSize(_limitController.text, widget.model)) {
    //   CommonFunction.showSnackBarKey(
    //       key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
    //   return;
    // }
    // List<String> val2 = _triggerController.text.split('.');
    // // //print('this is val2 => $val2');
    // if (val2.length > 1) {
    //   if (val2[1].length == 1) _triggerController.text += '0';
    // } else {
    //   _triggerController.text += '.00';
    // }
    // if (_isSLTPOrder && !CommonFunction.isValidTickSize(_triggerController.text, widget.model)) {
    //   CommonFunction.showSnackBarKey(
    //       key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
    //   return;
    // }
    // if (_limitController.text == '0') {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Price field cannot be zero');
    //   return;
    // }
    // if (_limitController.text == '') {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Price field cannot be blank');
    //   return;
    // }
    // if (!_orderTypeController.value &&
    //     !CommonFunction.rateWithin(
    //       widget.model.lowerCktLimit,
    //       widget.model.upperCktLimit,
    //       limit,
    //     )) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Limit Rate not within reasonable limits');
    //   return;
    // }
    // //-----------> Updated <--------------------
    //
    // if (_isSLTPOrder && _triggerController.text.isEmpty) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
    //   return;
    // }
    // //-----------> Updated <--------------------
    //
    // if (_isSLTPOrder && _triggerController.text == '0') {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be zero');
    //   return;
    // }
    // //-----------> Updated <--------------------
    //
    // if (_isSLTPOrder && _triggerController.text[0] == '0') {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot start with zero');
    //   return;
    // }
    //
    // if (_isSLTPOrder &&
    //     !CommonFunction.rateWithin(
    //       widget.model.lowerCktLimit,
    //       widget.model.upperCktLimit,
    //       trigger,
    //     )) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price not within reasonable limits');
    //   return;
    // }
    //
    // //------------------------> S/M (Market) Order Logic <---------------------------------------------
    //
    // // if (widget.isBuy) {
    // //   if (_isSLTPOrder &&
    // //       double.parse(_triggerController.text) <
    // //           double.parse(widget.model.close.toString())) {
    // //     CommonFunction.showSnackBarKey(
    // //         key: _scaffoldKey,
    // //         color: Colors.red,
    // //         context: context,
    // //         text: 'Trigger Price should be greater than LTP');
    // //     return;
    // //   }
    // // } else {
    // //   if (_isSLTPOrder &&
    // //       double.parse(_triggerController.text) >
    // //           double.parse(widget.model.close.toString())) {
    // //     CommonFunction.showSnackBarKey(
    // //         key: _scaffoldKey,
    // //         color: Colors.red,
    // //         context: context,
    // //         text: 'Trigger Price should be less than LTP');
    // //     return;
    // //   }
    // // }
    //
    // //---------------------> S/L (Limit) Order Logic<---------------------
    //
    // if (widget.isBuy) {
    //   if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) >= double.parse(_limitController.text)) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be less than limit price');
    //     return;
    //   }
    // } else {
    //   if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) <= double.parse(_limitController.text)) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be greater than limit price');
    //     return;
    //   }
    // }
    //
    // if (dQty < 0) _discQtyContoller.text = '0';
    //
    // if (dQty > 0 && widget.orderType == ScripDetailType.modify) {
    //   if (dQty > qty) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
    //     return;
    //   }
    //   if (dQty > 0) {
    //     int minDQ = (0.1 * qty).round();
    //     if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
    //     if (dQty < minDQ) {
    //       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
    //       return;
    //     }
    //   }
    //   if (dQty > 0) {
    //     int minDQ = (0.1 * (qty - widget.orderModel.qty)).round();
    //     if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
    //     if (dQty < minDQ) {
    //       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
    //       return;
    //     }
    //   }
    // } else if (dQty > 0) {
    //   if (dQty > qty) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
    //     return;
    //   }
    //   if (dQty > 0) {
    //     int minDQ = (0.1 * qty).round();
    //     if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
    //     if (dQty < minDQ) {
    //       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
    //       return;
    //     }
    //   }
    // }
    // if (widget.model.exch == 'N') {
    //   bool check = false;
    //   if (widget.orderModel != null) check = (qty + widget.orderModel.qty) == dQty;
    //   if (qty == dQty || check) _discQtyContoller.text = '0';
    // }
    // if (qty < 1) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Order Quantity');
    //   return;
    // }
    // if (!_orderTypeController.value && limit < 0.01) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Limit Price');
    //   return;
    // }
    // if (_isSLTPOrder && trigger < 0.01) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Trigger Price');
    //   return;
    // }
    // if (!_orderTypeController.value && _isSLTPOrder) {
    //   if (widget.isBuy && trigger > limit) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be greater than Limit Price');
    //     return;
    //   } else if (!widget.isBuy && trigger < limit) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price cannot be greater than Trigger Price');
    //     return;
    //   }
    // }
    // if (qty > Dataconstants.maxOrderQty) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order Qty allowed is ${Dataconstants.maxOrderQty}');
    //   return;
    // }
    // if (qty * limit > Dataconstants.maxCashOrderValue) {
    //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Cash Order value allowed is Rs. ${Dataconstants.maxCashOrderValue}');
    //   return;
    // }
    // if (widget.orderType == ScripDetailType.modify) {
    //   if (qty + widget.orderModel.tradedQty <= widget.orderModel.tradedQty) {
    //     CommonFunction.showSnackBarKey(
    //         key: _scaffoldKey, color: Colors.red, context: context, text: 'Order Qty cannot be less than or equal to already Traded Qty i.e. ${widget.orderModel.tradedQty}');
    //     return;
    //   }
    //   if (widget.model.exch == 'B') {
    //     if (!widget.orderModel.isSL && _isSLTPOrder) {
    //       CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Bse Limit Order cannot be modified into a SL order\nRemove Trigger Price');
    //       return;
    //     }
    //     if (widget.orderModel.isSL && widget.orderModel.slTriggered && _isSLTPOrder) {
    //       CommonFunction.showSnackBarKey(
    //           key: _scaffoldKey, color: Colors.red, context: context, text: 'Bse SL Order which is already triggered cannot be modified into a SL order\nRemove Trigger Price');
    //       return;
    //     }
    //     if (widget.orderModel.isSL && !widget.orderModel.slTriggered && !_isSLTPOrder) {
    //       CommonFunction.showSnackBarKey(
    //           key: _scaffoldKey, color: Colors.red, context: context, text: 'Bse SL Order not yet triggered cannot be modified into a Limit order\nPlease provide Trigger Price');
    //       return;
    //     }
    //   }
    //
    //   int executedIndex = OrderBookController.executedList.indexWhere((element) => element.exchorderid == widget.orderModel.exchangeOrderId);
    //   if (executedIndex >= 0) {
    //     var order = OrderBookController.executedList[executedIndex];
    //     if (order.model.exch == widget.model.exch && order.symboltoken == widget.model.exchCode) {
    //       if (OrderBookController.getCombinedTradedQty(widget.orderModel) != widget.orderModel.tradedQty) {
    //         CommonFunction.showSnackBarKey(
    //             key: _scaffoldKey,
    //             color: Colors.red,
    //             context: context,
    //             text: 'Traded Qty mismatch for OrderID: ${widget.orderModel.exchangeOrderId.toString()}\nThis order seems to be further partly or fully executed\nPlease exit and re login.');
    //         return;
    //       }
    //     }
    //   }
    //   bool noDifference = false;
    //   if ((widget.orderModel.qty - widget.orderModel.tradedQty) == qty && widget.orderModel.rate == limit) {
    //     noDifference = true;
    //     if (widget.orderModel.isLimit != !_orderTypeController.value) noDifference = false;
    //     if (widget.orderModel.isSL != _isSLTPOrder) noDifference = false;
    //     if (widget.orderModel.triggerRate != trigger) noDifference = false;
    //     // if (widget.orderModel.ioc == 1) noDifference = false;
    //   }
    //   if (noDifference) {
    //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'No difference between current order and modified order.');
    //     return;
    //   }
    // }
    //
    // if (widget.orderType == ScripDetailType.modify) {
    //   var jsons = {
    //     "variety": "NORMAL",
    //     "tradingsymbol": widget.model.exch == "N" ? widget.model.name + "-" + widget.model.series : widget.model.name,
    //     "symboltoken": widget.model.exchCode.toString(),
    //     "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
    //     "orderid": widget.orderModel.orderId,
    //     "transactiontype": widget.isBuy ? "BUY" : "SELL",
    //     "ordertype": !_orderTypeController.value ? "LIMIT" : "MARKET",
    //     "producttype": _productType.toUpperCase(),
    //     "duration": _validityType.toUpperCase(),
    //     "price": !_orderTypeController.value ? _limitController.text : "0",
    //     "quantity": _qtyContoller.text,
    //     "filledquantity": widget.orderModel.tradedQty.toString(),
    //     "disclosedquantity": _discQtyContoller.text,
    //     "triggerprice": !_slOrderTypeController.value ? _triggerController.text : "0.00"
    //   };
    //   log(jsons.toString());
    //   var response = await CommonFunction.modifyOrder(jsons);
    //   //log("modify Order Response => $response");
    //   try {
    //     var responseJson = json.decode(response.toString());
    //     if (responseJson["status"] == false) {
    //       CommonFunction.showBasicToast(responseJson["message"]);
    //     } else {
    //       Dataconstants.orderBookData.fetchOrderBook();
    //       HapticFeedback.vibrate();
    //       var data = await showDialog(
    //         context: context,
    //         builder: (_) => Material(
    //           type: MaterialType.transparency,
    //           child: OrderPlacedAnimationScreen('Order Modification requested'),
    //         ),
    //       );
    //       if (data['result'] == true) {
    //         Dataconstants.orderBookData.fetchOrderBook().then((value) {
    //           return showModalBottomSheet(
    //               isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => OrderStatusDetails(OrderBookController.OrderBookList.value.data[0], false));
    //         });
    //         // Navigator.of(context).pop();
    //       }
    //     }
    //   } catch (e) {}
    // } else {
    //   var jsons = {
    //     "variety": _isSLTPOrder ? "STOPLOSS" : "NORMAL",
    //     "tradingsymbol": widget.model.exch == "N" ? widget.model.name + "-" + widget.model.series : widget.model.name,
    //     "symboltoken": widget.model.exchCode.toString(),
    //     "transactiontype": widget.isBuy ? "BUY" : "SELL",
    //     "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
    //     "ordertype": !_orderTypeController.value ? "LIMIT" : "MARKET",
    //     "producttype": _productType.toUpperCase(),
    //     "duration": _validityType.toUpperCase(),
    //     "price": !_orderTypeController.value ? _limitController.text : "0",
    //     "squareoff": "0",
    //     "stoploss": "0",
    //     "quantity": _qtyContoller.text,
    //     "disclosedquantity": _discQtyContoller.text,
    //     "triggerprice": _isSLTPOrder
    //         ? _slOrderTypeController.value == true
    //         ? widget.model.close.toStringAsFixed(2)
    //         : _triggerController.text
    //         : "0.00"
    //   };
    //   log(jsons.toString());
    //   var response = await CommonFunction.placeOrder(jsons);
    //   //log("Order Response => $response");
    //   try {
    //     var responseJson = json.decode(response.toString());
    //     if (responseJson["status"] == false) {
    //       CommonFunction.showBasicToast(responseJson["message"]);
    //     } else {
    //       HapticFeedback.vibrate();
    //       var data = await showDialog(
    //         context: context,
    //         builder: (_) => Material(
    //           type: MaterialType.transparency,
    //           child: OrderPlacedAnimationScreen('Order Placed'),
    //         ),
    //       );
    //       if (data['result'] == true) {
    //         Dataconstants.orderBookData.fetchOrderBook().then((value) {
    //           return showModalBottomSheet(
    //               isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) =>
    //               OrderStatusDetails(OrderBookController.OrderBookList.value.data[0], false));
    //         });
    //         // Navigator.of(context).pop();
    //       }
    //     }
    //   } catch (e) {}
    // }
  }

}
