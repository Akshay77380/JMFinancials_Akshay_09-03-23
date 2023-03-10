// To parse this JSON data, do
//
//     final eventsBonus = eventsBonusFromJson(jsonString);

import 'dart:convert';

EventsBonus eventsBonusFromJson(String str) => EventsBonus.fromJson(json.decode(str));

String eventsBonusToJson(EventsBonus data) => json.encode(data.toJson());

class EventsBonus {
  EventsBonus({
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

  factory EventsBonus.fromJson(Map<String, dynamic> json) => EventsBonus(
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
      this.coName,
      this.coCode,
      this.symbol,
      this.isin,
      this.announcementDate,
      this.recordDate,
      this.bonusDate,
      this.bonusRatio,
      this.remark,
      this.description,
  });

  String coName;
  double coCode;
  String symbol;
  String isin;
  DateTime announcementDate;
  DateTime recordDate;
  DateTime bonusDate;
  String bonusRatio;
  String remark;
  String description;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coName: json["co_name"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    isin: json["isin"],
    announcementDate: DateTime.parse(json["AnnouncementDate"]),
    recordDate: DateTime.parse(json["RecordDate"]),
    bonusDate: DateTime.parse(json["BonusDate"]),
    bonusRatio: json["BonusRatio"],
    remark: json["remark"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "co_name": coName,
    "co_code": coCode,
    "symbol": symbol,
    "isin": isin,
    "AnnouncementDate": announcementDate.toIso8601String(),
    "RecordDate": recordDate.toIso8601String(),
    "BonusDate": bonusDate.toIso8601String(),
    "BonusRatio": bonusRatio,
    "remark": remark,
    "Description": description,
  };
}
