// To parse this JSON data, do
//
//     final companyQuoteDividend = companyQuoteDividendFromJson(jsonString);

import 'dart:convert';

CompanyQuoteDividend companyQuoteDividendFromJson(String str) => CompanyQuoteDividend.fromJson(json.decode(str));

String companyQuoteDividendToJson(CompanyQuoteDividend data) => json.encode(data.toJson());

class CompanyQuoteDividend {
  CompanyQuoteDividend({
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

  factory CompanyQuoteDividend.fromJson(Map<String, dynamic> json) => CompanyQuoteDividend(
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
      this.coName,
      this.coCode,
      this.symbol,
      this.isin,
      this.announcementDate,
      this.divDate,
      this.recordDate,
      this.divAmount,
      this.divPer,
      this.dividendType,
      this.description,
    this.dividendPayoutDate,
  });

  String coName;
  double coCode;
  String symbol;
  String isin;
  DateTime announcementDate;
  DateTime divDate;
  DateTime recordDate;
  double divAmount;
  double divPer;
  String dividendType;
  String description;
  dynamic dividendPayoutDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coName: json["co_name"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    isin: json["isin"],
    announcementDate: DateTime.parse(json["AnnouncementDate"]),
    divDate: DateTime.parse(json["DivDate"]),
    recordDate: DateTime.parse(json["RecordDate"]),
    divAmount: json["DivAmount"]?.toDouble(),
    divPer: json["DivPer"]?.toDouble(),
    dividendType: json["DividendType"],
    description: json["Description"],
    dividendPayoutDate: json["DividendPayoutDate"],
  );

  Map<String, dynamic> toJson() => {
    "co_name": coName,
    "co_code": coCode,
    "symbol": symbol,
    "isin": isin,
    "AnnouncementDate": announcementDate.toIso8601String(),
    "DivDate": divDate.toIso8601String(),
    "RecordDate": recordDate.toIso8601String(),
    "DivAmount": divAmount,
    "DivPer": divPer,
    "DividendType": dividendType,
    "Description": description,
    "DividendPayoutDate": dividendPayoutDate,
  };
}
