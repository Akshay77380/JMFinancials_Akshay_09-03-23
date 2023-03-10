// To parse this JSON data, do
//
//     final bulkDeals = bulkDealsFromJson(jsonString);

import 'dart:convert';

import 'package:markets/model/scrip_info_model.dart';
import 'package:markets/util/CommonFunctions.dart';

BulkDeals bulkDealsFromJson(String str) => BulkDeals.fromJson(json.decode(str));

String bulkDealsToJson(BulkDeals data) => json.encode(data.toJson());

class BulkDeals {
  BulkDeals({
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
  ScripInfoModel model;

  factory BulkDeals.fromJson(Map<String, dynamic> json) => BulkDeals(
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
    this.scripname,
    this.clientname,
    this.buysell,
    this.qtyshares,
    this.avgPrice,
    this.model,
  }) {
    model = CommonFunction.getScripDataModel(
      exch: 'B',
      exchCode: int.parse(scripcode),
      sendReq: true,
      getNseBseMap: true,
    );
  }

  String scripcode;
  DateTime date;
  double serial;
  double coCode;
  String scripname;
  String clientname;
  Buysell buysell;
  double qtyshares;
  double avgPrice;
  ScripInfoModel model;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    scripcode: json["scripcode"],
    date: DateTime.parse(json["Date"]),
    serial: json["Serial"],
    coCode: json["CO_CODE"],
    scripname: json["scripname"],
    clientname: json["clientname"],
    buysell: buysellValues.map[json["buysell"]],
    qtyshares: json["qtyshares"],
    avgPrice: json["avg_price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "scripcode": scripcode,
    "Date": date.toIso8601String(),
    "Serial": serial,
    "CO_CODE": coCode,
    "scripname": scripname,
    "clientname": clientname,
    "buysell": buysellValues.reverse[buysell],
    "qtyshares": qtyshares,
    "avg_price": avgPrice,
  };


}

enum Buysell { B, S }

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
