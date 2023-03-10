import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../jmScreens/ScriptInfo/ScriptInfo.dart';
import '../jmScreens/equitySIP/equity_sip_order_screen.dart';
import '../jmScreens/orders/OrderPlacement/derivative_order_screen.dart';
import '../jmScreens/orders/OrderPlacement/equity_order_screen.dart';
import '../jmScreens/research/research_search.dart';
import '../model/scripStaticModel.dart';
import '../model/scrip_info_model.dart';
import '../screens/scrip_details_screen.dart';
import '../style/theme.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import '../util/InAppSelections.dart';
import '../util/Utils.dart';
import '../widget/custom_tab_bar.dart';

class SearchArea extends StatefulWidget {
  final int id;

  final List<ScripStaticModel> dataAll, dataCash, dataFO, dataCurrency, dataCommodity;
  final Function searchFunction;
  final String query;

  SearchArea({
    @required this.dataAll,
    @required this.dataCash,
    @required this.dataFO,
    @required this.dataCurrency,
    @required this.dataCommodity,
    @required this.query,
    @required this.id,
    @required this.searchFunction,
  });

  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool addedToRecentSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: Dataconstants.isFromBasketOrder
            ? 0
            : Dataconstants.isFromAlgo
                ? 3
                : 5);
    _tabController.index = InAppSelection.searchTabIndex;
  }

  void addToRecentSearch(bool isRecentlyViewed, [ScripInfoModel model]) {
    if (!addedToRecentSearch && widget.query.isNotEmpty) {
      var index = Dataconstants.recentSearchQueries.indexOf(widget.query);
      if (Dataconstants.recentSearchQueries.length >= 5) {
        if (index >= 0)
          Dataconstants.recentSearchQueries.removeAt(index);
        else
          Dataconstants.recentSearchQueries.removeLast();
        Dataconstants.recentSearchQueries.insert(0, widget.query);
      } else if (index < 0) Dataconstants.recentSearchQueries.insert(0, widget.query);
    }
    if (!isRecentlyViewed) return;
    var index = Dataconstants.recentViewedScrips.indexWhere((element) => element.exch == model.exch && element.exchCode == model.exchCode);
    if (Dataconstants.recentViewedScrips.length >= 5) {
      if (index >= 0)
        Dataconstants.recentViewedScrips.removeAt(index);
      else
        Dataconstants.recentViewedScrips.removeLast();
      Dataconstants.recentViewedScrips.insert(0, model);
    } else if (index < 0) Dataconstants.recentViewedScrips.insert(0, model);
  }

  @override
  Widget build(BuildContext context) {
    return
        /* BOB requirement */
        /* Keep this code if require in future */
        // GestureDetector(
        //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        //   child: _buildSearchList(widget.dataAll,
        //       "Search for stocks to add \n Eg: AXISBANK NSE, NIFTY FUT", true),
        // );
        Column(
      children: [
        TabBar(
          physics: CustomTabBarScrollPhysics(),
          isScrollable: true,
          labelColor: Utils.primaryColor,
          //labelPadding: EdgeInsets.symmetric(horizontal: 15),
          unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
          controller: _tabController,
          indicatorColor: Utils.primaryColor.withOpacity(0.5),
          indicator: BubbleTabIndicator(
            indicatorHeight: 40.0,
            insets: EdgeInsets.symmetric(horizontal: 2),
            indicatorColor: Utils.primaryColor.withOpacity(0.2),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          onTap: (value) {
            var index = value;
            // InAppSelection.searchTabIndex=value;
            setState(() {
              InAppSelection.searchTabIndex = value;
            });
            //print("search index ${InAppSelection.searchTabIndex}");
          },
          tabs: [
            Tab(text: "All"),
            Tab(text: "Cash"),
            Tab(text: "F&O"),
            if (!Dataconstants.isFromAlgo) Tab(text: "Currency"),
            if (!Dataconstants.isFromAlgo) Tab(text: "Commodity"),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: CustomTabBarScrollPhysics(),
            controller: _tabController,
            children: [
              _buildSearchList(widget.dataAll, "Search for stocks to add \n Eg: AXISBANK NSE, NIFTY FUT", true),
              _buildSearchList(widget.dataCash, "Search for stocks to add \n Eg: NSE/BSE"),
              _buildSearchList(
                widget.dataFO,
                "Search for stocks to add \n Eg: NIFTY FUT, Nifty CE, Nifty PE, TCS FUT",
              ),
              if (!Dataconstants.isFromAlgo)
                _buildSearchList(
                  widget.dataCurrency,
                  "Search for stocks to add \n Eg: USDINR FUT, USD FUT, USD CE, USD PE",
                ),
              if (!Dataconstants.isFromAlgo)
                _buildSearchList(
                  widget.dataCommodity,
                  "Search for stocks to add \n Eg: GOLD,CRUDE OIL,COTTON,GOLD PE",
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchList(List<ScripStaticModel> data, String searchText, [bool isAllUI = false]) {
    var theme = Theme.of(context);
    if (data.isEmpty && !isAllUI)
      return Center(
        child: Text(
          searchText,
          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
          textAlign: TextAlign.center,
        ),
      );
    if (data.isEmpty && isAllUI)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Dataconstants.recentSearchQueries.length > 0)
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Visited',
                    style: Utils.fonts(size: 14.0, color: Utils.greyColor.withOpacity(0.5), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: Dataconstants.recentSearchQueries
                        .map(
                          (query) => InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            onTap: () {
                              widget.searchFunction(query);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.history,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    query,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          if (Dataconstants.recentViewedScrips.length > 0)
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                'Recent viewed',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: Dataconstants.recentViewedScrips.length,
              itemBuilder: (context, i) => ListTile(
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        Dataconstants.recentViewedScrips[i].name,
                        style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Text(Dataconstants.recentViewedScrips[i].exchName, style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w400)),
                          // SizedBox(
                          //   width: 4,
                          // ),
                          // Text(Dataconstants.recentViewedScrips[i].series,
                          //     style: Utils.fonts(
                          //         size: 11.0,
                          //         color: Utils.greyColor,
                          //         fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
                subtitle: Text(Dataconstants.recentViewedScrips[i].desc, style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w400)),
                // leading: Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Utils.greyColor.withOpacity(0.2),
                //   ),
                //   padding: EdgeInsets.all(3),
                //   child: Icon(
                //     Icons.add,
                //     size: 25,
                //   ),
                // ),

                // //Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       Dataconstants.recentViewedScrips[i].exchName,
                //       style: TextStyle(
                //           color: Dataconstants.recentViewedScrips[i].exchName ==
                //               'NSE'
                //               ? Colors.redAccent
                //               : Colors.blueAccent),
                //     ),
                //     Text(Dataconstants.recentViewedScrips[i].series),
                //   ],
                // ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Visibility(
                    //   visible: !CommonFunction.isIndicesScrip(
                    //       widget.model.exch, widget.model.exchCode),
                    //   child: Row(
                    //     children: [
                    //       /* Buy button */
                    //       // InkWell(
                    //       //   onTap: () => orderNavigate(false),
                    //       //   child: Container(
                    //       //     width: 28,
                    //       //     height: 28,
                    //       //     child: Center(
                    //       //         child: const Text("B",
                    //       //             style: const TextStyle(fontSize: 17.0,color: Colors.white))),
                    //       //     decoration: BoxDecoration(
                    //       //         borderRadius: BorderRadius.all(Radius.circular(6)),
                    //       //         color: const Color(0xe034c758)),
                    //       //   ),
                    //       // ),
                    //       // const SizedBox(width: 8),
                    //       /* Sell button */
                    //       InkWell(
                    //         onTap: () => orderNavigate(true),
                    //         child: Container(
                    //           width: 28,
                    //           height: 28,
                    //           child: Center(
                    //               child: const Text("S",
                    //                   style: const TextStyle(fontSize: 17.0,color: Colors.white))),
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.all(Radius.circular(6)),
                    //               color: const Color(0xe0fe3c30)),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(width: 5),
                    Observer(
                        builder: (_) => Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(Dataconstants.recentViewedScrips[i].close.toStringAsFixed(Dataconstants.recentViewedScrips[i].precision),
                                      style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w600)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Dataconstants.recentViewedScrips[i].priceChangeText + " " + Dataconstants.recentViewedScrips[i].percentChangeText,
                                      style: Utils.fonts(
                                          color: Dataconstants.recentViewedScrips[i].percentChange > 0
                                              ? ThemeConstants.buyColor
                                              : Dataconstants.recentViewedScrips[i].percentChange < 0
                                                  ? ThemeConstants.sellColor
                                                  : theme.errorColor,
                                          size: 11.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Icon(
                                        Dataconstants.recentViewedScrips[i].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                        color: Dataconstants.recentViewedScrips[i].percentChange > 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                  ],
                ),

                // const Icon(
                //   Icons.history,
                //   color: Colors.grey,
                // ),
                onTap: () {
                  ScripInfoModel tempModel =
                      CommonFunction.getScripDataModel(exch: Dataconstants.recentViewedScrips[i].exch, exchCode: Dataconstants.recentViewedScrips[i].exchCode, getNseBseMap: true);

                  /* showModalBottomSheet was causing to much processing on main thread */
                  /* Keep this code if require in future */
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(25.0),
                  //       topRight: Radius.circular(25.0),
                  //     ),
                  //   ),
                  //   clipBehavior: Clip.antiAliasWithSaveLayer,
                  //   builder: (builder) {
                  //     return DraggableScrollableSheet(
                  //       initialChildSize:
                  //           MediaQuery.of(context).size.height * 0.0009,
                  //       minChildSize: 0.50,
                  //       maxChildSize: 1,
                  //       expand: false,
                  //       builder: (BuildContext context,
                  //           ScrollController scrollController) {
                  //         return ScripDetailsScreen(
                  //           model: tempModel,
                  //           scrollController: scrollController,
                  //         );
                  //       },
                  //     );
                  //   },
                  // );
                  if (Dataconstants.isSip) {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => EquitySipOrderScreen(
                          model: tempModel,
                        ),
                      ),
                    )
                        .then((value) {
                      //print("ishdfnisdhg  $value");
                    });
                  } else if (Dataconstants.searchResearch) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResearchSearch(
                          model: tempModel,
                        ),
                      ),
                    );
                  } else
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScriptInfo(
                          tempModel,
                        ),
                      ),
                    );
                  addToRecentSearch(true, Dataconstants.recentViewedScrips[i]);
                },
              ),
            ),
          ),
        ],
      );
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, index) {
          int pos = Dataconstants.marketWatchListeners[widget.id].watchList.indexWhere((element) => element.exch == data[index].exch && element.exchCode == data[index].exchCode);

          return Column(
            children: [
              SearchAreaRow(
                key: ObjectKey(data[index]),
                model: data[index],
                initialPos: pos,
                id: widget.id,
                addToRecentSearch: addToRecentSearch,
              ),
              const Divider(),
            ],
          );
        });
  }
}

class SearchAreaRow extends StatefulWidget {
  final int initialPos;
  final ScripStaticModel model;
  final int id;
  final Function addToRecentSearch;

  SearchAreaRow({
    Key key,
    @required this.model,
    @required this.initialPos,
    @required this.id,
    @required this.addToRecentSearch,
  });

  @override
  _SearchAreaRowState createState() => _SearchAreaRowState();
}

class _SearchAreaRowState extends State<SearchAreaRow> {
  int pos;
  ScripInfoModel tempModel;

  @override
  void initState() {
    pos = widget.initialPos;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchAreaRow oldWidget) {
    pos = widget.initialPos;
    super.didUpdateWidget(oldWidget);
  }

  void orderNavigate(bool isSellButton) {
    try {
      if (tempModel.exchCategory == ExchCategory.nseEquity || tempModel.exchCategory == ExchCategory.bseEquity)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EquityOrderScreen(
                model: tempModel,
                orderType: ScripDetailType.none,
                isBuy: !isSellButton,
              );
            },
          ),
        );
      else if (tempModel.exchCategory == ExchCategory.nseFuture || tempModel.exchCategory == ExchCategory.nseOptions)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DerivativeOrderScreen(
                model: tempModel,
                orderType: ScripDetailType.none,
                isBuy: !isSellButton,
              );
            },
          ),
        );
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    tempModel = CommonFunction.getScripDataModel(sendReq: true, exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
    return ListTile(
      onTap: () {
        if (Dataconstants.isComingFromMarginCalculator) {
          Dataconstants.searchModel = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
          Navigator.pop(context);
        }
        ScripInfoModel tempModel = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
        widget.addToRecentSearch(true, tempModel);

        /* showModalBottomSheet was causing to much processing on main thread */
        /* Keep this code if require in future */
        // showModalBottomSheet(
        //   context: context,
        //   isScrollControlled: true,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(25.0),
        //       topRight: Radius.circular(25.0),
        //     ),
        //   ),
        //   clipBehavior: Clip.antiAliasWithSaveLayer,
        //   builder: (builder) {
        //     return DraggableScrollableSheet(
        //       initialChildSize: MediaQuery.of(context).size.height * 0.0009,
        //       minChildSize: 0.50,
        //       maxChildSize: 1,
        //       expand: false,
        //       builder:
        //           (BuildContext context, ScrollController scrollController) {
        //         return ScripDetailsScreen(
        //           model: tempModel,
        //           scrollController: scrollController,
        //         );
        //       },
        //     );
        //   },
        // );
        if (Dataconstants.isSip) {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EquitySipOrderScreen(
                model: tempModel,
              ),
            ),
          );
        } else if (Dataconstants.isFromAlgo) {
          ScripInfoModel tempModelforSearch = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
          Dataconstants.algoScriptModel = tempModelforSearch;
          Navigator.pop(context);
          return;
        } else if (Dataconstants.searchResearch) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResearchSearch(
                model: tempModel,
              ),
            ),
          );
        } else
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ScriptInfo(
                tempModel,
                watchListId: widget.id,
              ),
            ),
          )
              .then((value) {
            //print("scrip Info  $value");
          });
        ;
      },
      /* Script name */
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   widget.model.exchName,
          //   style: Utils.fonts(
          //       size: 14.0, color: widget.model.exchName == 'NSE'
          //       ? Colors.redAccent
          //       : Colors.blueAccent)
          // ),
          // Text(widget.model.series),
          /* Plus icon for add and remove the script */
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            padding: EdgeInsets.all(5),
            child: InkWell(
              child: Icon(
                pos > -1 ? Icons.check : Icons.add,
                size: 25,
              ),
              onTap: () {
                /* Model is not added to watchlist */
                if (Dataconstants.isComingFromMarginCalculator) {
                  Dataconstants.searchModel = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
                  Navigator.pop(context);
                  return;
                }
                if (pos < 0) {
                  if (Dataconstants.marketWatchListeners[widget.id].watchList.length >= Dataconstants.maxWatchlistCount)
                    CommonFunction.showSnackBar(
                      context: context,
                      text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
                      color: Colors.red,
                      duration: const Duration(milliseconds: 1500),
                    );
                  else {
                    if (Dataconstants.marketWatchListeners[widget.id].watchList.length == 0) {
                      Dataconstants.itsClient.getChartData(timeInterval: 15, chartPeriod: 'I', model: tempModel);
                      Dataconstants.marketWatchListeners[widget.id].addToWatchListSearch(widget.model);

                      setState(() {
                        pos = Dataconstants.marketWatchListeners[widget.id].watchList.length;
                      });
                    } else {
                      for (int i = 0; i < Dataconstants.marketWatchListeners[widget.id].watchList.length; i++) {
                        // //print(Dataconstants.marketWatchListeners[widget.id].watchList[i].name.toString());
                        if (Dataconstants.marketWatchListeners[widget.id].watchList[i].exchCode != widget.model.exchCode) {
                          Dataconstants.itsClient.getChartData(timeInterval: 15, chartPeriod: 'I', model: tempModel);
                          Dataconstants.marketWatchListeners[widget.id].addToWatchListSearch(widget.model);
                        }
                        setState(() {
                          pos = Dataconstants.marketWatchListeners[widget.id].watchList.length;
                        });
                        break;
                      }
                    }
                  }
                  Dataconstants.scriptCount++;
                } else {
                  /* Model is added to watchlist */
                  Dataconstants.marketWatchListeners[widget.id].removeFromWatchListIndex(pos);

                  setState(() {
                    pos = -1;
                  });
                  Dataconstants.scriptCount--;
                }
                if (Dataconstants.isFromAlgo) {
                  widget.addToRecentSearch(false);
                  ScripInfoModel tempModelforSearch = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.exchCode, getNseBseMap: true);
                  Dataconstants.algoScriptModel = tempModelforSearch;
                  Navigator.pop(context);
                  return;
                }
                widget.addToRecentSearch(false);
              },
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visibility(
          //   visible: !CommonFunction.isIndicesScrip(
          //       widget.model.exch, widget.model.exchCode),
          //   child: Row(
          //     children: [
          //       /* Buy button */
          //       // InkWell(
          //       //   onTap: () => orderNavigate(false),
          //       //   child: Container(
          //       //     width: 28,
          //       //     height: 28,
          //       //     child: Center(
          //       //         child: const Text("B",
          //       //             style: const TextStyle(fontSize: 17.0,color: Colors.white))),
          //       //     decoration: BoxDecoration(
          //       //         borderRadius: BorderRadius.all(Radius.circular(6)),
          //       //         color: const Color(0xe034c758)),
          //       //   ),
          //       // ),
          //       // const SizedBox(width: 8),
          //       /* Sell button */
          //       InkWell(
          //         onTap: () => orderNavigate(true),
          //         child: Container(
          //           width: 28,
          //           height: 28,
          //           child: Center(
          //               child: const Text("S",
          //                   style: const TextStyle(fontSize: 17.0,color: Colors.white))),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(6)),
          //               color: const Color(0xe0fe3c30)),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(width: 5),
          Observer(
              builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(tempModel.close.toStringAsFixed(tempModel.precision), style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w600)),
                      ),
                      Row(
                        children: [
                          Text(
                            tempModel.priceChangeText + " " + tempModel.percentChangeText,
                            style: Utils.fonts(
                                color: tempModel.percentChange > 0
                                    ? ThemeConstants.buyColor
                                    : tempModel.percentChange < 0
                                        ? ThemeConstants.sellColor
                                        : theme.errorColor,
                                size: 11.0,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              tempModel.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                              color: tempModel.percentChange > 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                              size: 28,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
        ],
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              widget.model.name,
              style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Text(widget.model.exchName, style: Utils.fonts(size: 13.0, color: Utils.greyColor, fontWeight: FontWeight.w400)),
                SizedBox(
                  width: 4,
                ),
                // Text(widget.model.series,
                //     style: Utils.fonts(
                //         size: 13.0,
                //         color: Utils.greyColor,
                //         fontWeight: FontWeight.w400)),
                // Text(
                //   'LTP',
                //   style: TextStyle(
                //     fontSize: 13,
                //     color: Colors.grey[600],
                //   ),
                // ),
                // const SizedBox(width: 5),
                // Observer(
                //   builder: (_) => Text(
                //     /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
                //     tempModel.close == 0.00
                //         ? tempModel.prevDayClose.toStringAsFixed(
                //             widget.model.series == 'Curr' ? 4 : 2)
                //         : tempModel.close.toStringAsFixed(
                //             widget.model.series == 'Curr' ? 4 : 2),
                //     style: const TextStyle(
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      subtitle: Text(widget.model.desc, style: Utils.fonts(size: 13.0, color: Utils.greyColor, fontWeight: FontWeight.w400)),
    );
  }
}

// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:markets/util/InAppSelections.dart';
// import '../jmScreens/ScriptInfo/ScriptInfo.dart';
// import '../jmScreens/equitySIP/equity_sip_order_screen.dart';
// import '../jmScreens/orders/OrderPlacement/derivative_order_screen.dart';
// import '../jmScreens/orders/OrderPlacement/equity_order_screen.dart';
// import '../model/scripStaticModel.dart';
// import '../model/scrip_info_model.dart';
// import '../screens/scrip_details_screen.dart';
// import '../style/theme.dart';
// import '../util/CommonFunctions.dart';
// import '../util/Dataconstants.dart';
// import '../util/InAppSelections.dart';
// import '../util/Utils.dart';
// import '../widget/custom_tab_bar.dart';
//
// class SearchArea extends StatefulWidget {
//   final int id;
//
//   final List<ScripStaticModel> dataAll,
//       dataCash,
//       dataFO,
//       dataCurrency,
//       dataCommodity;
//   final Function searchFunction;
//   final String query;
//
//   SearchArea({
//     @required this.dataAll,
//     @required this.dataCash,
//     @required this.dataFO,
//     @required this.dataCurrency,
//     @required this.dataCommodity,
//     @required this.query,
//     @required this.id,
//     @required this.searchFunction,
//   });
//
//   @override
//   _SearchAreaState createState() => _SearchAreaState();
// }
//
// class _SearchAreaState extends State<SearchArea>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;
//   bool addedToRecentSearch = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(vsync: this, length: 5);
//     _tabController.index=InAppSelection.searchTabIndex;
//   }
//
//   void addToRecentSearch(bool isRecentlyViewed, [ScripInfoModel model]) {
//     if (!addedToRecentSearch && widget.query.isNotEmpty) {
//       var index = Dataconstants.recentSearchQueries.indexOf(widget.query);
//       if (Dataconstants.recentSearchQueries.length >= 5) {
//         if (index >= 0)
//           Dataconstants.recentSearchQueries.removeAt(index);
//         else
//           Dataconstants.recentSearchQueries.removeLast();
//         Dataconstants.recentSearchQueries.insert(0, widget.query);
//       } else if (index < 0)
//         Dataconstants.recentSearchQueries.insert(0, widget.query);
//     }
//     if (!isRecentlyViewed) return;
//     var index = Dataconstants.recentViewedScrips.indexWhere((element) =>
//         element.exch == model.exch && element.exchCode == model.exchCode);
//     if (Dataconstants.recentViewedScrips.length >= 5) {
//       if (index >= 0)
//         Dataconstants.recentViewedScrips.removeAt(index);
//       else
//         Dataconstants.recentViewedScrips.removeLast();
//       Dataconstants.recentViewedScrips.insert(0, model);
//     } else if (index < 0) Dataconstants.recentViewedScrips.insert(0, model);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//         /* BOB requirement */
//         /* Keep this code if require in future */
//         // GestureDetector(
//         //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         //   child: _buildSearchList(widget.dataAll,
//         //       "Search for stocks to add \n Eg: AXISBANK NSE, NIFTY FUT", true),
//         // );
//         Column(
//       children: [
//         TabBar(
//           physics: CustomTabBarScrollPhysics(),
//           isScrollable: true,
//           labelColor: Utils.primaryColor,
//           //labelPadding: EdgeInsets.symmetric(horizontal: 15),
//           unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
//           controller: _tabController,
//           indicatorColor: Utils.primaryColor.withOpacity(0.5),
//           indicator: BubbleTabIndicator(
//             indicatorHeight: 40.0,
//             insets: EdgeInsets.symmetric(horizontal: 2),
//             indicatorColor: Utils.primaryColor.withOpacity(0.2),
//             tabBarIndicatorSize: TabBarIndicatorSize.tab,
//           ),
//           onTap: (value){
//             var index = value;
//             // InAppSelection.searchTabIndex=value;
//             setState(() {
//               InAppSelection.searchTabIndex=value;
//             });
//             //print("search index ${InAppSelection.searchTabIndex}");
//           },
//           tabs: [
//             Tab(text: "All"),
//             Tab(text: "Cash"),
//             Tab(text: "F&O"),
//             Tab(text: "Currency"),
//             Tab(text: "Commodity"),
//           ],
//         ),
//         Expanded(
//           child: TabBarView(
//             physics: CustomTabBarScrollPhysics(),
//             controller: _tabController,
//             children: [
//               _buildSearchList(
//                   widget.dataAll,
//                   "Search for stocks to add \n Eg: AXISBANK NSE, NIFTY FUT",
//                   true),
//               _buildSearchList(
//                   widget.dataCash, "Search for stocks to add \n Eg: NSE/BSE"),
//               _buildSearchList(
//                 widget.dataFO,
//                 "Search for stocks to add \n Eg: NIFTY FUT, Nifty CE, Nifty PE, TCS FUT",
//               ),
//               _buildSearchList(
//                 widget.dataCurrency,
//                 "Search for stocks to add \n Eg: USDINR FUT, USD FUT, USD CE, USD PE",
//               ),
//               _buildSearchList(
//                 widget.dataCommodity,
//                 "Search for stocks to add \n Eg: GOLD,CRUDE OIL,COTTON,GOLD PE",
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSearchList(List<ScripStaticModel> data, String searchText,
//       [bool isAllUI = false]) {
//     var theme = Theme.of(context);
//     if (data.isEmpty && !isAllUI)
//       return Center(
//         child: Text(
//           searchText,
//           style: Utils.fonts(size: 14.0, color: Utils.greyColor),
//           textAlign: TextAlign.center,
//         ),
//       );
//     if (data.isEmpty && isAllUI)
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           if (Dataconstants.recentSearchQueries.length > 0)
//             Container(
//               margin: const EdgeInsets.only(
//                 left: 10,
//                 right: 10,
//                 top: 10,
//                 bottom: 15,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Recent Visited',
//                     style: Utils.fonts(
//                         size: 14.0,
//                         color: Utils.greyColor.withOpacity(0.5),
//                         fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 15),
//                   Wrap(
//                     direction: Axis.horizontal,
//                     spacing: 10,
//                     children: Dataconstants.recentSearchQueries
//                         .map(
//                           (query) => InkWell(
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(8.0),
//                             ),
//                             onTap: () {
//                               widget.searchFunction(query);
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(5.0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(
//                                     Icons.history,
//                                     color: Colors.grey,
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                     query,
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//           if (Dataconstants.recentViewedScrips.length > 0)
//             Container(
//               margin: const EdgeInsets.all(10),
//               child: Text(
//                 'Recent viewed',
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: Dataconstants.recentViewedScrips.length,
//               itemBuilder: (context, i) => ListTile(
//                 title: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   alignment: Alignment.centerLeft,
//                   child: Row(
//                     children: [
//                       Text(
//                         Dataconstants.recentViewedScrips[i].name,
//                         style: Utils.fonts(
//                             size: 16.0, fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Row(
//                         children: [
//                           Text(Dataconstants.recentViewedScrips[i].exchName,
//                               style: Utils.fonts(
//                                   size: 11.0,
//                                   color: Utils.greyColor,
//                                   fontWeight: FontWeight.w400)),
//                           // SizedBox(
//                           //   width: 4,
//                           // ),
//                           // Text(Dataconstants.recentViewedScrips[i].series,
//                           //     style: Utils.fonts(
//                           //         size: 11.0,
//                           //         color: Utils.greyColor,
//                           //         fontWeight: FontWeight.w400)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 subtitle: Text(Dataconstants.recentViewedScrips[i].desc,
//                     style: Utils.fonts(
//                         size: 11.0,
//                         color: Utils.greyColor,
//                         fontWeight: FontWeight.w400)),
//                 // leading: Container(
//                 //   decoration: BoxDecoration(
//                 //     shape: BoxShape.circle,
//                 //     color: Utils.greyColor.withOpacity(0.2),
//                 //   ),
//                 //   padding: EdgeInsets.all(3),
//                 //   child: Icon(
//                 //     Icons.add,
//                 //     size: 25,
//                 //   ),
//                 // ),
//
//                 // //Column(
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     Text(
//                 //       Dataconstants.recentViewedScrips[i].exchName,
//                 //       style: TextStyle(
//                 //           color: Dataconstants.recentViewedScrips[i].exchName ==
//                 //               'NSE'
//                 //               ? Colors.redAccent
//                 //               : Colors.blueAccent),
//                 //     ),
//                 //     Text(Dataconstants.recentViewedScrips[i].series),
//                 //   ],
//                 // ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Visibility(
//                     //   visible: !CommonFunction.isIndicesScrip(
//                     //       widget.model.exch, widget.model.exchCode),
//                     //   child: Row(
//                     //     children: [
//                     //       /* Buy button */
//                     //       // InkWell(
//                     //       //   onTap: () => orderNavigate(false),
//                     //       //   child: Container(
//                     //       //     width: 28,
//                     //       //     height: 28,
//                     //       //     child: Center(
//                     //       //         child: const Text("B",
//                     //       //             style: const TextStyle(fontSize: 17.0,color: Colors.white))),
//                     //       //     decoration: BoxDecoration(
//                     //       //         borderRadius: BorderRadius.all(Radius.circular(6)),
//                     //       //         color: const Color(0xe034c758)),
//                     //       //   ),
//                     //       // ),
//                     //       // const SizedBox(width: 8),
//                     //       /* Sell button */
//                     //       InkWell(
//                     //         onTap: () => orderNavigate(true),
//                     //         child: Container(
//                     //           width: 28,
//                     //           height: 28,
//                     //           child: Center(
//                     //               child: const Text("S",
//                     //                   style: const TextStyle(fontSize: 17.0,color: Colors.white))),
//                     //           decoration: BoxDecoration(
//                     //               borderRadius: BorderRadius.all(Radius.circular(6)),
//                     //               color: const Color(0xe0fe3c30)),
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     // const SizedBox(width: 5),
//                     Observer(
//                         builder: (_) => Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0),
//                                   child: Text(
//                                       Dataconstants.recentViewedScrips[i].close
//                                           .toStringAsFixed(Dataconstants
//                                               .recentViewedScrips[i].precision),
//                                       style: Utils.fonts(
//                                           size: 14.0,
//                                           color: Utils.blackColor,
//                                           fontWeight: FontWeight.w600)),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       Dataconstants.recentViewedScrips[i]
//                                               .priceChangeText +
//                                           " " +
//                                           Dataconstants.recentViewedScrips[i]
//                                               .percentChangeText,
//                                       style: Utils.fonts(
//                                           color: Dataconstants
//                                                       .recentViewedScrips[i]
//                                                       .percentChange >
//                                                   0
//                                               ? ThemeConstants.buyColor
//                                               : Dataconstants
//                                                           .recentViewedScrips[i]
//                                                           .percentChange <
//                                                       0
//                                                   ? ThemeConstants.sellColor
//                                                   : theme.errorColor,
//                                           size: 11.0,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.all(0.0),
//                                       child: Icon(
//                                         Dataconstants.recentViewedScrips[i]
//                                                     .percentChange >
//                                                 0
//                                             ? Icons.arrow_drop_up_rounded
//                                             : Icons.arrow_drop_down_rounded,
//                                         color: Dataconstants
//                                                     .recentViewedScrips[i]
//                                                     .percentChange >
//                                                 0
//                                             ? ThemeConstants.buyColor
//                                             : ThemeConstants.sellColor,
//                                         size: 28,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )),
//                   ],
//                 ),
//
//                 // const Icon(
//                 //   Icons.history,
//                 //   color: Colors.grey,
//                 // ),
//                 onTap: () {
//                   ScripInfoModel tempModel = CommonFunction.getScripDataModel(
//                       exch: Dataconstants.recentViewedScrips[i].exch,
//                       exchCode: Dataconstants.recentViewedScrips[i].exchCode,
//                       getNseBseMap: true);
//
//                   /* showModalBottomSheet was causing to much processing on main thread */
//                   /* Keep this code if require in future */
//                   // showModalBottomSheet(
//                   //   context: context,
//                   //   isScrollControlled: true,
//                   //   shape: RoundedRectangleBorder(
//                   //     borderRadius: BorderRadius.only(
//                   //       topLeft: Radius.circular(25.0),
//                   //       topRight: Radius.circular(25.0),
//                   //     ),
//                   //   ),
//                   //   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   //   builder: (builder) {
//                   //     return DraggableScrollableSheet(
//                   //       initialChildSize:
//                   //           MediaQuery.of(context).size.height * 0.0009,
//                   //       minChildSize: 0.50,
//                   //       maxChildSize: 1,
//                   //       expand: false,
//                   //       builder: (BuildContext context,
//                   //           ScrollController scrollController) {
//                   //         return ScripDetailsScreen(
//                   //           model: tempModel,
//                   //           scrollController: scrollController,
//                   //         );
//                   //       },
//                   //     );
//                   //   },
//                   // );
//                   if (Dataconstants.isSip) {
//                     Navigator.pop(context);
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => EquitySipOrderScreen(
//                           model: tempModel,
//                         ),
//                       ),
//                     ).then((value){
//                       //print("ishdfnisdhg  $value");
//                     });
//                   } else
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => ScriptInfo(
//                           tempModel,
//                         ),
//                       ),
//                     );
//                   addToRecentSearch(true, Dataconstants.recentViewedScrips[i]);
//                 },
//               ),
//             ),
//           ),
//         ],
//       );
//     return ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (ctx, index) {
//           int pos = Dataconstants.marketWatchListeners[widget.id].watchList
//               .indexWhere((element) =>
//                   element.exch == data[index].exch &&
//                   element.exchCode == data[index].exchCode);
//
//           return Column(
//             children: [
//               SearchAreaRow(
//                 key: ObjectKey(data[index]),
//                 model: data[index],
//                 initialPos: pos,
//                 id: widget.id,
//                 addToRecentSearch: addToRecentSearch,
//               ),
//               const Divider(),
//             ],
//           );
//         });
//   }
// }
//
// class SearchAreaRow extends StatefulWidget {
//   final int initialPos;
//   final ScripStaticModel model;
//   final int id;
//   final Function addToRecentSearch;
//
//   SearchAreaRow({
//     Key key,
//     @required this.model,
//     @required this.initialPos,
//     @required this.id,
//     @required this.addToRecentSearch,
//   });
//
//   @override
//   _SearchAreaRowState createState() => _SearchAreaRowState();
// }
//
// class _SearchAreaRowState extends State<SearchAreaRow> {
//   int pos;
//   ScripInfoModel tempModel;
//
//   @override
//   void initState() {
//     pos = widget.initialPos;
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(covariant SearchAreaRow oldWidget) {
//     pos = widget.initialPos;
//     super.didUpdateWidget(oldWidget);
//   }
//
//   void orderNavigate(bool isSellButton) {
//     try {
//       if (tempModel.exchCategory == ExchCategory.nseEquity ||
//           tempModel.exchCategory == ExchCategory.bseEquity)
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) {
//               return EquityOrderScreen(
//                 model: tempModel,
//                 orderType: ScripDetailType.none,
//                 isBuy: !isSellButton,
//               );
//             },
//           ),
//         );
//       else if (tempModel.exchCategory == ExchCategory.nseFuture ||
//           tempModel.exchCategory == ExchCategory.nseOptions)
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) {
//               return DerivativeOrderScreen(
//                 model: tempModel,
//                 orderType: ScripDetailType.none,
//                 isBuy: !isSellButton,
//               );
//             },
//           ),
//         );
//     } catch (e) {
//       //print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     tempModel = CommonFunction.getScripDataModel(
//         sendReq: true,
//         exch: widget.model.exch,
//         exchCode: widget.model.exchCode,
//         getNseBseMap: true);
//     return ListTile(
//       onTap: () {
//         if (Dataconstants.isComingFromMarginCalculator) {
//           Dataconstants.searchModel = CommonFunction.getScripDataModel(
//               exch: widget.model.exch,
//               exchCode: widget.model.exchCode,
//               getNseBseMap: true);
//           Navigator.pop(context);
//         }
//         ScripInfoModel tempModel = CommonFunction.getScripDataModel(
//             exch: widget.model.exch,
//             exchCode: widget.model.exchCode,
//             getNseBseMap: true);
//         widget.addToRecentSearch(true, tempModel);
//
//         /* showModalBottomSheet was causing to much processing on main thread */
//         /* Keep this code if require in future */
//         // showModalBottomSheet(
//         //   context: context,
//         //   isScrollControlled: true,
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.only(
//         //       topLeft: Radius.circular(25.0),
//         //       topRight: Radius.circular(25.0),
//         //     ),
//         //   ),
//         //   clipBehavior: Clip.antiAliasWithSaveLayer,
//         //   builder: (builder) {
//         //     return DraggableScrollableSheet(
//         //       initialChildSize: MediaQuery.of(context).size.height * 0.0009,
//         //       minChildSize: 0.50,
//         //       maxChildSize: 1,
//         //       expand: false,
//         //       builder:
//         //           (BuildContext context, ScrollController scrollController) {
//         //         return ScripDetailsScreen(
//         //           model: tempModel,
//         //           scrollController: scrollController,
//         //         );
//         //       },
//         //     );
//         //   },
//         // );
//         if (Dataconstants.isSip) {
//           Navigator.pop(context);
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => EquitySipOrderScreen(
//                 model: tempModel,
//               ),
//             ),
//           );
//         } else
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => ScriptInfo(
//                 tempModel,
//               ),
//             ),
//           ).then((value){
//             //print("scrip Info  $value");
//           });;
//       },
//       /* Script name */
//       leading: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Text(
//           //   widget.model.exchName,
//           //   style: Utils.fonts(
//           //       size: 14.0, color: widget.model.exchName == 'NSE'
//           //       ? Colors.redAccent
//           //       : Colors.blueAccent)
//           // ),
//           // Text(widget.model.series),
//           /* Plus icon for add and remove the script */
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Utils.greyColor.withOpacity(0.2),
//             ),
//             padding: EdgeInsets.all(5),
//             child: InkWell(
//               child: Icon(
//                 pos > -1 ? Icons.check : Icons.add,
//                 size: 25,
//               ),
//               onTap: () {
//                 /* Model is not added to watchlist */
//                 if (Dataconstants.isComingFromMarginCalculator) {
//                   Dataconstants.searchModel = CommonFunction.getScripDataModel(
//                       exch: widget.model.exch,
//                       exchCode: widget.model.exchCode,
//                       getNseBseMap: true);
//                   Navigator.pop(context);
//                   return;
//                 }
//                 if (pos < 0) {
//                   if (Dataconstants
//                           .marketWatchListeners[widget.id].watchList.length >=
//                       Dataconstants.maxWatchlistCount)
//                     CommonFunction.showSnackBar(
//                       context: context,
//                       text:
//                           'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
//                       color: Colors.red,
//                       duration: const Duration(milliseconds: 1500),
//                     );
//                   else {
//                     if (Dataconstants
//                             .marketWatchListeners[widget.id].watchList.length ==
//                         0) {
//                       Dataconstants.itsClient.getChartData(
//                           timeInterval: 15, chartPeriod: 'I', model: tempModel);
//                       Dataconstants.marketWatchListeners[widget.id]
//                           .addToWatchListSearch(widget.model);
//
//                       setState(() {
//                         pos = Dataconstants
//                             .marketWatchListeners[widget.id].watchList.length;
//                       });
//                     } else {
//                       for (int i = 0;
//                           i <
//                               Dataconstants.marketWatchListeners[widget.id]
//                                   .watchList.length;
//                           i++) {
//                         // //print(Dataconstants.marketWatchListeners[widget.id].watchList[i].name.toString());
//                         if (Dataconstants.marketWatchListeners[widget.id]
//                                 .watchList[i].exchCode !=
//                             widget.model.exchCode) {
//                           Dataconstants.itsClient.getChartData(
//                               timeInterval: 15,
//                               chartPeriod: 'I',
//                               model: tempModel);
//                           Dataconstants.marketWatchListeners[widget.id]
//                               .addToWatchListSearch(widget.model);
//                         }
//                         setState(() {
//                           pos = Dataconstants
//                               .marketWatchListeners[widget.id].watchList.length;
//                         });
//                         break;
//                       }
//                     }
//                   }
//                   Dataconstants.scriptCount++;
//                 } else {
//                   /* Model is added to watchlist */
//                   Dataconstants.marketWatchListeners[widget.id]
//                       .removeFromWatchListIndex(pos);
//
//                   setState(() {
//                     pos = -1;
//                   });
//                   Dataconstants.scriptCount--;
//                 }
//                 widget.addToRecentSearch(false);
//               },
//             ),
//           ),
//         ],
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Visibility(
//           //   visible: !CommonFunction.isIndicesScrip(
//           //       widget.model.exch, widget.model.exchCode),
//           //   child: Row(
//           //     children: [
//           //       /* Buy button */
//           //       // InkWell(
//           //       //   onTap: () => orderNavigate(false),
//           //       //   child: Container(
//           //       //     width: 28,
//           //       //     height: 28,
//           //       //     child: Center(
//           //       //         child: const Text("B",
//           //       //             style: const TextStyle(fontSize: 17.0,color: Colors.white))),
//           //       //     decoration: BoxDecoration(
//           //       //         borderRadius: BorderRadius.all(Radius.circular(6)),
//           //       //         color: const Color(0xe034c758)),
//           //       //   ),
//           //       // ),
//           //       // const SizedBox(width: 8),
//           //       /* Sell button */
//           //       InkWell(
//           //         onTap: () => orderNavigate(true),
//           //         child: Container(
//           //           width: 28,
//           //           height: 28,
//           //           child: Center(
//           //               child: const Text("S",
//           //                   style: const TextStyle(fontSize: 17.0,color: Colors.white))),
//           //           decoration: BoxDecoration(
//           //               borderRadius: BorderRadius.all(Radius.circular(6)),
//           //               color: const Color(0xe0fe3c30)),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           // const SizedBox(width: 5),
//           Observer(
//               builder: (_) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(
//                             tempModel.close
//                                 .toStringAsFixed(tempModel.precision),
//                             style: Utils.fonts(
//                                 size: 14.0,
//                                 color: Utils.blackColor,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             tempModel.priceChangeText +
//                                 " " +
//                                 tempModel.percentChangeText,
//                             style: Utils.fonts(
//                                 color: tempModel.percentChange > 0
//                                     ? ThemeConstants.buyColor
//                                     : tempModel.percentChange < 0
//                                         ? ThemeConstants.sellColor
//                                         : theme.errorColor,
//                                 size: 11.0,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(0.0),
//                             child: Icon(
//                               tempModel.percentChange > 0
//                                   ? Icons.arrow_drop_up_rounded
//                                   : Icons.arrow_drop_down_rounded,
//                               color: tempModel.percentChange > 0
//                                   ? ThemeConstants.buyColor
//                                   : ThemeConstants.sellColor,
//                               size: 28,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   )),
//         ],
//       ),
//       title: FittedBox(
//         fit: BoxFit.scaleDown,
//         alignment: Alignment.centerLeft,
//         child: Row(
//           children: [
//             Text(
//               widget.model.name,
//               style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.start,
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Row(
//               children: [
//                 Text(widget.model.exchName,
//                     style: Utils.fonts(
//                         size: 13.0,
//                         color: Utils.greyColor,
//                         fontWeight: FontWeight.w400)),
//                 // SizedBox(
//                 //   width: 4,
//                 // ),
//                 // Text(widget.model.series,
//                 //     style: Utils.fonts(
//                 //         size: 13.0,
//                 //         color: Utils.greyColor,
//                 //         fontWeight: FontWeight.w400)),
//                 // Text(
//                 //   'LTP',
//                 //   style: TextStyle(
//                 //     fontSize: 13,
//                 //     color: Colors.grey[600],
//                 //   ),
//                 // ),
//                 // const SizedBox(width: 5),
//                 // Observer(
//                 //   builder: (_) => Text(
//                 //     /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
//                 //     tempModel.close == 0.00
//                 //         ? tempModel.prevDayClose.toStringAsFixed(
//                 //             widget.model.series == 'Curr' ? 4 : 2)
//                 //         : tempModel.close.toStringAsFixed(
//                 //             widget.model.series == 'Curr' ? 4 : 2),
//                 //     style: const TextStyle(
//                 //       fontSize: 14,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       subtitle: Text(widget.model.desc,
//           style: Utils.fonts(
//               size: 13.0, color: Utils.greyColor, fontWeight: FontWeight.w400)),
//     );
//   }
// }
