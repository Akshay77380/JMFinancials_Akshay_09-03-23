// To parse this JSON data, do
//
//     final increaseInOi = increaseInOiFromJson(jsonString);

import 'dart:convert';

IncreaseInOi increaseInOiFromJson(String str) => IncreaseInOi.fromJson(json.decode(str));

String increaseInOiToJson(IncreaseInOi data) => json.encode(data.toJson());

class IncreaseInOi {
  IncreaseInOi({
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

  factory IncreaseInOi.fromJson(Map<String, dynamic> json) => IncreaseInOi(
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
      this.prevLtp,
      this.ltp,
      this.faOdiff,
      this.faOchange,
      this.instName,
      this.symbol,
      this.expDate,
      this.strikePrice,
      this.optType,
      this.updTime,
      this.qty,
      this.openInterest,
      this.chgOpenInt,
  });

  double prevLtp;
  double ltp;
  double faOdiff;
  double faOchange;
  String instName;
  String symbol;
  DateTime expDate;
  double strikePrice;
  String optType;
  DateTime updTime;
  double qty;
  double openInterest;
  double chgOpenInt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    prevLtp: json["PrevLtp"]?.toDouble(),
    ltp: json["LTP"]?.toDouble(),
    faOdiff: json["FaOdiff"]?.toDouble(),
    faOchange: json["FaOchange"]?.toDouble(),
    instName: json["InstName"],
    symbol: json["Symbol"],
    expDate: DateTime.parse(json["ExpDate"]),
    strikePrice: json["StrikePrice"],
    optType: json["OptType"],
    updTime: DateTime.parse(json["UpdTime"]),
    qty: json["Qty"],
    openInterest: json["OpenInterest"],
    chgOpenInt: json["chgOpenInt"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "PrevLtp": prevLtp,
    "LTP": ltp,
    "FaOdiff": faOdiff,
    "FaOchange": faOchange,
    "InstName": instName,
    "Symbol": symbol,
    "ExpDate": expDate.toIso8601String(),
    "StrikePrice": strikePrice,
    "OptType": optType,
    "UpdTime": updTime.toIso8601String(),
    "Qty": qty,
    "OpenInterest": openInterest,
    "chgOpenInt": chgOpenInt,
  };
}
