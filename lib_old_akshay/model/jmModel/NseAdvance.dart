// To parse this JSON data, do
//
//     final nseAdvance = nseAdvanceFromJson(jsonString);

import 'dart:convert';

NseAdvance nseAdvanceFromJson(String str) => NseAdvance.fromJson(json.decode(str));

String nseAdvanceToJson(NseAdvance data) => json.encode(data.toJson());

class NseAdvance {
  NseAdvance({
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

  factory NseAdvance.fromJson(Map<String, dynamic> json) => NseAdvance(
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
  ScGroup scGroup;
  DateTime updTime;
  StkExchng stkExchng;
  double closePrice;
  double prevClose;
  double perchg;
  double netchg;
  int volTraded;
  String lname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    scCode: json["sc_code"],
    coCode: json["co_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    scGroup: scGroupValues.map[json["sc_group"]],
    updTime: DateTime.parse(json["upd_Time"]),
    stkExchng: stkExchngValues.map[json["stk_exchng"]],
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
    "sc_group": scGroupValues.reverse[scGroup],
    "upd_Time": updTime.toIso8601String(),
    "stk_exchng": stkExchngValues.reverse[stkExchng],
    "ClosePrice": closePrice,
    "PrevClose": prevClose,
    "perchg": perchg,
    "netchg": netchg,
    "vol_traded": volTraded,
    "lname": lname,
  };
}

enum ScGroup { A }

final scGroupValues = EnumValues({
  "A": ScGroup.A
});

enum StkExchng { NSE }

final stkExchngValues = EnumValues({
  "NSE": StkExchng.NSE
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
