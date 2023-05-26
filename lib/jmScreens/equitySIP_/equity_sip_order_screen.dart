import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '../../model/exchData.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/number_field.dart';
import 'equity_sip_order_review.dart';


class EquitySipOrderScreen extends StatefulWidget {
  final ScripInfoModel model;

  EquitySipOrderScreen({
    @required this.model,
  });

  @override
  _EquitySipOrderScreenState createState() => _EquitySipOrderScreenState();
}

class _EquitySipOrderScreenState extends State<EquitySipOrderScreen> {
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _qtyContoller, _durationController;
  bool _isMandate = false, showMarginCalculation = true, _agreeTerms = true;
  List<String> items = ['Monthly'];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    Dataconstants.isSip = false;
    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _durationController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    /* Assigning blank field to the Quantity when its fresh order or quantity field is zero BOB and exchange requirement */
    _qtyContoller.text = ' ';
    _durationController.text = ' ';
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Utils.primaryColor,
                    onPrimary: Utils.whiteColor,
                    onSurface: Utils.primaryColor)),
            child: child));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
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
                      color: Utils.brightRedColor,
                    ),
                    child: Text('SELL',
                        style: Utils.fonts(
                            size: 14.0,
                            color: Utils.whiteColor,
                            fontWeight: FontWeight.w500)),
                  ),
                  Text(
                    widget.model.exchCategory == ExchCategory.nseEquity ||
                            widget.model.exchCategory == ExchCategory.bseEquity
                        ? widget.model.desc.trim()
                        : widget.model.marketWatchName.trim(),
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
                    child: Text('NSE',
                        style: Utils.fonts(
                            size: 14.0,
                            color: Utils.whiteColor,
                            fontWeight: FontWeight.w500)),
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
                      widget.model.close
                          .toStringAsFixed(widget.model.precision),
                      style: Utils.fonts(
                          color: Utils.blackColor,
                          size: 12.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      widget.model.close > widget.model.prevTickRate
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: Utils.blackColor,
                    ),
                    Observer(
                      builder: (_) => Text(
                        /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                        widget.model.close == 0.00
                            ? '0.00'
                            : widget.model.priceChangeText,
                        style: Utils.fonts(
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Utils.blackColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Observer(
                      builder: (_) => Text(
                        /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                        widget.model.close == 0.00
                            ? '0.00%'
                            : '${widget.model.percentChangeText}',
                        style: Utils.fonts(
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Utils.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [Icon(Icons.more_vert)],
        ),
        body: Column(
          children: [
            if (Dataconstants.exchData[0].exchangeStatus !=
                ExchangeStatus.nesOpen)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Dataconstants.exchData[0].exchangeStatus ==
                              ExchangeStatus.nesOpen
                          ? ThemeConstants.buyColor
                          : ThemeConstants.sellColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  /* Here i am checking the exchData field at index zero for Equity to display market open and close status */
                  Text(
                      Dataconstants.exchData[0].exchangeStatus ==
                              ExchangeStatus.nesOpen
                          ? 'Market Open'
                          : 'Market Closed',
                      style: Utils.fonts(
                        size: 14.0,
                        fontWeight: FontWeight.w200,
                      )),
                ],
              ),
            /* If the market is closed then displaying the below message */
            if (Dataconstants.exchData[0].exchangeStatus !=
                ExchangeStatus.nesOpen)
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_sharp,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          'Market is currently closed. Your After Market Order will be sent to exchange once the Market is open.',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: theme.bottomNavigationBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(5)),
              ),
            Divider(
              thickness: 1,
            ),
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
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),

                      NumberField(
                       numberController: _qtyContoller,
                        hint: 'Quantity',
                        maxLength: 10,
                        isRupeeLogo: false,
                        isBuy: true,
                        defaultValue: 0,
                        isInteger: true,

                      ),
                      const SizedBox(height: 20),
                      Text(
                        'FREQUENCY',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 55,
                        width: size.width,
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ThemeConstants.buyColor.withOpacity(0.1)),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            items: items.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Utils.fonts(
                                      size: 14.0,
                                      color: theme.textTheme.bodyText1.color),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox(),
                            hint: Text(
                              'Monthly',
                              style: Utils.fonts(
                                  size: 14.0,
                                  color: theme.textTheme.bodyText1.color),
                            ),
                            icon: Icon(
                              // Add this
                              Icons.arrow_drop_down, // Add this
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color, // Add this
                            ),
                            onChanged: (val) {}),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'START DATE',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 55,
                        width: size.width,
                        padding: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ThemeConstants.buyColor.withOpacity(0.1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                DateFormat('dd MMM yyyy')
                                    .format(selectedDate)
                                    .toString(),
                                style: Utils.fonts(
                                    size: 20.0,
                                    color: theme.textTheme.bodyText1.color)),
                            // SvgPicture.asset('assets/appImages/showCalendar.svg'),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                height: 43,
                                width: 45,
                                decoration: BoxDecoration(
                                    color: ThemeConstants.buyColor
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: ThemeConstants.buyColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'DURATION (MONTHS)',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      NumberField(
                        isBuy: true,
                        numberController: _durationController,
                        isRupeeLogo: false,
                        isInteger: true,
                      ),
                      const SizedBox(height: 20),
                      if (_isMandate)
                        Text(
                          'NACH MANDATE',
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Utils.greyColor),
                        ),
                      if (_isMandate) const SizedBox(height: 10),
                      if (_isMandate)
                        Container(
                          height: 55,
                          width: size.width,
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ThemeConstants.buyColor.withOpacity(0.1)),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              items: items.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: Utils.fonts(
                                        size: 14.0,
                                        color: theme.textTheme.bodyText1.color),
                                  ),
                                );
                              }).toList(),
                              underline: SizedBox(),
                              hint: Text(
                                'Monthly',
                                style: Utils.fonts(
                                    size: 14.0,
                                    color: theme.textTheme.bodyText1.color),
                              ),
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color, // Add this
                              ),
                              onChanged: (val) {}),
                        ),
                      if (_isMandate) const SizedBox(height: 20),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _agreeTerms = !_agreeTerms;
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Utils.primaryColor, width: 2),
                                  color: _agreeTerms
                                      ? Utils.primaryColor
                                      : Colors.transparent),
                              child: _agreeTerms
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Utils.whiteColor,
                                    )
                                  : SizedBox(),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'I agree ',
                                  style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: theme.textTheme.bodyText1.color),
                                  children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Utils.primaryColor,
                                      textDecoration: TextDecoration.underline),
                                )
                              ]))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _validate(true);
              },
              child: Text(
                'Order Summary',
                style: Utils.fonts(
                    size: 15.0,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyText1.color,
                    textDecoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: size.width * 0.6,
                margin: Platform.isIOS
                    ? const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 70)
                    : const EdgeInsets.all(10),
                child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.buyColor,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      'START SIP',
                      style: Utils.fonts(color: Utils.whiteColor),
                    ),
                    onPressed: () {
                      _validate(false);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validate(bool isSummary) {
    var endDate = DateTime(
        selectedDate.year,
        selectedDate.month + int.tryParse(_durationController.text),
        selectedDate.day);
    // //print('endDate ---- ${endDate.toString()}');
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == ' ') {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey,
          context: context,
          color: Colors.red,
          text: 'Quantity field cannot be blank');
      return;
    }
    if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey,
          context: context,
          color: Colors.red,
          text: 'Quantity field cannot be zero');
      return;
    }
    if (_durationController.text.length == 0 ||
        _durationController.text == ' ') {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey,
          context: context,
          color: Colors.red,
          text: 'Duration field cannot be blank');
      return;
    }
    if (_durationController.text.length == 0 ||
        _durationController.text == '0') {
      CommonFunction.showSnackBarKey(
          key: _scaffoldKey,
          context: context,
          color: Colors.red,
          text: 'Duration field cannot be zero');
      return;
    }
    if (isSummary)
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => EquitySipOrderReview(
                qty: _qtyContoller.text,
                frequency: 'Monthly',
                duration: _durationController.text,
                name: widget.model.name,
                exch: widget.model.exch,
                exchType:widget.model.exchType,
                scriptCode: widget.model.exchCode.toString(),
                symbol: widget.model.tradingSymbol,
                upperLimitPrice: widget.model.upperCktLimit,
                lowerLimitPrice: widget.model.lowerCktLimit,
                startDate:
                    DateFormat('dd MMM yyyy').format(selectedDate).toString(),
                endDate: DateFormat('dd MMM yyyy').format(endDate).toString(),
                ltp: widget.model.close.toStringAsFixed(2),
                ordeValue: calculateRequiredMargin(widget.model),
              ));

  }
  String calculateRequiredMargin(ScripInfoModel model) {
    double result;
    int qty = int.tryParse(_qtyContoller.text);
    double limit = model.close;
    if (qty == null || limit == null)
      return 0.toStringAsFixed(model.precision);
    else {
      result = qty * limit;
      return result.toStringAsFixed(model.precision);
    }
  }

  @override
  void dispose() {
    _qtyContoller.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
