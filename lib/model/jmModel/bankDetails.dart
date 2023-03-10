// To parse this JSON data, do
//
//     final bankDetails = bankDetailsFromJson(jsonString);

import 'dart:convert';

BankDetails bankDetailsFromJson(String str) => BankDetails.fromJson(json.decode(str));

String bankDetailsToJson(BankDetails data) => json.encode(data.toJson());

class BankDetails {
  BankDetails({
    this.status,
    this.message,
    this.errorcode,
    this.emsg,
    this.data,
  });

  var status;
  String message;
  String errorcode;
  var emsg;
  List<Datum> data;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
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
    this.id,
    this.name,
    this.clientName,
    this.accountNo,
    this.ifsc,
  });

  String id;
  String name;
  String clientName;
  String accountNo;
  String ifsc;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["Id"],
    name: json["Name"],
    clientName: json["ClientName"],
    accountNo: json["AccountNo"],
    ifsc: json["IFSC"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ClientName": clientName,
    "AccountNo": accountNo,
    "IFSC": ifsc,
  };
}
