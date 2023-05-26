import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';

class CustomiseDashboard extends StatefulWidget {
  const CustomiseDashboard({Key key}) : super(key: key);

  @override
  State<CustomiseDashboard> createState() => _CustomiseDashboardState();
}

class _CustomiseDashboardState extends State<CustomiseDashboard> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController _tabController;

  var headers = ["All", "Suggestion", "Trading", "Investing", "Alt. Investments"];

  void isBiometricAvailable() async {
    try {
      var biometrics = await CommonFunction.isBiometricAvailable();
      InAppSelection.isBioMetricAvailable = biometrics.isNotEmpty;

      SharedPreferences pref = await SharedPreferences.getInstance();
      bool isFingerPrintAvailable = pref.getBool("FingerprintEnabled");
      InAppSelection.fingerPrintEnabled = isFingerPrintAvailable;
      Dataconstants.isBiometricOtpVerified = isFingerPrintAvailable ?? false;
    } catch (e) {}

    setState(() {});
  }

  var datas = [];

  int _currentIndex = 0;
  var selectedScripts = 0;
  var allSelected = false;
  var isChanged = false;

  @override
  void initState() {
    super.initState();
    if(Dataconstants.isGuestUser){
      datas = [
        ["1", "Key Indices", true],
        ["2", "Trending Stocks", true],
        ["3", "Top Performing Industries", true],
        ["4", "Top Gainers", true],
        ["5", "Most Active", true],
        ["6", "Top Losers", true],
        ["7", "Global Indices", true],
      ];
    }else {
      var dashboardData;
      if (InAppSelection.dashboardSettings != "") {
        dashboardData = InAppSelection.dashboardSettings.toString();
        var decodedlist = json.decode(dashboardData);
        var newData = [];
        for (var i = 0; i < decodedlist.length; i++) {
          newData.add(decodedlist[i]);
        }
        datas = newData;
        checkSelected();
      } else {
        // datas = [
        //   ["0", "Limits", true],
        //   ["1", "Positions ", true],
        //   ["2", "Trending Stocks", true],
        //   ["3", "Other Assets", true],
        //   ["4", "Market Breadth", true],
        //   ["5", "Top Performing Industries", true],
        //   ["6", "Orders", true],
        //   ["7", "Top Gainers", true],
        //   ["8", "Events", true],
        //   ["9", "Most Active", true],
        //   ["10", "Key Indices", false],
        //   ["11", "JM Baskets", false],
        //   ["12", "My Ongoing SIPs", false],
        //   ["13", "Research", false],
        //   ["14", "Top Losers", false],
        //   ["15", "News", false],
        //   ["16", "Global Indices", false],
        //   ["17", "Circuit Breakers", false],
        //   ["18", "Option Chain", false],
        //   ["19", "OI Analysis", false],
        //   ["20", "Backoffice", false],
        //   ["21", "IPO", false],
        //   ["22", "NFO", false],
        //   ["23", "NCD", false]
        // ];

        datas = [
          ["0", "Key Indices", true],
          ["1", "Limits ", true],
          ["2", "Positions", true],
          ["3", "Orders", true],
          ["4", "Trending Stocks", true],
          ["5", "Other Assets", false],
          ["6", "Market Breadth", false],
          ["7", "Top Performing Industries", false],
          ["8", "Top Gainers", false],
          ["9", "Events", false],
          ["10", "Most Active", false],
          // ["11", "JM Baskets", false],
          // ["11", "My Ongoing SIPs", false],
          ["11", "Research", false],
          ["12", "Top Losers", false],
          ["13", "News", false],
          ["14", "Global Indices", false],
          ["15", "Circuit Breakers", false],
          ["16", "Option Chain", false],
          ["17", "OI Analysis", false],
          ["18", "Backoffice", false],
          ["19", "IPO", false],
          // ["22", "NFO", false],
          // ["23", "NCD", false]
        ];
      }
    }
    _tabController = TabController(vsync: this, length: headers.length);
  }

  checkSelected() {
    setState(() {
      selectedScripts = datas.where((element) => element[2] == true).toList().length;
    });
  }

  @override
  bool get wantKeepAlive => true;

  var searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Customise Dashboard",
                    style: Utils.fonts(size: 17.0),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        // filled: true,
                        // fillColor: Color(0xFFFFFFFF),
                        prefixIcon: Icon(Icons.search, color: Utils.greyColor.withOpacity(0.7)),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.5),
                          child: Container(
                            // height: 10,
                            // width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff0063f5).withOpacity(0.25),
                            ),
                            child: Icon(
                              Icons.mic_none,
                              size: 20,
                              color: Utils.primaryColor,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        hintText: 'Search Widget',
                        // hintStyle: const TextStyle(color: Utils.blackColor)
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                  onTap: (_index) {},
                  tabs: [
                    for (var i = 0; i < headers.length; i++)
                      Tab(
                        child: Row(
                          mainAxisAlignment: _currentIndex == i ? MainAxisAlignment.center : MainAxisAlignment.start,
                          children: [
                            Text(
                              headers[i].toString(),
                              style: Utils.fonts(
                                size: _currentIndex == i ? 13.0 : 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 2.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "WIDGETS",
                    style: Utils.fonts(color: Utils.greyColor),
                  ),
                  Text(
                    "You can select upto 10 widgets",
                    style: Utils.fonts(color: Utils.greyColor, size: 12.0),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Container(
                height: 2.0,
                width: MediaQuery.of(context).size.width,
                color: Utils.greyColor.withOpacity(0.2),
              ),
            ),
            searchValue.isEmpty
                ? Expanded(
                    child: ReorderableListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, i) {
                          return Card(
                            // color: Utils.whiteColor,
                            // color: Theme.of(context).brightness == Brightness.light
                            //     ? Utils.whiteColor
                            //     : Utils.dark_appBarColor,
                            key: ValueKey(datas[i][0]),
                            child: ListTile(
                              onTap: () {
                                if (datas[i][2] == true) {
                                  datas[i][2] = false;
                                } else {
                                  if (selectedScripts >= 10) return CommonFunction.CustomToast(Icons.clear, "cannot add more than 10 widgets", false);
                                  datas[i][2] = true;
                                }
                                checkSelected();
                              },
                              leading: SvgPicture.asset("assets/appImages/dashboard/Frame.svg"),
                              title: Row(
                                children: [
                                  Text(
                                    datas[i][1].toString(),
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  datas[i][2] == true
                                      ? SvgPicture.asset(
                                          "assets/appImages/selectedCircle.svg",
                                          height: 20,
                                          width: 20,
                                        )
                                      : SvgPicture.asset(
                                          "assets/appImages/unselectedRadio.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: datas.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex = newIndex - 1;
                            }
                            final element = datas.removeAt(oldIndex);
                            datas.insert(newIndex, element);
                            isChanged = true;
                          });
                        }),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: datas.length,
                      itemBuilder: (context, i) {
                        if (datas[i][1].toString().toUpperCase().contains(searchValue.toString().toUpperCase())) {
                          //print("index - $i - ${datas[i][1].toString()}");
                          return Card(
                            child: ListTile(
                              onTap: () {
                                if (datas[i][2] == true) {
                                  datas[i][2] = false;
                                } else {
                                  if (selectedScripts >= 10) return CommonFunction.CustomToast(Icons.clear, "cannot add more than 10 widgets", false);
                                  datas[i][2] = true;
                                }
                                checkSelected();
                              },
                              leading: SvgPicture.asset("assets/appImages/dashboard/Frame.svg"),
                              title: Row(
                                children: [
                                  Text(
                                    datas[i][1].toString(),
                                    style: Utils.fonts(),
                                  ),
                                  Spacer(),
                                  datas[i][2] == true
                                      ? SvgPicture.asset(
                                          "assets/appImages/selectedCircle.svg",
                                          height: 20,
                                          width: 20,
                                        )
                                      : SvgPicture.asset(
                                          "assets/appImages/unselectedRadio.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else
                          return SizedBox.shrink();
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "Cancel",
                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var finalJson = json.encode(datas);
                  prefs.setString("dashboardSettings", finalJson);
                  InAppSelection.dashboardSettings = finalJson;
                  // CommonFunction.CustomToast(
                  //     Icons.save, "Dashboard Settings Saved", false);
                  HomeWidgets.assignWidgets(Dataconstants.navigatorKey.currentContext);
                  Navigator.pop(context);
                  var dashboardData = InAppSelection.dashboardSettings.toString();
                  List decodedlist = json.decode(dashboardData);
                  for (int i = 0; i < decodedlist.length; i++) {
                    if (decodedlist[i][2] == true) {
                      switch (decodedlist[i][1]) {
                        case "Limits":
                          Dataconstants.limitController.getLimitsData();
                          break;
                        case "Positions":
                          Dataconstants.netPositionController.fetchNetPosition();
                          break;
                        case "Trending Stocks":
                          Dataconstants.mostActiveVolumeController.getMostActiveVolume("NSE", "Nifty");
                          break;
                        case "Top Performing Industries":
                          Dataconstants.topPerformingIndustriesController.getTopPerformingIndustries();
                          break;
                        case "Orders":
                          Dataconstants.orderBookData.fetchOrderBook();
                          break;
                        case "Top Gainers":
                          Dataconstants.topGainersController.getTopGainers("nse", "nifty", "day");
                          break;
                        case "Events":
                          Dataconstants.eventsDividendController.getEventsDividend();
                          break;
                        case "Most Active":
                          Dataconstants.mostActiveVolumeController.getMostActiveVolume("NSE", "Nifty");
                          break;
                        case "JM Baskets":
                          break;
                        case "My Ongoing SIPs":
                          Dataconstants.equitySipController.getEquitySip();
                          break;
                        case "Research":
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await CommonFunction.getResearchClientStructuredCallEntries();
                          });
                          break;
                        case "Top Losers":
                          Dataconstants.topLosersController.getTopLosers("nse", "nifty", 'month');
                          break;
                        case "News":
                          break;
                        case "Global Indices":
                          Dataconstants.worldIndicesController.getWorldIndices();
                          break;
                        case "Market Breadth":
                          Dataconstants.nseAdvanceController.getNseAdvance();
                          Dataconstants.nseDeclineController.getNseDecline();
                          Dataconstants.bseAdvanceController.getBseAdvance();
                          Dataconstants.bseDeclineController.getBseDecline();
                          break;
                        case "Circuit Breakers":
                          Dataconstants.circuitBreakersController.getCircuitBreakers();
                          break;
                        case "OI Analysis":
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await Dataconstants.topHighestOiController.getTopHighestOi();
                            await Dataconstants.topLowestOIController.getTopLowestOi();
                            await Dataconstants.increaseInOiController.getIncreaseInOi();
                            await Dataconstants.decreaseInOiController.getDecreaseinOi();
                          });
                          break;
                        case "Backoffice":
                          break;
                        case "IPO":
                          Dataconstants.openIpoController.getOpenIpo();
                          // Dataconstants.upcomingIpoController.getUpcomingIpo();
                          // Dataconstants.recentListingController.getIpoRecentListing();
                          break;
                        case "NFO":
                          break;
                        case "NCD":
                          break;
                        case "DP Holdings":
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                            await Dataconstants.holdingController.fetchHolding();
                            await Dataconstants.holdingController.fetchMtfHolding();
                          });
                          break;
                        case "Other Assets":
                          Dataconstants.openIpoController.getOpenIpo();
                          if (Dataconstants.otherAssets.length == 0 || Dataconstants.marketWatchList.length == 0) {
                            if (Dataconstants.marketWatchList.length == 0) CommonFunction.getMarketWatch();
                            if (Dataconstants.otherAssets.length == 0) CommonFunction.getOtherAssets();
                          }
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            for (int i = 0; i < Dataconstants.otherAssets.length; i++) {
                              Dataconstants.otherAssets[i] = CommonFunction.getScripDataModel(
                                exch: Dataconstants.otherAssets[i].exch,
                                exchCode: Dataconstants.otherAssets[i].exchCode,
                                getNseBseMap: true,
                                sendReq: true,
                                getChartDataTime: 15,
                              );
                            }
                            for (int i = 0; i < Dataconstants.marketWatchList.length; i++) {
                              Dataconstants.marketWatchList[i] = CommonFunction.getScripDataModel(
                                exch: Dataconstants.marketWatchList[i].exch,
                                exchCode: Dataconstants.marketWatchList[i].exchCode,
                                getNseBseMap: true,
                                sendReq: true,
                                getChartDataTime: 15,
                              );
                            }
                          });
                          break;
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    "Save (${selectedScripts.toString()} / ${datas.length.toString()})",
                    style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )))),
          ],
        ),
      ),
    );
  }
}
