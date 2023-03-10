// To parse this JSON data, do
//
//     final algoLog = algoLogFromJson(jsonString);

import 'dart:convert';

AlgoLog algoLogFromJson(String str) => AlgoLog.fromJson(json.decode(str));

String algoLogToJson(AlgoLog data) => json.encode(data.toJson());

class AlgoLog {
  AlgoLog({
    this.algoName,
    this.scripName,
    this.avgBuyPrice,
    this.avgSellPrice,
    this.buyQty,
    this.sellQty,
    this.pendingQty,
    this.placedQty,
    this.tradedQty,
    this.totalQty,
    this.orderQty,
    this.status,
    this.startTime,
    this.endTime,
    this.logs,
    this.chartData,
  });

  String algoName;
  String scripName;
  double avgBuyPrice;
  double avgSellPrice;
  int buyQty;
  int sellQty;
  int pendingQty;
  int placedQty;
  int tradedQty;
  int totalQty;
  int orderQty;
  String status;
  String startTime;
  String endTime;
  List<Log> logs;
  List<ChartDatum> chartData;

  factory AlgoLog.fromJson(Map<String, dynamic> json) => AlgoLog(
    algoName: json["AlgoName"],
    scripName: json["ScripName"],
    avgBuyPrice: json["AvgBuyPrice"].toDouble(),
    avgSellPrice: json["AvgSellPrice"].toDouble(),
    buyQty: json["BuyQty"],
    sellQty: json["SellQty"],
    pendingQty: json["PendingQty"],
    placedQty: json["PlacedQty"],
    tradedQty: json["TradedQty"],
    totalQty: json["TotalQty"],
    orderQty: json["OrderQty"],
    status: json["Status"],
    startTime: json["StartTime"],
    endTime: json["EndTime"],
    logs: List<Log>.from(json["Logs"].map((x) => Log.fromJson(x))),
    chartData: List<ChartDatum>.from(json["ChartData"].map((x) => ChartDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AlgoName": algoName,
    "ScripName": scripName,
    "AvgBuyPrice": avgBuyPrice,
    "AvgSellPrice": avgSellPrice,
    "BuyQty": buyQty,
    "SellQty": sellQty,
    "PendingQty": pendingQty,
    "PlacedQty":placedQty,
    "TradedQty": tradedQty,
    "TotalQty": totalQty,
    "OrderQty":orderQty,
    "Status":status,
    "StartTime":startTime,
    "EndTime":endTime,
    "Logs": List<dynamic>.from(logs.map((x) => x.toJson())),
    "ChartData": List<dynamic>.from(chartData.map((x) => x.toJson())),
  };
}

class ChartDatum {
  ChartDatum({
    this.rate,
    this.dateTime,
    this.plot,
    this.color,
  });

  double rate;
  DateTime dateTime;
  Plot plot;
  Color color;

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
    rate: json["Rate"].toDouble(),
    dateTime: DateTime.parse(json["DateTime"]),
    plot: plotValues.map[json["Plot"]],
    color: colorValues.map[json["Color"]],
  );

  Map<String, dynamic> toJson() => {
    "Rate": rate,
    "DateTime": dateTime.toIso8601String(),
    "Plot": plotValues.reverse[plot],
    "Color": colorValues.reverse[color],
  };
}

enum Color { THE_0_X_FF000000 }

final colorValues = EnumValues({
  "0xFF000000": Color.THE_0_X_FF000000
});

enum Plot { FALSE }

final plotValues = EnumValues({
  "False": Plot.FALSE
});

class Log {
  Log({
    this.qty,
    this.color,
    this.event,
    this.rate,
    this.tradedRate,
    this.dateTime,
    this.description,
    this.userName,
    this.tradedQty,
    this.rejectedQty,
    this.orderRef
  });

  int qty;
  String color;
  String event;
  double rate;
  double tradedRate;
  DateTime dateTime;
  String description;
  String userName;
  int tradedQty;
  int rejectedQty;
  String orderRef;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    qty: json["Qty"],
    color: json["Color"],
    event: json["Event"],
    rate: json["Rate"].toDouble(),
    tradedRate: json["TradedRate"].toDouble(),
    dateTime: DateTime.parse(json["DateTime"]),
    description: json["Description"],
    userName: json["UserName"],
    tradedQty: json["TradedQty"],
    rejectedQty: json["RejectedQty"],
    orderRef: json["OrderRef"],
  );
  Map<String, dynamic> toJson() => {
    "Qty": qty,
    "Color": color,
    "Event": event,
    "Rate": rate,
    "TradedRate":tradedRate,
    "DateTime": dateTime.toIso8601String(),
    "Description": description,
    "UserName":userName,
    "TradedQty":tradedQty,
    "RejectedQty":rejectedQty,
    "OrderRef": orderRef,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
