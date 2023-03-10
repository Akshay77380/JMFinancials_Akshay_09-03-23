import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../style/theme.dart';
import '../../util/Utils.dart';
import 'dart:math' as math;

class TradeReports extends StatefulWidget {
  const TradeReports({Key key}) : super(key: key);

  @override
  State<TradeReports> createState() => _TradeReportsState();
}

class _TradeReportsState extends State<TradeReports>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  List<String> _productItems = ['data1', 'data2', 'data3'];
  String _productType = 'Last 10 Days (1 Apr to 10 Apr)';

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _tabController.index = Dataconstants.tradeScreenIndex;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Trade Reports",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
              child: TabBar(
                isScrollable: true,
                labelStyle:
                    Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.grey[600],
                labelColor: Utils.primaryColor,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  insets: EdgeInsets.symmetric(horizontal: 2),
                  indicatorColor: Utils.primaryColor.withOpacity(0.3),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: _currentIndex == 0
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Equity',
                        ),
                        if (_currentIndex == 0) const SizedBox(width: 8),
                        // if (_currentIndex == 0)
                        // Obx(() {
                        //   return OrderBookController.isLoading.value
                        //       ? SizedBox.shrink()
                        //       : Visibility(
                        //     visible:
                        //     OrderBookController.isLoading.value ==
                        //         true
                        //         ? false
                        //         : true,
                        //     child: CircleAvatar(
                        //       backgroundColor: _tabController.index == 0
                        //           ? theme.primaryColor
                        //           : Colors.grey,
                        //       foregroundColor: Colors.white,
                        //       maxRadius: 11,
                        //       child: Text(
                        //         '${OrderBookController.OrderBookLength}',
                        //         style: const TextStyle(fontSize: 12),
                        //       ),
                        //     ),
                        //   );
                        // })
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: _currentIndex == 1
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Equity F&O',
                        ),
                        if (_currentIndex == 1) const SizedBox(width: 8),
                        // if (_currentIndex == 1)
                        // Obx(() {
                        //   return NetPositionController.isLoading.value &&
                        //       TodaysPositionController.isLoading.value
                        //       ? SizedBox.shrink()
                        //       : Visibility(
                        //     visible:
                        //     NetPositionController.isLoading.value ==
                        //         true &&
                        //         TodaysPositionController
                        //             .isLoading.value ==
                        //             true
                        //         ? false
                        //         : true,
                        //     child: CircleAvatar(
                        //       backgroundColor: _tabController.index == 1
                        //           ? theme.primaryColor
                        //           : Colors.grey,
                        //       foregroundColor: Colors.white,
                        //       maxRadius: 11,
                        //       child: Text(
                        //         '${(NetPositionController.NetPositionLength + TodaysPositionController.TodaysPositionLength).toString()}',
                        //         style: const TextStyle(fontSize: 12),
                        //       ),
                        //     ),
                        //   );
                        // })
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: _currentIndex == 2
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Commodity',
                        ),
                        if (_currentIndex == 2) const SizedBox(width: 8),
                        // if (_currentIndex == 2)
                        // CircleAvatar(
                        //     backgroundColor: _currentIndex == 2
                        //         ? Utils.primaryColor
                        //         : Utils.greyColor,
                        //     foregroundColor: Utils.whiteColor,
                        //     maxRadius: 11,
                        //     child: Text("0", style: const TextStyle(fontSize: 12),))
                        //   Obx(() {
                        //     return HoldingController.isLoading.value
                        //         ? SizedBox.shrink()
                        //         : Visibility(
                        //       visible:
                        //       HoldingController.isLoading.value == true
                        //           ? false
                        //           : true,
                        //       child: CircleAvatar(
                        //         backgroundColor: _tabController.index == 2
                        //             ? theme.primaryColor
                        //             : Colors.grey,
                        //         foregroundColor: Colors.white,
                        //         maxRadius: 11,
                        //         child: Text(HoldingController.HoldigsLength.toString(),
                        //           style: const TextStyle(fontSize: 12),
                        //         ),
                        //       ),
                        //     );
                        //   })
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: _currentIndex == 2
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Currency',
                        ),
                        if (_currentIndex == 2) const SizedBox(width: 8),
                        // if (_currentIndex == 2)
                        // CircleAvatar(
                        //     backgroundColor: _currentIndex == 2
                        //         ? Utils.primaryColor
                        //         : Utils.greyColor,
                        //     foregroundColor: Utils.whiteColor,
                        //     maxRadius: 11,
                        //     child: Text("0", style: const TextStyle(fontSize: 12),))
                        //   Obx(() {
                        //     return HoldingController.isLoading.value
                        //         ? SizedBox.shrink()
                        //         : Visibility(
                        //       visible:
                        //       HoldingController.isLoading.value == true
                        //           ? false
                        //           : true,
                        //       child: CircleAvatar(
                        //         backgroundColor: _tabController.index == 2
                        //             ? theme.primaryColor
                        //             : Colors.grey,
                        //         foregroundColor: Colors.white,
                        //         maxRadius: 11,
                        //         child: Text(HoldingController.HoldigsLength.toString(),
                        //           style: const TextStyle(fontSize: 12),
                        //         ),
                        //       ),
                        //     );
                        //   })
                      ],
                    ),
                  ),
                ],
                onTap: (value) {
                  setState(() {
                    Dataconstants.ordersScreenIndex = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "View Combined Ledger for",
                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 55,
                width: size.width,
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.dullWhiteColor),
                child: DropdownButton<String>(
                    isExpanded: true,
                    items: _productItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Utils.fonts(
                              size: 14.0,
                              color: theme.textTheme.bodyText1.color),
                        ),
                        onTap: () {
                          //TODO:
                        },
                      );
                    }).toList(),
                    underline: SizedBox(),
                    hint: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _productType,
                          style: Utils.fonts(
                              size: 14.0,
                              color: theme.textTheme.bodyText1.color),
                        ),
                        Text(
                          'Short Description',
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 12.0,
                              color: theme.textTheme.bodyText1.color),
                        ),
                      ],
                    ),
                    icon: Icon(
                      // Add this
                      Icons.arrow_drop_down, // Add this
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color, // Add this
                    ),
                    onChanged: (val) {
                      setState(() {
                        _productType = val;
                      });
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Utils.greyColor.withOpacity(0.1),
                ),
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Search Scrip',
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SvgPicture.asset(
                              'assets/appImages/searchSmall.svg',
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                          ),
                          suffixIcon: SvgPicture.asset(
                            'assets/appImages/voiceSearchGrey.svg',
                          ),
                          labelStyle: Utils.fonts(
                              size: 14.0, fontWeight: FontWeight.w600),
                          hintStyle: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Utils.greyColor),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.sort_rounded),
                    //   onPressed: () {
                    //     FocusManager.instance.primaryFocus.unfocus();
                    //     showModalBottomSheet<void>(
                    //       isScrollControlled: true,
                    //       context: context,
                    //       builder: (BuildContext context) =>
                    //           PendingOrdersFilter(DataConstants.orderReportModel
                    //               .getPendingFilterMap()),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last 10 Transaction",
                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w300),
                  ),
                  SvgPicture.asset(
                    'assets/appImages/download.svg',
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ThemeConstants.buyColor),
                        child: Text(
                          "BUY",
                          style: Utils.fonts(
                              color: Utils.whiteColor,
                              size: 10.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("INFY",
                          style: Utils.fonts(
                              size: 16.0, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TR Date",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "06 Jan 2022",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Qty",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "100",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Value",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "35,655.6",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
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
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ThemeConstants.sellColor),
                        child: Text(
                          "SELL",
                          style: Utils.fonts(
                              color: Utils.whiteColor,
                              size: 10.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("ONGC",
                          style: Utils.fonts(
                              size: 16.0, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TR Date",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "06 Jan 2022",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Qty",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "100",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Value",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "35,655.6",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Net Rate with STT",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "31.12",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rate",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "134.55",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
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
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "BSE",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "531.00",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumRedColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "531.00",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumGreenColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "0.0",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
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
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ThemeConstants.buyColor),
                        child: Text(
                          "BUY",
                          style: Utils.fonts(
                              color: Utils.whiteColor,
                              size: 10.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("RELIANCE",
                          style: Utils.fonts(
                              size: 16.0, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TR Date",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "06 Jan 2022",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Qty",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "50",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Value",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "35,655.6",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Utils.primaryColor.withOpacity(0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Date",
              style: TextStyle(fontSize: 18, color: Utils.whiteColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              'assets/appImages/uparrow.svg',
              width: 15,
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
