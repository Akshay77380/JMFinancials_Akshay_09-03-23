// To parse this JSON data, do
//
//     final validateAPi = validateAPiFromJson(jsonString);

import 'dart:convert';

ValidateAPi validateAPiFromJson(String str) => ValidateAPi.fromJson(json.decode(str));

String validateAPiToJson(ValidateAPi data) => json.encode(data.toJson());

class ValidateAPi {
  ValidateAPi({
    this.status,
    this.message,
    this.errorcode,
    this.emsg,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  var emsg;
  Data data;

  factory ValidateAPi.fromJson(Map json) => ValidateAPi(
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
    this.customerName,
    this.success,
    this.vpa,
  });

  var customerName;
  var success;
  var vpa;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    customerName: json["customer_name"],
    success: json["success"],
    vpa: json["vpa"],
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "success": success,
    "vpa": vpa,
  };
}
