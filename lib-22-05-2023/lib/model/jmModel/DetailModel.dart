// To parse this JSON data, do
//
//     final detail = detailFromJson(jsonString);

import 'dart:convert';

Detail detailFromJson(String str) => Detail.fromJson(json.decode(str));

String detailToJson(Detail data) => json.encode(data.toJson());

class Detail {
  Detail({
        this.trPositionsCmDetailGetDataResult,
  });

  List<TrPositionsCmDetailGetDataResult> trPositionsCmDetailGetDataResult;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
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
  String scripType;
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
    netQty: json["NetQty"]?.toDouble(),
    netRate: json["NetRate"]?.toDouble(),
    netValue: json["NetValue"]?.toDouble(),
    scripCode: json["ScripCode"],
    scripName: json["ScripName"],
    scripType: json["ScripType"],
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
    "ScripType": scripType,
    "Sector": sector,
    "TradeDate": tradeDate,
    "UnrealisedPL": unrealisedPl,
    "ValDateAndTime": valDateAndTimeValues.reverse[valDateAndTime],
    "ValRate": valRate,
    "Valuation": valuation,
    "ValuationPercentShare": valuationPercentShare,
  };
}

enum ClientName { NIRAV_MANSUKHLAL_GANDHI }

final clientNameValues = EnumValues({
  "NIRAV MANSUKHLAL GANDHI": ClientName.NIRAV_MANSUKHLAL_GANDHI
});

enum HeaderLine1 { CLIENT_CODE_10114133_NIRAV_MANSUKHLAL_GANDHI }

final headerLine1Values = EnumValues({
  "Client Code: 10114133 - NIRAV MANSUKHLAL GANDHI": HeaderLine1.CLIENT_CODE_10114133_NIRAV_MANSUKHLAL_GANDHI
});

enum Ludt { DATE_16752843000000530 }

final ludtValues = EnumValues({
  "/Date(1675284300000+0530)/": Ludt.DATE_16752843000000530
});

enum ValDateAndTime { DATE_16751898000000530, DATE_22090086000000530 }

final valDateAndTimeValues = EnumValues({
  "/Date(1675189800000+0530)/": ValDateAndTime.DATE_16751898000000530,
  "/Date(-2209008600000+0530)/": ValDateAndTime.DATE_22090086000000530
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
