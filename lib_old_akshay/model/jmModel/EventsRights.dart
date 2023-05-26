// To parse this JSON data, do
//
//     final eventsRights = eventsRightsFromJson(jsonString);

import 'dart:convert';

EventsRights eventsRightsFromJson(String str) => EventsRights.fromJson(json.decode(str));

String eventsRightsToJson(EventsRights data) => json.encode(data.toJson());

class EventsRights {
  EventsRights({
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

  factory EventsRights.fromJson(Map<String, dynamic> json) => EventsRights(
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
      this.recorddate,
      this.rightDate,
      this.rightsRatio,
      this.premium,
      this.remark,
      this.description,
    this.noDeliveryStartDate,
    this.noDeliveryEndDate,
  });

  String coName;
  double coCode;
  String symbol;
  String isin;
  DateTime announcementDate;
  DateTime recorddate;
  DateTime rightDate;
  String rightsRatio;
  double premium;
  String remark;
  String description;
  dynamic noDeliveryStartDate;
  dynamic noDeliveryEndDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coName: json["co_name"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    isin: json["isin"],
    announcementDate: DateTime.parse(json["AnnouncementDate"]),
    recorddate: DateTime.parse(json["recorddate"]),
    rightDate: DateTime.parse(json["RightDate"]),
    rightsRatio: json["RightsRatio"],
    premium: json["premium"],
    remark: json["remark"],
    description: json["Description"],
    noDeliveryStartDate: json["NoDeliveryStartDate"],
    noDeliveryEndDate: json["NoDeliveryEndDate"],
  );

  Map<String, dynamic> toJson() => {
    "co_name": coName,
    "co_code": coCode,
    "symbol": symbol,
    "isin": isin,
    "AnnouncementDate": announcementDate.toIso8601String(),
    "recorddate": recorddate.toIso8601String(),
    "RightDate": rightDate.toIso8601String(),
    "RightsRatio": rightsRatio,
    "premium": premium,
    "remark": remark,
    "Description": description,
    "NoDeliveryStartDate": noDeliveryStartDate,
    "NoDeliveryEndDate": noDeliveryEndDate,
  };
}
