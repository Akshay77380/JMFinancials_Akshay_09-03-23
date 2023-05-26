// To parse this JSON data, do
//
//     final mostActiveTurnOver = mostActiveTurnOverFromJson(jsonString);

import 'dart:convert';

MostActiveTurnOver mostActiveTurnOverFromJson(String str) => MostActiveTurnOver.fromJson(json.decode(str));

String mostActiveTurnOverToJson(MostActiveTurnOver data) => json.encode(data.toJson());

class MostActiveTurnOver {
  MostActiveTurnOver({
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

  factory MostActiveTurnOver.fromJson(Map<String, dynamic> json) => MostActiveTurnOver(
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
    this.stkExchng,
    this.scCode,
    this.coCode,
    this.symbol,
    this.coName,
    this.scGroup,
    this.updTime,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.closePrice,
    this.bBuyQty,
    this.bBuyPrice,
    this.bSellQty,
    this.bSellPrice,
    this.prevClose,
    this.volTraded,
    this.perVol,
    this.perchg,
    this.netchg,
    this.valTraded,
    this.the52WeekHigh,
    this.the52WeekLow,
    this.prevVolTraded,
    this.prevValueTraded,
    this.offerPrice,
    this.offerQty,
    this.lname,
  });

  String stkExchng;
  String scCode;
  double coCode;
  String symbol;
  String coName;
  String scGroup;
  DateTime updTime;
  double openPrice;
  double highPrice;
  double lowPrice;
  double closePrice;
  int bBuyQty;
  double bBuyPrice;
  int bSellQty;
  double bSellPrice;
  double prevClose;
  int volTraded;
  double perVol;
  double perchg;
  double netchg;
  double valTraded;
  double the52WeekHigh;
  double the52WeekLow;
  double prevVolTraded;
  double prevValueTraded;
  dynamic offerPrice;
  dynamic offerQty;
  String lname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    stkExchng: json["stk_exchng"],
    scCode: json["sc_code"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    scGroup: json["sc_group"],
    updTime: DateTime.parse(json["Upd_Time"]),
    openPrice: json["Open_Price"].toDouble(),
    highPrice: json["high_price"].toDouble(),
    lowPrice: json["low_price"].toDouble(),
    closePrice: json["close_price"].toDouble(),
    bBuyQty: json["BBuy_Qty"],
    bBuyPrice: json["BBuy_Price"].toDouble(),
    bSellQty: json["BSell_Qty"],
    bSellPrice: json["BSell_Price"].toDouble(),
    prevClose: json["PrevClose"].toDouble(),
    volTraded: json["vol_traded"],
    perVol: json["perVol"].toDouble(),
    perchg: json["perchg"].toDouble(),
    netchg: json["netchg"].toDouble(),
    valTraded: json["val_traded"].toDouble(),
    the52WeekHigh: json["52WeekHigh"].toDouble(),
    the52WeekLow: json["52WeekLow"].toDouble(),
    prevVolTraded: json["prev_vol_traded"],
    prevValueTraded: json["Prev_value_traded"].toDouble(),
    offerPrice: json["OfferPrice"],
    offerQty: json["OfferQty"],
    lname: json["lname"],
  );

  Map<String, dynamic> toJson() => {
    "stk_exchng": stkExchng,
    "sc_code": scCode,
    "co_code": coCode,
    "symbol": symbol,
    "co_name": coName,
    "sc_group": scGroup,
    "Upd_Time": updTime.toIso8601String(),
    "Open_Price": openPrice,
    "high_price": highPrice,
    "low_price": lowPrice,
    "close_price": closePrice,
    "BBuy_Qty": bBuyQty,
    "BBuy_Price": bBuyPrice,
    "BSell_Qty": bSellQty,
    "BSell_Price": bSellPrice,
    "PrevClose": prevClose,
    "vol_traded": volTraded,
    "perVol": perVol,
    "perchg": perchg,
    "netchg": netchg,
    "val_traded": valTraded,
    "52WeekHigh": the52WeekHigh,
    "52WeekLow": the52WeekLow,
    "prev_vol_traded": prevVolTraded,
    "Prev_value_traded": prevValueTraded,
    "OfferPrice": offerPrice,
    "OfferQty": offerQty,
    "lname": lname,
  };
}
