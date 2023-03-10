// To parse this JSON data, do
//
//     final blockDeals = blockDealsFromJson(jsonString);

import 'dart:convert';

BlockDeals blockDealsFromJson(String str) => BlockDeals.fromJson(json.decode(str));

String blockDealsToJson(BlockDeals data) => json.encode(data.toJson());

class BlockDeals {
  BlockDeals({
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

  factory BlockDeals.fromJson(Map<String, dynamic> json) => BlockDeals(
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
    this.scripcode,
    this.date,
    this.serial,
    this.coCode,
    this.scripName,
    this.clientName,
    this.buysell,
    this.qtyshares,
    this.avgPrice,
  });

  String scripcode;
  DateTime date;
  double serial;
  double coCode;
  String scripName;
  String clientName;
  Buysell buysell;
  double qtyshares;
  double avgPrice;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    scripcode: json["scripcode"],
    date: DateTime.parse(json["Date"]),
    serial: json["Serial"],
    coCode: json["CO_CODE"],
    scripName: json["ScripName"],
    clientName: json["ClientName"],
    buysell: buysellValues.map[json["BUYSELL"]],
    qtyshares: json["QTYSHARES"],
    avgPrice: json["AVG_PRICE"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "scripcode": scripcode,
    "Date": date.toIso8601String(),
    "Serial": serial,
    "CO_CODE": coCode,
    "ScripName": scripName,
    "ClientName": clientName,
    "BUYSELL": buysellValues.reverse[buysell],
    "QTYSHARES": qtyshares,
    "AVG_PRICE": avgPrice,
  };
}

enum Buysell { S, B }

final buysellValues = EnumValues({
  "B": Buysell.B,
  "S": Buysell.S
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
