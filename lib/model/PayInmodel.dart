// To parse this JSON data, do
//
//     final payInModel = payInModelFromJson(jsonString);

import 'dart:convert';

PayInModel payInModelFromJson(String str) =>
    PayInModel.fromJson(json.decode(str));

String payInModelToJson(PayInModel data) => json.encode(data.toJson());

class PayInModel {
  PayInModel({
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

  factory PayInModel.fromJson(Map<String, dynamic> json) => PayInModel(
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
    this.completedDate,
    this.amount,
    this.bankReferenceNo,
    this.status,
    this.source,
    this.clientCode,
  });

  String completedDate;
  String amount;
  dynamic bankReferenceNo;
  String status;
  dynamic source;
  String clientCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        completedDate: json["CompletedDate"],
        amount: json["Amount"],
        bankReferenceNo: json["BankReferenceNo"],
        status: json["Status"],
        source: json["Source"],
        clientCode: json["ClientCode"],
      );

  Map<String, dynamic> toJson() => {
        "CompletedDate": completedDate,
        "Amount": amount,
        "BankReferenceNo": bankReferenceNo,
        "Status": status,
        "Source": source,
        "ClientCode": clientCode,
      };

  @override
  String toString() {
    return 'Datum{completedDate: $completedDate, amount: $amount, bankReferenceNo: $bankReferenceNo, status: $status, source: $source, clientCode: $clientCode}';
  }
}
