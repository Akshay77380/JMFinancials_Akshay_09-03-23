// To parse this JSON data, do
//
//     final brokerage = brokerageFromJson(jsonString);

import 'dart:convert';

Brokerage brokerageFromJson(String str) => Brokerage.fromJson(json.decode(str));

String brokerageToJson(Brokerage data) => json.encode(data.toJson());

class Brokerage {
  Brokerage({
      this.status,
      this.message,
      this.errorcode,
    this.emsg,
      this.data,
  });

  bool status;
  String message;
  String errorcode;
  dynamic emsg;
  Data data;

  factory Brokerage.fromJson(Map<String, dynamic> json) => Brokerage(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
      this.clientcode,
      this.transactionType,
      this.exchange,
      this.segment,
      this.instrument,
      this.symbol,
      this.expiryDate,
      this.optiontype,
      this.strikePrice,
      this.product,
      this.isin,
      this.bseSymbol,
      this.series,
      this.quantity,
      this.price,
      this.orderValue,
      this.brokerage,
      this.gst,
      this.sttCtt,
      this.transCharge,
      this.sebiFees,
      this.stampDuty,
  });

  String clientcode;
  String transactionType;
  String exchange;
  String segment;
  String instrument;
  String symbol;
  String expiryDate;
  String optiontype;
  double strikePrice;
  String product;
  String isin;
  String bseSymbol;
  String series;
  int quantity;
  double price;
  double orderValue;
  String brokerage;
  String gst;
  String sttCtt;
  String transCharge;
  String sebiFees;
  String stampDuty;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    clientcode: json["Clientcode"],
    transactionType: json["TransactionType"],
    exchange: json["Exchange"],
    segment: json["Segment"],
    instrument: json["Instrument"],
    symbol: json["Symbol"],
    expiryDate: json["ExpiryDate"],
    optiontype: json["Optiontype"],
    strikePrice: json["StrikePrice"],
    product: json["Product"],
    isin: json["ISIN"],
    bseSymbol: json["BSESymbol"],
    series: json["Series"],
    quantity: json["Quantity"],
    price: json["Price"]?.toDouble(),
    orderValue: json["OrderValue"],
    brokerage: json["Brokerage"],
    gst: json["GST"],
    sttCtt: json["STT_CTT"],
    transCharge: json["Trans_Charge"],
    sebiFees: json["SEBI_Fees"],
    stampDuty: json["Stamp_Duty"],
  );

  Map<String, dynamic> toJson() => {
    "Clientcode": clientcode,
    "TransactionType": transactionType,
    "Exchange": exchange,
    "Segment": segment,
    "Instrument": instrument,
    "Symbol": symbol,
    "ExpiryDate": expiryDate,
    "Optiontype": optiontype,
    "StrikePrice": strikePrice,
    "Product": product,
    "ISIN": isin,
    "BSESymbol": bseSymbol,
    "Series": series,
    "Quantity": quantity,
    "Price": price,
    "OrderValue": orderValue,
    "Brokerage": brokerage,
    "GST": gst,
    "STT_CTT": sttCtt,
    "Trans_Charge": transCharge,
    "SEBI_Fees": sebiFees,
    "Stamp_Duty": stampDuty,
  };
}
