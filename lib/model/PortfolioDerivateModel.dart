// To parse this JSON data, do
//
//     final portfolioDerivateModel = portfolioDerivateModelFromJson(jsonString);

import 'dart:convert';

PortfolioDerivateModel portfolioDerivateModelFromJson(String str) => PortfolioDerivateModel.fromJson(json.decode(str));

String portfolioDerivateModelToJson(PortfolioDerivateModel data) => json.encode(data.toJson());

class PortfolioDerivateModel {
  PortfolioDerivateModel({
    this.trPositionsDerivativesFifoCostDetailGetDataResult,
  });

  List<TrPositionsDerivativesFifoCostDetailGetDataResult> trPositionsDerivativesFifoCostDetailGetDataResult;

  factory PortfolioDerivateModel.fromJson(Map<String, dynamic> json) => PortfolioDerivateModel(
    trPositionsDerivativesFifoCostDetailGetDataResult: List<TrPositionsDerivativesFifoCostDetailGetDataResult>.from(json["TrPositionsDerivativesFIFOCostDetailGetDataResult"].map((x) => TrPositionsDerivativesFifoCostDetailGetDataResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TrPositionsDerivativesFIFOCostDetailGetDataResult": List<dynamic>.from(trPositionsDerivativesFifoCostDetailGetDataResult.map((x) => x.toJson())),
  };
}

class TrPositionsDerivativesFifoCostDetailGetDataResult {
  TrPositionsDerivativesFifoCostDetailGetDataResult({
    this.callPut,
    this.clientCode,
    this.clientName,
    this.costPrice,
    this.exchange,
    this.expiryDate,
    this.exposureValue,
    this.headerLine1,
    this.headerLine2,
    this.ludt,
    this.longQty,
    this.longValue,
    this.multiplier,
    this.pl,
    this.productCode,
    this.scripName,
    this.seriesCode,
    this.seriesName2,
    this.settlementPrice,
    this.shortQty,
    this.shortValue,
    this.sortOrder,
    this.strikePrice,
    this.tradeDate,
    this.valRate,
  });

  String callPut;
  String clientCode;
  String clientName;
  double costPrice;
  String exchange;
  String expiryDate;
  double exposureValue;
  String headerLine1;
  String headerLine2;
  String ludt;
  int longQty;
  double longValue;
  int multiplier;
  double pl;
  String productCode;
  String scripName;
  String seriesCode;
  String seriesName2;
  double settlementPrice;
  int shortQty;
  int shortValue;
  int sortOrder;
  double strikePrice;
  String tradeDate;
  double valRate;

  factory TrPositionsDerivativesFifoCostDetailGetDataResult.fromJson(Map<String, dynamic> json) => TrPositionsDerivativesFifoCostDetailGetDataResult(
    callPut: json["CallPut"],
    clientCode: json["ClientCode"],
    clientName: json["ClientName"],
    costPrice: json["CostPrice"].toDouble(),
    exchange: json["Exchange"],
    expiryDate: json["ExpiryDate"],
    exposureValue: json["ExposureValue"].toDouble(),
    headerLine1: json["HeaderLine1"],
    headerLine2: json["HeaderLine2"],
    ludt: json["LUDT"],
    longQty: json["LongQty"],
    longValue: json["LongValue"].toDouble(),
    multiplier: json["Multiplier"],
    pl: json["PL"].toDouble(),
    productCode: json["ProductCode"],
    scripName: json["ScripName"],
    seriesCode: json["SeriesCode"],
    seriesName2: json["SeriesName2"],
    settlementPrice: json["SettlementPrice"].toDouble(),
    shortQty: json["ShortQty"],
    shortValue: json["ShortValue"],
    sortOrder: json["SortOrder"],
    strikePrice: json["StrikePrice"].toDouble(),
    tradeDate: json["TradeDate"],
    valRate: json["ValRate"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "CallPut": callPut,
    "ClientCode": clientCode,
    "ClientName": clientName,
    "CostPrice": costPrice,
    "Exchange": exchange,
    "ExpiryDate": expiryDate,
    "ExposureValue": exposureValue,
    "HeaderLine1": headerLine1,
    "HeaderLine2": headerLine2,
    "LUDT": ludt,
    "LongQty": longQty,
    "LongValue": longValue,
    "Multiplier": multiplier,
    "PL": pl,
    "ProductCode": productCode,
    "ScripName": scripName,
    "SeriesCode": seriesCode,
    "SeriesName2": seriesName2,
    "SettlementPrice": settlementPrice,
    "ShortQty": shortQty,
    "ShortValue": shortValue,
    "SortOrder": sortOrder,
    "StrikePrice": strikePrice,
    "TradeDate": tradeDate,
    "ValRate": valRate,
  };
}


