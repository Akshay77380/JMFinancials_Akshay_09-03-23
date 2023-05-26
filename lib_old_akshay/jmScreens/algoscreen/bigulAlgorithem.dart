import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../controllers/AlgoController/awaitingController.dart';
import '../../controllers/AlgoController/finishedController.dart';
import '../../controllers/AlgoController/runningController.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../widget/custom_tab_bar.dart';
import 'algorithm_await_screen.dart';
import 'algorithm_finished_screen.dart';
import 'algorithm_running_screen.dart';
import 'algorithm_screen.dart';


class bigulAlgorithem extends StatefulWidget {
  // const bigulAlgorithem({Key? key}) : super(key: key);

  @override
  State<bigulAlgorithem> createState() => _bigulAlgorithemState();
}

class _bigulAlgorithemState extends State<bigulAlgorithem>  with SingleTickerProviderStateMixin {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  int _currentIndex = 0;
  bool firstLoginAlgorithmScreen = false;
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  GlobalKey _key = GlobalKey();
  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();
  bool test = false;
  var prefs;



    @override
  void initState() {
    super.initState();
    // Dataconstants.finishedController= Get.put(FinishedController());
    // Dataconstants.awaitingController= Get.put(AwaitingController());
    InAppSelection.algoOrderReportScreenTabIndex = 0;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // if (Dataconstants.shouldShowPopForbasket) {
    //   //   Dataconstants.isComingFromBasketGetQuote = false;
    //   // }
    //
    //   if (Dataconstants.isComingFromGoToBasket) {
    //     Dataconstants.isFromToolsToBasketOrder = true;
    //     Dataconstants.isComingFromGoToBasket = false;
    //   } else {
    //     Dataconstants.isFromToolsToBasketOrder = false;
    //   }
    // });
    // setState(() {
    //   calledPreference();
    //   // Dataconstants.coachMarkerKey = _key3;
    //   Dataconstants.isFromToolsToAlgo = false;
    //   Dataconstants.isFromToolsToFlashTrade = false;
    //   // if (Dataconstants.isComingFromOverview)
    //   //   Dataconstants.isFromToolsToResearch = true;
    //
    //   if (Dataconstants.isEquity == 1 || Dataconstants.isComingFromOverview)
    //     Dataconstants.isFromToolsToResearch = true;
    //   else
    //     Dataconstants.isFromToolsToResearch = false;
    //   Dataconstants.isFromToolsToEasyOptions = false;
    // });
    // widget.stream.listen((seconds) {
    //   _updateSeconds();
    // });
    // if (!Dataconstants.isStreamBuild) {
    //   widget.stream.listen((seconds) {
    //     _updateSeconds();
    //   });
    //   Dataconstants.isStreamBuild = true;
    // }
    // firstLoggedIn(); ///------------------------coach marker-----------------------
    //  Dataconstants.itsClient.getOrderBook();
    // Dataconstants.itsClient.fetch();
    // Dataconstants.itsClient.reportAlgo();
    // Dataconstants.itsClient.reportRunningAlgo();
    // Dataconstants.itsClient.reportFinishedAlgo();
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _tabController.index = InAppSelection.algoOrderReportScreenTabIndex;
    // CommonFunction.firebaselogEvent(true,"Tools screen","_Click","Tools screen");
    // firstLoggedIn();
  }

  void firstLoggedIn() async {
    var prefs = await SharedPreferences.getInstance();
    var firstLogin = prefs.getBool("firstLoginAlgorithmScreen");
    // //print("firstLoginAlgorithmScreen in init state : $firstLogin ");

    // if ((firstLogin == null || firstLogin == false) &&
    //     (Dataconstants.reportAlgoModel.reportAlgoLists.isEmpty) &&
    //     (Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty) &&
    //     (Dataconstants.reportFinishdModel.reportFinishAlgoLists.isEmpty)) {
    //   initTargets();
    //   WidgetsBinding.instance.addPostFrameCallback(_layout);
    //   // await prefs.setBool('firstLoginAlgorithmScreen', true);
    // }
    // else {
    //   // tutorialCoachMark..finish();
    //   await prefs.setBool('firstLoginAlgorithmScreen', true);
    // }
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            // setState(() {
            //   Dataconstants.isFromToolsToAlgo = false;
            // });
            Dataconstants.pageController.add(true);
          },
        ),
        centerTitle: false,
        backgroundColor: theme.appBarTheme.color,
        elevation: 0,
        title: Text(
          "Algorithm",
          style: TextStyle(color: theme.textTheme.bodyText1.color),
        ),
      ),
      floatingActionButton:
      // (InAppSelection.algoOrderReportScreenTabIndex == 0 &&
      //     AwaitingController.reportAwaitingAlgoLists.isEmpty) ||
      //     // Dataconstants.reportAlgoModel.reportAlgoLists.isEmpty) ||
      //         (InAppSelection.algoOrderReportScreenTabIndex == 1 &&
      //             RunningController.reportRunningAlgoLists.isEmpty)
      //             // Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty)
      // || (InAppSelection.algoOrderReportScreenTabIndex == 2 &&
      //     FinishedController.reportFinishedAlgoLists.isEmpty)?
      // // TextButton(
      // //
      // // ) :
      //  SizedBox.shrink():
      // Container(
      //         // margin:EdgeInsets.all(10),
      //         width: 28,
      //         height: 28,
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //         ),
      //         child: FloatingActionButton(
      //           backgroundColor: theme.primaryColor,
      //           // theme.scaffoldBackgroundColor,
      //           onPressed: () {
      //             // CommonFunction.launchURL(BrokerInfo.home);
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => InAppIciciWebView(
      //                         "Execution Algos Help",
      //                         BrokerInfo.home)));
      //           },
      //           child: Text(
      //             "?",
      //             style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.w500),
      //           ),
      //         ),
      //       )
      //     :
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // InkWell(
          //   onTap: () {
          //     // CommonFunction.launchURL(BrokerInfo.home);
          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //         builder: (context) => InAppIciciWebView(
          //     //             "Execution Algos Help",
          //     //             BrokerInfo.home)));
          //   },
          //   child: Container(
          //     width: 28,
          //     height: 28,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: theme.primaryColor,
          //     ),
          //     child: Center(
          //       child: Text(
          //         "?",
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 20,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //   ),
          // ),

          // InkWell(
          //     onTap: () {
          //       // CommonFunction.launchURL(BrokerInfo.home);
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => InAppIciciWebView(
          //                   "Execution Algos Help",
          //                   BrokerInfo.home)));
          //     },
          //     child: Text(
          //       "Help?",
          //       style: TextStyle(
          //           color: theme.primaryColor,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500),
          //     )),
          SizedBox(height: 20),
          Container(
            // key: _key3,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  Dataconstants
                      .isFromScripDetailToAdvanceScreen = false;
                  Dataconstants.isFinishedAlgoModify = false;
                  Dataconstants.isAwaitingAlgoModify = false;
                  // //print(
                  //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
                  //  Dataconstants.itsClient.fetch();
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AlgorithmScreen()));// AlgorithmScreen()))    AdvanceOrder

                // CommonFunction.firebaselogEvent(true,"algo_floating_action","_Click","algo_floating_action");
              },
              backgroundColor: theme.primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            Container(
              // color: theme.appBarTheme.color,color
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              // width: width,
              child: TabBar(
                physics:
                // prefs.getBool("firstLoginAlgorithmScreen") ==
                //     true
                //     ? CustomTabBarScrollPhysics()
                //     :
                NeverScrollableScrollPhysics(),
                indicatorPadding: EdgeInsets.zero,
                controller: _tabController,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.grey[600],
                labelColor: theme.textTheme.bodyText1.color,
                indicatorSize: TabBarIndicatorSize.label,
                //TabBarIndicatorSize.tab,
                isScrollable:
                // prefs.
                // getBool("firstLoginAlgorithmScreen") ==
                //     true
                //     ? true
                //     :
                false,
                //zzzz
                indicatorWeight: 0,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: theme.accentColor,
                ),
                // indicator: BubbleTabIndicator(
                //   indicatorHeight: 45.0,
                //   indicatorColor: theme.accentColor,
                //   tabBarIndicatorSize: TabBarIndicatorSize.tab,
                // ),
                //   isScrollable: true,
                onTap: (value) {

                  InAppSelection.algoOrderReportScreenTabIndex =
                      value;
                  _tabController.index =InAppSelection.algoOrderReportScreenTabIndex;

                  // prefs.getBool(
                  //     "firstLoginAlgorithmScreen") ==
                  //     true
                  //     ? InAppSelection.algoOrderReportScreenTabIndex
                  //     : 0;
                  //print(
                  //     'Tab count number ${InAppSelection.algoOrderReportScreenTabIndex}'
                  // );
                },
                tabs: [
                  Container(
                    key: _key,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Awaiting',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    key: _key1,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Running',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    key: _key2,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Finished',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: CustomTabBarScrollPhysics(),
                // prefs.getBool("firstLoginAlgorithmScreen")==true?CustomTabBarScrollPhysics(): NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Await(),
                  Running(),
                  Finished(),
                  // ExecutedOrderReport(),
                  // Container(
                  //   child: Center(
                  //     child: Text('ihefriuoweriwrywoiurwiuo'),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
