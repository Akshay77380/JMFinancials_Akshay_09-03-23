import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/jmScreens/orders/holding_details.dart';
import '../../controllers/holdingController.dart';
import '../../model/jmModel/holdings.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../mainScreen/MainScreen.dart';

class HoldingsScreen extends StatefulWidget {
  @override
  State<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends State<HoldingsScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });

    _tabController.index = Dataconstants.holdingIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Dataconstants.holdingController.fetchHolding();
      await Dataconstants.holdingController.fetchMtfHolding();
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        // if (!(HoldingController.HoldigsLength == 0))
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: [
                    Color(0xff7ca6fa).withOpacity(0.2),
                    Color(0xff219305ff).withOpacity(0.2),
                  ]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Total Value",
                          style: Utils.fonts(
                            size: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        Obx(() => Text(
                              HoldingController.totalVal2.value.toStringAsFixed(2),
                              style: Utils.fonts(
                                size: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ))
                        //
                        // Observer(builder: (context) => Text(HoldingController.HoldingData),)
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Advance",
                          style: Utils.fonts(
                            size: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Dataconstants.holdingIndex == 0
                            ? Obx(() => Text(
                                  HoldingController.advances.value.toString(),
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w400, color: Utils.brightGreenColor),
                                ))
                            : Obx(() => Text(
                                  HoldingController.MtfAdvances.value.toString(),
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w400, color: Utils.brightGreenColor),
                                ))
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Decline",
                          style: Utils.fonts(
                            size: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Dataconstants.holdingIndex == 0
                            ? Obx(() => Text(
                                  HoldingController.declines.value.toString(),
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w400, color: Utils.brightRedColor),
                                ))
                            : Obx(() => Text(
                                  HoldingController.MtfDeclines.value.toString(),
                                  style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w400, color: Utils.brightRedColor),
                                ))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() {
                return HoldingController.isLoading.value
                    ? SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          // width: size.width,
                          decoration: BoxDecoration(border: Border.all(color: Utils.greyColor)),
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
                                decoration: BoxDecoration(border: Border.all(color: _currentIndex == 0 ? Utils.primaryColor : Colors.transparent)),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'HOLDINGS',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                decoration: BoxDecoration(border: Border.all(color: _currentIndex == 1 ? Utils.primaryColor : Utils.greyColor)),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'MTF',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                decoration: BoxDecoration(border: Border.all(color: _currentIndex == 2 ? Utils.primaryColor : Colors.transparent)),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'INVESTMENT BASKET',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            onTap: (value) {
                              setState(() {
                                Dataconstants.holdingIndex = value;
                              });
                            },
                          ),
                        ),
                      );
              }),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
        ),
        Obx(() {
          return HoldingController.isLoading.value
              ? CircularProgressIndicator()
              : !(HoldingController.HoldigsLength == 0)
                  ? Expanded(
                      child: TabBarView(
                        physics: CustomTabBarScrollPhysics(),
                        controller: _tabController,
                        children: [Holdings(), MtfHoldings(), InvestmentBasketHoldings()],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Seems you have no holding at the moment",
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
        }),
      ],
    );
  }
}

class Holdings extends StatefulWidget {
  @override
  State<Holdings> createState() => _HoldingsState();
}

class _HoldingsState extends State<Holdings> {
  bool expandNote = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Obx(() {
            return HoldingController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: theme.primaryColor,
                    onRefresh: () {
                      Dataconstants.holdingController.fetchHolding();
                      return Future.value(true);
                    },
                    child: HoldingController.holdingList.length == 0
                        ? HoldingController.isHoldingSearch.value
                            ? Center(
                                child: Text(
                                  "No records found",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Seems you have no holding at the moment",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Symbol',
                                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'LTP',
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Holding Qty',
                                            style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Valuation',
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: HoldingController.holdingList.length,
                                    itemBuilder: (ctx, index) => HoldingsTile(HoldingController.holdingList[index]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            expandNote = !expandNote;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Note',
                                              style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SvgPicture.asset(!expandNote ? 'assets/appImages/down_arrow.svg' : 'assets/appImages/up_arrow.svg'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Visibility(
                                        visible: expandNote,
                                        child: Text(
                                          '\n1. This is just the logical holding balance. For actual DP Balance and saleable quantity please check Holding Report.'
                                          '\n\n2. Portfolio Reports are updated on EOD basis. Please refer Net Position, Trade and Order Book for orders placed today',
                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.lightGreyColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  CommonFunction.message('That’s all we have for you today'),
                                ],
                              ),
                            ),
                          ));
          }),
        )
      ],
    );
  }
}

class MtfHoldings extends StatefulWidget {
  @override
  State<MtfHoldings> createState() => _MtfHoldingsState();
}

class _MtfHoldingsState extends State<MtfHoldings> {
  bool expandNote = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Obx(() {
            return HoldingController.isLoadingMtf.value
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: theme.primaryColor,
                    onRefresh: () {
                      Dataconstants.holdingController.fetchMtfHolding();
                      return Future.value(true);
                    },
                    child: HoldingController.mtfHoldingList.length == 0
                        ? HoldingController.isHoldingSearch.value
                            ? Center(
                                child: Text(
                                  "No records found",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Seems you have no MTF holding at the moment",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Symbol',
                                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'LTP',
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Holding Qty',
                                            style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Valuation',
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: HoldingController.mtfHoldingList.length,
                                    itemBuilder: (ctx, index) => HoldingsTile(HoldingController.mtfHoldingList[index]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            expandNote = !expandNote;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Note',
                                              style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SvgPicture.asset(!expandNote ? 'assets/appImages/down_arrow.svg' : 'assets/appImages/up_arrow.svg'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Visibility(
                                        visible: expandNote,
                                        child: Text(
                                          '\n1. This is just the logical holding balance. For actual DP Balance and saleable quantity please check Holding Report.'
                                          '\n\n2. Portfolio Reports are updated on EOD basis. Please refer Net Position, Trade and Order Book for orders placed today',
                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.lightGreyColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  CommonFunction.message('That’s all we have for you today'),
                                ],
                              ),
                            ),
                          ));
          }),
        )
      ],
    );
  }
}

class InvestmentBasketHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Seems you have no holding at the moment",
        style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class HoldingsTile extends StatelessWidget {
  final HoldingDatum order;

  HoldingsTile(this.order);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent, builder: (context) => HoldingDetails(order));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.tradingSymbol,
                    style: Utils.fonts(
                      size: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Observer(builder: (context) {
                    return Text(
                      order.model.close.toStringAsFixed(order.model.precision),
                      style: Utils.fonts(
                        size: 11.0,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.quantity,
                    style: Utils.fonts(
                      size: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Observer(builder: (context) {
                    return Text(
                      (double.parse(order.quantity) * order.model.close).toStringAsFixed(2),
                      style: Utils.fonts(
                        size: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
