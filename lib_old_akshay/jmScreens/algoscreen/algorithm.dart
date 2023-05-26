// import 'dart:async';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import '../../controllers/AlgoController/awaitingController.dart';
// import '../../controllers/AlgoController/finishedController.dart';
// import '../../controllers/AlgoController/runningController.dart';
// import '../../style/theme.dart';
// import '../../util/CommonFunctions.dart';
// import '../../util/Dataconstants.dart';
// import '../../util/DateUtil.dart';
// import '../../util/InAppSelections.dart';
// import '../../widget/custom_tab_bar.dart';
// import 'advanceOrder_screen.dart';
// import 'algorithm_await_screen.dart';
// import 'algorithm_finished_screen.dart';
// import 'algorithm_running_screen.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'algorithm_screen.dart';
//
//
// class Algorithm extends StatefulWidget {
//   @override
//   AlgorithmState createState() => AlgorithmState();
//
//   final Stream<bool> stream;
//
//   Algorithm(this.stream);
// }
//
// class AlgorithmState extends State<Algorithm>
//     with SingleTickerProviderStateMixin {
//   void _updateSeconds() {
//     if (mounted) setState(() {});
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   TabController _tabController;
//   int _currentIndex = 0;
//   bool firstLoginAlgorithmScreen = false;
//   TutorialCoachMark tutorialCoachMark;
//   List<TargetFocus> targets = List();
//   GlobalKey _key = GlobalKey();
//   GlobalKey _key1 = GlobalKey();
//   GlobalKey _key2 = GlobalKey();
//   GlobalKey _key3 = GlobalKey();
//   bool test = false;
//   var prefs;
//
//   calledPreference() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Dataconstants.finishedController= Get.put(FinishedController());
//     // Dataconstants.awaitingController= Get.put(AwaitingController());
//     InAppSelection.algoOrderReportScreenTabIndex = 0;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // if (Dataconstants.shouldShowPopForbasket) {
//       //   Dataconstants.isComingFromBasketGetQuote = false;
//       // }
//
//       if (Dataconstants.isComingFromGoToBasket) {
//         Dataconstants.isFromToolsToBasketOrder = true;
//         Dataconstants.isComingFromGoToBasket = false;
//       } else {
//         Dataconstants.isFromToolsToBasketOrder = false;
//       }
//     });
//     setState(() {
//       calledPreference();
//       // Dataconstants.coachMarkerKey = _key3;
//       Dataconstants.isFromToolsToAlgo = false;
//       Dataconstants.isFromToolsToFlashTrade = false;
//       // if (Dataconstants.isComingFromOverview)
//       //   Dataconstants.isFromToolsToResearch = true;
//
//       if (Dataconstants.isEquity == 1 || Dataconstants.isComingFromOverview)
//         Dataconstants.isFromToolsToResearch = true;
//       else
//         Dataconstants.isFromToolsToResearch = false;
//       Dataconstants.isFromToolsToEasyOptions = false;
//     });
//     widget.stream.listen((seconds) {
//       _updateSeconds();
//     });
//     // if (!Dataconstants.isStreamBuild) {
//     //   widget.stream.listen((seconds) {
//     //     _updateSeconds();
//     //   });
//     //   Dataconstants.isStreamBuild = true;
//     // }
//     // firstLoggedIn(); ///------------------------coach marker-----------------------
//     //  Dataconstants.itsClient.getOrderBook();
//     // Dataconstants.itsClient.fetch();
//     // Dataconstants.itsClient.reportAlgo();
//     // Dataconstants.itsClient.reportRunningAlgo();
//     // Dataconstants.itsClient.reportFinishedAlgo();
//     _tabController = TabController(vsync: this, length: 3)
//       ..addListener(() {
//         setState(() {
//           _currentIndex = _tabController.index;
//         });
//       });
//     _tabController.index = InAppSelection.algoOrderReportScreenTabIndex;
//     CommonFunction.firebaselogEvent(true,"Tools screen","_Click","Tools screen");
//     // firstLoggedIn();
//   }
//
//   void firstLoggedIn() async {
//     var prefs = await SharedPreferences.getInstance();
//     var firstLogin = prefs.getBool("firstLoginAlgorithmScreen");
//     // //print("firstLoginAlgorithmScreen in init state : $firstLogin ");
//
//     if ((firstLogin == null || firstLogin == false) &&
//         (Dataconstants.reportAlgoModel.reportAlgoLists.isEmpty) &&
//         (Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty) &&
//         (Dataconstants.reportFinishdModel.reportFinishAlgoLists.isEmpty)) {
//       initTargets();
//       WidgetsBinding.instance.addPostFrameCallback(_layout);
//       // await prefs.setBool('firstLoginAlgorithmScreen', true);
//     } else {
//       // tutorialCoachMark..finish();
//       await prefs.setBool('firstLoginAlgorithmScreen', true);
//     }
//   }
//
//   void _layout(_) {
//     Future.delayed(Duration(milliseconds: 100), () {
//       showTutorial();
//     });
//   }
//
//   void showTutorial() {
//     initTargets();
//     tutorialCoachMark = TutorialCoachMark(
//       targets: targets,
//       colorShadow: Colors.black,
//       opacityShadow: 0.9,
//       pulseEnable: false,
//       hideSkip: true,
//       onSkip: () {
//         // //print("skip");
//       },
//     )..show();
//     tutorialCoachMark..next();
//   }
//
//   void initTargets() {
//     targets.add(
//       TargetFocus(
//         identify: "Target 0",
//         keyTarget: _key,
//         enableOverlayTab: false,
//         enableTargetTab: false,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: InkWell(
//                     onTap: () async {
//                       final prefs = await SharedPreferences.getInstance();
//                       tutorialCoachMark.skip();
//                       await prefs.setBool('firstLoginAlgorithmScreen', true);
//                     },
//                     child: Container(
//                       child: Text(
//                         "Skip",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: 18.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               )),
//           TargetContent(
//               align: ContentAlign.bottom,
//               child: Container(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "This will list all the strategies that are paused or are yet to start",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           fontSize: 17.0),
//                     ),
//                     // Text("paused or are yet to start",
//                     //   style: TextStyle(fontWeight: FontWeight.w400, color:Colors.white, fontSize: 17.0),
//                     // ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       child: Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             "1/4",
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: ElevatedButton(
//                         // color: Color(0xFF5367FC),
//                         onPressed: () {
//                           tutorialCoachMark..next();
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all<Color>(Color(0xFF5367FC)),
//                             shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(40.0),
//                                     side:
//                                     BorderSide(color: Color(0xFF5367FC))))),
//                         // shape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(40),
//                         // ),
//
//                         child: Container(
//                             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 0, vertical: 3),
//                             // height: 40,
//                             width: 70,
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text("Next",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w400)),
//                             )),
//                       ),
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//         shape: ShapeLightFocus.RRect,
//         radius: 28,
//       ),
//     );
//     targets.add(
//       TargetFocus(
//         enableOverlayTab: false,
//         enableTargetTab: false,
//         identify: "Target 1",
//         keyTarget: _key1,
//         // color: Colors.grey,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: InkWell(
//                     onTap: () async {
//                       final prefs = await SharedPreferences.getInstance();
//                       tutorialCoachMark.skip();
//                       await prefs.setBool('firstLoginAlgorithmScreen', true);
//                     },
//                     child: Container(
//                       child: Text(
//                         "Skip",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: 18.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               )),
//           TargetContent(
//               align: ContentAlign.bottom,
//               child: Container(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "This will list all the strategies that are active and are executing",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           fontSize: 17.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       child: Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             "2/4",
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         OutlinedButton(
//                           // highlightedBorderColor: Colors.white,
//                           // focusColor: Colors.white,
//                           onPressed: () {
//                             tutorialCoachMark..previous();
//                           },
//                           style: OutlinedButton.styleFrom(
//
//                             side: BorderSide(width:1.0 ,color: Colors.white,style: BorderStyle.solid),
//                           ),
//                           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
//                           // borderSide: BorderSide(
//                           //   width: 1.0,
//                           //   color: Colors.white,
//                           //   style: BorderStyle.solid,
//                           // ),
//                           child: Text(
//                             "Previous",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         ElevatedButton(
//                           // color: Color(0xFF5367FC),
//                           onPressed: () {
//                             tutorialCoachMark..next();
//                           },
//                           style: ButtonStyle(
//                               backgroundColor:
//                               MaterialStateProperty.all<Color>(Color(0xFF5367FC)),
//                               shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(40.0),
//                                       side:
//                                       BorderSide(color: Color(0xFF5367FC))))),
//                           // shape: RoundedRectangleBorder(
//                           //   borderRadius: BorderRadius.circular(40),
//                           // ),
//                           child: Container(
//                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 0, vertical: 3),
//                               // height: 40,
//                               width: 70,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text("Next",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400)),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//         shape: ShapeLightFocus.RRect,
//         radius: 28,
//       ),
//     );
//     targets.add(TargetFocus(
//       identify: "Target 2",
//       keyTarget: _key2,
//       enableOverlayTab: false,
//       enableTargetTab: false,
//       contents: [
//         TargetContent(
//             align: ContentAlign.top,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: InkWell(
//                   onTap: () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     tutorialCoachMark.skip();
//                     await prefs.setBool('firstLoginAlgorithmScreen', true);
//                   },
//                   child: Container(
//                     child: Text(
//                       "Skip",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                           fontSize: 18.0),
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//         TargetContent(
//             align: ContentAlign.bottom,
//             child: Container(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "This will list all the strategies that have been stopped or have ended",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                         fontSize: 17.0),
//                   ),
//                   // Text("stopped or have ended",
//                   //   style: TextStyle(fontWeight: FontWeight.w400, color:Colors.white, fontSize: 17.0),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "3/4",
//                           style: TextStyle(color: Colors.white),
//                         )),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       OutlinedButton(
//                         highlightedBorderColor: Colors.white,
//                         focusColor: Colors.white,
//                         onPressed: () {
//                           tutorialCoachMark..previous();
//                         },
//                         // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
//                         // borderSide: BorderSide(
//                         //   width: 1.0,
//                         //   color: Colors.white,
//                         //   style: BorderStyle.solid,
//                         // ),
//                         child: Text(
//                           "Previous",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       ElevatedButton(
//                         // color: Color(0xFF5367FC),
//                         onPressed: () {
//                           tutorialCoachMark..next();
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all<Color>(Color(0xFF5367FC)),
//                             shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(40.0),
//                                     side:
//                                     BorderSide(color: Color(0xFF5367FC))))),
//                       //   shape: RoundedRectangleBorder(
//                       //   borderRadius: BorderRadius.circular(40),
//                       // ),
//                         child: Container(
//
//                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 0, vertical: 3),
//                             // height: 40,
//                             width: 70,
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text("Next",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w400)),
//                             )),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ))
//       ],
//       shape: ShapeLightFocus.RRect,
//       radius: 28,
//     ));
//     targets.add(TargetFocus(
//       identify: "Target 3",
//       keyTarget: Dataconstants.coachMarkerKey,
//       // color: Colors.grey,
//       enableOverlayTab: false,
//       enableTargetTab: false,
//       contents: [
//         TargetContent(
//             align: ContentAlign.top,
//             child: Align(
//               alignment: Alignment.topRight,
//               child: InkWell(
//                 onTap: () async {
//                   final prefs = await SharedPreferences.getInstance();
//                   tutorialCoachMark.skip();
//                   await prefs.setBool('firstLoginAlgorithmScreen', true);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 400),
//                   child: Container(
//                     child: Text(
//                       "Skip",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                           fontSize: 18.0),
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//         TargetContent(
//             align: ContentAlign.top,
//             child: Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Click here to browse and select your desired Algorithm",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                         fontSize: 17.0),
//                   ),
//                 ],
//               ),
//             )),
//         TargetContent(
//             align: ContentAlign.bottom,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "4/4",
//                         style: TextStyle(color: Colors.white),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     OutlineButton(
//                       highlightedBorderColor: Colors.white,
//                       focusColor: Colors.white,
//                       onPressed: () {
//                         tutorialCoachMark..previous();
//                       },
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
//                       borderSide: BorderSide(
//                         width: 1.0,
//                         color: Colors.white,
//                         style: BorderStyle.solid,
//                       ),
//                       child: Text(
//                         "Previous",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     ElevatedButton(
//                       // color: Color(0xFF5367FC),
//                       onPressed: () async {
//                         final prefs = await SharedPreferences.getInstance();
//                         tutorialCoachMark..finish();
//                         await prefs.setBool('firstLoginAlgorithmScreen', true);
//                         // //print("firstLoginAlgorithmScreen : $firstLoginAlgorithmScreen");
//                       },
//                       style: ButtonStyle(
//                           backgroundColor:
//                           MaterialStateProperty.all<Color>(Color(0xFF5367FC)),
//                           shape:
//                           MaterialStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(40.0),
//                                   side:
//                                   BorderSide(color: Color(0xFF5367FC))))),
//                       // shape: RoundedRectangleBorder(
//                       //   borderRadius: BorderRadius.circular(40),
//                       // ),
//
//                       child: Container(
//                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 0, vertical: 3),
//                           // height: 40,
//                           width: 70,
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text("Got it",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400)),
//                           )),
//                     ),
//                   ],
//                 ),
//               ],
//             ))
//       ],
//       shape: ShapeLightFocus.RRect,
//       // radius: 0.5
//     ));
//   }
//
//   changeState() {
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     if (Dataconstants.isFromToolsToFlashTrade == false) {
//       Dataconstants.periodicTimer.cancel();
//     }
//     super.dispose();
//   }
//
//   floatingButton(){
//     switch(InAppSelection.algoOrderReportScreenTabIndex)
//     {
//      case 0: {
//        Dataconstants.awaitingController.fetchReportAwaitingAlgo();
//        return AwaitingController.reportAwaitingAlgoLists.isEmpty;
//      }
//     break;
//       case 1: {
//         Dataconstants.runningController.fetchReportRunningAlgo();
//         return RunningController.reportRunningAlgoLists.isEmpty;
//       }
//       break;
//       case 2: {
//         Dataconstants.finishedController.fetchReportFinishedAlgo();
//         return FinishedController.reportFinishedAlgoLists.isEmpty;
//       }
//       break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     var theme = Theme.of(context);
//     return WillPopScope(
//       onWillPop: () async {
//         // setState(() {
//         //   Dataconstants.isFromToolsToAlgo=false;
//         // });
//         var prefs = await SharedPreferences.getInstance();
//         var firstLogin = prefs.getBool("firstLoginAlgorithmScreen");
//         if (firstLogin == true) {
//           return Future.value(true);
//         } else {
//           return Future.value(false);
//         }
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: Dataconstants.isFromToolsToAlgo == true
//             ? Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: () {
//                 setState(() {
//                   Dataconstants.isFromToolsToAlgo = false;
//                 });
//                 Dataconstants.pageController.add(true);
//               },
//             ),
//             centerTitle: false,
//             backgroundColor: theme.appBarTheme.color,
//             elevation: 0,
//             title: Text(
//               "Bigul Algos",
//               style: TextStyle(color: theme.textTheme.bodyText1.color),
//             ),
//           ),
//           floatingActionButton:
//           // (InAppSelection.algoOrderReportScreenTabIndex == 0 &&
//           //     AwaitingController.reportAwaitingAlgoLists.isEmpty) ||
//           //     // Dataconstants.reportAlgoModel.reportAlgoLists.isEmpty) ||
//           //         (InAppSelection.algoOrderReportScreenTabIndex == 1 &&
//           //             RunningController.reportRunningAlgoLists.isEmpty)
//           //             // Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty)
//           // || (InAppSelection.algoOrderReportScreenTabIndex == 2 &&
//           //     FinishedController.reportFinishedAlgoLists.isEmpty)
//           floatingButton() ?
//           SizedBox.shrink()
//           // Container(
//           //         // margin:EdgeInsets.all(10),
//           //         width: 28,
//           //         height: 28,
//           //         decoration: BoxDecoration(
//           //           shape: BoxShape.circle,
//           //         ),
//           //         child: FloatingActionButton(
//           //           backgroundColor: theme.primaryColor,
//           //           // theme.scaffoldBackgroundColor,
//           //           onPressed: () {
//           //             // CommonFunction.launchURL(BrokerInfo.home);
//           //             Navigator.push(
//           //                 context,
//           //                 MaterialPageRoute(
//           //                     builder: (context) => InAppIciciWebView(
//           //                         "Execution Algos Help",
//           //                         BrokerInfo.home)));
//           //           },
//           //           child: Text(
//           //             "?",
//           //             style: TextStyle(
//           //                 color: Colors.white,
//           //                 fontSize: 20,
//           //                 fontWeight: FontWeight.w500),
//           //           ),
//           //         ),
//           //       )
//               :
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // InkWell(
//               //   onTap: () {
//               //     // CommonFunction.launchURL(BrokerInfo.home);
//               //     // Navigator.push(
//               //     //     context,
//               //     //     MaterialPageRoute(
//               //     //         builder: (context) => InAppIciciWebView(
//               //     //             "Execution Algos Help",
//               //     //             BrokerInfo.home)));
//               //   },
//               //   child: Container(
//               //     width: 28,
//               //     height: 28,
//               //     decoration: BoxDecoration(
//               //       shape: BoxShape.circle,
//               //       color: theme.primaryColor,
//               //     ),
//               //     child: Center(
//               //       child: Text(
//               //         "?",
//               //         style: TextStyle(
//               //             color: Colors.white,
//               //             fontSize: 20,
//               //             fontWeight: FontWeight.w500),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//
//               // InkWell(
//               //     onTap: () {
//               //       // CommonFunction.launchURL(BrokerInfo.home);
//               //       Navigator.push(
//               //           context,
//               //           MaterialPageRoute(
//               //               builder: (context) => InAppIciciWebView(
//               //                   "Execution Algos Help",
//               //                   BrokerInfo.home)));
//               //     },
//               //     child: Text(
//               //       "Help?",
//               //       style: TextStyle(
//               //           color: theme.primaryColor,
//               //           fontSize: 16,
//               //           fontWeight: FontWeight.w500),
//               //     )),
//               SizedBox(height: 20),
//               Container(
//                 // key: _key3,
//                 child: FloatingActionButton(
//                   onPressed: () async {
//                     setState(() {
//                       Dataconstants
//                           .isFromScripDetailToAdvanceScreen = false;
//                       Dataconstants.isFinishedAlgoModify = false;
//                       Dataconstants.isAwaitingAlgoModify = false;
//                       // //print(
//                       //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
//                       //  Dataconstants.itsClient.fetch();
//                     });
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) =>
//                             AlgorithmScreen()));// AlgorithmScreen()))    AdvanceOrder
//
//                     // CommonFunction.firebaselogEvent(true,"algo_floating_action","_Click","algo_floating_action");
//                   },
//                   backgroundColor: theme.primaryColor,
//                   child: Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//
//
//
//           body: Container(
//             child: Column(
//               children: [
//                 Container(
//                   color: theme.appBarTheme.color,
//                   padding: EdgeInsets.symmetric(
//                     vertical: 10,
//                   ),
//                   width: width,
//                   child: TabBar(
//                     physics:
//                     prefs.getBool("firstLoginAlgorithmScreen") ==
//                         true
//                         ? CustomTabBarScrollPhysics()
//                         : NeverScrollableScrollPhysics(),
//                     indicatorPadding: EdgeInsets.zero,
//                     controller: _tabController,
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     unselectedLabelStyle:
//                     TextStyle(fontWeight: FontWeight.normal),
//                     unselectedLabelColor: Colors.grey[600],
//                     labelColor: theme.textTheme.bodyText1.color,
//                     indicatorSize: TabBarIndicatorSize.label,
//                     //TabBarIndicatorSize.tab,
//                     isScrollable:
//                     prefs.getBool("firstLoginAlgorithmScreen") ==
//                         true
//                         ? true
//                         : false,
//                     //zzzz
//                     indicatorWeight: 0,
//                     indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       color: theme.accentColor,
//                     ),
//                     // indicator: BubbleTabIndicator(
//                     //   indicatorHeight: 45.0,
//                     //   indicatorColor: theme.accentColor,
//                     //   tabBarIndicatorSize: TabBarIndicatorSize.tab,
//                     // ),
//                     //   isScrollable: true,
//                     onTap: (value) {
//                       InAppSelection.algoOrderReportScreenTabIndex =
//                           value;
//                       _tabController.index = prefs.getBool(
//                           "firstLoginAlgorithmScreen") ==
//                           true
//                           ? InAppSelection.algoOrderReportScreenTabIndex
//                           : 0;
//                       //print(
//                           'Tab count number ${InAppSelection.algoOrderReportScreenTabIndex}');
//                     },
//                     tabs: [
//                       Container(
//                         key: _key,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Awaiting',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         key: _key1,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Running',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         key: _key2,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Finished',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     physics: CustomTabBarScrollPhysics(),
//                     // prefs.getBool("firstLoginAlgorithmScreen")==true?CustomTabBarScrollPhysics(): NeverScrollableScrollPhysics(),
//                     controller: _tabController,
//                     children: [
//                       Await(),
//                       Running(),
//                       Finished(),
//                       // ExecutedOrderReport(),
//                       // Container(
//                       //   child: Center(
//                       //     child: Text('ihefriuoweriwrywoiurwiuo'),
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//
//         // Observer(builder: (context) {
//         //         return Scaffold(
//         //           appBar: AppBar(
//         //             leading: IconButton(
//         //               icon: Icon(Icons.arrow_back_ios),
//         //               onPressed: () {
//         //                 setState(() {
//         //                   Dataconstants.isFromToolsToAlgo = false;
//         //                 });
//         //                 Dataconstants.pageController.add(true);
//         //               },
//         //             ),
//         //             centerTitle: false,
//         //             backgroundColor: theme.appBarTheme.color,
//         //             elevation: 0,
//         //             title: Text(
//         //               "Bigul Algos",
//         //               style: TextStyle(color: theme.textTheme.bodyText1.color),
//         //             ),
//         //           ),
//         //           floatingActionButton:
//         //           // (InAppSelection.algoOrderReportScreenTabIndex == 0 &&
//         //           //     AwaitingController.reportAwaitingAlgoLists.isEmpty) ||
//         //           //     // Dataconstants.reportAlgoModel.reportAlgoLists.isEmpty) ||
//         //           //         (InAppSelection.algoOrderReportScreenTabIndex == 1 &&
//         //           //             RunningController.reportRunningAlgoLists.isEmpty)
//         //           //             // Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty)
//         //           // || (InAppSelection.algoOrderReportScreenTabIndex == 2 &&
//         //           //     FinishedController.reportFinishedAlgoLists.isEmpty)
//         //           floatingButton() ?
//         //               SizedBox.shrink()
//         //           // Container(
//         //           //         // margin:EdgeInsets.all(10),
//         //           //         width: 28,
//         //           //         height: 28,
//         //           //         decoration: BoxDecoration(
//         //           //           shape: BoxShape.circle,
//         //           //         ),
//         //           //         child: FloatingActionButton(
//         //           //           backgroundColor: theme.primaryColor,
//         //           //           // theme.scaffoldBackgroundColor,
//         //           //           onPressed: () {
//         //           //             // CommonFunction.launchURL(BrokerInfo.home);
//         //           //             Navigator.push(
//         //           //                 context,
//         //           //                 MaterialPageRoute(
//         //           //                     builder: (context) => InAppIciciWebView(
//         //           //                         "Execution Algos Help",
//         //           //                         BrokerInfo.home)));
//         //           //           },
//         //           //           child: Text(
//         //           //             "?",
//         //           //             style: TextStyle(
//         //           //                 color: Colors.white,
//         //           //                 fontSize: 20,
//         //           //                 fontWeight: FontWeight.w500),
//         //           //           ),
//         //           //         ),
//         //           //       )
//         //               :
//         //           Column(
//         //                   mainAxisSize: MainAxisSize.min,
//         //                   children: [
//         //                     // InkWell(
//         //                     //   onTap: () {
//         //                     //     // CommonFunction.launchURL(BrokerInfo.home);
//         //                     //     // Navigator.push(
//         //                     //     //     context,
//         //                     //     //     MaterialPageRoute(
//         //                     //     //         builder: (context) => InAppIciciWebView(
//         //                     //     //             "Execution Algos Help",
//         //                     //     //             BrokerInfo.home)));
//         //                     //   },
//         //                     //   child: Container(
//         //                     //     width: 28,
//         //                     //     height: 28,
//         //                     //     decoration: BoxDecoration(
//         //                     //       shape: BoxShape.circle,
//         //                     //       color: theme.primaryColor,
//         //                     //     ),
//         //                     //     child: Center(
//         //                     //       child: Text(
//         //                     //         "?",
//         //                     //         style: TextStyle(
//         //                     //             color: Colors.white,
//         //                     //             fontSize: 20,
//         //                     //             fontWeight: FontWeight.w500),
//         //                     //       ),
//         //                     //     ),
//         //                     //   ),
//         //                     // ),
//         //
//         //                     // InkWell(
//         //                     //     onTap: () {
//         //                     //       // CommonFunction.launchURL(BrokerInfo.home);
//         //                     //       Navigator.push(
//         //                     //           context,
//         //                     //           MaterialPageRoute(
//         //                     //               builder: (context) => InAppIciciWebView(
//         //                     //                   "Execution Algos Help",
//         //                     //                   BrokerInfo.home)));
//         //                     //     },
//         //                     //     child: Text(
//         //                     //       "Help?",
//         //                     //       style: TextStyle(
//         //                     //           color: theme.primaryColor,
//         //                     //           fontSize: 16,
//         //                     //           fontWeight: FontWeight.w500),
//         //                     //     )),
//         //                     SizedBox(height: 20),
//         //                     Container(
//         //                       // key: _key3,
//         //                       child: FloatingActionButton(
//         //                         onPressed: () async {
//         //                           setState(() {
//         //                             Dataconstants
//         //                                     .isFromScripDetailToAdvanceScreen = false;
//         //                             Dataconstants.isFinishedAlgoModify = false;
//         //                             Dataconstants.isAwaitingAlgoModify = false;
//         //                             // //print(
//         //                             //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
//         //                             //  Dataconstants.itsClient.fetch();
//         //                           });
//         //                           Navigator.of(context).push(MaterialPageRoute(
//         //                               builder: (context) =>
//         //                                   AlgorithmScreen()));// AlgorithmScreen()))    AdvanceOrder
//         //
//         //                           CommonFunction.firebaselogEvent(true,"algo_floating_action","_Click","algo_floating_action");
//         //                         },
//         //                         backgroundColor: theme.primaryColor,
//         //                         child: Icon(
//         //                           Icons.add,
//         //                           color: Colors.white,
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   ],
//         //                 ),
//         //
//         //
//         //
//         //
//         //           body: Container(
//         //             child: Column(
//         //               children: [
//         //                 Container(
//         //                   color: theme.appBarTheme.color,
//         //                   padding: EdgeInsets.symmetric(
//         //                     vertical: 10,
//         //                   ),
//         //                   width: width,
//         //                   child: TabBar(
//         //                     physics:
//         //                         prefs.getBool("firstLoginAlgorithmScreen") ==
//         //                                 true
//         //                             ? CustomTabBarScrollPhysics()
//         //                             : NeverScrollableScrollPhysics(),
//         //                     indicatorPadding: EdgeInsets.zero,
//         //                     controller: _tabController,
//         //                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//         //                     unselectedLabelStyle:
//         //                         TextStyle(fontWeight: FontWeight.normal),
//         //                     unselectedLabelColor: Colors.grey[600],
//         //                     labelColor: theme.textTheme.bodyText1.color,
//         //                     indicatorSize: TabBarIndicatorSize.label,
//         //                     //TabBarIndicatorSize.tab,
//         //                     isScrollable:
//         //                         prefs.getBool("firstLoginAlgorithmScreen") ==
//         //                                 true
//         //                             ? true
//         //                             : false,
//         //                     //zzzz
//         //                     indicatorWeight: 0,
//         //                     indicator: BoxDecoration(
//         //                       borderRadius: BorderRadius.circular(50),
//         //                       color: theme.accentColor,
//         //                     ),
//         //                     // indicator: BubbleTabIndicator(
//         //                     //   indicatorHeight: 45.0,
//         //                     //   indicatorColor: theme.accentColor,
//         //                     //   tabBarIndicatorSize: TabBarIndicatorSize.tab,
//         //                     // ),
//         //                     //   isScrollable: true,
//         //                     onTap: (value) {
//         //                       InAppSelection.algoOrderReportScreenTabIndex =
//         //                           value;
//         //                       _tabController.index = prefs.getBool(
//         //                                   "firstLoginAlgorithmScreen") ==
//         //                               true
//         //                           ? InAppSelection.algoOrderReportScreenTabIndex
//         //                           : 0;
//         //                       //print(
//         //                           'Tab count number ${InAppSelection.algoOrderReportScreenTabIndex}');
//         //                     },
//         //                     tabs: [
//         //                       Container(
//         //                         key: _key,
//         //                         padding: EdgeInsets.symmetric(
//         //                           horizontal: 20,
//         //                         ),
//         //                         child: Tab(
//         //                           child: Row(
//         //                             mainAxisAlignment: MainAxisAlignment.center,
//         //                             children: [
//         //                               Text(
//         //                                 'Awaiting',
//         //                               ),
//         //                             ],
//         //                           ),
//         //                         ),
//         //                       ),
//         //                       Container(
//         //                         key: _key1,
//         //                         padding: EdgeInsets.symmetric(
//         //                           horizontal: 20,
//         //                         ),
//         //                         child: Tab(
//         //                           child: Row(
//         //                             mainAxisAlignment: MainAxisAlignment.center,
//         //                             children: [
//         //                               Text(
//         //                                 'Running',
//         //                               ),
//         //                             ],
//         //                           ),
//         //                         ),
//         //                       ),
//         //                       Container(
//         //                         key: _key2,
//         //                         padding: EdgeInsets.symmetric(
//         //                           horizontal: 20,
//         //                         ),
//         //                         child: Tab(
//         //                           child: Row(
//         //                             mainAxisAlignment: MainAxisAlignment.center,
//         //                             children: [
//         //                               Text(
//         //                                 'Finished',
//         //                               ),
//         //                             ],
//         //                           ),
//         //                         ),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ),
//         //                 Expanded(
//         //                   child: TabBarView(
//         //                     physics: CustomTabBarScrollPhysics(),
//         //                     // prefs.getBool("firstLoginAlgorithmScreen")==true?CustomTabBarScrollPhysics(): NeverScrollableScrollPhysics(),
//         //                     controller: _tabController,
//         //                     children: [
//         //                       Await(),
//         //                       Running(),
//         //                       Finished(),
//         //                       // ExecutedOrderReport(),
//         //                       // Container(
//         //                       //   child: Center(
//         //                       //     child: Text('ihefriuoweriwrywoiurwiuo'),
//         //                       //   ),
//         //                       // )
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ],
//         //             ),
//         //           ),
//         //         );
//         //       })
//             : Dataconstants.isFromToolsToResearch == true
//                 ? ResearchScreen()
//                 : Dataconstants.isFromToolsToEasyOptions == true
//                     ? OptionSimplifiedScreen()
//                     : Dataconstants.isFromToolsToBasketOrder == true
//                         ? BasketWatch()
//                         : Dataconstants.isFromToolsToFlashTrade == true
//                             ? FlashTradeBOB()    // FlashTradeScreen()
//                             : Column(
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       Container(
//                                         height: 60,
//                                         color: theme.appBarTheme.color,
//                                         child: Center(
//                                           child: Text(
//                                             "Tools & Research",
//                                             style: TextStyle(
//                                                 color: theme.textTheme
//                                                     .bodyText1.color,
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 21),
//                                           ),
//                                         ),
//                                       ),
//                                       // Padding(
//                                       //   padding: const EdgeInsets.only(
//                                       //       top: 30, left: 10, right: 10),
//                                       //   child: Container(
//                                       //     height: 50,
//                                       //     decoration: BoxDecoration(
//                                       //         borderRadius:
//                                       //             BorderRadius.circular(5),
//                                       //         color:theme.cardColor
//                                       //
//                                       //         // ThemeConstants.themeMode.value == ThemeMode.light
//                                       //         //     ?  Color(0xff3A424B).withOpacity(0.4) //Colors.white
//                                       //         //     : Color(0xff3A424B),
//                                       //         // gradient: LinearGradient(
//                                       //         //     begin:
//                                       //         //         Alignment.bottomCenter,
//                                       //         //     end: Alignment.topCenter,
//                                       //         //     colors: [
//                                       //         //       theme.cardColor,
//                                       //         //       ThemeConstants.themeMode.value == ThemeMode.light
//                                       //         //           ?  Color(0xff3A424B).withOpacity(0.4) //Colors.white
//                                       //         //           : Color(0xff3A424B),
//                                       //         //     ])
//                                       //
//                                       //     ),
//                                       //     child: Center(
//                                       //       child: Text(
//                                       //         "Tools & Research",
//                                       //         style: TextStyle(
//                                       //             color: theme.textTheme
//                                       //                 .bodyText1.color,
//                                       //             fontWeight: FontWeight.w400,
//                                       //             fontSize: 21),
//                                       //       ),
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         ///--------------------------Basket--------------------///
//                                         InkWell(
//                                           onTap: () {
//                                             if (Dataconstants.osGuestUser) {
//                                               CommonFunction
//                                                   .showDialogGestLogin(
//                                                 context: context,
//                                                 comingFrom: "tools",
//                                                 title1: 'For Basket Order,',
//                                               );
//                                             } else {
//                                               setState(() {
//                                                 Dataconstants.isFromToolsToBasketOrder = true;
//                                               });
//                                             }
//                                             // CommonFunction.firebaselogEvent(true,"basket_order","_Click","basket_order");
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 gradient: LinearGradient(
//                                                     begin: Alignment.centerLeft,
//                                                     end: Alignment.centerRight,
//                                                     colors: [
//                                                       theme.cardColor,
//                                                       ThemeConstants.themeMode
//                                                                   .value ==
//                                                               ThemeMode.light
//                                                           ? theme.cardColor
//                                                           : Color(0xff3A424B),
//                                                     ])),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(16),
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     child:Icon(Icons.add_shopping_cart,color: theme.primaryColor,),
//                                                     // SvgPicture.asset(
//                                                     //     "assets/images/tools/Basket.svg",color: Color(0xFF5367FC),),
//                                                     backgroundColor:
//                                                         ThemeConstants.themeMode
//                                                                     .value ==
//                                                                 ThemeMode.light
//                                                             ? Colors.white
//                                                             : Colors.black,
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Basket Order",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text(
//                                                       "Place upto 20 orders in a single click",
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w300,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: theme.textTheme
//                                                           .bodyText1.color),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         ///--------------------------Research--------------------///
//                                         InkWell(
//                                           onTap: () {
//                                             if (Dataconstants.osGuestUser) {
//                                               CommonFunction
//                                                   .showDialogGestLogin(
//                                                 context: context,
//                                                 comingFrom: "tools",
//                                                 title1: 'For Investment ideas,',
//                                               );
//                                             } else {
//                                               setState(() {
//                                                 Dataconstants.isFromToolsToResearch = true;
//                                               });
//                                               Dataconstants.periodicTimer =
//                                                   Timer.periodic(
//                                                 const Duration(minutes: 3),
//                                                 (timer) {
//                                                   Dataconstants.itsClient
//                                                       .clickToGain();
//                                                   Dataconstants.itsClient
//                                                       .clickToInvest();
//                                                 },
//                                               );
//                                             }
//
//                                             // CommonFunction.firebaselogEvent(true,"investment_ideas","_Click","investment_ideas");
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 gradient: LinearGradient(
//                                                     begin: Alignment.centerLeft,
//                                                     end: Alignment.centerRight,
//                                                     colors: [
//                                                       theme.cardColor,
//                                                       ThemeConstants.themeMode
//                                                                   .value ==
//                                                               ThemeMode.light
//                                                           ? theme.cardColor
//                                                           : Color(0xff3A424B),
//                                                     ])),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(16),
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     child: SvgPicture.asset(
//                                                         "assets/images/tools/research_ideas.svg",color:Color(0xFF5367FC)),
//                                                     // child: SvgPicture.asset("assets/images/options_simplified/ic_fast_option.svg", colorBlendMode: BlendMode.difference,),
//                                                     backgroundColor:
//                                                         ThemeConstants.themeMode
//                                                                     .value ==
//                                                                 ThemeMode.light
//                                                             ? Colors.white
//                                                             : Colors.black,
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Investment ideas",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text(
//                                                       "Stock ideas to power your trade",
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w300,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: theme.textTheme
//                                                           .bodyText1.color),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         ///--------------------------Algo--------------------///
//                                         InkWell(
//                                           onTap: () async {
//
//                                             if (Dataconstants.osGuestUser) {
//                                               CommonFunction
//                                                   .showDialogGestLogin(
//                                                 context: context,
//                                                 comingFrom: "tools",
//                                                 title1: 'For Bigul Algos,',
//                                               );
//                                             } else
//                                             {
//                                               if (prefs.getBool(
//                                                           "firstLoginAlgorithmScreen") ==
//                                                       null ||
//                                                   prefs.getBool(
//                                                           "firstLoginAlgorithmScreen") ==
//                                                       false) {
//                                                 await Dataconstants.itsClient
//                                                     .reportAlgo();
//                                                 await Dataconstants.itsClient
//                                                     .reportRunningAlgo();
//                                                 await Dataconstants.itsClient
//                                                     .reportFinishedAlgo();
//
//                                                 firstLoggedIn();
//                                                 setState(() {
//                                                   Dataconstants.isFromToolsToAlgo = true;
//
//                                                 });
//                                               } else
//                                               {
//                                                 setState(() {
//                                                   Dataconstants.isFromToolsToAlgo = true;
//                                                 });
//                                               }
//                                             }
//                                             // CommonFunction.firebaselogEvent(true,"bigul_algos","_Click","bigul_algos");
//
//                                             //z}zzz
//
//                                             /// ------------------- coach marker -------------
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 gradient: LinearGradient(
//                                                     begin: Alignment.centerLeft,
//                                                     end: Alignment.centerRight,
//                                                     colors: [
//                                                       theme.cardColor,
//                                                       ThemeConstants.themeMode
//                                                                   .value ==
//                                                               ThemeMode.light
//                                                           ? theme.cardColor
//                                                           : Color(0xff3A424B),
//                                                     ])),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(16),
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     child: SvgPicture.asset(
//                                                         "assets/images/tools/algo.svg",color:Color(0xFF5367FC)),
//                                                     // child: SvgPicture.asset("assets/images/options_simplified/ic_fast_option.svg", colorBlendMode: BlendMode.difference,),
//                                                     backgroundColor:
//                                                         ThemeConstants.themeMode
//                                                                     .value ==
//                                                                 ThemeMode.light
//                                                             ? Colors.white
//                                                             : Colors.black,
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Bigul Algos",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text(
//                                                       "Smart orders to get better prices",
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w300,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: theme.textTheme
//                                                           .bodyText1.color),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         ///--------------------------Easy Option--------------------///
//                                         InkWell(
//                                           onTap: () {
//                                             if (Dataconstants.osGuestUser) {
//                                               CommonFunction
//                                                   .showDialogGestLogin(
//                                                 context: context,
//                                                 comingFrom: "tools",
//                                                 title1: 'For Options ideas,',
//                                               );
//                                             } else {
//                                               setState(() {
//                                                 Dataconstants
//                                                         .isFromToolsToEasyOptions =
//                                                     true;
//                                               });
//                                             }
//                                             // CommonFunction.firebaselogEvent(true,"option_ideas","_Click","option_ideas");
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 gradient: LinearGradient(
//                                                     begin: Alignment.centerLeft,
//                                                     end: Alignment.centerRight,
//                                                     colors: [
//                                                       theme.cardColor,
//                                                       ThemeConstants.themeMode
//                                                                   .value ==
//                                                               ThemeMode.light
//                                                           ? theme.cardColor
//                                                           : Color(0xff3A424B),
//                                                     ])),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(16),
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     child: SvgPicture.asset(
//                                                         "assets/images/tools/fast_option.svg",color:Color(0xFF5367FC)),
//                                                     backgroundColor:
//                                                         ThemeConstants.themeMode
//                                                                     .value ==
//                                                                 ThemeMode.light
//                                                             ? Colors.white
//                                                             : Colors.black,
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Options ideas",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text(
//                                                       "Trading in options, now gets simple",
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.w300,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: theme.textTheme
//                                                           .bodyText1.color),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         ///--------------------------Flash Trade--------------------///
//                                         InkWell(
//                                           onTap: () {
//                                             // buySellIconColor=false;
//                                             Dataconstants.chartTickByTick = true;
//                                             Dataconstants
//                                                 .nullCheckFlashTradeLineDraw = null;
//                                             TimeOfDay intraDayTime =
//                                             TimeOfDay(hour: 9, minute: 0);
//                                             final now = new DateTime.now();
//                                             var finalIntraDayTime = DateTime(
//                                                 now.year,
//                                                 now.month,
//                                                 now.day,
//                                                 intraDayTime.hour,
//                                                 intraDayTime.minute)
//                                                 .subtract(Duration(
//                                                 hours: 5, minutes: 30));
//                                             //print(
//                                                 " finalIntraDayTime : $finalIntraDayTime");
//                                             var intraDayTimePass =
//                                             DateUtil.getIntFromDate1Chart(
//                                                 finalIntraDayTime.toString());
//                                             var fromDate = DateTime.now().subtract(
//                                                 const Duration(
//                                                     days: 1)); // DateTime.now();
//                                             //print('current date Time $fromDate');
//                                             var fromDatePass =
//                                             DateUtil.getIntFromDate1Chart(
//                                                 fromDate.toString());
//                                             //print('fromDate Pass $fromDatePass');
//
//                                             ///-----------------to date pass----------------------------------------- `
//                                             var toDate = DateTime.now().subtract(
//                                                 Duration(hours: 5, minutes: 30));
//                                             //print('toDate $toDate');
//                                             var toDatePass =
//                                             DateUtil.getIntFromDate1Chart(
//                                                 toDate.toString());
//                                             //print('toDate Pass $toDatePass');
//                                             //---------------------------- leftSideTime(FromDate)----------------------------------
//                                             DateTime lt = new DateTime(
//                                                 toDate.year,
//                                                 toDate.month,
//                                                 toDate.day - 30,
//                                                 9,
//                                                 0)
//                                                 .subtract(Duration(
//                                                 hours: 5, minutes: 30));
//                                             var leftSideTime =
//                                             DateUtil.getIntFromDate1Chart(
//                                                 lt.toString());
//                                             //print(leftSideTime);
//
//                                             // Dataconstants.modelFlashTrade =
//                                             //     Dataconstants.flashTradeModel
//                                             //         .favStock[0].model;
//                                             Dataconstants.modelFlashTrade=  CommonFunction.getScripDataModel(
//                                                 exch: "N",
//                                                 exchCode: 15083,    // 15083,
//                                                 getNseBseMap: true);
//                                             Dataconstants.qtyContoller.text = "1";
//
//                                             // Dataconstants.modelForChart =
//                                             //     Dataconstants.modelFlashTrade;
//                                             // Dataconstants.iqsClient
//                                             //     .sendChartRequest(
//                                             //   Dataconstants.modelFlashTrade,
//                                             //   intraDayTimePass,
//                                             // );
//
//                                             // SChart(
//                                             //   Dataconstants.modelFlashTrade,
//                                             //   exChar:    Dataconstants.modelFlashTrade.exch ,//'N',
//                                             //   scripCode:Dataconstants.modelFlashTrade.exchCode.toString(),// "22",
//                                             //   symbol: Dataconstants.modelFlashTrade.name.toString(), // 'ACC',
//                                             //   fromDate:leftSideTime.toString(),          // intraDayTimePass.toString(),// "1656185400",// intraDayTimePass.toString(),    // '1655839800',
//                                             //   toDate:  toDatePass.toString(),//  "1656308532", //  toDatePass.toString(),//    '1655980175',
//                                             //   timeInterval: '1',
//                                             //   chartPeriod: 'I',
//                                             //   volumeHidden:true,
//                                             // );
//
//                                             //-----------------------------------------chart End ---------------------------------
//                                             if (Dataconstants.osGuestUser) {
//                                               CommonFunction.showDialogGestLogin(
//                                                 context: context,
//                                                 comingFrom: "tools",
//                                                 title1: 'For Flash Trade,',
//                                               );
//                                             } else {
//                                               setState(() {
//                                                 Dataconstants.isFromToolsToFlashTrade = true;
//                                               });
//                                             }
//
//                                             Dataconstants.buySellButtonTickByTick =
//                                             false;
//                                             // Dataconstants.defaultBuySellChartSetting = true;
//                                             // CommonFunction.firebaselogEvent(true,"flash_trade","_Click","flash_trade");
//
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius.circular(5),
//                                                 gradient: LinearGradient(
//                                                     begin: Alignment.centerLeft,
//                                                     end: Alignment.centerRight,
//                                                     colors: [
//                                                       theme.cardColor,
//                                                       ThemeConstants.themeMode
//                                                           .value ==
//                                                           ThemeMode.light
//                                                           ? theme.cardColor
//                                                           : Color(0xff3A424B),
//                                                     ])),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.all(16),
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     child: Image.asset(
//                                                         "assets/images/tools/flash_trade.png",color:Color(0xFF5367FC)),
//                                                     backgroundColor: ThemeConstants
//                                                         .themeMode.value ==
//                                                         ThemeMode.light
//                                                         ? Colors.white
//                                                         : Colors.black,
//                                                   ),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Flash Trade",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                           FontWeight.w500,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text(
//                                                       "Quick and Simple way to trade F&O",
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                           FontWeight.w300,
//                                                           color: theme.textTheme
//                                                               .bodyText1.color),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding: const EdgeInsets.all(10),
//                                                   child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       color: theme.textTheme
//                                                           .bodyText1.color),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         // Stack(
//                                         //   children: [
//                                         //     InkWell(
//                                         //       onTap: () {
//                                         //         // setState(() {
//                                         //         //   Dataconstants.isFromToolsToAlgo=true;
//                                         //         // });
//                                         //       },
//                                         //       child: Container(
//                                         //         height: 80,
//                                         //         decoration: BoxDecoration(
//                                         //             borderRadius: BorderRadius.circular(5),
//                                         //             gradient: LinearGradient(
//                                         //                 begin: Alignment.centerLeft,
//                                         //                 end: Alignment.centerRight,
//                                         //                 colors: [
//                                         //                   theme.cardColor,
//                                         //                   ThemeConstants.themeMode.value ==
//                                         //                           ThemeMode.light
//                                         //                       ? theme.cardColor
//                                         //                       : Color(0xff3A424B),
//                                         //                 ])),
//                                         //         child: Row(
//                                         //           crossAxisAlignment:
//                                         //               CrossAxisAlignment.center,
//                                         //           children: [
//                                         //             Padding(
//                                         //               padding: const EdgeInsets.all(16),
//                                         //               child: CircleAvatar(
//                                         //                 radius: 25,
//                                         //                 child: Image.asset(
//                                         //                     "assets/images/tools/fast_option.svg"),
//                                         //                 backgroundColor: ThemeConstants
//                                         //                             .themeMode.value ==
//                                         //                         ThemeMode.light
//                                         //                     ? Colors.white
//                                         //                     : Colors.black,
//                                         //               ),
//                                         //             ),
//                                         //             Column(
//                                         //               crossAxisAlignment:
//                                         //                   CrossAxisAlignment.start,
//                                         //               mainAxisAlignment:
//                                         //                   MainAxisAlignment.center,
//                                         //               children: [
//                                         //                 Text(
//                                         //                   "Easy Options",
//                                         //                   style: TextStyle(
//                                         //                       fontSize: 16,
//                                         //                       fontWeight: FontWeight.w500,
//                                         //                       color: theme.textTheme
//                                         //                           .bodyText1.color),
//                                         //                 ),
//                                         //                 SizedBox(
//                                         //                   height: 8,
//                                         //                 ),
//                                         //                 Text(
//                                         //                   "Trading in options, now gets simple",
//                                         //                   style: TextStyle(
//                                         //                       fontSize: 11,
//                                         //                       fontWeight: FontWeight.w300,
//                                         //                       color: theme.textTheme
//                                         //                           .bodyText1.color),
//                                         //                 ),
//                                         //               ],
//                                         //             ),
//                                         //           ],
//                                         //         ),
//                                         //       ),
//                                         //     ),
//                                         //     Positioned(
//                                         //       top: 0,
//                                         //       right: 0,
//                                         //       child: Container(
//                                         //         height: 18,
//                                         //         width: 85,
//                                         //         alignment: Alignment.center,
//                                         //         decoration: BoxDecoration(
//                                         //             color: ThemeConstants.themeMode.value ==
//                                         //                     ThemeMode.light
//                                         //                 ? Color(0xff353535)
//                                         //                 : Colors.white,
//                                         //             borderRadius: BorderRadius.only(
//                                         //               topLeft: Radius.circular(10),
//                                         //               bottomLeft: Radius.circular(10),
//                                         //               topRight: Radius.circular(5),
//                                         //             )),
//                                         //         child: Text(
//                                         //           "Coming Soon",
//                                         //           style: TextStyle(
//                                         //               fontSize: 12,
//                                         //               color:
//                                         //                   ThemeConstants.themeMode.value ==
//                                         //                           ThemeMode.light
//                                         //                       ? Colors.white
//                                         //                       : Color(0xff353535)),
//                                         //         ),
//                                         //       ),
//                                         //     )
//                                         //   ],
//                                         // )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//       ),
//     );
//   }
// }
