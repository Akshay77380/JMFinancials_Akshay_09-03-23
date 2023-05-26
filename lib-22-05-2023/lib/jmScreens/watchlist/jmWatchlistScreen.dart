import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/holdingController.dart';
import '../../database/watchlist_database.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'EditWatchlist.dart';
import 'PredefinedWachlist.dart';
import 'WatchListSelector.dart';
import 'displaySettings.dart';
import 'editColumns.dart';
import 'holdingsWatchlist.dart';
import 'manageWatchlist.dart';
import 'marketWatchlist.dart';

class JmWatchlistScreen extends StatefulWidget {
  @override
  _JmWatchlistScreenState createState() => _JmWatchlistScreenState();
}

class _JmWatchlistScreenState extends State<JmWatchlistScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String newWatchListName;

  String renamedWatchlist;

  @override
  bool get wantKeepAlive => true;
  TabController _tabController;
  int _currentIndex = 0;
  int counter;

  // List<Tab> _tabs = [];
  final int _startingTabCount = 4;

  // List<Tab> getTabs(int count) {
  //   _tabs.clear();
  //   for (int i = 0; i < count; i++) {
  //     _tabs.add(getTab(i));
  //   }
  //   return _tabs;
  // }

  // Tab getTab(int i) {
  //   return Tab(
  //     child: Row(
  //       mainAxisAlignment: _currentIndex == i
  //           ? MainAxisAlignment.center
  //           : MainAxisAlignment.start,
  //       children: [
  //         Text(
  //           Dataconstants.marketWatchListeners[i].watchListName.toString(),
  //           style: Utils.fonts(
  //             size: _currentIndex == i ? 14.0 : 12.0,
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         CircleAvatar(
  //             backgroundColor:
  //                 _currentIndex == i ? Utils.primaryColor : Utils.greyColor,
  //             foregroundColor: Utils.whiteColor,
  //             maxRadius: 11,
  //             child: Text(
  //               Dataconstants.marketWatchListeners[i]
  //                   .getWatchLength()
  //                   .toString(),
  //               style: Utils.fonts(
  //                   size: 11.0, color: Utils.greyColor.withOpacity(0.5)),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp]);

    _currentIndex = Dataconstants.defaultWatchList;
    _currentIndex = 0;
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    // CommonFunction.getMarketWatch();

    _tabController.addListener(() {
      print(_tabController.index.toString());
      Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.marketWatchListeners[_tabController.index].watchList, true);
      Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.preDefinedWatchListeners[_tabController.index].watchList, true);
    });
    generateLandscapeData();
    if (_currentIndex != -1) _tabController.index = _currentIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Dataconstants.loginData.watchlistFlag.toString() == "true") {
        await Dataconstants.watchListController.checkWatchList();
      }
    });

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp
    // ]);
    // if (InAppSelection.newUserToIndices == false)
    //   _tabController.index = 0;
    // else {
    //   getnewUserToIndices();
    //   _tabController.index = 1;
    // }

    Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList, true);
    Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.preDefinedWatchListeners[InAppSelection.marketWatchID].watchList, true);

  }

  void getnewUserToIndices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    InAppSelection.newUserToIndices = false;
    prefs.setBool('newUserToIndices', false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  final FocusNode myFocusNodeCreateWatchlist = FocusNode();
  final FocusNode myFocusNodeRenameWatchlist = FocusNode();
  TextEditingController createWatchListController = TextEditingController();
  TextEditingController renameWatchListController = TextEditingController();

  createWatchList() {
    createWatchListController.text = "";
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 2,
                                  color: Utils.greyColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Image.asset(
                                  "assets/appImages/createWatchlistImage.png",
                                ),
                              ),
                              Text(
                                "Create Watchlist",
                                style: Utils.fonts(size: 18.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextField(
                                maxLength: 15,
                                controller: createWatchListController,
                                focusNode: myFocusNodeCreateWatchlist,
                                showCursor: true,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    newWatchListName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  labelText: "Watchlist Name",
                                  // prefixIcon: Icon(
                                  //   Icons.phone_android_rounded,
                                  //   size: 18,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Cancel",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
                                  ElevatedButton(
                                      onPressed: () async {
                                        // var newWatchListNo = int.parse(
                                        //     WatchlistDatabase.lastWatchListIndex
                                        //         .toString());
                                        // await WatchlistDatabase.instance
                                        //     .addNewWatchlist(
                                        //         ++newWatchListNo,
                                        //         newWatchListName.toString(),
                                        //         "4");
                                        Navigator.pop(context);
                                        replaceWatchList();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Create",
                                          style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                          )))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          );
        });
  }

  renameWatchList(index) {
    renameWatchListController.text = "";
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 2,
                                  color: Utils.greyColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rename ${WatchlistDatabase.allWatchlist[index]["watchListName"].toString()}",
                                style: Utils.fonts(size: 18.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLength: 15,
                                controller: renameWatchListController,
                                focusNode: myFocusNodeRenameWatchlist,
                                showCursor: true,
                                onChanged: (value) {
                                  setState(() {
                                    renamedWatchlist = value;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  labelText: "Watchlist Name",
                                  // prefixIcon: Icon(
                                  //   Icons.phone_android_rounded,
                                  //   size: 18,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Cancel",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await WatchlistDatabase.instance.updateWatchListName(WatchlistDatabase.allWatchlist[index]["watchListNo"], renamedWatchlist);

                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Save",
                                          style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                          )))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          );
        });
  }

  replaceWatchList() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return ReplaceWatchList(newWatchListName.toString());
        }).then((value) async {
      await Future.delayed(Duration(seconds: 2));
      setState(() {});
    });
  }

  expandedDots() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new Container(
            height: 450.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            createWatchList();
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/createWatchLists.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Create Watchlists",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             PredefinedWatchlist()));
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/predefinedWatchlist.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Predefined Watchlists",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageWatchlist())).then((value) {
                              if (value != null) {
                                try {
                                  var newValue = value.toString().split("-");
                                  if (newValue[1] == "2") {
                                    Navigator.pop(context);
                                    // CommonFunction.deleteWatchList(
                                    //     context, int.parse(newValue[0]));
                                  } else if (newValue[1] == "1") {
                                    Navigator.pop(context);
                                    renameWatchList(int.parse(newValue[0]));
                                  }
                                } catch (e) {}
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/manageWatchlist.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Manage Watchlists",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditWatchList(_currentIndex)));
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/editCurrentWatchlist.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Edit Current Watchlist",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditColumns()));
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/editWatchListColumn.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Edit Watchlist Columns",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySettings())).then((value) {
                              setState(() {});
                            });
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/displaySetting.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Display Settings",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        }).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    return portraitMode(theme);
    // return OrientationBuilder(builder: (context, orientation) {
    //   return orientation == Orientation.portrait ? portraitMode(theme) : landScapeMode();
    // });
  }

  portraitMode(theme) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              leading: null,
              // leading: InkWell(
              //     onTap: () {
              //       setState(() {
              //         InAppSelection.mainScreenIndex = 0;
              //       });
              //     },
              //     child: Icon(Icons.arrow_back)),
              title: Text(
                "Watchlist",
                style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: theme.textTheme.bodyText1.color),
              ),
              elevation: 0,
              actions: [
                InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                      CommonFunction.marketWatchBottomSheet(context);
                    },
                    child: SvgPicture.asset('assets/appImages/tranding.svg', color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor)),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    print(_currentIndex);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => WatchListSelector(_currentIndex),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor,
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
                      labelPadding: EdgeInsets.symmetric(horizontal: 20),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 0,
                      indicator: BubbleTabIndicator(
                        indicatorHeight: 40.0,
                        insets: EdgeInsets.symmetric(horizontal: 2),
                        indicatorColor: Utils.primaryColor.withOpacity(0.3),
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      ),
                      controller: _tabController,
                      onTap: (_index) {
                        if (_index == 0) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await Dataconstants.holdingController.fetchHolding();
                            await Dataconstants.holdingController.fetchMtfHolding();
                          });
                        }
                        if (_index == 1) {
                          Dataconstants.iqsClient.bulkSendScripRequestToIQS(Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList, false);
                          Dataconstants.iqsClient.bulkSendScripRequestToIQS(Dataconstants.marketWatchListeners[0].watchList, true);
                          Dataconstants.marketWatchListeners[0].watchList.forEach((model) {
                            // model.getChartData(timeInterval: 15, chartPeriod: "I");

                            Dataconstants.itsClient.getChartData(timeInterval: 15, chartPeriod: "I", model: model);
                          });
                        }
                        setState(() {
                          InAppSelection.marketWatchID = _index;
                          _currentIndex = _index;
                        });
                      },
                      tabs: [
                        for (var i = 0; i < InAppSelection.tabsView.length; i++)
                          InkWell(
                            onTap: () {
                              _currentIndex = i;

                              Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList, true);
                              Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.preDefinedWatchListeners[InAppSelection.marketWatchID].watchList, true);

                              print(_currentIndex);
                              setState(() {
                                InAppSelection.marketWatchID = i;
                                _currentIndex = i;
                                _tabController.animateTo(i, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                              });

                            },
                            onLongPress: () {
                              _currentIndex = i;
                              print(_currentIndex);
                              setState(() {
                                InAppSelection.marketWatchID = i;
                                _currentIndex = i;
                                _tabController.animateTo(i, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                              });

                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) => WatchListSelector(_currentIndex),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Tab(
                              child: Row(
                                mainAxisAlignment: _currentIndex == i ? MainAxisAlignment.center : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    InAppSelection.tabsView[i][0].toString(),
                                    style: Utils.fonts(size: _currentIndex == i ? 13.0 : 12.0, color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor),
                                  ),
                                  const SizedBox(width: 8),
                                  InAppSelection.tabsView[i][1].toString() != "predefined"
                                      ? CircleAvatar(
                                          backgroundColor: _currentIndex == i ? Utils.primaryColor : Utils.greyColor,
                                          foregroundColor: Utils.whiteColor,
                                          maxRadius: 11,
                                          child: Observer(builder: (context) {
                                            return Text(InAppSelection.tabsView[i][0].toString() == "Holdings"
                                                ? HoldingController.HoldigsLength.toString()
                                                : Dataconstants.marketWatchListeners[i].getWatchLength().toString());
                                          }))
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: CustomTabBarScrollPhysics(),
                controller: _tabController,
                children: getTabBarView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var titleColumn = <DataColumn>[];

  Future<void> generateLandscapeData() async {
    titleColumn = <DataColumn>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var finalValues = prefs.getString("editColumns") ?? "";
    if (finalValues != "") {
      List newValue = jsonDecode(finalValues);
      for (var i = 0; i < newValue.length; i++) {
        if (newValue[i][1] == true)
          titleColumn.add(DataColumn(
            label: Text(newValue[i][0].toString()),
          ));
      }
    }
  }

  landScapeMode() async {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        children: [
          DataTable(columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Code'),
            ),
            DataColumn(
              label: Text('Quantity'),
            ),
            DataColumn(
              label: Text('Amount'),
            ),
          ], rows: [
            DataRow(cells: [
              DataCell(Text('1')),
              DataCell(Text('Arshik')),
              DataCell(Text('5644645')),
              DataCell(Text('3')),
              DataCell(Text('265\$')),
            ])
          ])
        ],
      ),
    )));
  }

  getTabBarView() {
    var tabView = <Widget>[];
    for (var i = 0; i < 4; i++) {
      if (InAppSelection.tabsView[i][0].toString().toUpperCase() == "HOLDINGS") {
        tabView.add(HoldingsWatchList());
      } else if (InAppSelection.tabsView[i][1].toString() == "predefined") {
        tabView.add(PredefinedWatchList(i));
      } else
        tabView.add(JmHoldingWatchlistScreen(i));
    }
    return tabView;
  }

//   @override
//   void initState() {
//     super.initState();
//     Dataconstants.holdingController = Get.put(HoldingController());
//     _tabController = TabController(length: 4, vsync: this)
//       ..addListener(() {
//         setState(() {
//           _currentIndex = _tabController.index;
//         });
//       });
//     /* It was used to set data theme,this code is not required as it working fine */
//     // getThemeData();
//     /* Sending chart request to Bcast of all script available in the current watchlist */
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList
//           .forEach((model) {
//         Dataconstants.itsClient
//             .getChartData(timeInterval: 15, chartPeriod: 'I', model: model);
//       });
//     });
//     if (Dataconstants.oneTimeFiltersLoadWatchlist == 0) {
//       getSortFromPref();
//       Dataconstants.oneTimeFiltersLoadWatchlist++;
//     }
//   }
//
//   void getSortFromPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     /* CurrentSort will be an Map of arrray of string with string 0 or 1 */
//     var currentSort;
//     /* Checking wheather sortSelectionWatchList which is used for saving the sorting data
//       is null or not */
//     if (preferences.getString('sortSelectionWatchList') != null) {
//       currentSort = preferences.getString('sortSelectionWatchList').split(',');
//       if (currentSort.first == 'Name') {
//         int _filterByName = int.parse(currentSort.last);
//         /* 1 mean ascending order by name
//            0 mean descending order by name */
//         if (_filterByName == 1)
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyName(false);
//         else
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyName(true);
//       }
//       if (currentSort.first == 'Price') {
//         int _filterByPrice = int.parse(currentSort.last);
//         /* 1 mean ascending order by price
//            0 mean descending order by price */
//         if (_filterByPrice == 1)
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyPrice(false);
//         else
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyPrice(true);
//       }
//       if (currentSort.first == 'Percentage') {
//         int _filterByPercent = int.parse(currentSort.last);
//         /* 1 mean ascending order by Percent
//            0 mean descending order by Percent */
//         if (_filterByPercent == 1)
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyPercent(false);
//         else
//           Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
//               .sortListbyPercent(true);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     counter = 0;
//     var theme = Theme.of(context);
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(120),
//         child: Container(
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//               color: Colors.grey[200],
//               offset: Offset(0, 2.0),
//               blurRadius: 4.0,
//             )
//           ]),
//           child: AppBar(
//             backgroundColor: Utils.whiteColor,
//             title: Text(
//               "Watchlist",
//               style: Utils.fonts(
//                   size: 18.0,
//                   fontWeight: FontWeight.w600,
//                   color: theme.textTheme.bodyText1.color),
//             ),
//             elevation: 0,
//             actions: [

//               InkWell(
//                   onTap: () {
//                     FocusManager.instance.primaryFocus.unfocus();
//                     showModalBottomSheet<void>(
//                       isScrollControlled: true,
//                       context: context,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               topRight: Radius.circular(10))),
//                       builder: (BuildContext context) => OrderBookFilters(
//                           Dataconstants.orderBookData
//                               .getOrderBookSegmentFilterMap()),
//                     );
//                   },
//                   child: SvgPicture.asset('assets/appImages/tranding.svg')),
//               SizedBox(
//                 width: 10,
//               ),
//               Icon(
//                 Icons.more_vert,
//                 color: Utils.greyColor,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//             bottom: PreferredSize(
//               preferredSize: Size.fromHeight(60.0),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
//                   child: TabBar(
//                     isScrollable: true,
//                     labelStyle:
//                     Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
//                     unselectedLabelStyle:
//                     Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
//                     unselectedLabelColor: Colors.grey[600],
//                     labelColor: Utils.primaryColor,
//                     indicatorPadding: EdgeInsets.zero,
//                     labelPadding: EdgeInsets.symmetric(horizontal: 20),
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     indicatorWeight: 0,
//                     indicator: BubbleTabIndicator(
//                       indicatorHeight: 40.0,
//                       insets: EdgeInsets.symmetric(horizontal: 2),
//                       indicatorColor: Utils.primaryColor.withOpacity(0.3),
//                       tabBarIndicatorSize: TabBarIndicatorSize.tab,
//                     ),
//                     controller: _tabController,
//                     tabs: [
//                       Tab(
//                         child: Row(
//                           mainAxisAlignment: _currentIndex == 0
//                               ? MainAxisAlignment.center
//                               : MainAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Holdings',
//                             ),
//                             if (_currentIndex == 0) const SizedBox(width: 8),
//                             if (_currentIndex == 0)
//                               Obx(() {
//                                 return HoldingController.isLoading.value
//                                     ? SizedBox.shrink()
//                                     : Visibility(
//                                   visible:
//                                   HoldingController.isLoading.value ==
//                                       true
//                                       ? false
//                                       : true,
//                                   child: CircleAvatar(
//                                     backgroundColor: _tabController.index == 0
//                                         ? theme.primaryColor
//                                         : Colors.grey,
//                                     foregroundColor: Colors.white,
//                                     maxRadius: 11,
//                                     child: Text(
//                                       '${HoldingController.HoldigsLength}',
//                                       style: const TextStyle(fontSize: 12),
//                                     ),
//                                   ),
//                                 );
//                               })
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           mainAxisAlignment: _currentIndex == 1
//                               ? MainAxisAlignment.center
//                               : MainAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'My List 2',
//                             ),
//                             if (_currentIndex == 1) const SizedBox(width: 8),
//                             if (_currentIndex == 1)
//                               CircleAvatar(
//                                   backgroundColor: _currentIndex == 1
//                                       ? Utils.primaryColor
//                                       : Utils.greyColor,
//                                   foregroundColor: Utils.whiteColor,
//                                   maxRadius: 11,
//                                   child: Text('2'))
//                             // Obx(() {
//                             //   return tabBar
//                             //       ? SizedBox.shrink()
//                             //       : Visibility(
//                             //     visible:
//                             //     tabBar == true
//                             //         ? false
//                             //         : true,
//                             //     child: CircleAvatar(
//                             //       backgroundColor: _tabController.index == 0
//                             //           ? theme.primaryColor
//                             //           : Colors.grey,
//                             //       foregroundColor: Colors.white,
//                             //       maxRadius: 11,
//                             //       child: Text('2',
//                             //         style: const TextStyle(fontSize: 12),
//                             //       ),
//                             //     ),
//                             //   );
//                             // })
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           mainAxisAlignment: _currentIndex == 2
//                               ? MainAxisAlignment.center
//                               : MainAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'My List 3',
//                             ),
//                             if (_currentIndex == 2) const SizedBox(width: 8),
//                             if (_currentIndex == 2)
//                               CircleAvatar(
//                                   backgroundColor: _currentIndex == 2
//                                       ? Utils.primaryColor
//                                       : Utils.greyColor,
//                                   foregroundColor: Utils.whiteColor,
//                                   maxRadius: 11,
//                                   child: Text('2'))
//                             // Obx(() {
//                             //   return tabBar
//                             //       ? SizedBox.shrink()
//                             //       : Visibility(
//                             //     visible:
//                             //     tabBar == true
//                             //         ? false
//                             //         : true,
//                             //     child: CircleAvatar(
//                             //       backgroundColor: _tabController.index == 0
//                             //           ? theme.primaryColor
//                             //           : Colors.grey,
//                             //       foregroundColor: Colors.white,
//                             //       maxRadius: 11,
//                             //       child: Text('2',
//                             //         style: const TextStyle(fontSize: 12),
//                             //       ),
//                             //     ),
//                             //   );
//                             // })
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           mainAxisAlignment: _currentIndex == 2
//                               ? MainAxisAlignment.center
//                               : MainAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'My List 4',
//                             ),
//                             if (_currentIndex == 2) const SizedBox(width: 8),
//                             if (_currentIndex == 2)
//                               CircleAvatar(
//                                   backgroundColor: _currentIndex == 2
//                                       ? Utils.primaryColor
//                                       : Utils.greyColor,
//                                   foregroundColor: Utils.whiteColor,
//                                   maxRadius: 11,
//                                   child: Text('2'))
//                             // Obx(() {
//                             //   return tabBar
//                             //       ? SizedBox.shrink()
//                             //       : Visibility(
//                             //     visible:
//                             //     tabBar == true
//                             //         ? false
//                             //         : true,
//                             //     child: CircleAvatar(
//                             //       backgroundColor: _tabController.index == 0
//                             //           ? theme.primaryColor
//                             //           : Colors.grey,
//                             //       foregroundColor: Colors.white,
//                             //       maxRadius: 11,
//                             //       child: Text('2',
//                             //         style: const TextStyle(fontSize: 12),
//                             //       ),
//                             //     ),
//                             //   );
//                             // })
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//           ),
//         ),
//       )
//       ,
//       body: TabBarView(
//         physics: CustomTabBarScrollPhysics(),
//         controller: _tabController,
//         children: [
//             HoldingWatchlistScreen(),
//           HoldingWatchlistScreen(),
//           HoldingWatchlistScreen(),
//           HoldingWatchlistScreen()
//
//         ],
//       ),
//     );
//   }
//
//   void showEditWatchListScreen() {
//     HapticFeedback.vibrate();
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => WatchListEditScreen(InAppSelection.marketWatchID),
//       ),
//     );
//   }
// }
//
// class MarketWatchRow extends StatelessWidget {
//   const MarketWatchRow(
//       this.index,
//       );
//
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     /* kept this code if required in future */
//     // bool containsNews = Dataconstants.todayNews.todayNewsInScrip(Dataconstants
//     //     .marketWatchListeners[InAppSelection.marketWatchID]
//     //     .watchList[index]
//     //     .exchCode);
//     var theme = Theme.of(context);
//     return InkWell(
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(25.0),
//               topRight: Radius.circular(25.0),
//             ),
//           ),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           builder: (builder) {
//             return DraggableScrollableSheet(
//               /* This initialChildSize is working, do not change it */
//               /* Coding sigma rule no.1: Dont touch the code if its working */
//               initialChildSize: MediaQuery.of(context).size.height * 0.0009,
//               minChildSize: 0.50,
//               maxChildSize: 1,
//               expand: false,
//               builder:
//                   (BuildContext context, ScrollController scrollController) {
//                 return ScripDetailsScreen(
//                   model: Dataconstants
//                       .marketWatchListeners[InAppSelection.marketWatchID]
//                       .watchList[index],
//                   scrollController: scrollController,
//                 );
//               },
//             );
//           },
//         );
//         /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */
//         // Navigator.of(context).push(
//         //   MaterialPageRoute(
//         //     builder: (context) => ScripDetailsScreen(
//         //       model: Dataconstants
//         //           .marketWatchListeners[InAppSelection.marketWatchID]
//         //           .watchList[index],
//         //     ),
//         //   ),
//         // );
//       },
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(
//               left: 15,
//               top: 15,
//               bottom: 15,
//               right: 5,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 /* Displaying the Script details */
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       /* Displaying the Script name */
//                       Text(
//                           Dataconstants
//                               .marketWatchListeners[
//                           InAppSelection.marketWatchID]
//                               .watchList[index]
//                               .name
//                               .toUpperCase(),
//                           style: Utils.fonts(
//                               size: 14.0, fontWeight: FontWeight.w600)
//                         // style: TextStyle(
//                         //   fontSize: 15,
//                         // ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       FittedBox(
//                         child: Row(
//                           children: [
//                             /* Displaying the Script exchange Name */
//                             Text(
//                                 Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .exchName
//                                     .toUpperCase(),
//                                 style: Utils.fonts(
//                                     size: 11.0,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.grey)
//                               // style: const TextStyle(
//                               //     fontSize: 13, color: Colors.grey),
//                             ),
//                             const SizedBox(
//                               width: 4,
//                             ),
//                             /* Displaying the Script Description */
//                             Text(
//                                 Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .marketWatchDesc
//                                     .toUpperCase(),
//                                 style: Utils.fonts(
//                                   size: 11.0,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey,
//                                 )
//                               // style: const TextStyle(
//                               //   fontSize: 13,
//                               //   color: Colors.grey,
//                               // ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 /* Displaying the Script chart */
//                 Expanded(
//                   flex: 1,
//                   child: Observer(
//                     /* Checking if we got the chart data of the current script by checking its array length,
//                      if not then shrink. The UI will throw erreo */
//                     builder: (context) => Dataconstants
//                         .marketWatchListeners[
//                     InAppSelection.marketWatchID]
//                         .watchList[index]
//                         .chartMinClose[15]
//                         .length >
//                         0
//                         ? SmallSimpleLineChart(
//                       seriesList: Dataconstants
//                           .marketWatchListeners[
//                       InAppSelection.marketWatchID]
//                           .watchList[index]
//                           .dataPoint[15],
//                       prevClose: Dataconstants
//                           .marketWatchListeners[
//                       InAppSelection.marketWatchID]
//                           .watchList[index]
//                           .prevDayClose,
//                       name: Dataconstants
//                           .marketWatchListeners[
//                       InAppSelection.marketWatchID]
//                           .watchList[index]
//                           .name,
//                     )
//                         : const SizedBox.shrink(),
//                   ),
//                 ),
//                 /* Deiplaying the feeds of the script */
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       /* Displaying the feed of the script */
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Observer(
//                             builder: (_) => AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               width: 90,
//                               alignment: Alignment.centerRight,
//                               decoration: BoxDecoration(
//                                 color: Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .close >
//                                     Dataconstants
//                                         .marketWatchListeners[
//                                     InAppSelection.marketWatchID]
//                                         .watchList[index]
//                                         .prevTickRate
//                                     ? ThemeConstants.buyColor
//                                     : Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection
//                                     .marketWatchID]
//                                     .watchList[index]
//                                     .close <
//                                     Dataconstants
//                                         .marketWatchListeners[
//                                     InAppSelection
//                                         .marketWatchID]
//                                         .watchList[index]
//                                         .prevTickRate
//                                     ? ThemeConstants.sellColor
//                                     : theme.errorColor,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                               padding: const EdgeInsets.only(
//                                 top: 4,
//                                 bottom: 4,
//                                 left: 10,
//                                 right: 5,
//                               ),
//                               child: Text(
//                                 /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
//                                   Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList[index].close == 0.00
//                                       ? Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection.marketWatchID]
//                                       .watchList[index]
//                                       .prevDayClose
//                                       .toStringAsFixed(Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection
//                                       .marketWatchID]
//                                       .watchList[index]
//                                       .series ==
//                                       'Curr'
//                                       ? 4
//                                       : 2)
//                                       : Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection.marketWatchID]
//                                       .watchList[index]
//                                       .close
//                                       .toStringAsFixed(Dataconstants
//                                       .marketWatchListeners[InAppSelection.marketWatchID]
//                                       .watchList[index]
//                                       .series ==
//                                       'Curr'
//                                       ? 4
//                                       : 2),
//                                   style: Utils.fonts(
//                                     size: 14.0,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   )
//                                 // style:
//                                 //
//                                 // const TextStyle(
//                                 //     fontSize: 16,
//                                 //     color: Colors.white,
//                                 //     fontWeight: FontWeight.w700),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       /* Displaying the price change and percentage change of the script */
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           /* Displaying the price change of the script */
//                           Observer(
//                             builder: (_) => Text(
//                               /* If the LTP is zero before or after market time, it is showing zero instead of price change */
//                                 Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .close ==
//                                     0.00
//                                     ? "0.00"
//                                     : Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .priceChangeText,
//                                 style: Utils.fonts(
//                                   size: 12.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection.marketWatchID]
//                                       .watchList[index]
//                                       .priceChange >
//                                       0
//                                       ? ThemeConstants.buyColor
//                                       : Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection
//                                       .marketWatchID]
//                                       .watchList[index]
//                                       .priceChange <
//                                       0
//                                       ? ThemeConstants.sellColor
//                                       : theme.textTheme.bodyText1.color,
//                                 )
//
//                               // style: TextStyle(
//                               //   color: Dataconstants
//                               //               .marketWatchListeners[
//                               //                   InAppSelection.marketWatchID]
//                               //               .watchList[index]
//                               //               .priceChange >
//                               //           0
//                               //       ? ThemeConstants.buyColor
//                               //       : Dataconstants
//                               //                   .marketWatchListeners[
//                               //                       InAppSelection
//                               //                           .marketWatchID]
//                               //                   .watchList[index]
//                               //                   .priceChange <
//                               //               0
//                               //           ? ThemeConstants.sellColor
//                               //           : theme.textTheme.bodyText1.color,
//                               // ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           /* Displaying the percentage change of the script */
//                           Observer(
//                             builder: (_) => Text(
//                               /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
//                                 Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .close ==
//                                     0.00
//                                     ? "(0.00%)"
//                                     : Dataconstants
//                                     .marketWatchListeners[
//                                 InAppSelection.marketWatchID]
//                                     .watchList[index]
//                                     .percentChangeText,
//                                 style: Utils.fonts(
//                                   size: 12.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection.marketWatchID]
//                                       .watchList[index]
//                                       .percentChange >
//                                       0
//                                       ? ThemeConstants.buyColor
//                                       : Dataconstants
//                                       .marketWatchListeners[
//                                   InAppSelection
//                                       .marketWatchID]
//                                       .watchList[index]
//                                       .percentChange <
//                                       0
//                                       ? ThemeConstants.sellColor
//                                       : theme.textTheme.bodyText1.color,
//                                 )
//                               // style: TextStyle(
//                               //   color: Dataconstants
//                               //               .marketWatchListeners[
//                               //                   InAppSelection.marketWatchID]
//                               //               .watchList[index]
//                               //               .percentChange >
//                               //           0
//                               //       ? ThemeConstants.buyColor
//                               //       : Dataconstants
//                               //                   .marketWatchListeners[
//                               //                       InAppSelection
//                               //                           .marketWatchID]
//                               //                   .watchList[index]
//                               //                   .percentChange <
//                               //               0
//                               //           ? ThemeConstants.sellColor
//                               //           : theme.textTheme.bodyText1.color,
//                               // ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(
//             height: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
}

class ReplaceWatchList extends StatefulWidget {
  var newWatchListName;

  ReplaceWatchList(this.newWatchListName);

  @override
  State<ReplaceWatchList> createState() => _ReplaceWatchListState();
}

class _ReplaceWatchListState extends State<ReplaceWatchList> {
  var allWatchlist = [];

  var selectedIndex = -1;

  @override
  void initState() {
    for (var i = 0; i < WatchlistDatabase.allWatchlist.length; i++) {
      allWatchlist.add([WatchlistDatabase.allWatchlist[i]["watchListNo"].toString(), WatchlistDatabase.allWatchlist[i]["watchListName"], WatchlistDatabase.allWatchlist[i]["position"].toString()]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Replace WatchList With?",
                      style: Utils.fonts(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (var i = 0; i < 4; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                WatchlistDatabase.allWatchlist[i]["watchListName"].toString(),
                                style: Utils.fonts(),
                              ),
                              Spacer(),
                              selectedIndex == i
                                  ? SvgPicture.asset(
                                      "assets/appImages/selectedCircle.svg",
                                      height: 20,
                                      width: 20,
                                    )
                                  : SvgPicture.asset(
                                      "assets/appImages/unselectedRadio.svg",
                                      height: 20,
                                      width: 20,
                                    )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.5,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          var newWatchListNo = int.parse(WatchlistDatabase.lastWatchListIndex.toString());
                          newWatchListNo++;
                          var element = allWatchlist[selectedIndex];
                          allWatchlist.removeAt(selectedIndex);
                          allWatchlist.insert(selectedIndex, [newWatchListNo.toString(), widget.newWatchListName, selectedIndex.toString()]);
                          allWatchlist.add(element);
                          var fromIndex = selectedIndex;
                          fromIndex++;
                          for (var i = fromIndex; i < allWatchlist.length; i++) {
                            allWatchlist[i][2] = (i).toString();
                          }

                          var FinalWatchList = [];
                          for (var i = 0; i < allWatchlist.length; i++) {
                            FinalWatchList.add({
                              "watchListNo": allWatchlist[i][0],
                              "watchListName": allWatchlist[i][1],
                              "position": allWatchlist[i][2],
                            });
                          }

                          await WatchlistDatabase.instance.addNewWatchlist(newWatchListNo.toString(), widget.newWatchListName.toString(), selectedIndex.toString());

                          await WatchlistDatabase.instance.replaceAllWatchList(FinalWatchList);

                          //print(allWatchlist.length);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          child: Text(
                            "Replace",
                            style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
