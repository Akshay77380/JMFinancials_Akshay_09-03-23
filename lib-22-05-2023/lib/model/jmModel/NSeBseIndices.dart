// To parse this JSON data, do
//
//     final nseBseIndices = nseBseIndicesFromJson(jsonString);

import 'dart:convert';

NseBseIndices nseBseIndicesFromJson(String str) => NseBseIndices.fromJson(json.decode(str));

String nseBseIndicesToJson(NseBseIndices data) => json.encode(data.toJson());

class NseBseIndices {
  NseBseIndices({
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

  factory NseBseIndices.fromJson(Map<String, dynamic> json) => NseBseIndices(
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
     this.exchange,
     this.indexCode,
     this.indexName,
     this.currentprice,
     this.prevclose,
     this.pricediff,
     this.prechange,
     this.tradetime,
  });

  Exchange exchange;
  double indexCode;
  String indexName;
  double currentprice;
  double prevclose;
  double pricediff;
  double prechange;
  DateTime tradetime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    exchange: exchangeValues.map[json["exchange"]],
    indexCode: json["IndexCode"],
    indexName: json["IndexName"],
    currentprice: json["Currentprice"]?.toDouble(),
    prevclose: json["prevclose"]?.toDouble(),
    pricediff: json["pricediff"]?.toDouble(),
    prechange: json["prechange"]?.toDouble(),
    tradetime: DateTime.parse(json["tradetime"]),
  );

  Map<String, dynamic> toJson() => {
    "exchange": exchangeValues.reverse[exchange],
    "IndexCode": indexCode,
    "IndexName": indexName,
    "Currentprice": currentprice,
    "prevclose": prevclose,
    "pricediff": pricediff,
    "prechange": prechange,
    "tradetime": tradetime.toIso8601String(),
  };
}

enum Exchange { BSE }

final exchangeValues = EnumValues({
  "BSE": Exchange.BSE
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
