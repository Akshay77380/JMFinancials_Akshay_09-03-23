// To parse this JSON data, do
//
//     final tradeBook = tradeBookFromJson(jsonString);

import 'dart:convert';

import '../../util/CommonFunctions.dart';
import '../scrip_info_model.dart';

TradeBook tradeBookFromJson(String str) => TradeBook.fromJson(json.decode(str));

String tradeBookToJson(TradeBook data) => json.encode(data.toJson());

class TradeBook {
  TradeBook({
    this.status,
    this.message,
    this.errorCode,
    this.data,
  });

  bool status;
  String message;
  String errorCode;
  List<tradebookDatum> data;

  factory TradeBook.fromJson(Map<String, dynamic> json) => TradeBook(
        status: json["status"],
        message: json["message"],
        errorCode: json["error_code"],
        data: List<tradebookDatum>.from(json["data"].map((x) => tradebookDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error_code": errorCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class tradebookDatum {
  tradebookDatum(
      {this.exchange,
      this.producttype,
      this.tradingsymbol,
      this.instrumenttype,
      this.symboltoken,
      this.symbolgroup,
      this.strikeprice,
      this.optiontype,
      this.expirydate,
      this.marketlot,
      this.precision,
      this.multiplier,
      this.tradevalue,
      this.transactiontype,
      this.fillprice,
      this.fillsize,
      this.orderid,
      this.exchorderid,
      this.fillid,
      this.filltime,
      this.quantity,
      this.model}) {
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

  String exchange;
  String producttype;
  String tradingsymbol;
  String instrumenttype;
  String symboltoken;
  String symbolgroup;
  String strikeprice;
  String optiontype;
  String expirydate;
  String marketlot;
  String precision;
  String multiplier;
  String tradevalue;
  String transactiontype;
  String fillprice;
  String fillsize;
  String orderid;
  String exchorderid;
  String fillid;
  String filltime;
  int quantity;
  ScripInfoModel model;

  factory tradebookDatum.fromJson(Map<String, dynamic> json) => tradebookDatum(
        exchange: json["exchange"],
        producttype: json["producttype"] == 'CARRYFORWARD' || json["producttype"] == 'NRML'
            ? 'NRML'
            : json["producttype"] == 'DELIVERY' || json["producttype"] == 'CNC'
                ? 'CNC'
                : json["producttype"] == 'INTRADAY' || json["producttype"] == 'MIS'
                    ? 'MIS'
                    : json["producttype"] == 'CO' || json["producttype"] == 'COVER'
                        ? 'COVER'
                        : json["producttype"] == 'BO' || json["producttype"] == 'BRACKET'
                            ? 'BRACKET'
                            : json["producttype"] == 'MTF'
                                ? 'MTF'
                                : '',
        tradingsymbol: json["tradingsymbol"],
        instrumenttype: json["instrumenttype"],
        symboltoken: json["symboltoken"],
        symbolgroup: json["symbolgroup"],
        strikeprice: json["strikeprice"],
        optiontype: json["optiontype"],
        expirydate: json["expirydate"],
        marketlot: json["marketlot"],
        precision: json["precision"],
        multiplier: json["multiplier"],
        tradevalue: json["tradevalue"],
        transactiontype: json["transactiontype"],
        fillprice: json["fillprice"],
        fillsize: json["fillsize"],
        orderid: json["orderid"],
        exchorderid: json["exchorderid"],
        fillid: json["fillid"],
        filltime: json["filltime"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "producttype": producttype,
        "tradingsymbol": tradingsymbol,
        "instrumenttype": instrumenttype,
        "symboltoken": symboltoken,
        "symbolgroup": symbolgroup,
        "strikeprice": strikeprice,
        "optiontype": optiontype,
        "expirydate": expirydate,
        "marketlot": marketlot,
        "precision": precision,
        "multiplier": multiplier,
        "tradevalue": tradevalue,
        "transactiontype": transactiontype,
        "fillprice": fillprice,
        "fillsize": fillsize,
        "orderid": orderid,
        "exchorderid": exchorderid,
        "fillid": fillid,
        "filltime": filltime,
        "quantity": quantity,
      };
}
