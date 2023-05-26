import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/jmScreens/research/research_cards.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../util/CommonFunctions.dart';

class CommodityResearchScreen extends StatefulWidget {
  @override
  State<CommodityResearchScreen> createState() => _CommodityResearchScreenState();
}

class _CommodityResearchScreenState extends State<CommodityResearchScreen> {
  bool searchVisible = true;
  bool closedClicked = false;
  int _sortByValue = 0;
  String dropDownValueFilter = 'All';
  String dropDownValueSort = 'Recent';
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  final List<String> filters = [
    'All',
    'Watchlist',
    // 'Portfolio',
    // 'Nifty',
    // 'Bank Nifty'
  ];
  final List<String> sort = ['Recent', 'Profit Potential'];

  @override
  void initState() {
    // Dataconstants.itsClient.clickToGain();
    switch (Dataconstants.researchCallsModel.lastCommoditySort) {
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
    super.initState();
  }

  void commoditySort(String sort) {
    setState(
      () {
        dropDownValueSort = sort;
      },
    );
    switch (sort) {
      case 'Recent':
        Dataconstants.researchCallsModel.sortCommodityByRecent();
        break;
      case 'Profit Potential':
        setState(() {
          _sortByValue = _sortByValue == 1 ? 2 : 1;
        });
        _sortByValue == 1 ? Dataconstants.researchCallsModel.sortCommodityByProfitPotential(false) : Dataconstants.researchCallsModel.sortCommodityByProfitPotential(true);
        break;
      default:
        break;
    }
  }

  void commodityFilter(String filter) {
    setState(
      () {
        dropDownValueFilter = filter;
        Dataconstants.lastCommodityFilter = filter;
      },
    );
    Dataconstants.researchCallsModel.filterResearchCommodity(filter);
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
            if (searchVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Filters: ',
                          style: TextStyle(fontSize: 13, color: ThemeConstants.themeMode.value == ThemeMode.light ? ThemeConstants.dropdown : Colors.white),
                        ),
                        DropdownButton<String>(
                            items: filters.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: 14)),
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
                            onChanged: (val) {
                              commodityFilter(val);
                            }),
                        SizedBox(
                          width: 10,
                        ),
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
                                child: Text(value, style: TextStyle(fontSize: 14)),
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
                              commoditySort(val);
                            }),
                        SizedBox(
                          width: 10,
                        ),
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
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: (value) {
                      Dataconstants.researchCallsModel.searchResearchCommodity(value);
                    },
                    onTap: () {
                      setState(() {
                        if (!closedClicked)
                          searchVisible = false;
                        else
                          closedClicked = false;
                      });
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        // _searchFocus.unfocus();
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
                                  searchVisible = true;
                                  closedClicked = true;
                                  _searchController.clear();
                                  // //print('searchVisible : $searchVisible');
                                });
                                Dataconstants.researchCallsModel.searchResearchCommodity();

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
            SizedBox(
              height: 5,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
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
                  : Dataconstants.researchCallsModel.commodityList.length > 0
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: Dataconstants.researchCallsModel.commodityList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    CommodityCard(
                                      data: Dataconstants.researchCallsModel.commodityList[index],
                                      isScripDetailResearch: false,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }),
                        )
                      : Text(
                          "No Research Information Available",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                        );
            }),
          ],
        ),
      ),
    );
  }
}
