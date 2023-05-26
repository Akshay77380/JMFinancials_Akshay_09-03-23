import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../model/scrip_info_model.dart';
import '../../../screens/scrip_details_screen.dart';
import '../../../util/CommonFunctions.dart';
import '../../../util/Dataconstants.dart';
import '../../../util/InAppSelections.dart';
import '../../../util/Utils.dart';
import '../../../widget/slider_button.dart';
import '../../CommonWidgets/custom_keyboard.dart';
import '../../CommonWidgets/number_field.dart';
import '../../CommonWidgets/switch.dart';
import '../order_summary_details.dart';

class SpreadOrderScreen extends StatefulWidget {
  final ScripInfoModel model;
  final isBuy;
  final Stream<bool> stream;
  final ScripDetailType orderType;

  SpreadOrderScreen({@required this.model, @required this.isBuy, this.stream, this.orderType});

  @override
  State<SpreadOrderScreen> createState() => _SpreadOrderScreenState();
}

class _SpreadOrderScreenState extends State<SpreadOrderScreen> {
  final _orderTypeController = ValueNotifier<bool>(false), _slOrderTypeController = ValueNotifier<bool>(false), _afterMarketController = ValueNotifier<bool>(false);
  List<String> _productItems = ['NRML'], _orderValidityItems = ['DAY', 'COL'];
  bool _showKeyboard = false, _isInt;
  String _productType, _validityType, selectedFormatDate;
  TextEditingController _qtyContoller, _limitController, _triggerController, _discQtyContoller, _numPadController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _limitController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _orderTypeController.addListener(() {
      setState(() {});
    });
    _slOrderTypeController.addListener(() {
      setState(() {});
    });
    _triggerController = TextEditingController();
    _discQtyContoller = TextEditingController();
    _qtyContoller.text = '1';
    _limitController.text = CommonFunction.getMarketRate(widget.model, widget.isBuy).toStringAsFixed(widget.model.precision) ?? '0';
    _productType = InAppSelection.productTypeEquity;
    _orderTypeController.value = InAppSelection.orderType == 'market' ? true : false;
    _triggerController.text = '';
    _discQtyContoller.text = '0';
    _validityType = 'DAY';
    selectedFormatDate = formatter.format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Utils.primaryColor, onPrimary: Utils.whiteColor, onSurface: Utils.primaryColor)), child: child);
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedFormatDate = formatter.format(selectedDate);
      });
    }
  }

  Widget swipeToAction(Size size, ThemeData theme, double width) {
    return Container(
      width: size.width * width,
      margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
      child: SliderButton(
        height: 55,
        width: size.width * width - 0.05,
        text: 'SWIPE TO '
            '${widget.orderType == ScripDetailType.positionExit ? 'SQUAREOFF' : widget.isBuy ? widget.orderType == ScripDetailType.modify ? 'MODIFY BUY' : 'BUY' : widget.orderType == ScripDetailType.modify ? 'MODIFY SELL' : 'SELL'}',
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
          // processPlace();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                      maxLength: 6,
                      numberController: _qtyContoller,
                      hint: 'Quantity',
                      isInteger: true,
                      isBuy: widget.isBuy,
                      isRupeeLogo: false,
                      decimalPosition: 2,
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
                          isDisable: _orderTypeController.value ? true : false,
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
                                'Overnight',
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
                    // const SizedBox(height: 10),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'SL TRIGGER PRICE',
                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                        ),
                        Spacer(),
                        ToggleSwitch(
                          switchController: _slOrderTypeController,
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    NumberField(
                      setDefault: false,
                      doubleIncrement: widget.model.incrementTicksize(),
                      maxLength: 10,
                      numberController: _triggerController,
                      hint: 'SL Trigger Price',
                      isBuy: widget.isBuy,
                      isRupeeLogo: false,
                      isDisable: _slOrderTypeController.value ? true : false,
                      decimalPosition: 2,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'DISCLOSED QUANTITY',
                      style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                    ),
                    const SizedBox(height: 10),
                    NumberField(
                      setDefault: false,
                      doubleIncrement: widget.model.incrementTicksize(),
                      maxLength: 10,
                      numberController: _discQtyContoller,
                      hint: 'Disclosed Quantity',
                      isBuy: widget.isBuy,
                      isRupeeLogo: false,
                      decimalPosition: 2,
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
                              onTap: () {
                                //TODO:
                              },
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1)),
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
                                      decoration:
                                          BoxDecoration(color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.4) : Utils.brightRedColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
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
                        ))
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
                    productType: _productType,
                    // orderType: _isSLTPOrder
                    //     ? "STOP LOSS"
                    //     : "",
                    limitPrice: _orderTypeController.value == true ? '0' : _limitController.text,
                    slTriggerPrice: _triggerController.text == null || _triggerController.text == '' ? "" : _triggerController.text,
                    dislosedQty: _discQtyContoller.text != null
                        ? _discQtyContoller.text
                        : '',
                    validty: _validityType,
                    afterMarketOrder: _afterMarketController.value,
                    swipeAction: swipeToAction(size, theme, 1.0),
                  ));
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
              text: 'SWIPE TO ${widget.isBuy ? 'BUY' : 'SELL'}',
              textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
              backgroundColorEnd: theme.cardColor,
              backgroundColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
              foregroundColor: Utils.whiteColor,
              iconColor: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
              icon: Icons.double_arrow,
              shimmer: false,
              // shimmerHighlight: Utils.whiteColor,
              // shimmerBase: Utils.whiteColor,
              onConfirmation: () {},
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
      ),
    );
  }
}
