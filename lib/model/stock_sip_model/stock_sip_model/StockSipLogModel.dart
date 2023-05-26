// To parse this JSON data, do
//
//     final stockSipLogModel = stockSipLogModelFromJson(jsonString);

import 'dart:convert';

StockSipLogModel stockSipLogModelFromJson(String str) => StockSipLogModel.fromJson(json.decode(str));

String stockSipLogModelToJson(StockSipLogModel data) => json.encode(data.toJson());

class StockSipLogModel {
  StockSipLogModel({
    this.instId,
    this.clientCode,
    this.scripName,
    this.buyPlacedQty,
    this.buyRejectedQty,
    this.buyExchTradedQty,
    this.buyExchRejectedQty,
    this.buyExchPendingQty,
    this.buyExchTradedRate,
    this.status,
    this.logs,
  });

  int instId;
  String clientCode;
  String scripName;
  var buyPlacedQty;
  var buyRejectedQty;
  var buyExchTradedQty;
  var buyExchRejectedQty;
  var buyExchPendingQty;
  var buyExchTradedRate;
  String status;
  List<Log> logs;

  factory StockSipLogModel.fromJson(Map<String, dynamic> json) => StockSipLogModel(
    instId: json["InstID"],
    clientCode: json["ClientCode"],
    scripName: json["ScripName"],
    buyPlacedQty: json["BuyPlacedQty"],
    buyRejectedQty: json["BuyRejectedQty"],
    buyExchTradedQty: json["BuyExchTradedQty"],
    buyExchRejectedQty: json["BuyExchRejectedQty"],
    buyExchPendingQty: json["BuyExchPendingQty"],
    buyExchTradedRate: json["BuyExchTradedRate"],
    status: json["Status"],
    logs: List<Log>.from(json["Logs"].map((x) => Log.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "ClientCode": clientCode,
    "ScripName": scripName,
    "BuyPlacedQty": buyPlacedQty,
    "BuyRejectedQty": buyRejectedQty,
    "BuyExchTradedQty": buyExchTradedQty,
    "BuyExchRejectedQty": buyExchRejectedQty,
    "BuyExchPendingQty": buyExchPendingQty,
    "BuyExchTradedRate": buyExchTradedRate,
    "Status": status,
    "Logs": List<dynamic>.from(logs.map((x) => x.toJson())),
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
  var rate;
  DateTime dateTime;
  String description;
  String userName;
  var tradedRate;
  var tradedQty;
  var rejectedQty;
  String orderRef;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    qty: json["Qty"],
    color: json["Color"],
    event: json["Event"],
    rate: json["Rate"]?.toDouble(),
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
