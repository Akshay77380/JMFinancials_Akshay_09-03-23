import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/watchlist_database.dart';
import '../screens/search_bar_screen.dart';
import '../util/InAppSelections.dart';
import '../util/Utils.dart';
import '../widget/smallChart.dart';
import 'package:path/path.dart';

import '../widget/decimal_text.dart';

import '../model/scrip_info_model.dart';
import '../screens/scrip_details_screen.dart';
import '../style/theme.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import '../widget/watchlist_picker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class newPredefinedGroupPicker extends StatefulWidget {
  var id;

  newPredefinedGroupPicker(this.id);

  @override
  State<newPredefinedGroupPicker> createState() => _newPredefinedGroupPickerState();
}

class _newPredefinedGroupPickerState extends State<newPredefinedGroupPicker> {
  Map<int, String> groupTypes = {
    0: 'P',
    1: 'I',
    2: 'B',
    3: 'Q',
    4: 'J',
    5: 'C',
  };
  TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 0.7 * height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              color: theme.accentColor,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search Name',
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  labelStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        ),
                      ),
                      child: Text('NSE',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                          )
                          // style: TextStyle(
                          //   color: DataConstants.predefinedMarketWatchListener
                          //               .selectedFilter ==
                          //           0
                          //       ? theme.primaryColor
                          //       : theme.textTheme.bodyText1.color,
                          // ),
                          ),
                      // borderSide: BorderSide(
                      //   color: DataConstants.predefinedMarketWatchListener
                      //               .selectedFilter ==
                      //           0
                      //       ? theme.primaryColor
                      //       : theme.textTheme.bodyText1.color,
                      // ),
                      onPressed: () {
                        if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 0) {
                          setState(() {
                            Dataconstants.predefinedMarketWatchListener.selectedFilter = 0;
                          });
                        }
                      }),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        ),
                      ),
                      child: Text('NSE INDUSTRY',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                          )),
                      // borderSide: BorderSide(
                      //   color: DataConstants.predefinedMarketWatchListener
                      //               .selectedFilter ==
                      //           1
                      //       ? theme.primaryColor
                      //       : theme.textTheme.bodyText1.color,
                      // ),
                      onPressed: () {
                        if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 1) {
                          setState(() {
                            Dataconstants.predefinedMarketWatchListener.selectedFilter = 1;
                          });
                        }
                      }),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 2 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    child: Text('NSE BUSINESS',
                        style: Utils.fonts(
                          size: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 2 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        )),
                    // borderSide: BorderSide(
                    //   color: DataConstants.predefinedMarketWatchListener
                    //               .selectedFilter ==
                    //           2
                    //       ? theme.primaryColor
                    //       : theme.textTheme.bodyText1.color,
                    // ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 2) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 2;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 3 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        ),
                      ),
                      child: Text('BSE',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 3 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                          )),
                      // borderSide: BorderSide(
                      //   color: DataConstants.predefinedMarketWatchListener
                      //               .selectedFilter ==
                      //           3
                      //       ? theme.primaryColor
                      //       : theme.textTheme.bodyText1.color,
                      // ),
                      onPressed: () {
                        if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 3) {
                          setState(() {
                            Dataconstants.predefinedMarketWatchListener.selectedFilter = 3;
                          });
                        }
                      }),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 4 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        ),
                      ),
                      child: Text('BSE INDUSTRY',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 4 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                          )),
                      // borderSide: BorderSide(
                      //   color: DataConstants.predefinedMarketWatchListener
                      //               .selectedFilter ==
                      //           4
                      //       ? theme.primaryColor
                      //       : theme.textTheme.bodyText1.color,
                      // ),
                      onPressed: () {
                        if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 4) {
                          setState(() {
                            Dataconstants.predefinedMarketWatchListener.selectedFilter = 4;
                          });
                        }
                      }),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 5 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                        ),
                      ),
                      child: Text('BSE BUSINESS',
                          style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 5 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                          )),
                      // borderSide: BorderSide(
                      //   color: DataConstants.predefinedMarketWatchListener
                      //               .selectedFilter ==
                      //           5
                      //       ? theme.primaryColor
                      //       : theme.textTheme.bodyText1.color,
                      // ),
                      onPressed: () {
                        if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 5) {
                          setState(() {
                            Dataconstants.predefinedMarketWatchListener.selectedFilter = 5;
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                var groups = CommonFunction.getGroup(
                  groupTypes[Dataconstants.predefinedMarketWatchListener.selectedFilter],
                  searchController.text.toLowerCase(),
                );
                return ListView.separated(
                    itemCount: groups.length,
                    separatorBuilder: (_, index) {
                      return const Divider(
                        height: 1,
                      );
                    },
                    itemBuilder: (_, index) {
                      if (groups[index].grName.trim() == "NIfty 500") {
                        return SizedBox.shrink();
                      } else
                        return ListTile(
                          onTap: () async {
                            for (var i = 0; i < InAppSelection.tabsView.length; i++) {
                              if (InAppSelection.tabsView[i][0] == groups[index].grName) {
                                CommonFunction.showBasicToast("Cannot Add Same Predefined watchList");
                                return;
                              }
                            }

                            Dataconstants.preDefinedWatchListeners[widget.id].addToPredefinedWatchListBulk(
                              values: CommonFunction.getMembers(
                                groups[index].grType,
                                groups[index].grCode,
                              ),
                              grType: groups[index].grType,
                              grCode: groups[index].grCode,
                              grName: groups[index].grName,
                            );

                            InAppSelection.tabsView[widget.id] = [groups[index].grName.toString(), "predefined", widget.id.toString()];

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var finalTabs = json.encode(InAppSelection.tabsView);
                            prefs.setString("tabsView", finalTabs);
                            Dataconstants.isWatchListChanged = true;
                            WatchlistDatabase.getAllWatchList();
                            Dataconstants.isTabChanged = true;

                            // DataConstants.predefinedMarketWatchListener
                            //     .addToPredefinedWatchListBulk(
                            //   values: CommonFunction.getMembers(
                            //     groups[index].grType,
                            //     groups[index].grCode,
                            //   ),
                            //   grType: groups[index].grType,
                            //   grCode: groups[index].grCode,
                            //   grName: groups[index].grName,
                            // );
                            Navigator.of(context).pop();
                          },
                          title: Text(groups[index].grName.trim(), style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600)),
                        );
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class PredefinedMarketwatch extends StatefulWidget {
  @override
  _PredefinedMarketwatchState createState() => _PredefinedMarketwatchState();
}

class _PredefinedMarketwatchState extends State<PredefinedMarketwatch> {
  int selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   // Dataconstants.iqsClient.sendBulkLTPRequest(
  //   //     Dataconstants.predefinedMarketWatchListener.watchList, true);
  // }

  @override
  void dispose() {
    Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.predefinedMarketWatchListener.watchList, false);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.predefinedMarketWatchListener.watchList, true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var toCallChart = await CommonFunction.getPredefinedChartTime();
      if (toCallChart) {
        Dataconstants.predefinedMarketWatchListener.watchList.forEach((model) {
          Dataconstants.itsClient.getChartData(timeInterval: 15, chartPeriod: 'I', model: model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 24,
              color: theme.appBarTheme.color,
            ),
            Card(
              color: theme.accentColor,
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 4,
              ),
              elevation: 5,
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => PredefinedGroupPicker(),
                        );
                      },
                      child: Row(
                        children: [
                          Observer(
                            builder: (ctx) => Text(
                              Dataconstants.predefinedMarketWatchListener.watchListName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // IconButton(
                        //   icon: Icon(Icons.sort_rounded),
                        //   onPressed: () {
                        //     showModalBottomSheet<void>(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return PredefinedWatchListFilter();
                        //       },
                        //     );
                        //   },
                        // ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SearchBarScreen(InAppSelection.marketWatchID),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        // Expanded(
        //   child: RefreshIndicator(
        //     color: theme.primaryColor,
        //     onRefresh: () => Dataconstants.iqsClient
        //         .sendIqsReconnectWithCallback("PredefinedWatchList"),
        //     child: Observer(
        //       builder: (ctx) => ListView(
        //         // itemCount: Dataconstants
        //         //     .predefinedMarketWatchListener.watchList.length,
        //           children: List.generate(
        //               Dataconstants.predefinedMarketWatchListener.watchList
        //                   .length, (index) {
        //             return PredefinedMarketWatchRow(
        //               key: ObjectKey(Dataconstants
        //                   .predefinedMarketWatchListener.watchList[index]),
        //               index: index,
        //             );
        //           })
        //         // children: (ctx, index) => PredefinedMarketWatchRow(
        //         //   key: ObjectKey(Dataconstants
        //         //       .predefinedMarketWatchListener.watchList[index]),
        //         //   index: index,
        //         // ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class PredefinedMarketWatchRow extends StatefulWidget {
  final int index;

  PredefinedMarketWatchRow({Key key, @required this.index}) : super(key: key);

  @override
  _PredefinedMarketWatchRowState createState() => _PredefinedMarketWatchRowState();
}

class _PredefinedMarketWatchRowState extends State<PredefinedMarketWatchRow> {
  bool added;
  List<int> pos = [-1, -1, -1, -1];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) =>
          element.exch == Dataconstants.predefinedMarketWatchListener.watchList[widget.index].exch && element.exchCode == Dataconstants.predefinedMarketWatchListener.watchList[widget.index].exchCode);
    }
    added = pos.any((element) => element > -1);
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              top: 15,
              bottom: 15,
              right: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Dataconstants.predefinedMarketWatchListener.watchList[widget.index].marketWatchName,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${Dataconstants.predefinedMarketWatchListener.watchList[widget.index].exchName.toUpperCase()} ${Dataconstants.predefinedMarketWatchListener.watchList[widget.index].marketWatchDesc.toUpperCase()}',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Observer(
                          builder: (context) => Dataconstants.predefinedMarketWatchListener.watchList[widget.index].chartMinClose[15].length > 0
                              ? SmallSimpleLineChart(
                                  seriesList: Dataconstants.predefinedMarketWatchListener.watchList[widget.index].dataPoint[15],
                                  prevClose: Dataconstants.predefinedMarketWatchListener.watchList[widget.index].prevDayClose,
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Observer(
                              builder: (_) => Container(
                                width: 90,
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.00 ||
                                          Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.0
                                      ? Colors.grey
                                      : Dataconstants.predefinedMarketWatchListener.watchList[widget.index].priceChange > 0
                                          ? ThemeConstants.buyColor
                                          : Dataconstants.predefinedMarketWatchListener.watchList[widget.index].priceChange < 0
                                              ? ThemeConstants.sellColor
                                              : Colors.grey,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                padding: EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                  left: 5,
                                  right: 5,
                                ),
                                child: DecimalText(
                                  Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.00 || Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.0
                                      ? Dataconstants.predefinedMarketWatchListener.watchList[widget.index].prevDayClose.toStringAsFixed(2)
                                      : Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.00 ||
                                            Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.0
                                        ? "0.00"
                                        : Dataconstants.predefinedMarketWatchListener.watchList[widget.index].priceChangeText,
                                  ),
                                ),
                                // SizedBox(width: 5),
                                Observer(
                                  builder: (_) => Text(
                                    Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.00 ||
                                            Dataconstants.predefinedMarketWatchListener.watchList[widget.index].close == 0.0
                                        ? "(0.00%)"
                                        : Dataconstants.predefinedMarketWatchListener.watchList[widget.index].percentChangeText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                IconButton(
                  icon: Icon(
                    added ? Icons.check : Icons.add,
                    size: 15,
                  ),
                  onPressed: () async {
                    if (!added) {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) => WatchListPickerCard(Dataconstants.predefinedMarketWatchListener.watchList[widget.index]),
                      );
                      if (result != null && result['added'] == 1) {
                        setState(() {
                          added = true;
                        });
                        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) =>
                            element.exch == Dataconstants.predefinedMarketWatchListener.watchList[widget.index].exch &&
                            element.exchCode == Dataconstants.predefinedMarketWatchListener.watchList[widget.index].exchCode);
                        CommonFunction.showSnackBar(
                          context: context,
                          text: 'Added ${Dataconstants.predefinedMarketWatchListener.watchList[widget.index].name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
                          duration: const Duration(milliseconds: 1500),
                        );
                      } else if (result != null && result['added'] == 2) {
                        CommonFunction.showSnackBar(
                          context: context,
                          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
                          color: Colors.red,
                          duration: const Duration(milliseconds: 1500),
                        );
                      }
                    } else {
                      setState(() {
                        added = false;
                      });
                      for (int i = 0; i < pos.length; i++) {
                        if (pos[i] > -1) {
                          CommonFunction.showSnackBar(
                            context: context,
                            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
                            color: Colors.black,
                            duration: const Duration(milliseconds: 1500),
                          );
                          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
                        }
                      }
                      pos = [-1, -1, -1, -1];
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}

class PredefinedGroupPicker extends StatefulWidget {
  @override
  _PredefinedGroupPickerState createState() => _PredefinedGroupPickerState();
}

class _PredefinedGroupPickerState extends State<PredefinedGroupPicker> {
  Map<int, String> groupTypes = {
    0: 'P',
    1: 'I',
    2: 'B',
    3: 'Q',
    4: 'J',
    5: 'C',
  };
  TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 0.7 * height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              color: theme.accentColor,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search Name',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    child: Text(
                      'NSE',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 0) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 0;
                        });
                      }
                    }),
                OutlinedButton(
                    child: Text(
                      'NSE INDUSTRY',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
    color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
    ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 1) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 1;
                        });
                      }
                    }),
                OutlinedButton(
                    child: Text(
                      'NSE BUSINESS',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 2 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 2 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 2) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 2;
                        });
                      }
                    }),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    child: Text(
                      'BSE',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 3 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 3 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 3) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 3;
                        });
                      }
                    }),
                OutlinedButton(
                    child: Text(
                      'BSE INDUSTRY',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 4 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
    color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 4 ? theme.primaryColor : theme.textTheme.bodyText1.color,
    ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 4) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 4;
                        });
                      }
                    }),
                OutlinedButton(
                    child: Text(
                      'BSE BUSINESS',
                      style: TextStyle(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 5 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Dataconstants.predefinedMarketWatchListener.selectedFilter == 5 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                      ),
                    ),
                    onPressed: () {
                      if (Dataconstants.predefinedMarketWatchListener.selectedFilter != 5) {
                        setState(() {
                          Dataconstants.predefinedMarketWatchListener.selectedFilter = 5;
                        });
                      }
                    }),
              ],
            ),
          ),
          SizedBox(height: 5),
          // Expanded(
          //   child: Builder(
          //     builder: (BuildContext context) {
          //       var groups = CommonFunction.getGroup(
          //         groupTypes[Dataconstants
          //             .predefinedMarketWatchListener.selectedFilter],
          //         searchController.text.toLowerCase(),
          //       );
          //       return ListView.separated(
          //           itemCount: groups.length,
          //           separatorBuilder: (_, index) {
          //             return Divider(
          //               height: 1,
          //             );
          //           },
          //           itemBuilder: (_, index) {
          //             return ListTile(
          //               onTap: () async {
          //                 await Dataconstants.predefinedMarketWatchListener
          //                     .addToPredefinedWatchListBulk(
          //                   values: CommonFunction.getMembers(
          //                     groups[index].grType,
          //                     groups[index].grCode,
          //                   ),
          //                   grType: groups[index].grType,
          //                   grCode: groups[index].grCode,
          //                   grName: groups[index].grName,
          //                 );
          //                 CommonFunction.setPredefinedChartTime(DateTime.now());
          //                 Dataconstants.predefinedMarketWatchListener.watchList
          //                     .forEach((model) {
          //                   Dataconstants.itsClient.getChartData(
          //                     timeInterval: 15,
          //                     chartPeriod: 'I',
          //                     model: model,
          //                   );
          //                 });
          //                 Navigator.of(context).pop();
          //               },
          //               title: Text(groups[index].grName.trim()),
          //             );
          //           });
          //     },
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class GroupData {
  final String grCode;
  final String grName;
  final String grType;

  GroupData(this.grType, this.grCode, this.grName);
}

class MemberData {
  final String exch;
  final String exchType;
  final int exchCode;
  final String grType;
  final String grCode;
  final String name;

  MemberData({
    @required this.exch,
    @required this.exchCode,
    @required this.exchType,
    @required this.grType,
    @required this.grCode,
    @required this.name,
  });
}
