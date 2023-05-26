// To parse this JSON data, do
//
//     final ipoRecentListing = ipoRecentListingFromJson(jsonString);

import 'dart:convert';

IpoRecentListing ipoRecentListingFromJson(String str) => IpoRecentListing.fromJson(json.decode(str));

String ipoRecentListingToJson(IpoRecentListing data) => json.encode(data.toJson());

class IpoRecentListing {
  IpoRecentListing({
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

  factory IpoRecentListing.fromJson(Map<String, dynamic> json) => IpoRecentListing(
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
    this.code,
    this.coCode,
    this.coName,
    this.listdate,
    this.listprice,
    this.listvol,
    this.high,
    this.low,
    this.close,
    this.date,
    this.volume,
    this.lastTrDate,
    this.issueSize,
    this.offerPrice,
    this.perChange,
    this.issuePrice,
    this.lname,
  });

  String code;
  double coCode;
  String coName;
  DateTime listdate;
  double listprice;
  double listvol;
  double high;
  double low;
  double close;
  DateTime date;
  double volume;
  DateTime lastTrDate;
  String issueSize;
  double offerPrice;
  double perChange;
  double issuePrice;
  String lname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    code: json["code"],
    coCode: json["co_code"],
    coName: json["CO_NAME"],
    listdate: DateTime.parse(json["LISTDATE"]),
    listprice: json["LISTPRICE"].toDouble(),
    listvol: json["LISTVOL"],
    high: json["HIGH"].toDouble(),
    low: json["LOW"].toDouble(),
    close: json["CLOSE"].toDouble(),
    date: DateTime.parse(json["DATE"]),
    volume: json["VOLUME"],
    lastTrDate: DateTime.parse(json["LastTr_Date"]),
    issueSize: json["IssueSize"],
    offerPrice: json["OfferPrice"].toDouble(),
    perChange: json["PerChange"].toDouble(),
    issuePrice: json["IssuePrice"],
    lname: json["lname"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "co_code": coCode,
    "CO_NAME": coName,
    "LISTDATE": listdate.toIso8601String(),
    "LISTPRICE": listprice,
    "LISTVOL": listvol,
    "HIGH": high,
    "LOW": low,
    "CLOSE": close,
    "DATE": date.toIso8601String(),
    "VOLUME": volume,
    "LastTr_Date": lastTrDate.toIso8601String(),
    "IssueSize": issueSize,
    "OfferPrice": offerPrice,
    "PerChange": perChange,
    "IssuePrice": issuePrice,
    "lname": lname,
  };
}
