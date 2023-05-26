import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/limitController.dart';
import '../../../controllers/orderBookController.dart';
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

class ModifyCurrencyOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  final ScripDetailType orderType;
  final bool isBuy;
  final ExistingNewOrderDetails orderModel;
  final Stream<bool> stream;

  ModifyCurrencyOrderScreen({
    @required this.model,
    @required this.orderType,
    @required this.isBuy,
    this.orderModel,
    this.stream,
  });

  @override
  State<ModifyCurrencyOrderScreen> createState() => _ModifyCurrencyOrderScreenState();
}

class _ModifyCurrencyOrderScreenState extends State<ModifyCurrencyOrderScreen> {
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _orderTypeController = ValueNotifier<bool>(false), _afterMarketController = ValueNotifier<bool>(false);
  List<String> _productItems = ['NRML', 'MIS'], _orderValidityItems = ['DAY', 'IOC'];
  bool _isInt, isOpen = false, _isSLTPOrder = false, _isCoverOrder = false, _isBracketOrder = false, _isCoverRangeOpen = false, _isQtyDisabled = false, disableSLTP = false;
  String _productType, _validityType, _limitValue, coverBuyRange = '', coverSellRange = '', selectedFormatDate;
  int _disableBracket = 0;
  TextEditingController _qtyContoller,
      _limitController,
      _triggerController,
      _discQtyContoller,
      _coverTriggerController,
      _squareOffTextController,
      _slBracketTextController,
      _trailSLTextController,
      _numPadController = TextEditingController();
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
    _orderTypeController.addListener(() {
      setState(() {
        if (_orderTypeController.value == true) {
          _limitValue = _limitController.text;
          _limitController.text = '0';
        } else {
          _limitController.text = _limitValue;
        }
      });
      if (widget.orderType == ScripDetailType.modify && _isCoverOrder == true && widget.orderModel.isLimit.contains('STOPLOSS')) {
        setState(() {
          _orderTypeController.value = false;
        });
      }
      if (widget.orderType == ScripDetailType.modify && _isBracketOrder == true && widget.orderModel.syomorderid != '') {
        setState(() {
          _orderTypeController.value = true;
        });
      }
    });
    _afterMarketController.addListener(() {
      setState(() {
        _afterMarketController.value = false;
      });
    });
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
    _qtyContoller.text = widget.model.exchCategory == ExchCategory.nseFuture ? InAppSelection.futureDefaultQty.toString() : InAppSelection.optionDefaultQty.toString();
    _limitController.text = CommonFunction.getMarketRate(widget.model, widget.isBuy).toStringAsFixed(widget.model.precision);
    _triggerController.text = '';
    _coverTriggerController.text = '';
    _squareOffTextController.text = '';
    _slBracketTextController.text = '';
    _trailSLTextController.text = '';
    _discQtyContoller.text = '0';
    selectedFormatDate = formatter.format(DateTime.now());
    if (widget.orderType == ScripDetailType.modify) {
      _qtyContoller.text = (widget.orderModel.qty - widget.orderModel.tradedQty).toString();
      _orderTypeController.value = widget.orderModel.isLimit == 'MARKET' || widget.orderModel.isLimit == 'STOPLOSS_MARKET' ? true : false;
      if (!_orderTypeController.value)
        /* Fetching limit value from the model and assigning it to its testfield*/
        _limitController.text = widget.orderModel.rate.toStringAsFixed(widget.model.precision);
      /* if order slTriggered is Triggered and its an isSL order then the order should converted to RL (regular order)*/
      if (widget.orderModel.slTriggered && widget.orderModel.isSL) {
      } else {
        /* if order not Triggered or its an sl(isSL) order then order should follow StopLoss*/
        _isSLTPOrder = widget.orderModel.isSL;
      }

      if (_isSLTPOrder)
        /* Fetching trigger value from the model and assigning it to its testfield*/
        _triggerController.text = widget.orderModel.triggerRate.toStringAsFixed(widget.model.precision);

      /* setting it wheather it is intraday or delivery */
      _productType = widget.orderModel.productType == 'COVER' || widget.orderModel.productType == 'BRACKET' ? 'MIS' : widget.orderModel.productType;
      _validityType = widget.orderModel.validity;
      if (widget.orderModel.isSL) _validityType = 'DAY';
      _productItems = [_productType];
      if (_validityType == 'DAY' || _validityType == 'IOC')
        _orderValidityItems = ['DAY', 'IOC'];
      else if (_validityType == 'GTC') _orderValidityItems = ['GTC'];
      else if (_validityType == 'GTD') _orderValidityItems = ['GTD'];
      if(_validityType == 'GTC' || _validityType == 'GTD') {
        isOpen = true;
        _isSLTPOrder = false;
        disableSLTP = true;
        if(_validityType == 'GTD') selectedFormatDate = widget.orderModel.gtdValdate;
      }
      if (widget.orderModel.productType == 'COVER') {
        isOpen = true;
        _isCoverOrder = true;
        _coverTriggerController.text = widget.orderModel.triggerRate.toString();
        _orderTypeController.value = widget.orderModel.isLimit == 'STOPLOSS_MARKET' ? true : false;
        _validityType = 'DAY';
        _orderValidityItems = ['DAY'];
        _isSLTPOrder = false;
        if (widget.orderModel.isLimit.contains('STOPLOSS')) _isQtyDisabled = true;
      }
      if (widget.orderModel.productType == 'BRACKET') {
        isOpen = true;
        _isBracketOrder = true;
        _validityType = 'DAY';
        _orderValidityItems = ['DAY'];
        _isSLTPOrder = false;
        if (widget.orderModel.syomorderid != "") {
          // Bracket order 2nd leg
          _isQtyDisabled = true;
          _limitController.text = '0.0';
          _disableBracket = 1;
          _orderTypeController.value = true;
          if (widget.orderModel.isLimit.contains('STOPLOSS')) {
            _disableBracket = 2;
            _squareOffTextController.text = '0.0';
            _slBracketTextController.text = widget.orderModel.triggerRate.toString();
          } else {
            _disableBracket = 3;
            _squareOffTextController.text = widget.orderModel.rate.toStringAsFixed(widget.model.precision);
            _slBracketTextController.text = '0.0';
          }
        }
      }
      if (widget.orderType == ScripDetailType.modify) isOpen = true;
    } else if (widget.orderType == ScripDetailType.positionExit) {
      _qtyContoller.text = widget.orderModel.qty.toString();
      _productType = widget.orderModel.productType == 'COVER' ? 'MIS' : widget.orderModel.productType;
      _validityType = widget.orderModel.validity;
      _orderValidityItems = [_validityType];
      _productItems = widget.orderModel.productType == 'COVER' || widget.orderModel.productType == 'BRACKET' ? [_productType] : ['NRML', 'CNC', 'MIS'];
      if (widget.orderModel.productType != 'COVER' || widget.orderModel.productType != 'BRACKET') disableSLTP = true;
    }
    super.initState();
  }

  void _updateSeconds() {
    if (mounted) setState(() {});
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final picked = await showDatePicker(
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Utils.primaryColor, onPrimary: Utils.whiteColor, onSurface: Utils.primaryColor)), child: child);
  //       },
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       selectedFormatDate = formatter.format(selectedDate);
  //     });
  //   }
  // }

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
                    increment: widget.model.minimumLotQty,
                    hint: 'Quantity',
                    isInteger: true,
                    isBuy: widget.isBuy,
                    isRupeeLogo: false,
                    isDisable: _isQtyDisabled ? true : false,
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
                        maxLength: 10,
                        numberController: _limitController,
                        hint: 'Limit',
                        isBuy: widget.isBuy,
                        isRupeeLogo: true,
                        isDisable: _isBracketOrder
                            ? _disableBracket == 0
                                ? false
                                : true
                            : _orderTypeController.value
                                ? true
                                : false,
                        decimalPosition: 2,
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
                              _productType == 'MIS' ? 'Intraday' : 'Overnight',
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
                            if (_isCoverOrder || _isBracketOrder)
                              _orderValidityItems = ['DAY'];
                            else if (val == 'NRML' || val == 'MIS')
                              _orderValidityItems = ['DAY', 'IOC'];
                            else
                              _orderValidityItems = ['DAY', 'IOC', 'GTC', 'GTD'];
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
                                    if (widget.orderModel.productType != 'COVER' && widget.orderModel.productType != 'BRACKET' && !disableSLTP) {
                                      setState(() {
                                        _isSLTPOrder = !_isSLTPOrder;
                                      });
                                    }
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
                                    child: Text('STOP LOSS',
                                        style: Utils.fonts(
                                            size: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: (widget.orderModel.productType == 'COVER' || widget.orderModel.productType == 'BRACKET' || disableSLTP)
                                                ? Utils.greyColor.withOpacity(0.5)
                                                : Utils.blackColor)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (widget.orderModel.productType == 'COVER') {
                                      // setState(() {
                                      //   _isCoverOrder = !_isCoverOrder;
                                      // });
                                    }
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
                                    child: Text('COVER',
                                        style: Utils.fonts(
                                            size: 14.0, fontWeight: FontWeight.w500, color: widget.orderModel.productType != 'COVER' ? Utils.greyColor.withOpacity(0.5) : Utils.blackColor)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (widget.orderModel.productType == 'BRACKET') {
                                      //setState(() {
                                     //   _isBracketOrder = !_isBracketOrder;
                                     // });
                                    }
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
                                    child: Text('BRACKET',
                                        style: Utils.fonts(
                                            size: 14.0, fontWeight: FontWeight.w500, color: widget.orderModel.productType != 'BRACKET' ? Utils.greyColor.withOpacity(0.5) : Utils.blackColor)),
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
                                  maxLength: 10,
                                  numberController: _triggerController,
                                  hint: 'SL Trigger Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  decimalPosition: 4,
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
                                  maxLength: 10,
                                  numberController: _coverTriggerController,
                                  hint: 'Trigger Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  decimalPosition: 4,
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
                                  maxLength: 10,
                                  numberController: _squareOffTextController,
                                  hint: 'Square Off',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  decimalPosition: 4,
                                  isDisable: _isBracketOrder
                                      ? _disableBracket == 2 || _disableBracket == 0
                                          ? true
                                          : false
                                      : false,
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
                                  maxLength: 10,
                                  numberController: _slBracketTextController,
                                  hint: 'SL Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  decimalPosition: 4,
                                  isDisable: _isBracketOrder
                                      ? _disableBracket == 3 || _disableBracket == 0
                                          ? true
                                          : false
                                      : false,
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
                                  maxLength: 10,
                                  numberController: _trailSLTextController,
                                  hint: 'Trail Stop Loss Price',
                                  isBuy: widget.isBuy,
                                  isRupeeLogo: false,
                                  decimalPosition: 4,
                                  isDisable: _isBracketOrder ? true : false,
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
                          isInteger: true,
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Text('ORDER VALIDITY', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                            Spacer(),
                            ToggleSwitch(
                              switchController: _afterMarketController,
                              isBorder: true,
                              activeColor: Utils.whiteColor,
                              inactiveColor: Utils.whiteColor,
                              thumbColor: Utils.blackColor,
                            ),
                            const SizedBox(width: 10),
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
                                      // GestureDetector(
                                      //   onTap: () => _selectDate(context),
                                      //   child: Container(
                                      //     padding: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 15),
                                      //     decoration: BoxDecoration(
                                      //         color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.4) : Utils.brightRedColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                                      //     child: GestureDetector(
                                      //       child: InkWell(
                                      //         child: SvgPicture.asset(
                                      //           'assets/appImages/showCalendar.svg',
                                      //           color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      limitPrice: _orderTypeController.value == true ? '0' : _limitController.text,
                      productType: _isCoverOrder
                          ? 'CO'
                          : _isBracketOrder
                              ? 'BO'
                              : _productType,
                      swipeAction: swipeToAction(size, theme, 1.0),
                    ));
          },
          child: Text(
            'Order Summary',
            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color, textDecoration: TextDecoration.underline),
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
          child: Text('${widget.orderType == ScripDetailType.positionExit ? 'SQUAREOFF' : widget.isBuy ? 'MODIFY BUY' : 'MODIFY SELL'}'),
        )
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

  void processPlace() async {
    int dQty = int.tryParse(_discQtyContoller.text) ?? 0;
    if (Dataconstants.passwordChangeRequired) {
      CommonFunction.changePasswordPopUp(context, Dataconstants.passwordChangeMessage);
      return;
    }
    int qty = int.tryParse(_qtyContoller.text) ?? widget.model.minimumLotQty;
    double limit = double.tryParse(_limitController.text) ?? 0.0;
    double trigger = double.tryParse(_triggerController.text) ?? 0.0;
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == ' ') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be blank');
      return;
    }
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be zero');
      return;
    }
    // log('ddd');
    // //log("ssssssssss   ${qty % widget.model.minimumLotQty}");
    if (!(qty % widget.model.minimumLotQty == 0)) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Order Quantity must be multiple of ${widget.model.minimumLotQty}');
      return;
    }
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

    if (dQty > 0) {
      if (qty < dQty) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed quantity cannot be greater than quantity');
        return;
      }
      int minDQ = (0.1 * qty).round();
      if (widget.model.exch == 'B') minDQ = Math.min(1000, minDQ);
      if (dQty < minDQ) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Disclosed Quantity should be atleast $minDQ');
        return;
      }
    }

    if (!widget.isBuy && _orderTypeController.value == false && limit < 0.01) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Limit Price');
      return;
    }

    if (!widget.isBuy && _isSLTPOrder && trigger < 0.01) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Trigger Price');
      return;
    }

    if (!widget.isBuy && _orderTypeController.value == false && _isSLTPOrder) {
      if (trigger < limit) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Limit Price cannot be greater than Trigger Price');
        return;
      }
    }

    //Edited by Aakash end

    if (_isSLTPOrder && _triggerController.text.isEmpty) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price cannot be blank');
      return;
    }
    //-----------> Updated <--------------------

    if (_isSLTPOrder && _triggerController.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price cannot be zero');
      return;
    }
    //-----------> Updated <--------------------
    if (_isSLTPOrder && _triggerController.text[0] == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price cannot start with zero');
      return;
    }

    //------------------------> S/M (Market) Order Logic <---------------------------------------------
    // if (widget.isBuy) {
    //   if (_isStopLoss &&
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
    //   if (_isStopLoss &&
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

    // ---------------------> S/L (Limit) Order Logic<---------------------

    if (widget.isBuy) {
      if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) >= double.parse(_limitController.text)) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: ' Trigger Price should be less than limit price');
        return;
      }
    } else {
      if (_isSLTPOrder && _orderTypeController.value == false && double.parse(_triggerController.text) <= double.parse(_limitController.text)) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price should be greater than limit price');
        return;
      }
    }
    if (_isSLTPOrder &&
        !CommonFunction.rateWithin(
          widget.model.lowerCktLimit,
          widget.model.upperCktLimit,
          trigger,
        )) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price not within reasonable limits');
      return;
    }
    if (qty < 1) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Order Quantity');
      return;
    }
    if (!_orderTypeController.value && limit < 0.01) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Limit Price');
      return;
    }
    if (_isSLTPOrder && trigger < 0.02) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Invalid Trigger Price');
      return;
    }
    if (qty > widget.model.freezQty && widget.model.exch == "CDS") {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Order Qty allowed is ${widget.model.freezQty}');
      return;
    }
    if (qty * limit > Dataconstants.maxDerivOrderValue) {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Max Deriv Order value allowed is Rs. ${Dataconstants.maxDerivOrderValue}');
      return;
    }
    if (_isCoverOrder) {
      double upperBuyRange, lowerBuyRange, upperSellRange, lowerSellRange;
      upperBuyRange = double.parse(coverBuyRange.split(" ")[2]);
      lowerBuyRange = double.parse(coverBuyRange.split(" ")[0]);
      upperSellRange = double.parse(coverSellRange.split(" ")[2]);
      lowerSellRange = double.parse(coverSellRange.split(" ")[0]);
      if (_coverTriggerController.text.isEmpty || _coverTriggerController.text == '') {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
        return;
      }
      if (_isCoverOrder && widget.orderModel.isLimit.contains('STOPLOSS')) {
        // if (widget.isBuy) {
        //   if (double.tryParse(_coverTriggerController.text) >= double.parse(widget.model.close.toStringAsFixed(2))) {
        //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than LTP');
        //     return;
        //   }
        // } else {
        //   if (double.tryParse(_coverTriggerController.text) <= double.parse(widget.model.close.toStringAsFixed(2))) {
        //     CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than LTP');
        //     return;
        //   }
        // }
      } else {
        if (!widget.isBuy) {
          if (limit <= lowerSellRange || limit >= upperSellRange) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Sell Order Price should be within sell price range');
            return;
          }
          if (_orderTypeController.value && double.tryParse(_coverTriggerController.text) <= double.parse(_limitController.text)) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than sell order price');
            return;
          } else if (!_orderTypeController.value && double.tryParse(_coverTriggerController.text) <= double.parse(widget.model.close.toStringAsFixed(2))) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be greater than sell order price');
            return;
          }
        } else {
          if (limit <= lowerBuyRange || limit >= upperBuyRange) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Buy Order Price should be within buy price range');
            return;
          }
          if (_orderTypeController.value && double.tryParse(_coverTriggerController.text) >= double.parse(_limitController.text)) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than buy order price');
            return;
          } else if (!_orderTypeController.value && double.tryParse(_coverTriggerController.text) >= double.parse(widget.model.close.toStringAsFixed(2))) {
            CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger price should be less than buy order price');
            return;
          }
        }
      }
    }
    if (_isBracketOrder) {
      if (widget.orderModel.syomorderid != '' && widget.orderModel.isLimit.contains('STOPLOSS')) {
        if (_slBracketTextController.text.isEmpty || _slBracketTextController.text == '') {
          CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Trigger Price cannot be blank');
          return;
        }
      } else {
        if (_squareOffTextController.text.isEmpty || _squareOffTextController.text == '') {
          CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price cannot be blank');
          return;
        }
        if (!CommonFunction.isValidTickSize(_squareOffTextController.text, widget.model)) {
          CommonFunction.showSnackBarKey(
              key: _scaffoldKey, color: Colors.red, context: context, text: 'Square Off Price of order is not in multiples of tick size.\nPlease select another price in multiples of 0.05');
          return;
        }
      }
    }
    if (widget.orderType == ScripDetailType.modify) {
      if (qty + widget.orderModel.tradedQty <= widget.orderModel.tradedQty) {
        CommonFunction.showSnackBarKey(
            key: _scaffoldKey, color: Colors.red, context: context, text: 'Order Qty cannot be less than or equal to already Traded Qty i.e. ${widget.orderModel.tradedQty}');
        return;
      }
      int executedIndex = OrderBookController.executedList.indexWhere((element) => element.exchorderid == widget.orderModel.exchangeOrderId);
      if (executedIndex >= 0) {
        var order = OrderBookController.executedList[executedIndex];
        if (order.model.exch == widget.model.exch && order.symboltoken == widget.model.exchCode) {
          if (OrderBookController.getCombinedTradedQty(widget.orderModel) != widget.orderModel.tradedQty) {
            CommonFunction.showSnackBarKey(
                key: _scaffoldKey,
                color: Colors.red,
                context: context,
                text: 'Traded Qty mismatch for OrderID: ${widget.orderModel.exchangeOrderId.toString()}\nThis order seems to be further partly or fully executed\nPlease exit and re login.');
            return;
          }
        }
      }
      bool noDifference = false;
      bool isLimit = widget.orderModel.isLimit == 'LIMIT' ? true : false;
      if ((widget.orderModel.qty - widget.orderModel.tradedQty) == qty && widget.orderModel.rate == limit) {
        noDifference = true;
        if (isLimit != !_orderTypeController.value) noDifference = false;
        if (widget.orderModel.isSL != _isSLTPOrder) noDifference = false;
        if (widget.orderModel.triggerRate != trigger) noDifference = false;
        if (widget.orderModel.validity == 'IOC') noDifference = false;
      }
      if (noDifference) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'No difference between current order and modified order.');
        return;
      }
    }
    if (widget.orderType == ScripDetailType.positionExit) {
      if (int.tryParse(_qtyContoller.text) > widget.orderModel.qty) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'Quantity should be less than or equal to ${widget.orderModel.qty}');
        return;
      }
    }
    if (widget.orderType == ScripDetailType.modify) {
      var jsons = {
        "variety": "NORMAL",
        "tradingsymbol": widget.model.tradingSymbol,
        "symboltoken": widget.model.exchCode.toString(),
        "exchange": widget.model.exch == "E" ? "BCD" : "CDS",
        "orderid": widget.orderModel.orderId,
        "transactiontype": widget.isBuy ? "BUY" : "SELL",
        "ordertype": _isCoverOrder && widget.orderModel.isLimit.contains('STOPLOSS')
            ? widget.orderModel.isLimit
            : _isBracketOrder && widget.orderModel.syomorderid != ''
                ? widget.orderModel.isLimit
                : _isSLTPOrder
                    ? !_orderTypeController.value
                        ? "STOPLOSS_LIMIT"
                        : "STOPLOSS_MARKET"
                    : !_orderTypeController.value
                        ? "LIMIT"
                        : "MARKET",
        "producttype": _isCoverOrder
            ? 'COVER'
            : _isBracketOrder
                ? 'BO'
                : _productType.toUpperCase(),
        "duration": _validityType.toUpperCase(),
        "price": _isBracketOrder && widget.orderModel.syomorderid != ''
            ? widget.orderModel.isLimit.contains('STOPLOSS')
                ? widget.orderModel.rate.toString()
                : _squareOffTextController.text
            : !_orderTypeController.value
                ? _limitController.text
                : "0",
        "quantity": _qtyContoller.text,
        "filledquantity": widget.orderModel.tradedQty.toString(),
        "disclosedquantity": _discQtyContoller.text,
        "triggerprice": _isBracketOrder && widget.orderModel.isLimit.contains('STOPLOSS')
            ? _slBracketTextController.text
            : _isSLTPOrder
                ? _triggerController.text
                : _isCoverOrder
                    ? _coverTriggerController.text
                    : "0.00"
      };
      log(jsons.toString());
      var response = await CommonFunction.modifyOrder(jsons);
      //log("modify Order Response => $response");
      try {
        var responseJson = json.decode(response.toString());
        if (responseJson["status"] == false) {
          CommonFunction.showBasicToast(responseJson["emsg"]);
        } else {
          Dataconstants.orderBookData.fetchOrderBook();
          HapticFeedback.vibrate();
          var data = await showDialog(
            context: context,
            builder: (_) => Material(
              type: MaterialType.transparency,
              child: OrderPlacedAnimationScreen('Order Modification requested'),
            ),
          );
          if (data['result'] == true) {
            Dataconstants.orderBookData.fetchOrderBook().then((value) {
              Navigator.pop(context);
              return showModalBottomSheet(
                  isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => OrderStatusDetails(OrderBookController.OrderBookList.value.data[0],             orderType: widget.orderType,));
            });
          }
        }
      } catch (e) {}
    } else if (widget.orderType == ScripDetailType.positionExit) {
      var jsons = {
        "exchangeseg": widget.model.exch == "E" ? "BCD" : "CDS",
        "producttype": widget.orderModel.productType,
        "Netqty": widget.isBuy ? "-" + _qtyContoller.text : _qtyContoller.text,
        "symboltoken": widget.model.exchCode.toString(),
        "symbolname": widget.model.tradingSymbol,
        "OrderSource": "MOB"
      };
      log(jsons.toString());
      var response = await CommonFunction.squareOfPosition(jsons);
      //log("squareoff Order Response => $response");
      try {
        var responseJson = json.decode(response.toString());
        if (responseJson["status"] == false) {
          CommonFunction.showBasicToast(responseJson["emsg"]);
        } else {
          Dataconstants.orderBookData.fetchOrderBook();
          Dataconstants.netPositionController.fetchNetPosition();
          HapticFeedback.vibrate();
          var data = await showDialog(
            context: context,
            builder: (_) => Material(
              type: MaterialType.transparency,
              child: OrderPlacedAnimationScreen('Order Squareoff requested'),
            ),
          );
          if (data['result'] == true) {
            Dataconstants.orderBookData.fetchOrderBook().then((value) {
              Navigator.pop(context);
              return showModalBottomSheet(
                  isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => OrderStatusDetails(OrderBookController.OrderBookList.value.data[0], orderType: widget.orderType));
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
    Dataconstants.iqsClient.sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, false);
    super.dispose();
  }
}
