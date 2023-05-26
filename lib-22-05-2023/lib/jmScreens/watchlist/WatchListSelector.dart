import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markets/controllers/watchListController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/watchlist_database.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../../widget/predefined_marketwatch.dart';
import 'displaySettings.dart';

class WatchListSelector extends StatefulWidget {
  var watchListNo;

  WatchListSelector(this.watchListNo);

  @override
  State<WatchListSelector> createState() => _WatchListSelectorState();
}

class _WatchListSelectorState extends State<WatchListSelector> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  TextEditingController userSearchController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _currentIndex = Dataconstants.defaultWatchList;
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    userSearchController = TextEditingController();

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown
    // ]);

    // if (InAppSelection.newUserToIndices == false)
    //   _tabController.index = 0;
    // else {
    //   getnewUserToIndices();
    //   _tabController.index = 1;
    // }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 0.7 * height,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              TabBar(
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
                  setState(() {
                    _currentIndex = _index;
                  });
                },
                tabs: [
                  Tab(
                    child: Text(
                      "User Defined",
                      style: Utils.fonts(
                        size: _currentIndex == 0 ? 13.0 : 12.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Pre Defined",
                      style: Utils.fonts(
                        size: _currentIndex == 0 ? 13.0 : 12.0,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Dynamic",
                      style: Utils.fonts(
                        size: _currentIndex == 0 ? 13.0 : 12.0,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySettings()));
                  },
                  child: Icon(Icons.settings)),
              SizedBox(
                width: 10,
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: CustomTabBarScrollPhysics(),
              controller: _tabController,
              children: [
                UserDefinedList(widget.watchListNo),
                preDefined(),
                scanners()
              ],
            ),
          ),
        ],
      ),
    );
  }

  preDefined() {
    var index = 0;
    if (widget.watchListNo == -1)
      index = 0;
    else
      index = widget.watchListNo;

    return newPredefinedGroupPicker(index);
  }

  userDefined() {
    var searchedValue = "";
    var width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);

    var nameList = [];
    List<nameListData> _listNameList = [];
    for (var j = 0; j < WatchlistDatabase.allWatchlist.length; j++) {
      nameList.add([WatchlistDatabase.allWatchlist[j]["watchListName"].toString(), false]);
      for (var i = 0; i < InAppSelection.tabsView.length; i++) {
        if (InAppSelection.tabsView[i][0].toString() == WatchlistDatabase.allWatchlist[j]["watchListName"].toString()) {
          nameList[nameList.length - 1] = [WatchlistDatabase.allWatchlist[j]["watchListName"].toString(), true];
          break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 2,
            width: width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Total Watchlist (${WatchlistDatabase.allWatchlist.length})", style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
              Spacer(),
              InkWell(
                onTap: () {
                  createWatchList();
                },
                child: Row(
                  children: [
                    Text("Create Watchlist", style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add_circle,
                      color: Utils.primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            width: width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              color: theme.accentColor,
              child: TextField(
                controller: userSearchController,
                onChanged: (value) {
                  setState(() {
                    searchedValue = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Watchlist',
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  labelStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  suffixIcon: IconButton(
                    onPressed: () {
                      userSearchController.clear();
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  for (var i = 0; i < WatchlistDatabase.allWatchlist.length; i++)
                    (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase().contains(searchedValue.toString().toUpperCase()) || searchedValue.isEmpty)
                        ? InkWell(
                            onTap: () async {
                              if (nameList[i][1]) {
                                CommonFunction.CustomToast(Icons.error, "Already Added", 0);
                                return;
                              }
                              if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() == "HOLDINGS")
                                InAppSelection.tabsView[widget.watchListNo] = ["Holdings", "holdings", "na"];
                              else
                                InAppSelection.tabsView[widget.watchListNo] = [
                                  WatchlistDatabase.allWatchlist[i]["watchListName"].toString(),
                                  "watchlist",
                                  WatchlistDatabase.allWatchlist[i]["watchListNo"].toString()
                                ];
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var finalTabs = json.encode(InAppSelection.tabsView);
                              prefs.setString("tabsView", finalTabs);
                              WatchlistDatabase.getAllWatchList();
                              Dataconstants.isTabChanged = true;
                              // await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(nameList[i][0].toString(), style: Utils.fonts(color: Utils.blackColor, size: 17.0)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                color: nameList[i][1] ? Utils.primaryColor.withOpacity(0.7) : Utils.mediumGreenColor.withOpacity(0.7)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                                              child: Text(nameList[i][1] ? "Already Added" : "Tap To Load", style: Utils.fonts(color: Utils.whiteColor, size: 11.0, fontWeight: FontWeight.w500)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                                        InkWell(
                                          onTap: () {
                                            // renameWatchList(i, WatchlistDatabase.allWatchlist[i]["watchListName"].toString());
                                            renameWatchList(i,_listNameList[i].name);
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.edit,
                                              color: Utils.greyColor.withOpacity(0.5),
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                                        InkWell(
                                          onTap: () {
                                            // if(InAppSelection.tabsView.length>4)
                                            print(nameList[i][0].toString());
                                            if (nameList.length > 5) {
                                              CommonFunction.deleteWatchList(context, i, nameList[i][0].toString()).then((value) => setState(() {
                                                print("");
                                              }));
                                            }
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.delete,
                                              color: Utils.greyColor.withOpacity(0.5),
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Utils.greyColor.withOpacity(0.5),
                                          size: 20.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 2,
                                    width: width * 0.9,
                                    color: Utils.greyColor.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  scanners() {
    return newPredefinedGroupPicker(_currentIndex);
  }

  renameWatchList(index, name) {
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
          return RenameWatchListBottomSheet(index, name);
        });
  }

  createWatchList() {
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
          return CreateWatchListBottomSheet();
        }).then((value) {
      setState(() {});
    });
  }
}

class UserDefinedList extends StatefulWidget {
  var watchListNo;

  UserDefinedList(this.watchListNo);

  @override
  State<UserDefinedList> createState() => _UserDefinedListState();
}

class _UserDefinedListState extends State<UserDefinedList> {
  renameWatchList(index, name) {
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
          return RenameWatchListBottomSheet(index, name);
        }).then((value) {
      setState(() {});
    });
  }

  createWatchList() {
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

          return CreateWatchListBottomSheet();
        }).then((value) {
      setState(() {});
    });
  }

  TextEditingController userSearchController;

  @override
  void initState() {
    userSearchController = TextEditingController();
    Dataconstants.listNameList.clear();
    super.initState();
  }

  var searchedValue = "";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    Dataconstants.listNameList.clear();
    //Bhavesh
    var nameList = [];


    if(Dataconstants.isReorderWatchlist == true){
      for (var j = 0; j < Dataconstants.nameListWatchList.length; j++) {

        if (Dataconstants.nameListWatchList.length > 0) {
          //print(Dataconstants.nameListWatchList[j][0].toString());

          Dataconstants.listNameList.add(
              nameListData(
                  id: Dataconstants.nameListWatchList[j].id,
                  name: Dataconstants.nameListWatchList[j].name,
                  flag: false
              ));

          for (var i = 0; i < InAppSelection.tabsView.length; i++) {
            print(InAppSelection.tabsView[i][0].toString());
            print(Dataconstants.nameListWatchList[0].name);

            if (InAppSelection.tabsView[i][0].toString() == Dataconstants.nameListWatchList[j].name.toString()) {
              // nameList[nameList.length - 1] = [Dataconstants.nameListWatchList[j][0].toString(), true];

              Dataconstants.listNameList[Dataconstants.listNameList.length - 1] =
                  nameListData(
                      id: int.parse(WatchlistDatabase.allWatchlist[i]["watchListNo"].toString().trim()),
                      name: WatchlistDatabase.allWatchlist[i]["watchListName"].toString(),
                      flag: true
                  );

              break;
            }
          }

          Dataconstants.isReorderWatchlist = false;
        }

      }
    }else{
      for (var j = 0; j < WatchlistDatabase.allWatchlist.length; j++) {

        // nameList.add([WatchlistDatabase.allWatchlist[j]["watchListName"].toString(), false,WatchlistDatabase.allWatchlist[j]["watchListName"]]);

        Dataconstants.listNameList.add(
            nameListData(
                id: int.parse(WatchlistDatabase.allWatchlist[j]["watchListNo"].toString().trim()),
                name: WatchlistDatabase.allWatchlist[j]["watchListName"].toString().trim(),
                flag: false
            ));

        for (var i = 0; i < InAppSelection.tabsView.length; i++) {
          if (InAppSelection.tabsView[i][0].toString() == WatchlistDatabase.allWatchlist[j]["watchListName"].toString()) {
            Dataconstants.listNameList[Dataconstants.listNameList.length - 1] =
                nameListData(
                    id: int.parse(WatchlistDatabase.allWatchlist[j]["watchListNo"].toString().trim()),
                    name: WatchlistDatabase.allWatchlist[j]["watchListName"].toString(),
                    flag: true
                );
            break;
          }
        }

      }
      for(int i=0; i < WatchListController.WatchList.length;i++){
        Dataconstants.listNameList.add(
            nameListData(
                id: int.parse(WatchListController.WatchList[i].watchlistId.toString().trim()),
                name: WatchListController.WatchList[i].watchlistName.toString().trim(),
                flag: false
            ));
        // nameList.add([WatchListController.WatchList[i].watchlistName,false,WatchListController.WatchList[i].watchlistId]);
      }
    }




    //Bhavesh

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 2,
            width: width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Total Watchlist (${Dataconstants.listNameList.length})", style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
              Spacer(),
              InkWell(
                onTap: () {
                  createWatchList();
                },
                child: Row(
                  children: [
                    Text("Create Watchlist", style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add_circle,
                      color: Utils.primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            width: width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              color: theme.accentColor,
              child: TextField(
                controller: userSearchController,
                onChanged: (value) {
                  setState(() {
                    searchedValue = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Watchlist',
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  labelStyle: Utils.fonts(size: 15.0, fontWeight: FontWeight.w600),
                  suffixIcon: IconButton(
                    onPressed: () {
                      userSearchController.clear();
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (var i = 0; i < Dataconstants.listNameList.length; i++)
                        InkWell(
                          key: Key('$i'),
                          onTap: () async {
                            if (Dataconstants.listNameList[i].flag) {
                              CommonFunction.CustomToast(Icons.error, "Already Added", 0);
                              return;
                            }


                            if(Dataconstants.listNameList[i].name == "Holdings"){
                              Dataconstants.holdingController.fetchHolding();
                              Dataconstants.holdingController.fetchMtfHolding();
                            }


                            // if (nameList[i][0].toString().toUpperCase() == "HOLDINGS")
                            //   InAppSelection.tabsView[i] = ["Holdings", "holdings", "na"];
                            // else
                            //   InAppSelection.tabsView.add([
                            //     nameList[i][0].toString(),
                            //     "watchlist",
                            //     nameList[i][2].toString()
                            //   ]);

                            // else
                            //   InAppSelection.tabsView[i] = [
                            //     nameList[i][0].toString(),
                            //     "watchlist",
                            //     nameList[i][2].toString()
                            //   ];\


                            print(widget.watchListNo);


                            if (Dataconstants.listNameList[i].name.toString().toUpperCase() == "HOLDINGS")
                              InAppSelection.tabsView[widget.watchListNo] = ["Holdings", "holdings", "na"];
                            else
                              InAppSelection.tabsView[widget.watchListNo] = [
                                Dataconstants.listNameList[i].name.toString(),
                                "watchlist",
                                Dataconstants.listNameList[i].id.toString()
                              ];
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var finalTabs = json.encode(InAppSelection.tabsView);
                            prefs.setString("tabsView", finalTabs);
                            var lastPosition = WatchlistDatabase.allWatchlist.length;
                            WatchlistDatabase.instance.addNewWatchlist(Dataconstants.listNameList[i].id,Dataconstants.listNameList[i].name,lastPosition);
                            WatchlistDatabase.getAllWatchList();
                            Dataconstants.listNameList.removeAt(i);
                            Dataconstants.isTabChanged = true;
                            // await Future.delayed(Duration(seconds: 1));
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(Dataconstants.listNameList[i].name.toString(), style: Utils.fonts(color: Utils.blackColor, size: 17.0)),
                                        // Text(InAppSelection.tabsView[i][0].toString(), style: Utils.fonts(color: Utils.blackColor, size: 17.0)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Dataconstants.listNameList[i].flag ? Utils.primaryColor.withOpacity(0.7) : Utils.mediumGreenColor.withOpacity(0.7)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                                            child: Text(Dataconstants.listNameList[i].flag ? "Already Added" : "Tap To Load", style: Utils.fonts(color: Utils.whiteColor, size: 11.0, fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                                    if (Dataconstants.listNameList[i].name.toString().toUpperCase() != "HOLDINGS")
                                      InkWell(
                                        onTap: () {
                                          // renameWatchList(i, WatchlistDatabase.allWatchlist[i]["watchListName"].toString());
                                          renameWatchList(i,Dataconstants.listNameList[i].name);


                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            color: Utils.greyColor.withOpacity(0.5),
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    // if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                                    if (Dataconstants.listNameList[i].name.toString().toUpperCase() != "HOLDINGS")
                                      InkWell(
                                        onTap: () async {
                                          // print(nameList[i][0].toString());
                                          // if(Dataconstants.listNameList[i].name.toString() == WatchlistDatabase.allWatchlist[i]["watchListName"].toString()){
                                          //   await CommonFunction.deleteWatchList(context, WatchlistDatabase.allWatchlist[i]["watchListNo"], WatchlistDatabase.allWatchlist[i]["watchListName"]).then((value) => setState(() {}));
                                            await CommonFunction.deleteWatchList(context, Dataconstants.listNameList[i].id,Dataconstants.listNameList[i].name).then((value) => setState(() {}));
                                            if (Dataconstants.loginData.watchlistFlag.toString() == "true")
                                              await Dataconstants.watchListController.checkWatchList();
                                          // }
                                          // if (nameList[i].length > 5) {
                                          //   await CommonFunction.deleteWatchList(context, i, nameList[i][0].toString()).then((value) => setState(() {}));
                                            // await Future.delayed(
                                            //     Duration(seconds: 1));
                                            // setState(() {});
                                          // }
                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: Utils.greyColor.withOpacity(0.5),
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Utils.greyColor.withOpacity(0.5),
                                        size: 20.0,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 2,
                                  width: width * 0.9,
                                  color: Utils.greyColor.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // for (var i = 0; i < InAppSelection.tabsView.length; i++)
                      //   InkWell(
                      //     key: Key('$i'),
                      //     child: Text(InAppSelection.tabsView[i][0]),
                      //   )
                        // InkWell(
                        //   key: Key('$i'),
                        //   onTap: () async {
                        //     if (nameList[i][1]) {
                        //       CommonFunction.CustomToast(Icons.error, "Already Added", 0);
                        //       return;
                        //     }
                        //     if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() == "HOLDINGS")
                        //       InAppSelection.tabsView[widget.watchListNo] = ["Holdings", "holdings", "na"];
                        //     else
                        //       InAppSelection.tabsView[widget.watchListNo] = [
                        //         WatchlistDatabase.allWatchlist[i]["watchListName"].toString(),
                        //         "watchlist",
                        //         WatchlistDatabase.allWatchlist[i]["watchListNo"].toString()
                        //       ];
                        //     SharedPreferences prefs = await SharedPreferences.getInstance();
                        //     var finalTabs = json.encode(InAppSelection.tabsView);
                        //     prefs.setString("tabsView", finalTabs);
                        //     WatchlistDatabase.getAllWatchList();
                        //     Dataconstants.isTabChanged = true;
                        //     // await Future.delayed(Duration(seconds: 1));
                        //     Navigator.pop(context);
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(nameList[i][0].toString(), style: Utils.fonts(color: Utils.blackColor, size: 17.0)),
                        //                 // Text(InAppSelection.tabsView.toString(), style: Utils.fonts(color: Utils.blackColor, size: 17.0)),
                        //                 SizedBox(
                        //                   height: 5,
                        //                 ),
                        //                 Container(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        //                       color: nameList[i][1] ? Utils.primaryColor.withOpacity(0.7) : Utils.mediumGreenColor.withOpacity(0.7)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                        //                     child: Text(nameList[i][1] ? "Already Added" : "Tap To Load", style: Utils.fonts(color: Utils.whiteColor, size: 11.0, fontWeight: FontWeight.w500)),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //               ],
                        //             ),
                        //             Spacer(),
                        //             if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                        //               InkWell(
                        //                 onTap: () {
                        //                   renameWatchList(i, WatchlistDatabase.allWatchlist[i]["watchListName"].toString());
                        //                 },
                        //                 child: Center(
                        //                   child: Icon(
                        //                     Icons.edit,
                        //                     color: Utils.greyColor.withOpacity(0.5),
                        //                     size: 20.0,
                        //                   ),
                        //                 ),
                        //               ),
                        //             SizedBox(
                        //               width: 20,
                        //             ),
                        //             if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString().toUpperCase() != "HOLDINGS")
                        //               InkWell(
                        //                 onTap: () async {
                        //                   if (nameList.length > 5) {
                        //                     await CommonFunction.deleteWatchList(context, i, nameList[i][0].toString()).then((value) => setState(() {}));
                        //                     // await Future.delayed(
                        //                     //     Duration(seconds: 1));
                        //                     // setState(() {});
                        //                   }
                        //                 },
                        //                 child: Center(
                        //                   child: Icon(
                        //                     Icons.delete,
                        //                     color: Utils.greyColor.withOpacity(0.5),
                        //                     size: 20.0,
                        //                   ),
                        //                 ),
                        //               ),
                        //             SizedBox(
                        //               width: 20,
                        //             ),
                        //             Center(
                        //               child: Icon(
                        //                 Icons.arrow_forward_ios_outlined,
                        //                 color: Utils.greyColor.withOpacity(0.5),
                        //                 size: 20.0,
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //         Container(
                        //           height: 2,
                        //           width: width * 0.9,
                        //           color: Utils.greyColor.withOpacity(0.2),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                    ],
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        Dataconstants.isReorderWatchlist = true;
                        Dataconstants.nameListWatchList.clear();
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        var item = Dataconstants.listNameList.removeAt(oldIndex);
                        Dataconstants.listNameList.insert(newIndex, item);
                        //Bhavesh
                        Dataconstants.nameListWatchList.addAll(Dataconstants.listNameList);
                        //Bhavesh
                      });
                    },
                  ),
                  // for (var i = 0;
                  //     i < WatchlistDatabase.allWatchlist.length;
                  //     i++)
                  //   (WatchlistDatabase.allWatchlist[i]["watchListName"]
                  //               .toString()
                  //               .toUpperCase()
                  //               .contains(
                  //                   searchedValue.toString().toUpperCase()) ||
                  //           searchedValue.isEmpty)
                  //       ? InkWell(
                  //           onTap: () async {
                  //             if (nameList[i][1]) {
                  //               CommonFunction.CustomToast(
                  //                   Icons.error, "Already Added", 0);
                  //               return;
                  //             }
                  //             if (WatchlistDatabase.allWatchlist[i]
                  //                         ["watchListName"]
                  //                     .toString()
                  //                     .toUpperCase() ==
                  //                 "HOLDINGS")
                  //               InAppSelection.tabsView[widget.watchListNo] = [
                  //                 "Holdings",
                  //                 "holdings",
                  //                 "na"
                  //               ];
                  //             else
                  //               InAppSelection.tabsView[widget.watchListNo] = [
                  //                 WatchlistDatabase.allWatchlist[i]
                  //                         ["watchListName"]
                  //                     .toString(),
                  //                 "watchlist",
                  //                 WatchlistDatabase.allWatchlist[i]
                  //                         ["watchListNo"]
                  //                     .toString()
                  //               ];
                  //             SharedPreferences prefs =
                  //                 await SharedPreferences.getInstance();
                  //             var finalTabs =
                  //                 json.encode(InAppSelection.tabsView);
                  //             prefs.setString("tabsView", finalTabs);
                  //             WatchlistDatabase.getAllWatchList();
                  //             DataConstants.isTabChanged = true;
                  //             // await Future.delayed(Duration(seconds: 1));
                  //             Navigator.pop(context);
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Column(
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(nameList[i][0].toString(),
                  //                             style: Utils.fonts(
                  //                                 color: Utils.blackColor,
                  //                                 size: 17.0)),
                  //                         SizedBox(
                  //                           height: 5,
                  //                         ),
                  //                         Container(
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.all(
                  //                                   Radius.circular(10.0)),
                  //                               color: nameList[i][1]
                  //                                   ? Utils.primaryColor
                  //                                       .withOpacity(0.7)
                  //                                   : Utils.mediumGreenColor
                  //                                       .withOpacity(0.7)),
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.symmetric(
                  //                                     horizontal: 5.0,
                  //                                     vertical: 3.0),
                  //                             child: Text(
                  //                                 nameList[i][1]
                  //                                     ? "Already Added"
                  //                                     : "Tap To Load",
                  //                                 style: Utils.fonts(
                  //                                     color: Utils.whiteColor,
                  //                                     size: 11.0,
                  //                                     fontWeight:
                  //                                         FontWeight.w500)),
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     Spacer(),
                  //                     if (WatchlistDatabase.allWatchlist[i]
                  //                                 ["watchListName"]
                  //                             .toString()
                  //                             .toUpperCase() !=
                  //                         "HOLDINGS")
                  //                       InkWell(
                  //                         onTap: () {
                  //                           renameWatchList(
                  //                               i,
                  //                               WatchlistDatabase
                  //                                   .allWatchlist[i]
                  //                                       ["watchListName"]
                  //                                   .toString());
                  //                         },
                  //                         child: Center(
                  //                           child: Icon(
                  //                             Icons.edit,
                  //                             color: Utils.greyColor
                  //                                 .withOpacity(0.5),
                  //                             size: 20.0,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     SizedBox(
                  //                       width: 20,
                  //                     ),
                  //                     if (WatchlistDatabase.allWatchlist[i]
                  //                                 ["watchListName"]
                  //                             .toString()
                  //                             .toUpperCase() !=
                  //                         "HOLDINGS")
                  //                       InkWell(
                  //                         onTap: () async {
                  //                           await CommonFunction
                  //                               .deleteWatchList(context, i,
                  //                                   nameList[i][0].toString());
                  //                           await Future.delayed(
                  //                               Duration(seconds: 1));
                  //                           setState(() {});
                  //                         },
                  //                         child: Center(
                  //                           child: Icon(
                  //                             Icons.delete,
                  //                             color: Utils.greyColor
                  //                                 .withOpacity(0.5),
                  //                             size: 20.0,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     SizedBox(
                  //                       width: 20,
                  //                     ),
                  //                     Center(
                  //                       child: Icon(
                  //                         Icons.arrow_forward_ios_outlined,
                  //                         color:
                  //                             Utils.greyColor.withOpacity(0.5),
                  //                         size: 20.0,
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 Container(
                  //                   height: 2,
                  //                   width: width * 0.9,
                  //                   color: Utils.greyColor.withOpacity(0.2),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //       : SizedBox.shrink()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class nameListData{
  int id;
  String name;
  bool flag;
  nameListData({this.id, this.name, this.flag});
}

class RenameWatchListBottomSheet extends StatefulWidget {
  var index = 0;
  var name;

  RenameWatchListBottomSheet(this.index, this.name);

  @override
  State<RenameWatchListBottomSheet> createState() => _RenameWatchListBottomSheetState();
}

class _RenameWatchListBottomSheetState extends State<RenameWatchListBottomSheet> {
  final FocusNode myFocusNodeRenameWatchlist = FocusNode();
  TextEditingController renameWatchListController = TextEditingController();
  var renamedWatchlist = "";
  var renameFlag = false;

  @override
  Widget build(BuildContext context) {
    print(InAppSelection.tabsView[0][0].toString());
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
                          "Rename ${widget.name}",
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
                              if (value.length >= 3) {
                                renameFlag = true;
                              } else {
                                renameFlag = false;
                              }
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
                            !renameFlag
                                ? ElevatedButton(
                                  onPressed: (){
                                    print("");
                                  },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                      child: Text(
                                        "Save",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor)))))
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (renamedWatchlist == null || renamedWatchlist.toString().isEmpty) {
                                        CommonFunction.showBasicToast("Please Enter WatchList Name");
                                        return;
                                      }

                                      for (var i = 0; i < WatchlistDatabase.allWatchlist.length; i++) {
                                        if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString() == renamedWatchlist.toString()) {
                                          CommonFunction.showBasicToast("WatchList Already Exists");
                                          return;
                                        }
                                      }

                                      try{
                                        await WatchlistDatabase.instance.updateWatchListName(
                                            WatchlistDatabase.allWatchlist[widget.index]["watchListNo"],
                                            renamedWatchlist
                                        );

                                        var jsons = {
                                          "LoginID": Dataconstants.feUserID,
                                          "Operation" :"UPDATE",
                                          "WatchlistId": WatchlistDatabase.allWatchlist[widget.index]["watchListNo"],
                                          "Watchlistname": WatchlistDatabase.allWatchlist[widget.index]["watchListName"],
                                          "Watchlistscrips": "" //json string
                                        };
                                        await CommonFunction.watchListOperations(jsons);
                                      }catch(e){
                                          Dataconstants.listNameList[widget.index].name = renamedWatchlist;
                                          var jsons = {
                                            "LoginID": Dataconstants.feUserID,
                                            "Operation" :"UPDATE",
                                            "WatchlistId": Dataconstants.listNameList[widget.index].id,
                                            "Watchlistname": Dataconstants.listNameList[widget.index].name,
                                            "Watchlistscrips": "" //json string
                                          };
                                          await CommonFunction.watchListOperations(jsons);
                                      }

                                      try{
                                        var tabindex = InAppSelection.tabsView.indexWhere((element) => element[0] == WatchlistDatabase.allWatchlist[widget.index]["watchListName"]);
                                        InAppSelection.tabsView[tabindex] = [renamedWatchlist, "watchlist", WatchlistDatabase.allWatchlist[widget.index]["watchListNo"].toString()];
                                      }catch(e){

                                      }


                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      var finalTabs = json.encode(InAppSelection.tabsView);
                                      prefs.setString("tabsView", finalTabs);
                                      Dataconstants.isWatchListChanged = true;
                                      if (Dataconstants.loginData.watchlistFlag.toString() == "true") {
                                         await Dataconstants.watchListController
                                            .checkWatchList();
                                      }
                                      WatchlistDatabase.getAllWatchList();
                                      Navigator.pop(context);
                                      setState(() {

                                      });
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
  }
}

class CreateWatchListBottomSheet extends StatefulWidget {
  const CreateWatchListBottomSheet({Key key}) : super(key: key);

  @override
  State<CreateWatchListBottomSheet> createState() => _CreateWatchListBottomSheetState();
}

class _CreateWatchListBottomSheetState extends State<CreateWatchListBottomSheet> {
  final FocusNode myFocusNodeCreateWatchlist = FocusNode();
  TextEditingController createWatchListController = TextEditingController();
  String newWatchListName;
  var createFlag = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(

              decoration: new BoxDecoration(

                  borderRadius: new  BorderRadius.only(topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
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
                            width: 200,
                            height: 200,
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
                              if (value.length >= 3) {
                                createFlag = true;
                              } else {
                                createFlag = false;
                              }
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
                            createFlag
                                ? ElevatedButton(
                                    onPressed: () async {
                                      if (newWatchListName == null || newWatchListName.toString().isEmpty) {
                                        CommonFunction.showBasicToast("Please Enter WatchList Name");
                                        return;
                                      }

                                      for (var i = 0; i < WatchlistDatabase.allWatchlist.length; i++) {
                                        if (WatchlistDatabase.allWatchlist[i]["watchListName"].toString() == newWatchListName.toString()) {
                                          CommonFunction.showBasicToast("WatchList Already Exists");
                                          return;
                                        }
                                      }

                                      try{
                                        var jsons = {
                                          "LoginID": Dataconstants.feUserID,
                                          "Operation" : "INSERT",
                                          "Watchlistname": createWatchListController.text.trim(),
                                          "Watchlistscrips": "" //json string
                                        };
                                        await CommonFunction.watchListOperations(jsons);
                                      }catch(e){
                                      }

                                      var newWatchListNo = int.parse(WatchlistDatabase.lastWatchListIndex.toString());
                                      var lastPosition = WatchlistDatabase.allWatchlist.length;
                                      await WatchlistDatabase.instance.addNewWatchlist(++newWatchListNo, newWatchListName.toString(), lastPosition);
                                      CommonFunction.showBasicToast("WatchList Created Successfully");
                                      Navigator.pop(context);

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
                                        ))))
                                : ElevatedButton(
                                    onPressed: () {


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                      child: Text(
                                        "Create",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
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
  }
}
