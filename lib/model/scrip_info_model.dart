import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/util/Dataconstants.dart';
import '../widget/smallChart.dart';

import '../Connection/structHelper/ServiceCaller.dart';
import '../Connection/structHelper/TypeConverter.dart';
import '../Connection/IQS/structures/RecHeader.dart';
import '../Connection/structHelper/RespRecType.dart';
import '../model/scripStaticModel.dart';
import '../util/Dataconstants.dart';
import '../util/DateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'scrip_info_model.g.dart';

enum ExchCategory {
  nseEquity,
  nseFuture,
  nseOptions,
  bseEquity,
  currenyFutures,
  currenyOptions,
  bseCurrenyFutures,
  bseCurrenyOptions,
  mcxFutures,
  mcxOptions,
  notAvailable
}

class ScripInfoModel = _ScripInfoModel with _$ScripInfoModel;

abstract class _ScripInfoModel with Store {
  static DateFormat chartDateFormat = DateFormat('dd-MMM-yyyy');
  static DateFormat chartDateFormat1 = DateFormat('dd-MMM-yyyy HH:mm:ss');
  static const int intSize = 4, byteSize = 1, shortSize = 2;
  int chartCloseRequestedTime = 0, chartOHLCRequestedTime = 0;
  @observable
  ScripInfoModel alternateModel;
  String name = '';
  String isecName = '';
  String series = '';
  String desc = '';
  String alternateDesc = '';
  int position = 0;
  int recTime = 0;
  String exch = '';
  ExchCategory exchCategory;
  int exchCode = 0;
  @observable
  int exType = 0;
  int _recType = 0;
  int _exchstatus = 0;
  @observable
  double lastTickRate = 0;
  @observable
  int exchQty = 0;
  @observable
  double exchValue = 0;
  int adv = 0;
  int dec = 0;
  int same = 0;
  int advVal = 0;
  int decVal = 0;
  int sameVal = 0;
  int newHigh = 0;
  int newLow = 0;
  @observable
  double open = 0;
  @observable
  double high = 0;
  @observable
  double low = 0;
  @observable
  double prevDayClose = 0;
  @observable
  double close = 0;
  @observable
  int priceColor = 0; //0-None,1-Green,2-Red
  @observable
  int lastTickQty = 0;
  @observable
  double avgTradePrice = 0;
  int rptType = 0;
  double _turnover = 0;
  @observable
  double percentChange = 0;
  @observable
  double currRate = 0;
  @observable
  int totalBuyQty = 0;
  @observable
  int totalSellQty = 0;
  @observable
  int openInterestX = 0;
  @observable
  int openInterestHighX = 0;
  @observable
  int openInterestLowX = 0;
  @observable
  double upperCktLimit = 0;
  @observable
  double lowerCktLimit = 0;
  @observable
  bool isOption = false;

  int todayTrades = 0;
  double todayValue = 0;

  int freezQty = 0;

//BidOffer 1
  @observable
  double bidRate1 = 0;
  @observable
  int bidOrder1 = 0;
  @observable
  int bidQty1 = 0;
  @observable
  double offerRate1 = 0;
  @observable
  int offerOrder1 = 0;
  @observable
  int offerQty1 = 0;

  //BidOffer 2
  @observable
  double bidRate2 = 0;
  @observable
  int bidOrder2 = 0;
  @observable
  int bidQty2 = 0;
  @observable
  double offerRate2 = 0;
  @observable
  int offerOrder2 = 0;
  @observable
  int offerQty2 = 0;

  //BidOffer 3
  @observable
  double bidRate3 = 0;
  @observable
  int bidOrder3 = 0;
  @observable
  int bidQty3 = 0;
  @observable
  double offerRate3 = 0;
  @observable
  int offerOrder3 = 0;
  @observable
  int offerQty3 = 0;

  //BidOffer 4
  @observable
  double bidRate4 = 0;
  @observable
  int bidOrder4 = 0;
  @observable
  int bidQty4 = 0;
  @observable
  double offerRate4 = 0;
  @observable
  int offerOrder4 = 0;
  @observable
  int offerQty4 = 0;

  //BidOffer 5
  @observable
  double bidRate5 = 0;
  @observable
  int bidOrder5 = 0;
  @observable
  int bidQty5 = 0;
  @observable
  double offerRate5 = 0;
  @observable
  int offerOrder5 = 0;
  @observable
  int offerQty5 = 0;

  @observable
  int openInterest = 0;
  int openInterestHigh = 0;
  int openInterestLow = 0;
  @observable
  double yearlyHigh = 0;
  @observable
  double yearlyLow = 0;
  int tickSize = 0;
  int tickSize2 = 0;

  int allowedIntraday = 0;
  double prevDayOpen = 0;
  double prevDayHigh = 0;
  double prevDayLow = 0;
  double prevDayCumWtAvg = 0;
  int prevDayCumVol = 0;
  int precision = 2;
  double pointChange = 0;

  double actionRate = 0;
  int actionIdentifier = 0;
  int actionQty = 0;
  double actionPercentChange = 0;
  int prevOpenInterest = 0;
  int prevDayTime = 0;
  double prevDayPrice = 0;
  int prevDayQty = 0;
  double prev2DayOpen = 0;
  double prev2DayHigh = 0;
  double prev2DayLow = 0;
  double prev2DayClose = 0;
  int prev2DayCumVol = 0;

  int expiry = 0;
  int expiry2 = 0;
  double strikePrice = 0;
  double strikePrice2 = 0;
  int cpType = 0;
  bool isFromApi = false;
  int ulToken = 0;
  int ofisType = 0;
  int ofisType2 = 0;
  int minimumLotQty = 0;
  int minimumLotQty2 = 0;
  int caLevel = 0;
  int caLevel2 = 0;
  int summaryRecCnt = 0;
  int exchType = 0;
  int dummy19Length = 0;
  int historyRecCntB = 0;
  int historyType = 0;
  int dummy8ALength = 0;
  String units = '', unit1 = '', unit2 = '';

  int unitNo = 0;
  int startTime = 0;
  int endDate = 0;
  int delStart = 0;
  int delEnd = 0;
  int tenderStart = 0;
  int tenderEnd = 0;
  int maxQty = 0;
  double factor = 0;
  int t2tIndicatior = 0;
  double buyMargin = 0;
  double sellMargin = 0;
  int mcxTickSize = 0;
  int groupID = 0;

  bool isVisible = false;

  int spdCode1 = 0;
  int spdCode2 = 0;
  double hldQty = 0;

  bool inWatchlist = false;
  double prevTickRate = 0;
  double tickRateDiff = 0;
  int lastRecTime = 0;
  String tradingSymbol = "";
  bool isSpread;
  @observable
  int lastTradeTime = 0;
  int prevCumQty = 0;
  int tradeAraryUpto = -1;
  int tradeReceivedCount = 50;

  // bool isE = false;
  // bool isR = false;
  // bool isP = false;

  //5 min and 15 min map
  @observable
  ObservableMap<int, ObservableList<double>> chartMinClose = ObservableMap.of({
    5: ObservableList(),
    15: ObservableList(),
  });

  @observable
  ObservableMap<int, ObservableList<FlSpot>> dataPoint = ObservableMap.of({
    5: ObservableList(),
    15: ObservableList(),
  });

  int get exchPos {
    switch (exchCategory) {
      case ExchCategory.nseEquity:
        return 0;
        break;
      case ExchCategory.nseFuture:
      case ExchCategory.nseOptions:
        return 1;
        break;
      case ExchCategory.bseEquity:
        return 2;
        break;
      case ExchCategory.currenyFutures:
      case ExchCategory.currenyOptions:
        return 3;
        break;
      case ExchCategory.bseCurrenyFutures:
      case ExchCategory.bseCurrenyOptions:
        return 4;
        break;
      case ExchCategory.mcxFutures:
      case ExchCategory.mcxOptions:
        return 5;
        break;
      default:
        return -1;
    }
  }

  String get getExchType {
    switch (exchCategory) {
      case ExchCategory.nseEquity:
        return 'C';
        break;
      case ExchCategory.nseFuture:
      case ExchCategory.nseOptions:
      return 'D';
        break;
      case ExchCategory.bseEquity:
        return 'C';
        break;
      case ExchCategory.currenyFutures:
      case ExchCategory.currenyOptions:
      return 'D';
        break;
      case ExchCategory.bseCurrenyFutures:
      case ExchCategory.bseCurrenyOptions:
      return 'D';
        break;
      case ExchCategory.mcxFutures:
      case ExchCategory.mcxOptions:
      return 'D';
        break;
      default:
        return '';
    }
  }
  String get recType {
    if (_recType != null) {
      Uint8List byteArray = new Uint8List(1);
      byteArray[0] = _recType;
      return String.fromCharCodes(byteArray.toList());
    }
    return "";
  }

  double incrementTicksize() {
    if (exchCategory == ExchCategory.mcxFutures ||
        exchCategory == ExchCategory.mcxOptions)
      return max(0.01, (mcxTickSize / 100));
    else if (exchCategory == ExchCategory.currenyFutures ||
        exchCategory == ExchCategory.currenyOptions)
      return max(0.0001, (tickSize / 10000));
    else
      return max(0.01, (tickSize / 100));
  }

  String get exchTypeLong {
    switch (exchCategory) {
      case ExchCategory.nseEquity:
        return 'NSE';
      case ExchCategory.bseEquity:
        return 'BSE';
        break;
      case ExchCategory.nseFuture:
      case ExchCategory.nseOptions:
        return 'NFO';
      case ExchCategory.currenyFutures:
        return 'CURR FUT';
        break;
      case ExchCategory.currenyOptions:
      case ExchCategory.bseCurrenyFutures:
      case ExchCategory.bseCurrenyOptions:
        return 'Currency';
        break;
      default:
        return 'Mcx';
    }
  }

  void setApiData({
    @required String isecApiName,
    @required ExchCategory exchCategory,
    exchApi,
    bool isOPtion,
    int expiryDate,
    int cptype,
    double strikePrice,
    String isecName,
    String ltp = '0.00',
  }) {
    this.name = isecApiName;
    this.isecName = isecApiName;
    this.isOption = isOPtion;
    this.exch = exchApi;
    this.expiry = expiryDate;
    this.exchCategory = exchCategory;
    this.cpType = cptype;
    this.strikePrice = strikePrice;
    this.isFromApi = true;
    this.close = ltp.contains('NA') ? 0.00 : double.parse(ltp);
  }

  void setStaticData(ScripStaticModel staticModel) {
    this.name = staticModel.name;
    this.isecName = staticModel.isecName;
    this.exch = staticModel.exch;
    this.exchCode = staticModel.exchCode;
    this.desc = staticModel.desc;
    this.tradingSymbol = staticModel.tradingSymbol;
    this.isSpread = staticModel.isSpread;
    this.series = staticModel.series;
    this.minimumLotQty = staticModel.minimumLotQty;
    this.minimumLotQty2 = staticModel.minimumLotQty2;
    this.tickSize = staticModel.tickSize;
    this.tickSize2 = staticModel.tickSize2;
    this.ulToken = staticModel.ulToken;
    this.caLevel = staticModel.caLevel;
    this.caLevel2 = staticModel.caLevel2;
    this.ofisType = staticModel.ofisType;
    this.ofisType2 = staticModel.ofisType2;
    this.cpType = staticModel.cpType;
    this.expiry = staticModel.expiry;
    this.expiry2 = staticModel.expiry2;
    this.strikePrice = staticModel.strikePrice;
    this.strikePrice2 = staticModel.strikePrice2;
    this.spdCode1 = staticModel.spdCode1;
    this.spdCode2 = staticModel.spdCode2;
    this.exchCategory = staticModel.exchCategory;
    this.units = staticModel.units;
    this.unit1 = staticModel.unit1;
    this.unit2 = staticModel.unit2;
    this.unitNo = staticModel.unitNo;
    this.startTime = staticModel.startTime;
    this.endDate = staticModel.endDate;
    this.delEnd = staticModel.delEnd;
    this.delStart = staticModel.delStart;
    this.tenderStart = staticModel.tenderStart;
    this.tenderEnd = staticModel.tenderEnd;
    this.maxQty = staticModel.maxQty;
    this.factor = staticModel.factor;
    this.buyMargin = staticModel.buyMargin;
    this.sellMargin = staticModel.sellMargin;
    this.mcxTickSize = staticModel.mcxTickSize;
    this.groupID = staticModel.groupID;
    if (staticModel.exchCategory == ExchCategory.mcxFutures ||
        staticModel.exchCategory == ExchCategory.mcxOptions)
      this.precision = 2;
    else if (staticModel.exchCategory == ExchCategory.currenyFutures ||
        staticModel.exchCategory == ExchCategory.currenyOptions ||
        staticModel.exch == 'E' ||
        staticModel.ofisType > 5)
      this.precision = 4;
    else
      this.precision = 2;
  }

  @computed
  String get exchName {
    switch (exch) {
      case 'N':
        return 'NSE';
      case 'B':
        return 'BSE';
      case 'M':
        return 'MCX';
      case 'C':
        return 'NSE Curr';
      case 'NDX':
        return 'NSE Curr';
      case 'E':
        return 'BSE Curr';
      default:
        return '';
    }
  }

  @action
  void resetBidOffer() {
    bidRate1 = 0;
    bidOrder1 = 0;
    bidQty1 = 0;
    offerRate1 = 0;
    offerOrder1 = 0;
    offerQty1 = 0;

    bidRate2 = 0;
    bidOrder2 = 0;
    bidQty2 = 0;
    offerRate2 = 0;
    offerOrder2 = 0;
    offerQty2 = 0;

    bidRate3 = 0;
    bidOrder3 = 0;
    bidQty3 = 0;
    offerRate3 = 0;
    offerOrder3 = 0;
    offerQty3 = 0;

    bidRate4 = 0;
    bidOrder4 = 0;
    bidQty4 = 0;
    offerRate4 = 0;
    offerOrder4 = 0;
    offerQty4 = 0;

    bidRate5 = 0;
    bidOrder5 = 0;
    bidQty5 = 0;
    offerRate5 = 0;
    offerOrder5 = 0;
    offerQty5 = 0;
  }

  @computed
  double get priceChange => close - prevDayClose;

  @computed
  String get priceChangeText =>
      '${priceChange < 0 ? "" : "+"}${priceChange.toStringAsFixed(precision)}';

  // @computed
  // String get openInterestText =>
  //     '${(openInterest / 100000).toStringAsFixed(2)}';
  @computed
  String get openInterestText =>
      '${(exch == 'M'?openInterest:openInterest / 100000).toStringAsFixed(exch == 'M'?0:2)}';
  @computed
  String get percentChangeText =>
      "(${percentChange < 0 ? "" : "+"}${percentChange.toStringAsFixed(2)}%)";

  @computed
  String get optionChainPercentChangeText =>
      "${percentChange < 0 ? "" : "+"}${percentChange.toStringAsFixed(2)}%";

  @computed
  Key get watchListKey => ValueKey(exchCode);

  @computed
  String get price1 => (lastTickQty.toDouble() * close).toString();

  // @computed
  // String get lastTickQtyText =>
  //     '$lastTickQty @ ${(lastTickQty.toDouble() * close).toStringAsFixed(precision)}';

  // @computed
  // String get lastTradeTimeText => DateUtil.dateFormatter.format(
  //       Dataconstants.exchStartDate.add(
  //         new Duration(seconds: 1),
  //       ),
  //     );
  @computed
  String get lastTickQtyText =>
      '$lastTickQty @ ${close.toStringAsFixed(precision)}';

  @computed
  String get lastTradeTimeText => DateUtil.dateFormatter.format(
        Dataconstants.exchStartDate.add(
          new Duration(seconds: lastTradeTime),
        ),
      );
  @computed
  double get bidTotalVal {
    var temp = (totalBuyQty / (totalBuyQty + totalSellQty)) * 100;
    if (temp.isInfinite || temp.isNaN)
      return 0;
    else
      return temp;
  }

  @computed
  double get askTotalVal {
    var temp = (totalSellQty / (totalBuyQty + totalSellQty)) * 100;
    if (temp.isInfinite || temp.isNaN)
      return 0;
    else
      return temp;
  }

  String get marketWatchName {
    switch (exchCategory) {
      case ExchCategory.nseFuture:
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')}';
      case ExchCategory.currenyFutures:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        String name1 = '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')}';
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')}';
        break;
      case ExchCategory.bseCurrenyFutures:
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')}';
        break;
      case ExchCategory.mcxFutures:
        return '${name.toUpperCase()}  ${DateUtil.getMcxDateWithFormat(expiry, 'dd MMM yy')}';
      case ExchCategory.nseOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        break;
      case ExchCategory.currenyOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        // return name;
        break;
      case ExchCategory.bseCurrenyOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        break;
      case ExchCategory.mcxOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${name.toUpperCase()} ${DateUtil.getMcxDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        break;
      case ExchCategory.notAvailable:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '';
        break;
      default:
        if (isOption) {
          String cpText = cpType == 3 ? 'CE' : 'PE';
          return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        } else if (!isOption && exch == 'NFO') {
          String cpText = cpType == 3 ? 'CE' : 'PE';
          return '${name.toUpperCase()} ${DateUtil.getDateWithFormat(expiry, 'dd MMM yy')} ${strikePrice.toStringAsFixed(2)} $cpText';
        } else
          return '$name';
    }
  }

  String get marketWatchDescOld {
    switch (exchCategory) {
      case ExchCategory.bseEquity:
      case ExchCategory.nseEquity:
        return series;
      case ExchCategory.nseFuture:
      case ExchCategory.currenyFutures:
      case ExchCategory.bseCurrenyFutures:
        return 'FUT ${DateUtil.getDateWithFormat(expiry, 'dd MMM')}';
        break;
      case ExchCategory.mcxFutures:
        return 'FUT ${DateUtil.getMcxDateWithFormat(expiry, 'dd MMM')}';
      case ExchCategory.nseOptions:
      case ExchCategory.currenyOptions:
      case ExchCategory.bseCurrenyOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${DateUtil.getDateWithFormat(expiry, 'dd MMM')} ${strikePrice.toStringAsFixed(2)} $cpText';
        break;
      case ExchCategory.mcxOptions:
        String cpText = cpType == 3 ? 'CE' : 'PE';
        return '${DateUtil.getMcxDateWithFormat(expiry, 'dd MMM')} ${strikePrice.toStringAsFixed(2)} $cpText';
        break;
      default:
        return '';
    }
  }

  bool isNewCloseChartDataRequired(int time) {
    if (chartMinClose[time].isEmpty) return true;
    DateTime current = DateTime.now();
    if (current.hour > 16 &&
        chartMinClose[time].length >=
            375 / time) // 375 minutes is total trading timr
      return false;
    Duration currentMinute = DateTime.now().difference(
      DateTime(
        current.year,
        current.month,
        current.day,
        9,
        15,
      ),
    );
    return currentMinute.inMinutes > chartMinClose[time].length * time;
  }

  String get marketWatchDesc {
    switch (exchCategory) {
      case ExchCategory.bseEquity:
      case ExchCategory.nseEquity:
        return series;
      case ExchCategory.nseFuture:
      case ExchCategory.currenyFutures:
        return 'FUT';
        break;
      case ExchCategory.bseCurrenyFutures:
        return 'FUT';
        break;
      case ExchCategory.mcxFutures:
        return 'FUT';
        break;
      case ExchCategory.nseOptions:
        return 'OPT';
        break;
      case ExchCategory.currenyOptions:
        return 'OPT';
        break;
      case ExchCategory.bseCurrenyOptions:
        return 'OPT';
        break;
      case ExchCategory.mcxOptions:
        return 'OPT';
        break;
      default:
        return '';
    }
  }

  String get expiryDateString {
    if (expiry <= 0) return '--';
    if (exchCategory == ExchCategory.mcxFutures ||
        exchCategory == ExchCategory.mcxOptions)
      return DateUtil.getMcxDateWithFormat(expiry, 'dd MMM yyyy');
    else
      return DateUtil.getDateWithFormat(expiry, 'dd MMM yyyy');
  }

  String get expiryDateIsecString {
    if (expiry <= 0) return '--';
    if (exchCategory == ExchCategory.mcxFutures ||
        exchCategory == ExchCategory.mcxOptions)
      return DateUtil.getMcxDateWithFormat(expiry, 'dd-MMM-yyyy');
    else
      return DateUtil.getDateWithFormat(expiry, 'dd-MMM-yyyy');
  }

  @action
  void addAlternateModel(ScripInfoModel model) {
    this.alternateModel = model;
  }

  Future<void> getChartData({
    int timeInterval = 15,
    String chartPeriod = 'I',
  }) async {
    if (!isNewCloseChartDataRequired(timeInterval)) return;
    try {
      var link =
          // 'https://marketstreams.icicidirect.com/chart/api/chart/symbol15minchartdata';
      'https://${Dataconstants.iqsIP}/chart/api/chart/symbol15minchartdata';

      var jsonData = {
        "Exch": exch,
        "ScripCode": exchCode.toString(),
        // "FromDate": Dataconstants.chartFromDate, // 31 jul 2021 09:15:00
        // "ToDate": Dataconstants.chartToDate, // 31 jul 2021 15:30:00
        "TimeInterval": timeInterval.toString(),
        "ChartPeriod": chartPeriod,
      };
      var response = await post(Uri.parse(link),body: jsonData);
      // var response = await CommonFunction.aliceLogging(link: link,payload: jsonData);
      var data = jsonDecode(response.body);
      // //print("chart data => $jsonData");
      chartMinClose[timeInterval] = ObservableList();
      dataPoint[timeInterval] = ObservableList();
      if (data['Status'] != 200) {
        if (data['c'].length > 0)
          for (int i = 0; i < data['c'].length; i++) {
            chartMinClose[timeInterval].add( double.parse(data['c'][i].toStringAsFixed(2)));
            dataPoint[timeInterval]
                .add(FlSpot(
                double.parse(i.toStringAsFixed(2)), double.parse(data['c'][i].toStringAsFixed(2))));
          }
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  ServiceCaller setFields(Uint8List resp, RecHeader header) {
    ServiceCaller caller = ServiceCaller.SCRIP_DETAIL_PAGE;
    setHeader(header);
    switch (header.recType.getValue()) {
      case RespRecType.recType_A:
        setRecA(resp);
        break;
      case RespRecType.recType_d:
        setRecSmallD(resp);
        break;
      case RespRecType.recType_B:
        setRecB(resp);
        break;
      case RespRecType.recType_C:
        caller = ServiceCaller.SCRIP_DETAIL_C;
        setRecC(resp);
        break;
      case RespRecType.recType_D:
        caller = ServiceCaller.SCRIP_DETAIL_D;
        setRecD(resp);
        break;
      case RespRecType.recType_E:
        caller = ServiceCaller.SCRIP_DETAIL_E;
        setRecE(resp);
        break;
      case RespRecType.recType_F:
        caller = ServiceCaller.SCRIP_DETAIL_F;
        setRecF(resp);
        break;
      case RespRecType.recType_G:
        setRecG(resp);
        break;
      case RespRecType.recType_g:
        setRecg(resp);
        break;
      case RespRecType.recType_H:
        setRecH(resp);
        caller = ServiceCaller.SNAPSHOT;
        break;
      case RespRecType.recType_I:
        setRecIi(resp);
        break;
      case RespRecType.recType_i:
        setRecIi(resp);
        break;
      case RespRecType.recType_a:
        setRecSmallA(resp);
        break;
      case RespRecType.recType_m:
        setRecSmallM(resp);
        break;
      case RespRecType.recType_W:
        setRecW(resp);
        break;
      case RespRecType.recType_X:
        setRecX(resp);
        break;
      case RespRecType.recType_x:
        setRecSmallX(resp);
        break;
      case RespRecType.recType_Y:
        setRecY(resp);
        caller = ServiceCaller.EXCH_MSG;
        break;
      case RespRecType.recType_Z:
        setRecZ(resp);
        break;
      case RespRecType.recType_z:
        setRecSmallZ(resp);
        break;
      case RespRecType.recType_c:
        setRecSmallC(resp);
        break;
      case RespRecType.recType_o:
        setRecSmallO(resp);
        caller = ServiceCaller.MARKET_SUMMARY;
        break;
      case RespRecType.recType_n:
        setRecSmallN(resp);
        break;
      case RespRecType.recType_S:
        setRecS(resp);
        break;
      case RespRecType.recType_s:
        setRecSmallS(resp);
        break;
      // case RespRecType.recType_k:
      //   setRecSmallK(resp);
      //   break;
      // case RespRecType.recType_v:
      //   setRecSmallV(resp);
      //   break;
    }
    return caller;
  }

  void setHeader(RecHeader header) {
    this.exch = String.fromCharCode(header.exch.getValue());
    this.exchCode = header.exchCode.getValue();
    this._recType = header.recType.getValue();
    this.recTime = header.recTime.getValue();
  }

  @action
  void setRecA(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    double newPrice = TypeConverter.byteToFloat(output);
    if (this.close != 0) {
      if (newPrice > this.close)
        priceColor = 1;
      else if (newPrice < this.close)
        priceColor = 2;
      else
        priceColor = 0;
    }
    if (this.exchCode == 64432) {
      //print('');
    }
    this.close = newPrice;
    // //print("LTP : ${this.close}");
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayClose = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterest = TypeConverter.byteToInt(output);
    todayTrades = todayTrades + 1;
    switch (todayTrades) {
      case 1:
        prevTickRate = 0.0;
        tickRateDiff = 0.0;
        break;
      case 2:
        prevTickRate = lastTickRate;
        tickRateDiff = close - lastTickRate;
        break;
      default:
        prevTickRate = lastTickRate;
        tickRateDiff = close - lastTickRate;
    }
    lastRecTime = recTime;
    lastTradeTime = recTime;
    if (prevDayClose > 0.01)
      percentChange = 100.00 * (close - prevDayClose) / prevDayClose;
    if (tradeAraryUpto == tradeReceivedCount - 1) tradeReceivedCount += 50;
  }

  @action
  void setRecSmallD(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.lastTickQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.exchQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.avgTradePrice = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    // this.openInterest = TypeConverter.byteToInt(output);
    prevCumQty = exchQty;
    todayValue = avgTradePrice * exchQty;
  }

  @action
  void setRecSmallA(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.actionRate = TypeConverter.byteToFloat(output);
    //Logit.e("recType_H", (("indexvalue " + IndexValue) + " ") + ExchCode);
    len += size;
    size = byteSize;
    this.actionIdentifier = resp[len];
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.actionQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.actionPercentChange = TypeConverter.byteToFloat(output);
  }

//sus
  @action
  void setRecSmallY(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = byteSize;
    Uint8List output = new Uint8List(size);
    this.exType = resp[len];
    len += size;
    size = byteSize;
    this.rptType = resp[len];
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this._turnover = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.percentChange = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.currRate = TypeConverter.byteToFloat(output);
    // DataConstants.marketWatchListener.updateScrip(this);
  }

  @action
  void setRecG(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.open = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.high = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.low = TypeConverter.byteToFloat(output);
  }

  void setRecS(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = shortSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.summaryRecCnt = TypeConverter.byteToUShort(output);
    len += size;
    size = byteSize;
    this.exchType = resp[len];
    len += size;
    size = byteSize;
    this.dummy19Length = resp[len];
  }

  void setRecSmallS(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = shortSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.historyRecCntB = TypeConverter.byteToUShort(output);
    len += size;
    size = byteSize;
    this.historyType = resp[len];
    len += size;
    size = byteSize;
    this.dummy8ALength = resp[len];
  }

  // @action
  // void setRecSmallK(Uint8List resp) {
  //   try {
  //     int totalCount = resp.length ~/ intSize;
  //     int len = 0;
  //     int size = 0;
  //     size = intSize;
  //     chartMinClose[chartCloseRequestedTime] = ObservableList();
  //     dataPoint[chartCloseRequestedTime] = ObservableList();
  //     for (int i = 0; i < totalCount; i++) {
  //       Uint8List output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       double value =
  //           double.parse(TypeConverter.byteToFloat(output).toStringAsFixed(2));
  //       chartMinClose[chartCloseRequestedTime].add(value);
  //       dataPoint[chartCloseRequestedTime].add(FlSpot(i.toDouble(), value));
  //       len += size;
  //     }
  //     // //print(
  //     //     "---------------------------chart data of $name with lenght ${chartMinClose[15]}");
  //   } catch (e) {
  //     //print(e);
  //   }
  // }

  // @action
  // void setRecSmallV(Uint8List resp) {
  //   try {
  //     int totalCount = resp.length ~/ (intSize * 5);
  //     int len = 0;
  //     int size = 0;
  //     size = intSize;
  //     chartCloseRate.clear();
  //     chartOpenRate.clear();
  //     chartHighRate.clear();
  //     chartLowRate.clear();
  //     chartTickQty.clear();
  //     for (int i = 0; i < totalCount; i++) {
  //       size = intSize;
  //       Uint8List output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       chartOpenRate.add(TypeConverter.byteToFloat(output));
  //       len += size;
  //       size = intSize;
  //       output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       chartHighRate.add(TypeConverter.byteToFloat(output));
  //       len += size;
  //       size = intSize;
  //       output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       chartLowRate.add(TypeConverter.byteToFloat(output));
  //       len += size;
  //       size = intSize;
  //       output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       chartCloseRate.add(TypeConverter.byteToFloat(output));
  //       len += size;
  //       size = intSize;
  //       output = new Uint8List(size);
  //       output.setRange(0, output.length, resp, len);
  //       chartTickQty.add(TypeConverter.byteToInt(output));
  //       len += size;
  //     }
  //     //  //print("The chart data $name length is ${chartTickQty.length}");
  //     //  //print(chartTickQty);
  //   } catch (e) {
  //     //print(e);
  //   }
  // }

  @action
  void setRecB(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidRate1 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidQty1 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidOrder1 = TypeConverter.byteToShort(output).toInt();
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerRate1 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerQty1 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerOrder1 = TypeConverter.byteToShort(output).toInt();
  }

  @action
  void setRecC(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidRate2 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidQty2 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidOrder2 = TypeConverter.byteToShort(output).toInt();
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerRate2 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerQty2 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerOrder2 = TypeConverter.byteToShort(output).toInt();
  }

  @action
  void setRecD(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidRate3 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidQty3 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidOrder3 = TypeConverter.byteToShort(output).toInt();
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerRate3 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerQty3 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerOrder3 = TypeConverter.byteToShort(output).toInt();
  }

  @action
  void setRecE(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidRate4 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidQty4 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidOrder4 = TypeConverter.byteToShort(output).toInt();
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerRate4 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerQty4 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerOrder4 = TypeConverter.byteToShort(output).toInt();
  }

  @action
  void setRecF(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidRate5 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidQty5 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.bidOrder5 = TypeConverter.byteToShort(output).toInt();
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerRate5 = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerQty5 = TypeConverter.byteToInt(output);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.offerOrder5 = TypeConverter.byteToShort(output).toInt();
  }

  @action
  void setRecX(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.totalBuyQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.totalSellQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterestX = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterestHighX = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterestLowX = TypeConverter.byteToInt(output);
  }

  @action
  void setRecW(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.upperCktLimit = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.lowerCktLimit = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.freezQty = TypeConverter.byteToInt(output);
  }

  @action
  void setRecSmallM(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterest = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterestHigh = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.openInterestLow = TypeConverter.byteToInt(output);
  }

  void setRecSmallN(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.expiry = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.strikePrice = TypeConverter.byteToFloat(output);
    len += size;
    size = byteSize;
    this.cpType = resp[len];
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.ulToken = TypeConverter.byteToInt(output);
    len += size;
    size = byteSize;
    this.ofisType = resp[len];
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.minimumLotQty = TypeConverter.byteToUShort(output);
    len += size;
    size = byteSize;
    this.caLevel = resp[len];
    this.desc = modelDesc();
  }

  void setRecZ(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayTime = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayPrice = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayQty = TypeConverter.byteToInt(output);
  }

  void setRecSmallZ(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayOpen = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayHigh = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayLow = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayCumWtAvg = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayCumVol = TypeConverter.byteToInt(output);
  }

  void setRecSmallC(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prev2DayOpen = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prev2DayHigh = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prev2DayLow = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prev2DayClose = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prev2DayCumVol = TypeConverter.byteToInt(output);
  }

  @action
  void setRecH(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    double newPrice = TypeConverter.byteToFloat(output);
    if (this.close != 0) {
      if (newPrice > this.close)
        priceColor = 1;
      else if (newPrice < this.close)
        priceColor = 2;
      else
        priceColor = 0;
    }
    this.close = newPrice;
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.exchQty = TypeConverter.byteToInt(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.exchValue = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevDayClose = TypeConverter.byteToFloat(output);
    if (prevDayClose > 0.01)
      percentChange = 100.00 * (close - prevDayClose) / prevDayClose;
  }

  void setRecIi(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = shortSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.adv = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", (("exce ADS Adv " + Adv) + " ") + ExchCode);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.dec = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", "exce ADS Dec " + Dec);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.same = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", "exce ADS Same " + Same);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.advVal = TypeConverter.byteToInt(output);
    //Logit.e("RectypeI ", "exce ADS AdvVal " + AdvVal);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.decVal = TypeConverter.byteToInt(output);
    //Logit.e("RectypeI ", "exce ADS DecVal " + DecVal);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.sameVal = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", "exce ADS SameVal" + SameVal);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.newHigh = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", "exce ADS NewHigh " + NewHigh);
    len += size;
    size = shortSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.newLow = TypeConverter.byteToShort(output);
    //Logit.e("RectypeI ", "exce ADS NewLow " + NewLow);
  }

  @action
  void setRecg(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.yearlyHigh = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.yearlyLow = TypeConverter.byteToFloat(output);
    // len += size;
    // size = byteSize;
    // this.tickSize = resp[len].toInt();
  }

  void setRecSmallX(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.prevOpenInterest = TypeConverter.byteToInt(output);
  }

  @action
  void setRecSmallO(Uint8List resp) {
    int len = 0;
    int size = 0;
    size = intSize;
    Uint8List output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.yearlyHigh = TypeConverter.byteToFloat(output);
    len += size;
    size = intSize;
    output = new Uint8List(size);
    output.setRange(0, output.length, resp, len);
    this.yearlyLow = TypeConverter.byteToFloat(output);
  }

  void setRecY(Uint8List resp) {
    int len = 0;
    this._exchstatus = resp[len].toInt();
  }

  int getStringSize(String obj) {
    return obj.trim().length;
  }

  String modelDesc() {
    String desc = name +
        DateUtil.getAnyFormattedDate(
            Dataconstants.exchStartDate.add(Duration(seconds: expiry)),
            "dd mmm yyyy");
    if (cpType > 0)
      desc = '$desc ${Dataconstants.array_option_type[cpType]} $strikePrice';
    return desc;
  }
}
