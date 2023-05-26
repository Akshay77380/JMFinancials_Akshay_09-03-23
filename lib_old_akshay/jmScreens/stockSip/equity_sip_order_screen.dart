import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../model/scrip_info_model.dart';
import '../../model/stock_sip_model/stock_sip_model/get_sip_list.dart';
import '../../screens/search_bar_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/DateUtilBigul.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/decimal_text.dart';

// import '../../widget/number_field.dart';
// import '../newLoginScreen.dart';
// import '../order_placed_animation_screen_bigul.dart';
// import '../order_placed_animation_screen_bigul_loader.dart';
// import '../search_bar_screen.dart';
import '../../widget/number_field_bigul.dart';
import '../CommonWidgets/number_field.dart';
import '../algoscreen/order_placed_animation_screen_bigul.dart';
import 'equity_sip_order_review.dart';
import 'package:jiffy/jiffy.dart';

class EquitySipOrderScreen extends StatefulWidget {
  final bool isModify;
  final bool isClone;
  final GetSipList model;

  EquitySipOrderScreen({@required this.isModify, this.model, @required this.isClone});

  @override
  _EquitySipOrderScreenState createState() => _EquitySipOrderScreenState();
}

class _EquitySipOrderScreenState extends State<EquitySipOrderScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _qtyContoller, _durationController, _amountController;
  bool _isMandate = false, showMarginCalculation = true, _agreeTerms = false, amount = false;
  var item = "Daily";
  List<String> items = ["Daily"];

  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  ScripInfoModel currentModel;

  @override
  void initState() {
    Jiffy("2021-03-25");
    items.add("Weekly");
    items.add("Monthly");
    items.add("Quarterly");
    // items.add("Half Yearly");
    // items.add("Yearly");
    Dataconstants.sipScriptModel = null;
    Dataconstants.isSip = false;
    _qtyContoller = TextEditingController()
      ..addListener(() {
        // setState(() {});
      });
    _durationController = TextEditingController()
      ..addListener(() {
        // setState(() {});
      });
    _amountController = TextEditingController()..addListener(() {

    });
    if (widget.isModify) {
      currentModel = widget.model.model;
      _qtyContoller.text = widget.model.qty.toString() == '0' ? widget.model.value.toString() : widget.model.qty.toString();
      amount = widget.model.qty.toString() == '0' ? true : false;
      // _amountController.text = widget.model.value.toStringAsFixed(2);
      item = widget.model.sipPeriod.toString();
      selectedDate = DateTime.parse(widget.model.startDate.toString().split("T")[0].toString().split(" ")[0].toString());
      _amountController.text = (currentModel.close + (currentModel.close / 10)).toStringAsFixed(2);

      // print(selectedDate);
    } else if (widget.isClone) {
      currentModel = widget.model.model;
      _qtyContoller.text = widget.model.qty.toString() == '0' ? widget.model.value.toString() : widget.model.qty.toString();
      amount = widget.model.qty.toString() == '0' ? true : false;
      _amountController.text = widget.model.value.toStringAsFixed(2);
      item = widget.model.sipPeriod.toString();
      _amountController.text = (currentModel.close + (currentModel.close / 10)).toStringAsFixed(2);

      // selectedDate=DateTime.parse(widget.model.startDate.toString().split("T")[0].toString().split(" ")[0].toString());
      // print(selectedDate);
    } else {
      _qtyContoller.text = '0';
      _durationController.text = '0';
      _amountController.text = '0';
    }

    // _amountController.text = widget.model.value.toString();

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    var theme = Theme.of(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime(2101),
        builder: (context, child) =>
            Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: theme.primaryColor, onPrimary: Colors.white, onSurface: theme.primaryColor)), child: child));
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
              onTap: () => Navigator.pop(context),
            ),
            elevation: 0,
            title: Center(
                child: Text(
              "Start SIP",
              style: TextStyle(color: theme.textTheme.bodyText1.color),
            ))

            // Column(
            //   children: [
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Container(
            //           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //           margin: EdgeInsets.only(right: 10),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: Colors.red,
            //           ),
            //           child: Text('SELL',
            //               style: TextStyle(
            //                   fontSize: 14.0,
            //                   color: Utils.whiteColor,
            //                   fontWeight: FontWeight.w500)),
            //         ),
            //         Text(
            //           widget.model.exchCategory == ExchCategory.nseEquity ||
            //                   widget.model.exchCategory == ExchCategory.bseEquity
            //               ? widget.model.desc.trim()
            //               : widget.model.marketWatchName.trim(),
            //           style: TextStyle(fontSize: 15.0, color: Colors.black),
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Container(
            //           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: Utils.greyColor,
            //           ),
            //           child: Text('NSE',
            //               style: TextStyle(
            //                   fontSize: 14.0,
            //                   color: Utils.whiteColor,
            //                   fontWeight: FontWeight.w500)),
            //         ),
            //         // SizedBox(
            //         //   height: 22,
            //         //   child: Icon(
            //         //     Icons.arrow_drop_down_rounded,
            //         //     size: 30,
            //         //     // widget.model.close > widget.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
            //         //     color: Utils.blackColor,
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //     Observer(
            //       builder: (_) => Row(
            //         children: [
            //           Text(
            //             widget.model.close
            //                 .toStringAsFixed(widget.model.precision),
            //             style: TextStyle(
            //                 color: Utils.blackColor,
            //                 fontSize: 12.0,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //           Icon(
            //             widget.model.close > widget.model.prevTickRate
            //                 ? Icons.arrow_drop_up_rounded
            //                 : Icons.arrow_drop_down_rounded,
            //             color: Utils.blackColor,
            //           ),
            //           Observer(
            //             builder: (_) => Text(
            //               /* If the LTP is zero before or after market time, it is showing zero instead of price change */
            //               widget.model.close == 0.00
            //                   ? '0.00'
            //                   : widget.model.priceChangeText,
            //               style: TextStyle(
            //                 fontSize: 12.0,
            //                 fontWeight: FontWeight.w500,
            //                 color: Utils.blackColor,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Observer(
            //             builder: (_) => Text(
            //               /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
            //               widget.model.close == 0.00
            //                   ? '0.00%'
            //                   : '${widget.model.percentChangeText}',
            //               style: TextStyle(
            //                 fontSize: 12.0,
            //                 fontWeight: FontWeight.w500,
            //                 color: Utils.blackColor,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // actions: [Icon(Icons.more_vert)],
            ),
        body: Column(
          children: [
            // if (Dataconstants.exchData[0].exchangeStatus !=
            //     ExchangeStatus.nesOpen)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         width: 10,
            //         height: 10,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Dataconstants.exchData[0].exchangeStatus ==
            //                   ExchangeStatus.nesOpen
            //               ? ThemeConstants.buyColor
            //               : ThemeConstants.sellColor,
            //         ),
            //       ),
            //       const SizedBox(width: 5),
            //       /* Here i am checking the exchData field at index zero for Equity to display market open and close status */
            //       Text(
            //           Dataconstants.exchData[0].exchangeStatus ==
            //                   ExchangeStatus.nesOpen
            //               ? 'Market Open'
            //               : 'Market Closed',
            //           style: TextStyle(
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w200,
            //           )),
            //     ],
            //   ),
            // /* If the market is closed then displaying the below message */
            // if (Dataconstants.exchData[0].exchangeStatus !=
            //     ExchangeStatus.nesOpen)
            //   Container(
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Row(
            //         children: [
            //           const Icon(
            //             Icons.schedule_sharp,
            //             size: 20,
            //           ),
            //           const SizedBox(
            //             width: 10,
            //           ),
            //           Flexible(
            //             child: Text(
            //               'Market is currently closed. Your After Market Order will be sent to exchange once the Market is open.',
            //               style: TextStyle(
            //                 fontSize: 12.0,
            //                 fontWeight: FontWeight.w200,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     margin: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //         color: theme.bottomNavigationBarTheme.backgroundColor,
            //         borderRadius: BorderRadius.circular(5)),
            //   ),
            // Divider(
            //   thickness: 1,
            // ),
            Stack(
              children: [
                // Container(
                //   height: 45,
                //   color: groupValue == 0
                //       ? ThemeConstants.buyColor
                //       : ThemeConstants.sellColorOld,
                // ),
                Container(
                  height: 70,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () async {
                          if (!widget.isModify) {
                            Dataconstants.isFromSIP = true;
                            setState(() {
                              Dataconstants.isSip = true;
                            });
                            await showSearch(
                              context: context,
                              delegate: SearchBarScreen(InAppSelection.marketWatchID),
                            ).then((value) {
                              try {
                                setState(() {
                                  currentModel = Dataconstants.sipScriptModel;
                                  // _exchTogglePosition =
                                  // Dataconstants.sipScriptModel.exch == 'N'
                                  //     ? 0
                                  //     : 1;

                                  Dataconstants.isFromSIP = false;
                                  Dataconstants.isSip = false;
                                  _qtyContoller.text = currentModel.minimumLotQty.toString();
                                  _amountController.text = (currentModel.close + (currentModel.close / 10)).toStringAsFixed(2);
                                  if (currentModel.exchCategory == ExchCategory.nseFuture || currentModel.exchCategory == ExchCategory.nseOptions) {
                                    _qtyContoller.text = currentModel.minimumLotQty.toString();
                                    _amountController.text = currentModel.close.toStringAsFixed(2);
                                  } else {
                                    _qtyContoller.text = "0";
                                  }
                                });
                              } catch (e) {
                                print(e);
                              }
                            });
                            // }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 25,
                                decoration: BoxDecoration(color: Colors.transparent),
                                child: FittedBox(
                                  child: Text(
                                    (Dataconstants.sipScriptModel == null || Dataconstants.sipScriptModel.name == null || Dataconstants.sipScriptModel.name == "")
                                        ? widget.isModify
                                            ? widget.model.model.marketWatchName
                                            : widget.isClone
                                                ? widget.model.model.marketWatchName
                                                : 'Select Stock'
                                        : Dataconstants.sipScriptModel.name,
                                    style: TextStyle(fontSize: 18, color: theme.textTheme.bodyText1.color, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // if (currentModel != null)
                            Observer(
                              builder: (_) => DecimalText(
                                  // "0.0",
                                  currentModel == null
                                      ? ""
                                      : currentModel.close == 0.0
                                          ? currentModel.prevDayClose.toStringAsFixed(currentModel.precision)
                                          : currentModel.close.toStringAsFixed(currentModel.precision),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: currentModel == null
                                        ? theme.textTheme.bodyText1.color
                                        : currentModel.priceColor == 1
                                            ? ThemeConstants.buyColor
                                            : currentModel.priceColor == 2
                                                ? ThemeConstants.sellColor
                                                : theme.textTheme.bodyText1.color,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                      Row(
                        children: [
                          Text(
                            amount ? 'AMOUNT' : 'QUANTITY',
                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text("QUANTITY", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                              Switch(
                                activeColor: theme.primaryColor,
                                value: amount,
                                onChanged: (val) {
                                  setState(() {
                                    amount = !amount;
                                    print("amount = $amount");
                                    // print(_amountController.text);
                                  });
                                },
                              ),
                              Text("AMOUNT", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      !amount
                          ? NumberFieldBigul(
                              maxLength: 16,
                              numberController: _qtyContoller,
                              hint: 'Quantity',
                              isInteger: true,
                              // isBuy: true,
                            )
                          : NumberFieldBigul(
                              // isInteger: true,
                              // maxValue: 9999999999,
                              // increment: 100,
                              doubleDefaultValue: 0,
                              doubleIncrement: 0.05,
                              maxLength: 10,
                              numberController: _amountController,
                              hint: 'Amount',
                            ),
                      const SizedBox(height: 20),
                      Text(
                        'FREQUENCY',
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 55,
                        width: size.width,
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ThemeConstants.buyColor.withOpacity(0.1)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, left: 25),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              underline: SizedBox.shrink(),
                              value: item,
                              items: items.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 14.0, color: theme.textTheme.bodyText1.color),
                                  ),
                                );
                              }).toList(),
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Theme.of(context).textTheme.bodyText1.color, // Add this
                              ),
                              onChanged: (val) {
                                setState(() {
                                  item = val;
                                });
                              }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'START DATE',
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 55,
                        width: size.width,
                        padding: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ThemeConstants.buyColor.withOpacity(0.1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                // widget.isModify?
                                // DateUtil.getDateStockEvent(widget.model.startDate.toString().split("T")[0].toString().split(" ")[0].toString()) :
                                // widget.isClone? DateUtil.getDateStockEvent(widget.model.startDate.toString().split("T")[0].toString().split(" ")[0].toString()):

                                DateFormat('dd-MM-yyyy').format(selectedDate).toString(),
                                style: TextStyle(fontSize: 20.0, color: theme.textTheme.bodyText1.color)),
                            // SvgPicture.asset('assets/appImages/showCalendar.svg'),
                            InkWell(
                              onTap: () {
                                // if(widget.isModify==false)
                                widget.isModify ? null : _selectDate(context);
                                // ),
                              },
                              child: Container(
                                height: 43,
                                width: 45,
                                decoration: BoxDecoration(color: ThemeConstants.buyColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
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
                        'DURATION (${item.toUpperCase()})',
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      ),
                      const SizedBox(height: 10),
                      NumberFieldBigul(
                        maxLength: 10,
                        numberController: _durationController,
                        hint: 'Duration',
                        isInteger: true,
                        // isBuy: true,
                      ),
                      const SizedBox(height: 20),

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
                                      color: theme.primaryColor,
                                      width: 2),
                                  color: _agreeTerms
                                      ? theme.primaryColor
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
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: theme.textTheme.bodyText1.color),
                                  children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color:ThemeConstants.themeMode.value == ThemeMode.dark?Color(0xFF7989FE): theme.primaryColor,
                                  ),
                                )
                              ]))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

      // Row(
        //   children: [
        //     InkWell(
        //       onTap: () {
        //         setState(() {
        //           _agreeTerms = !_agreeTerms;
        //         });
        //       },
        //       child: Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(15),
        //             border: Border.all(
        //                 color: theme.primaryColor,
        //                 width: 2),
        //             color: _agreeTerms
        //                 ? theme.primaryColor
        //                 : Colors.transparent),
        //         child: _agreeTerms
        //             ? Icon(
        //                 Icons.check,
        //                 size: 16,
        //                 color: Utils.whiteColor,
        //               )
        //             : SizedBox(),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 5,
        //     ),
        //     RichText(
        //         text: TextSpan(
        //             text: 'I agree ',
        //             style: TextStyle(
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w500,
        //                 color: theme.textTheme.bodyText1.color),
        //             children: [
        //           TextSpan(
        //             text: 'Terms & Conditions',
        //             style: TextStyle(
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w500,
        //                 color:ThemeConstants.themeMode.value == ThemeMode.dark?Color(0xFF7989FE): theme.primaryColor,
        //             ),
        //           )
        //         ]))
        //   ],

            SizedBox(height: MediaQuery.of(context).size.height * 0.065,),

            InkWell(
              onTap: () {
                _validate(true);
                // if(currentModel==null){
                //   CommonFunction.showSnackBarKey(
                //       key: _scaffoldKey,
                //       color: Colors.red,
                //       context: context,
                //       text: 'please select stock');
                // }else {
                //
                //
                //   _validate(true);
                // }
              },
              child: Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyText1.color,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                print("");
              },
              child: Container(
                width: size.width * 0.6,
                margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
                child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.buyColor,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      (widget.isModify) ? "MODIFY SIP" : 'START SIP',
                      style: TextStyle(color: Utils.whiteColor),
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

  void _validate(bool isSummary) async {
    var startDate;
    var endDate;
    var addDay;
    var addMonth;
    var addYear;
    if (currentModel == null || currentModel.name == "") {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, color: Colors.red, context: context, text: 'please select stock');
      return;
    }
    if (amount) {
      // if (double.parse(_qtyContoller.text.toString()) <= currentModel.close) {
      //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'SIP Amount should not be less then LTP');
      //   return;
      // }
      // if (double.parse(_qtyContoller.text.toString()) <= 99.00) {
      //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Please Revise The Amount More Than 100 stock');
      //   return;
      // }

      if(double.parse(_amountController.text) < currentModel.close + (currentModel.close / 10)){
        // CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Amount should be atleast 10% greater than the LTP');
        CommonFunction.showBasicToast("Amount should be atleast 10% greater than the LTP");
        return;
      }
    }
    if (!amount) {
      if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0.00' || int.parse(_qtyContoller.text.toString()) == 0) {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be blank');
        return;
      }
      if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0') {
        CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Quantity field cannot be blank');
        return;
      }
    } else {
      // if (double.parse(_qtyContoller.text.toString()) == 0.0 || _qtyContoller.text.length == 0 || _qtyContoller.text == '0.0') {
      //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Amount field cannot be blank');
      //   return;
      // }
      // if (_qtyContoller.text.length == 0 || _qtyContoller.text == '0.0') {
      //   CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Amount field cannot be blank');
      //   return;
      // }
    }

    if (_durationController.text.length == 0 || _durationController.text == ' ') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Duration field cannot be blank');
      return;
    }
    if (_durationController.text.length == 0 || _durationController.text == '0') {
      CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Duration field cannot be zero');
      return;
    }

    addDay = item == "Daily"
        ? int.parse(_durationController.text)
        : item == "Weekly"
            ? int.parse(_durationController.text) * 7
            : 0;

    addMonth = item == "Monthly"
        ? int.parse(_durationController.text)
        : item == "Quarterly"
            ? int.parse(_durationController.text) * 3
            : item == "Half Yearly"
                ? int.parse(_durationController.text) * 6
                : 0;
    addYear = item == "Yearly" ? int.parse(_durationController.text) : 0;
    startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    endDate = Jiffy({
      "year": selectedDate.year,
      "month": selectedDate.month,
      "day": selectedDate.day,
    }).add(months: addMonth, days: addDay, years: addYear).format("yyyy-MM-dd HH:mm:ss");

    print(endDate);

    if (isSummary) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          // backgroundColor: Colors.transparent,
          builder: (context) => EquitySipOrderReview(
                isAmount: amount,
                qty: _qtyContoller.text,
                frequency: item,
                duration: _durationController.text,
                name: currentModel.tradingSymbol,
                exch: currentModel.exch,
                startDate: DateFormat('dd-MM-yyyy').format(startDate).toString(),
                endDate: DateUtilBigul.getDateStockEvent(endDate.toString().split(" ")[0].toString()).toString(),
                //DateFormat('dd MM yyyy').format(endDate).toString(),
                ltp: currentModel.close.toStringAsFixed(2),
                ordeValue: calculateRequiredMargin(currentModel),
              ));
    } else {
      var exch = currentModel.exch;
      var ExchType = Dataconstants.exchData[currentModel.exchType].exchTypeShort;
      var symbol = currentModel.tradingSymbol;
      var ScripCode = currentModel.exchCode;
      var StartDate = startDate; //"2023-03-06T00:00:00";
      var ExpiryDate = endDate.toString(); //"2023-03-10T00:00:00";
      var SIPPeriod = item; // "Daily";
      var Qty = amount ? 0 : _qtyContoller.text.toString(); //int.parse(_qtyContoller.text.toString());
      var Value = amount ? _amountController.text.toString() : 0; //100000;
      var UpperPriceLimit = 0;
      var LowerPriceLimit = 0;

      showModalBottomSheet(
          isScrollControlled: true, isDismissible: false, enableDrag: false, backgroundColor: Colors.transparent, context: context, builder: (BuildContext context) => CircularProgressIndicator());
      var response;

      if (widget.isModify) {
        var instIde = widget.model.instId;
        response = await Dataconstants.itsClient.modifySip(exch, "N", ScripCode, StartDate, ExpiryDate, SIPPeriod, Qty, Value, symbol, instIde);
      } else {
        response = await Dataconstants.itsClient.startSip(exch, ExchType, ScripCode, StartDate, ExpiryDate, SIPPeriod, Qty, Value, symbol);
      }

      Navigator.pop(context);

      print("modify Order Response => ${response["Status"]}");
      showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: OrderPlacedAnimationScreenBigul(
            'Order Placed',
          ),
        ),
      ).then((value) {
        Dataconstants.getSipListController.fetchGetSipListData();
        Navigator.pop(context);
      });
    }
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
