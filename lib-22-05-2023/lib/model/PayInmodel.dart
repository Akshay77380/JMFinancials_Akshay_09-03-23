// To parse this JSON data, do
//
//     final payInModel = payInModelFromJson(jsonString);

import 'dart:convert';

PayInModel payInModelFromJson(String str) => PayInModel.fromJson(json.decode(str));

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

  CompletedDate completedDate;
  String amount;
  dynamic bankReferenceNo;
  Status status;
  dynamic source;
  ClientCode clientCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    completedDate: completedDateValues.map[json["CompletedDate"]],
    amount: json["Amount"],
    bankReferenceNo: json["BankReferenceNo"],
    status: statusValues.map[json["Status"]],
    source: json["Source"],
    clientCode: clientCodeValues.map[json["ClientCode"]],
  );

  Map<String, dynamic> toJson() => {
    "CompletedDate": completedDateValues.reverse[completedDate],
    "Amount": amount,
    "BankReferenceNo": bankReferenceNo,
    "Status": statusValues.reverse[status],
    "Source": source,
    "ClientCode": clientCodeValues.reverse[clientCode],
  };
}

enum ClientCode { SPD333 }

final clientCodeValues = EnumValues({
  "SPD333": ClientCode.SPD333
});

enum CompletedDate { THE_21012023 }

final completedDateValues = EnumValues({
  "21/01/2023": CompletedDate.THE_21012023
});

enum Status { FAILED }

final statusValues = EnumValues({
  "failed": Status.FAILED
});

class EnumValues<T> {
  Map<String, T> map;
   Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
