// To parse this JSON data, do
//
//     final decreaseInOi = decreaseInOiFromJson(jsonString);

import 'dart:convert';

DecreaseInOi decreaseInOiFromJson(String str) => DecreaseInOi.fromJson(json.decode(str));

String decreaseInOiToJson(DecreaseInOi data) => json.encode(data.toJson());

class DecreaseInOi {
  DecreaseInOi({
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

  factory DecreaseInOi.fromJson(Map<String, dynamic> json) => DecreaseInOi(
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
  InstName instName;
  String symbol;
  DateTime expDate;
  double strikePrice;
  OptType optType;
  DateTime updTime;
  int qty;
  int openInterest;
  double chgOpenInt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    prevLtp: json["PrevLtp"]?.toDouble(),
    ltp: json["LTP"]?.toDouble(),
    faOdiff: json["FaOdiff"]?.toDouble(),
    faOchange: json["FaOchange"]?.toDouble(),
    instName: instNameValues.map[json["InstName"]],
    symbol: json["Symbol"],
    expDate: DateTime.parse(json["ExpDate"]),
    strikePrice: json["StrikePrice"]?.toDouble(),
    optType: optTypeValues.map[json["OptType"]],
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
    "InstName": instNameValues.reverse[instName],
    "Symbol": symbol,
    "ExpDate": expDate.toIso8601String(),
    "StrikePrice": strikePrice,
    "OptType": optTypeValues.reverse[optType],
    "UpdTime": updTime.toIso8601String(),
    "Qty": qty,
    "OpenInterest": openInterest,
    "chgOpenInt": chgOpenInt,
  };
}

enum InstName { OPTSTK }

final instNameValues = EnumValues({
  "OPTSTK": InstName.OPTSTK
});

enum OptType { CE, PE }

final optTypeValues = EnumValues({
  "CE": OptType.CE,
  "PE": OptType.PE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
