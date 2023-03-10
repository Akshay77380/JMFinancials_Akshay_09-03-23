import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../controllers/holdingController.dart';
import '../../model/jmModel/holdings.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/smallChart.dart';

class HoldingsWatchList extends StatefulWidget {
  const HoldingsWatchList({Key key}) : super(key: key);

  @override
  State<HoldingsWatchList> createState() => _HoldingsWatchListState();
}

class _HoldingsWatchListState extends State<HoldingsWatchList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var selectedFilter = 0;

  // int setTheme = 0;
  int counter;

  var holdingsList = [];

  @override
  void initState() {
    super.initState();
    holdingsList = HoldingController.holdingList;
    // if (Dataconstants.indicesListener == null)
    //   Dataconstants.indicesListener = IndicesListener();
    // /* It was used to set data theme,this code is not required as it working fine */
    // // getThemeData();
    // /* Sending chart request to Bcast of all script available in the current watchlist */
    for (var i = 0; i < holdingsList.length; i++) {
      Dataconstants.itsClient.getChartData(
          timeInterval: 15, chartPeriod: 'I', model: holdingsList[i].model);
    }
    // /* Aim is to execute getSortFromPref ones (sorting function ones) when app is started,
    //    after ignore this function everytime user visite this screen */
    // /* oneTimeFiltersLoadWatchlist value satted to zero in dataconstant.*/
    // /* Checking wheather oneTimeFiltersLoadWatchlist have been incremented or not */
    // if (Dataconstants.oneTimeFiltersLoadWatchlist == 0) {
    //   getSortFromPref();
    //   /* Increment oneTimeFiltersLoadWatchlist so it does'nt enter above if condition when user
    //      visite this screen except first time */
    //   Dataconstants.oneTimeFiltersLoadWatchlist++;
    // }
  }

  // void getSortFromPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   /* CurrentSort will be an Map of arrray of string with string 0 or 1 */
  //   var currentSort;
  //   /* Checking wheather sortSelectionWatchList which is used for saving the sorting data
  //     is null or not */
  //   if (preferences.getString('sortSelectionWatchList') != null) {
  //     currentSort = preferences.getString('sortSelectionWatchList').split(',');
  //     if (currentSort.first == 'Name') {
  //       int _filterByName = int.parse(currentSort.last);
  //       /* 1 mean ascending order by name
  //          0 mean descending order by name */
  //       if (_filterByName == 1)
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyName(false);
  //       else
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyName(true);
  //     }
  //     if (currentSort.first == 'Price') {
  //       int _filterByPrice = int.parse(currentSort.last);
  //       /* 1 mean ascending order by price
  //          0 mean descending order by price */
  //       if (_filterByPrice == 1)
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyPrice(false);
  //       else
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyPrice(true);
  //     }
  //     if (currentSort.first == 'Percentage') {
  //       int _filterByPercent = int.parse(currentSort.last);
  //       /* 1 mean ascending order by Percent
  //          0 mean descending order by Percent */
  //       if (_filterByPercent == 1)
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyPercent(false);
  //       else
  //         Dataconstants.marketWatchListeners[widget.watchlistNo]
  //             .sortListbyPercent(true);
  //     }
  //   }
  // }

  sortBy(sortingBy, isAscending) {
    // Dataconstants.marketWatchListeners[widget.watchlistNo]
    //     .sortListbyPercent(true);
    if (sortingBy == "name") {
      holdingsList.sort((a, b) => isAscending
          ? a.model.name.toString().compareTo(b.model.name.toString())
          : b.model.name.toString().compareTo(a.model.name.toString()));
      setState(() {});
    } else if (sortingBy == "change") {
      holdingsList.sort((a, b) => isAscending
          ? a.model.percentChange
              .toString()
              .compareTo(b.model.percentChange.toString())
          : b.model.percentChange
              .toString()
              .compareTo(a.model.percentChange.toString()));
      setState(() {});
    } else if (sortingBy == "price") {
      holdingsList.sort((a, b) => isAscending
          ? a.model.close.toString().compareTo(b.model.close.toString())
          : b.model.close.toString().compareTo(a.model.close.toString()));
      setState(() {});
    }
  }

  var _filterByName = 0;
  var _filterByPercent = 0;
  var _filterByPrice = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    counter = 0;
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Observer(builder: (context) {
              return Column(
                children: [
                  if (Dataconstants.displayIndices)
                    Container(
                      // height: 66,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.grey[200],
                      ))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.indicesListener.indices1.name
                                        .toUpperCase(),
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w400,
                                        color: Utils.greyColor,
                                        size: 12.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices1
                                                    .close ==
                                                0.00
                                            ? Dataconstants.indicesListener
                                                .indices1.prevDayClose
                                                .toStringAsFixed(2)
                                            : Dataconstants
                                                .indicesListener.indices1.close
                                                .toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                    Observer(
                                        builder: (_) => Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Icon(
                                                Dataconstants.indicesListener
                                                            .indices1.close >
                                                        Dataconstants
                                                            .indicesListener
                                                            .indices1
                                                            .prevTickRate
                                                    ? Icons
                                                        .arrow_drop_up_rounded
                                                    : Icons
                                                        .arrow_drop_down_rounded,
                                                color: Dataconstants
                                                            .indicesListener
                                                            .indices1
                                                            .close >
                                                        Dataconstants
                                                            .indicesListener
                                                            .indices1
                                                            .prevTickRate
                                                    ? ThemeConstants.buyColor
                                                    : ThemeConstants.sellColor,
                                              ),
                                            ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices1
                                            .priceChangeText,
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants
                                                        .indicesListener
                                                        .indices1
                                                        .percentChange >=
                                                    0
                                                ? ThemeConstants.buyColor
                                                : ThemeConstants.sellColor),
                                      ),
                                    ),
                                    Observer(builder: (context) {
                                      return Text(
                                        Dataconstants.indicesListener.indices1
                                            .percentChangeText,
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants
                                                        .indicesListener
                                                        .indices1
                                                        .percentChange >=
                                                    0
                                                ? ThemeConstants.buyColor
                                                : ThemeConstants.sellColor),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.indicesListener.indices2.name
                                        .toUpperCase(),
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w400,
                                        color: Utils.greyColor,
                                        size: 12.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices2
                                                    .close ==
                                                0.00
                                            ? Dataconstants.indicesListener
                                                .indices2.prevDayClose
                                                .toStringAsFixed(2)
                                            : Dataconstants
                                                .indicesListener.indices2.close
                                                .toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                    Observer(
                                        builder: (_) => Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Icon(
                                                Dataconstants.indicesListener
                                                            .indices2.close >
                                                        Dataconstants
                                                            .indicesListener
                                                            .indices2
                                                            .prevTickRate
                                                    ? Icons
                                                        .arrow_drop_up_rounded
                                                    : Icons
                                                        .arrow_drop_down_rounded,
                                                color: Dataconstants
                                                            .indicesListener
                                                            .indices2
                                                            .close >
                                                        Dataconstants
                                                            .indicesListener
                                                            .indices2
                                                            .prevTickRate
                                                    ? ThemeConstants.buyColor
                                                    : ThemeConstants.sellColor,
                                              ),
                                            ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices2
                                            .priceChangeText,
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants
                                                        .indicesListener
                                                        .indices2
                                                        .percentChange >=
                                                    0
                                                ? ThemeConstants.buyColor
                                                : ThemeConstants.sellColor),
                                      ),
                                    ),
                                    Observer(builder: (context) {
                                      return Text(
                                        Dataconstants.indicesListener.indices2
                                            .percentChangeText,
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Dataconstants
                                                        .indicesListener
                                                        .indices2
                                                        .percentChange >=
                                                    0
                                                ? ThemeConstants.buyColor
                                                : ThemeConstants.sellColor),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: Dataconstants
                            .iqsClient.sendIqsReconnectWithCallback,
                        child: Observer(
                          builder: (context) {
                            if (HoldingController.HoldigsLength == 0)
                              return Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/appImages/noscript.svg'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "No Holdings Available!",
                                        style: Utils.fonts(
                                          size: 14.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // Text(
                                      //   "Your watchlist has been created.\nStart adding your favourite stocks to Watchlist",
                                      //   style: Utils.fonts(
                                      //       size: 15.0,
                                      //       fontWeight: FontWeight.w400,
                                      //       color: Utils.greyColor),
                                      //   // style: const TextStyle(
                                      //   //     color: Colors.grey, fontSize: 15),
                                      //   textAlign: TextAlign.center,
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            else
                              // if (Dataconstants.isHeatMap)
                            if (Dataconstants.heatMapArray[InAppSelection.marketWatchID])
                            {
                              return GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0.1,
                                shrinkWrap: true,
                                childAspectRatio: 14 / 9,
                                children: [
                                  for (var i = 0; i < holdingsList.length; i++)
                                    Card(
                                      color:
                                          holdingsList[i].model.percentChange <
                                                  -2
                                              ? Utils.darkRedColor
                                              : holdingsList[i]
                                                          .model
                                                          .percentChange <
                                                      0
                                                  ? Utils.lightRedColor
                                                  : holdingsList[i]
                                                              .model
                                                              .percentChange >
                                                          0
                                                      ? Utils.lightGreenColor
                                                      : Utils.darkGreenColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.green, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            HoldingController
                                                .holdingList[i].model.name
                                                .toUpperCase(),
                                            style: Utils.fonts(
                                                size: 14.0,
                                                color: Utils.whiteColor),
                                          ),
                                          Text(
                                              holdingsList[i].model.close == 0.00
                                                  ? holdingsList[i]
                                                      .model
                                                      .prevDayClose
                                                      .toStringAsFixed(
                                                          holdingsList[i].model.series == 'Curr'
                                                              ? 4
                                                              : 2)
                                                  : HoldingController
                                                      .holdingList[i]
                                                      .model
                                                      .close
                                                      .toStringAsFixed(
                                                          HoldingController
                                                                      .holdingList[
                                                                          i]
                                                                      .model
                                                                      .series ==
                                                                  'Curr'
                                                              ? 4
                                                              : 2),
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.whiteColor)),
                                          Text(
                                              holdingsList[i].model.close ==
                                                      0.00
                                                  ? "(0.00%)"
                                                  : holdingsList[i]
                                                      .model
                                                      .percentChangeText,
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.whiteColor))
                                        ],
                                      ),
                                    )
                                ],
                              );
                            } else
                              return GestureDetector(
                                // onLongPress: showEditWatchListScreen,
                                child: ListView.builder(
                                  itemCount: HoldingController.HoldigsLength,
                                  itemBuilder: (ctx, index) {
                                    if (index ==
                                        HoldingController.HoldigsLength) {
                                      return SizedBox(height: 50);
                                    } else
                                      return MarketWatchRow(
                                          holdingsList[index]);
                                  },
                                ),
                              );
                            /* Checking is data is available */
                            // if (HoldingController.HoldigsLength == 0)
                            //   return Center(
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         SvgPicture.asset(
                            //             'assets/appImages/noscript.svg'),
                            //         SizedBox(
                            //           height: 20,
                            //         ),
                            //         Text(
                            //           "No Scrips Added!",
                            //           style: Utils.fonts(
                            //             size: 14.0,
                            //           ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //         const SizedBox(
                            //           height: 20,
                            //         ),
                            //         Text(
                            //           "Your watchlist has been created.\nStart adding your favourite stocks to Watchlist",
                            //           style: Utils.fonts(
                            //               size: 15.0,
                            //               fontWeight: FontWeight.w400,
                            //               color: Utils.greyColor),
                            //           // style: const TextStyle(
                            //           //     color: Colors.grey, fontSize: 15),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //         SizedBox(
                            //           height: 30,
                            //         ),
                            //         ElevatedButton(
                            //             onPressed: () {
                            //               showSearch(
                            //                 context: context,
                            //                 delegate: SearchBarScreen(
                            //                     widget.watchlistNo),
                            //               );
                            //             },
                            //             child: Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                   vertical: 15.0, horizontal: 20.0),
                            //               child: Text(
                            //                 "Add Scrips",
                            //                 style: Utils.fonts(
                            //                     size: 14.0,
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.w400),
                            //               ),
                            //             ),
                            //             style: ButtonStyle(
                            //                 backgroundColor:
                            //                     MaterialStateProperty.all<Color>(
                            //                         Utils.primaryColor),
                            //                 shape: MaterialStateProperty.all<
                            //                         RoundedRectangleBorder>(
                            //                     RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       BorderRadius.circular(50.0),
                            //                 )))),
                            //       ],
                            //     ),
                            //   );
                            // else
                            //   return GestureDetector(
                            //     onLongPress: showEditWatchListScreen,
                            //     child: ListView.builder(
                            //       itemCount: Dataconstants
                            //           .marketWatchListeners[
                            //               widget.watchlistNo]
                            //           .watchList
                            //           .length,
                            //       itemBuilder: (ctx, index) =>
                            //           MarketWatchRow(index),
                            //     ),
                            //   );
                          },
                        )),
                  ),
                ],
              );
            }),
            Observer(
              builder: (_) => holdingsList.length != 0
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      if (_filterByName == 1) {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyName(false);
                                        setState(() {
                                          selectedFilter = 0;
                                          _filterByName = 0;
                                        });
                                        sortBy("name", true);
                                      } else {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyName(true);
                                        setState(() {
                                          selectedFilter = 0;
                                          _filterByName = 1;
                                        });
                                        sortBy("name", false);
                                      }
                                      preferences.setString(
                                          'sortSelectionWatchList',
                                          'Name,$_filterByName');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Utils.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            top: 8.0,
                                            bottom: 8.0,
                                            right: 8.0),
                                        child: Text("Name",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                color: selectedFilter == 0
                                                    ? Utils.primaryColor
                                                    : Utils.greyColor,
                                                fontWeight: selectedFilter == 0
                                                    ? FontWeight.w600
                                                    : FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Utils.greyColor.withOpacity(0.5),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      if (_filterByPercent == 1) {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyPercent(false);
                                        setState(() {
                                          selectedFilter = 1;
                                          _filterByPercent = 0;
                                        });
                                        sortBy("change", false);
                                      } else {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyPercent(true);
                                        setState(() {
                                          selectedFilter = 1;
                                          _filterByPercent = 1;
                                        });
                                        sortBy("change", true);
                                      }
                                      preferences.setString(
                                          'sortSelectionWatchList',
                                          'Percentage,$_filterByPercent');
                                    },
                                    child: Container(
                                      color:
                                          Utils.primaryColor.withOpacity(0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "%Change ",
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: selectedFilter == 1
                                                          ? Utils.primaryColor
                                                          : Utils.greyColor,
                                                      fontWeight:
                                                          selectedFilter == 1
                                                              ? FontWeight.w600
                                                              : FontWeight
                                                                  .w500)),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  size: 14,
                                                  color: selectedFilter == 1
                                                      ? Utils.primaryColor
                                                      : Utils.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Utils.greyColor.withOpacity(0.5),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      if (_filterByPrice == 1) {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyPrice(false);
                                        setState(() {
                                          selectedFilter = 2;
                                          _filterByPrice = 0;
                                        });
                                        sortBy("price", false);
                                      } else {
                                        // Dataconstants.marketWatchListeners[
                                        //         widget.watchlistNo]
                                        //     .sortListbyPrice(true);
                                        setState(() {
                                          selectedFilter = 2;
                                          _filterByPrice = 1;
                                        });
                                        sortBy("price", true);
                                      }
                                      preferences.setString(
                                          'sortSelectionWatchList',
                                          'Percentage,$_filterByPrice');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Utils.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0,
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 8.0),
                                        child: Text("Price",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                color: selectedFilter == 2
                                                    ? Utils.primaryColor
                                                    : Utils.greyColor,
                                                fontWeight: selectedFilter == 2
                                                    ? FontWeight.w600
                                                    : FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          // InkWell(
                          //   // onTap: () {
                          //   //   Dataconstants.scriptCount = 0;
                          //   //   showSearch(
                          //   //     context: context,
                          //   //     delegate: SearchBarScreen(widget.watchlistNo),
                          //   //   );
                          //   // },
                          //   child: SvgPicture.asset(
                          //     'assets/appImages/add.svg',
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

// void showEditWatchListScreen() {
//   HapticFeedback.vibrate();
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) => WatchListEditScreen(widget.watchlistNo),
//     ),
//   );
// }
}

class MarketWatchRow extends StatelessWidget {
  final HoldingDatum order;

  MarketWatchRow(this.order);

  @override
  Widget build(BuildContext context) {
    /* kept this code if required in future */
    // bool containsNews = Dataconstants.todayNews.todayNewsInScrip(Dataconstants
    //     .marketWatchListeners[widget.watchlistNo]
    //     .watchList[index]
    //     .exchCode);
    var desc;
    var finalDesc;
    var whichOption;
    if (order.model.exchCategory == ExchCategory.nseFuture) {
      desc = order.model.desc.toString().toUpperCase().split(" ");
      finalDesc = desc[1] + " " + desc[2];
    } else if (order.model.exchCategory == ExchCategory.nseOptions) {
      desc = order.model.desc.toString().toUpperCase().split(" ");
      whichOption = desc[4];
      finalDesc =
          desc[1] + " " + desc[2] + " " + desc[5].toString().split(".").first;
    } else {
      finalDesc = order.model.exchName.toString().toUpperCase();
    }

    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // showModalBottomSheet(
        //   context: context,
        //   isScrollControlled: true,
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(25.0),
        //       topRight: Radius.circular(25.0),
        //     ),
        //   ),
        //   clipBehavior: Clip.antiAliasWithSaveLayer,
        //   builder: (builder) {
        //     return DraggableScrollableSheet(
        //       /* This initialChildSize is working, do not change it */
        //       /* Coding sigma rule no.1: Dont touch the code if its working */
        //       initialChildSize: MediaQuery.of(context).size.height * 0.0009,
        //       minChildSize: 0.50,
        //       maxChildSize: 1,
        //       expand: false,
        //       builder:
        //           (BuildContext context, ScrollController scrollController) {
        //         return ScripDetailsScreen(
        //           model: Dataconstants
        //               .marketWatchListeners[watchlistNo].watchList[index],
        //           scrollController: scrollController,
        //         );
        //       },
        //     );
        //   },
        // );
        /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ScripDetailsScreen(
        //       model: Dataconstants
        //           .marketWatchListeners[widget.watchlistNo]
        //           .watchList[index],
        //     ),
        //   ),
        // );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 15,
              top: 15,
              bottom: 15,
              right: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Displaying the Script details */
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* Displaying the Script name */
                      Text(order.model.name.toUpperCase(),
                          style: Utils.fonts(
                              size: 14.0, fontWeight: FontWeight.w600)
                          // style: TextStyle(
                          //   fontSize: 15,
                          // ),
                          ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            /* Displaying the Script exchange Name */
                            Text(finalDesc,
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Utils.greyColor)
                                // style: const TextStyle(
                                //     fontSize: 13, color: Colors.grey),
                                ),
                            if (order.model.exchCategory ==
                                ExchCategory.nseFuture)
                              Text(
                                " FUT",
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Utils.primaryColor),
                              ),
                            if (whichOption == "PE")
                              Text(
                                " PE",
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Utils.mediumRedColor),
                              ),
                            if (whichOption == "CE")
                              Text(
                                " CE",
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Utils.mediumGreenColor),
                              ),
                            const SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset(
                              "assets/appImages/bag.svg",
                              height: 12,
                              width: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              order.quantity,
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor),
                            ),
                            /* Displaying the Script Description */
                            // Text(
                            //     Dataconstants
                            //         .marketWatchListeners[
                            //             widget.watchlistNo]
                            //         .watchList[index]
                            //         .marketWatchDesc
                            //         .toUpperCase(),
                            //     style: Utils.fonts(
                            //       size: 12.0,
                            //       fontWeight: FontWeight.w500,
                            //       color: Utils.greyColor,
                            //     )
                            //     // style: const TextStyle(
                            //     //   fontSize: 13,
                            //     //   color: Colors.grey,
                            //     // ),
                            //     ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /* Displaying the Script chart */
                // if (Dataconstants.sparkLine)
                if(Dataconstants.sparkLineArray[InAppSelection.marketWatchID])
                Expanded(
                  flex: 1,
                  child: Observer(
                    /* Checking if we got the chart data of the current script by checking its array length,
                     if not then shrink. The UI will throw erreo */
                    builder: (context) =>
                        order.model.chartMinClose[15].length > 0
                            ? SmallSimpleLineChart(
                                seriesList: order.model.dataPoint[15],
                                prevClose: order.model.prevDayClose,
                                name: order.model.name,
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
                /* Deiplaying the feeds of the script */
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /* Displaying the feed of the script */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Observer(
                            builder: (_) => Row(
                              children: [
                                Text(
                                    /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                                    order.model.close == 0.00
                                        ? order.model.prevDayClose
                                            .toStringAsFixed(
                                                order.model.series == 'Curr'
                                                    ? 4
                                                    : 2)
                                        : order.model.close.toStringAsFixed(
                                            order.model.series == 'Curr'
                                                ? 4
                                                : 2),
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Utils.blackColor,
                                    )
                                    // style:
                                    //
                                    // const TextStyle(
                                    //     fontSize: 16,
                                    //     color: Colors.white,
                                    //     fontWeight: FontWeight.w700),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      /* Displaying the price change and percentage change of the script */
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /* Displaying the price change of the script */
                          Observer(
                            builder: (_) => Text(
                                /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                order.model.close == 0.00
                                    ? "0.00"
                                    : order.model.priceChangeText,
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: order.model.priceChange > 0
                                      ? ThemeConstants.buyColor
                                      : order.model.priceChange < 0
                                          ? ThemeConstants.sellColor
                                          : theme.textTheme.bodyText1.color,
                                )

                                // style: TextStyle(
                                //   color: Dataconstants
                                //               .marketWatchListeners[
                                //                   widget.watchlistNo]
                                //               .watchList[index]
                                //               .priceChange >
                                //           0
                                //       ? ThemeConstants.buyColor
                                //       : Dataconstants
                                //                   .marketWatchListeners[
                                //                       InAppSelection
                                //                           .marketWatchID]
                                //                   .watchList[index]
                                //                   .priceChange <
                                //               0
                                //           ? ThemeConstants.sellColor
                                //           : theme.textTheme.bodyText1.color,
                                // ),
                                ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          /* Displaying the percentage change of the script */
                          Observer(
                            builder: (_) => Text(
                                /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                order.model.close == 0.00
                                    ? "(0.00%)"
                                    : order.model.percentChangeText,
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: order.model.percentChange > 0
                                      ? ThemeConstants.buyColor
                                      : order.model.percentChange < 0
                                          ? ThemeConstants.sellColor
                                          : theme.textTheme.bodyText1.color,
                                )
                                // style: TextStyle(
                                //   color: Dataconstants
                                //               .marketWatchListeners[
                                //                   widget.watchlistNo]
                                //               .watchList[index]
                                //               .percentChange >
                                //           0
                                //       ? ThemeConstants.buyColor
                                //       : Dataconstants
                                //                   .marketWatchListeners[
                                //                       InAppSelection
                                //                           .marketWatchID]
                                //                   .watchList[index]
                                //                   .percentChange <
                                //               0
                                //           ? ThemeConstants.sellColor
                                //           : theme.textTheme.bodyText1.color,
                                // ),
                                ),
                          ),
                          Observer(
                              builder: (_) => Container(
                                    margin: EdgeInsets.zero,
                                    padding: EdgeInsets.zero,
                                    child: IconButton(
                                      constraints: BoxConstraints(),
                                      padding: const EdgeInsets.all(0),
                                      icon: Icon(order.model.close >
                                              order.model.prevTickRate
                                          ? Icons.arrow_drop_up_rounded
                                          : Icons.arrow_drop_down_rounded),
                                      color: order.model.close >
                                              order.model.prevTickRate
                                          ? ThemeConstants.buyColor
                                          : ThemeConstants.sellColor,
                                    ),
                                  ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
