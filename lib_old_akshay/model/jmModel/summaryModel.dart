// To parse this JSON data, do
//
//     final summaryApi = summaryApiFromJson(jsonString);

import 'dart:convert';

SummaryApi summaryApiFromJson(String str) => SummaryApi.fromJson(json.decode(str));

String summaryApiToJson(SummaryApi data) => json.encode(data.toJson());

class SummaryApi {
  SummaryApi({
      this.trPositionsCmGetDataResult,
  });


  List<TrPositionsCmGetDataResult> trPositionsCmGetDataResult;

  factory SummaryApi.fromJson(Map<String, dynamic> json) => SummaryApi(
    trPositionsCmGetDataResult: List<TrPositionsCmGetDataResult>.from(json["TrPositionsCMGetDataResult"].map((x) => TrPositionsCmGetDataResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TrPositionsCMGetDataResult": List<dynamic>.from(trPositionsCmGetDataResult.map((x) => x.toJson())),
  };
}

class TrPositionsCmGetDataResult {
  TrPositionsCmGetDataResult({
      this.clientCode,
      this.clientName,
      this.exchangeInternalScripCode,
      this.headerLine1,
      this.headerLine2,
      this.isinCode,
      this.ludt,
      this.marketValue,
      this.mktRate,
      this.multiplier,
      this.netQty,
      this.netRate,
      this.netValue,
      this.scripCode,
      this.scripName,
      this.scripType,
      this.sector,
      this.unrealisedPl,
      this.valDateAndTime,
      this.valRate,
      this.valuation,
      this.valuationPercentShare,
  });

  String clientCode;
  String clientName;
  String exchangeInternalScripCode;
  String headerLine1;
  String headerLine2;
  String isinCode;
  String ludt;
  int marketValue;
  int mktRate;
  double multiplier;
  double netQty;
  double netRate;
  double netValue;
  String scripCode;
  String scripName;
  String scripType;
  String sector;
  double unrealisedPl;
  String valDateAndTime;
  double valRate;
  double valuation;
  double valuationPercentShare;

  factory TrPositionsCmGetDataResult.fromJson(Map<String, dynamic> json) => TrPositionsCmGetDataResult(
    clientCode: json["ClientCode"],
    clientName: json["ClientName"],
    exchangeInternalScripCode: json["ExchangeInternalScripCode"],
    headerLine1: json["HeaderLine1"],
    headerLine2: json["HeaderLine2"],
    isinCode: json["ISINCode"],
    ludt: json["LUDT"],
    marketValue: json["MarketValue"],
    mktRate: json["MktRate"],
    multiplier: json["Multiplier"],
    netQty: json["NetQty"]?.toDouble(),
    netRate: json["NetRate"]?.toDouble(),
    netValue: json["NetValue"]?.toDouble(),
    scripCode: json["ScripCode"],
    scripName: json["ScripName"],
    scripType: json["ScripType"],
    sector: json["Sector"],
    unrealisedPl: json["UnrealisedPL"]?.toDouble(),
    valDateAndTime: json["ValDateAndTime"],
    valRate: json["ValRate"]?.toDouble(),
    valuation: json["Valuation"]?.toDouble(),
    valuationPercentShare: json["ValuationPercentShare"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ClientCode": clientCode,
    "ClientName": clientName,
    "ExchangeInternalScripCode": exchangeInternalScripCode,
    "HeaderLine1": headerLine1,
    "HeaderLine2": headerLine2,
    "ISINCode": isinCode,
    "LUDT": ludt,
    "MarketValue": marketValue,
    "MktRate": mktRate,
    "Multiplier": multiplier,
    "NetQty": netQty,
    "NetRate": netRate,
    "NetValue": netValue,
    "ScripCode": scripCode,
    "ScripName": scripName,
    "ScripType": scripType,
    "Sector": sector,
    "UnrealisedPL": unrealisedPl,
    "ValDateAndTime": valDateAndTime,
    "ValRate": valRate,
    "Valuation": valuation,
    "ValuationPercentShare": valuationPercentShare,
  };
}
