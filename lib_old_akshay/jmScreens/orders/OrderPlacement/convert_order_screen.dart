import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import '../../../controllers/getReqMarginController.dart';
import '../../../controllers/limitController.dart';
import '../../../model/existingOrderDetails.dart';
import '../../../model/scrip_info_model.dart';
import '../../../screens/JMOrderPlacedAnimationScreen.dart';
import '../../../screens/scrip_details_screen.dart';
import '../../../screens/web_view_link_screen.dart';
import '../../../style/theme.dart';
import '../../../util/CommonFunctions.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/InAppSelections.dart';
import '../../../util/Utils.dart';
import '../../../widget/slider_button.dart';
import '../../CommonWidgets/custom_keyboard.dart';
import '../../CommonWidgets/number_field.dart';
import '../../addFunds/AddMoney.dart';
import '../../mainScreen/MainScreen.dart';
import '../order_summary_details.dart';
import 'order_placement_screen.dart';

class ConvertOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  final ExistingNewOrderDetails orderModel;
  final isBuy;

  ConvertOrderScreen({@required this.model, @required this.isBuy, this.orderModel});

  @override
  State<ConvertOrderScreen> createState() => _ConvertOrderScreenState();
}

class _ConvertOrderScreenState extends State<ConvertOrderScreen> {
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  List<String> _productItems = ['NRML', 'CNC', 'MIS'];
  bool _showKeyboard = false, _isInt;
  String _productType;
  TextEditingController _qtyContoller, _numPadController = TextEditingController();

  @override
  void initState() {
    Dataconstants.iqsClient.sendLTPRequest(widget.model, false);
    Dataconstants.iqsClient.sendMarketDepthRequest(
        widget.model.exch, widget.model.exchCode, true
    );
    super.initState();
    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _qtyContoller.text = widget.isBuy ? widget.orderModel.convertBuyQty.toString() : widget.orderModel.convertSellQty.toString();
    if (widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity) {
      if (widget.orderModel.productType == 'NRML') {
        _productItems = ['CNC', 'MIS'];
        _productType = _productItems[0];
      } else if (widget.orderModel.productType == 'CNC') {
        _productItems = ['NRML', 'MIS'];
        _productType = _productItems[0];
      } else {
        _productItems = ['NRML', 'CNC'];
        _productType = _productItems[0];
      }
    } else {
      if (widget.orderModel.productType == 'NRML') {
        _productItems = ['MIS'];
        _productType = _productItems[0];
      } else {
        _productItems = ['NRML'];
        _productType = _productItems[0];
      }
    }
  }

  @override
  void dispose() {
    Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20.0,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: const Icon(Icons.arrow_back_ios),
          ),
          // color: Colors.white,
          onTap: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                  ),
                  child: Text(widget.isBuy ? 'BUY' : 'SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                ),
                Text(
                  widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity ? widget.model.desc.trim() : widget.model.marketWatchName.trim(),
                  style: Utils.fonts(size: 15.0, color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Utils.greyColor,
                  ),
                  child: Text(widget.orderModel.exch == 'B' ? 'BSE' : 'NSE', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500)),
                ),
                // SizedBox(
                //   height: 22,
                //   child: Icon(
                //     Icons.arrow_drop_down_rounded,
                //     size: 30,
                //     // widget.model.close > widget.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                //     color: Utils.blackColor,
                //   ),
                // ),
              ],
            ),
            Observer(
              builder: (_) => Row(
                children: [
                  Text(
                    widget.model.close.toStringAsFixed(widget.model.precision),
                    style: Utils.fonts(color: Utils.blackColor, size: 12.0, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    widget.model.close > widget.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    color: Utils.blackColor,
                  ),
                  Observer(
                    builder: (_) => Text(
                      /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                      widget.model.close == 0.00 ? '0.00' : widget.model.priceChangeText,
                      style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                        color: widget.model.priceChange > 0
                            ? Utils.mediumGreenColor
                            : widget.model.priceChange < 0
                            ? Utils.mediumRedColor
                            : theme.textTheme.bodyText1.color,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Observer(
                    builder: (_) => Text(
                      /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                      widget.model.close == 0.00 ? '0.00%' : '${widget.model.percentChangeText}',
                      style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                        color: widget.model.priceChange > 0
                            ? Utils.mediumGreenColor
                            : widget.model.priceChange < 0
                            ? Utils.mediumRedColor
                            : theme.textTheme.bodyText1.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
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
                      increment: widget.model.minimumLotQty,
                      maxLength: 6,
                      numberController: _qtyContoller,
                      hint: 'Quantity',
                      isInteger: true,
                      isBuy: widget.isBuy,
                      isRupeeLogo: false,
                    ),
                    const SizedBox(height: 25),
                    Text('OLD PRODUCT', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                    const SizedBox(height: 10),
                    Container(
                      height: 55,
                      width: size.width,
                      padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderModel.productType,
                            style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                          ),
                          Text(
                            widget.orderModel.productType == 'NRML' ? 'Overnight' : widget.orderModel.productType == 'MIS' ? 'Intraday' : 'Delivery',
                            style: Utils.fonts(fontWeight: FontWeight.w500, size: 12.0, color: theme.textTheme.bodyText1.color),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text('NEW PRODUCT', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
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
                                _productType == 'NRML' ? 'Overnight' : _productType == 'MIS' ? 'Intraday' : 'Delivery',
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

                            var requestForReqMargin = {
                              "exchangetype": widget.model.series,
                              "producttype": _productType,
                              "quantity_or_lot": "1",
                              "Ltp": widget.model.close.toStringAsFixed(4),
                              "scripcode": widget.model.exchCode.toString(),
                              "tradingsymbol": widget.model.tradingSymbol
                            };

                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                              await Dataconstants.getRequiredMarginController.getRequiredMargin(requestForReqMargin);
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
                        Obx(() {
                          return Text(
                            '₹ ${LimitController.limitData.value.availableMargin.toString()}',
                            style: Utils.fonts(
                                color: Utils.blackColor,
                                size: 14.0,
                                fontWeight: FontWeight.w700),
                          );
                        }
                        ),
                        Obx(() {
                          return GetRequiredMarginController.isLoading.value
                              ? Text(
                              widget.orderModel.productType == "NRML" || widget.orderModel.productType == "MTF" || widget.orderModel.productType == "MIS"
                                  ? (widget.orderModel.qty * widget.model.close * (double.parse(GetRequiredMarginController.hairCut.value) / 100)).toStringAsFixed(2)
                                  : (widget.orderModel.qty * widget.model.close).toStringAsFixed(2),
                                    // : "djy",
                              style: Utils.fonts(
                                color: Utils.blackColor,
                              ))
                              : Text(
                              widget.orderModel.productType == "NRML" || widget.orderModel.productType == "MTF" || widget.orderModel.productType == "MIS"
                                  ? (widget.orderModel.qty * widget.model.close * (double.parse(GetRequiredMarginController.hairCut.value) / 100)).toStringAsFixed(2)
                                  : (widget.orderModel.qty * widget.model.close).toStringAsFixed(2),
                              style: Utils.fonts(
                                color: Utils.blackColor,
                              ));
                        }),
                        // Text("0.0")
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
              // showModalBottomSheet(
              //     isScrollControlled: true,
              //     context: context,
              //     backgroundColor: Colors.transparent,
              //     builder: (context) => OrderSummaryDetails(
              //       isBuy: widget.isBuy,
              //       model: widget.model,
              //       qty: _qtyContoller.text,
              //       productType: _productType,
              //       swipeAction: swipeToAction(size, theme, 1.0),
              //     ));
            },
            child: Text(
              'Order Summary',
              style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color, textDecoration: TextDecoration.underline),
            ),
          ),
          swipeToAction(size, theme, 0.85),
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
      ),
    );
  }

  Widget swipeToAction(Size size, ThemeData theme, double width) {
    return Container(
      width: size.width * 0.85,
      margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
        child: TextButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(size.width * width - 0.05, 55)),
              backgroundColor: widget.isBuy ? MaterialStateProperty.all<Color>(Utils.brightGreenColor) : MaterialStateProperty.all<Color>(Utils.brightRedColor),
              foregroundColor: MaterialStateProperty.all<Color>(Utils.whiteColor),
              textStyle: MaterialStateProperty.all<TextStyle>(Utils.fonts(size: 18.0, color: Utils.whiteColor)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
          onPressed: () {
            processPlace();
          },
          child: Text('CLICK TO CONVERT'),
        )
      // child: SliderButton(
      //   height: 55,
      //   width: size.width * 0.80,
      //   text: 'SWIPE TO CONVERT',
      //   textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
      //   backgroundColorEnd: theme.cardColor,
      //   backgroundColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   foregroundColor: Utils.whiteColor,
      //   iconColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   icon: Icons.double_arrow,
      //   shimmer: false,
      //   // shimmerHighlight: Utils.whiteColor,
      //   // shimmerBase: Utils.whiteColor,
      //   onConfirmation: () {
      //     processPlace();
      //   },
      // ),
    );
  }

  void processPlace() async {
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be zero');
      return;
    }
    if (int.tryParse(_qtyContoller.text) > (widget.isBuy ? widget.orderModel.convertBuyQty : widget.orderModel.convertSellQty)) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Quantity should be less than or equal to ${widget.isBuy ? widget.orderModel.convertBuyQty.toString() : widget.orderModel.convertSellQty.toString()}');
      return;
    }
    if (_productType == widget.orderModel.productType) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'No difference between current product and product to convert.');
      return;
    }
    var jsons = {
      "producttype": widget.orderModel.productType,
      "newproducttype": _productType,
      "exchange": widget.model.exchCategory == ExchCategory.bseEquity
          ? 'BSE'
          : widget.model.exchCategory == ExchCategory.nseFuture || widget.model.exchCategory == ExchCategory.nseOptions
          ? 'NFO'
          : widget.model.exchCategory == ExchCategory.mcxFutures || widget.model.exchCategory == ExchCategory.mcxOptions
          ? "MCX"
          : widget.model.exchCategory == ExchCategory.nseEquity
          ? "NSE"
          : 'CDS',
      "symboltoken": widget.orderModel.symboltoken,
      "tradingsymbol": widget.model.tradingSymbol,
      "symbolname": widget.model.name,
      "quantity": _qtyContoller.text,
      "transactiontype": widget.isBuy ? "BUY" : "SELL",
      "type": "DAY"
    };
    log(jsons.toString());
    var response = await CommonFunction.convertPositionOrder(jsons);
    //log("convert position Order Response => $response");
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
            child: OrderPlacedAnimationScreen('Position Conversion Requested'),
          ),
        );
        if (data['result'] == true) {
          Navigator.pop(context);
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => ConvertOrderStatusDetails(
                model: widget.model,
                newProduct: _productType,
                qty: _qtyContoller.text,
                status: true,
                rejectMsg: responseJson["message"],
                isBuy: widget.isBuy,
              ));
        }
        Dataconstants.netPositionController.fetchNetPosition();
      }
    } catch (e) {}
  }
}

class ConvertOrderStatusDetails extends StatefulWidget {
  final String newProduct;
  final String qty;
  final ScripInfoModel model;
  final bool status;
  final String rejectMsg;
  final bool isBuy;

  ConvertOrderStatusDetails({this.model, this.qty, this.newProduct, this.status, this.rejectMsg, this.isBuy});

  @override
  State<ConvertOrderStatusDetails> createState() => _ConvertOrderStatusDetailsState();
}

class _ConvertOrderStatusDetailsState extends State<ConvertOrderStatusDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
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
                            "Order Status",
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
                        height: 10,
                      ),
                      Image.asset('assets/appImages/sip_bell.png'),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "QTY",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.qty,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "NEW PRODUCT",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.newProduct.toUpperCase(),
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "STATUS",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.status ? 'SUCCESS' : 'REJECT',
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: widget.status ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text("STOCK YOU ${widget.isBuy ? 'BUY' : 'SELL'}",
                                style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity ? widget.model.name : widget.model.desc, maxLines: 1, style: Utils.fonts(size: 20.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                  ),
                                  Observer(
                                      builder: (_) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(widget.model.close.toStringAsFixed(widget.model.precision),
                                                style: Utils.fonts(size: 16.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                widget.model.priceChangeText + " " + widget.model.percentChangeText,
                                                style: Utils.fonts(
                                                    color: widget.model.percentChange > 0
                                                        ? ThemeConstants.buyColor
                                                        : widget.model.percentChange < 0
                                                        ? ThemeConstants.sellColor
                                                        : theme.errorColor,
                                                    size: 12.0,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Icon(
                                                  widget.model.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                  color: widget.model.percentChange > 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (!widget.status)
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Utils.greyColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("REJECTION REASON", style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Text("${widget.rejectMsg}", style: Utils.fonts(size: 12.0, color: Colors.red), textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (widget.rejectMsg.toLowerCase().contains('margin exceeds'))
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Available Margin", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Text('25,325.5', style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                                          Text("Shortfall Amount", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Text('67,565.5', style: Utils.fonts(size: 12.0, color: Utils.brightRedColor))
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
                                          Text("Increase Margin using Holdings", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Text('1,12,000.5', style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
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
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Utils.primaryColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Utils.whiteColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  InAppSelection.mainScreenIndex = 3;
                                  Dataconstants.ordersScreenIndex = 0;
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (_) => MainScreen(
                                        toChangeTab: true,
                                      )), (route) => false);
                                },
                                child: Text("ORDER BOOK", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                              ),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              widget.rejectMsg.toLowerCase().contains('margin exceeds')
                                  ? InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoney(money:'0',fromActivity: "Add Funds",type: "add")));
                                },
                                child: Text("ADD FUNDS", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                              )
                                  : InkWell(
                                onTap: () {
                                  InAppSelection.mainScreenIndex = 1;
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (_) => MainScreen(
                                        toChangeTab: false,
                                      )), (route) => false);
                                },
                                child: Text("WATCHLIST", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    widget.rejectMsg.toLowerCase().contains('margin exceeds')
                        ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>WebViewLinkScreen(Dataconstants.clientTypeData["pledge_url"],"PLEDGE")));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("INCREASE MARGIN", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                      ),
                    )
                        : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (widget.status) {
                          if (widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return OrderPlacementScreen(
                                    // model: currentModelNew,
                                    model: widget.model,
                                    // currentModelNew to be used only for equity nse/bse toggle
                                    orderType: ScripDetailType.none,
                                    isBuy: widget.isBuy == 'BUY' ? false : true,
                                    selectedExch: widget.model.exch == 'NSE' ? "N" : "B",
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
                                    model: widget.model,
                                    orderType: ScripDetailType.none,
                                    isBuy: widget.isBuy == 'BUY' ? false : true,
                                    selectedExch: "N",
                                    stream: Dataconstants.pageController.stream,
                                  );
                                },
                              ),
                            );
                        } else
                          Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(widget.status ? "ADD MORE" : "RETRY", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
