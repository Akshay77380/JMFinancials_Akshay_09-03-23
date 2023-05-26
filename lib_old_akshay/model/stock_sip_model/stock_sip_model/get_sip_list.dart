// To parse this JSON data, do
//
//     final getSipList = getSipListFromJson(jsonString);

import 'dart:convert';

import '../../../util/CommonFunctions.dart';
import '../../scrip_info_model.dart';

List<GetSipList> getSipListFromJson(String str) => List<GetSipList>.from(json.decode(str).map((x) => GetSipList.fromJson(x)));

String getSipListToJson(List<GetSipList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSipList {
  GetSipList({
    this.instId,
    this.exch,
    this.exchType,
    this.scripCode,
    this.symbol,
    this.description,
    this.startDate,
    this.sipPeriod,
    this.qty,
    this.value,
    this.expiryDate,
    this.nextTradeDate,
    this.upperPriceLimit,
    this.lowerPriceLimit,
    this.buyPlacedQty,
    this.buyRejectedQty,
    this.buyExchTradedQty,
    this.buyExchRejectedQty,
    this.buyExchPendingQty,
    this.buyExchTradedRate,
    this.instructionState,
    this.model,
  }) {
    model = CommonFunction.getScripDataModel(
      exch: exch,
      exchCode: scripCode,
      sendReq: true,
      getNseBseMap: true,
    );
  }

  int instId;
  var exch;
  var exchType;
  int scripCode;
  var symbol;
  var description;
  DateTime startDate;
  var sipPeriod;
  int qty;
  var value;
  DateTime expiryDate;
  DateTime nextTradeDate;
  var upperPriceLimit;
  var lowerPriceLimit;
  int buyPlacedQty;
  int buyRejectedQty;
  int buyExchTradedQty;
  int buyExchRejectedQty;
  int buyExchPendingQty;
  var buyExchTradedRate;
  var instructionState;
  ScripInfoModel model;

  factory GetSipList.fromJson(Map<String, dynamic> json) =>
      GetSipList(
    instId: json["InstID"],
    exch: json["Exch"],
    exchType: json["ExchType"],
    scripCode: json["ScripCode"],
    symbol: json["Symbol"],
    description: json["Description"],
    startDate: DateTime.parse(json["StartDate"]),
    sipPeriod: json["SIPPeriod"],
    qty: json["Qty"],
    value: json["Value"],
    expiryDate: DateTime.parse(json["ExpiryDate"]),
    nextTradeDate: DateTime.parse(json["NextTradeDate"]),
    upperPriceLimit: json["UpperPriceLimit"],
    lowerPriceLimit: json["LowerPriceLimit"],
    buyPlacedQty: json["BuyPlacedQty"],
    buyRejectedQty: json["BuyRejectedQty"],
    buyExchTradedQty: json["BuyExchTradedQty"],
    buyExchRejectedQty: json["BuyExchRejectedQty"],
    buyExchPendingQty: json["BuyExchPendingQty"],
    buyExchTradedRate: json["BuyExchTradedRate"],
    instructionState: json["InstructionState"],
  );

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "Exch": exch,
    "ExchType": exchType,
    "ScripCode": scripCode,
    "Symbol": symbol,
    "Description": description,
    "StartDate": startDate.toIso8601String(),
    "SIPPeriod": sipPeriod,
    "Qty": qty,
    "Value": value,
    "ExpiryDate": expiryDate.toIso8601String(),
    "NextTradeDate": nextTradeDate.toIso8601String(),
    "UpperPriceLimit": upperPriceLimit,
    "LowerPriceLimit": lowerPriceLimit,
    "BuyPlacedQty": buyPlacedQty,
    "BuyRejectedQty": buyRejectedQty,
    "BuyExchTradedQty": buyExchTradedQty,
    "BuyExchRejectedQty": buyExchRejectedQty,
    "BuyExchPendingQty": buyExchPendingQty,
    "BuyExchTradedRate": buyExchTradedRate,
    "InstructionState": instructionState,
  };
}
