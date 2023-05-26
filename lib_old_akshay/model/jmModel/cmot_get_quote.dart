// To parse this JSON data, do
//
//     final getQuoteDetails = getQuoteDetailsFromJson(jsonString);

import 'dart:convert';

GetQuoteDetails getQuoteDetailsFromJson(String str) => GetQuoteDetails.fromJson(json.decode(str));

String getQuoteDetailsToJson(GetQuoteDetails data) => json.encode(data.toJson());

class GetQuoteDetails {
  GetQuoteDetails({
    this.success,
    this.data,
    this.status,
    this.message,
    this.responsecode,
  });

  bool success;
  List<Datum> data;
  String status;
  String message;
  String responsecode;

  factory GetQuoteDetails.fromJson(Map<String, dynamic> json) => GetQuoteDetails(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    status: json["status"],
    message: json["message"],
    responsecode: json["responsecode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "message": message,
    "responsecode": responsecode,
  };
}

class Datum {
  Datum({
    this.xchng,
    this.updTime,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.price,
    this.bbuyQty,
    this.bbuyPrice,
    this.bsellQty,
    this.bsellPrice,
    this.value,
    this.oldPrice,
    this.pricediff,
    this.change,
    this.trdQty,
    this.volume,
    this.hi52Wk,
    this.lo52Wk,
    this.h52Date,
    this.l52Date,
    this.trdValue,
    this.scGroup,
    this.compLname,
    this.scCode,
    this.listInfo,
    this.b52HighAdj,
    this.b52LowAdj,
    this.isin,
    this.symbol,
    this.week1High,
    this.week1Low,
    this.month1High,
    this.month1Low,
  });

  String xchng;
  DateTime updTime;
  double openPrice;
  double highPrice;
  double lowPrice;
  double price;
  double bbuyQty;
  double bbuyPrice;
  double bsellQty;
  double bsellPrice;
  double value;
  double oldPrice;
  double pricediff;
  double change;
  double trdQty;
  double volume;
  double hi52Wk;
  double lo52Wk;
  DateTime h52Date;
  DateTime l52Date;
  double trdValue;
  String scGroup;
  String compLname;
  String scCode;
  String listInfo;
  double b52HighAdj;
  double b52LowAdj;
  String isin;
  String symbol;
  double week1High;
  double week1Low;
  double month1High;
  double month1Low;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    xchng: json["XCHNG"].toString(),
    updTime: DateTime.parse(json["Upd_Time"]),
    openPrice: double.parse(json["Open_Price"].toString()),
    highPrice: double.parse(json["High_Price"].toString()),
    lowPrice: double.parse(json["Low_Price"].toString()),
    price: double.parse(json["price"].toString()),
    bbuyQty: double.parse(json["bbuy_qty"].toString()),
    bbuyPrice: double.parse(json["bbuy_price"].toString()),
    bsellQty: double.parse(json["bsell_qty"].toString()),
    bsellPrice: double.parse(json["bsell_price"].toString()),
    value: double.parse(json["Value"].toString()),
    oldPrice: double.parse(json["OldPrice"].toString()),
    pricediff: double.parse(json["Pricediff"].toString()),
    change: double.parse(json["change"].toString()),
    trdQty: double.parse(json["Trd_Qty"].toString()),
    volume: double.parse(json["Volume"].toString()),
    hi52Wk: double.parse(json["HI_52_WK"].toString()),
    lo52Wk: double.parse(json["LO_52_WK"].toString()),
    h52Date: DateTime.parse(json["H52DATE"]),
    l52Date: DateTime.parse(json["L52DATE"]),
    trdValue: double.parse(json["Trd_Value"].toString()),
    scGroup: json["sc_group"].toString(),
    compLname: json["CompLname"].toString(),
    scCode: json["Sc_code"].toString(),
    listInfo: json["ListInfo"].toString(),
    b52HighAdj: double.parse(json["B52HighAdj"].toString()),
    b52LowAdj: double.parse(json["b52LowAdj"].toString()),
    isin: json["isin"].toString(),
    symbol: json["symbol"].toString(),
    week1High: double.parse(json["Week1High"].toString()),
    week1Low: double.parse(json["Week1Low"].toString()),
    month1High: double.parse(json["Month1High"].toString()),
    month1Low: double.parse(json["Month1Low"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "XCHNG": xchng,
    "Upd_Time": updTime.toIso8601String(),
    "Open_Price": openPrice,
    "High_Price": highPrice,
    "Low_Price": lowPrice,
    "price": price,
    "bbuy_qty": bbuyQty,
    "bbuy_price": bbuyPrice,
    "bsell_qty": bsellQty,
    "bsell_price": bsellPrice,
    "Value": value,
    "OldPrice": oldPrice,
    "Pricediff": pricediff,
    "change": change,
    "Trd_Qty": trdQty,
    "Volume": volume,
    "HI_52_WK": hi52Wk,
    "LO_52_WK": lo52Wk,
    "H52DATE": h52Date.toIso8601String(),
    "L52DATE": l52Date.toIso8601String(),
    "Trd_Value": trdValue,
    "sc_group": scGroup,
    "CompLname": compLname,
    "Sc_code": scCode,
    "ListInfo": listInfo,
    "B52HighAdj": b52HighAdj,
    "b52LowAdj": b52LowAdj,
    "isin": isin,
    "symbol": symbol,
    "Week1High": week1High,
    "Week1Low": week1Low,
    "Month1High": month1High,
    "Month1Low": month1Low,
  };
}

