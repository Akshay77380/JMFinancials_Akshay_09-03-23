// To parse this JSON data, do
//
//     final topGainersDpHoldingModel = topGainersDpHoldingModelFromJson(jsonString);

import 'dart:convert';

TopGainersDpHoldingModel topGainersDpHoldingModelFromJson(String str) => TopGainersDpHoldingModel.fromJson(json.decode(str));

String topGainersDpHoldingModelToJson(TopGainersDpHoldingModel data) => json.encode(data.toJson());

class TopGainersDpHoldingModel {
  TopGainersDpHoldingModel({
    this.dpHoldingsGetDataResult,
  });

  List<DpHoldingsGetDataResult> dpHoldingsGetDataResult;

  factory TopGainersDpHoldingModel.fromJson(Map<String, dynamic> json) => TopGainersDpHoldingModel(
    dpHoldingsGetDataResult: List<DpHoldingsGetDataResult>.from(json["DPHoldingsGetDataResult"].map((x) => DpHoldingsGetDataResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DPHoldingsGetDataResult": List<dynamic>.from(dpHoldingsGetDataResult.map((x) => x.toJson())),
  };
}

class DpHoldingsGetDataResult {
  DpHoldingsGetDataResult({
    this.approvedScrip,
    this.clientCode,
    this.clientId,
    this.clientName,
    this.currentBal,
    this.dpid,
    this.earmarkedBal,
    this.freeBal,
    this.freezedBal,
    this.headerLine1,
    this.headerLine2,
    this.holdingDateAndTime,
    this.isinCode,
    this.ludt,
    this.lockedInBal,
    this.pendingDematBal,
    this.pendingRematBal,
    this.pledgeBal,
    this.scripCode,
    this.scripName,
    this.valDateAndTime,
    this.valRate,
    this.valuation,
  });

  String approvedScrip;
  String clientCode;
  String clientId;
  ClientName clientName;
  double currentBal;
  Dpid dpid;
  int earmarkedBal;
  double freeBal;
  int freezedBal;
  HeaderLine1 headerLine1;
  String headerLine2;
  HoldingDateAndTime holdingDateAndTime;
  String isinCode;
  Ludt ludt;
  int lockedInBal;
  int pendingDematBal;
  int pendingRematBal;
  int pledgeBal;
  String scripCode;
  String scripName;
  ValDateAndTime valDateAndTime;
  double valRate;
  double valuation;

  factory DpHoldingsGetDataResult.fromJson(Map<String, dynamic> json) => DpHoldingsGetDataResult(
    approvedScrip: json["ApprovedScrip"],
    clientCode: json["ClientCode"],
    clientId: json["ClientID"],
    clientName: clientNameValues.map[json["ClientName"]],
    currentBal: json["CurrentBal"].toDouble(),
    dpid: dpidValues.map[json["DPID"]],
    earmarkedBal: json["EarmarkedBal"],
    freeBal: json["FreeBal"].toDouble(),
    freezedBal: json["FreezedBal"],
    headerLine1: headerLine1Values.map[json["HeaderLine1"]],
    headerLine2: json["HeaderLine2"],
    holdingDateAndTime: holdingDateAndTimeValues.map[json["HoldingDateAndTime"]],
    isinCode: json["ISINCode"],
    ludt: ludtValues.map[json["LUDT"]],
    lockedInBal: json["LockedInBal"],
    pendingDematBal: json["PendingDematBal"],
    pendingRematBal: json["PendingRematBal"],
    pledgeBal: json["PledgeBal"],
    scripCode: json["ScripCode"],
    scripName: json["ScripName"],
    valDateAndTime: valDateAndTimeValues.map[json["ValDateAndTime"]],
    valRate: json["ValRate"].toDouble(),
    valuation: json["Valuation"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ApprovedScrip": approvedScrip,
    "ClientCode": clientCode,
    "ClientID": clientId,
    "ClientName": clientNameValues.reverse[clientName],
    "CurrentBal": currentBal,
    "DPID": dpidValues.reverse[dpid],
    "EarmarkedBal": earmarkedBal,
    "FreeBal": freeBal,
    "FreezedBal": freezedBal,
    "HeaderLine1": headerLine1Values.reverse[headerLine1],
    "HeaderLine2": headerLine2,
    "HoldingDateAndTime": holdingDateAndTimeValues.reverse[holdingDateAndTime],
    "ISINCode": isinCode,
    "LUDT": ludtValues.reverse[ludt],
    "LockedInBal": lockedInBal,
    "PendingDematBal": pendingDematBal,
    "PendingRematBal": pendingRematBal,
    "PledgeBal": pledgeBal,
    "ScripCode": scripCode,
    "ScripName": scripName,
    "ValDateAndTime": valDateAndTimeValues.reverse[valDateAndTime],
    "ValRate": valRate,
    "Valuation": valuation,
  };
}

enum ClientName { AMIT_RAMDAS_MORADE }

final clientNameValues = EnumValues({
  "AMIT RAMDAS MORADE": ClientName.AMIT_RAMDAS_MORADE
});

enum Dpid { IN302927 }

final dpidValues = EnumValues({
  "IN302927": Dpid.IN302927
});

enum HeaderLine1 { CLIENT_CODE_10116241_AMIT_RAMDAS_MORADE }

final headerLine1Values = EnumValues({
  "Client Code: 10116241 - AMIT RAMDAS MORADE": HeaderLine1.CLIENT_CODE_10116241_AMIT_RAMDAS_MORADE
});

enum HoldingDateAndTime { DATE_16817710800000530 }

final holdingDateAndTimeValues = EnumValues({
  "/Date(1681771080000+0530)/": HoldingDateAndTime.DATE_16817710800000530
});

enum Ludt { THE_418202340800_AM }

final ludtValues = EnumValues({
  "4/18/2023 4:08:00 AM": Ludt.THE_418202340800_AM
});

enum ValDateAndTime { DATE_16817562000000530 }

final valDateAndTimeValues = EnumValues({
  "/Date(1681756200000+0530)/": ValDateAndTime.DATE_16817562000000530
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
