// To parse this JSON data, do
//
//     final algoLogModel = algoLogModelFromJson(jsonString);

import 'dart:convert';

AlgoLogModel algoLogModelFromJson(String str) => AlgoLogModel.fromJson(json.decode(str));

String algoLogModelToJson(AlgoLogModel data) => json.encode(data.toJson());

class AlgoLogModel {
  AlgoLogModel({
    this.instId,
    this.clientCode,
    this.matchId,
    this.algoName,
    this.scripName,
    this.avgBuyPrice,
    this.avgSellPrice,
    this.buyQty,
    this.sellQty,
    this.openBuyQty,
    this.openSellQty,
    this.netOpenOrders,
    this.realizedAmount,
    this.pendingQty,
    this.placedQty,
    this.tradedQty,
    this.rejectedQty,
    this.totalQty,
    this.orderQty,
    this.exchTradedQty,
    this.exchRejectedQty,
    this.exchPendingQty,
    this.status,
    this.startTime,
    this.endTime,
    this.logs,
    this.chartData,
  });

  int instId;
  String clientCode;
  String matchId;
  String algoName;
  String scripName;
  double avgBuyPrice;
  double avgSellPrice;
  int buyQty;
  int sellQty;
  int openBuyQty;
  int openSellQty;
  int netOpenOrders;
  double realizedAmount;
  int pendingQty;
  int placedQty;
  int tradedQty;
  int rejectedQty;
  int totalQty;
  int orderQty;
  int exchTradedQty;
  int exchRejectedQty;
  int exchPendingQty;
  String status;
  DateTime startTime;
  DateTime endTime;
  List<Log> logs;
  List<dynamic> chartData;

  factory AlgoLogModel.fromJson(Map<String, dynamic> json) => AlgoLogModel(
    instId: json["InstID"],
    clientCode: json["ClientCode"],
    matchId: json["MatchID"],
    algoName: json["AlgoName"],
    scripName: json["ScripName"],
    avgBuyPrice: json["AvgBuyPrice"],
    avgSellPrice: json["AvgSellPrice"],
    buyQty: json["BuyQty"],
    sellQty: json["SellQty"],
    openBuyQty: json["OpenBuyQty"],
    openSellQty: json["OpenSellQty"],
    netOpenOrders: json["NetOpenOrders"],
    realizedAmount: json["RealizedAmount"],
    pendingQty: json["PendingQty"],
    placedQty: json["PlacedQty"],
    tradedQty: json["TradedQty"],
    rejectedQty: json["RejectedQty"],
    totalQty: json["TotalQty"],
    orderQty: json["OrderQty"],
    exchTradedQty: json["ExchTradedQty"],
    exchRejectedQty: json["ExchRejectedQty"],
    exchPendingQty: json["ExchPendingQty"],
    status: json["Status"],
    startTime: DateTime.parse(json["StartTime"]),
    endTime: DateTime.parse(json["EndTime"]),
    logs: List<Log>.from(json["Logs"].map((x) => Log.fromJson(x))),
    chartData: List<dynamic>.from(json["ChartData"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "ClientCode": clientCode,
    "MatchID": matchId,
    "AlgoName": algoName,
    "ScripName": scripName,
    "AvgBuyPrice": avgBuyPrice,
    "AvgSellPrice": avgSellPrice,
    "BuyQty": buyQty,
    "SellQty": sellQty,
    "OpenBuyQty": openBuyQty,
    "OpenSellQty": openSellQty,
    "NetOpenOrders": netOpenOrders,
    "RealizedAmount": realizedAmount,
    "PendingQty": pendingQty,
    "PlacedQty": placedQty,
    "TradedQty": tradedQty,
    "RejectedQty": rejectedQty,
    "TotalQty": totalQty,
    "OrderQty": orderQty,
    "ExchTradedQty": exchTradedQty,
    "ExchRejectedQty": exchRejectedQty,
    "ExchPendingQty": exchPendingQty,
    "Status": status,
    "StartTime": startTime.toIso8601String(),
    "EndTime": endTime.toIso8601String(),
    "Logs": List<dynamic>.from(logs.map((x) => x.toJson())),
    "ChartData": List<dynamic>.from(chartData.map((x) => x)),
  };
}

class Log {
  Log({
    this.qty,
    this.color,
    this.event,
    this.rate,
    this.dateTime,
    this.description,
    this.userName,
    this.tradedRate,
    this.tradedQty,
    this.rejectedQty,
    this.orderRef,
  });

  int qty;
  String color;
  String event;
  double rate;
  DateTime dateTime;
  String description;
  String userName;
  double tradedRate;
  int tradedQty;
  int rejectedQty;
  String orderRef;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    qty: json["Qty"],
    color: json["Color"],
    event: json["Event"],
    rate: json["Rate"],
    dateTime: DateTime.parse(json["DateTime"]),
    description: json["Description"],
    userName: json["UserName"],
    tradedRate: json["TradedRate"],
    tradedQty: json["TradedQty"],
    rejectedQty: json["RejectedQty"],
    orderRef: json["OrderRef"],
  );

  Map<String, dynamic> toJson() => {
    "Qty": qty,
    "Color": color,
    "Event": event,
    "Rate": rate,
    "DateTime": dateTime.toIso8601String(),
    "Description": description,
    "UserName": userName,
    "TradedRate": tradedRate,
    "TradedQty": tradedQty,
    "RejectedQty": rejectedQty,
    "OrderRef": orderRef,
  };
}
