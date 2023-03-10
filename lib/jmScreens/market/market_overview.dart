import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/MostActiveFuturesController.dart';
import '../../controllers/MostActivePutController.dart';
import '../../controllers/MostActiveTurnoverController.dart';
import '../../controllers/MostActiveVolumeController.dart';
import '../../controllers/OpenIpoController.dart';
import '../../controllers/mostActiveCallController.dart';
import '../../controllers/topGainersController.dart';
import '../../controllers/topLosersController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../../widget/scripdetail_chart.dart';
import '../../widget/smallChart.dart';

class MarketOverView extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<MarketOverView> createState() => _MarketOverViewState();
}

class _MarketOverViewState extends State<MarketOverView> {
  final ScrollController _controller = ScrollController();
  ScrollController _scrollController = ScrollController();
  int touchedIndex = -1;
  var topIndustries = 1;

  var otherAssets = 1;
  var researchPicks = 1;
  var topGainersTab = 1;
  var topLosersTab = 1;
  var otherAssetTab = 1;
  var topLosersExpanded = false;
  var mostActiveExpanded = false;
  var mostActiveTab = 1;
  var guruPortfolio = 1;
  bool sensexFlag = false, niftyFlag = true, bankNiftyFlag = false;
  var topGainersExpanded = false;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  var totalMarketValueNifty, totalMarketValueSensex;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Dataconstants.itsClient.getChartData(timeInterval: 5, chartPeriod: 'I', model: Dataconstants.indicesListener.indices1);
      Dataconstants.itsClient.getChartData(timeInterval: 5, chartPeriod: 'I', model: Dataconstants.indicesListener.indices2);
      Dataconstants.itsClient.getChartData(timeInterval: 5, chartPeriod: 'I', model: Dataconstants.indicesListener.indices3);
    });
    Dataconstants.topPerformingIndustriesController.getTopPerformingIndustries();
    totalMarketValueNifty = (Dataconstants.indicesListener.indices1.totalBuyQty + Dataconstants.indicesListener.indices1.totalSellQty);
    totalMarketValueSensex = (Dataconstants.indicesListener.indices2.totalBuyQty + Dataconstants.indicesListener.indices2.totalSellQty);

    Dataconstants.nseAdvanceController.getNseAdvance();
    Dataconstants.bseAdvanceController.getBseAdvance();

    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Divider(
            thickness: 2,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text(
                  "Op: ",
                  style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                ),
                Text(
                  sensexFlag
                      ? Dataconstants.indicesListener.indices2.open.toStringAsFixed(2)
                      : niftyFlag
                          ? Dataconstants.indicesListener.indices1.open.toStringAsFixed(2)
                          : bankNiftyFlag
                              ? Dataconstants.indicesListener.indices3.open.toStringAsFixed(2)
                              : "",
                  style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Text("Hi: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                Text(
                  sensexFlag
                      ? Dataconstants.indicesListener.indices2.high.toStringAsFixed(2)
                      : niftyFlag
                          ? Dataconstants.indicesListener.indices1.high.toStringAsFixed(2)
                          : bankNiftyFlag
                              ? Dataconstants.indicesListener.indices3.high.toStringAsFixed(2)
                              : "",
                  style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Text("Lo: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                Observer(builder: (_) {
                  return Text(
                    sensexFlag
                        ? Dataconstants.indicesListener.indices2.low.toStringAsFixed(2)
                        : niftyFlag
                            ? Dataconstants.indicesListener.indices1.low.toStringAsFixed(2)
                            : bankNiftyFlag
                                ? Dataconstants.indicesListener.indices3.low.toStringAsFixed(2)
                                : "",
                    style: Utils.fonts(size: 13.0, color: Utils.lightRedColor, fontWeight: FontWeight.w500),
                  );
                })
              ],
            ),
            Row(
              children: [
                Text("Cl: ", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                Observer(builder: (_) {
                  return Text(
                    sensexFlag
                        ? Dataconstants.indicesListener.indices2.close.toStringAsFixed(2)
                        : niftyFlag
                            ? Dataconstants.indicesListener.indices1.close.toStringAsFixed(2)
                            : bankNiftyFlag
                                ? Dataconstants.indicesListener.indices3.close.toStringAsFixed(2)
                                : "",
                    style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                  );
                })
              ],
            ),
          ]),
          Divider(
            thickness: 2,
          ),
          if (sensexFlag)
            Observer(
              builder: (context) => Dataconstants.indicesListener.indices1.chartMinClose[5].length > 0
                  ? ScripdetailChart(
                      seriesList: Dataconstants.indicesListener.indices1.dataPoint[5],
                      prevClose: Dataconstants.indicesListener.indices1.prevDayClose,
                      animate: true,
                    )
                  : SizedBox.shrink(),
            )
          else if (niftyFlag)
            Observer(
              builder: (context) => Dataconstants.indicesListener.indices2.chartMinClose[5].length > 0
                  ? ScripdetailChart(
                      seriesList: Dataconstants.indicesListener.indices2.dataPoint[5],
                      prevClose: Dataconstants.indicesListener.indices2.prevDayClose,
                      animate: true,
                    )
                  : SizedBox.shrink(),
            )
          else
            Observer(
              builder: (context) => Dataconstants.indicesListener.indices3.chartMinClose[5].length > 0
                  ? ScripdetailChart(
                      seriesList: Dataconstants.indicesListener.indices3.dataPoint[5],
                      prevClose: Dataconstants.indicesListener.indices3.prevDayClose,
                      animate: true,
                    )
                  : SizedBox.shrink(),
            ),

          // Container(
          //   height: 180,
          //   width: MediaQuery.of(context).size.width,
          //   child: SmallSimpleLineChart(
          //     seriesList: sensexFlag
          //         ? Dataconstants.indicesListener.indices1.dataPoint[15]
          //         : niftyFlag
          //         ? Dataconstants.indicesListener.indices2.dataPoint[15]
          //         : Dataconstants.indicesListener.indices3.dataPoint[15],
          //     prevClose: Dataconstants.indicesListener.indices1.prevDayClose,
          //     name: Dataconstants.indicesListener.indices1.name,
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    sensexFlag = true;
                    niftyFlag = false;
                    bankNiftyFlag = false;
                    setState(() {});
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.33,
                    decoration: BoxDecoration(border: Border.all(color: sensexFlag ? Utils.primaryColor : Utils.greyColor), borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sensex", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Observer(
                            builder: (_) => Text(
                              Dataconstants.indicesListener.indices2.close.toStringAsFixed(2),
                              style: Utils.fonts(size: 13.0, color: Utils.blackColor),
                            ),
                          ),
                          Observer(
                            builder: (_) => Row(
                              children: [
                                Icon(
                                  Dataconstants.indicesListener.indices1.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                  color: Dataconstants.indicesListener.indices1.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                ),
                                Text(
                                  Dataconstants.indicesListener.indices1.percentChange.toStringAsFixed(2),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Dataconstants.indicesListener.indices1.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    niftyFlag = true;
                    sensexFlag = false;
                    bankNiftyFlag = false;
                    setState(() {});
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.33,
                    decoration: BoxDecoration(border: Border.all(color: niftyFlag ? Utils.primaryColor : Utils.greyColor), borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Nifty", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Observer(
                            builder: (_) => Text(
                              Dataconstants.indicesListener.indices1.close.toStringAsFixed(2),
                              style: Utils.fonts(size: 15.0, color: Utils.blackColor),
                            ),
                          ),
                          Observer(
                            builder: (_) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Dataconstants.indicesListener.indices2.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                  color: Dataconstants.indicesListener.indices2.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                ),
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.indicesListener.indices2.percentChange.toStringAsFixed(2),
                                    style: Utils.fonts(size: 12.0, color: Dataconstants.indicesListener.indices2.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    bankNiftyFlag = true;
                    sensexFlag = false;
                    niftyFlag = false;
                    setState(() {});
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.33,
                    decoration: BoxDecoration(border: Border.all(color: bankNiftyFlag ? Utils.primaryColor : Utils.greyColor), borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Bank Nifty", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Utils.greyColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Observer(
                            builder: (_) => Text(
                              Dataconstants.indicesListener.indices3.close.toStringAsFixed(2),
                              style: Utils.fonts(size: 12.0, color: Utils.blackColor),
                            ),
                          ),
                          Observer(
                            builder: (_) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Dataconstants.indicesListener.indices3.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                  color: Dataconstants.indicesListener.indices3.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                ),
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.indicesListener.indices3.percentChange.toStringAsFixed(2),
                                    style: Utils.fonts(size: 13.0, color: Dataconstants.indicesListener.indices3.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          HomeWidgets.otherAsset(),
          SizedBox(height: 10),
          Divider(
            thickness: 3,
          ),
          // marketBreadth(),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Trending Stocks',
                    style: Utils.fonts(
                      size: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Utils.greyColor.withOpacity(0.2),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Utils.greyColor,
                      size: 11,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              for (var i = 0; i < 4; i++)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              'ONGC',
                              style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("12323.43", style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Colors.black)),
                            Row(
                              children: [
                                SvgPicture.asset("assets/appImages/markets/inverted_rectangle.svg"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '111.85',
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              Divider(thickness: 3),
              SizedBox(
                height: 10,
              ),
              HomeWidgets.topPerformingIndus()
            ],
          ),

          HomeWidgets.marketBreadth(),

          HomeWidgets.topGrainers(),

          SizedBox(height: 20),

          HomeWidgets.topLosers(),

          Divider(thickness: 3),

          SizedBox(
            height: 20,
          ),

          HomeWidgets.mostActive(),

          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Investment Guru Portfolios',
                    style: Utils.fonts(
                      size: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Utils.greyColor.withOpacity(0.2),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Utils.greyColor,
                      size: 11,
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                  },
                  child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
            ],
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      guruPortfolio = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: guruPortfolio == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      bottom: guruPortfolio == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      right: guruPortfolio == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                      left: guruPortfolio == 1 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Rakesh Jhunjhunwala", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: guruPortfolio == 1 ? Utils.primaryColor : Utils.greyColor)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      guruPortfolio = 2;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: guruPortfolio == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      bottom: guruPortfolio == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      right: guruPortfolio == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                      left: guruPortfolio == 2 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Dolly Khanna", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: guruPortfolio == 2 ? Utils.primaryColor : Utils.greyColor)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      guruPortfolio = 3;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: guruPortfolio == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      bottom: guruPortfolio == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide(color: Utils.greyColor),
                      right: guruPortfolio == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                      left: guruPortfolio == 3 ? BorderSide(color: Utils.primaryColor) : BorderSide.none,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Radhakishan Damani", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: guruPortfolio == 3 ? Utils.primaryColor : Utils.greyColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/appImages/markets/rakesh_jhunjhunwala.svg"),
                  Text(
                    'Stocks in his portfolio',
                    style: Utils.fonts(
                      size: MediaQuery.of(context).size.width * 0.033,
                      color: Utils.greyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' 31',
                    style: Utils.fonts(
                      size: MediaQuery.of(context).size.width * 0.033,
                      color: Utils.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Total Value ',
                    style: Utils.fonts(
                      size: MediaQuery.of(context).size.width * 0.033,
                      color: Utils.greyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '16,325 Cr',
                    style: Utils.fonts(
                      size: 14.0,
                      color: Utils.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          for (var i = 0; i < 4; i++)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RELIANCE',
                      style: Utils.fonts(
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset("assets/appImages/markets/inverted_rectangle.svg"),
                        ),
                        Text(
                          '13.65%',
                          style: Utils.fonts(
                            size: 12.0,
                            color: Utils.lightGreenColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '2336.90',
                      style: Utils.fonts(
                        size: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
        ],
      ),
    );
  }

  showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Utils.primaryColor,
            value: 40,
            // (gettingNiftyModel.totalSellQty / totalMarketValue) == null
            //     ? 0.0
            //     : (gettingNiftyModel.totalSellQty / totalMarketValue),
            title: '${(totalMarketValueNifty / Dataconstants.indicesListener.indices1.totalBuyQty).toString()}',
            //"${gettingNiftyModel.totalSellQty / totalMarketValue}",
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value:
                // 60,
                //gettingNiftyModel.totalBuyQty / totalMarketValue ?? 0,

                totalMarketValueNifty / Dataconstants.indicesListener.indices1.totalBuyQty,
            title: '60',
            //"${gettingNiftyModel.totalBuyQty / totalMarketValue}",
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  topGrainers() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
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
                              topGainersTab = 1;
                              Dataconstants.topGainersController.getTopGainers("day");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 2;
                              Dataconstants.topGainersController.getTopGainers("month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 3;
                              Dataconstants.topGainersController.getTopGainers("week");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
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
                TopGainersController.getTopGainersListItems.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : topGainersTab == 4
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No Data available",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : topGainersExpanded
                            ? Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        physics: CustomTabBarScrollPhysics(),
                                        itemCount: TopGainersController.getTopGainersListItems.length < 4 ? TopGainersController.getTopGainersListItems : 4,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        TopGainersController.getTopGainersListItems[index].symbol,
                                                        style: Utils.fonts(),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        TopGainersController.getTopGainersListItems[index].perchg.toStringAsFixed(2),
                                                        style: Utils.fonts(
                                                          color: Utils.greyColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(),
                                                          Text(
                                                            TopGainersController.getTopGainersListItems[index].prevClose.toString(),
                                                            style: Utils.fonts(
                                                              color: Utils.mediumGreenColor,
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
                            : Column(
                                children: [
                                  for (var i = 0; i < TopGainersController.getTopGainersListItems.length; i++)
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  TopGainersController.getTopGainersListItems[i].symbol,
                                                  style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Icon(
                                                    Icons.arrow_drop_up_rounded,
                                                    color: Utils.lightGreenColor,
                                                  ),
                                                  Text(
                                                    TopGainersController.getTopGainersListItems[i].perchg.toStringAsFixed(2),
                                                    style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                                  ),
                                                ]),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      TopGainersController.getTopGainersListItems[i].prevClose.toString(),
                                                      style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
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
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  topLosers() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
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
                              Dataconstants.topLosersController.getTopLosers("day");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 3;
                              Dataconstants.topLosersController.getTopLosers("week");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 1;
                              Dataconstants.topLosersController.getTopLosers("month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
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
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
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
                    : TopLosersController.isLoading.value == true
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
                                  if (TopLosersController.getTopLosersListItems.length < 0)
                                    Text(
                                      "No Data Available",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else
                                    for (var i = 0; i < TopLosersController.getTopLosersListItems.length; i++)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    TopLosersController.getTopLosersListItems[i].symbol,
                                                    style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                    Icon(
                                                      Icons.arrow_drop_up_rounded,
                                                      color: Utils.lightGreenColor,
                                                    ),
                                                    Text(
                                                      "${TopLosersController.getTopLosersListItems[i].perchg.toStringAsFixed(2)}%",
                                                      style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ]),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        TopLosersController.getTopLosersListItems[i].prevClose.toString(),
                                                        style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
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
                                      ),
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        physics: CustomTabBarScrollPhysics(),
                                        itemCount: 4,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        TopLosersController.getTopLosersListItems[index].symbol,
                                                        style: Utils.fonts(fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        TopLosersController.getTopLosersListItems[index].perchg.toStringAsFixed(2),
                                                        style: Utils.fonts(
                                                          color: Utils.greyColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(),
                                                          Text(
                                                            TopLosersController.getTopLosersListItems[index].prevClose.toString(),
                                                            style: Utils.fonts(
                                                              color: Utils.mediumGreenColor,
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
        ],
      );
    });
  }

  otherAsset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Other Assets",
                    style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        _scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                otherAssetTab = 1;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Commodities",
                                      style: Utils.fonts(size: 12.0, color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                otherAssetTab = 2;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Currencies",
                                      style: Utils.fonts(size: 12.0, color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                otherAssetTab = 4;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "IPOs",
                                      style: Utils.fonts(size: 12.0, color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
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
                  otherAssetTab == 1
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 16.0),
                              //   child: Container(
                              //     width: 160,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color:
                              //             Utils.greyColor.withOpacity(0.5)),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //             children: [
                              //               Column(
                              //                 crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     Dataconstants
                              //                         .indicesListener.indices1.name
                              //                         .toString(),
                              //                     style: Utils.fonts(
                              //                         size: 13.0,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 5,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants
                              //                         .indicesListener.indices1
                              //                         .expiryDateString,
                              //                     style: Utils.fonts(
                              //                         size: 11.0,
                              //                         color: Utils.greyColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Row(
                              //                 children: [
                              //                   Icon(
                              //                     Dataconstants
                              //                         .indicesListener.indices1
                              //                         .percentChange >
                              //                         0
                              //                         ? Icons
                              //                         .arrow_drop_up_rounded
                              //                         : Icons
                              //                         .arrow_drop_down_rounded,
                              //                     color: Dataconstants
                              //                         .indicesListener.indices1
                              //                         .percentChange >
                              //                         0
                              //                         ? Utils.lightGreenColor
                              //                         : Utils.lightRedColor,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants
                              //                         .indicesListener.indices1
                              //                         .percentChange
                              //                         .toStringAsFixed(1),
                              //                     style: Utils.fonts(
                              //                         size: 12.0,
                              //                         color: Dataconstants
                              //                             .indicesListener.indices1
                              //                             .percentChange >
                              //                             0
                              //                             ? Utils
                              //                             .lightGreenColor
                              //                             : Utils.lightRedColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: 10,
                              //           ),
                              //           Image.asset(
                              //             "assets/appImages/green_small_chart_shadow.png",
                              //             width: 170,
                              //             height: 70,
                              //             fit: BoxFit.fill,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 16.0),
                              //   child: Container(
                              //     width: 160,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color:
                              //             Utils.greyColor.withOpacity(0.5)),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //             children: [
                              //               Column(
                              //                 crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     Dataconstants
                              //                         .otherAssets[0].name
                              //                         .toString(),
                              //                     style: Utils.fonts(
                              //                         size: 13.0,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 5,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants.otherAssets[0]
                              //                         .expiryDateString,
                              //                     style: Utils.fonts(
                              //                         size: 11.0,
                              //                         color: Utils.greyColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Row(
                              //                 children: [
                              //                   Icon(
                              //                     Dataconstants.otherAssets[0]
                              //                         .percentChange >
                              //                         0
                              //                         ? Icons
                              //                         .arrow_drop_up_rounded
                              //                         : Icons
                              //                         .arrow_drop_down_rounded,
                              //                     color: Dataconstants
                              //                         .otherAssets[0]
                              //                         .percentChange >
                              //                         0
                              //                         ? Utils.lightGreenColor
                              //                         : Utils.lightRedColor,
                              //                   ),
                              //                   Text(
                              //                     "${Dataconstants.otherAssets[0].percentChange.toStringAsFixed(1)}%",
                              //                     style: Utils.fonts(
                              //                         size: 12.0,
                              //                         color: Dataconstants
                              //                             .otherAssets[
                              //                         0]
                              //                             .percentChange >
                              //                             0
                              //                             ? Utils
                              //                             .lightGreenColor
                              //                             : Utils.lightRedColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: 10,
                              //           ),
                              //           Image.asset(
                              //             "assets/appImages/green_small_chart_shadow.png",
                              //             width: 170,
                              //             height: 70,
                              //             fit: BoxFit.fill,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 16.0),
                              //   child: Container(
                              //     width: 160,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color:
                              //             Utils.greyColor.withOpacity(0.5)),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //             children: [
                              //               Column(
                              //                 crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     Dataconstants
                              //                         .otherAssets[1].name,
                              //                     style: Utils.fonts(
                              //                         size: 13.0,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 5,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants.otherAssets[1]
                              //                         .expiryDateString,
                              //                     style: Utils.fonts(
                              //                         size: 11.0,
                              //                         color: Utils.greyColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Row(
                              //                 children: [
                              //                   Icon(
                              //                     Dataconstants.otherAssets[1]
                              //                         .percentChange >
                              //                         0
                              //                         ? Icons
                              //                         .arrow_drop_up_rounded
                              //                         : Icons
                              //                         .arrow_drop_down_rounded,
                              //                     color: Utils.lightGreenColor,
                              //                   ),
                              //                   Text(
                              //                     "${Dataconstants.otherAssets[1].percentChange.toStringAsFixed(1)}%",
                              //                     style: Utils.fonts(
                              //                         size: 12.0,
                              //                         color: Dataconstants
                              //                             .otherAssets[
                              //                         1]
                              //                             .percentChange >
                              //                             0
                              //                             ? Utils.darkGreenColor
                              //                             : Utils.lightRedColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: 10,
                              //           ),
                              //           Image.asset(
                              //             "assets/appImages/green_small_chart_shadow.png",
                              //             width: 170,
                              //             height: 70,
                              //             fit: BoxFit.fill,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 16.0),
                              //   child: Container(
                              //     width: 160,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color:
                              //             Utils.greyColor.withOpacity(0.5)),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //             children: [
                              //               Column(
                              //                 crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     Dataconstants
                              //                         .otherAssets[2].name,
                              //                     style: Utils.fonts(
                              //                         size: 10.0,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 5,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants.otherAssets[2]
                              //                         .expiryDateString,
                              //                     style: Utils.fonts(
                              //                         size: 11.0,
                              //                         color: Utils.greyColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Row(
                              //                 children: [
                              //                   Icon(
                              //                     Dataconstants.otherAssets[2]
                              //                         .percentChange >
                              //                         0
                              //                         ? Icons
                              //                         .arrow_drop_up_rounded
                              //                         : Icons
                              //                         .arrow_drop_down_rounded,
                              //                     color: Utils.lightGreenColor,
                              //                   ),
                              //                   Text(
                              //                     "${Dataconstants.otherAssets[2].percentChange.toStringAsFixed(1)}%",
                              //                     style: Utils.fonts(
                              //                         size: 12.0,
                              //                         color: Dataconstants
                              //                             .otherAssets[
                              //                         2]
                              //                             .percentChange >
                              //                             0
                              //                             ? Utils.darkGreenColor
                              //                             : Utils.lightRedColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: 10,
                              //           ),
                              //           Image.asset(
                              //             "assets/appImages/green_small_chart_shadow.png",
                              //             width: 170,
                              //             height: 70,
                              //             fit: BoxFit.fill,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 16.0),
                              //   child: Container(
                              //     width: 160,
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color:
                              //             Utils.greyColor.withOpacity(0.5)),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20.0))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //             children: [
                              //               Column(
                              //                 crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     Dataconstants
                              //                         .otherAssets[3].name,
                              //                     style: Utils.fonts(
                              //                         size: 13.0,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                   SizedBox(
                              //                     height: 5,
                              //                   ),
                              //                   Text(
                              //                     Dataconstants.otherAssets[3]
                              //                         .expiryDateString,
                              //                     style: Utils.fonts(
                              //                         size: 11.0,
                              //                         color: Utils.greyColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Spacer(),
                              //               Row(
                              //                 children: [
                              //                   Icon(
                              //                     Icons.arrow_drop_up_rounded,
                              //                     color: Utils.lightGreenColor,
                              //                   ),
                              //                   Text(
                              //                     "${Dataconstants.otherAssets[3].percentChange.toStringAsFixed(1)}%",
                              //                     style: Utils.fonts(
                              //                         size: 12.0,
                              //                         color: Dataconstants
                              //                             .otherAssets[
                              //                         3]
                              //                             .percentChange >
                              //                             0
                              //                             ? Utils.darkGreenColor
                              //                             : Utils.lightRedColor,
                              //                         fontWeight:
                              //                         FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: 10,
                              //           ),
                              //           Image.asset(
                              //             "assets/appImages/green_small_chart_shadow.png",
                              //             width: 170,
                              //             height: 70,
                              //             fit: BoxFit.fill,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : otherAssetTab == 2
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 16.0),
                                  //   child: Container(
                                  //     width: 190,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Utils.greyColor
                                  //                 .withOpacity(0.5)),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(20.0))),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .marketWatchList[2]
                                  //                         .name,
                                  //                     style: Utils.fonts(
                                  //                         size: 13.0,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .marketWatchList[2]
                                  //                         .expiryDateString,
                                  //                     style: Utils.fonts(
                                  //                         size: 11.0,
                                  //                         color:
                                  //                         Utils.greyColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Spacer(),
                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Dataconstants
                                  //                         .marketWatchList[
                                  //                     2]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Icons
                                  //                         .arrow_drop_up_rounded
                                  //                         : Icons
                                  //                         .arrow_drop_down_rounded,
                                  //                     color: Dataconstants
                                  //                         .marketWatchList[
                                  //                     2]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Utils
                                  //                         .lightGreenColor
                                  //                         : Utils.lightRedColor,
                                  //                   ),
                                  //                   Text(
                                  //                     "${Dataconstants.marketWatchList[2].percentChange.toStringAsFixed(4)}%",
                                  //                     style: Utils.fonts(
                                  //                         size: 12.0,
                                  //                         color: Dataconstants
                                  //                             .marketWatchList[
                                  //                         2]
                                  //                             .percentChange >
                                  //                             0
                                  //                             ? Utils
                                  //                             .darkGreenColor
                                  //                             : Utils
                                  //                             .lightRedColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Image.asset(
                                  //             "assets/appImages/green_small_chart_shadow.png",
                                  //             width: 170,
                                  //             height: 70,
                                  //             fit: BoxFit.fill,
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 16.0),
                                  //   child: Container(
                                  //     width: 190,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Utils.greyColor
                                  //                 .withOpacity(0.5)),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(20.0))),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[4].name,
                                  //                     style: Utils.fonts(
                                  //                         size: 13.0,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[4]
                                  //                         .expiryDateString,
                                  //                     style: Utils.fonts(
                                  //                         size: 11.0,
                                  //                         color:
                                  //                         Utils.greyColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Spacer(),
                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Dataconstants
                                  //                         .otherAssets[
                                  //                     4]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Icons
                                  //                         .arrow_drop_up_rounded
                                  //                         : Icons
                                  //                         .arrow_drop_down_rounded,
                                  //                     color: Dataconstants
                                  //                         .otherAssets[
                                  //                     4]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Utils
                                  //                         .lightGreenColor
                                  //                         : Utils.lightRedColor,
                                  //                   ),
                                  //                   Text(
                                  //                     "${Dataconstants.otherAssets[4].percentChange.toStringAsFixed(4)}%",
                                  //                     style: Utils.fonts(
                                  //                         size: 12.0,
                                  //                         color: Dataconstants
                                  //                             .otherAssets[
                                  //                         4]
                                  //                             .percentChange >
                                  //                             0
                                  //                             ? Utils
                                  //                             .darkGreenColor
                                  //                             : Utils
                                  //                             .lightRedColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Image.asset(
                                  //             "assets/appImages/green_small_chart_shadow.png",
                                  //             width: 170,
                                  //             height: 70,
                                  //             fit: BoxFit.fill,
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 16.0),
                                  //   child: Container(
                                  //     width: 190,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Utils.greyColor
                                  //                 .withOpacity(0.5)),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(20.0))),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[6].name,
                                  //                     style: Utils.fonts(
                                  //                         size: 13.0,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[6]
                                  //                         .expiryDateString,
                                  //                     style: Utils.fonts(
                                  //                         size: 11.0,
                                  //                         color:
                                  //                         Utils.greyColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Spacer(),
                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Dataconstants
                                  //                         .otherAssets[
                                  //                     6]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Icons
                                  //                         .arrow_drop_up_rounded
                                  //                         : Icons
                                  //                         .arrow_drop_down_rounded,
                                  //                     color: Dataconstants
                                  //                         .otherAssets[
                                  //                     6]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Utils.darkGreenColor
                                  //                         : Utils.lightRedColor,
                                  //                   ),
                                  //                   Text(
                                  //                     "${Dataconstants.otherAssets[6].percentChange.toStringAsFixed(4)}%",
                                  //                     style: Utils.fonts(
                                  //                         size: 12.0,
                                  //                         color: Dataconstants
                                  //                             .otherAssets[
                                  //                         6]
                                  //                             .percentChange >
                                  //                             0
                                  //                             ? Utils
                                  //                             .darkGreenColor
                                  //                             : Utils
                                  //                             .lightRedColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Image.asset(
                                  //             "assets/appImages/green_small_chart_shadow.png",
                                  //             width: 170,
                                  //             height: 70,
                                  //             fit: BoxFit.fill,
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 16.0),
                                  //   child: Container(
                                  //     width: 190,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Utils.greyColor
                                  //                 .withOpacity(0.5)),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(20.0))),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[5].name,
                                  //                     style: Utils.fonts(
                                  //                         size: 13.0,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     height: 5,
                                  //                   ),
                                  //                   Text(
                                  //                     Dataconstants
                                  //                         .otherAssets[5]
                                  //                         .expiryDateString,
                                  //                     style: Utils.fonts(
                                  //                         size: 11.0,
                                  //                         color:
                                  //                         Utils.greyColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Spacer(),
                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Dataconstants
                                  //                         .otherAssets[
                                  //                     5]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Icons
                                  //                         .arrow_drop_up_rounded
                                  //                         : Icons
                                  //                         .arrow_drop_down_rounded,
                                  //                     color: Dataconstants
                                  //                         .otherAssets[
                                  //                     5]
                                  //                         .percentChange >
                                  //                         0
                                  //                         ? Utils
                                  //                         .lightGreenColor
                                  //                         : Utils.lightRedColor,
                                  //                   ),
                                  //                   Text(
                                  //                     "${Dataconstants.otherAssets[5].percentChange.toStringAsFixed(4)}%",
                                  //                     style: Utils.fonts(
                                  //                         size: 12.0,
                                  //                         color: Dataconstants
                                  //                             .otherAssets[
                                  //                         5]
                                  //                             .percentChange >
                                  //                             0
                                  //                             ? Utils
                                  //                             .darkGreenColor
                                  //                             : Utils
                                  //                             .lightRedColor,
                                  //                         fontWeight:
                                  //                         FontWeight.w600),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //           SizedBox(
                                  //             height: 10,
                                  //           ),
                                  //           Image.asset(
                                  //             "assets/appImages/green_small_chart_shadow.png",
                                  //             width: 170,
                                  //             height: 70,
                                  //             fit: BoxFit.fill,
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i = 0; i < OpenIpoController.getIpoDetailListItems.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Container(
                                        width: 160,
                                        decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        OpenIpoController.getIpoDetailListItems[i].lname.split(" ")[0].toString(),
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            formatter.format(OpenIpoController.getIpoDetailListItems[i].opendate),
                                                            style: Utils.fonts(size: 10.0, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            formatter.format(OpenIpoController.getIpoDetailListItems[i].closdate),
                                                            style: Utils.fonts(
                                                              size: 10.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(children: [
                                                Text(
                                                  OpenIpoController.getIpoDetailListItems[i].issueprice.toString(),
                                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w600),
                                                ),
                                                Spacer(),
                                                Text(
                                                  OpenIpoController.getIpoDetailListItems[i].issuepri2.toString(),
                                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w600),
                                                )
                                              ])
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  marketBreadth() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Market Breadth",
                    style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () async {
                      //     String deviceName, osName, devicemodel;
                      //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      //
                      //     if (Platform.isIOS) {
                      //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                      //       //print("${iosInfo.name}");
                      //       deviceName = iosInfo.name;
                      //       osName = iosInfo.systemVersion;
                      //       devicemodel = iosInfo.model;
                      //     } else {
                      //       AndroidDeviceInfo androidInfo =
                      //       await deviceInfo.androidInfo;
                      //       //print("${androidInfo.brand}");
                      //       deviceName = androidInfo.brand.replaceAll(' ', '');
                      //       osName = 'Android${androidInfo.version.release}';
                      //       devicemodel = androidInfo.model;
                      //     }
                      //
                      //     CommonFunction.firebaseEvent(
                      //       clientCode: "dummy",
                      //       device_manufacturer: deviceName,
                      //       device_model: devicemodel,
                      //       eventId: "6.0.4.0.0",
                      //       eventLocation: "body",
                      //       eventMetaData: "dummy",
                      //       eventName: "nifty",
                      //       os_version: osName,
                      //       location: "dummy",
                      //       eventType:"Click",
                      //       sessionId: "dummy",
                      //       platform: Platform.isAndroid ? 'Android' : 'iOS',
                      //       screenName: "guest user dashboard",
                      //       serverTimeStamp: DateTime.now().toString(),
                      //       source_metadata: "dummy",
                      //       subType: "card",
                      //     );
                      //
                      //   },
                      //   child: Container(
                      //       decoration: BoxDecoration(
                      //         border: Border(
                      //             left: BorderSide(
                      //               color: Utils.primaryColor,
                      //               width: 1,
                      //             ),
                      //             top: BorderSide(
                      //               color: Utils.primaryColor,
                      //               width: 1,
                      //             ),
                      //             bottom: BorderSide(
                      //               color: Utils.primaryColor,
                      //               width: 1,
                      //             ),
                      //             right: BorderSide(
                      //               color: Utils.primaryColor,
                      //               width: 1,
                      //             )),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Text(
                      //           "Nifty 50",
                      //           style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
                      //         ),
                      //       )),
                      // ),
                      InkWell(
                        onTap: () async {
                          CommonFunction.firebaseEvent(
                            clientCode: "dummy",
                            device_manufacturer: Dataconstants.deviceName,
                            device_model: Dataconstants.devicemodel,
                            eventId: "6.0.4.0.0",
                            eventLocation: "body",
                            eventMetaData: "dummy",
                            eventName: "nifty",
                            os_version: Dataconstants.osName,
                            location: "dummy",
                            eventType: "Click",
                            sessionId: "dummy",
                            platform: Platform.isAndroid ? 'Android' : 'iOS',
                            screenName: "guest user dashboard",
                            serverTimeStamp: DateTime.now().toString(),
                            source_metadata: "dummy",
                            subType: "card",
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: Utils.primaryColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: Utils.primaryColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Utils.primaryColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: Utils.primaryColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Nifty 50",
                                style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () async {
                          CommonFunction.firebaseEvent(
                            clientCode: "dummy",
                            device_manufacturer: Dataconstants.deviceName,
                            device_model: Dataconstants.devicemodel,
                            eventId: "6.0.5.0.0",
                            eventLocation: "body",
                            eventMetaData: "dummy",
                            eventName: "sensex",
                            os_version: Dataconstants.osName,
                            location: "dummy",
                            eventType: "Click",
                            sessionId: "dummy",
                            platform: Platform.isAndroid ? 'Android' : 'iOS',
                            screenName: "guest user dashboard",
                            serverTimeStamp: DateTime.now().toString(),
                            source_metadata: "dummy",
                            subType: "card",
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                    color: Utils.greyColor.withOpacity(0.5),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Utils.greyColor.withOpacity(0.5),
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: Utils.greyColor.withOpacity(0.5),
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sensex",
                                style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections()),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Utils.primaryColor),
                            ),
                          ),
                          Text(
                            "ADV: ${Dataconstants.marketWatchList[0].adv.toString()}",
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.orange),
                            ),
                          ),
                          Text(
                            "DEC: ${Dataconstants.marketWatchList[0].dec.toString()}",
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  mostActive() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (mostActiveExpanded == false) {
                      mostActiveExpanded = true;
                    } else if (mostActiveExpanded == true) {
                      mostActiveExpanded = false;
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Most Active",
                        style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
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
                        children: [
                          InkWell(
                            onTap: () {
                              mostActiveTab = 1;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Volume",
                                    style: Utils.fonts(size: 12.0, color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              mostActiveTab = 2;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Turnover",
                                    style: Utils.fonts(size: 12.0, color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              mostActiveTab = 3;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Futures",
                                    style: Utils.fonts(size: 12.0, color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              mostActiveTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Calls",
                                    style: Utils.fonts(size: 12.0, color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              mostActiveTab = 5;
                              Dataconstants.mostActiveController.getMostActive();
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Puts",
                                    style: Utils.fonts(size: 12.0, color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                  mostActiveTab == 2
                      ? Text("Value Traded(Cr)", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                      : mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                          ? Text("Traded Qty", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                          : Text("Volume", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                  mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                      ? Text("Turnover", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("LTP", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                            Text("%Chg", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ],
                        ),
                ]),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                MostActiveCallController.getMostActiveCallDetailsListItems.isEmpty ||
                        MostActivePutController.getMostActivePutDetailsListItems.isEmpty ||
                        MostActiveVolumeController.getMostActiveVolumeListItems.isEmpty ||
                        MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.isEmpty ||
                        MostActiveFuturesController.getMostActiveFuturesDetailsListItems.isEmpty
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : (() {
                        if (mostActiveTab == 1)
                          return Column(children: [
                            mostActiveExpanded
                                ? Column(
                                    children: [
                                      for (var i = 0; i < MostActiveVolumeController.getMostActiveVolumeListItems.length; i++)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      MostActiveVolumeController.getMostActiveVolumeListItems[i].symbol.toString(),
                                                      style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            MostActiveVolumeController.getMostActiveVolumeListItems[i].volTraded.toStringAsFixed(2),
                                                            style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              MostActiveVolumeController.getMostActiveVolumeListItems[i].closePrice.toString(),
                                                              style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                            ),
                                                            Text(
                                                              MostActiveVolumeController.getMostActiveVolumeListItems[i].perchg.toStringAsFixed(2),
                                                              style: Utils.fonts(
                                                                  size: 14.0,
                                                                  color: MostActiveVolumeController.getMostActiveVolumeListItems[i].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            physics: CustomTabBarScrollPhysics(),
                                            itemCount: MostActiveVolumeController.getMostActiveVolumeListItems.length >= 4 ? 4 : MostActiveVolumeController.getMostActiveVolumeListItems.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Expanded(
                                                            child: Text(
                                                              MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                MostActiveVolumeController.getMostActiveVolumeListItems[index].volTraded.toStringAsFixed(2),
                                                                style: Utils.fonts(
                                                                  color: Utils.greyColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    MostActiveVolumeController.getMostActiveVolumeListItems[index].prevClose.toString(),
                                                                    style: Utils.fonts(),
                                                                  ),
                                                                  Text(
                                                                    MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2),
                                                                    style: Utils.fonts(
                                                                        color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor),
                                                                  ),
                                                                ],
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
                          ]);

                        if (mostActiveTab == 2)
                          return Column(children: [
                            mostActiveExpanded
                                ? Column(
                                    children: [
                                      for (var i = 0; i < MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length; i++)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[i].symbol,
                                                      style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[i].valTraded.toStringAsFixed(2),
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[i].closePrice.toString(),
                                                              style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                            ),
                                                            Text(
                                                              MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[i].perchg.toStringAsFixed(2),
                                                              style: Utils.fonts(
                                                                  size: 14.0,
                                                                  color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[i].perchg > 0 ? Utils.lightRedColor : Utils.lightRedColor,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            physics: CustomTabBarScrollPhysics(),
                                            itemCount: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length < 4
                                                ? MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length
                                                : 4,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].coName,
                                                            style: Utils.fonts(),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].valTraded.toStringAsFixed(2),
                                                            style: Utils.fonts(
                                                              color: Utils.greyColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].closePrice.toStringAsFixed(2),
                                                                    style: Utils.fonts(),
                                                                  ),
                                                                  Text(
                                                                    MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg.toStringAsFixed(2),
                                                                    style: Utils.fonts(
                                                                      color: Utils.mediumGreenColor,
                                                                    ),
                                                                  ),
                                                                ],
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
                          ]);

                        if (mostActiveTab == 3)
                          return Column(children: [
                            mostActiveExpanded
                                ? Column(
                                    children: [
                                      for (var i = 0; i < MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length; i++)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      MostActiveFuturesController.getMostActiveFuturesDetailsListItems[i].symbol.toString() ?? " ",
                                                      style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          MostActiveFuturesController.getMostActiveFuturesDetailsListItems[i].tradedQty.toStringAsFixed(2) ?? " ",
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          MostActiveFuturesController.getMostActiveFuturesDetailsListItems[i].turnOver.toStringAsFixed(2) ?? " ",
                                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            physics: CustomTabBarScrollPhysics(),
                                            itemCount: MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length >= 4
                                                ? 4
                                                : MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].symbol ?? " ",
                                                            style: Utils.fonts(),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].tradedQty.toString(),
                                                                style: Utils.fonts(
                                                                  color: Utils.mediumGreenColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              SizedBox(),
                                                              Text(
                                                                MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].turnOver.toStringAsFixed(2) ?? " ",
                                                                style: Utils.fonts(
                                                                  color: Utils.greyColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
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
                          ]);

                        if (mostActiveTab == 4)
                          return Column(children: [
                            mostActiveExpanded
                                ? Column(
                                    children: [
                                      for (var i = 0; i < MostActiveCallController.getMostActiveCallDetailsListItems.length; i++)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          MostActiveCallController.getMostActiveCallDetailsListItems[i].symbol.name,
                                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w700),
                                                        ),
                                                        Text(
                                                          MostActiveCallController.getMostActiveCallDetailsListItems[i].strikePrice,
                                                          style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Utils.greyColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          MostActiveCallController.getMostActiveCallDetailsListItems[i].tradedQty,
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          (double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[i].turnOver) / 10000000).toStringAsFixed(2),
                                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            physics: CustomTabBarScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                MostActiveCallController.getMostActiveCallDetailsListItems[index].symbol.name.trim(),
                                                                style: Utils.fonts(),
                                                              ),
                                                              Text(
                                                                MostActiveCallController.getMostActiveCallDetailsListItems[index].strikePrice.trim(),
                                                                style: Utils.fonts(
                                                                  color: Utils.greyColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                          child: Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              // double.tryParse(MostActiveCallController.getMostActiveCallDetailsListItems[index].tradedQty).toStringAsFixed(2),
                                                              MostActiveCallController.getMostActiveCallDetailsListItems[index].tradedQty,
                                                              style: Utils.fonts(
                                                                color: Utils.greyColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                          child: Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(),
                                                                Text(
                                                                  (double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
                                                                  style: Utils.fonts(),
                                                                ),
                                                              ],
                                                            ),
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
                          ]);

                        if (mostActiveTab == 5)
                          return Column(
                            children: [
                              mostActiveExpanded
                                  ? Column(
                                      children: [
                                        for (var i = 0; i < MostActivePutController.getMostActivePutDetailsListItems.length; i++)
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            MostActivePutController.getMostActivePutDetailsListItems[i].symbol.name ?? null,
                                                            style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                          ),
                                                          Text(
                                                            MostActivePutController.getMostActivePutDetailsListItems[i].strikePrice ?? null,
                                                            style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            MostActivePutController.getMostActivePutDetailsListItems[i].tradedQty,
                                                            style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            (double.parse(MostActivePutController.getMostActivePutDetailsListItems[i].turnOver) / 10000000).toStringAsFixed(2),
                                                            style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                    )
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
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              physics: CustomTabBarScrollPhysics(),
                                              itemCount: MostActivePutController.getMostActivePutDetailsListItems.length >= 4 ? 4 : MostActivePutController.getMostActivePutDetailsListItems.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  MostActivePutController.getMostActivePutDetailsListItems[index].symbol.name,
                                                                  style: Utils.fonts(),
                                                                ),
                                                                Text(
                                                                  MostActivePutController.getMostActivePutDetailsListItems[index].strikePrice,
                                                                  style: Utils.fonts(
                                                                    color: Utils.greyColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(),
                                                            child: Expanded(
                                                              child: Text(
                                                                MostActivePutController.getMostActivePutDetailsListItems[index].tradedQty,
                                                                style: Utils.fonts(
                                                                  color: Utils.greyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(),
                                                            child: Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(),
                                                                  Text(
                                                                    (double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
                                                                    style: Utils.fonts(),
                                                                  ),
                                                                ],
                                                              ),
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
                          );
                      }())
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
}
