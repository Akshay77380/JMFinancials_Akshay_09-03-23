import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markets/controllers/FiftyTwoWeekHighController.dart';
import 'package:markets/controllers/FiftyTwoWeekLowController.dart';
import 'package:markets/controllers/MostActiveTurnoverController.dart';
import 'package:markets/controllers/OiGainersController.dart';
import 'package:markets/controllers/OiLosersController.dart';
import 'package:markets/controllers/mostActiveCallController.dart';
import 'package:markets/controllers/topGainersController.dart';
import 'package:markets/controllers/topLosersController.dart';
import 'package:markets/widget/smallChart.dart';

import '../../controllers/MostActiveFuturesController.dart';
import '../../controllers/MostActivePutController.dart';
import '../../controllers/MostActiveVolumeController.dart';
import '../../util/DataConstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';

class MarketStatsNext extends StatefulWidget {
  var name;
  var currentTabIndex;
  var currentIndex = 1;

  MarketStatsNext({Key key, @required this.name, this.currentTabIndex})
      : super(key: key);

  @override
  State<MarketStatsNext> createState() => _MarketStatsNextState();
}

class _MarketStatsNextState extends State<MarketStatsNext>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  TabController _tabController;

  var tabValue;
  var topGainers = 1;
  var topLosers = 1;
  var mostActive = 1;
  var mostActiveTab = 1;
  var mostActiveExpanded = false;
  final DateFormat formatter = DateFormat('dd MMM yy');

  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    // SystemChrome.setPreferredOrientations(
    //   [
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft
    // ]);

    Dataconstants.fiftyTwoWeekHighController.getFiftyTwoWeekHigh();
    Dataconstants.fiftyTwoWeekLowController.getFiftyTwoWeekLow();
    Dataconstants.oiGainersController.getOiGainers();
    Dataconstants.mostActiveVolumeController.getMostActiveVolume();
    Dataconstants.mostActiveCallController.getMostActiveCall();
    Dataconstants.mostActivePutController.getMostActivePut();

    super.initState();
    _tabController = TabController(vsync: this, length: 7)
      ..addListener(() {
        setState(() {});
      });
    _tabController.index = widget.currentTabIndex;
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var mediaQueryValue = MediaQuery.of(context).orientation;

    //print(mediaQueryValue);

    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Markets',
          style: Utils.fonts(
            size: 14.0,
            color: Utils.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Sheet(),
                    );
                  },
                  backgroundColor: Utils.whiteColor,
                );
              },
              child: Icon(
                Icons.more_vert,
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
                child: TabBar(
                  isScrollable: true,
                  labelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                  unselectedLabelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                  unselectedLabelColor: Colors.grey[600],
                  labelColor: Utils.primaryColor,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 40.0,
                    insets: EdgeInsets.symmetric(horizontal: 2),
                    indicatorColor: Utils.primaryColor.withOpacity(0.3),
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  controller: _tabController,
                  onTap: (_index) {},
                  tabs: [
                    Tab(
                      child: Text("Top Gainers"),
                    ),
                    Tab(
                      child: Text("Top Losers"),
                    ),
                    Tab(
                      child: Text("Most Active"),
                    ),
                    Tab(
                      child: Text("52 Week High"),
                    ),
                    Tab(
                      child: Text("52 Week Low"),
                    ),
                    Tab(
                      child: Text("OI Gainers"),
                    ),
                    Tab(
                      child: Text("OI Losers"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: CustomTabBarScrollPhysics(),
              controller: _tabController,
              children: [
                TopGainers(),
                TopLosers(),
                MostActive(),
                FiftyTwoWeekHigh(),
                FiftyTwoWeekLow(),
                OIGainers(),
                OILosers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget TopGainers() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topGainers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("15 Minutes",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topGainers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Hour",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topGainers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Day",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 4;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topGainers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("5 Days",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 4
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 5;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topGainers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Month",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 5
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topGainers = 6;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topGainers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topGainers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topGainers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  left: topGainers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("YTD",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topGainers == 6
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Sheet(),
                    );
                  },
                  backgroundColor: Utils.whiteColor,
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.width * 0.09,
                width: MediaQuery.of(context).size.width * 0.3,
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Utils.greyColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Monthly",
                      style: Utils.fonts(
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset(
                          "assets/appImages/markets/inverted_rectangle.svg",
                          color: Utils.blackColor,
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text('My Holdings',
                  style: Utils.fonts(
                    size: 14.0,
                    color: Utils.blackColor,
                    fontWeight: FontWeight.w700,
                  )),
              Switch(
                // thumb color (round icon)
                activeColor: Utils.primaryColor,
                activeTrackColor: Utils.greyColor,
                inactiveThumbColor: Utils.greyColor,
                inactiveTrackColor: Colors.grey.shade400,
                splashRadius: 50.0,
                // boolean variable value
                value: true,
                // changes the state of the switch
                onChanged: (value) => setState(() => {}),
              ),
            ],
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
            itemCount: TopGainersController.getTopGainersListItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(TopGainersController.getTopGainersListItems[index].symbol,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'BSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('2000',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(TopGainersController.getTopGainersListItems[index].prevClose.toString(),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '2.60 (${TopGainersController.getTopGainersListItems[index].perchg.toStringAsFixed(2)}%)',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: TopGainersController.getTopGainersListItems[index].perchg >= 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TopGainersController.getTopGainersListItems[index].perchg >= 0 ? SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg"
                                  ) : RotatedBox(
                                    quarterTurns: 2,
                                    child: SvgPicture.asset(
                                        "assets/appImages/markets/inverted_rectangle.svg"
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  )
                ],
              );
            }),
      ),
        
    ]);
  }


  Widget TopLosers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topLosers == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("15 Minutes",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topLosers == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Hour",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topLosers == 3
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Day",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 4;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topLosers == 4
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("5 Days",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 4
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 5;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: topLosers == 5
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("1 Month",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 5
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  topLosers = 6;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: topLosers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: topLosers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: topLosers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  left: topLosers == 6
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("YTD",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: topLosers == 6
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: TopLosersController.getTopLosersListItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(TopLosersController.getTopLosersListItems[index].symbol,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'BSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('Markets',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('111.85',
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '2.60 (${TopLosersController.getTopLosersListItems[index].perchg.toStringAsFixed(2)}%)',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: TopLosersController.getTopLosersListItems[index].perchg >= 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TopLosersController.getTopLosersListItems[index].perchg > 0 ? SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                                        quarterTurns: 2,
                                        child: SvgPicture.asset(
                                        "assets/appImages/markets/inverted_rectangle.svg", color: Utils.lightRedColor),
                                      ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                );
              }),
        ),
          
      ]),
    );
  }


  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }


  MostActive_() {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() { Dataconstants.mostActiveVolumeController.getMostActiveVolume();
                                Dataconstants.mostActiveTab = 1;});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: Dataconstants.mostActiveTab == 1
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Dataconstants.mostActiveTab == 1
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Dataconstants.mostActiveTab == 1
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Dataconstants.mostActiveTab == 1
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Volume",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Dataconstants.mostActiveTab == 1
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                              ),
                           ),
                            InkWell(
                              onTap: () {

                                setState(() {  Dataconstants.mostActiveTurnOverController.getMostTurnOver();
                                Dataconstants.mostActiveTab = 2;});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: Dataconstants.mostActiveTab == 2
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Dataconstants.mostActiveTab == 2
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Dataconstants.mostActiveTab == 2
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Dataconstants.mostActiveTab == 2
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Turnover",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Dataconstants.mostActiveTab == 2
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {

                                setState(() {Dataconstants.mostActiveFuturesController.getMostFutures();
                                Dataconstants.mostActiveTab = 3;});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: Dataconstants.mostActiveTab == 3
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Dataconstants.mostActiveTab == 3
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Dataconstants.mostActiveTab == 3
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Dataconstants.mostActiveTab == 3
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Futures",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Dataconstants.mostActiveTab == 3
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {

                                setState(() { Dataconstants.mostActiveCallController.getMostActiveCall();
                                Dataconstants.mostActiveTab = 4;});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: Dataconstants.mostActiveTab == 4
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Dataconstants.mostActiveTab == 4
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Dataconstants.mostActiveTab == 4
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Dataconstants.mostActiveTab == 4
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Calls",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Dataconstants.mostActiveTab == 4
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {

                                setState(() { Dataconstants.mostActiveTab = 5;
                                Dataconstants.mostActivePutController.getMostActivePut();});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: Dataconstants.mostActiveTab == 5
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Dataconstants.mostActiveTab == 5
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Dataconstants.mostActiveTab == 5
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Dataconstants.mostActiveTab == 5
                                              ? Utils.primaryColor
                                              : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Puts",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Dataconstants.mostActiveTab == 5
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Symbol",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.greyColor,
                                fontWeight: FontWeight.w500)),
                        Dataconstants.mostActiveTab == 2
                            ? Text("Value Traded(Cr)",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.greyColor,
                                fontWeight: FontWeight.w500))
                            : Dataconstants.mostActiveTab == 3 ||
                            Dataconstants.mostActiveTab == 4 ||
                            Dataconstants.mostActiveTab == 5
                            ? Text("Traded Qty",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.greyColor,
                                fontWeight: FontWeight.w500))
                            : Text("Volume",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.greyColor,
                                fontWeight: FontWeight.w500)),
                        Dataconstants.mostActiveTab == 3 || Dataconstants.mostActiveTab == 4 || Dataconstants.mostActiveTab == 5? Text("Turnover",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.greyColor,
                                fontWeight: FontWeight.w500)) : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("LTP",
                                style: Utils.fonts(
                                    size: 15.0,
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w500)),
                            Text("%Chg",
                                style: Utils.fonts(
                                    size: 15.0,
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ((){
                    if (mostActiveTab == 1)
                      return MostActiveVolumeController.getMostActiveVolumeListItems.length > 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        // physics: CustomTabBarScrollPhysics(),
                        itemCount: mostActiveExpanded
                            ? MostActiveVolumeController.getMostActiveVolumeListItems.length < 4
                            ? MostActiveVolumeController.getMostActiveVolumeListItems.length
                            : 4
                            : MostActiveVolumeController.getMostActiveVolumeListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol.toString(),
                                        style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      child: Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              MostActiveVolumeController.getMostActiveVolumeListItems[index].volTraded.toStringAsFixed(2),
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
                                                MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice.toString(),
                                                style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2),
                                                style: Utils.fonts(
                                                    size: 14.0,
                                                    color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
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
                          );
                        },
                      )
                          : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      );

                    if (mostActiveTab == 2)
                      return MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length > 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        // physics: CustomTabBarScrollPhysics(),
                        itemCount: mostActiveExpanded
                            ? MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length < 4
                            ? MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length
                            : 4
                            : MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].symbol,
                                        style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].valTraded.toStringAsFixed(2),
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
                                                MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].closePrice.toString(),
                                                style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg.toStringAsFixed(2),
                                                style: Utils.fonts(
                                                    size: 14.0,
                                                    color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0 ? Utils.lightRedColor : Utils.lightRedColor,
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
                          );
                        },
                      )
                          : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      );

                    if (mostActiveTab == 3)
                      return MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length > 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        // physics: CustomTabBarScrollPhysics(),
                        itemCount: mostActiveExpanded
                            ? MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length < 4
                            ? MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length
                            : 4
                            : MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].symbol.toString() ?? " ",
                                        style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].tradedQty.toStringAsFixed(2) ?? " ",
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
                                            MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].turnOver.toStringAsFixed(2) ?? " ",
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
                          );
                        },
                      )
                          : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      );

                    if (mostActiveTab == 4)
                      return MostActiveCallController.getMostActiveCallDetailsListItems.length > 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        // physics: CustomTabBarScrollPhysics(),
                        itemCount: mostActiveExpanded
                            ? MostActiveCallController.getMostActiveCallDetailsListItems.length < 4
                            ? MostActiveCallController.getMostActiveCallDetailsListItems.length
                            : 4
                            : MostActiveCallController.getMostActiveCallDetailsListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
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
                                            MostActiveCallController.getMostActiveCallDetailsListItems[index].symbol.name,
                                            style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            MostActiveCallController.getMostActiveCallDetailsListItems[index].strikePrice,
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
                                            MostActiveCallController.getMostActiveCallDetailsListItems[index].tradedQty,
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
                                            (double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
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
                          );
                        },
                      )
                          : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      );

                    if (mostActiveTab == 5)
                      return MostActivePutController.getMostActivePutDetailsListItems.length > 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        // physics: CustomTabBarScrollPhysics(),
                        itemCount: mostActiveExpanded
                            ? MostActivePutController.getMostActivePutDetailsListItems.length < 4
                            ? MostActivePutController.getMostActivePutDetailsListItems.length
                            : 4
                            : MostActivePutController.getMostActivePutDetailsListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
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
                                            MostActivePutController.getMostActivePutDetailsListItems[index].symbol.name ?? null,
                                            style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            MostActivePutController.getMostActivePutDetailsListItems[index].strikePrice ?? null,
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
                                            MostActivePutController.getMostActivePutDetailsListItems[index].tradedQty,
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
                                            (double.parse(MostActivePutController.getMostActivePutDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
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
                          );
                        },
                      )
                          : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
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
      }),
    );
  }


  MostActive() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
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

                                  setState(() { Dataconstants.mostActiveVolumeController.getMostActiveVolume();
                                  Dataconstants.mostActiveTab = 1;});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: Dataconstants.mostActiveTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: Dataconstants.mostActiveTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Dataconstants.mostActiveTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Dataconstants.mostActiveTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Volume",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants.mostActiveTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                  setState(() {  Dataconstants.mostActiveTurnOverController.getMostTurnOver();
                                  Dataconstants.mostActiveTab = 2;});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: Dataconstants.mostActiveTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: Dataconstants.mostActiveTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Dataconstants.mostActiveTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Dataconstants.mostActiveTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Turnover",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants.mostActiveTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {

                                  setState(() {Dataconstants.mostActiveFuturesController.getMostFutures();
                                  Dataconstants.mostActiveTab = 3;});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: Dataconstants.mostActiveTab == 3
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: Dataconstants.mostActiveTab == 3
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Dataconstants.mostActiveTab == 3
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Dataconstants.mostActiveTab == 3
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Futures",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants.mostActiveTab == 3
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {

                                  setState(() { Dataconstants.mostActiveCallController.getMostActiveCall();
                                  Dataconstants.mostActiveTab = 4;});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: Dataconstants.mostActiveTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: Dataconstants.mostActiveTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Dataconstants.mostActiveTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Dataconstants.mostActiveTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Calls",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants.mostActiveTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {

                                  setState(() { Dataconstants.mostActiveTab = 5;
                                  Dataconstants.mostActivePutController.getMostActivePut();});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: Dataconstants.mostActiveTab == 5
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: Dataconstants.mostActiveTab == 5
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Dataconstants.mostActiveTab == 5
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Dataconstants.mostActiveTab == 5
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Puts",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants.mostActiveTab == 5
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
                    (() {
                      if (Dataconstants.mostActiveTab == 1)
                        return MostActiveVolumeController.getMostActiveVolumeListItems.length > 0
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mostActiveExpanded
                              ? MostActiveVolumeController.getMostActiveVolumeListItems.length < 4
                              ? MostActiveVolumeController.getMostActiveVolumeListItems.length
                              : 4
                              : MostActiveVolumeController.getMostActiveVolumeListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol.toString(),
                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        child: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                MostActiveVolumeController.getMostActiveVolumeListItems[index].volTraded.toStringAsFixed(2),
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
                                                  MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice.toString(),
                                                  style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
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
                            );
                          },
                        )
                            : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                        );

                      if (Dataconstants.mostActiveTab == 2)
                        return MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length > 0
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mostActiveExpanded
                              ? MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length < 4
                              ? MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length
                              : 4
                              : MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].symbol,
                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].valTraded.toStringAsFixed(2),
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
                                                  MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].closePrice.toString(),
                                                  style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg.toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0 ? Utils.lightRedColor : Utils.lightRedColor,
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
                            );
                          },
                        )
                            : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                        );

                      if (Dataconstants.mostActiveTab == 3)
                        return MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length > 0
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mostActiveExpanded
                              ? MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length < 4
                              ? MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length
                              : 4
                              : MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].symbol.toString() ?? " ",
                                          style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].tradedQty.toStringAsFixed(2) ?? " ",
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
                                              MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].turnOver.toStringAsFixed(2) ?? " ",
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
                            );
                          },
                        )
                            : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                        );

                      if (Dataconstants.mostActiveTab == 4)
                        return MostActiveCallController.getMostActiveCallDetailsListItems.length > 0
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mostActiveExpanded
                              ? MostActiveCallController.getMostActiveCallDetailsListItems.length < 4
                              ? MostActiveCallController.getMostActiveCallDetailsListItems.length
                              : 4
                              : MostActiveCallController.getMostActiveCallDetailsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
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
                                              MostActiveCallController.getMostActiveCallDetailsListItems[index].symbol.name,
                                              style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              MostActiveCallController.getMostActiveCallDetailsListItems[index].strikePrice,
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
                                              MostActiveCallController.getMostActiveCallDetailsListItems[index].tradedQty,
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
                                              (double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
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
                            );
                          },
                        )
                            : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                        );

                      if (Dataconstants.mostActiveTab == 5)
                        return MostActivePutController.getMostActivePutDetailsListItems.length > 0
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mostActiveExpanded
                              ? MostActivePutController.getMostActivePutDetailsListItems.length < 4
                              ? MostActivePutController.getMostActivePutDetailsListItems.length
                              : 4
                              : MostActivePutController.getMostActivePutDetailsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
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
                                              MostActivePutController.getMostActivePutDetailsListItems[index].symbol.name ?? null,
                                              style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              MostActivePutController.getMostActivePutDetailsListItems[index].strikePrice ?? null,
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
                                              MostActivePutController.getMostActivePutDetailsListItems[index].tradedQty,
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
                                              (double.parse(MostActivePutController.getMostActivePutDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2),
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
                            );
                          },
                        )
                            : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Available",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
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
          ),
        );
      });
    });
  }


  Widget MostActiveCall() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  tabValue = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Volume",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Turnover",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Futures",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 4;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Calls",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 4
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 5;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      left: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Puts",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 5
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ONGC',
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'NSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('Markets',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('111.85',
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '2.60 (2.43%)',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreenColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg"),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                );
              }),
        ),
          
      ]),
    );
  }

  Widget MostActiveFutures() {}

  Widget MostActivePut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  tabValue = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Volume",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Turnover",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Futures",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 4;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Calls",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 4
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 5;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      left: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Puts",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 5
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ONGC',
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'NSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('Markets',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('111.85',
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '2.60 (2.43%)',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreenColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg"),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                );
              }),
        ),
          
      ]),
    );
  }

  Widget MostActiveVolume() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ONGC',
                              style: Utils.fonts(
                                size: 16.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'NSE',
                                style: Utils.fonts(
                                  size: 12.0,
                                  color: Utils.lightGreyColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                        "assets/appImages/markets/suitcase.svg")),
                              ),
                              Text('Markets',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('111.85',
                              style: Utils.fonts(
                                size: 16.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                '2.60 (2.43%)',
                                style: Utils.fonts(
                                  size: 12.0,
                                  color: Utils.lightGreenColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SvgPicture.asset(
                                    "assets/appImages/markets/inverted_rectangle.svg"),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              );
            }),
          
      ]),
    );
  }

  Widget MostActiveTurnover() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  tabValue = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Volume",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Turnover",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Futures",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 4;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: mostActive == 4
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Calls",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 4
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mostActive = 5;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      left: mostActive == 5
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Puts",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: mostActive == 5
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].symbol,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'NSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('Markets',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].prevClose.toString(),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '2.60 (${MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg.toStringAsFixed(2)}%)',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0 ?
                SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                quarterTurns: 2,
                                        child: SvgPicture.asset(
                "assets/appImages/markets/inverted_rectangle.svg"),
                                      ),
                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                );
              }),
        ),
          
      ]),
    );
  }

  Widget FiftyTwoWeekHigh() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.builder(
            itemCount: FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems[index].coName,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'NSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0
                                  ),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg"
                                      )
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // SmallSimpleLineChart(prevClose: 12.0, animate: true,name: "Aakaash", seriesList: Dataconstants.indicesListener.indices1.dataPoint[5]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems[index].price.toString(),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '52 Wk Hi: ',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.greyColor
                                  ),
                                ),
                                Text(
                                  FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems[index].high.toStringAsFixed(2),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems[index].high > FiftyTwoWeekHighController.getFiftyTwoWeekHighListItems[index].price ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
              );
            }),
      ),
    ]);
  }

  Widget FiftyTwoWeekLow() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.builder(
            itemCount: FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems[index].coName,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'NSE',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                          "assets/appImages/markets/suitcase.svg")),
                                ),
                                Text('Markets',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.lightGreyColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems[index].price.toStringAsFixed(2),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '52 Wk Lo: ',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems[index].low.toString(),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color:
                                    FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems[index].low < FiftyTwoWeekLowController.getFiftyTwoWeekLowListItems[index].price ? Utils.lightRedColor: Utils.lightGreenColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                ),
              );
            }),
      ),
        
    ]);
  }

  Widget OIGainers() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.builder(
            itemCount: OiGainersController.getOiGainersDetailsListItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(OiGainersController.getOiGainersDetailsListItems[index].symbol,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${formatter.format(OiGainersController.getOiGainersDetailsListItems[index].expDate).toString()} ',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text('FUT',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(OiGainersController.getOiGainersDetailsListItems[index].ltp.toString(),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Oi Chg: ',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${OiGainersController.getOiGainersDetailsListItems[index].faOchange
                                      .toStringAsFixed(2)}%',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: OiGainersController.getOiGainersDetailsListItems[index].faOchange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: OiGainersController.getOiGainersDetailsListItems[index].faOchange > 0 ? SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                                    quarterTurns: 2,
                                        child: SvgPicture.asset(
                                        "assets/appImages/markets/inverted_rectangle.svg", color: Utils.lightRedColor,),
                                      )
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
              );
            }),
      ),
        
    ]);
  }

  Widget OILosers() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.builder(
            itemCount: OiLosersController.getOiLosersDetailsListItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                OiLosersController.getOiLosersDetailsListItems[index].symbol,
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  formatter.format(OiLosersController.getOiLosersDetailsListItems[index].expDate),
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.lightGreyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(' FUT',
                                    style: Utils.fonts(
                                      size: 12.0,
                                      color: Utils.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(OiLosersController.getOiLosersDetailsListItems[index].prevLtp.toString(),
                                style: Utils.fonts(
                                  size: 16.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'OI Chg: ',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${OiLosersController.getOiLosersDetailsListItems[index].faOchange.toStringAsFixed(2)}%',
                                  style: Utils.fonts(
                                    size: 12.0,
                                    color: OiLosersController.getOiLosersDetailsListItems[index].faOchange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: OiLosersController.getOiLosersDetailsListItems[index].faOchange > 0 ? SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                                    quarterTurns: 2,
                                        child: SvgPicture.asset(
                                        "assets/appImages/markets/inverted_rectangle.svg",
                                        color: Utils.lightRedColor,
                                        ),
                                      ) ,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
              );
            }),
      ),
        
    ]);
  }
}

class Sheet extends StatefulWidget {
  const Sheet({Key key}) : super(key: key);

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  var index;
  var tabValue;
  List preferredSector = [
    'All',
    'Nifty 50',
    'Nifty Midcap 150',
    'Nifty Smallcap 250',
    'Nifty Smallcap 100',
    'Nifty Large Midcap',
    'Nifty Mid Smallcap',
    'Nifty SME Emerge',
    'Nifty 100 Equal',
    'Nifty Alpha 50',
  ];

  Widget preferredSectorTitle(String title, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                index = i;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: Utils.fonts(
                        size: 14.0,
                        fontWeight:
                            index == i ? FontWeight.w600 : FontWeight.w400,
                        color: index == i
                            ? Utils.primaryColor
                            : Utils.blackColor)),
                index == i
                    ? SvgPicture.asset(
                        'assets/appImages/markets/checkbox_circle_blue.svg')
                    : Container(
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            )),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(children: [
      SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Index",
                style: Utils.fonts(
                    fontWeight: FontWeight.w700,
                    size: 17.0,
                    color: Utils.blackColor)),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      tabValue = 1;

                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: tabValue == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        bottom: tabValue == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        right: tabValue == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                        left: tabValue == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("NSE",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: tabValue == 1
                                    ? Utils.primaryColor
                                    : Utils.greyColor)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      tabValue = 2;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: tabValue == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        bottom: tabValue == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        right: tabValue == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                        left: tabValue == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("BSE",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: tabValue == 2
                                    ? Utils.primaryColor
                                    : Utils.greyColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Column(
        children: List.generate(preferredSector.length, (index) {
          return preferredSectorTitle(preferredSector[index], index);
        }),
      )
    ]);
  }
}
