// To parse this JSON data, do
//
//     final eventsSplits = eventsSplitsFromJson(jsonString);

import 'dart:convert';

EventsSplits eventsSplitsFromJson(String str) => EventsSplits.fromJson(json.decode(str));

String eventsSplitsToJson(EventsSplits data) => json.encode(data.toJson());

class EventsSplits {
  EventsSplits({
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

  factory EventsSplits.fromJson(Map<String, dynamic> json) => EventsSplits(
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
      this.coCode,
      this.scCode,
    this.symbol,
      this.coName,
      this.isin,
      this.currentPrice,
      this.pricediff,
      this.perChange,
      this.tradeDate,
      this.splitDate,
      this.fvFrom,
      this.fvTo,
      this.note,
  });

  double coCode;
  String scCode;
  String symbol;
  String coName;
  String isin;
  double currentPrice;
  double pricediff;
  double perChange;
  DateTime tradeDate;
  DateTime splitDate;
  double fvFrom;
  double fvTo;
  String note;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["co_code"],
    scCode: json["sc_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    isin: json["isin"],
    currentPrice: json["CurrentPrice"]?.toDouble(),
    pricediff: json["Pricediff"]?.toDouble(),
    perChange: json["PerChange"]?.toDouble(),
    tradeDate: DateTime.parse(json["TradeDate"]),
    splitDate: DateTime.parse(json["SplitDate"]),
    fvFrom: json["FV_From"],
    fvTo: json["FV_To"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "co_code": coCode,
    "sc_code": scCode,
    "symbol": symbol,
    "co_name": coName,
    "isin": isin,
    "CurrentPrice": currentPrice,
    "Pricediff": pricediff,
    "PerChange": perChange,
    "TradeDate": tradeDate.toIso8601String(),
    "SplitDate": splitDate.toIso8601String(),
    "FV_From": fvFrom,
    "FV_To": fvTo,
    "note": note,
  };
}
