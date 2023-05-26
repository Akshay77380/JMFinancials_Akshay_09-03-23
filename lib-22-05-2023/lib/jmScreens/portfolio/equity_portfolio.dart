import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/Connection/ISecITS/ITSClient.dart';
import 'package:markets/jmScreens/news/news.dart';
import 'package:markets/jmScreens/orders/OrderPlacement/order_placement_screen.dart';
import 'package:markets/jmScreens/portfolio/view_transactions.dart';
import 'package:markets/model/AlgoModels/AlgoLogModel.dart';
import 'package:markets/model/jmModel/PortfolioModels/PortfolioHoldings.dart';
import 'package:markets/model/jmModel/summaryModel.dart';
import 'package:markets/screens/news_screen.dart';
import 'package:markets/screens/scrip_details_screen.dart';
import 'package:mobx/mobx.dart';
import '../../controllers/EventsBoardMeetController.dart';
import '../../controllers/EventsBonusController.dart';
import '../../controllers/EventsDividendController.dart';
import '../../controllers/EventsRightsController.dart';
import '../../controllers/EventsSplitsController.dart';
import '../../model/existingOrderDetails.dart';
import '../../model/jmModel/eventsDividend.dart';
import '../../model/scrip_info_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/DetailController.dart';
import 'package:markets/controllers/PortfolioControllers/SummaryController.dart';
import 'package:markets/controllers/PortfolioControllers/PortfolioHoldings.dart';
import 'package:markets/model/jmModel/DetailModel.dart';
import '../../controllers/PortfolioControllers/DpHoldingController.dart';
import '../../controllers/PortfolioControllers/PortfolioEquityController.dart';
import 'package:markets/controllers/PortfolioControllers/PortfolioHoldings.dart';
import '../../controllers/holdingController.dart';
import '../../controllers/topGainersController.dart';
import '../../controllers/topLosersController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../ScriptInfo/ScriptInfo.dart';
import '../addFunds/AddFunds.dart';
import '../addFunds/AddMoney.dart';
import '../orders/holdings_screen.dart';
import 'package:http/http.dart' as http;
import '../../model/jmModel/eventsDividend.dart' as EventsDividend;
import 'package:markets/model/jmModel/EventsBonus.dart' as EventsBonus;
import 'package:markets/model/jmModel/EventsSplits.dart' as EventsSplits;
import 'package:markets/model/jmModel/EventsBoardMeet.dart' as EventsBoardMeet;
import 'package:markets/model/jmModel/EventsRights.dart' as EventsRight;

import '../portfolio/view_transactions.dart';

class EquityPorfolio extends StatefulWidget {
  // const EquityPorfolio({Key? key}) : super(key: key);

  @override
  State<EquityPorfolio> createState() => _EquityPorfolioState();
}

class _EquityPorfolioState extends State<EquityPorfolio> {
  final ScrollController _controller = ScrollController();

  //_controller1 = ScrollController(initialScrollOffset: 50.0);
  var currentModel;
  bool topGainersExpanded = false;
  bool topLosersExpanded = false;
  var topGainersTab = 1;
  var topLosersTab = 1;
  var summary = true;
  bool expandNote = false;
  var expandedHoldings = false;
  var expandedTopHoldings = false;
  var expandedSectoralHoldings = false;
  int holdings_scripCode;

  List<ScripInfoModel> dataListTopGainer = [];
  List<ScripInfoModel> datalist = [];
  List<ScripInfoModel> dataListTopLoss = [];
  ObservableDouble valRate = Observable(0.0);
  List<TrPositionsCmGetDataResult> data;
  List<TrPositionsCmGetDataResult2> data2;
  List<ScripInfoModel> data2_ltps = [];
  List<TrPositionsCmGetDataResult> topGainerList = [];
  List<TrPositionsCmGetDataResult> topLoserList = [];
  List<dynamic> marketAllocationData = [];
  double totalMarketCap = 0;
  Map<String, double> marketCapAllocation = {
    'LargeCap': 0,
    'MidCap': 0,
    'SmallCap': 0,
  };
  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  initState()  {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await Dataconstants.summaryController.getSummaryApi();
      await getMode();
    });
    // getHoldingsScripCode();
    // getMarketCapAllocationData();
    super.initState();
  }

  // Future<List<dynamic>> fetchNseDerList() async {
  //
  //   String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
  //   String bs64 = base64.encode(rawData.codeUnits);
  //
  //
  //   var res1 = await ITSClient.httpGetDpHoldings(
  //       "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
  //       bs64
  //   );
  //   final response = await ITSClient.httpGetDpHoldings('https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}'),);
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     final derList = jsonResponse['TrPositionsDerivativesFIFOCostDetailGetDataResult'];
  //     return derList;
  //   } else {
  //     throw Exception('Failed to load NSE DER list');
  //   }
  // }
  double diff(double valRate, double ltp) {
    String inString1 = valRate.toStringAsFixed(2); // '2.35'
    double inDouble1 = double.parse(inString1); // 2.35

    String inString2 = ltp.toStringAsFixed(2); // '2.35'
    double inDouble2 = double.parse(inString2);
    // print("val rate $valRate");
    return inDouble2 - inDouble1;
  }

  String checkFunction(double pp, double mp) {
    String inString1 = pp.toStringAsFixed(2); // '2.35'
    double inDouble1 = double.parse(inString1); // 2.35

    String inString2 = mp.toStringAsFixed(2); // '2.35'
    double inDouble2 = double.parse(inString2);

    String result = inDouble1 < inDouble2 ? "Profit" : "Loss";
    print('Result:: $result');
    return result;
  }

  getMode() async {
    data = [];
    await data.addAll(SummaryController.getSummaryDetailListItems);
    // data.removeAt(data.length-1);
    print('getMode data: $data');
    topGainerList = [];
    topLoserList = [];
    if (data != null) {
      for (int i = 0; i < data.length - 1; i++) {
        var exchCodense = data[i].exchangeInternalScripCode;
        valRate.value = data[i].valRate;
        print("val rate ${valRate.value}");
        print("scrip name ${data[i].scripName}");
        int exchCode = 0;
        if (exchCodense != "") {
          num number = num.tryParse(data[i].exchangeInternalScripCode);
          if (number == null) {
          } else {
            exchCode = number;
          }
        } else {
          num number = num.tryParse(data[i].scripCode);
          if (number == null) {
            // print('Invalid input. Please enter a numeric value.');
          } else {
            exchCode = number;
          }
        }
        var result = CommonFunction.getScripDataModel(
            exch: exchCode >= 0 && exchCode < 34999 ? "N" : "B",
            exchCode: exchCode,
            getNseBseMap: false);
        if (result != null) {
          print('Close value ${result.close}');
          if ((checkFunction(data[i].valRate, result.close)) == "Profit") {
            topGainerList.add(data[i]);
            dataListTopGainer.add(result);
          } else if (checkFunction(data[i].valRate, result.close) == "Loss") {
            topLoserList.add(data[i]);
            dataListTopLoss.add(result);
          }
          print("Result 2 - ${diff(data[i].valRate, result.close)}");
          datalist.add(result);
          print("Data in get Mode $datalist");
        }
      }

      print('Top Gain: ${topGainerList.length}');
      print('Top Loss: ${topLoserList.length}');
      print('data : ${data.length}');
    }
  }

  void getmode2() {
    data2 = [];
    data2.addAll(PortfolioHoldingController.getHoldingListItems);
    print('getMode data: $data2');
    // topGainerList =[];
    // topLoserList = [];
    if (data2 != null) {
      for (int i = 0; i < data2.length-1; i++) {
        var exchCodense = data2[i].exchangeInternalScripCode;
        valRate.value = data2[i].valRate;
        print("val rate ${valRate.value}");
        print("scrip name ${data2[i].scripName}");
        int holdingsexchCode = 0;
        if (exchCodense != "") {
          num number = num.tryParse(data2[i].exchangeInternalScripCode);
          if (number == null) {
          } else {
            holdingsexchCode = number;
          }
        } else {
          num number = num.tryParse(data2[i].scripCode);
          if (number == null) {
            // print('Invalid input. Please enter a numeric value.');
          } else {
            holdingsexchCode = number;
          }
        }
        var result2 = CommonFunction.getScripDataModel(
            exch: holdingsexchCode >= 0 && holdingsexchCode < 34999 ? "N" : "B",
            exchCode: holdingsexchCode,
            getNseBseMap: false);
        if (result2 != null) {
          print('Close value of 2 ${result2.close}');
          data2_ltps.add(result2);
        }
        print("data from data2_ltps:${data2_ltps}");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7ca6fa).withOpacity(0.2),
                            Color(0xff219305ff).withOpacity(0.2)
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        )),
                    // color: Color(0x7ca6fa),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Market Value",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 12.0
                                      ),
                                    ),
                                    Text(
                                      PortfolioEquityController.getPortfolioEquityListItems.last.valuation.toStringAsFixed(2),
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w900,
                                          size: 14.0),
                                    )

                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddFunds()),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Add Funds",
                                        style: Utils.fonts(
                                          color: Utils.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          size: 11.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/appImages/portfolio/zero_wallet.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Invested",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.greyColor),
                                    ),
                                    Text(
                                      PortfolioEquityController
                                          .getPortfolioEquityListItems[
                                              PortfolioEquityController
                                                      .getPortfolioEquityListItems
                                                      .length -
                                                  1]
                                          .netValue
                                          .toStringAsFixed(2),
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w900,
                                          size: 14.0),
                                    ),
                                    Text(
                                      "",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.brightGreenColor),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Day's P/L",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.greyColor),
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.brightGreenColor),
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.brightGreenColor),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Unrealised P/L",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.greyColor),
                                    ),
                                    Text(
                                      PortfolioEquityController
                                          .getPortfolioEquityListItems[
                                              PortfolioEquityController
                                                      .getPortfolioEquityListItems
                                                      .length -
                                                  1]
                                          .unrealisedPl
                                          .toStringAsFixed(2),
                                      // " ",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: PortfolioEquityController
                                                      .getPortfolioEquityListItems[
                                                          PortfolioEquityController
                                                                  .getPortfolioEquityListItems
                                                                  .length -
                                                              1]
                                                      .unrealisedPl <
                                                  0
                                              ? Colors
                                                  .red // set color to red if unrealisedPl is less than zero
                                              : Utils.brightGreenColor),
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Utils.brightGreenColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    summary = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    top: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.primaryColor
                                            : Utils.greyColor.withOpacity(0.5)),
                                    bottom: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.primaryColor
                                            : Utils.greyColor.withOpacity(0.5)),
                                    right: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.primaryColor
                                            : Utils.greyColor.withOpacity(0.5)),
                                    left: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.primaryColor
                                            : Utils.greyColor.withOpacity(0.5)),
                                  )),
                                  child: Center(
                                      child: Text(
                                    'SUMMARY',
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 11.0,
                                        color: summary
                                            ? Utils.primaryColor
                                            : Utils.greyColor.withOpacity(0.5)),
                                  )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    summary = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    top: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.greyColor.withOpacity(0.5)
                                            : Utils.primaryColor),
                                    bottom: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.greyColor.withOpacity(0.5)
                                            : Utils.primaryColor),
                                    right: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.greyColor.withOpacity(0.5)
                                            : Utils.primaryColor),
                                    left: BorderSide(
                                        width: 1,
                                        color: summary
                                            ? Utils.greyColor.withOpacity(0.5)
                                            : Utils.primaryColor),
                                  )),
                                  child: Center(
                                      child: Text(
                                    'HOLDINGS',
                                    style: Utils.fonts(
                                        size: 11.0,
                                        color: summary
                                            ? Utils.greyColor.withOpacity(0.5)
                                            : Utils.primaryColor),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Realised P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  color: Utils.greyColor,
                                  size: 12.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "-",
                                style: Utils.fonts(
                                    size: 13.0, color: Utils.lightGreenColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor,
            ),
            summary
                ? Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Market Cap Allocation",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Container(
                                height: 130,
                                width: 130,
                                child: Center(
                                  child: SvgPicture.asset(
                                      'assets/appImages/portfolio/pie_chart.svg'),
                                ),
                              ),
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 13.0),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/appImages/green_dot.svg'),
                                      SizedBox(height: 20),
                                      SvgPicture.asset(
                                          'assets/appImages/blue_dot.svg'),
                                      SizedBox(height: 20),
                                      SvgPicture.asset(
                                          'assets/appImages/yellow_dot.svg'),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LARGECAP',
                                      style: Utils.fonts(size: 12.0),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'MIDCAP',
                                      style: Utils.fonts(size: 12.0),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'SMALLCAP',
                                      style: Utils.fonts(size: 12.0),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${marketCapAllocation['LargeCap']}%',
                                        style: Utils.fonts(size: 12.0),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        '${marketCapAllocation['MidCap']}%',
                                        style: Utils.fonts(size: 12.0),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        '${marketCapAllocation['SmallCap']}%',
                                        style: Utils.fonts(size: 12.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xffdd2006).withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                // SvgPicture.asset(
                                //   "assets/appImages/market_cap_allocation2.svg",
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Higher concentration of portfolio in midcap\nand smallcap stocks",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 13.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      return PortfolioHoldingController.isLoading.value
                          ? CircularProgressIndicator()
                          : PortfolioHoldingController
                                  .getHoldingListItems.isEmpty
                              ? Center(child: Text("No Data available"))
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Symbol',
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Utils.greyColor),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'LTP',
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Utils.greyColor),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Holding Qty',
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Utils.greyColor),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Valuation',
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Utils.greyColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: CustomTabBarScrollPhysics(),
                                      itemCount: expandedHoldings
                                          ? PortfolioHoldingController
                                              .getHoldingListItems.length
                                          : 5,
                                      itemBuilder: ((context, index) => Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                          PortfolioHoldingController
                                                              .getHoldingListItems[
                                                                  index]
                                                              .scripName,
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Observer(
                                                          builder: (context) {
                                                        return Text(
                                                          // PortfolioHoldingController.getHoldingListItems[index].valuation.toStringAsFixed(2),
                                                          // '${data2_ltps[index].close}',
                                                          '-',
                                                          style: Utils.fonts(
                                                            size: 11.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        PortfolioHoldingController
                                                            .getHoldingListItems[
                                                                index]
                                                            .netQty
                                                            .toStringAsFixed(2),
                                                        style: Utils.fonts(
                                                          size: 11.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        PortfolioHoldingController
                                                            .getHoldingListItems[
                                                                index]
                                                            .netValue
                                                            .toStringAsFixed(2),
                                                        style: Utils.fonts(
                                                          size: 13.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                thickness: 2,
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                );
                    }),
                  ),
            summary == false
                ? InkWell(
                    onTap: () {
                      setState(() {
                        expandedHoldings
                            ? expandedHoldings = false
                            : expandedHoldings = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        expandedHoldings
                            ? Text(
                                "View less",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Utils.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              )
                            : Text(
                                "View more",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Utils.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                        expandedHoldings
                            ? RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40,
                                  color: Utils.primaryColor,
                                ),
                              )
                            : Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Utils.primaryColor,
                              )
                        // SizedBox(width: 5,),
                        // SvgPicture.asset(
                        //   "assets/appImages/upload.svg",
                        //   // width: 200,
                        //   // height: 200,
                        // ),
                        // Icon(Icons.arrow_drop_down,size: 40,color: Utils.primaryColor,)
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      child: Image.asset(
                        "assets/appImages/start_sip.png",
                        fit: BoxFit.fill,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Top Holdings",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Obx(()
                  // {
                  //   return PortfolioHoldingController.isLoading.value
                  //       ? Center(child: CircularProgressIndicator())
                  //       : PortfolioHoldingController.getHoldingListItems.isEmpty
                  //           ? Center(child: Text("No Data available"))
                  //           : ListView.builder(
                  //               shrinkWrap: true,
                  //               physics: CustomTabBarScrollPhysics(),
                  //               itemCount: expandedTopHoldings ? PortfolioHoldingController.getHoldingListItems.length - 1 : 5,
                  //               itemBuilder: (context, index) => Column(
                  //                 children: [
                  //                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  //                     Container(
                  //                       width: MediaQuery.of(context).size.width / 3,
                  //                       child: Text(
                  //                         PortfolioHoldingController.getHoldingListItems[index].scripName,
                  //                         style: Utils.fonts(fontWeight: FontWeight.w500, size: 11.0),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       width: MediaQuery.of(context).size.width / 3,
                  //                       child: Row(
                  //                         mainAxisAlignment:  MainAxisAlignment.start,
                  //                         children: [
                  //                           Container(
                  //                             height: 10,
                  //                             // width: PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare * (MediaQuery.of(context).size.width * 0.0045) ,
                  //                             width: PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare >= 0 && PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare <= 10
                  //                                     ? 10
                  //                                     : PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare * (MediaQuery.of(context).size.width * 0.003),
                  //                             decoration: BoxDecoration(
                  //                                 color: Utils.darkyellowColor,
                  //                                 borderRadius: BorderRadius.all(Radius.circular(25.0))
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       child: Row(
                  //                         mainAxisAlignment: MainAxisAlignment.end,
                  //                         children: [
                  //                           Text(
                  //                             '${PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare.toStringAsFixed(2)}%',
                  //                             style: Utils.fonts(
                  //                                 fontWeight: FontWeight.w500,
                  //                                 size: 12.0
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ]),
                  //                   Divider(
                  //                     thickness: 2,
                  //                   )
                  //                 ],
                  //               ),
                  //             );
                  // }),
                  // Obx(() {
                  //   final holdingsList = PortfolioHoldingController
                  //           .getHoldingListItems
                  //           .toList() ??
                  //       [];
                  //   if (holdingsList.isNotEmpty) {
                  //     // holdingsList.removeAt(holdingsList.length - 1);
                  //     holdingsList.sort((a, b) => b.valuationPercentShare
                  //         .compareTo(a.valuationPercentShare));
                  //   }
                  //   // holdingsList.add(PortfolioHoldingController.getHoldingListItems.last);
                  //   return PortfolioHoldingController.isLoading.value
                  //       ? Center(child: CircularProgressIndicator())
                  //       : holdingsList.isEmpty
                  //           ? Center(child: Text("No Data available"))
                  //           : ListView.builder(
                  //               shrinkWrap: true,
                  //               physics: CustomTabBarScrollPhysics(),
                  //               // itemCount: expandedTopHoldings
                  //               //     ? holdingsList.length - 0
                  //               //     : 5,
                  //               itemCount: getTopHoldingLength(),
                  //               itemBuilder: (context, index) => Column(
                  //                 children: [
                  //                   Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         InkWell(
                  //                           onTap: () {
                  //                             showModalBottomSheet(
                  //                                 isScrollControlled: true,
                  //                                 context: context,
                  //                                 shape: RoundedRectangleBorder(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           10.0),
                  //                                 ),
                  //                                 backgroundColor:
                  //                                     Colors.transparent,
                  //                                 constraints: BoxConstraints(
                  //                                     maxHeight:
                  //                                         MediaQuery.of(context)
                  //                                                 .size
                  //                                                 .height *
                  //                                             0.8),
                  //                                 builder: (context) => Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .all(18.0),
                  //                                       child:
                  //                                           SingleChildScrollView(
                  //                                         child: (Column(
                  //                                           children: [
                  //                                             Card(
                  //                                               margin:
                  //                                                   EdgeInsets
                  //                                                       .zero,
                  //                                               shape: RoundedRectangleBorder(
                  //                                                   borderRadius:
                  //                                                       BorderRadius.circular(
                  //                                                           10)),
                  //                                               color: Colors
                  //                                                   .white,
                  //                                               child: Padding(
                  //                                                 padding:
                  //                                                     const EdgeInsets
                  //                                                             .all(
                  //                                                         15.0),
                  //                                                 child: Column(
                  //                                                   children: [
                  //                                                     Row(
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.spaceBetween,
                  //                                                       children: [
                  //                                                         Text(
                  //                                                           "Holdings Details",
                  //                                                           style:
                  //                                                               Utils.fonts(size: 20.0),
                  //                                                         ),
                  //                                                         InkWell(
                  //                                                           onTap:
                  //                                                               () {
                  //                                                             Navigator.pop(context);
                  //                                                           },
                  //                                                           child:
                  //                                                               Icon(Icons.close),
                  //                                                         )
                  //                                                       ],
                  //                                                     ),
                  //                                                     const SizedBox(
                  //                                                       height:
                  //                                                           20,
                  //                                                     ),
                  //                                                     Row(
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.spaceBetween,
                  //                                                       children: [
                  //                                                         Column(
                  //                                                           crossAxisAlignment:
                  //                                                               CrossAxisAlignment.center,
                  //                                                           children: [
                  //                                                             Text(
                  //                                                               "QTY",
                  //                                                               style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400),
                  //                                                             ),
                  //                                                             Text(
                  //                                                               holdingsList[index].netQty.toStringAsFixed(0),
                  //                                                               style: Utils.fonts(
                  //                                                                 fontWeight: FontWeight.w900,
                  //                                                                 size: 15.0,
                  //                                                               ),
                  //                                                             )
                  //                                                           ],
                  //                                                         ),
                  //                                                         Column(
                  //                                                           crossAxisAlignment:
                  //                                                               CrossAxisAlignment.center,
                  //                                                           children: [
                  //                                                             Text(
                  //                                                               "AVG PRICE",
                  //                                                               style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400),
                  //                                                             ),
                  //                                                             Text(
                  //                                                               holdingsList[index].valRate.toStringAsFixed(2),
                  //                                                               style: Utils.fonts(
                  //                                                                 fontWeight: FontWeight.w700,
                  //                                                                 size: 15.0,
                  //                                                               ),
                  //                                                             )
                  //                                                           ],
                  //                                                         ),
                  //                                                         Column(
                  //                                                           crossAxisAlignment:
                  //                                                               CrossAxisAlignment.center,
                  //                                                           children: [
                  //                                                             Text(
                  //                                                               "STATUS",
                  //                                                               style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400),
                  //                                                             ),
                  //                                                             Text(
                  //                                                               "OPEN",
                  //                                                               style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0, color: Utils.brightGreenColor),
                  //                                                             )
                  //                                                           ],
                  //                                                         ),
                  //                                                       ],
                  //                                                     ),
                  //                                                     SizedBox(
                  //                                                       height:
                  //                                                           20,
                  //                                                     ),
                  //                                                     Container(
                  //                                                       decoration: BoxDecoration(
                  //                                                           border: Border.all(
                  //                                                             color: Utils.greyColor,
                  //                                                             width: 1,
                  //                                                           ),
                  //                                                           borderRadius: BorderRadius.all(
                  //                                                             Radius.circular(15.0),
                  //                                                           )),
                  //                                                       child:
                  //                                                           Column(
                  //                                                         children: [
                  //                                                           const SizedBox(
                  //                                                             height: 20,
                  //                                                           ),
                  //                                                           Row(
                  //                                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                                                             children: [
                  //                                                               Row(
                  //                                                                 children: [
                  //                                                                   SizedBox(
                  //                                                                     width: MediaQuery.of(context).size.width * 0.5, // Set the width to half the screen width
                  //                                                                     child: Text(
                  //                                                                       holdingsList[index].scripName,
                  //                                                                       style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                  //                                                                       overflow: TextOverflow.ellipsis,
                  //                                                                     ),
                  //                                                                   ),
                  //                                                                 ],
                  //                                                               ),
                  //                                                               Column(
                  //                                                                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                                                 children: [
                  //                                                                   Text(holdingsList[index].valRate.toStringAsFixed(2), style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)),
                  //                                                                   Row(
                  //                                                                     children: [
                  //                                                                       Text(holdingsList[index].valuationPercentShare.toStringAsFixed(2), style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700)),
                  //                                                                       Padding(
                  //                                                                         padding: const EdgeInsets.only(left: 8.0),
                  //                                                                         child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                  //                                                                       )
                  //                                                                     ],
                  //                                                                   ),
                  //                                                                 ],
                  //                                                               ),
                  //                                                             ],
                  //                                                           ),
                  //                                                           SizedBox(
                  //                                                             height: 20,
                  //                                                           ),
                  //                                                           Row(
                  //                                                             mainAxisAlignment: MainAxisAlignment.center,
                  //                                                             children: [
                  //                                                               InkWell(
                  //                                                                 onTap: () {
                  //                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => viewTransactions()));
                  //                                                                 },
                  //                                                                 child: Container(
                  //                                                                     decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), color: Utils.primaryColor.withOpacity(0.2)),
                  //                                                                     child: Padding(
                  //                                                                       padding: EdgeInsets.all(5.0),
                  //                                                                       child: Text("View Transactions", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.primaryColor)),
                  //                                                                     )),
                  //                                                               ),
                  //                                                             ],
                  //                                                           ),
                  //                                                           SizedBox(
                  //                                                             height: 20,
                  //                                                           ),
                  //                                                         ],
                  //                                                       ),
                  //                                                     ),
                  //                                                     SizedBox(
                  //                                                       height:
                  //                                                           20,
                  //                                                     ),
                  //                                                     SizedBox(
                  //                                                       height:
                  //                                                           10,
                  //                                                     ),
                  //                                                     Row(
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.spaceBetween,
                  //                                                       children: [
                  //                                                         Text(
                  //                                                             "Scrip Code",
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)),
                  //                                                         Text(
                  //                                                             holdingsList[index].scripCode,
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700))
                  //                                                       ],
                  //                                                     ),
                  //                                                     SizedBox(
                  //                                                       height:
                  //                                                           10,
                  //                                                     ),
                  //                                                     Row(
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.spaceBetween,
                  //                                                       children: [
                  //                                                         Text(
                  //                                                             "Unrealised P/L",
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)),
                  //                                                         Text(
                  //                                                             holdingsList[index].unrealisedPl.toStringAsFixed(2),
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700))
                  //                                                       ],
                  //                                                     ),
                  //                                                     SizedBox(
                  //                                                       height:
                  //                                                           10,
                  //                                                     ),
                  //                                                     Row(
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.spaceBetween,
                  //                                                       children: [
                  //                                                         Text(
                  //                                                             "Buy Value",
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)),
                  //                                                         Text(
                  //                                                             holdingsList[index].valuation.toStringAsFixed(2),
                  //                                                             style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700))
                  //                                                       ],
                  //                                                     ),
                  //                                                     const SizedBox(
                  //                                                       height:
                  //                                                           10,
                  //                                                     ),
                  //                                                     Column(
                  //                                                       children: [
                  //                                                         Row(
                  //                                                           mainAxisAlignment:
                  //                                                               MainAxisAlignment.spaceBetween,
                  //                                                           children: [
                  //                                                             Text("MKt Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)),
                  //                                                             Text(holdingsList[index].mktRate.toStringAsFixed(2), style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700))
                  //                                                           ],
                  //                                                         ),
                  //                                                         const SizedBox(
                  //                                                           height:
                  //                                                               10,
                  //                                                         ),
                  //                                                       ],
                  //                                                     ),
                  //                                                     const SizedBox(
                  //                                                       height:
                  //                                                           10,
                  //                                                     ),
                  //                                                   ],
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                             const SizedBox(
                  //                                                 height: 20),
                  //                                             Card(
                  //                                               shape: RoundedRectangleBorder(
                  //                                                   borderRadius:
                  //                                                       BorderRadius.circular(
                  //                                                           10)),
                  //                                               color: Utils
                  //                                                   .primaryColor,
                  //                                               child: Column(
                  //                                                 children: [
                  //                                                   Container(
                  //                                                     decoration:
                  //                                                         const BoxDecoration(
                  //                                                       color: Utils
                  //                                                           .whiteColor,
                  //                                                       borderRadius: BorderRadius.only(
                  //                                                           topLeft:
                  //                                                               Radius.circular(10.0),
                  //                                                           topRight: Radius.circular(10.0)),
                  //                                                     ),
                  //                                                     child:
                  //                                                         IntrinsicHeight(
                  //                                                       child:
                  //                                                           Padding(
                  //                                                         padding:
                  //                                                             const EdgeInsets.all(15.0),
                  //                                                         child:
                  //                                                             Row(
                  //                                                           mainAxisAlignment:
                  //                                                               MainAxisAlignment.spaceAround,
                  //                                                           children: [
                  //                                                             GestureDetector(
                  //                                                               behavior: HitTestBehavior.opaque,
                  //                                                               child: InkWell(
                  //                                                                   onTap: () {
                  //                                                                     // currentModel = CommonFunction.getScripDataModelFastForIQS(exchPos: int.tryParse(holdingsList[index].scripCode) > 0 && int.tryParse(holdingsList[index].scripCode) < 34999 ? 0 : 2, exchCode: int.tryParse(holdingsList[index].scripCode));
                  //                                                                     /*Navigator.of(context).push(
                  //                                                                       MaterialPageRoute(
                  //                                                                         builder: (context) =>
                  //                                                                             OrderPlacementScreen(
                  //                                                                               model: widget.order.model,
                  //                                                                               orderType: ScripDetailType.holdingAdd,
                  //                                                                               isBuy: true,
                  //                                                                               selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                  //                                                                               orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                  //                                                                               stream: Dataconstants.pageController.stream,
                  //                                                                             ),
                  //                                                                       ),
                  //                                                                     );*/
                  //                                                                     Navigator.of(context).push(
                  //                                                                       MaterialPageRoute(
                  //                                                                         builder: (context) => OrderPlacementScreen(
                  //                                                                           model: CommonFunction.getScripDataModel(
                  //                                                                             exch: int.parse(holdingsList[index].scripCode) >= 500000 ? "B" : "N",
                  //                                                                             exchCode: int.parse(holdingsList[index].scripCode.toString())),
                  //                                                                           orderType: ScripDetailType.none,
                  //                                                                           isBuy: true,
                  //                                                                           selectedExch: currentModel == 'NSE' ? "N" : "B",
                  //                                                                           stream: Dataconstants.pageController.stream,
                  //                                                                         ),
                  //                                                                       ),
                  //                                                                     );
                  //
                  //                                                                   },
                  //                                                                   child: Text("ADD MORE", style: Utils.fonts(size: 14.0))),
                  //                                                             ),
                  //                                                             const VerticalDivider(
                  //                                                               color: Utils.blackColor,
                  //                                                               thickness: 2,
                  //                                                             ),
                  //                                                             InkWell(
                  //                                                               onTap: () {
                  //                                                                 /*Navigator.of(context).push(
                  //                                                                   MaterialPageRoute(
                  //                                                                     builder: (context) =>
                  //                                                                         OrderPlacementScreen(
                  //                                                                           model: widget.order.model,
                  //                                                                           orderType: ScripDetailType.holdingAdd,
                  //                                                                           isBuy: true,
                  //                                                                           selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                  //                                                                           orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                  //                                                                           stream: Dataconstants.pageController.stream,
                  //                                                                         ),
                  //                                                                   ),
                  //                                                                 );   */
                  //                                                                 currentModel = CommonFunction.getScripDataModelFastForIQS(exchPos: int.tryParse(holdingsList[index].scripCode) > 0 && int.tryParse(holdingsList[index].scripCode) < 34999 ? 0 : 2, exchCode: int.tryParse(holdingsList[index].scripCode));
                  //                                                                 /*Navigator.of(context).push(
                  //                                                                       MaterialPageRoute(
                  //                                                                         builder: (context) =>
                  //                                                                             OrderPlacementScreen(
                  //                                                                               model: widget.order.model,
                  //                                                                               orderType: ScripDetailType.holdingAdd,
                  //                                                                               isBuy: true,
                  //                                                                               selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                  //                                                                               orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                  //                                                                               stream: Dataconstants.pageController.stream,
                  //                                                                             ),
                  //                                                                       ),
                  //                                                                     );*/
                  //                                                                 Navigator.of(context).push(
                  //                                                                   MaterialPageRoute(
                  //                                                                     builder: (context) => OrderPlacementScreen(
                  //                                                                       model: currentModel,
                  //                                                                       orderType: ScripDetailType.none,
                  //                                                                       isBuy: false,
                  //                                                                       selectedExch: currentModel == 'BSE' ? "B" : "N",
                  //                                                                       stream: Dataconstants.pageController.stream,
                  //                                                                     ),
                  //                                                                   ),
                  //                                                                 );
                  //                                                               },
                  //                                                               child: Text("SQUARE OFF", style: Utils.fonts(size: 14.0)),
                  //                                                             ),
                  //                                                           ],
                  //                                                         ),
                  //                                                       ),
                  //                                                     ),
                  //                                                   ),
                  //                                                   GestureDetector(
                  //                                                     behavior:
                  //                                                         HitTestBehavior
                  //                                                             .opaque,
                  //                                                     onTap:
                  //                                                         () {},
                  //                                                     child:
                  //                                                         Container(
                  //                                                       alignment:
                  //                                                           Alignment.center,
                  //                                                       width: MediaQuery.of(context)
                  //                                                           .size
                  //                                                           .width,
                  //                                                       padding:
                  //                                                           const EdgeInsets.symmetric(vertical: 15.0),
                  //                                                       child:
                  //                                                           InkWell(
                  //                                                         onTap:
                  //                                                             () {
                  //                                                               // CommonFunction.getScripDataModel(exchPos: int.tryParse(holdingsList[index].scripCode) > 0 && int.tryParse(holdingsList[index].scripCode) < 34999 ? 0 : 2, exchCode: int.tryParse(holdingsList[index].scripCode));
                  //                                                           Navigator.of(context).push(
                  //                                                             MaterialPageRoute(
                  //                                                               builder: (context) => ScriptInfo(CommonFunction.getScripDataModel(
                  //                                                                   exch: int.parse(holdingsList[index].scripCode) >= 500000 ? "B" : "N",
                  //                                                                   exchCode: int.parse(holdingsList[index].scripCode.toString())), false)
                  //                                                             ),
                  //                                                           );
                  //                                                         },
                  //                                                         child: Text(
                  //                                                             "GET QUOTE",
                  //                                                             style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                  //                                                       ),
                  //                                                     ),
                  //                                                   )
                  //                                                 ],
                  //                                               ),
                  //                                             )
                  //                                           ],
                  //                                         )),
                  //                                       ),
                  //                                     ));
                  //                           },
                  //                           child: Container(
                  //                             width: MediaQuery.of(context)
                  //                                     .size
                  //                                     .width /
                  //                                 3,
                  //                             child: Text(
                  //                               holdingsList[index].scripName,
                  //                               style: Utils.fonts(
                  //                                   fontWeight: FontWeight.w500,
                  //                                   size: 14.0),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Container(
                  //                           width: MediaQuery.of(context)
                  //                                   .size
                  //                                   .width /
                  //                               3,
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.start,
                  //                             children: [
                  //                               Container(
                  //                                 height: 10,
                  //                                 decoration:
                  //                                     const BoxDecoration(
                  //                                   color:
                  //                                       Utils.darkyellowColor,
                  //                                   borderRadius:
                  //                                       BorderRadius.only(
                  //                                     topLeft:
                  //                                         Radius.circular(25.0),
                  //                                     bottomLeft:
                  //                                         Radius.circular(25.0),
                  //                                   ),
                  //                                 ),
                  //                                 width: holdingsList[index]
                  //                                                 .valuationPercentShare >=
                  //                                             0 &&
                  //                                         holdingsList[index]
                  //                                                 .valuationPercentShare <=
                  //                                             10
                  //                                     ? 10
                  //                                     : holdingsList[index]
                  //                                             .valuationPercentShare *
                  //                                         (MediaQuery.of(
                  //                                                     context)
                  //                                                 .size
                  //                                                 .width *
                  //                                             0.003),
                  //                               ),
                  //                               Container(
                  //                                 height: 10,
                  //                                 decoration:
                  //                                     const BoxDecoration(
                  //                                   color: Utils.dullWhiteColor,
                  //                                   borderRadius:
                  //                                       BorderRadius.only(
                  //                                     topRight:
                  //                                         Radius.circular(25.0),
                  //                                     bottomRight:
                  //                                         Radius.circular(25.0),
                  //                                   ),
                  //                                 ),
                  //                                 width: holdingsList[index]
                  //                                                 .valuationPercentShare >=
                  //                                             0 &&
                  //                                         holdingsList[
                  //                                                     index]
                  //                                                 .valuationPercentShare <=
                  //                                             10
                  //                                     ? MediaQuery.of(context)
                  //                                             .size
                  //                                             .width *
                  //                                         0.003 *
                  //                                         90
                  //                                     : MediaQuery.of(context)
                  //                                             .size
                  //                                             .width *
                  //                                         0.003 *
                  //                                         (100 -
                  //                                             holdingsList[
                  //                                                     index]
                  //                                                 .valuationPercentShare),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Container(
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.end,
                  //                             children: [
                  //                               Text(
                  //                                 '${holdingsList[index].valuationPercentShare.toStringAsFixed(2)}%',
                  //                                 style: Utils.fonts(
                  //                                     fontWeight:
                  //                                         FontWeight.w500,
                  //                                     size: 12.0),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ]),
                  //                   // Divider(
                  //                   //   thickness: 1,
                  //                   // )
                  //                   SizedBox(
                  //                     height: 10,
                  //                   )
                  //                 ],
                  //               ),
                  //             );
                  // }),
                  Obx(() {
                    final holdingsList = PortfolioHoldingController
                        .getHoldingListItems
                        .toList() ??
                        [];
                    if (holdingsList.isNotEmpty) {
                      // holdingsList.removeAt(holdingsList.length - 1);
                      holdingsList.sort((a, b) =>
                          b.valuationPercentShare
                              .compareTo(a.valuationPercentShare));
                    }
                    // holdingsList.add(PortfolioHoldingController.getHoldingListItems.last);
                    return PortfolioHoldingController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : holdingsList.isEmpty
                        ? Center(child: Text("No Data available"))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: CustomTabBarScrollPhysics(),
                      itemCount: holdingsList.length > 4
                          ? 4
                          : (holdingsList.isEmpty
                          ? 0
                          : holdingsList.length),
                      // expandedTopHoldings
                      //     ? holdingsList.length - 0
                      //     :5,
                      itemBuilder: (context, index) =>
                          Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                            ),
                                            backgroundColor:
                                            Colors.transparent,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height *
                                                    0.8),
                                            builder: (context) =>
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(18.0),
                                                  child:
                                                  SingleChildScrollView(
                                                    child: (Column(
                                                      children: [
                                                        Card(
                                                          margin:
                                                          EdgeInsets
                                                              .zero,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          color: Colors
                                                              .white,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                15.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Holdings Details",
                                                                      style:
                                                                      Utils
                                                                          .fonts(
                                                                          size: 20.0),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                      Icon(Icons
                                                                          .close),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height:
                                                                  20,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                          "QTY",
                                                                          style: Utils
                                                                              .fonts(
                                                                              size: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .w400),
                                                                        ),
                                                                        Text(
                                                                          holdingsList[index]
                                                                              .netQty
                                                                              .toStringAsFixed(
                                                                              0),
                                                                          style: Utils
                                                                              .fonts(
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            size: 15.0,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                          "AVG PRICE",
                                                                          style: Utils
                                                                              .fonts(
                                                                              size: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .w400),
                                                                        ),
                                                                        Text(
                                                                          holdingsList[index]
                                                                              .valRate
                                                                              .toStringAsFixed(
                                                                              2),
                                                                          style: Utils
                                                                              .fonts(
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            size: 15.0,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text(
                                                                          "STATUS",
                                                                          style: Utils
                                                                              .fonts(
                                                                              size: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .w400),
                                                                        ),
                                                                        Text(
                                                                          "OPEN",
                                                                          style: Utils
                                                                              .fonts(
                                                                              fontWeight: FontWeight
                                                                                  .w700,
                                                                              size: 15.0,
                                                                              color: Utils
                                                                                  .brightGreenColor),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  20,
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(
                                                                        color: Utils
                                                                            .greyColor,
                                                                        width: 1,
                                                                      ),
                                                                      borderRadius: BorderRadius
                                                                          .all(
                                                                        Radius
                                                                            .circular(
                                                                            15.0),
                                                                      )),
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceAround,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width *
                                                                                    0.5,
                                                                                // Set the width to half the screen width
                                                                                child: Text(
                                                                                  holdingsList[index]
                                                                                      .scripName,
                                                                                  style: Utils
                                                                                      .fonts(
                                                                                      size: 14.0,
                                                                                      fontWeight: FontWeight
                                                                                          .w700,
                                                                                      color: Utils
                                                                                          .blackColor),
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .end,
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                  holdingsList[index]
                                                                                      .valRate
                                                                                      .toStringAsFixed(
                                                                                      2),
                                                                                  style: Utils
                                                                                      .fonts(
                                                                                      size: 14.0,
                                                                                      fontWeight: FontWeight
                                                                                          .w400)),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                      holdingsList[index]
                                                                                          .valuationPercentShare
                                                                                          .toStringAsFixed(
                                                                                          2),
                                                                                      style: Utils
                                                                                          .fonts(
                                                                                          size: 14.0,
                                                                                          color: Utils
                                                                                              .lightGreenColor,
                                                                                          fontWeight: FontWeight
                                                                                              .w700)),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .only(
                                                                                        left: 8.0),
                                                                                    child: SvgPicture
                                                                                        .asset(
                                                                                        "assets/appImages/inverted_rectangle.svg"),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () {
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          viewTransactions()));
                                                                            },
                                                                            child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius
                                                                                        .only(
                                                                                        topLeft: Radius
                                                                                            .circular(
                                                                                            20),
                                                                                        topRight: Radius
                                                                                            .circular(
                                                                                            20),
                                                                                        bottomLeft: Radius
                                                                                            .circular(
                                                                                            20),
                                                                                        bottomRight: Radius
                                                                                            .circular(
                                                                                            20)),
                                                                                    color: Utils
                                                                                        .primaryColor
                                                                                        .withOpacity(
                                                                                        0.2)),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets
                                                                                      .all(
                                                                                      5.0),
                                                                                  child: Text(
                                                                                      "View Transactions",
                                                                                      style: Utils
                                                                                          .fonts(
                                                                                          size: 14.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400,
                                                                                          color: Utils
                                                                                              .primaryColor)),
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  20,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "Scrip Code",
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w400)),
                                                                    Text(
                                                                        holdingsList[index]
                                                                            .scripCode,
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w700))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "Unrealised P/L",
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w400)),
                                                                    Text(
                                                                        holdingsList[index]
                                                                            .unrealisedPl
                                                                            .toStringAsFixed(
                                                                            2),
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w700))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "Buy Value",
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w400)),
                                                                    Text(
                                                                        holdingsList[index]
                                                                            .valuation
                                                                            .toStringAsFixed(
                                                                            2),
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight
                                                                                .w700))
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height:
                                                                  10,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            "MKt Value",
                                                                            style: Utils
                                                                                .fonts(
                                                                                size: 14.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400)),
                                                                        Text(
                                                                            holdingsList[index]
                                                                                .mktRate
                                                                                .toStringAsFixed(
                                                                                2),
                                                                            style: Utils
                                                                                .fonts(
                                                                                size: 14.0,
                                                                                fontWeight: FontWeight
                                                                                    .w700))
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                      10,
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height:
                                                                  10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          color: Utils
                                                              .primaryColor,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                const BoxDecoration(
                                                                  color: Utils
                                                                      .whiteColor,
                                                                  borderRadius: BorderRadius
                                                                      .only(
                                                                      topLeft:
                                                                      Radius
                                                                          .circular(
                                                                          10.0),
                                                                      topRight: Radius
                                                                          .circular(
                                                                          10.0)),
                                                                ),
                                                                child:
                                                                IntrinsicHeight(
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15.0),
                                                                    child:
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                      children: [
                                                                        GestureDetector(
                                                                          behavior: HitTestBehavior
                                                                              .opaque,
                                                                          child: InkWell(
                                                                              onTap: () {
                                                                                // currentModel = CommonFunction.getScripDataModelFastForIQS(exchPos: int.tryParse(holdingsList[index].scripCode) > 0 && int.tryParse(holdingsList[index].scripCode) < 34999 ? 0 : 2, exchCode: int.tryParse(holdingsList[index].scripCode));
                                                                                /*Navigator.of(context).push(
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) =>
                                                                                              OrderPlacementScreen(
                                                                                                model: widget.order.model,
                                                                                                orderType: ScripDetailType.holdingAdd,
                                                                                                isBuy: true,
                                                                                                selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                                                                                                orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                                                                                                stream: Dataconstants.pageController.stream,
                                                                                              ),
                                                                                        ),
                                                                                      );*/
                                                                                Navigator
                                                                                    .of(
                                                                                    context)
                                                                                    .push(
                                                                                  MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        OrderPlacementScreen(
                                                                                          model: CommonFunction
                                                                                              .getScripDataModel(
                                                                                              exch: int
                                                                                                  .parse(
                                                                                                  holdingsList[index]
                                                                                                      .scripCode) >=
                                                                                                  500000
                                                                                                  ? "B"
                                                                                                  : "N",
                                                                                              exchCode: int
                                                                                                  .parse(
                                                                                                  holdingsList[index]
                                                                                                      .scripCode
                                                                                                      .toString())),
                                                                                          orderType: ScripDetailType
                                                                                              .none,
                                                                                          isBuy: true,
                                                                                          selectedExch: currentModel ==
                                                                                              'NSE'
                                                                                              ? "N"
                                                                                              : "B",
                                                                                          stream: Dataconstants
                                                                                              .pageController
                                                                                              .stream,
                                                                                        ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Text(
                                                                                  "ADD MORE",
                                                                                  style: Utils
                                                                                      .fonts(
                                                                                      size: 14.0))),
                                                                        ),
                                                                        const VerticalDivider(
                                                                          color: Utils
                                                                              .blackColor,
                                                                          thickness: 2,
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            /*Navigator.of(context).push(
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) =>
                                                                                          OrderPlacementScreen(
                                                                                            model: widget.order.model,
                                                                                            orderType: ScripDetailType.holdingAdd,
                                                                                            isBuy: true,
                                                                                            selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                                                                                            orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                                                                                            stream: Dataconstants.pageController.stream,
                                                                                          ),
                                                                                    ),
                                                                                  );   */
                                                                            currentModel =
                                                                                CommonFunction
                                                                                    .getScripDataModelFastForIQS(
                                                                                    exchPos: int
                                                                                        .tryParse(
                                                                                        holdingsList[index]
                                                                                            .scripCode) >
                                                                                        0 &&
                                                                                        int
                                                                                            .tryParse(
                                                                                            holdingsList[index]
                                                                                                .scripCode) <
                                                                                            34999
                                                                                        ? 0
                                                                                        : 2,
                                                                                    exchCode: int
                                                                                        .tryParse(
                                                                                        holdingsList[index]
                                                                                            .scripCode));
                                                                            /*Navigator.of(context).push(
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) =>
                                                                                              OrderPlacementScreen(
                                                                                                model: widget.order.model,
                                                                                                orderType: ScripDetailType.holdingAdd,
                                                                                                isBuy: true,
                                                                                                selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                                                                                                orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                                                                                                stream: Dataconstants.pageController.stream,
                                                                                              ),
                                                                                        ),
                                                                                      );*/
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .push(
                                                                              MaterialPageRoute(
                                                                                builder: (
                                                                                    context) =>
                                                                                    OrderPlacementScreen(
                                                                                      model: currentModel,
                                                                                      orderType: ScripDetailType
                                                                                          .none,
                                                                                      isBuy: false,
                                                                                      selectedExch: currentModel ==
                                                                                          'BSE'
                                                                                          ? "B"
                                                                                          : "N",
                                                                                      stream: Dataconstants
                                                                                          .pageController
                                                                                          .stream,
                                                                                    ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Text(
                                                                              "SQUARE OFF",
                                                                              style: Utils
                                                                                  .fonts(
                                                                                  size: 14.0)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                                onTap:
                                                                    () {},
                                                                child:
                                                                Container(
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  width: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 15.0),
                                                                  child:
                                                                  InkWell(
                                                                    onTap:
                                                                        () {
                                                                      // CommonFunction.getScripDataModel(exchPos: int.tryParse(holdingsList[index].scripCode) > 0 && int.tryParse(holdingsList[index].scripCode) < 34999 ? 0 : 2, exchCode: int.tryParse(holdingsList[index].scripCode));
                                                                      Navigator
                                                                          .of(
                                                                          context)
                                                                          .push(
                                                                        MaterialPageRoute(
                                                                            builder: (
                                                                                context) =>
                                                                                ScriptInfo(
                                                                                    CommonFunction
                                                                                        .getScripDataModel(
                                                                                        exch: int
                                                                                            .parse(
                                                                                            holdingsList[index]
                                                                                                .scripCode) >=
                                                                                            500000
                                                                                            ? "B"
                                                                                            : "N",
                                                                                        exchCode: int
                                                                                            .parse(
                                                                                            holdingsList[index]
                                                                                                .scripCode
                                                                                                .toString())),
                                                                                    false)),
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                        "GET QUOTE",
                                                                        style: Utils
                                                                            .fonts(
                                                                            size: 14.0,
                                                                            color: Utils
                                                                                .whiteColor)),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                  ),
                                                ));
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3,
                                        child: Text(
                                          holdingsList[index].scripName,
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w500,
                                              size: 14.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          3,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 10,
                                            decoration:
                                            const BoxDecoration(
                                              color:
                                              Utils.darkyellowColor,
                                              borderRadius:
                                              BorderRadius.only(
                                                topLeft:
                                                Radius.circular(25.0),
                                                bottomLeft:
                                                Radius.circular(25.0),
                                              ),
                                            ),
                                            width: holdingsList[index]
                                                .valuationPercentShare >=
                                                0 &&
                                                holdingsList[index]
                                                    .valuationPercentShare <=
                                                    10
                                                ? 10
                                                : holdingsList[index]
                                                .valuationPercentShare *
                                                (MediaQuery
                                                    .of(
                                                    context)
                                                    .size
                                                    .width *
                                                    0.003),
                                          ),
                                          Container(
                                            height: 10,
                                            decoration:
                                            const BoxDecoration(
                                              color: Utils.dullWhiteColor,
                                              borderRadius:
                                              BorderRadius.only(
                                                topRight:
                                                Radius.circular(25.0),
                                                bottomRight:
                                                Radius.circular(25.0),
                                              ),
                                            ),
                                            width: holdingsList[index]
                                                .valuationPercentShare >=
                                                0 &&
                                                holdingsList[
                                                index]
                                                    .valuationPercentShare <=
                                                    10
                                                ? MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.003 *
                                                90
                                                : MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.003 *
                                                (100 -
                                                    holdingsList[
                                                    index]
                                                        .valuationPercentShare),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${holdingsList[index]
                                                .valuationPercentShare
                                                .toStringAsFixed(2)}%',
                                            style: Utils.fonts(
                                                fontWeight:
                                                FontWeight.w500,
                                                size: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              // Divider(
                              //   thickness: 1,
                              // )
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                    );
                  }),
                  InkWell(
                    onTap: () {
                      setState(() {
                        expandedTopHoldings
                            ? expandedTopHoldings = false
                            : expandedTopHoldings = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          expandedTopHoldings
                              ? Text(
                                  "View less",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              : Text(
                                  "View more",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                          expandedTopHoldings
                              ? RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    size: 40,
                                    color: Utils.primaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_drop_down,
                                  size: 40,
                                  color: Utils.primaryColor,
                                )
                          // SizedBox(width: 5,),
                          // SvgPicture.asset(
                          //   "assets/appImages/upload.svg",
                          //   // width: 200,
                          //   // height: 200,
                          // ),
                          // Icon(Icons.arrow_drop_down,size: 40,color: Utils.primaryColor,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sectoral Holdings",
                          style: Utils.fonts(
                            fontWeight: FontWeight.w600,
                            size: 17.0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              _scrollTop();
                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg")),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Obx(() {
                  //   return PortfolioHoldingController.isLoading.value
                  //       ? Center(child: CircularProgressIndicator())
                  //       : PortfolioHoldingController.sectors.isEmpty
                  //           ? Text("No Data available")
                  //           : Column(
                  //               children: [
                  //                 ListView.builder(
                  //                   shrinkWrap: true,
                  //                   physics: CustomTabBarScrollPhysics(),
                  //                   // itemCount: expandedSectoralHoldings
                  //                   //     ? PortfolioHoldingController
                  //                   //             .sectors.length -
                  //                   //         1
                  //                   //     : 4,
                  //                   itemCount: getSectorialHoldingLength(),
                  //                   itemBuilder: (context, index) => Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           PortfolioHoldingController
                  //                               .sectors[index],
                  //                           style: Utils.fonts(
                  //                               fontWeight: FontWeight.w500,
                  //                               size: 14.0),
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               top: 5, bottom: 15),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment
                  //                                     .spaceBetween,
                  //                             children: [
                  //                               // Container(
                  //                               //   height: 10,
                  //                               //   width: PortfolioHoldingController
                  //                               //               .getHoldingListItems[
                  //                               //                   index]
                  //                               //               .valuationPercentShare >
                  //                               //           100
                  //                               //       ? 100
                  //                               //       : PortfolioHoldingController
                  //                               //                   .getHoldingListItems[
                  //                               //                       index]
                  //                               //                   .valuationPercentShare <
                  //                               //               5
                  //                               //           ? 6
                  //                               //           : (MediaQuery.of(
                  //                               //                           context)
                  //                               //                       .size
                  //                               //                       .width *
                  //                               //                   0.0075) *
                  //                               //               PortfolioHoldingController
                  //                               //                   .getHoldingListItems[
                  //                               //                       index]
                  //                               //                   .valuationPercentShare,
                  //                               //   decoration: BoxDecoration(
                  //                               //       borderRadius:
                  //                               //           BorderRadius.all(
                  //                               //         Radius.circular(5.0),
                  //                               //       ),
                  //                               //       color:
                  //                               //           Utils.primaryColor),
                  //                               // ),
                  //                               Container(
                  //                                 height: 10,
                  //                                 width: MediaQuery.of(context)
                  //                                         .size
                  //                                         .width /
                  //                                     3,
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.all(
                  //                                     Radius.circular(5.0),
                  //                                   ),
                  //                                   color: Utils.dullWhiteColor,
                  //                                 ),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       width: PortfolioHoldingController
                  //                                                   .getHoldingListItems[
                  //                                                       index]
                  //                                                   .valuationPercentShare >
                  //                                               100
                  //                                           ? MediaQuery.of(
                  //                                                       context)
                  //                                                   .size
                  //                                                   .width /
                  //                                               3
                  //                                           : PortfolioHoldingController
                  //                                                       .getHoldingListItems[
                  //                                                           index]
                  //                                                       .valuationPercentShare <
                  //                                                   5
                  //                                               ? 6
                  //                                               : (MediaQuery.of(context)
                  //                                                           .size
                  //                                                           .width *
                  //                                                       0.003) *
                  //                                                   PortfolioHoldingController
                  //                                                       .getHoldingListItems[
                  //                                                           index]
                  //                                                       .valuationPercentShare,
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         borderRadius: PortfolioHoldingController
                  //                                                         .getHoldingListItems[
                  //                                                             index]
                  //                                                         .valuationPercentShare >=
                  //                                                     0 &&
                  //                                                 PortfolioHoldingController
                  //                                                         .getHoldingListItems[
                  //                                                             index]
                  //                                                         .valuationPercentShare <=
                  //                                                     10
                  //                                             ? BorderRadius
                  //                                                 .only(
                  //                                                 topLeft: Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                                 bottomLeft: Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                               )
                  //                                             : BorderRadius
                  //                                                 .all(
                  //                                                 Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                               ),
                  //                                         color: Utils
                  //                                             .primaryColor,
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: PortfolioHoldingController
                  //                                                   .getHoldingListItems[
                  //                                                       index]
                  //                                                   .valuationPercentShare >
                  //                                               100
                  //                                           ? 0
                  //                                           : PortfolioHoldingController
                  //                                                       .getHoldingListItems[
                  //                                                           index]
                  //                                                       .valuationPercentShare <
                  //                                                   5
                  //                                               ? MediaQuery.of(
                  //                                                           context)
                  //                                                       .size
                  //                                                       .width *
                  //                                                   0.003 *
                  //                                                   90
                  //                                               : (MediaQuery.of(context)
                  //                                                           .size
                  //                                                           .width *
                  //                                                       0.003) *
                  //                                                   (100 -
                  //                                                       PortfolioHoldingController
                  //                                                           .getHoldingListItems[index]
                  //                                                           .valuationPercentShare),
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         borderRadius: PortfolioHoldingController
                  //                                                         .getHoldingListItems[
                  //                                                             index]
                  //                                                         .valuationPercentShare >=
                  //                                                     0 &&
                  //                                                 PortfolioHoldingController
                  //                                                         .getHoldingListItems[
                  //                                                             index]
                  //                                                         .valuationPercentShare <=
                  //                                                     10
                  //                                             ? BorderRadius
                  //                                                 .only(
                  //                                                 topRight: Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                                 bottomRight: Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                               )
                  //                                             : BorderRadius
                  //                                                 .all(
                  //                                                 Radius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                               ),
                  //                                         color: Utils
                  //                                             .dullWhiteColor,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //
                  //                               SizedBox(
                  //                                 width: 15,
                  //                               ),
                  //                               Text(
                  //                                 // PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare.toStringAsFixed(2),
                  //                                 "${PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare.toStringAsFixed(2)} %",
                  //                                 style: Utils.fonts(
                  //                                   fontWeight: FontWeight.w500,
                  //                                   size: 14.0,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ]),
                  //                 ),
                  //               ],
                  //             );
                  // }),
                  Obx(() {
                    return PortfolioHoldingController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : PortfolioHoldingController.getHoldingListItems.isEmpty
                        ? Text("No Data available")
                        : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: CustomTabBarScrollPhysics(),
                          itemCount: getSectorialHoldingLength(),
                          // expandedSectoralHoldings
                          // ? PortfolioHoldingController
                          // .sectors.length
                          // : 4,
                          /*expandedSectoralHoldings
                          ? PortfolioHoldingController
                          .sectors.length
                          : 4,*/
                          itemBuilder: (context, index) =>
                              Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PortfolioHoldingController
                                          .getHoldingListItems[index].sector,
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          // Container(
                                          //   height: 10,
                                          //   width: PortfolioHoldingController
                                          //               .getHoldingListItems[
                                          //                   index]
                                          //               .valuationPercentShare >
                                          //           100
                                          //       ? 100
                                          //       : PortfolioHoldingController
                                          //                   .getHoldingListItems[
                                          //                       index]
                                          //                   .valuationPercentShare <
                                          //               5
                                          //           ? 6
                                          //           : (MediaQuery.of(
                                          //                           context)
                                          //                       .size
                                          //                       .width *
                                          //                   0.0075) *
                                          //               PortfolioHoldingController
                                          //                   .getHoldingListItems[
                                          //                       index]
                                          //                   .valuationPercentShare,
                                          //   decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.all(
                                          //         Radius.circular(5.0),
                                          //       ),
                                          //       color:
                                          //           Utils.primaryColor),
                                          // ),
                                          Container(
                                            height: 10,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width /
                                                3,
                                            decoration:
                                            const BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              color: Utils.dullWhiteColor,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: PortfolioHoldingController
                                                      .getHoldingListItems[
                                                  index]
                                                      .valuationPercentShare >
                                                      100
                                                      ? MediaQuery
                                                      .of(
                                                      context)
                                                      .size
                                                      .width /
                                                      3
                                                      : PortfolioHoldingController
                                                      .getHoldingListItems[
                                                  index]
                                                      .valuationPercentShare <
                                                      5
                                                      ? 6
                                                      : (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.003) *
                                                      PortfolioHoldingController
                                                          .getHoldingListItems[
                                                      index]
                                                          .valuationPercentShare,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius: PortfolioHoldingController
                                                        .getHoldingListItems[
                                                    index]
                                                        .valuationPercentShare >=
                                                        0 &&
                                                        PortfolioHoldingController
                                                            .getHoldingListItems[
                                                        index]
                                                            .valuationPercentShare <=
                                                            10
                                                        ? const BorderRadius
                                                        .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          5.0),
                                                      bottomLeft: Radius
                                                          .circular(
                                                          5.0),
                                                    )
                                                        : const BorderRadius
                                                        .all(
                                                      Radius
                                                          .circular(
                                                          5.0),
                                                    ),
                                                    color: Utils
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Container(
                                                  width: PortfolioHoldingController
                                                      .getHoldingListItems[
                                                  index]
                                                      .valuationPercentShare >
                                                      100
                                                      ? 0
                                                      : PortfolioHoldingController
                                                      .getHoldingListItems[
                                                  index]
                                                      .valuationPercentShare <
                                                      5
                                                      ? MediaQuery
                                                      .of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.003 *
                                                      90
                                                      : (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.003) *
                                                      (100 -
                                                          PortfolioHoldingController
                                                              .getHoldingListItems[index]
                                                              .valuationPercentShare),
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius: PortfolioHoldingController
                                                        .getHoldingListItems[
                                                    index]
                                                        .valuationPercentShare >=
                                                        0 &&
                                                        PortfolioHoldingController
                                                            .getHoldingListItems[
                                                        index]
                                                            .valuationPercentShare <=
                                                            10
                                                        ? BorderRadius
                                                        .only(
                                                      topRight: Radius
                                                          .circular(
                                                          5.0),
                                                      bottomRight: Radius
                                                          .circular(
                                                          5.0),
                                                    )
                                                        : BorderRadius
                                                        .all(
                                                      Radius
                                                          .circular(
                                                          5.0),
                                                    ),
                                                    color: Utils
                                                        .dullWhiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            // PortfolioHoldingController.getHoldingListItems[index].valuationPercentShare.toStringAsFixed(2),
                                            "${PortfolioHoldingController
                                                .getHoldingListItems[index]
                                                .valuationPercentShare
                                                .toStringAsFixed(2)} %",
                                            style: Utils.fonts(
                                              fontWeight: FontWeight.w500,
                                              size: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                        ),
                      ],
                    );
                  }),
                  InkWell(
                    onTap: () {
                      setState(() {
                        expandedSectoralHoldings
                            ? expandedSectoralHoldings = false
                            : expandedSectoralHoldings = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          expandedSectoralHoldings
                              ? Text(
                                  "View less",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              : Text(
                                  "View more",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                          expandedSectoralHoldings
                              ? RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    size: 40,
                                    color: Utils.primaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_drop_down,
                                  size: 40,
                                  color: Utils.primaryColor,
                                )
                          // SizedBox(width: 5,),
                          // SvgPicture.asset(
                          //   "assets/appImages/upload.svg",
                          //   // width: 200,
                          //   // height: 200,
                          // ),
                          // Icon(Icons.arrow_drop_down,size: 40,color: Utils.primaryColor,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Events",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 16.0,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              size: 20,
                            )
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              _scrollTop();
                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg")),
                        // Icon(
                        //   CupertinoIcons.arrow_up_left_circle,
                        //   color: Utils.primaryColor,
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(
                          right: 5,
                        ), //top: 8,bottom: 8
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          // height: 50,
                          decoration: BoxDecoration(
                            color: Utils.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dividend",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w600,
                                    size: 16.0,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "2 Scrip",
                                        style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            color: Utils.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            "View",
                                            style: TextStyle(
                                                // decoration: TextDecoration.underline,
                                                color: Utils.blackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                          // SizedBox(
                                          //   width: 5,
                                          // ),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: Utils.blackColor,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            // news(context),
            NewsScreen(holdings_scripCode),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor,
              ),
            ),
            topGrainers(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor,
              ),
            ),
            topLosers(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  news(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
                },
                child: Row(
                  children: [
                    Text(
                      "Holdings News",
                      style: Utils.fonts(
                        size: 18.0,
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsPage()));
                          },
                          child: SvgPicture.asset(
                              "assets/appImages/arrow_right_circle.svg")),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: Observer(builder: (context) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: Dataconstants.todayNews.filteredNews.length,
                    itemBuilder: (context, index) => InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (Dataconstants.todayNews.filteredNews[index]
                                        .staticModel !=
                                    null)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Dataconstants.todayNews
                                          .filteredNews[index].staticModel.name,
                                      style: Utils.fonts(
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                if (Dataconstants.todayNews.filteredNews[index]
                                        .staticModel !=
                                    null)
                                  SizedBox(
                                    height: 10,
                                  ),
                                Text(
                                  Dataconstants.todayNews.filteredNews[index]
                                      .description,
                                  style: Utils.fonts(
                                      size: 13.0, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      color: categoryColor(Dataconstants
                                              .todayNews
                                              .filteredNews[index]
                                              .category)
                                          .withOpacity(0.2),
                                      child: Text(
                                        Dataconstants.todayNews
                                            .filteredNews[index].category,
                                        style: Utils.fonts(
                                            size: 14.0,
                                            color: categoryColor(Dataconstants
                                                .todayNews
                                                .filteredNews[index]
                                                .category)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          Dataconstants.todayNews
                                              .filteredNews[index].newsTime,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                      onTap: Dataconstants
                                  .todayNews.filteredNews[index].staticModel ==
                              null
                          ? null
                          : () {
                              ScripInfoModel tempModel =
                                  CommonFunction.getScripDataModel(
                                      exch: Dataconstants.todayNews
                                          .filteredNews[index].staticModel.exch,
                                      exchCode: Dataconstants
                                          .todayNews
                                          .filteredNews[index]
                                          .staticModel
                                          .exchCode,
                                      getNseBseMap: true);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScriptInfo(
                                    tempModel,
                                    false,
                                  ),
                                ),
                              );
                            },
                    ),
                  );
                }),
              ),
              // for (var i = 0; i < 4; i++)
              //   Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 10.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SvgPicture.asset("assets/appImages/dashboard/Ellipse 503.svg"),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     "Adani Green Energy net profit rises 14% to Rs 49 cr ",
              //                     style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                   ),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Row(
              //                     children: [
              //                       Text(
              //                         "Moneycontrol",
              //                         style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
              //                       ),
              //                       Spacer(),
              //                       Text(
              //                         "2 Hours Ago",
              //                         style: Utils.fonts(size: 12.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                       )
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(
              //         thickness: 2,
              //       )
              //     ],
              //   )
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Color categoryColor(String category) {
    switch (category) {
      case 'Stocks':
        return Colors.lightBlue;
      case 'Commentary':
        return Colors.pink;
      case 'Global':
        return Colors.deepOrange;
      case 'Block Details':
        return Colors.blue;
      case 'Result':
        return Colors.purple;
      case 'Commodities':
        return Colors.amber;
      case 'Fixed income':
        return Colors.lightGreen;
      case 'Special Coverage':
        return Colors.teal;
      default:
        return Colors.lightBlue;
    }
  }

  topGrainers() {
    return DetailsControlller.getDetailResultListItems.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (topGainersExpanded == false) {
                          topGainersExpanded = true;
                        } else if (topGainersExpanded == true) {
                          topGainersExpanded = false;
                        }
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Top Gainers",
                            style: Utils.fonts(
                                size: 17.0, color: Utils.blackColor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                              "assets/appImages/arrow_right_circle.svg"),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                _scrollTop();
                              },
                              child: SvgPicture.asset(
                                  "assets/appImages/markets/up_arrow.svg"))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // // InkWell(
                              // //   onTap: () {
                              // //     topGainersTab = 1;
                              // //     Dataconstants.topGainersController.getTopGainers("day");
                              // //     setState(() {});
                              // //   },
                              // //   child: Container(
                              // //       decoration: BoxDecoration(
                              // //         border: Border(
                              // //             left: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             top: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             bottom: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             right: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             )),
                              // //       ),
                              // //       child: Padding(
                              // //         padding: const EdgeInsets.all(8.0),
                              // //         child: Text(
                              // //           "1 Day",
                              // //           style: Utils.fonts(size: 12.0, color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              // //         ),
                              // //       )),
                              // // ),
                              // // InkWell(
                              // //   onTap: () {
                              // //     topGainersTab = 2;
                              // //     Dataconstants.topGainersController.getTopGainers("month");
                              // //     setState(() {});
                              // //   },
                              // //   child: Container(
                              // //       decoration: BoxDecoration(
                              // //         border: Border(
                              // //             left: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             top: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             bottom: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             right: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             )),
                              // //       ),
                              // //       child: Padding(
                              // //         padding: const EdgeInsets.all(8.0),
                              // //         child: Text(
                              // //           "Monthly",
                              // //           style: Utils.fonts(size: 12.0, color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              // //         ),
                              // //       )),
                              // // ),
                              // InkWell(
                              //   onTap: () {
                              //     topGainersTab = 3;
                              //     Dataconstants.topGainersController.getTopGainers("week");
                              //     setState(() {});
                              //   },
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //         border: Border(
                              //             left: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             top: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             bottom: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             right: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             )),
                              //       ),
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Text(
                              //           "Weekly",
                              //           style: Utils.fonts(size: 12.0, color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              //         ),
                              //       )),
                              // ),
                              InkWell(
                                onTap: () {
                                  topGainersTab = 4;
                                  setState(() {
                                    // Dataconstants.detailsController.getDetailResult();
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: topGainersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: topGainersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: topGainersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: topGainersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "My Holdings",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: topGainersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // topGainersTab == 4
                    //     ? Center(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               "No Data Avialable",
                    //               style: TextStyle(
                    //                 fontSize: 16.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : topGainersExpanded
                    //         ? Column(
                    //             children: [
                    //               Padding(
                    //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //                   child: ListView.builder(
                    //                     shrinkWrap: true,
                    //                     padding: EdgeInsets.zero,
                    //                     scrollDirection: Axis.vertical,
                    //                     physics: CustomTabBarScrollPhysics(),
                    //                     itemCount: 4,
                    //                     itemBuilder: (BuildContext context, int index) {
                    //                       return Column(
                    //                         children: [
                    //                           Padding(
                    //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //                             child: Row(
                    //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                               children: [
                    //                                 Expanded(
                    //                                   flex: 2,
                    //                                   child: Text(
                    //                                     DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                     style: Utils.fonts(),
                    //                                   ),
                    //                                 ),
                    //                                 Expanded(
                    //                                   flex: 1,
                    //                                   child: Text(
                    //                                     DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                     style: Utils.fonts(
                    //                                       color: Utils.greyColor,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 Expanded(
                    //                                   flex: 1,
                    //                                   child: Row(
                    //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                     children: [
                    //                                       SizedBox(),
                    //                                       Text(
                    //                                         DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                         style: Utils.fonts(
                    //                                           color: Utils.mediumGreenColor,
                    //                                         ),
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 )
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           Divider(
                    //                             thickness: 1,
                    //                           )
                    //                         ],
                    //                       );
                    //                     },
                    //                   )),
                    //             ],
                    //           )
                    //         :
                    Container(
                      child: Column(
                        children: [
                          for (var i = 0; i < topGainerList.length; i++)
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      // currentModel = CommonFunction
                                      //     .getScripDataModelFastForIQS(
                                      //         exchPos: int.tryParse(
                                      //                         topGainerList[i]
                                      //                             .scripCode) >
                                      //                     0 &&
                                      //                 int.tryParse(
                                      //                         topGainerList[i]
                                      //                             .scripCode) <
                                      //                     34999
                                      //             ? 0
                                      //             : 2,
                                      //         exchCode: int.tryParse(
                                      //             topGainerList[i].scripCode));
                                      Navigator.of(context).push(
                                        // MaterialPageRoute(
                                        //   builder: (context) => ScriptInfo(
                                        //     currentModel,
                                        //     false,
                                        //   ),
                                        // ),
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(CommonFunction.getScripDataModel(
                                                exch: int.parse(topGainerList[i].scripCode) >= 500000 ? "B" : "N",
                                                exchCode: int.parse(topGainerList[i].scripCode.toString())), false)
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            topGainerList[i].scripName,
                                            style: Utils.fonts(
                                                size: 14.0,
                                                color: Utils.blackColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.arrow_drop_up_rounded,
                                                  color: Utils.lightGreenColor,
                                                ),
                                                Observer(
                                                  builder: (context) {
                                                    return Text(
                                                      diff(
                                                              topGainerList[i]
                                                                  .valRate,
                                                              dataListTopGainer[
                                                                      i]
                                                                  .close)
                                                          .toStringAsFixed(2),
                                                      style: Utils.fonts(
                                                          size: 14.0,
                                                          color: Utils
                                                              .lightGreenColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    );
                                                  },
                                                ),
                                              ]),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Observer(builder: (context) {
                                                return Text(
                                                  dataListTopGainer[i]
                                                      .close
                                                      .toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: Utils.blackColor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        // Expanded(
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     children: [
                                        //         Text(
                                        //           datalist[i].close.toStringAsFixed(2),
                                        //         //SummaryController.getSummaryDetailListItems[i].valuationPercentShare.toStringAsFixed(2),
                                        //         style: Utils.fonts(size: .0, color: Utils.blackColor, fontWeight: FontWeight.w500),)
                                        //       // Observer(
                                        //       //   builder: (context) {
                                        //       //     return
                                        //       //     Text(
                                        //       //       datalist[i].close.toStringAsFixed(2),
                                        //       //       // SummaryController.getSummaryDetailListItems[i].valuationPercentShare.toStringAsFixed(2),
                                        //       //       style: Utils.fonts(size: .0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                        //       //     );
                                        //       //   }
                                        //       // ),
                                        //       // Text(
                                        //       //   datalist[i].close.toStringAsFixed(2),
                                        //       //   style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                        //       // ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 4.0,
                width: MediaQuery.of(context).size.width,
                color: Utils.greyColor.withOpacity(0.2),
              ),
            ],
          );
  }

  topLosers() {
    return DetailsControlller.getDetailResultListItems.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (topGainersExpanded == false) {
                          topGainersExpanded = true;
                        } else if (topGainersExpanded == true) {
                          topGainersExpanded = false;
                        }
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Top Loser",
                            style: Utils.fonts(
                                size: 17.0, color: Utils.blackColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                              "assets/appImages/arrow_right_circle.svg"),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                _scrollTop();
                              },
                              child: SvgPicture.asset(
                                  "assets/appImages/markets/up_arrow.svg"))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // // InkWell(
                              // //   onTap: () {
                              // //     topGainersTab = 1;
                              // //     Dataconstants.topGainersController.getTopGainers("day");
                              // //     setState(() {});
                              // //   },
                              // //   child: Container(
                              // //       decoration: BoxDecoration(
                              // //         border: Border(
                              // //             left: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             top: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             bottom: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             right: BorderSide(
                              // //               color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             )),
                              // //       ),
                              // //       child: Padding(
                              // //         padding: const EdgeInsets.all(8.0),
                              // //         child: Text(
                              // //           "1 Day",
                              // //           style: Utils.fonts(size: 12.0, color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              // //         ),
                              // //       )),
                              // // ),
                              // // InkWell(
                              // //   onTap: () {
                              // //     topGainersTab = 2;
                              // //     Dataconstants.topGainersController.getTopGainers("month");
                              // //     setState(() {});
                              // //   },
                              // //   child: Container(
                              // //       decoration: BoxDecoration(
                              // //         border: Border(
                              // //             left: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             top: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             bottom: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             ),
                              // //             right: BorderSide(
                              // //               color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                              // //               width: 1,
                              // //             )),
                              // //       ),
                              // //       child: Padding(
                              // //         padding: const EdgeInsets.all(8.0),
                              // //         child: Text(
                              // //           "Monthly",
                              // //           style: Utils.fonts(size: 12.0, color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              // //         ),
                              // //       )),
                              // // ),
                              // InkWell(
                              //   onTap: () {
                              //     topGainersTab = 3;
                              //     Dataconstants.topGainersController.getTopGainers("week");
                              //     setState(() {});
                              //   },
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //         border: Border(
                              //             left: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             top: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             bottom: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             ),
                              //             right: BorderSide(
                              //               color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                              //               width: 1,
                              //             )),
                              //       ),
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Text(
                              //           "Weekly",
                              //           style: Utils.fonts(size: 12.0, color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              //         ),
                              //       )),
                              // ),
                              InkWell(
                                onTap: () {
                                  topLosersTab = 4;
                                  setState(() {
                                    // Dataconstants.detailsController.getDetailResult();
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: topLosersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: topLosersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: topLosersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: topLosersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "My Holdings",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: topLosersTab == 4
                                                ? Utils.primaryColor
                                                : Utils.primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // topGainersTab == 4
                    //     ? Center(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               "No Data Avialable",
                    //               style: TextStyle(
                    //                 fontSize: 16.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : topGainersExpanded
                    //         ? Column(
                    //             children: [
                    //               Padding(
                    //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //                   child: ListView.builder(
                    //                     shrinkWrap: true,
                    //                     padding: EdgeInsets.zero,
                    //                     scrollDirection: Axis.vertical,
                    //                     physics: CustomTabBarScrollPhysics(),
                    //                     itemCount: 4,
                    //                     itemBuilder: (BuildContext context, int index) {
                    //                       return Column(
                    //                         children: [
                    //                           Padding(
                    //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //                             child: Row(
                    //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                               children: [
                    //                                 Expanded(
                    //                                   flex: 2,
                    //                                   child: Text(
                    //                                     DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                     style: Utils.fonts(),
                    //                                   ),
                    //                                 ),
                    //                                 Expanded(
                    //                                   flex: 1,
                    //                                   child: Text(
                    //                                     DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                     style: Utils.fonts(
                    //                                       color: Utils.greyColor,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 Expanded(
                    //                                   flex: 1,
                    //                                   child: Row(
                    //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                     children: [
                    //                                       SizedBox(),
                    //                                       Text(
                    //                                         DetailsControlller.getDetailResultListItems[index].scripName,
                    //                                         style: Utils.fonts(
                    //                                           color: Utils.mediumGreenColor,
                    //                                         ),
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 )
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           Divider(
                    //                             thickness: 1,
                    //                           )
                    //                         ],
                    //                       );
                    //                     },
                    //                   )),
                    //             ],
                    //           )
                    //         :
                    Column(
                      children: [
                        for (var i = 0; i < topLoserList.length; i++)
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    // currentModel = CommonFunction
                                    //     .getScripDataModelFastForIQS(
                                    //         exchPos: int.tryParse(
                                    //                         topLoserList[i]
                                    //                             .scripCode) >
                                    //                     0 &&
                                    //                 int.tryParse(topLoserList[i]
                                    //                         .scripCode) <
                                    //                     34999
                                    //             ? 0
                                    //             : 2,
                                    //         exchCode: int.tryParse(
                                    //             topLoserList[i].scripCode));
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ScriptInfo(
                                    //       currentModel,
                                    //       true,
                                    //     ),
                                    //   ),
                                    // );

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                    exch: int.parse(topLoserList[i].scripCode) >= 500000 ? "B" : "N",
                                                    exchCode: int.parse(topLoserList[i].scripCode.toString())),
                                                false)));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          topLoserList[i].scripName,
                                          style: Utils.fonts(
                                              size: 14.0,
                                              color: Utils.blackColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Utils.lightRedColor,
                                              ),
                                              Observer(
                                                builder: (context) {
                                                  return Text(
                                                    diff(
                                                            topLoserList[i]
                                                                .valRate,
                                                            dataListTopLoss[i]
                                                                .close)
                                                        .toStringAsFixed(2),
                                                    style: Utils.fonts(
                                                        size: 14.0,
                                                        color:
                                                            Utils.lightRedColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  );
                                                },
                                              ),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Observer(builder: (context) {
                                              return Text(
                                                dataListTopLoss[i]
                                                    .close
                                                    .toStringAsFixed(2),
                                                style: Utils.fonts(
                                                    size: 14.0,
                                                    color: Utils.blackColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      // Expanded(
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //         Text(
                                      //           datalist[i].close.toStringAsFixed(2),
                                      //         //SummaryController.getSummaryDetailListItems[i].valuationPercentShare.toStringAsFixed(2),
                                      //         style: Utils.fonts(size: .0, color: Utils.blackColor, fontWeight: FontWeight.w500),)
                                      //       // Observer(
                                      //       //   builder: (context) {
                                      //       //     return
                                      //       //     Text(
                                      //       //       datalist[i].close.toStringAsFixed(2),
                                      //       //       // SummaryController.getSummaryDetailListItems[i].valuationPercentShare.toStringAsFixed(2),
                                      //       //       style: Utils.fonts(size: .0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                      //       //     );
                                      //       //   }
                                      //       // ),
                                      //       // Text(
                                      //       //   datalist[i].close.toStringAsFixed(2),
                                      //       //   style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                      //       // ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              )
                            ],
                          )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 4.0,
                width: MediaQuery.of(context).size.width,
                color: Utils.greyColor.withOpacity(0.2),
              ),
            ],
          );
  }

  topLosersold() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (topLosersExpanded == false) {
                      topLosersExpanded = true;
                    } else if (topLosersExpanded == true) {
                      topLosersExpanded = false;
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Top Losers",
                        style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                          "assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset(
                              "assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              topLosersTab = 2;
                              Dataconstants.topLosersController
                                  .getTopLosers("nse", "nifty", "month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 3;
                              Dataconstants.topLosersController
                                  .getTopLosers("nse", "nifty", "month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 1;
                              Dataconstants.topLosersController
                                  .getTopLosers("nse", "nifty", "month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                topLosersTab == 4
                    ? Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Data Available",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ))
                    : TopLosersController.getTopLosersListItems.isEmpty
                        ? Center(
                            child: Row(
                              children: [
                                Text(
                                  "Loading",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      '.....',
                                      textStyle: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      speed: const Duration(milliseconds: 100),
                                    ),
                                  ],
                                  totalRepeatCount: 400,
                                ),
                              ],
                            ),
                          )
                        : topLosersExpanded
                            ? Column(
                                children: [
                                  for (var i = 0;
                                      i <
                                          TopLosersController
                                              .getTopLosersListItems.length;
                                      i++)
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  TopLosersController
                                                      .getTopLosersListItems[i]
                                                      .symbol,
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: Utils.blackColor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_drop_up_rounded,
                                                        color: Utils
                                                            .lightGreenColor,
                                                      ),
                                                      Text(
                                                        "${TopLosersController.getTopLosersListItems[i].perchg.toStringAsFixed(2)}%",
                                                        style: Utils.fonts(
                                                            size: 14.0,
                                                            color: Utils
                                                                .lightGreenColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ]),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      TopLosersController
                                                          .getTopLosersListItems[
                                                              i]
                                                          .prevClose
                                                          .toString(),
                                                      style: Utils.fonts(
                                                          size: 14.0,
                                                          color:
                                                              Utils.blackColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    )
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        physics: CustomTabBarScrollPhysics(),
                                        itemCount: 4,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        TopLosersController
                                                            .getTopLosersListItems[
                                                                index]
                                                            .symbol,
                                                        style: Utils.fonts(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        TopLosersController
                                                            .getTopLosersListItems[
                                                                index]
                                                            .perchg
                                                            .toStringAsFixed(2),
                                                        style: Utils.fonts(
                                                          color:
                                                              Utils.greyColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(),
                                                          Text(
                                                            TopLosersController
                                                                .getTopLosersListItems[
                                                                    index]
                                                                .prevClose
                                                                .toString(),
                                                            style: Utils.fonts(
                                                              color: Utils
                                                                  .mediumGreenColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                              )
                                            ],
                                          );
                                        },
                                      )),
                                ],
                              )
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  void getHoldingsScripCode() {
    for (int i = 0;
        i < PortfolioHoldingController.getHoldingListItems.length;
        i++) {
      var val = PortfolioHoldingController.getHoldingListItems[i].scripCode;
      holdings_scripCode = int.tryParse(val);
    }
  }

  void getMarketCapAllocationData() async {
    // Define a list variable to hold the data
    List<dynamic> data = [];

    // Load the data from the jsonString variable
    List<TrPositionsCmGetDataResult> jsonData = SummaryController.getSummaryDetailListItems;
    data = jsonDecode(json.encode(jsonData))['TrPositionsCmGetDataResult'];

    // Calculate the total market cap of the portfolio
    for (var stock in data) {
      totalMarketCap += stock['MarketValue'] * stock['Multiplier'];
    }

    // Calculate the market cap allocation for each stock
    for (var stock in data) {
      var marketCap = stock['MarketValue'] * stock['Multiplier'];
      stock['MarketCap'] = marketCap;
      if (stock['MarketCapPercent'] == null) {
        stock['MarketCapPercent'] = 0.0;
      }
      if (totalMarketCap != 0) {
        stock['MarketCapPercent'] = marketCap / totalMarketCap * 100;
      }

      if (stock['MarketCapPercent'] < 30) {
        marketCapAllocation['SmallCap'] += stock['MarketCapPercent'];
      } else if (stock['MarketCapPercent'] < 70) {
        marketCapAllocation['MidCap'] += stock['MarketCapPercent'];
      } else {
        marketCapAllocation['LargeCap'] += stock['MarketCapPercent'];
      }
    }

    setState(() {});
  }

  int getTopHoldingLength() {
    int count = 0;
    if (!expandedHoldings &&
        PortfolioHoldingController.getHoldingListItems.length >= 5) {
      // length = 5
      count = 5;
      // if (PortfolioHoldingController.sectors.length > 5) {
      //   count = 5;
      // }
      // else
      // {
      //   count = PortfolioHoldingController.sectors.length;
      // }
    } else {
      print("holding list_size::  ${PortfolioHoldingController.getHoldingListItems
          .length}");
      count = PortfolioHoldingController.getHoldingListItems.isNotEmpty
          ? PortfolioHoldingController.getHoldingListItems.length
          : 0;
    }
    return count;
  }
  int getSectorialHoldingLength() {
    int count = 0;
    if (!expandedSectoralHoldings &&
        PortfolioHoldingController.getHoldingListItems.length >= 5) {
      // length = 5
      count = 5;
      // if (PortfolioHoldingController.sectors.length > 5) {
      //   count = 5;
      // }
      // else
      // {
      //   count = PortfolioHoldingController.sectors.length;
      // }
    } else {
      print("list_size::  ${PortfolioHoldingController.getHoldingListItems
          .length}");
      count = PortfolioHoldingController.getHoldingListItems.isNotEmpty
          ? PortfolioHoldingController.getHoldingListItems.length
          : 0;
    }
    return count;
  }

  Future<void> getHoldingsEvents()
  {

    Dataconstants.eventsDividendController.getEventsDividend();
    Dataconstants.eventsBonusController.getEventsBonus();
    Dataconstants.eventsSplitsController.getEventsSplits();
    Dataconstants.boardMeetController.getEventsBoardMeet();
    Dataconstants.eventsRightsController.getEventsRights();

    List<TrPositionsCmGetDataResult2> holdingList = PortfolioHoldingController
        .holdings.value.trPositionsCmGetDataResult;

    List<EventsDividend.Datum> DividendList = EventsDividendController.eventsDividend.value.data?? [];
    List<EventsBonus.Datum> BonusList = EventsBonusController.eventsBonus.value.data?? [];
    List<EventsSplits.Datum> SplitsList = EventsSplitsController.eventsSplits.value.data ?? [];
    List<EventsRight.Datum> EventRights = EventsRightsController.eventsRights.value.data?? [];
    List<EventsBoardMeet.Datum> BoardsList = BoardMeetController.eventsBoardMeet.value.data ?? [];

    // List<EventsDividend.Datum> matchingDividends = DividendList.where((dividendElement) {
    //   return holdingList.any((holdingElement) {
    //     return holdingElement.scripCode == dividendElement.scCode;
    //   });
    // }).toList();

    List<EventsDividend.Datum> matchingDividends = DividendList.where((element1) {
      return holdingList.every((element2) => element2.scripCode == element1.scCode);
    }).toList();

    List<EventsBonus.Datum> matchingBonus = BonusList.where((element1) {
      return holdingList.every((element2) => element2.scripCode == element1.scCode);
    }).toList();

    List<EventsSplits.Datum> matchingSplits = SplitsList.where((element1) {
      return holdingList.every((element2) => element2.scripCode == element1.scCode);
    }).toList();

    List<EventsRight.Datum> matchingRights = EventRights.where((element1) {
      return holdingList.every((element2) => element2.scripCode == element1.coCode);
    }).toList();

    List<EventsBoardMeet.Datum> boardMeet = BoardsList.where((element1) {
      return holdingList.every((element2) => element2.scripCode == element1.coCode);
    }).toList();

    print("Holding List: ${holdingList.toString()}");
    print("Dividend List: ${DividendList.toString()}");
    print("Matching Events Holding List: $matchingDividends");
    print("Matching Bonus Holding List: $matchingBonus");
    print("Matching Splits Holding List: $matchingSplits");
    print("Matching Splits Holding List: $matchingRights");
    print("Matching Board Holding List: $boardMeet");

  }

  }

