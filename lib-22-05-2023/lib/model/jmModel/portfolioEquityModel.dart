// To parse this JSON data, do
//
//     final portfolioEquity = portfolioEquityFromJson(jsonString);

import 'dart:convert';

PortfolioEquity portfolioEquityFromJson(String str) => PortfolioEquity.fromJson(json.decode(str));

String portfolioEquityToJson(PortfolioEquity data) => json.encode(data.toJson());

class PortfolioEquity {
  PortfolioEquity({
      this.trPositionsCmDetailGetDataResult,
  });

  List<TrPositionsCmDetailGetDataResult> trPositionsCmDetailGetDataResult;

  factory PortfolioEquity.fromJson(Map<String, dynamic> json) => PortfolioEquity(
    trPositionsCmDetailGetDataResult: List<TrPositionsCmDetailGetDataResult>.from(json["TrPositionsCMDetailGetDataResult"].map((x) => TrPositionsCmDetailGetDataResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TrPositionsCMDetailGetDataResult": List<dynamic>.from(trPositionsCmDetailGetDataResult.map((x) => x.toJson())),
  };
}

class TrPositionsCmDetailGetDataResult {
  TrPositionsCmDetailGetDataResult({
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
      this.tradeDate,
      this.unrealisedPl,
      this.valDateAndTime,
      this.valRate,
      this.valuation,
      this.valuationPercentShare,
  });

  String clientCode;
  ClientName clientName;
  String exchangeInternalScripCode;
  HeaderLine1 headerLine1;
  String headerLine2;
  String isinCode;
  Ludt ludt;
  int marketValue;
  int mktRate;
  double multiplier;
  double netQty;
  double netRate;
  double netValue;
  String scripCode;
  String scripName;
  ScripType scripType;
  String sector;
  String tradeDate;
  double unrealisedPl;
  ValDateAndTime valDateAndTime;
  double valRate;
  double valuation;
  double valuationPercentShare;

  factory TrPositionsCmDetailGetDataResult.fromJson(Map<String, dynamic> json) => TrPositionsCmDetailGetDataResult(
    clientCode: json["ClientCode"],
    clientName: clientNameValues.map[json["ClientName"]],
    exchangeInternalScripCode: json["ExchangeInternalScripCode"],
    headerLine1: headerLine1Values.map[json["HeaderLine1"]],
    headerLine2: json["HeaderLine2"],
    isinCode: json["ISINCode"],
    ludt: ludtValues.map[json["LUDT"]],
    marketValue: json["MarketValue"],
    mktRate: json["MktRate"],
    multiplier: json["Multiplier"],
    netQty: json["NetQty"],
    netRate: json["NetRate"]?.toDouble(),
    netValue: json["NetValue"]?.toDouble(),
    scripCode: json["ScripCode"],
    scripName: json["ScripName"],
    scripType: scripTypeValues.map[json["ScripType"]],
    sector: json["Sector"],
    tradeDate: json["TradeDate"],
    unrealisedPl: json["UnrealisedPL"]?.toDouble(),
    valDateAndTime: valDateAndTimeValues.map[json["ValDateAndTime"]],
    valRate: json["ValRate"]?.toDouble(),
    valuation: json["Valuation"]?.toDouble(),
    valuationPercentShare: json["ValuationPercentShare"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ClientCode": clientCode,
    "ClientName": clientNameValues.reverse[clientName],
    "ExchangeInternalScripCode": exchangeInternalScripCode,
    "HeaderLine1": headerLine1Values.reverse[headerLine1],
    "HeaderLine2": headerLine2,
    "ISINCode": isinCode,
    "LUDT": ludtValues.reverse[ludt],
    "MarketValue": marketValue,
    "MktRate": mktRate,
    "Multiplier": multiplier,
    "NetQty": netQty,
    "NetRate": netRate,
    "NetValue": netValue,
    "ScripCode": scripCode,
    "ScripName": scripName,
    "ScripType": scripTypeValues.reverse[scripType],
    "Sector": sector,
    "TradeDate": tradeDate,
    "UnrealisedPL": unrealisedPl,
    "ValDateAndTime": valDateAndTimeValues.reverse[valDateAndTime],
    "ValRate": valRate,
    "Valuation": valuation,
    "ValuationPercentShare": valuationPercentShare,
  };
}

enum ClientName { ANOOP_SHARMA }

final clientNameValues = EnumValues({
  "ANOOP  SHARMA": ClientName.ANOOP_SHARMA
});

enum HeaderLine1 { CLIENT_CODE_12312822_ANOOP_SHARMA }

final headerLine1Values = EnumValues({
  "Client Code: 12312822 - ANOOP  SHARMA": HeaderLine1.CLIENT_CODE_12312822_ANOOP_SHARMA
});

enum Ludt { DATE_16768395000000530 }

final ludtValues = EnumValues({
  "/Date(1676839500000+0530)/": Ludt.DATE_16768395000000530
});

enum ScripType { A, EMPTY, B, EQ, T }

final scripTypeValues = EnumValues({
  "A": ScripType.A,
  "B": ScripType.B,
  "": ScripType.EMPTY,
  "EQ": ScripType.EQ,
  "T": ScripType.T
});

enum ValDateAndTime { DATE_16765722000000530 }

final valDateAndTimeValues = EnumValues({
  "/Date(1676572200000+0530)/": ValDateAndTime.DATE_16765722000000530
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
