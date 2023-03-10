import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../controllers/blockDealsController.dart';
import '../../controllers/bulkController.dart';
import '../../util/Utils.dart';
import 'bulk_block_deals.dart';
import 'exch_messages.dart';
import 'fii_dii.dart';
import 'market_global.dart';
import 'market_indices.dart';
import 'market_overview.dart';
import 'market_events.dart';
import 'market_stats.dart';
import 'market_status.dart';
import 'news.dart';

class MarketLandingPage extends StatefulWidget {
  var _currentTabIndex = 0;
  var _currentIndex = 0;

  @override
  State<MarketLandingPage> createState() => _MarketLandingPageState();
}

class _MarketLandingPageState extends State<MarketLandingPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  TabController _tabController;

  @override
  void initState() {
    Dataconstants.topLosersController.getTopLosers('month');
    Dataconstants.oiLosersController.getOiLosers();
    Dataconstants.topGainersController.getTopGainers('month');
    Dataconstants.mostActiveVolumeController.getMostActiveVolume();


    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 10)
      ..addListener(() {
        setState(() {
          widget._currentTabIndex = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Markets",
            style: TextStyle(
                color: Utils.blackColor, fontWeight: FontWeight.w700)),
        elevation: 0,

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10),
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
                        child: Text("Overview"),
                      ),
                      Tab(
                        child: Text("Global"),
                      ),
                      Tab(
                        child: Text("Indices"),
                      ),
                      Tab(
                        child: Text("Stats"),
                      ),
                      Tab(
                        child: Text("News"),
                      ),
                      Tab(
                        child: Text("Events"),
                      ),
                      Tab(
                        child: Text("FII/DII"),
                      ),
                      Tab(

                        child: Text("Bulk & Block Details"),
                      ),
                      Tab(
                        child: Text("Exch. Messages"),
                      ),
                      Tab(
                        child: Text("Market Status"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            (() {
              if (widget._currentTabIndex == 0) {
                return MarketOverView();
              } else if (widget._currentTabIndex == 1) {
                return MarketGlobal();
              } else if (widget._currentTabIndex == 2) {
                return MarketIndices();
              } else if (widget._currentTabIndex == 3) {
                return MarketStats();
              } else if (widget._currentTabIndex == 4) {
                return News();
              } else if (widget._currentTabIndex == 5) {
                return MarketEvents();
              } else if (widget._currentTabIndex == 6) {
                return FiiDii();
              } else if (widget._currentTabIndex == 7) {
                Dataconstants.blockDealsController = Get.put(BlockDealsController());
                return BulkBlockDeals();
              } else if (widget._currentTabIndex == 8) {
                return ExchMessage();
              } else if (widget._currentTabIndex == 9) {
                return MarketStatus();
              }
            }())
          ],
        ),
      ),
    );
  }

  Widget EventsDividend() {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TCS",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("12.50 / share",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ex Date",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Record Date",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Div Yield",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("5.90%",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Utils.darkGreenColor)),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      SizedBox(
        height: 20,
      ),
      SvgPicture.asset("assets/appImages/markets/party.svg")
    ]);
  }

  Widget EventsBonus() {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TCS",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("12.50 / share",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Announcement Date",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Ex-Bonus",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("5.90%",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Utils.blackColor)),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      SizedBox(
        height: 20,
      ),
      SvgPicture.asset("assets/appImages/markets/party.svg")
    ]);
  }

  Widget EventsRights() {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("WOCKHARDT",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("1:1",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ex-Right",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Premium",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("5.90%",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Utils.blackColor)),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      SizedBox(
        height: 20,
      ),
      SvgPicture.asset("assets/appImages/markets/party.svg")
    ]);
  }

  Widget EventsSplits() {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("WOCKHARDT",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("1:1",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ex-Right",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Premium",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("5.90%",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Utils.blackColor)),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      SizedBox(
        height: 20,
      ),
      SvgPicture.asset("assets/appImages/markets/party.svg")
    ]);
  }

  Widget EventsBoardMeet() {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TCS",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("12.50 / share",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Agenda",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("Quaterly Results &InterimDividend",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black.withOpacity(0.6))),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      SizedBox(
        height: 20,
      ),
      SvgPicture.asset("assets/appImages/markets/markets/party.svg")
    ]);
  }
}
