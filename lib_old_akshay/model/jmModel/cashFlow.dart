// To parse this JSON data, do
//
//     final cashFlow = cashFlowFromJson(jsonString);

import 'dart:convert';

CashFlow cashFlowFromJson(String str) => CashFlow.fromJson(json.decode(str));

String cashFlowToJson(CashFlow data) => json.encode(data.toJson());

class CashFlow {
  CashFlow({
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

  factory CashFlow.fromJson(Map<String, dynamic> json) => CashFlow(
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
    this.columnname,
    this.rid,
    this.y202112,
    this.rowno,
  });

  String columnname;
  int rid;
  double y202112;
  int rowno;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    columnname: json["COLUMNNAME"] == null ? null : json["COLUMNNAME"],
    rid: json["RID"],
    y202112: json["Y202112"].toDouble(),
    rowno: json["rowno"],
  );

  Map<String, dynamic> toJson() => {
    "COLUMNNAME": columnname == null ? null : columnname,
    "RID": rid,
    "Y202112": y202112,
    "rowno": rowno,
  };
}
