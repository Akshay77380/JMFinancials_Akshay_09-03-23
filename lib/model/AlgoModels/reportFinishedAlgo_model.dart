// To parse this JSON data, do
//
//     final reportFinishedAlgo = reportFinishedAlgoFromJson(jsonString);
import 'dart:convert';
import 'package:markets/model/scrip_info_model.dart';
import 'package:markets/util/CommonFunctions.dart';


ReportFinishedAlgo reportFinishedAlgoFromJson(String str) => ReportFinishedAlgo.fromJson(json.decode(str));

String reportFinishedAlgoToJson(ReportFinishedAlgo data) => json.encode(data.toJson());

class ReportFinishedAlgo {
  ReportFinishedAlgo({
    this.algoId,
    this.algoName,
    this.instId,
    this.exch,
    this.exchType,
    this.clientCodeLength,
    this.clientCode,
    this.scripNameLength,
    this.scripName,
    this.descLength,
    this.desc,
    this.scripCode,
    this.atMarket,
    this.orderType,
    this.buySell,
    this.limitPrice,
    this.totalQty,
    this.slicingQty,
    this.sentQty,
    this.placedQty,
    this.rejectedQty,
    this.pendingQty,
    this.exchTradedQty,
    this.exchRejectedQty,
    this.exchPendingQty,
    this.timeInterval,
    this.startTime,
    this.endTime,
    this.instTime,
    this.instState,
    this.instStatus,
    this.priceRangeHigh,
    this.priceRangeLow,
    this.avgDirection,
    this.avgLimitPrice,
    this.avgEntryDiff,
    this.avgExitDiff,
    this.ltp,
    this.model
  });

  int algoId;
  String algoName;
  int instId;
  String exch;
  String exchType;
  int clientCodeLength;
  String clientCode;
  int scripNameLength;
  String scripName;
  int descLength;
  String desc;
  int scripCode;
  String atMarket;
  String orderType;
  String buySell;
  double limitPrice;
  int totalQty;
  int slicingQty;
  int sentQty;
  int placedQty;
  int rejectedQty;
  int pendingQty;
  int exchTradedQty;
  int exchRejectedQty;
  int exchPendingQty;
  int timeInterval;
  int startTime;
  int endTime;
  int instTime;
  int instState;
  String instStatus;
  double priceRangeHigh;
  double priceRangeLow;
  String avgDirection;
  double avgLimitPrice;
  double avgEntryDiff;
  double avgExitDiff;
  double ltp;
  ScripInfoModel model;

  factory ReportFinishedAlgo.fromJson(Map<String, dynamic> json) => ReportFinishedAlgo(
      algoId: json["AlgoID"],
      algoName: json["AlgoName"],
      instId: json["InstID"],
      exch: json["Exch"],
      exchType: json["ExchType"],
      clientCodeLength: json["ClientCodeLength"],
      clientCode: json["ClientCode"],
      scripNameLength: json["ScripNameLength"],
      scripName: json["ScripName"],
      descLength: json["DescLength"],
      desc: json["Desc"],
      scripCode: json["ScripCode"],
      atMarket: json["AtMarket"],
      orderType: json["OrderType"],
      buySell: json["BuySell"],
      limitPrice: json["LimitPrice"],
      totalQty: json["TotalQty"],
      slicingQty: json["SlicingQty"],
      sentQty: json["SentQty"],
      placedQty: json["PlacedQty"],
      rejectedQty: json["RejectedQty"],
      pendingQty: json["PendingQty"],
      exchTradedQty: json["ExchTradedQty"],
      exchRejectedQty: json["ExchRejectedQty"],
      exchPendingQty: json["ExchPendingQty"],
      timeInterval: json["TimeInterval"],
      startTime: json["StartTime"],
      endTime: json["EndTime"],
      instTime: json["InstTime"],
      instState: json["InstState"],
      instStatus: json["InstStatus"],
      priceRangeHigh: json["PriceRangeHigh"],
      priceRangeLow: json["PriceRangeLow"],
      avgDirection: json["AvgDirection"],
      avgLimitPrice: json["AvgLimitPrice"],
      avgEntryDiff: json["AvgEntryDiff"],
      avgExitDiff: json["AvgExitDiff"],
      ltp: json["LTP"],
      model: CommonFunction.getAlgoScripDataModelFromIsecName(

          exchType : json["ExchType"],
          exchCode : json["ScripCode"],
          exch: json["Exch"], isecName: json["ScripName"]));


  Map<String, dynamic> toJson() => {
    "AlgoID": algoId,
    "AlgoName": algoName,
    "InstID": instId,
    "Exch": exch,
    "ExchType": exchType,
    "ClientCodeLength": clientCodeLength,
    "ClientCode": clientCode,
    "ScripNameLength": scripNameLength,
    "ScripName": scripName,
    "DescLength": descLength,
    "Desc": desc,
    "ScripCode": scripCode,
    "AtMarket": atMarket,
    "OrderType": orderType,
    "BuySell": buySell,
    "LimitPrice": limitPrice,
    "TotalQty": totalQty,
    "SlicingQty": slicingQty,
    "SentQty": sentQty,
    "PlacedQty": placedQty,
    "RejectedQty": rejectedQty,
    "PendingQty": pendingQty,
    "ExchTradedQty": exchTradedQty,
    "ExchRejectedQty": exchRejectedQty,
    "ExchPendingQty": exchPendingQty,
    "TimeInterval": timeInterval,
    "StartTime": startTime,
    "EndTime": endTime,
    "InstTime": instTime,
    "InstState": instState,
    "InstStatus": instStatus,
    "PriceRangeHigh": priceRangeHigh,
    "PriceRangeLow": priceRangeLow,
    "AvgDirection": avgDirection,
    "AvgLimitPrice": avgLimitPrice,
    "AvgEntryDiff": avgEntryDiff,
    "AvgExitDiff": avgExitDiff,
    "LTP": ltp,
  };
}
