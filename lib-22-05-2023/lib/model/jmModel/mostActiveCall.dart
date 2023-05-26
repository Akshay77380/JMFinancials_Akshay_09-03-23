// To parse this JSON data, do
//
//     final mostActiveCall = mostActiveCallFromJson(jsonString);

import 'dart:convert';

MostActiveCall mostActiveCallFromJson(String str) => MostActiveCall.fromJson(json.decode(str));

String mostActiveCallToJson(MostActiveCall data) => json.encode(data.toJson());

class MostActiveCall {
  MostActiveCall({
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

  factory MostActiveCall.fromJson(Map<String, dynamic> json) => MostActiveCall(
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
    this.symbol,
    this.tradedQty,
    this.turnOver,
    this.updTime,
    this.strikePrice,
  });

  Symbol symbol;
  String tradedQty;
  String turnOver;
  String updTime;
  String strikePrice;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    symbol: symbolValues.map[json["symbol"]],
    tradedQty: json["TradedQty"],
    turnOver: json["TurnOver"],
    updTime: json["UpdTime"],
    strikePrice: json["StrikePrice"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbolValues.reverse[symbol],
    "TradedQty": tradedQty,
    "TurnOver": turnOver,
    "UpdTime": updTime,
    "StrikePrice": strikePrice,
  };
}

enum Symbol { FINNIFTY, BANKNIFTY, NIFTY, MIDCPNIFTY }

final symbolValues = EnumValues({
  "BANKNIFTY ": Symbol.BANKNIFTY,
  "FINNIFTY  ": Symbol.FINNIFTY,
  "MIDCPNIFTY": Symbol.MIDCPNIFTY,
  "NIFTY     ": Symbol.NIFTY
});

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
