// To parse this JSON data, do
//
//     final eventsBoardMeet = eventsBoardMeetFromJson(jsonString);

import 'dart:convert';

EventsBoardMeet eventsBoardMeetFromJson(String str) => EventsBoardMeet.fromJson(json.decode(str));

String eventsBoardMeetToJson(EventsBoardMeet data) => json.encode(data.toJson());

class EventsBoardMeet {
  EventsBoardMeet({
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

  factory EventsBoardMeet.fromJson(Map<String, dynamic> json) => EventsBoardMeet(
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
      this.coName,
    this.symbol,
      this.date,
      this.note,
  });

  double coCode;
  String coName;
  String symbol;
  DateTime date;
  String note;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["co_code"],
    coName: json["co_name"],
    symbol: json["symbol"],
    date: DateTime.parse(json["date"]),
    note: json["Note"],
  );

  Map<String, dynamic> toJson() => {
    "co_code": coCode,
    "co_name": coName,
    "symbol": symbol,
    "date": date.toIso8601String(),
    "Note": note,
  };
}
