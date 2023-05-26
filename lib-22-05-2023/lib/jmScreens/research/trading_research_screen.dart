import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/jmScreens/research/research_cards.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../util/CommonFunctions.dart';

class TradingResearchScreen extends StatefulWidget {
  @override
  State<TradingResearchScreen> createState() => _TradingResearchScreenState();
}

class _TradingResearchScreenState extends State<TradingResearchScreen> {
  bool searchVisible = true;
  bool closedClicked = false;
  int _sortByValue = 0;
  int selectedIndex;
  String dropDownValueFilter = 'All';
  String dropDownValueSort = 'Recent';
  TextEditingController searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  final List<String> filters = ['All', 'Nifty', 'Bank Nifty'];
  final List<String> sort = ['Recent', 'Profit Potential'];

  @override
  void initState() {
    // Dataconstants.itsClient.clickToGain();
    switch (Dataconstants.researchCallsModel.lastTradingSort) {
      case 0:
        _sortByValue = 1;
        break;
      case 1:
        _sortByValue = 2;
        break;
      case 2:
        _sortByValue = 1;
        break;
    }
    updateChip();
    super.initState();
  }

  void updateChip() {
    if (Dataconstants.researchCallsModel.tradingSelectedChip != null && Dataconstants.researchCallsModel.tradingSelectedChip >= 0 && Dataconstants.researchCallsModel.tradingSelectedChip < 2) {
      this.selectedIndex = Dataconstants.researchCallsModel.tradingSelectedChip;
    }
  }

  void tradingSort(String sort) {
    setState(
      () {
        dropDownValueSort = sort;
      },
    );
    switch (sort) {
      case 'Recent':
        Dataconstants.researchCallsModel.sortTradingByRecent();
        break;
      case 'Profit Potential':
        setState(() {
          _sortByValue = _sortByValue == 1 ? 2 : 1;
        });
        _sortByValue == 1 ? Dataconstants.researchCallsModel.sortTradingByProfitPotential(false) : Dataconstants.researchCallsModel.sortTradingByProfitPotential(true);
        break;
      default:
        break;
    }
  }

  void tradingFilter(String filter) {
    setState(
      () {
        dropDownValueFilter = filter;
        Dataconstants.lastTradingFilter = filter;
      },
    );
    Dataconstants.researchCallsModel.filterResearchTrading(filter);
  }

  Widget chipBuilder(context, currentIndex, label) {
    bool isActive = this.selectedIndex == currentIndex;

    return Observer(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = currentIndex;
            Dataconstants.researchCallsModel.tradingSelectedChip = currentIndex;
          });
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
                label,
                style: TextStyle(
                  color: isActive ? Color(0xff03A9F5) : Color(0xff3E5165),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: CommonFunction.getResearchClientStructuredCallEntries,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            if (searchVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filters:  ',
                          style: TextStyle(fontSize: 13, color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.dropdown : Colors.white),
                        ),
                        DropdownButton<String>(
                            items: filters.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox(),
                            hint: Text(
                              dropDownValueFilter,
                              style: TextStyle(fontSize: 14, color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.dropdown : Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            icon: Icon(
                              // Add this
                              Icons.arrow_drop_down, // Add this
                              color: Theme.of(context).textTheme.bodyText1.color, // Add this
                            ),
                            // onTap: () {},
                            onChanged: (val) {
                              tradingFilter(val);
                            }),
                        SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Sort: ',
                          style: TextStyle(fontSize: 13, color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.dropdown : Colors.white),
                        ),
                        DropdownButton<String>(
                            items: sort.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox(),
                            hint: Text(
                              dropDownValueSort,
                              style: TextStyle(fontSize: 14, color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.dropdown : Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            icon: Icon(
                              // Add this
                              Icons.arrow_drop_down, // Add this
                              color: Theme.of(context).textTheme.bodyText1.color, // Add this
                            ),
                            onChanged: (val) {
                              tradingSort(val);
                            }),
                        SizedBox(width: 8),
                      ],
                    ),
                    InkWell(
                      child: Icon(Icons.search),
                      onTap: () {
                        // //print("Search tapped");
                        setState(() {
                          if (!closedClicked)
                            searchVisible = false;
                          else
                            closedClicked = false;
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 32,
                  decoration: BoxDecoration(
                      color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.searchBackgroundLight : ThemeConstants.searchBackgroundDark.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: ThemeConstants.themeMode.value == ThemeMode.light ? 0.2 : 1.0, color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.black : Color(0xffD3D9DC))),
                  child: TextField(
                    controller: searchController,
                    focusNode: _searchFocus,
                    onChanged: (value) {
                      Dataconstants.researchCallsModel.searchResearchTrading(value);
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        searchVisible = true;
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
                      suffixIcon: searchVisible
                          ? null
                          : GestureDetector(
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff4F4F4F) : Color(0xffD3D9DC),
                              ),
                              onTap: () {
                                _searchFocus.unfocus();
                                _searchFocus.canRequestFocus = false;

                                setState(() {
                                  closedClicked = true;
                                  searchVisible = true;
                                  searchController.clear();
                                  // //print('searchVisible : $searchVisible');
                                });
                                Dataconstants.researchCallsModel.searchResearchTrading();

                                //Enable the text field's focus node request after some delay
                                Future.delayed(Duration(milliseconds: 100), () {
                                  _searchFocus.canRequestFocus = true;
                                });
                              },
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
              ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Observer(builder: (BuildContext context) {
              updateChip();
              return Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: 20,
                    child: ListView(
                      children: [
                        chipBuilder(context, 0, "Intraday"),
                        chipBuilder(context, 1, "Momentum"),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  ));
            }),
            SizedBox(
              height: 15,
            ),
            Observer(builder: (BuildContext context) {
              return Dataconstants.researchCallsModel.fetchingData
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    )
                  : Dataconstants.researchCallsModel.tradingSelectedChip == 0
                      ? Dataconstants.researchCallsModel.intradayList.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: Dataconstants.researchCallsModel.intradayList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 10),
                                        //   child: Html(
                                        //     data: Uri.decodeComponent("${Dataconstants.tradingIdeasIntraday}"),
                                        //   ),
                                        // ),
                                       // Text(Dataconstants.tradingIdeasIntraday),
                                        TradingCard(
                                          data: Dataconstants.researchCallsModel.intradayList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          : Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10),
                              //   child: Html(
                              //     data: Uri.decodeComponent("${Dataconstants.tradingIdeasIntraday}"),
                              //   ),
                              // ),
                              Text(
                                  "No Research Information Available",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                ),
                            ],
                          )
                      : Dataconstants.researchCallsModel.momentumList.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: Dataconstants.researchCallsModel.momentumList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 10),
                                        //   child: Html(
                                        //     data: Uri.decodeComponent("${Dataconstants.tradingIdeasMomentum}"),
                                        //   ),
                                        // ),
                                        TradingCard(
                                          data: Dataconstants.researchCallsModel.momentumList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          : Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10),
                              //   child: Html(
                              //     data: Uri.decodeComponent("${Dataconstants.tradingIdeasMomentum}"),
                              //   ),
                              // ),
                              Text(
                                  "No Research Information Available",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                                ),
                            ],
                          );
            }),
          ],
        ),
      ),
    );
  }
}
