// To parse this JSON data, do
//
//     final openIpo = openIpoFromJson(jsonString);

import 'dart:convert';

OpenIpo openIpoFromJson(String str) => OpenIpo.fromJson(json.decode(str));

String openIpoToJson(OpenIpo data) => json.encode(data.toJson());

class OpenIpo {
  OpenIpo({
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

  factory OpenIpo.fromJson(Map<String, dynamic> json) => OpenIpo(
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
    this.lname,
    this.volyr,
    this.volsrno,
    this.parvalue,
    this.issuetype,
    this.ba,
    this.nim,
    this.noshissued,
    this.issueprice,
    this.issuepri2,
    this.opendate,
    this.closdate,
    this.bbopendate,
    this.bbclosdate,
    this.listprice,
    this.minAppln,
    this.multiples,
    this.issueSize,
    this.issue,
    this.minQty,
    this.quantityMultiples,
    this.maxRetInv,
  });

  double coCode;
  String lname;
  double volyr;
  double volsrno;
  double parvalue;
  String issuetype;
  bool ba;
  bool nim;
  double noshissued;
  double issueprice;
  double issuepri2;
  DateTime opendate;
  DateTime closdate;
  DateTime bbopendate;
  DateTime bbclosdate;
  double listprice;
  double minAppln;
  double multiples;
  String issueSize;
  String issue;
  double minQty;
  double quantityMultiples;
  double maxRetInv;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["CO_CODE"],
    lname: json["lname"],
    volyr: json["VOLYR"],
    volsrno: json["VOLSRNO"],
    parvalue: json["PARVALUE"],
    issuetype: json["ISSUETYPE"],
    ba: json["BA"],
    nim: json["NIM"],
    noshissued: json["NOSHISSUED"],
    issueprice: json["ISSUEPRICE"],
    issuepri2: json["ISSUEPRI2"],
    opendate: DateTime.parse(json["OPENDATE"]),
    closdate: DateTime.parse(json["CLOSDATE"]),
    bbopendate: DateTime.parse(json["BBOPENDATE"]),
    bbclosdate: DateTime.parse(json["BBCLOSDATE"]),
    listprice: json["LISTPRICE"],
    minAppln: json["MIN_APPLN"],
    multiples: json["MULTIPLES"],
    issueSize: json["IssueSize"],
    issue: json["Issue"],
    minQty: json["MinQty"],
    quantityMultiples: json["QuantityMultiples"],
    maxRetInv: json["MaxRetInv"],
  );

  Map<String, dynamic> toJson() => {
    "CO_CODE": coCode,
    "lname": lname,
    "VOLYR": volyr,
    "VOLSRNO": volsrno,
    "PARVALUE": parvalue,
    "ISSUETYPE": issuetype,
    "BA": ba,
    "NIM": nim,
    "NOSHISSUED": noshissued,
    "ISSUEPRICE": issueprice,
    "ISSUEPRI2": issuepri2,
    "OPENDATE": opendate.toIso8601String(),
    "CLOSDATE": closdate.toIso8601String(),
    "BBOPENDATE": bbopendate.toIso8601String(),
    "BBCLOSDATE": bbclosdate.toIso8601String(),
    "LISTPRICE": listprice,
    "MIN_APPLN": minAppln,
    "MULTIPLES": multiples,
    "IssueSize": issueSize,
    "Issue": issue,
    "MinQty": minQty,
    "QuantityMultiples": quantityMultiples,
    "MaxRetInv": maxRetInv,
  };
}
