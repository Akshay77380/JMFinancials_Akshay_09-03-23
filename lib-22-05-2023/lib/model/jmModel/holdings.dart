// To parse this JSON data, do
//
//     final holdings = holdingsFromJson(jsonString);

import 'dart:convert';

import '../../util/CommonFunctions.dart';
import '../scrip_info_model.dart';

Holdings holdingsFromJson(String str) => Holdings.fromJson(json.decode(str));

String holdingsToJson(Holdings data) => json.encode(data.toJson());

class Holdings {
  Holdings({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  List<HoldingDatum> data;

  factory Holdings.fromJson(Map<String, dynamic> json) => Holdings(
        status: json["status"],
        message: json["message"],
        errorcode: json["errorcode"],
        data: List<HoldingDatum>.from(json["data"].map((x) => HoldingDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HoldingDatum {
  HoldingDatum({
    this.tradingSymbol,
    this.symboltoken,
    this.exchange,
    this.isin,
    this.t1Quantity,
    this.realisedquantity,
    this.quantity,
    this.authorisedquantity,
    this.profitandloss,
    this.product,
    this.collateralquantity,
    this.collateraltype,
    this.haircut,
    this.model,
  }) {
    model = CommonFunction.getScripDataModel(
      exch: exchange == 'BSE'
          ? 'B'
          : exchange == 'MCX'
              ? 'M'
              : exchange == 'CDS'
                  ? 'C'
                  : exchange == 'BCD'
                      ? 'E'
                      : 'N',
      exchCode: int.parse(symboltoken),
      sendReq: true,
      getNseBseMap: true,
    );
  }

  String tradingSymbol;
  String symboltoken;
  String exchange;
  String isin;
  String t1Quantity;
  String realisedquantity;
  String quantity;
  String authorisedquantity;
  String profitandloss;
  String product;
  String collateralquantity;
  String collateraltype;
  String haircut;
  ScripInfoModel model;

  factory HoldingDatum.fromJson(Map<String, dynamic> json) => HoldingDatum(
        tradingSymbol: json["tradingSymbol"],
        symboltoken: json['symboltoken'],
        exchange: json["exchange"],
        isin: json["isin"],
        t1Quantity: json["t1quantity"],
        realisedquantity: json["realisedquantity"],
        quantity: json["quantity"],
        authorisedquantity: json["authorisedquantity"],
        profitandloss: json["profitandloss"],
        product: json["product"],
        collateralquantity: json["collateralquantity"],
        collateraltype: json["collateraltype"],
        haircut: json["haircut"],
      );

  Map<String, dynamic> toJson() => {
        "tradingSymbol": tradingSymbol,
        "symboltoken": symboltoken,
        "exchange": exchange,
        "isin": isin,
        "t1quantity": t1Quantity,
        "realisedquantity": realisedquantity,
        "quantity": quantity,
        "authorisedquantity": authorisedquantity,
        "profitandloss": profitandloss,
        "product": product,
        "collateralquantity": collateralquantity,
        "collateraltype": collateraltype,
        "haircut": haircut,
      };
}
