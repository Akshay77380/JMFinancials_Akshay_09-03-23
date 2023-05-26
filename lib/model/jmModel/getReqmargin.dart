// To parse this JSON data, do
//
//     final getrequiredMargin = getrequiredMarginFromJson(jsonString);

import 'dart:convert';

GetrequiredMargin getrequiredMarginFromJson(String str) => GetrequiredMargin.fromJson(json.decode(str));

String getrequiredMarginToJson(GetrequiredMargin data) => json.encode(data.toJson());

class GetrequiredMargin {
  GetrequiredMargin({
     this.status,
     this.message,
     this.errorcode,
     this.emsg,
     this.data,
  });

  bool status;
  String message;
  String errorcode;
  String emsg;
  Data data;

  factory GetrequiredMargin.fromJson(Map<String, dynamic> json) => GetrequiredMargin(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
     this.requiredMargin,
     this.haircutPercentage,
  });

  String requiredMargin;
  String haircutPercentage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    requiredMargin: json["RequiredMargin"],
    haircutPercentage: json["HaircutPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "RequiredMargin": requiredMargin,
    "HaircutPercentage": haircutPercentage,
  };
}
