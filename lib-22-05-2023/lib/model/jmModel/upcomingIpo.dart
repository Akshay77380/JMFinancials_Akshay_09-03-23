// To parse this JSON data, do
//
//     final upcomingIpo = upcomingIpoFromJson(jsonString);

import 'dart:convert';

UpcomingIpo upcomingIpoFromJson(String str) => UpcomingIpo.fromJson(json.decode(str));

String upcomingIpoToJson(UpcomingIpo data) => json.encode(data.toJson());

class UpcomingIpo {
  UpcomingIpo({
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

  factory UpcomingIpo.fromJson(Map<String, dynamic> json) => UpcomingIpo(
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
    this.opendate,
    this.closdate,
    this.parvalue,
    this.issueprice,
    this.issuepri2,
    this.lname,
    this.issueSize,
    this.issueType,
    this.issue,
    this.daysLeft,
    this.minQty,
    this.quantityMultiples,
    this.maxRetInv,
  });

  double coCode;
  DateTime opendate;
  DateTime closdate;
  double parvalue;
  double issueprice;
  double issuepri2;
  String lname;
  String issueSize;
  String issueType;
  String issue;
  int daysLeft;
  double minQty;
  double quantityMultiples;
  double maxRetInv;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["CO_CODE"],
    opendate: DateTime.parse(json["OPENDATE"]),
    closdate: DateTime.parse(json["CLOSDATE"]),
    parvalue: json["PARVALUE"],
    issueprice: json["ISSUEPRICE"],
    issuepri2: json["ISSUEPRI2"],
    lname: json["LNAME"],
    issueSize: json["IssueSize"],
    issueType: json["IssueType"],
    issue: json["Issue"],
    daysLeft: json["DaysLeft"],
    minQty: json["MinQty"],
    quantityMultiples: json["QuantityMultiples"],
    maxRetInv: json["MaxRetInv"],
  );

  Map<String, dynamic> toJson() => {
    "CO_CODE": coCode,
    "OPENDATE": opendate.toIso8601String(),
    "CLOSDATE": closdate.toIso8601String(),
    "PARVALUE": parvalue,
    "ISSUEPRICE": issueprice,
    "ISSUEPRI2": issuepri2,
    "LNAME": lname,
    "IssueSize": issueSize,
    "IssueType": issueType,
    "Issue": issue,
    "DaysLeft": daysLeft,
    "MinQty": minQty,
    "QuantityMultiples": quantityMultiples,
    "MaxRetInv": maxRetInv,
  };
}
