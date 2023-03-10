// To parse this JSON data, do
//
//     final worldIndices = worldIndicesFromJson(jsonString);

import 'dart:convert';

WorldIndices worldIndicesFromJson(String str) => WorldIndices.fromJson(json.decode(str));

String worldIndicesToJson(WorldIndices data) => json.encode(data.toJson());

class WorldIndices {
  WorldIndices({
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

  factory WorldIndices.fromJson(Map<String, dynamic> json) => WorldIndices(
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
    this.indexname,
    this.country,
    this.date,
    this.close,
    this.chg,
    this.pChg,
    this.prevClose,
  });

  String indexname;
  String country;
  DateTime date;
  double close;
  double chg;
  double pChg;
  double prevClose;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    indexname: json["indexname"],
    country: json["Country"],
    date: DateTime.parse(json["date"]),
    close: json["close"].toDouble(),
    chg: json["Chg"].toDouble(),
    pChg: json["PChg"].toDouble(),
    prevClose: json["PrevClose"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "indexname": indexname,
    "Country": country,
    "date": date.toIso8601String(),
    "close": close,
    "Chg": chg,
    "PChg": pChg,
    "PrevClose": prevClose,
  };
}
