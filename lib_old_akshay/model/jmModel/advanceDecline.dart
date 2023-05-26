// To parse this JSON data, do
//
//     final advancesDeclines = advancesDeclinesFromJson(jsonString);

import 'dart:convert';

AdvancesDeclines advancesDeclinesFromJson(String str) => AdvancesDeclines.fromJson(json.decode(str));

String advancesDeclinesToJson(AdvancesDeclines data) => json.encode(data.toJson());

class AdvancesDeclines {
  AdvancesDeclines({
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

  factory AdvancesDeclines.fromJson(Map<String, dynamic> json) => AdvancesDeclines(
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
      this.scCode,
      this.coCode,
      this.symbol,
      this.coName,
      this.scGroup,
      this.updTime,
      this.stkExchng,
      this.closePrice,
      this.prevClose,
      this.perchg,
      this.netchg,
      this.volTraded,
      this.lname,
  });

  String scCode;
  double coCode;
  String symbol;
  String coName;
  String scGroup;
  DateTime updTime;
  String stkExchng;
  double closePrice;
  double prevClose;
  double perchg;
  double netchg;
  double volTraded;
  String lname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    scCode: json["sc_code"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    scGroup: json["sc_group"],
    updTime: DateTime.parse(json["upd_time"]),
    stkExchng: json["stk_exchng"],
    closePrice: json["ClosePrice"]?.toDouble(),
    prevClose: json["PrevClose"]?.toDouble(),
    perchg: json["perchg"]?.toDouble(),
    netchg: json["netchg"]?.toDouble(),
    volTraded: json["vol_traded"],
    lname: json["lname"],
  );

  Map<String, dynamic> toJson() => {
    "sc_code": scCode,
    "co_code": coCode,
    "symbol": symbol,
    "co_name": coName,
    "sc_group": scGroup,
    "upd_time": updTime.toIso8601String(),
    "stk_exchng": stkExchng,
    "ClosePrice": closePrice,
    "PrevClose": prevClose,
    "perchg": perchg,
    "netchg": netchg,
    "vol_traded": volTraded,
    "lname": lname,
  };
}
