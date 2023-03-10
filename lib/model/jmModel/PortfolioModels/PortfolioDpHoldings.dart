// To parse this JSON data, do
//
//     final dpHoldings = dpHoldingsFromJson(jsonString);

import 'dart:convert';

DpHoldings dpHoldingsFromJson(String str) => DpHoldings.fromJson(json.decode(str));

String dpHoldingsToJson(DpHoldings data) => json.encode(data.toJson());

class DpHoldings {
  DpHoldings({
      this.dpHoldingsGetDataResult,
  });

  List<Datum> dpHoldingsGetDataResult;

  factory DpHoldings.fromJson(Map<String, dynamic> json) => DpHoldings(
    dpHoldingsGetDataResult: List<Datum>.from(json["DPHoldingsGetDataResult"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DPHoldingsGetDataResult": List<dynamic>.from(dpHoldingsGetDataResult.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
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
  String dpid;
  double earmarkedBal;
  double freeBal;
  double freezedBal;
  HeaderLine1 headerLine1;
  String headerLine2;
  HoldingDateAndTime holdingDateAndTime;
  String isinCode;
  Ludt ludt;
  double lockedInBal;
  double pendingDematBal;
  double pendingRematBal;
  double pledgeBal;
  String scripCode;
  String scripName;
  ValDateAndTime valDateAndTime;
  double valRate;
  double valuation;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    approvedScrip: json["ApprovedScrip"],
    clientCode: json["ClientCode"],
    clientId: json["ClientID"],
    clientName: clientNameValues.map[json["ClientName"]],
    currentBal: json["CurrentBal"],
    dpid: json["DPID"],
    earmarkedBal: json["EarmarkedBal"],
    freeBal: json["FreeBal"],
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
    valRate: json["ValRate"]?.toDouble(),
    valuation: json["Valuation"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ApprovedScrip": approvedScrip,
    "ClientCode": clientCode,
    "ClientID": clientId,
    "ClientName": clientNameValues.reverse[clientName],
    "CurrentBal": currentBal,
    "DPID": dpid,
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

enum ClientName { NIRAV_MANSUKHLAL_GANDHI }

final clientNameValues = EnumValues({
  "NIRAV MANSUKHLAL GANDHI": ClientName.NIRAV_MANSUKHLAL_GANDHI
});

enum HeaderLine1 { CLIENT_CODE_10114133_NIRAV_MANSUKHLAL_GANDHI }

final headerLine1Values = EnumValues({
  "Client Code: 10114133 - NIRAV MANSUKHLAL GANDHI": HeaderLine1.CLIENT_CODE_10114133_NIRAV_MANSUKHLAL_GANDHI
});

enum HoldingDateAndTime { DATE_16765101000000530, DATE_16764988200000530 }

final holdingDateAndTimeValues = EnumValues({
  "/Date(1676498820000+0530)/": HoldingDateAndTime.DATE_16764988200000530,
  "/Date(1676510100000+0530)/": HoldingDateAndTime.DATE_16765101000000530
});

enum Ludt { THE_216202364500_AM, THE_216202333700_AM }

final ludtValues = EnumValues({
  "2/16/2023 3:37:00 AM": Ludt.THE_216202333700_AM,
  "2/16/2023 6:45:00 AM": Ludt.THE_216202364500_AM
});

enum ValDateAndTime { DATE_16769178000000530 }

final valDateAndTimeValues = EnumValues({
  "/Date(1676917800000+0530)/": ValDateAndTime.DATE_16769178000000530
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
