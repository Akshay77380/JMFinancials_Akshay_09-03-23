// To parse this JSON data, do
//
//     final topLosers = topLosersFromJson(jsonString);

import 'dart:convert';

TopLosers topLosersFromJson(String str) => TopLosers.fromJson(json.decode(str));

String topLosersToJson(TopLosers data) => json.encode(data.toJson());

class TopLosers {
  TopLosers({
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

  factory TopLosers.fromJson(Map<String, dynamic> json) => TopLosers(
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
    this.compLongName,
    this.updTime,
    this.closePrice,
    this.dayOpen,
    this.dayHigh,
    this.dayLow,
    this.bbuyQty,
    this.bbuyPrice,
    this.bsellQty,
    this.bsellPrice,
    this.prevClose,
    this.prevDate,
    this.perchg,
    this.netchg,
    this.volTraded,
    this.prevVolume,
    this.turnOver,
    this.prevTurnover,
    this.volumeavg,
    this.turnoveravg,
    this.hi52Wk,
    this.lo52Wk,
    this.h52Date,
    this.l52Date,
    this.bseSymbol,
  });

  StkExchng stkExchng;
  String scCode;
  double coCode;
  String symbol;
  String coName;
  String compLongName;
  DateTime updTime;
  double closePrice;
  double dayOpen;
  double dayHigh;
  double dayLow;
  double bbuyQty;
  double bbuyPrice;
  double bsellQty;
  double bsellPrice;
  double prevClose;
  DateTime prevDate;
  double perchg;
  double netchg;
  double volTraded;
  double prevVolume;
  double turnOver;
  double prevTurnover;
  double volumeavg;
  double turnoveravg;
  double hi52Wk;
  double lo52Wk;
  DateTime h52Date;
  DateTime l52Date;
  String bseSymbol;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    stkExchng: stkExchngValues.map[json["stk_exchng"]],
    scCode: json["sc_code"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    compLongName: json["CompLongName"],
    updTime: DateTime.parse(json["upd_time"]),
    closePrice: json["close_price"].toDouble(),
    dayOpen: json["DayOpen"].toDouble(),
    dayHigh: json["DayHigh"].toDouble(),
    dayLow: json["DayLow"].toDouble(),
    bbuyQty: json["bbuy_qty"],
    bbuyPrice: json["bbuy_price"],
    bsellQty: json["bsell_qty"],
    bsellPrice: json["bsell_price"],
    prevClose: json["PrevClose"].toDouble(),
    prevDate: DateTime.parse(json["PrevDate"]),
    perchg: json["perchg"].toDouble(),
    netchg: json["netchg"].toDouble(),
    volTraded: json["vol_traded"],
    prevVolume: json["PrevVolume"],
    turnOver: json["TurnOver"].toDouble(),
    prevTurnover: json["PrevTurnover"],
    volumeavg: json["volumeavg"].toDouble(),
    turnoveravg: json["turnoveravg"].toDouble(),
    hi52Wk: json["HI_52_WK"].toDouble(),
    lo52Wk: json["LO_52_WK"].toDouble(),
    h52Date: DateTime.parse(json["H52DATE"]),
    l52Date: DateTime.parse(json["L52DATE"]),
    bseSymbol: json["BSESymbol"],
  );

  Map<String, dynamic> toJson() => {
    "stk_exchng": stkExchngValues.reverse[stkExchng],
    "sc_code": scCode,
    "co_code": coCode,
    "symbol": symbol,
    "co_name": coName,
    "CompLongName": compLongName,
    "upd_time": updTime.toIso8601String(),
    "close_price": closePrice,
    "DayOpen": dayOpen,
    "DayHigh": dayHigh,
    "DayLow": dayLow,
    "bbuy_qty": bbuyQty,
    "bbuy_price": bbuyPrice,
    "bsell_qty": bsellQty,
    "bsell_price": bsellPrice,
    "PrevClose": prevClose,
    "PrevDate": prevDate.toIso8601String(),
    "perchg": perchg,
    "netchg": netchg,
    "vol_traded": volTraded,
    "PrevVolume": prevVolume,
    "TurnOver": turnOver,
    "PrevTurnover": prevTurnover,
    "volumeavg": volumeavg,
    "turnoveravg": turnoveravg,
    "HI_52_WK": hi52Wk,
    "LO_52_WK": lo52Wk,
    "H52DATE": h52Date.toIso8601String(),
    "L52DATE": l52Date.toIso8601String(),
    "BSESymbol": bseSymbol,
  };
}

enum StkExchng { BSE }

final stkExchngValues = EnumValues({
  "BSE": StkExchng.BSE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
