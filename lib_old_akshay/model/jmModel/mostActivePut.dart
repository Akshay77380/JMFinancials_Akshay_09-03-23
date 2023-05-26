// To parse this JSON data, do
//
//     final mostActivePut = mostActivePutFromJson(jsonString);

import 'dart:convert';

MostActivePut mostActivePutFromJson(String str) => MostActivePut.fromJson(json.decode(str));

String mostActivePutToJson(MostActivePut data) => json.encode(data.toJson());

class MostActivePut {
  MostActivePut({
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

  factory MostActivePut.fromJson(Map<String, dynamic> json) => MostActivePut(
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

enum Symbol { BANKNIFTY, NIFTY, FINNIFTY }

final symbolValues = EnumValues({
  "BANKNIFTY ": Symbol.BANKNIFTY,
  "FINNIFTY  ": Symbol.FINNIFTY,
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
