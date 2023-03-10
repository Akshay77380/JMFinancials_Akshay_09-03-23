import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/addFunds/FundSuccess.dart';
import 'package:markets/jmScreens/profile/marginscreen.dart';
import 'dart:math' as math;
import '../../controllers/BankDetailsController.dart';
import '../../controllers/limitController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../addFunds/AddFunds.dart';
import '../addFunds/AddMoney.dart';
import '../addFunds/FundTranscation.dart';

class LimitScreen extends StatefulWidget {
  @override
  State<LimitScreen> createState() => _LimitScreenState();
}

class _LimitScreenState extends State<LimitScreen> {
  bool isSourceLimitOpen = false;
  bool isUtilsLimitOpen = false;
  List sourceLimit = [
    {
      'title': 'Cash Balance',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.openingBalance)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.openingBalance))}" : "0.00",
    },
    {
      'title': 'Notional Cash Credit',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.notionalcash)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.notionalcash))}" : "0.00",
    },
    {
      'title': 'Collateral Value',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.stockValuation)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.stockValuation))}" : "0.00",
    },
    {
      'title': 'Direct Collateral Credit',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.directcollateralvalue)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.directcollateralvalue))}" : "0",
    },
    {
      'title': 'Booked Profit on Margin Positions',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.realisedmtom)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.realisedmtom))}" : "0",
    },
    {
      'title': 'Pay In Amount',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.payinAmt)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.payinAmt))}" : "0",
    },
    {
      'title': 'Ad Hoc Margin Credit',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin))}" : "0",
    },
    {
      'title': 'Net Delivery Sell Amount',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncsellcreditpresent)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncsellcreditpresent))}" : "0",
    },
    {
      'title': 'Net Premium Receivable',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.premiumpresent)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.premiumpresent))}" : "0",
    },
  ];
  List UtilsLimit = [
    {
      'title': 'Notional Cash Debit',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.notionalcash)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.notionalcash))}" : "0.00",
    },
    {
      'title': 'Ad Hoc Margin Debit',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin))}" : "0.00",
    },
    {
      'title': 'Net Delivery Buy Amount',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.valueindelivery)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.valueindelivery))}" : "0.00",
    },
    {
      'title': 'Brokerage Present',
      'value': LimitController.limitData.value.brokerageprsnt != null && LimitController.limitData.value.cncbrokerageprsnt != null
          ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.brokerageprsnt) + double.parse(LimitController.limitData.value.cncbrokerageprsnt))}"
          : "0.00",
    },
    {
      'title': 'Unrealized Loss (MtoM) on Delivery Positions',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.unrealisedmtom)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.unrealisedmtom))}" : "0.00",
    },
    {
      'title': 'Margin Used for Cash Segment',
      'value': LimitController.limitData.value.scripbasketmargin != null && LimitController.limitData.value.valueindelivery != null
          ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.scripbasketmargin) - double.parse(LimitController.limitData.value.valueindelivery))}"
          : "0.00",
    },
    {
      'title': 'Margin Used for CO',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.coMarginRequired)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.coMarginRequired))}" : "0.00",
    },
    {
      'title': 'Margin Used for BO',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.bOmarginRequired)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.bOmarginRequired))}" : "0.00",
    },
    {
      'title': 'Span Margin (Futures & Options Portfolio)',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.spanmargin)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.spanmargin))}" : "0.00",
    },
    {
      'title': 'Exposure Margin (Futures & Option Portfolio)',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.exposuremargin)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.exposuremargin))}" : "0.00",
    },
    {
      'title': 'CNC Margin Var Present',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncMarginVarPrsnt)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncMarginVarPrsnt))}" : "0.00",
    },
    {
      'title': 'Net Premium Payable',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.adhocmargin))}" : "0.00",
    },
    {
      'title': 'Booked Loss on Margin Positions',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.viewrealizedmtom)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.viewrealizedmtom))}" : "0.00",
    },
    {
      'title': 'Unrealized Loss (MtoM) on Margin Positions',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncunrealizedmtomprsnt)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.cncunrealizedmtomprsnt))}" : "0.00",
    },
    {
      'title': 'Requested Payout',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.payoutAmt)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.payoutAmt))}" : "0.00",
    },
    {
      'title': 'SGB/ ETF/ NCD/ IPO Amount',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.ipoAmount)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.ipoAmount))}" : "0.00",
    },
    {
      'title': 'Mutual Fund Amount',
      'value': CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.mfamount)) != null ? "${CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.mfamount))}" : "0.00",
    },
  ];
  var items = [];
  String dropDownValue;

  getPaymentAccessToken() async {
    var header = {"application": "Intellect"};

    var stringResponse = await CommonFunction.getPaymentAccessToken(header);

    var jsonResponse = jsonDecode(stringResponse);

    //print("Get access token: ${jsonResponse}");

    Dataconstants.fundstoken = await jsonResponse['data'];

    // getBankdetails();

    await Dataconstants.bankDetailsController.getBankDetails();

    getItems();

    //print(Dataconstants.fundstoken);

    // getBankdetails();

    return Dataconstants.fundstoken;
  }

  getItems() async {
    Dataconstants.items.clear();

    for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
      Dataconstants.items.add(BankDetailsController.getBankDetailsListItems[i].name.toString());
    }
    Dataconstants.dropDownInitialValue = Dataconstants.items.first.toString().trim();
  }
  @override
  void initState() {
    super.initState();

    getPaymentAccessToken();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: InkWell(
          // onTap: (){
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => FundSuccess()),
          //   );
          // },
          child: Text(
            "Limits",
            style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
          ),
        ),
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
            // size: 1,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus.unfocus();
              CommonFunction.marketWatchBottomSheet(context);
            },
            child: SvgPicture.asset("assets/appImages/tranding.svg"),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RefreshIndicator(
            color: Utils.primaryColor,
            onRefresh: () {
              Dataconstants.limitController.getLimitsData();
              return Future.value(true);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Utils.primaryColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Available Margin",
                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Obx(() {
                                  return Text(
                                    CommonFunction.currencyFormat(LimitController.limitData.value.availableMargin),
                                    style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                                  );
                                }),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Margin Used",
                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Obx(() {
                                  return Text(
                                    CommonFunction.currencyFormat(LimitController.limitData.value.marginUsed),
                                    style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                                  );
                                }),
                                SizedBox(
                                  height: 5,
                                ),
                                Obx(() {
                                  return Text(
                                    "(${LimitController.limitData.value.marginUsedPercentage} used)".toString(),
                                    style: Utils.fonts(size: 12.0, color: Colors.red, fontWeight: FontWeight.w600),
                                  );
                                }),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Segment: ALL",
                        style: Utils.fonts(size: 14.0, color: Utils.primaryColor.withOpacity(0.7), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available Margin Limit",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "(NRML /MIS /CO/ BO)",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          CommonFunction.currencyFormat(LimitController.limitData.value.availableMargin),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available Delivery Limit",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "(CNC) / Investment products",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          CommonFunction.currencyFormat(LimitController.limitData.value.availableDeliveryMarginLimitCnc),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available Derivative Limit",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "(NRML / MIS / CO/ BO)",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          CommonFunction.currencyFormat(LimitController.limitData.value.availableDerivativeMarginLimit),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Option Buy Limit",
                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          CommonFunction.currencyFormat(LimitController.limitData.value.availableOptnBuyLimit),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shortfall",
                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          CommonFunction.currencyFormat(LimitController.limitData.value.shortFall),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Colors.red),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSourceLimitOpen = !isSourceLimitOpen;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isSourceLimitOpen ? Icons.remove_circle : Icons.add_circle,
                          color: Utils.primaryColor.withOpacity(0.3),
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Source of Limit",
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Obx(() {
                          return Text(
                            CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.sourceOfLimit)),
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                          );
                        }),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: isSourceLimitOpen,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                              itemCount: sourceLimit.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Column(
                                children: [
                                  limitExpandedRow(title: sourceLimit[index]['title'], value: sourceLimit[index]['value']),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isUtilsLimitOpen = !isUtilsLimitOpen;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isUtilsLimitOpen ? Icons.remove_circle : Icons.add_circle,
                          color: Utils.primaryColor.withOpacity(0.3),
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Utilisation of Limit",
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Obx(() {
                          return Text(
                            CommonFunction.currencyFormat(double.parse(LimitController.limitData.value.utilizationOfLimit)),
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                          );
                        }),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: isUtilsLimitOpen,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                              itemCount: UtilsLimit.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Column(
                                children: [
                                  limitExpandedRow(title: UtilsLimit[index]['title'], value: UtilsLimit[index]['value']),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/appImages/fund_transactions.svg"),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FundTransactions()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Fund Transactions",
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Transform.rotate(
                                  angle: 270 * math.pi / 180,
                                  child: Icon(
                                    Icons.arrow_drop_down_circle_rounded,
                                    color: Utils.greyColor.withOpacity(0.6),
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Check Add/Withdraw funds details",
                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w300, color: Utils.greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MarginScreen()));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/appImages/fund_transactions.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Pledge Holdings",
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Transform.rotate(
                                  angle: 270 * math.pi / 180,
                                  child: Icon(
                                    Icons.arrow_drop_down_circle_rounded,
                                    color: Utils.greyColor.withOpacity(0.6),
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Pledge your holdings to enjoy margin benefits",
                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w300, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFunds()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            child: Text(
                              "ADD FUNDS",
                              style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )))),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoney("0", "Limits", "withdraw")));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            child: Text(
                              "WITHDRAW",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor)))))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget limitExpandedRow({String title, String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 25,
        ),
        Expanded(
          child: Text(
            title,
            style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w300),
          ),
        ),
        Spacer(),
        Text(
          value,
          style: Utils.fonts(color: Utils.blackColor, size: 12.0, fontWeight: FontWeight.w500),
        ),
        // Obx(() {
        //   return Text(
        //     value,
        //     // LimitController.limitData.value.availableMargin.toString(),
        //     style: Utils.fonts(color: Utils.blackColor, size: 12.0, fontWeight: FontWeight.w500),
        //   );
        // })
      ],
    );
  }
}
