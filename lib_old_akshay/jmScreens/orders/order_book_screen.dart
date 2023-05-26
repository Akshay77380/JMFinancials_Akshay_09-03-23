import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/orderBookController.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../mainScreen/MainScreen.dart';
import 'all_orders.dart';
import 'executed_orders.dart';
import 'pending_orders.dart';

class OrderBookScreen extends StatefulWidget {
  @override
  State<OrderBookScreen> createState() => _OrderBookScreenState();
}

class _OrderBookScreenState extends State<OrderBookScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    // Dataconstants.orderBookData.fetchOrderBook();
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _tabController.index = Dataconstants.orderBookIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Utils.greyColor.withOpacity(0.1),
                ),
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  onSubmitted: (_) {
                    OrderBookController.isOrderBookSearch.value = false;
                  },
                  onChanged: (value) {
                    OrderBookController.isOrderBookSearch.value = true;
                    Dataconstants.orderBookData.updateOrdersBySearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Scrip / Expiry Date',
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
                    labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600),
                    hintStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600, color: Utils.greyColor),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() {
                return OrderBookController.isLoading.value
                    ? SizedBox.shrink()
                    : !(OrderBookController.pendingLength == 0 && OrderBookController.executedLength == 0 && OrderBookController.allLength == 0)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TabBar(
                                      isScrollable: true,
                                      labelStyle: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                      unselectedLabelStyle: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                      unselectedLabelColor: Colors.grey[600],
                                      labelColor: Utils.primaryColor,
                                      indicatorPadding: EdgeInsets.zero,
                                      labelPadding: EdgeInsets.zero,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicatorWeight: 0,
                                      indicator: BoxDecoration(),
                                      controller: _tabController,
                                      tabs: [
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              ),
                                              border: Border.all(color: _currentIndex == 0 ? Utils.primaryColor : Utils.greyColor)),
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Tab(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'PENDING',
                                                ),
                                                const SizedBox(width: 5),
                                                Obx(() {
                                                  return OrderBookController.isLoading.value
                                                      ? SizedBox.shrink()
                                                      : Visibility(
                                                          visible: OrderBookController.isLoading.value == true ? false : true,
                                                          child: CircleAvatar(
                                                            backgroundColor: _tabController.index == 0 ? theme.primaryColor : Colors.grey,
                                                            foregroundColor: Colors.white,
                                                            maxRadius: 11,
                                                            child: Text(
                                                              '${OrderBookController.pendingLength}',
                                                              style: const TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                        );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                              // borderRadius: BorderRadius.only(
                                              //   topRight: Radius.circular(5),
                                              //   bottomRight: Radius.circular(5),
                                              // ),
                                              border: Border.all(color: _currentIndex == 1 ? Utils.primaryColor : Utils.greyColor)),
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Tab(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'EXECUTED',
                                                ),
                                                const SizedBox(width: 5),
                                                Obx(() {
                                                  return OrderBookController.isLoading.value
                                                      ? SizedBox.shrink()
                                                      : Visibility(
                                                          visible: OrderBookController.isLoading.value == true ? false : true,
                                                          child: CircleAvatar(
                                                            backgroundColor: _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                                            foregroundColor: Colors.white,
                                                            maxRadius: 11,
                                                            child: Text(
                                                              '${OrderBookController.executedLength}',
                                                              style: const TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                        );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomRight: Radius.circular(5),
                                              ),
                                              border: Border.all(color: _currentIndex == 2 ? Utils.primaryColor : Utils.greyColor)),
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Tab(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'ALL',
                                                ),
                                                const SizedBox(width: 5),
                                                Obx(() {
                                                  return OrderBookController.isLoading.value
                                                      ? SizedBox.shrink()
                                                      : Visibility(
                                                    visible: OrderBookController.isLoading.value == true ? false : true,
                                                    child: CircleAvatar(
                                                      backgroundColor: _tabController.index == 2 ? theme.primaryColor : Colors.grey,
                                                      foregroundColor: Colors.white,
                                                      maxRadius: 11,
                                                      child: Text(
                                                        // '${OrderBookController.cancelCount.toInt() + OrderBookController.pendingLength.toInt()}',
                                                        '${OrderBookController.allList.length.toInt()}',
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      onTap: (value) {
                                        setState(() {
                                          Dataconstants.orderBookIndex = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          )
                        : SizedBox.shrink();
              })
            ],
          ),
        ),
        Divider(
          thickness: 2,
        ),
        Obx(() {
          return OrderBookController.isLoading.value
              ? CircularProgressIndicator()
              : !(OrderBookController.pendingLength == 0 && OrderBookController.executedLength == 0 && OrderBookController.allList.isEmpty)
                ? Expanded(
                      child: TabBarView(
                        physics: CustomTabBarScrollPhysics(),
                        controller: _tabController,
                        children: [
                          PendingOrders(),
                          ExecutedOrders(),
                          AllOrders(),
                        ],
                      ),
                    )
                : Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/appImages/noOrders.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "You have no Orders in Order Book",
                            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: theme.primaryColor,
                                ),
                              ),
                              color: theme.primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                'GO TO WATCHLIST',
                                style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.white),
                              ),
                              onPressed: () {
                                InAppSelection.mainScreenIndex = 1;
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (_) => MainScreen(
                                          toChangeTab: false,
                                        )));
                              })
                        ],
                      ),
                    );
        })
      ],
    );
  }
}
