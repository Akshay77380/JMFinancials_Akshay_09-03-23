// To parse this JSON data, do
//
//     final equitySip = equitySipFromJson(jsonString);

import 'dart:convert';

EquitySip equitySipFromJson(String str) => EquitySip.fromJson(json.decode(str));

String equitySipToJson(EquitySip data) => json.encode(data.toJson());

class EquitySip {
  EquitySip({
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

  factory EquitySip.fromJson(Map<String, dynamic> json) => EquitySip(
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
      this.companyname,
      this.sipReturn,
  });

  double coCode;
  String companyname;
  double sipReturn;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["co_code"],
    companyname: json["companyname"],
    sipReturn: json["SIPReturn"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "co_code": coCode,
    "companyname": companyname,
    "SIPReturn": sipReturn,
  };
}
