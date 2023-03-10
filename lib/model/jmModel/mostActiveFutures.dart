// To parse this JSON data, do
//
//     final mostActiveFutures = mostActiveFuturesFromJson(jsonString);

import 'dart:convert';

MostActiveFutures mostActiveFuturesFromJson(String str) => MostActiveFutures.fromJson(json.decode(str));

String mostActiveFuturesToJson(MostActiveFutures data) => json.encode(data.toJson());

class MostActiveFutures {
  MostActiveFutures({
    this.success,
    this.data,
    this.status,
    this.message,
    this.responsecode,
  });

  bool success;
  List<Datum> data;
  String status;
  String message;
  String responsecode;

  factory MostActiveFutures.fromJson(Map<String, dynamic> json) => MostActiveFutures(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    status: json["status"],
    message: json["message"],
    responsecode: json["responsecode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "message": message,
    "responsecode": responsecode,
  };
}

class Datum {
  Datum({
    this.tradedQty,
    this.turnOver,
    this.symbol,
    this.updTime,
  });

  double tradedQty;
  double turnOver;
  String symbol;
  DateTime updTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tradedQty: json["TradedQty"],
    turnOver: json["TurnOver"].toDouble(),
    symbol: json["Symbol"],
    updTime: DateTime.parse(json["UpdTime"]),
  );

  Map<String, dynamic> toJson() => {
    "TradedQty": tradedQty,
    "TurnOver": turnOver,
    "Symbol": symbol,
    "UpdTime": updTime.toIso8601String(),
  };
}
