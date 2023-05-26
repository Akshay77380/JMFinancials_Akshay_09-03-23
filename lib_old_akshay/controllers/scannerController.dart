import 'package:get/get.dart';

import '../jmScreens/Scanners/EquityAndDerivativeIndicatorData.dart';
import '../jmScreens/Scanners/EquityControllerClass.dart';
import '../jmScreens/Scanners/Scanners.dart';
import '../jmScreens/Scanners/SqliteDatabase.dart';
import '../model/scrip_info_model.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class ScannerController extends GetxController {
  // static var bool isLoading = false.obs;
  static var isLoading = true.obs;
  static List<EquityControllerClass> equityDataList = [];
  static SqliteDatabse db = new SqliteDatabse();
  static int result = 0;
  static List<int> scCode = [];
  static EquityAndDerivativeIndicatorClass indicatorsData;
  static Scanners sc = new Scanners();
  static List<EquityControllerClass> data = [];
  static Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
  static ScripInfoModel dataModel;
  static ScripInfoModel model;

  @override
  void onInit() {
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

    super.onInit();
    callGetData();
  }

  callGetData() async {
    await getData(
        conditionEnumMap: conditionEnumMap,
        selectedCondition: Dataconstants.scannerTabControllerIndex == 0
            ? Dataconstants.selectedScannerConditionForBullish
            : Dataconstants.scannerTabControllerIndex == 1
                ? Dataconstants.selectedScannerConditionForBearish
                : Dataconstants.selectedScannerConditionForOthers,
        dropDownValue: Dataconstants.selectedFilterName);
  }

  Future<void> getData(
      {selectedCondition, conditionEnumMap, dropDownValue}) async {
    try {
      // if (mounted)
      //   setState(() {
      data = [];
      equityDataList = [];
      isLoading(true);
      //   });
      //print('step 1 => $dropDownValue');
      if (dropDownValue == "NSE - All Scrips") {
        await db.getEquitydata().then((value) {
          equityDataList = value;
        });
      } else {
        List<GroupMemberClass> groupdata = Dataconstants.groupList
            .where((element) => element.groupName == dropDownValue)
            .toList();
        List<ScripInfoModel> models = [];
        for (int i = 0; i < groupdata.length; i++) {
          equityDataList
              .addAll(await db.getEquitydataByScCode(groupdata[i].scCode));

          if (Dataconstants.productType == ProductType.Premium) {
            final scripPos =
                Dataconstants.exchData[0].scripPos(groupdata[i].scCode);
            model = Dataconstants.exchData[0].getModel(scripPos);

            if (model.close > 0) {
              equityDataList[i].open = model.open;
              equityDataList[i].high = model.high;
              equityDataList[i].low = model.low;
              equityDataList[i].close = model.close;

              equityDataList[i].pOpen = model.prevDayOpen;
              equityDataList[i].pHigh = model.prevDayHigh;
              equityDataList[i].pLow = model.prevDayLow;
              equityDataList[i].pClose = model.prevDayClose;

              equityDataList[i].pcntChg = model.percentChange;
              equityDataList[i].qty = model.exchQty;
              equityDataList[i].value = model.todayValue;
              equityDataList[i].trades = model.todayTrades.toDouble();
              equityDataList[i].pcntChgAbs = model.priceChange;
              equityDataList[i].lastticktime = model.lastTradeTime == 0
                  ? model.recTime
                  : model.lastTradeTime;
              models.add(model);
            }
          }
        }

        if (Dataconstants.productType == ProductType.Premium) {
          for (var index = 0; index < models.length; index++) {
            Dataconstants.iqsClient.sendScripRequestToIQS(models[index], true);
          }
        }
      }

      /* for (int i = 0; i < Global.equityDataList.length; i++) {
        scCode.add(Global.equityDataList[i].scCode);
      } */
      //print("Step 2=> ${equityDataList.length}");
      for (int i = 0; i < equityDataList.length; i++) {
        //print("");
        model = CommonFunction.getScripDataModel(
            exch: equityDataList[i].exchange,
            exchCode: equityDataList[i].scCode,
            getNseBseMap: true);
        equityDataList[i].model = model;
        //below condition to be used if using entire NSE exchange for scan.
        /*if (!CommonFunctions.isIndex(equityDataList[i].scCode))*/
        {
          if (conditionEnumMap[selectedCondition].readDB == true) {
            List<EquityAndDerivativeIndicatorClass> indicatorData1 =
                await db.getIndicatorData(equityDataList[i].scCode, "N");
            if (indicatorData1.length > 0) indicatorsData = indicatorData1[0];
          } else {
            await new Future.delayed(const Duration(microseconds: 1), () {});
          }

          bool retval = sc.scannerResult(
              equityDataList[i], indicatorsData, selectedCondition);

          if (retval == true) {
            //result++;
            data.add(equityDataList[i]);
          }
          // dataModel =  CommonFunction.getScripDataModel(
          //     exch: "N", exchCode: data.obs.value[i].scCode, getNseBseMap: true);
        }
      }
      //print("Step 3 ${data.length}");
      // if (mounted)
      //   setState(
      //         () {
      isLoading(false);
      result = data.length;
      //     },
      //   );
    } on Exception catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'ScannersResultView-getData() Exception');
    }
  }

  static sortListbyName(bool isDescending, List<EquityControllerClass> result) {
    if (isDescending)
      result.sort((b, a) => a.scName.compareTo(b.scName));
    else
      result.sort(
          (a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    return;
  }

  static sortListbyPrice(bool isDescending, List<EquityControllerClass> data) {
    if (isDescending)
      data.sort((b, a) => a.model.close.compareTo(b.model.close));
    else
      data.sort((a, b) => a.model.close.compareTo(b.model.close));
    return;
  }

/* sortListbyPercent function is used to sort List by percent Change */

  static sortListbyPercent(
      bool isDescending, List<EquityControllerClass> data) {
    if (isDescending)
      data.sort(
          (b, a) => a.model.percentChange.compareTo(b.model.percentChange));
    else
      data.sort(
          (a, b) => a.model.percentChange.compareTo(b.model.percentChange));
  }
}
