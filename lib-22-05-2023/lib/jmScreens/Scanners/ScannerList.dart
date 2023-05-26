import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/Scanners/buildup.dart';

import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'ScannersView.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var isList = false;
  TabController _tabController;
  int _currentIndex = 0;
  List<String> dropDownList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    // getDropDownlist();
    super.initState();
  }

  // void getDropDownlist() {
  //   dropDownList = [];
  //   //dropDownList.add("NSE - All Scrips");
  //   for (int i = 0; i < DataConstants.groupList.length; i++) {
  //     if (!dropDownList.contains(DataConstants.groupList[i].groupName)) {
  //       dropDownList.add(DataConstants.groupList[i].groupName);
  //     }
  //   }
  //
  // }
  var StrategiesList = [
    [
      "bullish_cir.svg",
      "Bullish Strategy",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "37 Scrips"
    ],
    [
      "bearish_cir.svg",
      "Bearish Strategy",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "12 Scrips"
    ],
    [
      "neutral_cir.svg",
      "Neutral Strategy",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "49 Scrips"
    ],
    [
      "IV_cir.svg",
      "IV Strategy",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "67 Scrips"
    ],
    [
      "index_cir.svg",
      "Index Strategy",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
  ];

  var ScannersList = [
    [
      "rising&falling_cir.svg",
      "Rising & Falling",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "37 Scrips"
    ],
    [
      "high&low_breaker_cir.svg",
      "High & Low Breaker",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "12 Scrips"
    ],
    [
      "strong_weak_cir.svg",
      "Strong & Weak",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "49 Scrips"
    ],
    [
      "circuit_breakers_cir.svg",
      "Circuit Breakers",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "67 Scrips"
    ],
    [
      "volume_shocker_cir.svg",
      "Volume Shocker",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
    [
      "high_low_cir.svg",
      "Open High or Low",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
    [
      "res_support_cir.svg",
      "Resistance & Support",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
    [
      "spreads_cir.svg",
      "Spreads",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
    [
      "tranding.svg",
      "Buildup",
      "Want to take bullish position on a particular stock? Use our in built bullish scanner to create profitable strategy",
      "2 Scrips"
    ],
  ];

  var gridStrategiesList = [
    ["bullish.svg", "Bullish", "Minimum Investment", "37 Scrips", "₹27,500"],
    ["bearish.svg", "Bearish", "Minimum Investment", "12 Scrips", "₹4,500"],
    ["neutral.svg", "Neutral", "Minimum Investment", "49 Scrips", "₹9,200"],
    ["IV.svg", "IV", "Minimum Investment", "67 Scrips", "₹600"],
    ["indices.svg", "Indices", "Minimum Investment", "2 Scrips", "₹5,200"],
  ];

  var gridScannerList = [
    [
      "rising&falling.svg",
      "Rising & Falling",
      "Minimum Investment",
      "37 Scrips",
      "₹27,500"
    ],
    [
      "high&low_breaker.svg",
      "High & Low Breaker",
      "Minimum Investment",
      "12 Scrips",
      "₹4,500"
    ],
    [
      "strong_weak.svg",
      "Strong & Weak",
      "Minimum Investment",
      "49 Scrips",
      "₹9,200"
    ],
    [
      "circuit_breakers.svg",
      "Circuit Breakers",
      "Minimum Investment",
      "67 Scrips",
      "₹600"
    ],
    [
      "volume_shocker.svg",
      "Volume Shocker",
      "Minimum Investment",
      "2 Scrips",
      "₹5,200"
    ],
    [
      "high_low.svg",
      "Open High or Low",
      "Minimum Investment",
      "2 Scrips",
      "₹5,200"
    ],
    [
      "res_support.svg",
      "Resistance & Support",
      "Minimum Investment",
      "2 Scrips",
      "₹5,200"
    ],
    ["spreads.svg", "Spreads", "Minimum Investment", "2 Scrips", "₹5,200"],
    ["tranding.svg", "BuildUp", "Minimum Investment", "2 Scrips", "₹5,200"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Analytics",
          style: Utils.fonts(color: Utils.blackColor, size: 18.0),
        ),
        actions: [
          InkWell(
              onTap: () {
                if (isList)
                  setState(() {
                    isList = false;
                  });
                else
                  setState(() {
                    isList = true;
                  });
              },
              child: Icon(isList ? Icons.grid_view_rounded : Icons.reorder)),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {},
              child: SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 20,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                TabBar(
                  isScrollable: true,
                  physics: CustomTabBarScrollPhysics(),
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
                  onTap: (_index) {
                    setState(() {
                      _currentIndex = _index;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Strategies",
                        style:
                            Utils.fonts(size: _currentIndex == 0 ? 13.0 : 11.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Scanners",
                        style:
                            Utils.fonts(size: _currentIndex == 1 ? 13.0 : 11.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_currentIndex == 0 ? strategiesView() : scannersView()],
        ),
      ),
    );
  }

  strategiesView() {
    return isList ? ViewByList() : ViewByGrid();
  }

  scannersView() {
    return isList ? ScannersViewByList() : ScannersViewByGrid();
  }

  ScannersViewByGrid() {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(
          gridScannerList.length,
          (i) => GestureDetector(
            onTap: () {
              Map<int, List<String>> tempList = gridScannerList.asMap();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuildUpScanner(
                        selectedTabIndex: tempList[i],
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Utils.greyColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/" + gridScannerList[i][0].toString(),
                      height: 60,
                      width: 60,
                    ),
                    Text(
                      gridScannerList[i][1].toString(),
                      style: Utils.fonts(size: 15.0),
                    ),
                    Text(
                      gridScannerList[i][3].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    Spacer(),
                    Text(
                      gridScannerList[i][2].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    Text(
                      gridScannerList[i][4].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        // <Widget>[
        //   for (var i = 0; i < gridScannerList.length; i++)
        //     GestureDetector(onTap: (){
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildUpScanner(selectedTabIndex: gridScannerList[i],)));
        //     },
        //     ),
        // ],
        );
  }

  ScannersViewByList() {
    return Column(
      children: [
        SizedBox(
          height: 8.0,
        ),
        for (var i = 0; i < ScannersList.length; i++)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuildUpScanner(
                        selectedTabIndex: gridScannerList[i],
                      )));
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                          "assets/appImages/" + ScannersList[i][0].toString()),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        ScannersList[i][1].toString(),
                        style: Utils.fonts(size: 14.0),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: Utils.lightyellowColor.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3.0),
                          child: Text(
                            ScannersList[i][3].toString(),
                            style: Utils.fonts(
                                size: 12.0, color: Utils.darkyellowColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ScannersList[i][2].toString(),
                    style: Utils.fonts(
                        size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                  ),
                  Divider()
                ],
              ),
            ),
          )
      ],
    );
  }

  ViewByGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: <Widget>[
        for (var i = 0; i < gridStrategiesList.length; i++)
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScannersView()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Utils.greyColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/" + gridStrategiesList[i][0].toString(),
                      height: 60,
                      width: 60,
                    ),
                    Text(
                      gridStrategiesList[i][1].toString(),
                      style: Utils.fonts(size: 15.0),
                    ),
                    Text(
                      gridStrategiesList[i][3].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    Spacer(),
                    Text(
                      gridStrategiesList[i][2].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    Text(
                      gridStrategiesList[i][4].toString(),
                      style: Utils.fonts(size: 13.0, color: Utils.greyColor),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  ViewByList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          for (var i = 0; i < StrategiesList.length; i++)
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScannersView()));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/appImages/" +
                            StrategiesList[i][0].toString()),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          StrategiesList[i][1].toString(),
                          style: Utils.fonts(size: 14.0),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.lightyellowColor.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3.0),
                            child: Text(
                              StrategiesList[i][3].toString(),
                              style: Utils.fonts(
                                  size: 12.0, color: Utils.darkyellowColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      StrategiesList[i][2].toString(),
                      style: Utils.fonts(
                          size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                    ),
                    Divider()
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
