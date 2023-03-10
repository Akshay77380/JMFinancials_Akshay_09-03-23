// import 'dart:developer';
//
// import 'package:BOB/jmScreens/orders/order_filters.dart';
// import 'package:BOB/widget/custom_tab_bar.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../controllers/orderBookController.dart';
// import '../../controllers/scannerController.dart';
// import '../../model/scrip_info_model.dart';
// import '../../style/theme.dart';
// import '../../util/CommonFunctions.dart';
// import '../../util/Dataconstants.dart';
// import '../../util/InAppSelections.dart';
// import '../../util/Utils.dart';
// import '../../widget/smallChart.dart';
// import 'EquityAndDerivativeIndicatorData.dart';
// import 'EquityControllerClass.dart';
// import 'Scanners.dart';
// import 'SqliteDatabase.dart';
//
// class ScannersView extends StatefulWidget {
//   const ScannersView({Key key}) : super(key: key);
//
//   @override
//   State<ScannersView> createState() => _ScannersViewState();
// }
//
// class _ScannersViewState extends State<ScannersView>
//     with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
//   TabController _tabController;
//   List<ScannerConditions> conditionList = [];
//   Map<String, int> categorylist = Map();
//   int _currentIndex = 0, i = 0;
//   int _bullishCurrentIndex = 0;
//   String selectedFiltered = "Nse F&O Scrips";
//   Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     DataConstants.scannerData = Get.put(ScannerController());
//     _tabController = TabController(vsync: this, length: 3);
//     super.initState();
//     conditionEnumMap[ScannerConditions.RedBody] = new Conditions(
//         lName: 'Red Body',
//         readDB: false,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.RedBody,
//         scanId: "1");
//
//     conditionEnumMap[ScannerConditions.GapDown] = new Conditions(
//         lName: 'Gap Down',
//         readDB: false,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.GapDown,
//         scanId: "2");
//
//     conditionEnumMap[ScannerConditions.openEqualToHigh] = new Conditions(
//         lName: 'Open = High',
//         readDB: false,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.openEqualToHigh,
//         scanId: "3");
//
//     conditionEnumMap[ScannerConditions.CLoseBelowPrevDayLow] = new Conditions(
//         lName: 'Close Below Prev Day Low',
//         readDB: false,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.CLoseBelowPrevDayLow,
//         scanId: "4");
//
//     conditionEnumMap[ScannerConditions.CLoseBelowPrevWeekLow] = new Conditions(
//         lName: 'Close Below Prev Week Low',
//         readDB: true,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.CLoseBelowPrevWeekLow,
//         scanId: "5",
//         allowed: false);
//
//     conditionEnumMap[ScannerConditions.CLoseBelowPrevMonthLow] = new Conditions(
//         lName: 'Close Below Prev Month Low',
//         readDB: true,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.CLoseBelowPrevMonthLow,
//         scanId: "6");
//
//     conditionEnumMap[ScannerConditions.CloseBelow5DayLow] = new Conditions(
//         lName: 'Close Below 5 Day Low',
//         readDB: true,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.CloseBelow5DayLow,
//         scanId: "7");
//
//     conditionEnumMap[ScannerConditions.GreenBody] = new Conditions(
//         lName: 'Green Body',
//         readDB: false,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.GreenBody,
//         scanId: "8");
//
//     conditionEnumMap[ScannerConditions.GapUp] = new Conditions(
//         lName: 'Gap Up',
//         readDB: false,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.GapUp,
//         scanId: "9");
//
//     conditionEnumMap[ScannerConditions.openEqualToLow] = new Conditions(
//         lName: 'Open = Low',
//         readDB: false,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.openEqualToLow,
//         scanId: "10");
//
//     conditionEnumMap[ScannerConditions.PriceTrendRisingLast2Days] =
//         new Conditions(
//             lName: 'Price Trend Rising Last 2 Days',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.PriceTrendRisingLast2Days,
//             scanId: "11");
//
//     conditionEnumMap[ScannerConditions.PriceTrendFallingLast2Days] =
//         new Conditions(
//             lName: 'Price Trend Falling Last 2 Days',
//             readDB: true,
//             category: "Price Bearish",
//             scannerConditions: ScannerConditions.PriceTrendFallingLast2Days,
//             scanId: "12");
//
//     conditionEnumMap[ScannerConditions.DoubleBottom2DaysReversal] =
//         new Conditions(
//             lName: 'Double Bottom 2 Days Reversal',
//             readDB: false,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.DoubleBottom2DaysReversal,
//             scanId: "13");
//
//     conditionEnumMap[ScannerConditions.PriceDownwardReversal] = new Conditions(
//         lName: 'Price Downward Reversal',
//         readDB: true,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.PriceDownwardReversal,
//         scanId: "14");
//
//     conditionEnumMap[ScannerConditions.CloseAbovePrevDayHigh] = new Conditions(
//         lName: 'Close Above Prev Day High',
//         readDB: false,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.CloseAbovePrevDayHigh,
//         scanId: "15");
//
//     conditionEnumMap[ScannerConditions.CloseAbovePrevWeekHigh] = new Conditions(
//         lName: 'Close Above Prev Week High',
//         readDB: true,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.CloseAbovePrevWeekHigh,
//         scanId: "16",
//         allowed: false);
//
//     conditionEnumMap[ScannerConditions.CloseAbovePrevMonthHigh] =
//         new Conditions(
//             lName: 'Close Above Prev Month High',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.CloseAbovePrevMonthHigh,
//             scanId: "17");
//
//     conditionEnumMap[ScannerConditions.CloseAbove5DayHigh] = new Conditions(
//         lName: 'Close Above 5 Day High',
//         readDB: true,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.CloseAbove5DayHigh,
//         scanId: "18");
//
//     conditionEnumMap[ScannerConditions.Doubletop2DaysReversal] = new Conditions(
//         lName: 'Double top 2 Days Reversal',
//         readDB: false,
//         category: "Price Bearish",
//         scannerConditions: ScannerConditions.Doubletop2DaysReversal,
//         scanId: "19");
//
//     conditionEnumMap[ScannerConditions.PriceUpwardReversal] = new Conditions(
//         lName: 'Price Upward Reversal',
//         readDB: true,
//         category: "Price Bullish",
//         scannerConditions: ScannerConditions.PriceUpwardReversal,
//         scanId: "20");
//
//     conditionEnumMap[ScannerConditions.VolumeRaiseAbove50] = new Conditions(
//         lName: 'Vol 50% Above Prev. Day',
//         readDB: true,
//         category: "Volume Rising",
//         scannerConditions: ScannerConditions.VolumeRaiseAbove50,
//         scanId: "21");
//
//     conditionEnumMap[ScannerConditions.VolumeRaiseAbove100] = new Conditions(
//         lName: 'Vol 100% Above Prev. Day',
//         readDB: true,
//         category: "Volume Rising",
//         scannerConditions: ScannerConditions.VolumeRaiseAbove100,
//         scanId: "22");
//
//     conditionEnumMap[ScannerConditions.VolumeRaiseAbove200] = new Conditions(
//         lName: 'Vol 200% Above Prev. Day',
//         readDB: true,
//         category: "Volume Rising",
//         scannerConditions: ScannerConditions.VolumeRaiseAbove200,
//         scanId: "23");
//
//     conditionEnumMap[ScannerConditions.PriceAboveR4] = new Conditions(
//         lName: 'Price Above R4',
//         readDB: false,
//         category: "Pivot Bullish",
//         scannerConditions: ScannerConditions.PriceAboveR4,
//         scanId: "24");
//
//     conditionEnumMap[ScannerConditions.PriceAboveR3] = new Conditions(
//         lName: 'Price Above R3',
//         readDB: false,
//         category: "Pivot Bullish",
//         scannerConditions: ScannerConditions.PriceAboveR3,
//         scanId: "25");
//
//     conditionEnumMap[ScannerConditions.PriceAboveR2] = new Conditions(
//         lName: 'Price Above R2',
//         readDB: false,
//         category: "Pivot Bullish",
//         scannerConditions: ScannerConditions.PriceAboveR2,
//         scanId: "26");
//
//     conditionEnumMap[ScannerConditions.PriceAboveR1] = new Conditions(
//         lName: 'Price Above R1',
//         readDB: false,
//         category: "Pivot Bullish",
//         scannerConditions: ScannerConditions.PriceAboveR1,
//         scanId: "27");
//
//     conditionEnumMap[ScannerConditions.PriceAbovePivot] = new Conditions(
//         lName: 'Price Above Pivot',
//         readDB: false,
//         category: "Pivot Bullish",
//         scannerConditions: ScannerConditions.PriceAbovePivot,
//         scanId: "28");
//
//     conditionEnumMap[ScannerConditions.PriceBelowS4] = new Conditions(
//         lName: 'Price Below S4',
//         readDB: false,
//         category: "Pivot Bearish",
//         scannerConditions: ScannerConditions.PriceBelowS4,
//         scanId: "29");
//
//     conditionEnumMap[ScannerConditions.PriceBelowS3] = new Conditions(
//         lName: 'Price Below S3',
//         readDB: false,
//         category: "Pivot Bearish",
//         scannerConditions: ScannerConditions.PriceBelowS3,
//         scanId: "30");
//
//     conditionEnumMap[ScannerConditions.PriceBelowS2] = new Conditions(
//         lName: 'Price Below S2',
//         readDB: false,
//         category: "Pivot Bearish",
//         scannerConditions: ScannerConditions.PriceBelowS2,
//         scanId: "31");
//
//     conditionEnumMap[ScannerConditions.PriceBelowS1] = new Conditions(
//         lName: 'Price Below S1',
//         readDB: false,
//         category: "Pivot Bearish",
//         scannerConditions: ScannerConditions.PriceBelowS1,
//         scanId: "32");
//
//     conditionEnumMap[ScannerConditions.PriceBelowPivot] = new Conditions(
//         lName: 'Price Below Pivot',
//         readDB: false,
//         category: "Pivot Bearish",
//         scannerConditions: ScannerConditions.PriceBelowPivot,
//         scanId: "33");
//
//     conditionEnumMap[ScannerConditions.PriceGrowth1YearAbove25] =
//         new Conditions(
//             lName: 'Price-Growth 1 Yr Abv 25%',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.PriceGrowth1YearAbove25,
//             scanId: "33B");
//
//     conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween25To50] =
//         new Conditions(
//             lName: 'Price-Growth 3 Yr Btw 25%-50%',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.PriceGrowth3YearBetween25To50,
//             scanId: "34");
//
//     conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween50To100] =
//         new Conditions(
//             lName: 'Price-Growth 3 Yr Btw 50%-100%',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.PriceGrowth3YearBetween50To100,
//             scanId: "35");
//
//     conditionEnumMap[ScannerConditions.PriceGrowth3YearAbove100] =
//         new Conditions(
//             lName: 'Price-Growth 3 Yr Abv 100%',
//             readDB: true,
//             category: "Price Bullish",
//             scannerConditions: ScannerConditions.PriceGrowth3YearAbove100,
//             scanId: "36");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSMA5] = new Conditions(
//         lName: 'Price Above SMA-5',
//         readDB: true,
//         category: "Average Bullish",
//         scannerConditions: ScannerConditions.PriceAboveSMA5,
//         scanId: "37");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSMA20] = new Conditions(
//         lName: 'Price Above SMA-20',
//         readDB: true,
//         category: "Average Bullish",
//         scannerConditions: ScannerConditions.PriceAboveSMA20,
//         scanId: "38");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSMA50] = new Conditions(
//         lName: 'Price Above SMA-50',
//         readDB: true,
//         category: "Average Bullish",
//         scannerConditions: ScannerConditions.PriceAboveSMA50,
//         scanId: "39");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSMA100] = new Conditions(
//         lName: 'Price Above SMA-100',
//         readDB: true,
//         category: "Average Bullish",
//         scannerConditions: ScannerConditions.PriceAboveSMA100,
//         scanId: "40");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSMA200] = new Conditions(
//         lName: 'Price Above SMA-200',
//         readDB: true,
//         category: "Average Bullish",
//         scannerConditions: ScannerConditions.PriceAboveSMA200,
//         scanId: "40B");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSMA5] = new Conditions(
//         lName: 'Price Below SMA-5',
//         readDB: true,
//         category: "Average Bearish",
//         scannerConditions: ScannerConditions.PriceBelowSMA5,
//         scanId: "41");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSMA20] = new Conditions(
//         lName: 'Price Below SMA-20',
//         readDB: true,
//         category: "Average Bearish",
//         scannerConditions: ScannerConditions.PriceBelowSMA20,
//         scanId: "42");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSMA50] = new Conditions(
//         lName: 'Price Below SMA-50',
//         readDB: true,
//         category: "Average Bearish",
//         scannerConditions: ScannerConditions.PriceBelowSMA50,
//         scanId: "43");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSMA100] = new Conditions(
//         lName: 'Price Below SMA-100',
//         readDB: true,
//         category: "Average Bearish",
//         scannerConditions: ScannerConditions.PriceBelowSMA100,
//         scanId: "44");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSMA200] = new Conditions(
//         lName: 'Price Below SMA-200',
//         readDB: true,
//         category: "Average Bearish",
//         scannerConditions: ScannerConditions.PriceBelowSMA200,
//         scanId: "45");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSuperTrend1] = new Conditions(
//         lName: 'Price Above SuperTrend 1',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceAboveSuperTrend1,
//         scanId: "46");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSuperTrend2] = new Conditions(
//         lName: 'Price Above SuperTrend 2',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceAboveSuperTrend2,
//         scanId: "47");
//
//     conditionEnumMap[ScannerConditions.PriceAboveSuperTrend3] = new Conditions(
//         lName: 'Price Above SuperTrend 3',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceAboveSuperTrend3,
//         scanId: "48");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSuperTrend1] = new Conditions(
//         lName: 'Price Below SuperTrend 1',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceBelowSuperTrend1,
//         scanId: "49");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSuperTrend2] = new Conditions(
//         lName: 'Price Below SuperTrend 2',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceBelowSuperTrend2,
//         scanId: "50");
//
//     conditionEnumMap[ScannerConditions.PriceBelowSuperTrend3] = new Conditions(
//         lName: 'Price Below SuperTrend 3',
//         readDB: true,
//         category: "SuperTrend",
//         scannerConditions: ScannerConditions.PriceBelowSuperTrend3,
//         scanId: "51");
//
//     conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend1and2] =
//         new Conditions(
//             lName: 'Price Btw SuperTrend 1 & 2',
//             readDB: true,
//             category: "SuperTrend",
//             scannerConditions: ScannerConditions.PriceBetweenSuperTrend1and2,
//             scanId: "52");
//
//     conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend2and3] =
//         new Conditions(
//             lName: 'Price Btw SuperTrend 2 & 3',
//             readDB: true,
//             category: "SuperTrend",
//             scannerConditions: ScannerConditions.PriceBetweenSuperTrend2and3,
//             scanId: "53");
//
//     conditionEnumMap[ScannerConditions.RSIOverSold30] = new Conditions(
//         lName: 'RSI Over Sold30',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIOverSold30,
//         scanId: "54");
//
//     conditionEnumMap[ScannerConditions.RSIBetween30To50] = new Conditions(
//         lName: 'RSI Between 30 To 50',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIBetween30To50,
//         scanId: "55");
//
//     conditionEnumMap[ScannerConditions.RSIBetween50TO70] = new Conditions(
//         lName: 'RSI Between 50 To 70',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIBetween50TO70,
//         scanId: "56");
//
//     conditionEnumMap[ScannerConditions.RSIOverBought70] = new Conditions(
//         lName: 'RSI OverBought 70',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIOverBought70,
//         scanId: "57");
//
//     conditionEnumMap[ScannerConditions.RSIAboveRSIAvg30] = new Conditions(
//         lName: 'RSI Above RSI Avg30',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIAboveRSIAvg30,
//         scanId: "58");
//
//     conditionEnumMap[ScannerConditions.RSIBelowRSIAvg30] = new Conditions(
//         lName: 'RSI Below RSI Avg30',
//         readDB: true,
//         category: "RSI Relative Strength Index",
//         scannerConditions: ScannerConditions.RSIBelowRSIAvg30,
//         scanId: "59");
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   DataConstants.scannerData.getData(
//     //       conditionEnumMap: conditionEnumMap,
//     //       selectedCondition: DataConstants.scannerTabControllerIndex == 0
//     //           ? DataConstants.selectedScannerConditionForBullish
//     //           : DataConstants.scannerTabControllerIndex == 1
//     //               ? DataConstants.selectedScannerConditionForBearish
//     //               : DataConstants.selectedScannerConditionForOthers,
//     //       dropDownValue: DataConstants.selectedFilterName);
//     // });
//     conditionEnumMap.forEach((key, value) {
//       conditionList.add(key);
//       categorylist[value.category.contains("Bullish")
//           ? "Bullish"
//           : value.category.contains("Bearish")
//               ? "Bearish"
//               : "Others"] = categorylist.containsKey(value.category) ? i++ : 0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back)),
//         title: Row(
//           children: [
//             Text(
//               "Scanners",
//               style: Utils.fonts(color: Utils.blackColor, size: 18.0),
//             ),
//             Icon(
//               Icons.arrow_drop_down_rounded,
//               color: Utils.greyColor,
//             ),
//             Icon(
//               Icons.rotate_90_degrees_ccw,
//               color: Utils.greyColor,
//             ),
//           ],
//         ),
//         actions: [
//           SizedBox(
//             width: 20,
//           ),
//           InkWell(
//               onTap: () {},
//               child: SvgPicture.asset('assets/appImages/tranding.svg')),
//           SizedBox(
//             width: 10,
//           ),
//           InkWell(
//             onTap: () {
//               showModalBottomSheet<void>(
//                   isScrollControlled: true,
//                   context: context,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10))),
//                   builder: (BuildContext context) =>
//                       ScannerSortFilters(OrderBookController.ScannersFilters));
//             },
//             child: Icon(
//               Icons.more_vert,
//               color: Utils.greyColor,
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60.0),
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 16,
//                   ),
//                   TabBar(
//                     isScrollable: true,
//                     physics: CustomTabBarScrollPhysics(),
//                     labelStyle:
//                         Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
//                     unselectedLabelStyle:
//                         Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
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
//                     onTap: (_index) async{
//                       setState(() {
//                         _currentIndex = _index;
//                       });
//                       DataConstants.scannerTabControllerIndex = _index;
//                       await DataConstants.scannerData.getData(
//                           conditionEnumMap: conditionEnumMap,
//                           selectedCondition:
//                               DataConstants.scannerTabControllerIndex == 0
//                                   ? DataConstants
//                                       .selectedScannerConditionForBullish
//                                   : DataConstants.scannerTabControllerIndex == 1
//                                       ? DataConstants
//                                           .selectedScannerConditionForBearish
//                                       : DataConstants
//                                           .selectedScannerConditionForOthers,
//                           dropDownValue: DataConstants.selectedFilterName);
//                     },
//                     tabs: [
//                       Tab(
//                         child: Text(
//                           "Bullish",
//                           style: Utils.fonts(
//                               size: _currentIndex == 0 ? 13.0 : 11.0),
//                         ),
//                       ),
//                       Tab(
//                         child: Text(
//                           "Bearish",
//                           style: Utils.fonts(
//                               size: _currentIndex == 1 ? 13.0 : 11.0),
//                         ),
//                       ),
//                       Tab(
//                         child: Text(
//                           "Others",
//                           style: Utils.fonts(
//                               size: _currentIndex == 2 ? 13.0 : 11.0),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: TabBarView(
//             physics: CustomTabBarScrollPhysics(),
//             controller: _tabController,
//             children: [
//               bullishWidget(
//                   ),
//               bearishWidget(),
//               otherWidget(),
//             ],
//           )),
//     );
//   }
// }
//
// class bearishWidget extends StatefulWidget {
//   const bearishWidget({Key key}) : super(key: key);
//
//   @override
//   State<bearishWidget> createState() => _bearishWidgetState();
// }
//
// class _bearishWidgetState extends State<bearishWidget> {
//   List<ScannerConditions> conditionList = [];
//   Map<String, int> categorylist = Map();
//   int i = 0;
//   Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
//
//   @override
//   void initState() {
//     // CommonFunction.getData(
//     //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
//     //     dropDownValue: DataConstants.selectedFilterName,
//     //     conditionEnumMap: widget.conditionEnumMap);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //print("build");
//     var theme = Theme.of(context);
//     return Column(
//       children: [
//         Obx(() {
//           return ScannerController.isLoading.value
//               ? CircularProgressIndicator()
//               : Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async{
//                      await DataConstants.scannerData.getData(
//                           conditionEnumMap: conditionEnumMap,
//                           selectedCondition:
//                               DataConstants.scannerTabControllerIndex == 0
//                                   ? DataConstants
//                                       .selectedScannerConditionForBullish
//                                   : DataConstants.scannerTabControllerIndex == 1
//                                       ? DataConstants
//                                           .selectedScannerConditionForBearish
//                                       : DataConstants
//                                           .selectedScannerConditionForOthers,
//                           dropDownValue: DataConstants.selectedFilterName);
//
//                       return Future.value(true);
//                     },
//
//                     child: ListView.builder(
//
//                       shrinkWrap: true,
//                       physics: AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return MarketWatchRow(
//                           index: index,
//                           data: ScannerController.data[index],
//                         );
//                       },
//                       itemCount: ScannerController.data.length,
//                     ),
//                   ),
//                 );
//         })
//       ],
//     );
//   }
// }
//
// class otherWidget extends StatefulWidget {
//   const otherWidget({Key key}) : super(key: key);
//
//   @override
//   State<otherWidget> createState() => _otherWidgetState();
// }
//
// class _otherWidgetState extends State<otherWidget> {
//   List<ScannerConditions> conditionList = [];
//   Map<String, int> categorylist = Map();
//   int i = 0;
//   Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
//
//   @override
//   void initState() {
//     // CommonFunction.getData(
//     //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
//     //     dropDownValue: DataConstants.selectedFilterName,
//     //     conditionEnumMap: widget.conditionEnumMap);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return Column(
//       children: [
//         Obx(() {
//           return ScannerController.isLoading.value
//               ? CircularProgressIndicator()
//               : Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async {
//                      await DataConstants.scannerData.getData(
//                           conditionEnumMap: conditionEnumMap,
//                           selectedCondition:
//                               DataConstants.scannerTabControllerIndex == 0
//                                   ? DataConstants
//                                       .selectedScannerConditionForBullish
//                                   : DataConstants.scannerTabControllerIndex == 1
//                                       ? DataConstants
//                                           .selectedScannerConditionForBearish
//                                       : DataConstants
//                                           .selectedScannerConditionForOthers,
//                           dropDownValue: DataConstants.selectedFilterName);
//
//                       return Future.value(true);
//                     },
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return MarketWatchRow(
//                           index: index,
//                           data: ScannerController.data[index],
//                         );
//                       },
//                       itemCount: ScannerController.data.length,
//                     ),
//                   ),
//                 );
//         })
//       ],
//     );
//   }
// }
//
// class bullishWidget extends StatefulWidget {
//   // final dropDownValue;
//   // final Map<ScannerConditions, Conditions> conditionEnumMap;
//   // final ScannerConditions selectedCondition;
//
//   const bullishWidget({
//     Key key,
//     // this.conditionEnumMap,
//     // this.selectedCondition,
//     // this.dropDownValue
//   }) : super(key: key);
//
//   @override
//   State<bullishWidget> createState() => _bullishWidgetState();
// }
//
// class _bullishWidgetState extends State<bullishWidget> {
//   List<ScannerConditions> conditionList = [];
//   Map<String, int> categorylist = Map();
//   int i = 0;
//   Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
//
//   @override
//   void initState() {
//     // CommonFunction.getData(
//     //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
//     //     dropDownValue: DataConstants.selectedFilterName,
//     //     conditionEnumMap: widget.conditionEnumMap);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return Column(
//       children: [
//         Obx(() {
//           return ScannerController.isLoading.value
//               ? CircularProgressIndicator()
//               : Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async{
//                       await DataConstants.scannerData.getData(
//                           conditionEnumMap: conditionEnumMap,
//                           selectedCondition:
//                               DataConstants.scannerTabControllerIndex == 0
//                                   ? DataConstants
//                                       .selectedScannerConditionForBullish
//                                   : DataConstants.scannerTabControllerIndex == 1
//                                       ? DataConstants
//                                           .selectedScannerConditionForBearish
//                                       : DataConstants
//                                           .selectedScannerConditionForOthers,
//                           dropDownValue: DataConstants.selectedFilterName);
//
//                       return Future.value(true);
//                     },
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return MarketWatchRow(
//                           index: index,
//                           data: ScannerController.data[index],
//                         );
//                       },
//                       itemCount: ScannerController.data.length,
//                     ),
//                   ),
//                 );
//         })
//       ],
//     );
//   }
// }
//
// class MarketWatchRow extends StatelessWidget {
//   final EquityControllerClass data;
//   final int index;
//
//   MarketWatchRow({this.index, this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     //print("Scanner data length => ${ScannerController.data.length}");
//     var theme = Theme.of(context);
//     return InkWell(
//       onTap: () {},
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
//                       Text(data.scName,
//                           style:
//                               Utils.fonts(size: 14.0, fontWeight: FontWeight.w600)
//                           // style: TextStyle(
//                           //   fontSize: 15,
//                           // ),
//                           ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Row(
//                         children: [
//                           /* Displaying the Script exchange Name */
//                           Text("${data.model.exchName}",
//                               style: Utils.fonts(
//                                   size: 12.0,
//                                   fontWeight: FontWeight.w500,
//                                   color: Utils.greyColor)
//                               // style: const TextStyle(
//                               //     fontSize: 13, color: Colors.grey),
//                               ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Spacer(),
//                 /* Displaying the Script chart */
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Observer(
//                         /* Checking if we got the chart data of the current script by checking its array length,
//                          if not then shrink. The UI will throw erreo */
//                         builder: (context) =>
//                             data.model.chartMinClose[15].length > 0
//                                 ? SmallSimpleLineChart(
//                                     seriesList:
//                                         data.model.dataPoint[15],
//                                     prevClose: data.model.prevDayClose,
//                                     name: data.model.name,
//                                   )
//                                 : const SizedBox.shrink(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Spacer(),
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
//                             builder: (_) => Row(
//                               children: [
//                                 Text(
//                                     /* If the LTP is zero before or after market time, it is showing previous day close(ltp) from the model */
//                                     data.model
//                                                 .close ==
//                                             0.00
//                                         ? data.model
//                                             .prevDayClose
//                                             .toStringAsFixed(data.model
//                                                         .series ==
//                                                     'Curr'
//                                                 ? 4
//                                                 : 2)
//                                         : data.model
//                                             .close
//                                             .toStringAsFixed(data.model
//                                                         .series ==
//                                                     'Curr'
//                                                 ? 4
//                                                 : 2),
//                                     style: Utils.fonts(
//                                       size: 14.0,
//                                       fontWeight: FontWeight.w600,
//                                       color: Utils.blackColor,
//                                     )),
//                               ],
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
//                                 /* If the LTP is zero before or after market time, it is showing zero instead of price change */
//                                 data.model.close ==
//                                         0.00
//                                     ? "0.00"
//                                     : data.model
//                                         .priceChangeText,
//                                 style: Utils.fonts(
//                                   size: 12.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: data.model
//                                               .priceChange >
//                                           0
//                                       ? ThemeConstants.buyColor
//                                       : data.model
//                                                   .priceChange <
//                                               0
//                                           ? ThemeConstants.sellColor
//                                           : theme.textTheme.bodyText1.color,
//                                 )),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           /* Displaying the percentage change of the script */
//                           Observer(
//                             builder: (_) => Text(
//                                 /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
//                               data.model.close ==
//                                         0.00
//                                     ? "(0.00%)"
//                                     : data.model.percentChangeText,
//                                 // style: Utils.fonts(
//                                 //   size: 12.0,
//                                 //   fontWeight: FontWeight.w600,
//                                 //   color: DataConstants
//                                 //               .marketWatchListeners[watchlistNo]
//                                 //               .watchList[index]
//                                 //               .percentChange >
//                                 //           0
//                                 //       ? ThemeConstants.buyColor
//                                 //       : DataConstants
//                                 //                   .marketWatchListeners[
//                                 //                       watchlistNo]
//                                 //                   .watchList[index]
//                                 //                   .percentChange <
//                                 //               0
//                                 //           ? ThemeConstants.sellColor
//                                 //           : theme.textTheme.bodyText1.color,
//                                 // )
//                                 style: TextStyle(
//                                   color: data.model
//                                               .percentChange >
//                                           0
//                                       ? ThemeConstants.buyColor
//                                       : data.model
//                                                   .percentChange <
//                                               0
//                                           ? ThemeConstants.sellColor
//                                           : theme.textTheme.bodyText1.color,
//                                 ),
//                                 ),
//                           ),
//                           Observer(
//                               builder: (_) => Container(
//                                     margin: EdgeInsets.zero,
//                                     padding: EdgeInsets.zero,
//                                     child: IconButton(
//                                       constraints: BoxConstraints(),
//                                       padding: const EdgeInsets.all(0),
//                                       icon: Icon(data.model
//                                                   .close >
//                                           data.model
//                                                   .prevTickRate
//                                           ? Icons.arrow_drop_up_rounded
//                                           : Icons.arrow_drop_down_rounded),
//                                       color: data.model
//                                                   .close >
//                                           data.model
//                                                   .prevTickRate
//                                           ? ThemeConstants.buyColor
//                                           : ThemeConstants.sellColor,
//                                     ),
//                                   ))
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

import 'dart:developer';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/orderBookController.dart';
import '../../controllers/scannerController.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../../widget/smallChart.dart';
import '../orders/order_filters.dart';
import 'EquityAndDerivativeIndicatorData.dart';
import 'EquityControllerClass.dart';
import 'Scanners.dart';
import 'SqliteDatabase.dart';

class ScannersView extends StatefulWidget {
  const ScannersView({Key key}) : super(key: key);

  @override
  State<ScannersView> createState() => _ScannersViewState();
}

class _ScannersViewState extends State<ScannersView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController _tabController;
  List<ScannerConditions> conditionList = [];
  Map<String, int> categorylist = Map();
  int _currentIndex = 0, i = 0;
  int _bullishCurrentIndex = 0;
  String selectedFiltered = "Nse F&O Scrips";
  Map<ScannerConditions, Conditions> conditionEnumMap = new Map();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Dataconstants.scannerData = Get.put(ScannerController());
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
    conditionEnumMap[ScannerConditions.RedBody] = new Conditions(
        lName: 'Red Body',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.RedBody,
        scanId: "1");

    conditionEnumMap[ScannerConditions.GapDown] = new Conditions(
        lName: 'Gap Down',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.GapDown,
        scanId: "2");

    conditionEnumMap[ScannerConditions.openEqualToHigh] = new Conditions(
        lName: 'Open = High',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.openEqualToHigh,
        scanId: "3");

    conditionEnumMap[ScannerConditions.CLoseBelowPrevDayLow] = new Conditions(
        lName: 'Close Below Prev Day Low',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevDayLow,
        scanId: "4");

    conditionEnumMap[ScannerConditions.CLoseBelowPrevWeekLow] = new Conditions(
        lName: 'Close Below Prev Week Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevWeekLow,
        scanId: "5",
        allowed: false);

    conditionEnumMap[ScannerConditions.CLoseBelowPrevMonthLow] = new Conditions(
        lName: 'Close Below Prev Month Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevMonthLow,
        scanId: "6");

    conditionEnumMap[ScannerConditions.CloseBelow5DayLow] = new Conditions(
        lName: 'Close Below 5 Day Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CloseBelow5DayLow,
        scanId: "7");

    conditionEnumMap[ScannerConditions.GreenBody] = new Conditions(
        lName: 'Green Body',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.GreenBody,
        scanId: "8");

    conditionEnumMap[ScannerConditions.GapUp] = new Conditions(
        lName: 'Gap Up',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.GapUp,
        scanId: "9");

    conditionEnumMap[ScannerConditions.openEqualToLow] = new Conditions(
        lName: 'Open = Low',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.openEqualToLow,
        scanId: "10");

    conditionEnumMap[ScannerConditions.PriceTrendRisingLast2Days] =
    new Conditions(
        lName: 'Price Trend Rising Last 2 Days',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceTrendRisingLast2Days,
        scanId: "11");

    conditionEnumMap[ScannerConditions.PriceTrendFallingLast2Days] =
    new Conditions(
        lName: 'Price Trend Falling Last 2 Days',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.PriceTrendFallingLast2Days,
        scanId: "12");

    conditionEnumMap[ScannerConditions.DoubleBottom2DaysReversal] =
    new Conditions(
        lName: 'Double Bottom 2 Days Reversal',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.DoubleBottom2DaysReversal,
        scanId: "13");

    conditionEnumMap[ScannerConditions.PriceDownwardReversal] = new Conditions(
        lName: 'Price Downward Reversal',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.PriceDownwardReversal,
        scanId: "14");

    conditionEnumMap[ScannerConditions.CloseAbovePrevDayHigh] = new Conditions(
        lName: 'Close Above Prev Day High',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevDayHigh,
        scanId: "15");

    conditionEnumMap[ScannerConditions.CloseAbovePrevWeekHigh] = new Conditions(
        lName: 'Close Above Prev Week High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevWeekHigh,
        scanId: "16",
        allowed: false);

    conditionEnumMap[ScannerConditions.CloseAbovePrevMonthHigh] =
    new Conditions(
        lName: 'Close Above Prev Month High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevMonthHigh,
        scanId: "17");

    conditionEnumMap[ScannerConditions.CloseAbove5DayHigh] = new Conditions(
        lName: 'Close Above 5 Day High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbove5DayHigh,
        scanId: "18");

    conditionEnumMap[ScannerConditions.Doubletop2DaysReversal] = new Conditions(
        lName: 'Double top 2 Days Reversal',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.Doubletop2DaysReversal,
        scanId: "19");

    conditionEnumMap[ScannerConditions.PriceUpwardReversal] = new Conditions(
        lName: 'Price Upward Reversal',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceUpwardReversal,
        scanId: "20");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove50] = new Conditions(
        lName: 'Vol 50% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove50,
        scanId: "21");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove100] = new Conditions(
        lName: 'Vol 100% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove100,
        scanId: "22");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove200] = new Conditions(
        lName: 'Vol 200% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove200,
        scanId: "23");

    conditionEnumMap[ScannerConditions.PriceAboveR4] = new Conditions(
        lName: 'Price Above R4',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR4,
        scanId: "24");

    conditionEnumMap[ScannerConditions.PriceAboveR3] = new Conditions(
        lName: 'Price Above R3',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR3,
        scanId: "25");

    conditionEnumMap[ScannerConditions.PriceAboveR2] = new Conditions(
        lName: 'Price Above R2',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR2,
        scanId: "26");

    conditionEnumMap[ScannerConditions.PriceAboveR1] = new Conditions(
        lName: 'Price Above R1',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR1,
        scanId: "27");

    conditionEnumMap[ScannerConditions.PriceAbovePivot] = new Conditions(
        lName: 'Price Above Pivot',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAbovePivot,
        scanId: "28");

    conditionEnumMap[ScannerConditions.PriceBelowS4] = new Conditions(
        lName: 'Price Below S4',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS4,
        scanId: "29");

    conditionEnumMap[ScannerConditions.PriceBelowS3] = new Conditions(
        lName: 'Price Below S3',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS3,
        scanId: "30");

    conditionEnumMap[ScannerConditions.PriceBelowS2] = new Conditions(
        lName: 'Price Below S2',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS2,
        scanId: "31");

    conditionEnumMap[ScannerConditions.PriceBelowS1] = new Conditions(
        lName: 'Price Below S1',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS1,
        scanId: "32");

    conditionEnumMap[ScannerConditions.PriceBelowPivot] = new Conditions(
        lName: 'Price Below Pivot',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowPivot,
        scanId: "33");

    conditionEnumMap[ScannerConditions.PriceGrowth1YearAbove25] =
    new Conditions(
        lName: 'Price-Growth 1 Yr Abv 25%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth1YearAbove25,
        scanId: "33B");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween25To50] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Btw 25%-50%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearBetween25To50,
        scanId: "34");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween50To100] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Btw 50%-100%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearBetween50To100,
        scanId: "35");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearAbove100] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Abv 100%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearAbove100,
        scanId: "36");

    conditionEnumMap[ScannerConditions.PriceAboveSMA5] = new Conditions(
        lName: 'Price Above SMA-5',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA5,
        scanId: "37");

    conditionEnumMap[ScannerConditions.PriceAboveSMA20] = new Conditions(
        lName: 'Price Above SMA-20',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA20,
        scanId: "38");

    conditionEnumMap[ScannerConditions.PriceAboveSMA50] = new Conditions(
        lName: 'Price Above SMA-50',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA50,
        scanId: "39");

    conditionEnumMap[ScannerConditions.PriceAboveSMA100] = new Conditions(
        lName: 'Price Above SMA-100',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA100,
        scanId: "40");

    conditionEnumMap[ScannerConditions.PriceAboveSMA200] = new Conditions(
        lName: 'Price Above SMA-200',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA200,
        scanId: "40B");

    conditionEnumMap[ScannerConditions.PriceBelowSMA5] = new Conditions(
        lName: 'Price Below SMA-5',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA5,
        scanId: "41");

    conditionEnumMap[ScannerConditions.PriceBelowSMA20] = new Conditions(
        lName: 'Price Below SMA-20',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA20,
        scanId: "42");

    conditionEnumMap[ScannerConditions.PriceBelowSMA50] = new Conditions(
        lName: 'Price Below SMA-50',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA50,
        scanId: "43");

    conditionEnumMap[ScannerConditions.PriceBelowSMA100] = new Conditions(
        lName: 'Price Below SMA-100',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA100,
        scanId: "44");

    conditionEnumMap[ScannerConditions.PriceBelowSMA200] = new Conditions(
        lName: 'Price Below SMA-200',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA200,
        scanId: "45");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend1] = new Conditions(
        lName: 'Price Above SuperTrend 1',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend1,
        scanId: "46");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend2] = new Conditions(
        lName: 'Price Above SuperTrend 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend2,
        scanId: "47");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend3] = new Conditions(
        lName: 'Price Above SuperTrend 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend3,
        scanId: "48");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend1] = new Conditions(
        lName: 'Price Below SuperTrend 1',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend1,
        scanId: "49");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend2] = new Conditions(
        lName: 'Price Below SuperTrend 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend2,
        scanId: "50");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend3] = new Conditions(
        lName: 'Price Below SuperTrend 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend3,
        scanId: "51");

    conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend1and2] =
    new Conditions(
        lName: 'Price Btw SuperTrend 1 & 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBetweenSuperTrend1and2,
        scanId: "52");

    conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend2and3] =
    new Conditions(
        lName: 'Price Btw SuperTrend 2 & 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBetweenSuperTrend2and3,
        scanId: "53");

    conditionEnumMap[ScannerConditions.RSIOverSold30] = new Conditions(
        lName: 'RSI Over Sold30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIOverSold30,
        scanId: "54");

    conditionEnumMap[ScannerConditions.RSIBetween30To50] = new Conditions(
        lName: 'RSI Between 30 To 50',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBetween30To50,
        scanId: "55");

    conditionEnumMap[ScannerConditions.RSIBetween50TO70] = new Conditions(
        lName: 'RSI Between 50 To 70',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBetween50TO70,
        scanId: "56");

    conditionEnumMap[ScannerConditions.RSIOverBought70] = new Conditions(
        lName: 'RSI OverBought 70',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIOverBought70,
        scanId: "57");

    conditionEnumMap[ScannerConditions.RSIAboveRSIAvg30] = new Conditions(
        lName: 'RSI Above RSI Avg30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIAboveRSIAvg30,
        scanId: "58");

    conditionEnumMap[ScannerConditions.RSIBelowRSIAvg30] = new Conditions(
        lName: 'RSI Below RSI Avg30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBelowRSIAvg30,
        scanId: "59");
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   DataConstants.scannerData.getData(
    //       conditionEnumMap: conditionEnumMap,
    //       selectedCondition: DataConstants.scannerTabControllerIndex == 0
    //           ? DataConstants.selectedScannerConditionForBullish
    //           : DataConstants.scannerTabControllerIndex == 1
    //               ? DataConstants.selectedScannerConditionForBearish
    //               : DataConstants.selectedScannerConditionForOthers,
    //       dropDownValue: DataConstants.selectedFilterName);
    // });
    conditionEnumMap.forEach((key, value) {
      conditionList.add(key);
      categorylist[value.category.contains("Bullish")
          ? "Bullish"
          : value.category.contains("Bearish")
          ? "Bearish"
          : "Others"] = categorylist.containsKey(value.category) ? i++ : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          title: Row(
            children: [
              Text(
                "Scanners",
                style: Utils.fonts(color: Utils.blackColor, size: 18.0),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: Utils.greyColor,
              ),
              Icon(
                Icons.rotate_90_degrees_ccw,
                color: Utils.greyColor,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: 20,
            ),
            InkWell(
                onTap: () {},
                child: SvgPicture.asset('assets/appImages/tranding.svg')),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    builder: (BuildContext context) => ScannerSortFilters(
                        OrderBookController.ScannersFilters));
              },
              child: Icon(
                Icons.more_vert,
                color: Utils.greyColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    TabBar(
                      isScrollable: true,
                      physics: CustomTabBarScrollPhysics(),
                      labelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                      unselectedLabelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
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
                      onTap: (_index) async {
                        setState(() {
                          _currentIndex = _index;
                        });
                        Dataconstants.scannerTabControllerIndex = _index;
                        await Dataconstants.scannerData.getData(
                            conditionEnumMap: conditionEnumMap,
                            selectedCondition:
                            Dataconstants.scannerTabControllerIndex == 0
                                ? Dataconstants
                                .selectedScannerConditionForBullish
                                : Dataconstants.scannerTabControllerIndex ==
                                1
                                ? Dataconstants
                                .selectedScannerConditionForBearish
                                : Dataconstants
                                .selectedScannerConditionForOthers,
                            dropDownValue: Dataconstants.selectedFilterName);
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            "Bullish",
                            style: Utils.fonts(
                                size: _currentIndex == 0 ? 13.0 : 11.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Bearish",
                            style: Utils.fonts(
                                size: _currentIndex == 1 ? 13.0 : 11.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Others",
                            style: Utils.fonts(
                                size: _currentIndex == 2 ? 13.0 : 11.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TabBarView(
              physics: CustomTabBarScrollPhysics(),
              controller: _tabController,
              children: [
                bullishWidget(),
                bearishWidget(),
                otherWidget(),
              ],
            )),
      ),
    );
  }
}

class bearishWidget extends StatefulWidget {
  const bearishWidget({Key key}) : super(key: key);

  @override
  State<bearishWidget> createState() => _bearishWidgetState();
}

class _bearishWidgetState extends State<bearishWidget> {
  List<ScannerConditions> conditionList = [];
  Map<String, int> categorylist = Map();
  int i = 0;
  var _filterByName = 0;
  var _filterByPercent = 0;
  var _filterByPrice = 0;
  var selectedFilter = 0;
  Map<ScannerConditions, Conditions> conditionEnumMap = new Map();

  @override
  void initState() {
    // CommonFunction.getData(
    //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
    //     dropDownValue: DataConstants.selectedFilterName,
    //     conditionEnumMap: widget.conditionEnumMap);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "SYMBOL",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Text(
                "PRICE",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                ),
              )
            ],),
          Obx(() {
            return ScannerController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MarketWatchRow(
                    index: index,
                    data: ScannerController.data[index],
                  );
                },
                itemCount: ScannerController.data.length,
              ),
            );
          })
        ],
      ),
        Observer(
            builder: (_) => Align(
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
                                ScannerController
                                    .sortListbyName(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 0;
                                });
                              } else {
                                ScannerController.sortListbyName(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 1;
                                });
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
                                ScannerController.sortListbyPercent(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPercent(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 1;
                                });
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
                                ScannerController
                                    .sortListbyPrice(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPrice(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 1;
                                });
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
                  Spacer(),
                ],
              ),
            )
        )
      ]
    );
  }
}

class otherWidget extends StatefulWidget {
  const otherWidget({Key key}) : super(key: key);

  @override
  State<otherWidget> createState() => _otherWidgetState();
}

class _otherWidgetState extends State<otherWidget> {
  List<ScannerConditions> conditionList = [];
  Map<String, int> categorylist = Map();
  int i = 0;
  var _filterByName = 0;
  var _filterByPercent = 0;
  var _filterByPrice = 0;
  var selectedFilter = 0;
  Map<ScannerConditions, Conditions> conditionEnumMap = new Map();

  @override
  void initState() {
    // CommonFunction.getData(
    //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
    //     dropDownValue: DataConstants.selectedFilterName,
    //     conditionEnumMap: widget.conditionEnumMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "SYMBOL",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Text(
                "PRICE",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                ),
              )
            ],),
          Obx(() {
            return ScannerController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MarketWatchRow(
                    index: index,
                    data: ScannerController.data[index],
                  );
                },
                itemCount: ScannerController.data.length,
              ),
            );
          })
        ],
      ),
        Observer(
            builder: (_) => Align(
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
                                ScannerController
                                    .sortListbyName(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 0;
                                });
                              } else {
                                ScannerController.sortListbyName(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 1;
                                });
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
                                ScannerController.sortListbyPercent(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPercent(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 1;
                                });
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
                                ScannerController
                                    .sortListbyPrice(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPrice(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 1;
                                });
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
                  Spacer(),
                ],
              ),
            )
        )
      ]
    );
  }
}

class bullishWidget extends StatefulWidget {
  // final dropDownValue;
  // final Map<ScannerConditions, Conditions> conditionEnumMap;
  // final ScannerConditions selectedCondition;

  const bullishWidget({
    Key key,
    // this.conditionEnumMap,
    // this.selectedCondition,
    // this.dropDownValue
  }) : super(key: key);

  @override
  State<bullishWidget> createState() => _bullishWidgetState();
}

class _bullishWidgetState extends State<bullishWidget> {
  List<ScannerConditions> conditionList = [];
  Map<String, int> categorylist = Map();
  int i = 0;
  Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
  var _filterByName = 0;
  var _filterByPercent = 0;
  var _filterByPrice = 0;
  var selectedFilter = 0;

  @override
  void initState() {
    // CommonFunction.getData(
    //     selectedCondition: DataConstants.selectedScannerConditionForBullish,
    //     dropDownValue: DataConstants.selectedFilterName,
    //     conditionEnumMap: widget.conditionEnumMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "SYMBOL",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Text(
                "PRICE",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                ),
              )
            ],),
            Obx(() {
              return ScannerController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MarketWatchRow(
                      index: index,
                      data: ScannerController.data[index],
                    );
                  },
                  itemCount: ScannerController.data.length,
                ),
              );
            })
          ],
        ),
          Observer(
            builder: (_) => Align(
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
                                ScannerController
                                    .sortListbyName(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 0;
                                });
                              } else {
                                ScannerController.sortListbyName(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 0;
                                  _filterByName = 1;
                                });
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
                                ScannerController.sortListbyPercent(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPercent(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 1;
                                  _filterByPercent = 1;
                                });
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
                                ScannerController
                                    .sortListbyPrice(false,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 0;
                                });
                              } else {
                                ScannerController
                                    .sortListbyPrice(true,ScannerController.data);
                                setState(() {
                                  selectedFilter = 2;
                                  _filterByPrice = 1;
                                });
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
                  Spacer(),
                ],
              ),
            )
        )
      ],
    );
  }
}

class MarketWatchRow extends StatelessWidget {
  final EquityControllerClass data;
  final int index;

  MarketWatchRow({this.index, this.data});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {},
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
                      Text(data.scName,
                          style: Utils.fonts(
                              size: 14.0, fontWeight: FontWeight.w600
                          )
                        // style: TextStyle(
                        //   fontSize: 15,
                        // ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          /* Displaying the Script exchange Name */
                          Text("${data.model.exchName}",
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Utils.greyColor)
                            // style: const TextStyle(
                            //     fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                /* Displaying the Script chart */
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Observer(
                        /* Checking if we got the chart data of the current script by checking its array length,
                         if not then shrink. The UI will throw erreo */
                        builder: (context) =>
                        data.model.chartMinClose[15].length > 0
                            ? SmallSimpleLineChart(
                          seriesList: data.model.dataPoint[15],
                          prevClose: data.model.prevDayClose,
                          name: data.model.name,
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
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
                                    data.model.close == 0.00
                                        ? data.model.prevDayClose
                                        .toStringAsFixed(
                                        data.model.series == 'Curr'
                                            ? 4
                                            : 2)
                                        : data.model.close.toStringAsFixed(
                                        data.model.series == 'Curr'
                                            ? 4
                                            : 2),
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Utils.blackColor,
                                    )),
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
                                data.model.close == 0.00
                                    ? "0.00"
                                    : data.model.priceChangeText,
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: data.model.priceChange > 0
                                      ? ThemeConstants.buyColor
                                      : data.model.priceChange < 0
                                      ? ThemeConstants.sellColor
                                      : theme.textTheme.bodyText1.color,
                                )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          /* Displaying the percentage change of the script */
                          Observer(
                            builder: (_) => Text(
                              /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                              data.model.close == 0.00
                                  ? "(0.00%)"
                                  : data.model.percentChangeText,
                              // style: Utils.fonts(
                              //   size: 12.0,
                              //   fontWeight: FontWeight.w600,
                              //   color: DataConstants
                              //               .marketWatchListeners[watchlistNo]
                              //               .watchList[index]
                              //               .percentChange >
                              //           0
                              //       ? ThemeConstants.buyColor
                              //       : DataConstants
                              //                   .marketWatchListeners[
                              //                       watchlistNo]
                              //                   .watchList[index]
                              //                   .percentChange <
                              //               0
                              //           ? ThemeConstants.sellColor
                              //           : theme.textTheme.bodyText1.color,
                              // )
                              style: TextStyle(
                                color: data.model.percentChange > 0
                                    ? ThemeConstants.buyColor
                                    : data.model.percentChange < 0
                                    ? ThemeConstants.sellColor
                                    : theme.textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                          Observer(
                              builder: (_) => Container(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: IconButton(
                                  constraints: BoxConstraints(),
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(data.model.close >=
                                      data.model.prevTickRate
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded),
                                  color: data.model.close >=
                                      data.model.prevTickRate
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
