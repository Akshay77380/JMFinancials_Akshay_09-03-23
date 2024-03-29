import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/holdingController.dart';
import '../../controllers/netPositionController.dart';
import '../../controllers/orderBookController.dart';
import '../../controllers/positionFilterController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'holdings_screen.dart';
import 'order_book_screen.dart';
import 'order_filters.dart';
import 'positions_screen.dart';
import 'dart:ui';

class JMOrdersScreen extends StatefulWidget {
  var isComingFromDashBoard = 0;

  JMOrdersScreen(this.isComingFromDashBoard);

  @override
  State<JMOrdersScreen> createState() => _JMOrdersScreenState();
}

class _JMOrdersScreenState extends State<JMOrdersScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('orderBookFilters') == null || prefs.getString('positionFilters') == null) InAppSelection.saveSelections();
    });

    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });

    // _tabController.index = Dataconstants.ordersScreenIndex;
    _tabController.index = Dataconstants.ordersScreenIndex == 2
        ? 1
        : Dataconstants.ordersScreenIndex == 3
            ? 2
            : 0;
    // _tabController.index = 1;
    Dataconstants.orderBookData.fetchOrderBook();
    CommonFunction.changeStatusBar();
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
      appBar: PositionFilterController.isPositionSearch.value || HoldingController.isHoldingSearch.value
          ? PositionFilterController.isPositionSearch.value
              ? AppBar(
                  systemOverlayStyle: Dataconstants.overlayStyle,
                  // leading: GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       Dataconstants.positionFilterController
                  //           .updatePositionsBySearch('');
                  //       PositionFilterController.isPositionSearch.value = false;
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Icon(Icons.arrow_back),
                  //   ),
                  // ),
                  // leadingWidth: 25,
                  title: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            Dataconstants.positionFilterController.updatePositionsBySearch(value);
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            prefixIcon: Icon(Icons.search, color: Utils.greyColor.withOpacity(0.7)),
                            suffixIcon: Icon(
                              Icons.mic_none,
                              size: 20,
                              color: Utils.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Search Sector / Indices',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Dataconstants.positionFilterController.updatePositionsBySearch('');
                              PositionFilterController.isPositionSearch.value = false;
                            });
                          },
                          child: Text(
                            'Cancel',
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                )
              : AppBar(
                  // leading: GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       Dataconstants.holdingController
                  //           .updateHoldingsBySearch('');
                  //       HoldingController.isHoldingSearch.value = false;
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Icon(Icons.arrow_back),
                  //   ),
                  // ),
                  // leadingWidth: 25,
                  systemOverlayStyle: Dataconstants.overlayStyle,
                  title: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            Dataconstants.holdingController.updateHoldingsBySearch(value);
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            prefixIcon: Icon(Icons.search, color: Utils.greyColor.withOpacity(0.7)),
                            suffixIcon: Icon(
                              Icons.mic_none,
                              size: 20,
                              color: Utils.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: 'Search Sector / Indices',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Dataconstants.holdingController.updateHoldingsBySearch('');
                              HoldingController.isHoldingSearch.value = false;
                            });
                          },
                          child: Text(
                            'Cancel',
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                )
          : AppBar(
              systemOverlayStyle: Dataconstants.overlayStyle,
              // leadingWidth: 30,
              // leading: Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: InkWell(
              //     onTap: () {
              //       // Navigator.pop(context);
              //     },
              //     child: Icon(
              //       Icons.arrow_back,
              //       color: Utils.greyColor,
              //     ),
              //   ),
              // ),
              title: Text(
                "Orders",
                style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
              ),
              elevation: 0,
              actions: [
                if (_currentIndex != 0)
                  InkWell(
                    onTap: () {
                      if (_currentIndex == 1) {
                        setState(() {
                          PositionFilterController.isPositionSearch.value = true;
                        });
                      }
                      if (_currentIndex == 2) {
                        setState(() {
                          HoldingController.isHoldingSearch.value = true;
                        });
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/appImages/searchSmall.svg',
                      color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                  ),
                if (_currentIndex != 0)
                  SizedBox(
                    width: 15,
                  ),
                InkWell(
                    onTap: () {
                      CommonFunction.marketWatchBottomSheet(context);
                    },
                    child: SvgPicture.asset(
                      'assets/appImages/tranding.svg',
                      color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor,
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (_currentIndex == 0) OrderBookController.isOrderBookSearch.value = true;
                    if (_currentIndex == 1) PositionFilterController.isPositionFilter.value = true;
                    FocusManager.instance.primaryFocus.unfocus();
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      builder: (BuildContext context) => _currentIndex == 0
                          ? OrderBookFilters(Dataconstants.orderBookData.getOrderBookFilterMap())
                          : _currentIndex == 1
                              ? PositionFilters(Dataconstants.positionFilterController.getPositionFilterMap())
                              : HoldingFilters(),
                    ).whenComplete(() {
                      if (_currentIndex == 0) {
                        OrderBookController.sortVal.value = OrderBookController.sortPrevVal.value;
                        CommonFunction.cancelFilters(true);
                      } else {
                        PositionFilterController.sortVal.value = PositionFilterController.sortPrevVal.value;
                        CommonFunction.cancelFilters(false);
                      }
                    });
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
                    child: TabBar(
                      isScrollable: true,
                      labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
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
                            mainAxisAlignment: _currentIndex == 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Book',
                              ),
                              CircleAvatar(
                                backgroundColor: _tabController.index == 0 ? theme.primaryColor : Colors.grey,
                                foregroundColor: Colors.white,
                                maxRadius: 11,
                                child: Text(
                                  // '${OrderBookController.OrderBookLength}',
                                  '${OrderBookController.allList.length}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: _currentIndex == 1 ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Positions',
                              ),
                              CircleAvatar(
                                backgroundColor: _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                foregroundColor: Colors.white,
                                maxRadius: 11,
                                child: Text(
                                  '${NetPositionController.NetPositionLength.toString()}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: _currentIndex == 2 ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              const Text(
                                'DP Holdings',
                              ),
                              // CircleAvatar(
                              //     backgroundColor: _currentIndex == 2
                              //         ? Utils.primaryColor
                              //         : Utils.greyColor,
                              //     foregroundColor: Utils.whiteColor,
                              //     maxRadius: 11,
                              //     child: Text("0", style: const TextStyle(fontSize: 12),))
                              CircleAvatar(
                                backgroundColor: _tabController.index == 2 ? theme.primaryColor : Colors.grey,
                                foregroundColor: Colors.white,
                                maxRadius: 11,
                                child: Text(
                                  HoldingController.HoldigsLength.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
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
      body: Stack(children: [
        TabBarView(
          physics: CustomTabBarScrollPhysics(),
          controller: _tabController,
          children: [
            OrderBookScreen(),
            PositionsScreen(),
            HoldingsScreen(),
          ],
        ),
        Dataconstants.isGuestUser
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Column(
                    children: [
                      Spacer(),
                      new Container(
                        // width: 200.0,
                        height: 200.0,
                        // decoration: new BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 250.0,

                                  // spreadRadius: 10.-
                                ),
                              ]),
                              child: SvgPicture.asset(
                                "assets/appImages/jmicon.svg",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Open Account with BlinkTrade PRO today and get access to exclusive features of the app',
                              style: Utils.fonts(),
                              textAlign: TextAlign.center,
                              // style: Theme.of(context).textTheme.display3
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink()
      ]),
    );
  }
}
