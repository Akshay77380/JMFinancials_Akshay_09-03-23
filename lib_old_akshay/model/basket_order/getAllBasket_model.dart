// To parse this JSON data, do
//
//     final getAllBaskets = getAllBasketsFromJson(jsonString);

import 'dart:convert';

GetAllBaskets getAllBasketsFromJson(String str) => GetAllBaskets.fromJson(json.decode(str));

String getAllBasketsToJson(GetAllBaskets data) => json.encode(data.toJson());

class GetAllBaskets {
  GetAllBaskets({
     this.status,
     this.message,
     this.errorcode,
    this.emsg,
     this.data,
  });

  bool status;
  String message;
  String errorcode;
  dynamic emsg;
  List<Datum> data;

  factory GetAllBaskets.fromJson(Map<String, dynamic> json) => GetAllBaskets(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
     this.basketId,
     this.basketName,
    this.scriptCount,
     this.createdAt,
     this.modifiedAt,
  });

  String basketId;
  String basketName;
  String scriptCount;
  String createdAt;
  String modifiedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    basketId: json["basketId"],
    basketName: json["basketName"],
    scriptCount: json["scriptCount"],
    createdAt: json["createdAt"],
    modifiedAt: json["modifiedAt"],
  );

  Map<String, dynamic> toJson() => {
    "basketId": basketId,
    "basketName": basketName,
    "scriptCount": scriptCount,
    "createdAt": createdAt,
    "modifiedAt": modifiedAt,
  };
}
