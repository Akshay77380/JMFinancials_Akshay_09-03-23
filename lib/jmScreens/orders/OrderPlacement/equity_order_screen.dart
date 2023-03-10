import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/more/more_screen.dart';
import '../../../controllers/BrokerageController.dart';
import '../../../controllers/limitController.dart';
import '../../../controllers/orderBookController.dart';
import '../../../model/exchData.dart';
import '../../../model/existingOrderDetails.dart';
import '../../../model/scrip_info_model.dart';
import '../../../screens/JMOrderPlacedAnimationScreen.dart';
import '../../../screens/scrip_details_screen.dart';
import '../../../util/CommonFunctions.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/InAppSelections.dart';
import '../../../util/Utils.dart';
import '../../../widget/slider_button.dart';
import '../../CommonWidgets/custom_keyboard.dart';
import '../../CommonWidgets/number_field.dart';
import '../../CommonWidgets/switch.dart';
import '../order_status_details.dart';
import '../order_summary_details.dart';

class EquityOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  final ScripDetailType orderType;
  final isBuy;
  final ExistingNewOrderDetails orderModel;
  final Stream<bool> stream;

  EquityOrderScreen({@required this.model, @required this.orderType, @required this.isBuy, this.orderModel, this.stream});

  @override
  _EquityOrderScreenState createState() => _EquityOrderScreenState();
}

class _EquityOrderScreenState extends State<EquityOrderScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  var _orderTypeController = ValueNotifier<bool>(false); // true = Market, false = Limit
  var _afterMarketController = ValueNotifier<bool>(false);
  TextEditingController _qtyContoller, _limitController, _triggerController, _discQtyContoller, _coverTriggerController, _squareOffTextController, _slBracketTextController, _trailSLTextController;
  List<String> _productItems = ['NRML', 'CNC', 'MIS', 'MTF'];
  List<String> _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD', 'GTT'];
  bool _isSLTPOrder = false, _isCoverOrder = false, _isBracketOrder = false, _isCoverRangeOpen = false, isOpen = false;
  String _limitValue, _productType, _validityType, selectedFormatDate, coverBuyRange = '', coverSellRange = '';
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  Future getCoverPriceRange() async {
    /* For Buy Range */
    var jsonResponse = {"exchange": widget.model.exch == 'N' ? "NSE" : "BSE", "tradingsymbol": widget.model.exchCode.toString(), "transactiontype": "BUY"};
    var result = await CommonFunction.coverPriceRange(jsonResponse);
    var response = jsonDecode(result);
    if (response['status'] == false) {
      CommonFunction.showBasicToast(response["emsg"].toString());
    } else {
      coverBuyRange = response['data']['TriggerPriceRange'];
    }
    /* For Sell Range */
    var jsonResponse2 = {"exchange": widget.model.exch == 'N' ? "NSE" : "BSE", "tradingsymbol": widget.model.exchCode.toString(), "transactiontype": "SELL"};
    var result2 = await CommonFunction.coverPriceRange(jsonResponse2);
    var response2 = jsonDecode(result2);
    if (response['status'] == false) {
      CommonFunction.showBasicToast(response["emsg"].toString());
    } else {
      coverSellRange = response2['data']['TriggerPriceRange'];
    }
  }

  @override
  void initState() {
    Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    getCoverPriceRange();
    widget.stream.listen((seconds) {
      _updateSeconds();
    });

    setState(() {
      if (Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesClosed){
        _afterMarketController.value = true;
      }
    });

    _orderTypeController.addListener(() {
      setState((){
        if (_validityType == 'GTC' || _validityType == 'GTD' || _validityType == 'GTT') {
          _orderTypeController.value = false;
        }
        if (_orderTypeController.value == true) {
          _limitValue = _limitController.text;
          _limitController.text = '0';
        } else {
          _limitController.text = _limitValue;
        }
      });
    });

    _afterMarketController.addListener(() {
      setState(() {
        if (Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesClosed){
          _afterMarketController.value = true;
        }
      });
      print("AfterMkt: ${_afterMarketController}");
    });

    // _afterMarketController.addListener(() {
    //   // if (_isCoverOrder)
    //   //   setState(() {
    //   //     _afterMarketController.value = false;
    //   //   });
    //   // if (Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesOpen) {
    //   //   if (_isCoverOrder)
    //   //     setState(() {
    //   //       _afterMarketController.value = false;
    //   //     });
    //   // } else {
    //   //   setState(() {
    //   //     _afterMarketController.value = false;
    //   //   });
    //   // }
    //   // setState(() {
    //   //   _afterMarketController.value =!_afterMarketController.value;
    //   //   // if(_afterMarketController.value == false){
    //   //   //   _afterMarketController.value = true;
    //   //   // }else{
    //   //   //   _afterMarketController.value = false;
    //   //   // }
    //   // });
    //   setState(() {
    //     if (Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesClosed){
    //       _afterMarketController.value = true;
    //     }
    //   });
    // });

    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _limitController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _triggerController = TextEditingController();
    _discQtyContoller = TextEditingController();
    _coverTriggerController = TextEditingController();
    _squareOffTextController = TextEditingController();
    _slBracketTextController = TextEditingController();
    _trailSLTextController = TextEditingController();
    /* Assigning blank field to the disclosed Quantity when its fresh order or disclosed quantity field is zero BOB and exchange requirement */
    _discQtyContoller.text = '0';
    /* Assigning blank field to the Quantity when its fresh order or quantity field is zero BOB and exchange requirement */
    _qtyContoller.text = Dataconstants.scripInfoQty != ''
        ? Dataconstants.scripInfoQty
        : (InAppSelection.equityDefaultQty == null || InAppSelection.equityDefaultQty == -1)
            ? widget.model.minimumLotQty.toString()
            : InAppSelection.equityDefaultQty.toString();
    /* Fetching limit value from the model and assigning it to its testfield*/
    _limitController.text = Dataconstants.scripInfoPrice != '' ? Dataconstants.scripInfoPrice : CommonFunction.getMarketRate(widget.model, widget.isBuy).toStringAsFixed(widget.model.precision);
    /* Fetching trigger value from the model and assigning it to its testfield*/
    _triggerController.text = '';
    _coverTriggerController.text = '';
    _squareOffTextController.text = '';
    _slBracketTextController.text = '';
    _trailSLTextController.text = '';
    // if (Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesAHOpen) {
    //   _afterMarketController.value = true;
    // }
    if (widget.orderType == ScripDetailType.positionAdd || widget.orderType == ScripDetailType.holdingAdd) {
      _productType = widget.orderModel.productType == 'COVER' ? 'MIS' : widget.orderModel.productType;
      _validityType = 'DAY';
    }
    if (widget.orderType == ScripDetailType.none || widget.orderType == ScripDetailType.setStopLoss) {
      _orderTypeController.value = InAppSelection.orderType == 'market' ? true : false;

      _afterMarketController.value = InAppSelection.orderType == 'market' ? true : false;
      _productType = Dataconstants.scripInfoProduct != ''
          ? Dataconstants.scripInfoProduct
          : InAppSelection.productTypeEquity == ''
              ? 'CNC'
              : InAppSelection.productTypeEquity;
      _validityType = 'DAY';
    }
    if (widget.orderType == ScripDetailType.setStopLoss) {
      isOpen = true;
      _isSLTPOrder = true;
      _qtyContoller.text = widget.orderModel.qty.toString();
    }
    selectedFormatDate = formatter.format(DateTime.now());
    super.initState();
  }

  void _updateSeconds() {
    if (mounted) setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    var newDate = new DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
    final picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Utils.primaryColor, onPrimary: Utils.whiteColor, onSurface: Utils.primaryColor)), child: child);
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: newDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedFormatDate = formatter.format(selectedDate);
      });
    }
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
                    maxLength: 6,
                    numberController: _qtyContoller,
                    hint: 'Quantity',
                    isInteger: true,
                    isBuy: widget.isBuy,
                    isRupeeLogo: false,
                    isDisable: false,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        'LIMIT',
                        style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      ),
                      const SizedBox(width: 10),
                      ToggleSwitch(
                        switchController: _orderTypeController,
                        isBorder: true,
                        activeColor: Utils.whiteColor,
                        inactiveColor: Utils.whiteColor,
                        thumbColor: Utils.blackColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'MARKET',
                        style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          InAppSelection.orderPlacementScreenIndex = 1;
                          Dataconstants.pageController.add(true);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/appImages/bidask.svg',
                              color: Utils.blackColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'BID/ASK',
                              style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor, textDecoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
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
                      child: NumberField(
                        doubleDefaultValue: widget.model.close,
                        doubleIncrement: widget.model.incrementTicksize(),
                        numberController: _limitController,
                        hint: 'Limit',
                        maxLength: 10,
                        decimalPosition: 2,
                        isBuy: widget.isBuy,
                        isRupeeLogo: true,
                        isDisable: _orderTypeController.value ? true : false,
                      )),
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
                              _productType == 'NRML'
                                  ? 'Overnight'
                                  : _productType == 'MIS'
                                      ? 'Intraday'
                                      : 'Delivery',
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
                            if (_isCoverOrder || _isBracketOrder || _isSLTPOrder)
                              _orderValidityItems = ['DAY'];
                            else if (val == 'MIS')
                              _orderValidityItems = ['DAY', 'IOC'];
                            else
                              _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD', 'GTT'];
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
                          style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                        );
                      }),
                      Text(
                        '₹ 0.00',
                        style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Advanced Options', style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: Utils.blackColor, textDecoration: TextDecoration.underline)),
                        const SizedBox(
                          width: 10,
                        ),
                        if (!isOpen) SvgPicture.asset('assets/appImages/arrow.svg') else RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/appImages/arrow.svg')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: isOpen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 55,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Utils.lightGreyColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSLTPOrder = !_isSLTPOrder;
                                      _isCoverOrder = false;
                                      _isBracketOrder = false;
                                      _productItems = ['NRML', 'CNC', 'MIS', 'MTF'];
                                      _discQtyContoller.text = '0';
                                      if (_isSLTPOrder) {
                                        _orderValidityItems = ['DAY'];
                                        _validityType = 'DAY';
                                      } else {
                                        _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD'];
                                        _validityType = 'DAY';
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _isSLTPOrder
                                          ? widget.isBuy
                                              ? Utils.brightGreenColor.withOpacity(0.4)
                                              : Utils.brightRedColor.withOpacity(0.4)
                                          : Colors.transparent,
                                    ),
                                    child: Text('STOP LOSS', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Utils.blackColor)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _orderTypeController.value = false;
                                      _isCoverOrder = !_isCoverOrder;
                                      _isSLTPOrder = false;
                                      _isBracketOrder = false;
                                      _discQtyContoller.text = '0';
                                      if (_isCoverOrder) {
                                        _productItems = ['MIS'];
                                        _productType = 'MIS';
                                        _orderValidityItems = ['DAY'];
                                        _validityType = 'DAY';
                                      } else {
                                        _productItems = ['NRML', 'CNC', 'MIS', 'MTF'];
                                        _productType = 'MIS';
                                        _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD'];
                                        _validityType = 'DAY';
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _isCoverOrder
                                          ? widget.isBuy
                                              ? Utils.brightGreenColor.withOpacity(0.4)
                                              : Utils.brightRedColor.withOpacity(0.4)
                                          : Colors.transparent,
                                    ),
                                    child: Text('COVER', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Utils.blackColor)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _orderTypeController.value = false;
                                      _isBracketOrder = !_isBracketOrder;
                                      _isCoverOrder = false;
                                      _isSLTPOrder = false;
                                      _discQtyContoller.text = '0';
                                      if (_isBracketOrder) {
                                        _productItems = ['MIS'];
                                        _productType = 'MIS';
                                        _orderValidityItems = ['DAY'];
                                        _validityType = 'DAY';
                                      } else {
                                        _productItems = ['NRML', 'CNC', 'MIS', 'MTF'];
                                        _productType = 'MIS';
                                        _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD'];
                                        _validityType = 'DAY';
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _isBracketOrder
                                          ? widget.isBuy
                                              ? Utils.brightGreenColor.withOpacity(0.4)
                                              : Utils.brightRedColor.withOpacity(0.4)
                                          : Colors.transparent,
                                    ),
                                    child: Text('BRACKET', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Utils.blackColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: _isSLTPOrder,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Text(
                                  'SL TRIGGER PRICE',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       'SL TRIGGER PRICE',
                                //       style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                //     ),
                                //     Spacer(),
                                //     ToggleSwitch(
                                //       switchController: _orderTypeController,
                                //       isBorder: true,
                                //       activeColor: Utils.whiteColor,
                                //       inactiveColor: Utils.whiteColor,
                                //       thumbColor: Utils.blackColor,
                                //     ),
                                //     const SizedBox(width: 10),
                                //     Text(
                                //       'MARKET',
                                //       style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                NumberField(
                                  setDefault: false,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _triggerController,
                                  hint: 'SL Trigger Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  maxLength: 10,
                                  decimalPosition: 2,
                                ),
                              ],
                            )),
                        Visibility(
                            visible: _isCoverOrder,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Text(
                                  'TRIGGER PRICE',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                ),
                                const SizedBox(height: 10),
                                NumberField(
                                  setDefault: false,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _coverTriggerController,
                                  hint: 'Trigger Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  maxLength: 10,
                                  decimalPosition: 2,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Range', style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: Utils.blackColor, textDecoration: TextDecoration.underline)),
                                    IconButton(
                                      icon: !_isCoverRangeOpen ? SvgPicture.asset('assets/appImages/arrow.svg') : RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/appImages/arrow.svg')),
                                      onPressed: () {
                                        setState(() {
                                          _isCoverRangeOpen = !_isCoverRangeOpen;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: _isCoverRangeOpen,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Utils.lightGreyColor.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('BUY', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.brightGreenColor)),
                                            Text(coverBuyRange, style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.blackColor)),
                                            Text('3%', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Utils.lightGreyColor.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('SELL', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.brightRedColor)),
                                            Text(coverSellRange, style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.blackColor)),
                                            Text('3%', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: _isBracketOrder,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Text(
                                  'SQUARE OFF',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                ),
                                const SizedBox(height: 10),
                                NumberField(
                                  setDefault: false,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _squareOffTextController,
                                  hint: 'Square Off',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  maxLength: 10,
                                  decimalPosition: 2,
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  'STOP LOSS',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                ),
                                const SizedBox(height: 10),
                                NumberField(
                                  setDefault: false,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _slBracketTextController,
                                  hint: 'SL Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  maxLength: 10,
                                  decimalPosition: 2,
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  'TRAIL STOP LOSS',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                ),
                                const SizedBox(height: 10),
                                NumberField(
                                  setDefault: false,
                                  doubleIncrement: widget.model.incrementTicksize(),
                                  numberController: _trailSLTextController,
                                  hint: 'Trail Stop Loss Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  maxLength: 10,
                                  decimalPosition: 2,
                                ),
                              ],
                            )),
                        const SizedBox(height: 25),
                        Text(
                          'DISCLOSED QUANTITY',
                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                        ),
                        const SizedBox(height: 10),
                        NumberField(
                          setDefault: false,
                          doubleIncrement: widget.model.incrementTicksize(),
                          maxLength: 6,
                          numberController: _discQtyContoller,
                          hint: 'Disclosed Quantity',
                          isBuy: widget.isBuy,
                          isRupeeLogo: false,
                          isDisable: _validityType == 'IOC' || _isCoverOrder || _isBracketOrder || _isSLTPOrder ? true : false,
                          isInteger: true,
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ORDER VALIDITY', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                            ToggleSwitch(
                              switchController: _afterMarketController,
                              isBorder: true,
                              activeColor: Utils.whiteColor,
                              inactiveColor: Utils.whiteColor,
                              thumbColor: Utils.blackColor,
                            ),
                            Text(
                              'AFTER MARKET ORDER',
                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 55,
                          width: size.width,
                          padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1)),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              items: _orderValidityItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                                  ),
                                );
                              }).toList(),
                              underline: SizedBox(),
                              hint: Text(
                                _validityType,
                                style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                              ),
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Theme.of(context).textTheme.bodyText1.color, // Add this
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _validityType = val;
                                  if (val == 'GTC' || val == 'GTD') {
                                    _productItems = ['CNC'];
                                    _orderTypeController.value = false;
                                  } else if (_isCoverOrder || _isBracketOrder) {
                                    _productItems = ['MIS'];
                                  } else if(val == 'GTT'){
                                    _productType = 'CNC';
                                    _productItems = ['NRML', 'CNC', 'MTF'];
                                  }else {
                                    _productItems = ['NRML', 'CNC', 'MIS', 'MTF'];
                                  }
                                });
                              }),
                        ),
                        Visibility(
                            visible: _validityType == 'GTD',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Text('DATE', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                                const SizedBox(height: 10),
                                Container(
                                  height: 55,
                                  width: size.width,
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedFormatDate,
                                        style: Utils.fonts(size: 20.0, color: theme.textTheme.bodyText1.color),
                                      ),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 15),
                                          decoration: BoxDecoration(
                                              color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.4) : Utils.brightRedColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                                          child: GestureDetector(
                                            child: InkWell(
                                              child: SvgPicture.asset(
                                                'assets/appImages/showCalendar.svg',
                                                color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   color: Colors.blue,
                        //   height: 200,
                        //   width: double.infinity,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  await Dataconstants.brokerageController.getBrokerage(widget.model.series, widget.isBuy ? "B" : "S", widget.model.exch == "N" ? "NSE" : "BSE", "E", widget.model.name,
                      widget.model.strikePrice, _productType, "", "", _qtyContoller.text, _orderTypeController.value ? widget.model.close : _limitController.text, 5000);
                  showModalBottomSheet(isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => BrokerageBottomSheet());
                },
                child: Text(
                  'Brokerage Charges',
                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color, textDecoration: TextDecoration.underline),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => OrderSummaryDetails(
                            isBuy: widget.isBuy,
                            model: widget.model,
                            qty: _qtyContoller.text,
                            productType: _isCoverOrder
                                ? 'CO'
                                : _isBracketOrder
                                    ? 'BO'
                                    : _productType,
                            isAdvanced: isOpen,
                            orderType: _isSLTPOrder
                                ? "STOP LOSS"
                                : _isBracketOrder
                                    ? "BRACKET"
                                    : "COVER",
                            limitPrice: _orderTypeController.value == true ? '0' : _limitController.text,
                            slTriggerPrice: _isSLTPOrder ? _triggerController.text : "",
                            dislosedQty: _isCoverOrder || _isBracketOrder
                                ? ''
                                : _discQtyContoller.text != null
                                    ? _discQtyContoller.text
                                    : '',
                            validty: _validityType,
                            coverTriggerPrice: _isCoverOrder ? _coverTriggerController.text : "",
                            buyRange: _isCoverOrder ? coverBuyRange : "",
                            sellRange: _isCoverOrder ? coverSellRange : "",
                            afterMarketOrder: _afterMarketController.value,
                            squareOff: _isBracketOrder ? _squareOffTextController.text : "",
                            boStopLoss: _isBracketOrder ? _slBracketTextController.text : "",
                            trailStopLoss: _isBracketOrder ? _trailSLTextController.text : "",
                            swipeAction: swipeToAction(size, theme, 1.0),
                          ));
                },
                child: Text(
                  'Order Summary',
                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color, textDecoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
        swipeToAction(size, theme, 0.85),
        // Visibility(
        //   visible: Dataconstants.showOrderFormKeyboard,
        //   child: NumPad(
        //     isInt: _isInt,
        //     controller: _numPadController,
        //     delete: () {
        //       var cursorPos = _numPadController.selection.base.offset;
        //       // //print('cursorPos -- $cursorPos');
        //       _numPadController.text = _numPadController.text.substring(0, cursorPos - 1) + _numPadController.text.substring(cursorPos, _numPadController.text.length);
        //       _numPadController.value = _numPadController.value.copyWith(selection: TextSelection.fromPosition(TextPosition(offset: cursorPos - 1)));
        //       // _numPadController.text =
        //       //     _numPadController.text.substring(0, _numPadController.text.length - 1);
        //     },
        //     onSubmit: () {
        //       setState(() {
        //         Dataconstants.showOrderFormKeyboard = false;
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget swipeToAction(Size size, ThemeData theme, double width) {
    return Container(
      width: size.width * width,
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
        child: Text('CLICK TO ${widget.isBuy ? 'BUY' : 'SELL'}'),
      ),
      // SliderButton(
      //   height: 55,
      //   width: size.width * width - 0.05,
      //   text: 'SWIPE TO '
      //       '${widget.orderType == ScripDetailType.positionExit ? 'SQUAREOFF' : widget.isBuy ? widget.orderType == ScripDetailType.modify ? 'MODIFY BUY' : 'BUY' : widget.orderType == ScripDetailType.modify ? 'MODIFY SELL' : 'SELL'}',
      //   textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
      //   backgroundColorEnd: theme.cardColor,
      //   backgroundColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   foregroundColor: Utils.whiteColor,
      //   iconColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   icon: Icons.double_arrow,
      //   shimmer: false,
      //   // shimmerHighlight: Utils.whiteColor,
      //   // shimmerBase: Utils.whiteColor,
      //   onConfirmation: () async {
      //     processPlace();
      //   },
      // ),

      // child: SliderButton(
      //   height: 55,
      //   width: size.width * width - 0.05,
      //   text: 'SWIPE TO '
      //       '${widget.orderType == ScripDetailType.positionExit ? 'SQUAREOFF' : widget.isBuy ? widget.orderType == ScripDetailType.modify ? 'MODIFY BUY' : 'BUY' : widget.orderType == ScripDetailType.modify ? 'MODIFY SELL' : 'SELL'}',
      //   textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
      //   backgroundColorEnd: theme.cardColor,
      //   backgroundColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   foregroundColor: Utils.whiteColor,
      //   iconColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
      //   icon: Icons.double_arrow,
      //   shimmer: false,
      //   // shimmerHighlight: Utils.whiteColor,
      //   // shimmerBase: Utils.whiteColor,
      //   onConfirmation: () async {
      //     processPlace();
      //   },
      // ),
    );
  }

/* Function to calcutale Required Margin */
  String calculateRequiredMargin(ScripInfoModel model) {
    double result;
    int qty = int.tryParse(_qtyContoller.text);
    double limit = !_orderTypeController.value ? double.tryParse(_limitController.text) : model.close;
    if (qty == null || limit == null)
      return 0.toStringAsFixed(model.precision);
    else {
      result = qty * limit;
      return result.toStringAsFixed(model.precision);
    }
  }

  void processPlace() async {
    if (Dataconstants.passwordChangeRequired) {
      CommonFunction.changePasswordPopUp(context, Dataconstants.passwordChangeMessage);
      return;
    }
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be zero');
      return;
    }
    if (_isSLTPOrder) _discQtyContoller.text = '0';
    int dQty = int.tryParse(_discQtyContoller.text) ?? 0;
    int qty = int.tryParse(_qtyContoller.text) ?? 1;
    double limit = double.tryParse(_limitController.text) ?? 0.0;
    double trigger = double.tryParse(_triggerController.text) ?? 0.0;
    List<String> val = _limitController.text.split('.');
    // //print('this is val => $val');
    if (val.length > 1) {
      if (val[1].length == 1) _limitController.text += '0';
    } else {
      _limitController.text += '.00';
    }
    if (!_orderTypeController.value && !CommonFunction.isValidTickSize(_limitController.text, widget.model)) {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
      return;
    }
    List<String> val2 = _triggerController.text.split('.');
    // //print('this is val2 => $val2');
    if (val2.length > 1) {
      if (val2[1].length == 1) _triggerController.text += '0';
    } else {
      _triggerController.text += '.00';
    }
    if (_isSLTPOrder && !CommonFunction.isValidTickSize(_triggerController.text, widget.model)) {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
      return;
    }
    if (_limitController.text == '0.00' && !_orderTypeController.value) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Please Enter Valid Price');
      return;
    }
    if (_limitController.text == '' && !_orderTypeController.value) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Price field cannot be blank');
      return;
    }
    if (!_orderTypeController.value &&
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
              'The Limit Price is outside the limit defined by exchange. Limit Price should fall between ${widget.model.lowerCktLimit.toStringAsFixed(2)} - ${widget.model.upperCktLimit.toStringAsFixed(2)}');
      return;
    }
    //-----------> Updated <--------------------

    if (_isSLTPOrder && _triggerController.text.isEmpty) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
      return;
    }
    //-----------> Updated <--------------------

    if (_isSLTPOrder && _triggerController.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be zero');
      return;
    }
    //-----------> Updated <--------------------

    if (_isSLTPOrder && _triggerController.text[0] == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot start with zero');
      return;
    }

    if (_isSLTPOrder &&
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
              'Trigger Price is outside the limit defined by exchange. Trigger Price should fall between ${widget.model.lowerCktLimit.toStringAsFixed(2)} - ${widget.model.upperCktLimit.toStringAsFixed(2)}');
      return;
    }

    //------------------------> S/M (Market) Order Logic <---------------------------------------------

    // if (widget.isBuy) {
    //   if (_isSLTPOrder &&
    //       double.parse(_triggerController.text) <
    //           double.parse(widget.model.close.toString())) {
    //     CommonFunction.showSnackBarKey(
    //         key: _scaffoldKey,
    //         color: Colors.red,
    //         context: context,
    //         text: 'Trigger Price should be greater than LTP');
    //     return;
    //   }
    // } else {
    //   if (_isSLTPOrder &&
    //       double.parse(_triggerController.text) >
    //           double.parse(widget.model.close.toString())) {
    //     CommonFunction.showSnackBarKey(
    //         key: _scaffoldKey,
    //         color: Colors.red,
    //         context: context,
    //         text: 'Trigger Price should be less than LTP');
    //     return;
    //   }
    // }

    //---------------------> S/L (Limit) Order Logic<---------------------

    if (widget.isBuy) {
      if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) >= double.parse(_limitController.text)) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be less than limit price');
        return;
      }
    } else {
      if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) <= double.parse(_limitController.text)) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be greater than limit price');
        return;
      }
    }

    if (dQty < 0) _discQtyContoller.text = '0';

    if (dQty > 0 && widget.orderType == ScripDetailType.modify) {
      if (dQty > qty) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
        return;
      }
      if (dQty > 0) {
        int minDQ = (0.1 * qty).round();
        if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
        if (dQty < minDQ) {
          CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
          return;
        }
      }
      if (dQty > 0) {
        int minDQ = (0.1 * (qty - widget.orderModel.qty)).round();
        if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
        if (dQty < minDQ) {
          CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
          return;
        }
      }
    } else if (dQty > 0) {
      if (dQty > qty) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity cannot exceed Order Quantity');
        return;
      }
      if (dQty > 0) {
        int minDQ = (0.1 * qty).ceil();
        if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
        if (dQty < minDQ) {
          CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
          return;
        }
      }
    }
    if (widget.model.exch == 'N') {
      bool check = false;
      if (widget.orderModel != null) check = (qty + widget.orderModel.qty) == dQty;
      if (qty == dQty || check) _discQtyContoller.text = '0';
    }
    if (qty < 1) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Order Quantity');
      return;
    }
    if (!_orderTypeController.value && limit < 0.01) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Limit Price');
      return;
    }
    if (_isSLTPOrder && trigger < 0.01) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Trigger Price');
      return;
    }
    if (!_orderTypeController.value && _isSLTPOrder) {
      if (widget.isBuy && trigger > limit) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be greater than Limit Price');
        return;
      } else if (!widget.isBuy && trigger < limit) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price cannot be greater than Trigger Price');
        return;
      }
    }
    if (qty > Dataconstants.maxOrderQty) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order Qty allowed is ${Dataconstants.maxOrderQty}');
      return;
    }
    if (qty * limit > Dataconstants.maxCashOrderValue) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Cash Order value allowed is Rs. ${Dataconstants.maxCashOrderValue}');
      return;
    }
    if (_isCoverOrder) {
      double upperBuyRange, lowerBuyRange, upperSellRange, lowerSellRange;
      upperBuyRange = double.parse(coverBuyRange.split(" ")[2]);
      lowerBuyRange = double.parse(coverBuyRange.split(" ")[0]);
      upperSellRange = double.parse(coverSellRange.split(" ")[2]);
      lowerSellRange = double.parse(coverSellRange.split(" ")[0]);
      if (_coverTriggerController.text.isEmpty) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price cannot be empty');
        return;
      }
      if (!widget.isBuy) {
        if (!_orderTypeController.value) {
          if (limit <= lowerSellRange || limit >= upperSellRange) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Sell Order Price should be within sell price range');
            return;
          }
          if (double.tryParse(_coverTriggerController.text) <= double.parse(_limitController.text)) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than sell order price');
            return;
          }
        } else {
          if (double.tryParse(_coverTriggerController.text) <= widget.model.close) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than LTP');
            return;
          }
        }
      } else {
        if (!_orderTypeController.value) {
          if (limit <= lowerBuyRange || limit >= upperBuyRange) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Buy Order Price should be within buy price range');
            return;
          }
          if (double.tryParse(_coverTriggerController.text) >= double.parse(_limitController.text)) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than buy order price');
            return;
          }
        } else {
          if (double.tryParse(_coverTriggerController.text) >= widget.model.close) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than LTP');
            return;
          }
        }
      }
    }
    if (_isBracketOrder) {
      if (_squareOffTextController.text.isEmpty || _squareOffTextController.text == '') {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price cannot be blank');
        return;
      }
      if (!CommonFunction.isValidTickSize(_squareOffTextController.text, widget.model)) {
        CommonFunction.showSnackBarKey(
            key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
        return;
      }
      if (_slBracketTextController.text.isEmpty || _slBracketTextController.text == '') {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
        return;
      }
      // // if (_trailSLTextController.text.isEmpty || _trailSLTextController.text == '') {
      // //   CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trail Stoploss Price cannot be blank');
      // //   return;
      // // }
      // var squareOff = double.parse(_squareOffTextController.text) ?? 0.0;
      // var trigger = double.parse(_slBracketTextController.text) ?? 0.0;
      // var trailSltp = double.parse(_trailSLTextController.text) ?? 0.0;
      // if (widget.isBuy) {
      //   if (squareOff <= limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price should be greater than Limit Price');
      //     return;
      //   }
      //   if (trigger >= limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be less than Limit Price');
      //     return;
      //   }
      //   if (trigger + trailSltp < limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trail Stoploss Price should be greater than or equal to Limit Price');
      //     return;
      //   }
      // } else {
      //   if (squareOff >= limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price should be less than Limit Price');
      //     return;
      //   }
      //   if (trigger <= limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be greater than Limit Price');
      //     return;
      //   }
      //   if (trigger - trailSltp > limit) {
      //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trail Stoploss Price should be less than or equal to Limit Price');
      //     return;
      //   }
      // }
    }
    if (_validityType == 'GTC' || _validityType == 'GTD') {
      if (qty * limit < 10000) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order value allowed for GTD/GTC is Rs. 10000');
        return;
      }
    }
    if (_productType == 'MTF') {
      if (widget.model.exch == 'B') {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'MTF product is not allowed for BSE segment');
        return;
      }
    }
    if (_isBracketOrder) {
      // var jsons = {
      // "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
      // "symboltoken": widget.model.exchCode.toString(),
      // "transactiontype": widget.isBuy ? "BUY" : "SELL",
      // "quantity": _qtyContoller.text,
      // "duration": _validityType.toUpperCase(),
      // "disclosedquantity": _discQtyContoller.text,
      // "price": !_orderTypeController.value ? _limitController.text : "0",
      // "LTP": widget.model.close.toStringAsFixed(2),
      // "SqrOffAbsOrticks": "Absolute",
      // "squareoff": _squareOffTextController.text,
      // "SLAbsOrticks": "Absolute",
      // // "targetprice": "100",
      // "stoploss": _slBracketTextController.text,
      // "trailingSL": _trailSLTextController.text,
      // "tSLticks": "N",
      // "orderSource": "MOB",
      // "userTag": "MOB"
      // };
      var jsons = {
        "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
        "symboltoken": widget.model.exchCode.toString(),
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "quantity": _qtyContoller.text,
        "duration": _validityType.toUpperCase(),
        "disclosedquantity": _discQtyContoller.text,
        "price": !_orderTypeController.value ? _limitController.text : "0",
        "ltporatp": "LTP",
        "squareofftype": "Absolute",
        "squareoffvalue": _squareOffTextController.text,
        "stoplosstype": "Absolute",
        "stoplossvalue": _slBracketTextController.text,
        "trailingstoplossflag": _trailSLTextController.text.isEmpty || _trailSLTextController.text == '' ? "N" : "Y",
        "trailingstoplossvalue": _trailSLTextController.text,
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
          }
        }
      } catch (e) {}
    } else if (_validityType == 'GTC' || _validityType == 'GTD') {
      var jsons = {
        "tradingsymbol": widget.model.tradingSymbol,
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
        "ordertype": "LIMIT",
        "producttype": _productType,
        "duration": _validityType.toUpperCase(),
        "price": _limitController.text,
        "quantity": _qtyContoller.text,
        "triggerprice": "0.00",
        "datedays": _validityType == 'GTD' ? selectedFormatDate.replaceAll("/", '-') : '',
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
          }
        }
      } catch (e) {}
    } else {
      var jsons = {
        "variety": _afterMarketController.value == true ? "AMO" : "NORMAL",
        "tradingsymbol": widget.model.tradingSymbol,
        "symboltoken": widget.model.exchCode.toString(),
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "exchange": widget.model.exch == "N" ? "NSE" : "BSE",
        "ordertype": _isSLTPOrder
            ? !_orderTypeController.value
                ? "STOPLOSS_LIMIT"
                : "STOPLOSS_MARKET"
            : !_orderTypeController.value
                ? "LIMIT"
                : "MARKET",
        "producttype": _isCoverOrder ? 'COVER' : _productType.toUpperCase(),
        "duration": _validityType.toUpperCase(),
        "price": !_orderTypeController.value ? _limitController.text : "0",
        "squareoff": "0",
        "stoploss": "0",
        "quantity": _qtyContoller.text,
        "disclosedquantity": _discQtyContoller.text,
        "triggerprice": _isSLTPOrder
            ? _triggerController.text
            : _isCoverOrder
                ? _coverTriggerController.text
                : "0.00"
      };
      log(jsons.toString());
      var response = await CommonFunction.placeOrder(jsons);
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
          }
        }
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    _qtyContoller.dispose();
    _limitController.dispose();
    _triggerController.dispose();
    _discQtyContoller.dispose();
    _orderTypeController.dispose();
    _afterMarketController.dispose();
    Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, false);
    Dataconstants.scripInfoQty = '';
    Dataconstants.scripInfoPrice = '';
    Dataconstants.scripInfoProduct = '';
    super.dispose();
  }
}

class BrokerageBottomSheet extends StatefulWidget {
  const BrokerageBottomSheet({Key key}) : super(key: key);

  @override
  State<BrokerageBottomSheet> createState() => _BrokerageBottomSheetState();
}

class _BrokerageBottomSheetState extends State<BrokerageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.only(
          top: 0,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Brokerage",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Text(BrokerageController.brokerageVal == null || BrokerageController.brokerageVal == '' ? "-" : "\u{20B9} ${BrokerageController.brokerageVal.toString()}"),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Securities Transaction Tax (STT)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Text(BrokerageController.secCharge == null || BrokerageController.secCharge == '' ? "-" : "\u{20B9} ${BrokerageController.secCharge.toString()}"),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction Charges",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Text(BrokerageController.transCharge == null || BrokerageController.transCharge == '' ? "-" : "\u{20B9} ${BrokerageController.transCharge.toString()}"),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stamp Duty",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Text(BrokerageController.stampduty == null || BrokerageController.stampduty == '' ? "-" : "\u{20B9} ${BrokerageController.stampduty.toString()}"),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SEBI Fees",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Text(BrokerageController.sebiTax == null || BrokerageController.sebiTax == '' ? "-" : "\u{20B9} ${BrokerageController.sebiTax.toString()}"),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "GST (On Brokerage, Transaction Charges\n& SEBI Fees)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  )),
                  Text(BrokerageController.gst == null ? "-" : "\u{20B9} ${BrokerageController.gst.toString()}"),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                  ),
                  // Text(
                  //     BrokerageController.gst == null ||
                  //         BrokerageController.gst == '' ||
                  //         BrokerageController.stampduty == '' ||
                  //         BrokerageController.stampduty == null ||
                  //         BrokerageController.sebiTax == null ||
                  //         BrokerageController.sebiTax == '' ||
                  //         BrokerageController.brokerageVal == null ||
                  //         BrokerageController.brokerageVal == '' ||
                  //         BrokerageController.secCharge == null ||
                  //         BrokerageController.secCharge == '' ||
                  //         BrokerageController.transCharge == null ||
                  //         BrokerageController.transCharge == ''
                  // ? "-"
                  //     : (double.parse(BrokerageController.gst) +
                  //             double.parse(BrokerageController.stampduty ?? 0) +
                  //             double.parse(BrokerageController.sebiTax ?? 0) +
                  //             double.parse(BrokerageController.brokerageVal ?? 0) +
                  //             double.parse(BrokerageController.secCharge ?? 0) +
                  //             double.parse(BrokerageController.transCharge ?? 0))
                  //         .toStringAsFixed(2)),
                  Text(
                      "₹ ${((BrokerageController.gst == null || BrokerageController.gst == ''
                          ? 0
                          : double.parse(BrokerageController.gst))
                            + (BrokerageController.stampduty == ''
                              || BrokerageController.stampduty == null ? 0 : double.parse(BrokerageController.stampduty)) + (BrokerageController.sebiTax == null || BrokerageController.sebiTax == '' ? 0 : double.parse(BrokerageController.sebiTax)) + (BrokerageController.brokerageVal == null || BrokerageController.brokerageVal == '' ? 0 : double.parse(BrokerageController.brokerageVal)) + (BrokerageController.secCharge == null || BrokerageController.secCharge == '' ? 0 : double.parse(BrokerageController.secCharge)) + (BrokerageController.transCharge == null || BrokerageController.transCharge == '' ? 0 : double.parse(BrokerageController.transCharge))).toStringAsFixed(2)}"),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: [
                  Flexible(
                      child: Text(
                    "Disclaimer: Information in Charges is approximate, not actual. Refer to contract note emailed for exact prices, fees & charges for trades executed. DP charges is inclusive of GST.",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
                  )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
