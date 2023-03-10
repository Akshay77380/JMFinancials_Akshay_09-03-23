import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/research/research_cards.dart';
import 'package:markets/screens/search_bar_screen.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:markets/util/InAppSelections.dart';

class AllResearchScreen extends StatefulWidget {
  final TabController tabController;

  AllResearchScreen({this.tabController});

  @override
  State<AllResearchScreen> createState() => _AllResearchScreenState();
}

class _AllResearchScreenState extends State<AllResearchScreen> {
  bool searchVisible = true;
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(child: buidUI(context, theme));
  }

  Widget buidUI(
    BuildContext context,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            height: 32,
            decoration: BoxDecoration(
                color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.searchBackgroundLight : ThemeConstants.searchBackgroundDark.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: ThemeConstants.themeMode.value == ThemeMode.light ? 0.2 : 1.0, color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.black : Color(0xffD3D9DC))),
            child: TextField(
              readOnly: true,
              onTap: () {
                setState(() {
                  Dataconstants.searchResearch = true;
                });
                showSearch(
                  context: context,
                  delegate: SearchBarScreen(InAppSelection.marketWatchID),
                ).then((value) {
                  setState(() {
                    Dataconstants.searchResearch = false;
                  });
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                contentPadding: EdgeInsets.only(bottom: 19),
                hintStyle: TextStyle(
                  color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff4F4F4F) : Color(0xffD3D9DC),
                  fontSize: 12,
                ),
                border: InputBorder.none,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(ThemeConstants.themeMode.value == ThemeMode.light ? "assets/images/search_light.svg" : "assets/images/search_dark.svg"),
                ),
              ),
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                height: 1,
                color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.grey : Colors.white,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Row(
          //     // mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       // Visibility(
          //       //   visible: searchVisible,
          //       //   child: Row(
          //       //     children: [
          //       //       Text(
          //       //         "To stay updated, click here",
          //       //         style: TextStyle(fontSize: 13),
          //       //       ),
          //       //       SizedBox(
          //       //         width: 5,
          //       //       ),
          //       //       MaterialButton(
          //       //         height: 30,
          //       //         minWidth: 30,
          //       //         color: ThemeConstants.themeMode.value == ThemeMode.light
          //       //             ? theme.primaryColor
          //       //             : Colors.white,
          //       //         onPressed: () {
          //       //           _showfollowBottom(
          //       //               context,
          //       //               Dataconstants
          //       //                   .researchCallsModel.clickToGain.success.first);
          //       //         },
          //       //         child: Text(
          //       //           "Follow",
          //       //           style: TextStyle(color: theme.appBarTheme.color),
          //       //         ),
          //       //       ),
          //       //       SizedBox(
          //       //         width: 10,
          //       //       ),
          //       //     ],
          //       //   ),
          //       // ),
          //       // IconButton(
          //       //   icon: Icon(Icons.search),
          //       //   onPressed: () {
          //       //     setState(() {
          //       //       Dataconstants.searchResearch = true;
          //       //     });
          //       //     showSearch(
          //       //       context: context,
          //       //       delegate: SearchBarScreen(InAppSelection.marketWatchID),
          //       //     ).then((value) {
          //       //       setState(() {
          //       //         Dataconstants.searchResearch = false;
          //       //       });
          //       //     });
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),
          Divider(
            thickness: 1,
          ),
          // ----------------------------- Trading Card ------------------------------------------ //
          Column(
            children: [
              sectionHeadline('Trading', 1),
              Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ChipsFilterAll(
                    selected: Dataconstants.researchCallsModel.tradingSelectedChip,
                    term: "Trading",
                    filters: [
                      Filter(
                          label: "Intraday",
                          func: () {
                            Dataconstants.researchCallsModel.tradingSelectedChip = 0;
                          }),
                      Filter(
                          label: "Momentum",
                          func: () {
                            Dataconstants.researchCallsModel.tradingSelectedChip = 1;
                          }),
                    ],
                  )),
              Observer(builder: (BuildContext context) {
                return Dataconstants.researchCallsModel.fetchingData
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          if (Dataconstants.researchCallsModel.tradingSelectedChip == 0)
                            Dataconstants.researchCallsModel.intradayList.length > 0
                                ? TradingCard(
                                    data: Dataconstants.researchCallsModel.intradayList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                          else
                            Dataconstants.researchCallsModel.momentumList.length > 0
                                ? TradingCard(
                                    data: Dataconstants.researchCallsModel.momentumList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                        ],
                      );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          // ----------------------------- Investment Card ------------------------------------------ //
          Column(
            children: [
              sectionHeadline('Investment', 2),
              Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ChipsFilterAll(
                    selected: Dataconstants.researchCallsModel.investmentSelectedChip,
                    term: "Investment",
                    filters: [
                      Filter(
                          label: "Large Cap",
                          func: () {
                            Dataconstants.researchCallsModel.investmentSelectedChip = 0;
                          }),
                      Filter(
                          label: "Mid Cap",
                          func: () {
                            Dataconstants.researchCallsModel.investmentSelectedChip = 1;
                          }),
                      Filter(
                          label: "Small Cap",
                          func: () {
                            Dataconstants.researchCallsModel.investmentSelectedChip = 2;
                          }),
                    ],
                  )),
              Observer(builder: (BuildContext context) {
                if (Dataconstants.researchCallsModel.investmentSelectedChip == 0) {
                  return Dataconstants.researchCallsModel.fetchingData
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Dataconstants.researchCallsModel.largeCapList.length > 0
                                ? InvestmentCard(
                                    data: Dataconstants.researchCallsModel.largeCapList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                          ],
                        );
                } else if (Dataconstants.researchCallsModel.investmentSelectedChip == 1) {
                  return Dataconstants.researchCallsModel.fetchingData
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Dataconstants.researchCallsModel.midCapList.length > 0
                                ? InvestmentCard(
                                    data: Dataconstants.researchCallsModel.midCapList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                          ],
                        );
                } else
                  return Dataconstants.researchCallsModel.fetchingData
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Dataconstants.researchCallsModel.smallCapList.length > 0
                                ? InvestmentCard(
                                    data: Dataconstants.researchCallsModel.smallCapList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                          ],
                        );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          // ----------------------------- Future Options Card ------------------------------------------ //
          Column(
            children: [
              sectionHeadline('Future & Options', 3),
              Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ChipsFilterAll(
                    selected: Dataconstants.researchCallsModel.fnoSelectedChip,
                    term: "FNO",
                    filters: [
                      Filter(
                          label: "Futures",
                          func: () {
                            Dataconstants.researchCallsModel.fnoSelectedChip = 0;
                          }),
                      Filter(
                          label: "Options",
                          func: () {
                            Dataconstants.researchCallsModel.fnoSelectedChip = 1;
                          }),
                    ],
                  )),
              Observer(builder: (BuildContext context) {
                return Dataconstants.researchCallsModel.fetchingData
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          if (Dataconstants.researchCallsModel.fnoSelectedChip == 0)
                            Dataconstants.researchCallsModel.futureList.length > 0
                                ? FutureOptionsCard(
                                    data: Dataconstants.researchCallsModel.futureList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                          else
                            Dataconstants.researchCallsModel.optionList.length > 0
                                ? FutureOptionsCard(
                                    data: Dataconstants.researchCallsModel.optionList.first,
                                    isScripDetailResearch: false,
                                  )
                                : Text(
                                    "No Research Information Available",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                  )
                        ],
                      );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          // ----------------------------- Currency Card ------------------------------------------ //
          Column(
            children: [
              sectionHeadline('Currency', 4),
              Observer(builder: (BuildContext context) {
                return Dataconstants.researchCallsModel.fetchingData
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Dataconstants.researchCallsModel.currencyList.length > 0
                              ? CurrencyCard(
                                  data: Dataconstants.researchCallsModel.currencyList.first,
                                  isScripDetailResearch: false,
                                )
                              : Text(
                                  "No Research Information Available",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                ),
                        ],
                      );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          // ----------------------------- Commodity Card ------------------------------------------ //
          Column(
            children: [
              sectionHeadline('Commodity', 5),
              Observer(builder: (BuildContext context) {
                return Dataconstants.researchCallsModel.fetchingData
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Dataconstants.researchCallsModel.commodityList.length > 0
                              ? CommodityCard(
                                  data: Dataconstants.researchCallsModel.commodityList.first,
                                  isScripDetailResearch: false,
                                )
                              : Text(
                                  "No Research Information Available",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                ),
                        ],
                      );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget sectionHeadline(String sectionTitle, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Text(
            sectionTitle,
            style: TextStyle(fontSize: 15),
          ),
          Spacer(),
          TextButton(
            onPressed: () => widget.tabController.animateTo(index),
            child: Text("View All",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD75B1F),
                )),
          )
        ],
      ),
    );
  }
}

class Filter {
  ///
  /// Displayed label
  ///
  final String label;

  ///
  /// The displayed icon when selected
  ///
  final IconData icon;
  final Function func;

  const Filter({this.label, this.icon, this.func});
}

class ChipsFilterAll extends StatefulWidget {
  final List<Filter> filters;
  final int selected;
  final String term;

  ChipsFilterAll({Key key, this.filters, this.selected, this.term}) : super(key: key);

  @override
  _ChipsFilterAllState createState() => _ChipsFilterAllState();
}

class _ChipsFilterAllState extends State<ChipsFilterAll> {
  int selectedIndex;

  @override
  void initState() {
    if (widget.selected != null && widget.selected >= 0 && widget.selected < widget.filters.length) {
      this.selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: ListView.builder(
        itemBuilder: this.chipBuilder,
        itemCount: widget.filters.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget chipBuilder(context, currentIndex) {
    Filter filter = widget.filters[currentIndex];
    bool isActive = this.selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = currentIndex;
        });
        if (widget.term == 'Trading') Dataconstants.researchCallsModel.tradingSelectedChip = currentIndex;
        if (widget.term == 'Investment') Dataconstants.researchCallsModel.investmentSelectedChip = currentIndex;
        if (widget.term == 'FNO') Dataconstants.researchCallsModel.fnoSelectedChip = currentIndex;
      },
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Color(0xffF3FBFF) : Color(0xffF2F2F2),
          border: Border.all(color: isActive ? Color(0xff03A9F5) : Color(0xffBCBDC1)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              filter.label,
              style: TextStyle(
                color: isActive ? Color(0xff03A9F5) : Color(0xff3E5165),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
