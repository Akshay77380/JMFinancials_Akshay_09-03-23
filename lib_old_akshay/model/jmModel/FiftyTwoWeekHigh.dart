// To parse this JSON data, do
//
//     final fiftyTwoWeekHigh = fiftyTwoWeekHighFromJson(jsonString);

import 'dart:convert';

FiftyTwoWeekHigh fiftyTwoWeekHighFromJson(String str) => FiftyTwoWeekHigh.fromJson(json.decode(str));

String fiftyTwoWeekHighToJson(FiftyTwoWeekHigh data) => json.encode(data.toJson());

class FiftyTwoWeekHigh {
  FiftyTwoWeekHigh({
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

  factory FiftyTwoWeekHigh.fromJson(Map<String, dynamic> json) => FiftyTwoWeekHigh(
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
    this.lname,
    this.coName,
    this.scCode,
    this.symbol,
    this.coCode,
    this.btdate,
    this.btprice,
    this.bthigh,
    this.btlow,
    this.btmcap,
    this.ntdate,
    this.ntprice,
    this.nthigh,
    this.ntlow,
    this.ntmcap,
    this.b52High,
    this.b52Hmcap,
    this.b52Hdate,
    this.b52Low,
    this.b52Lmcap,
    this.b52Ldate,
    this.n52High,
    this.n52Hmcap,
    this.n52Hdate,
    this.n52Low,
    this.n52Lmcap,
    this.n52Ldate,
    this.ballhigh,
    this.ballhdate,
    this.ballhmcap,
    this.balllow,
    this.balllmcap,
    this.ballldate,
    this.nallhigh,
    this.nallhmcap,
    this.nallhdate,
    this.nalllow,
    this.nalllmcap,
    this.nallldate,
    this.updTime,
    this.price,
    this.high,
    this.low,
    this.pChange,
    this.volume,
  });

  String lname;
  String coName;
  String scCode;
  String symbol;
  double coCode;
  DateTime btdate;
  double btprice;
  double bthigh;
  double btlow;
  double btmcap;
  DateTime ntdate;
  double ntprice;
  double nthigh;
  double ntlow;
  double ntmcap;
  double b52High;
  double b52Hmcap;
  DateTime b52Hdate;
  double b52Low;
  double b52Lmcap;
  DateTime b52Ldate;
  double n52High;
  double n52Hmcap;
  DateTime n52Hdate;
  double n52Low;
  double n52Lmcap;
  DateTime n52Ldate;
  double ballhigh;
  DateTime ballhdate;
  double ballhmcap;
  double balllow;
  double balllmcap;
  DateTime ballldate;
  double nallhigh;
  double nallhmcap;
  DateTime nallhdate;
  double nalllow;
  double nalllmcap;
  DateTime nallldate;
  DateTime updTime;
  double price;
  double high;
  double low;
  double pChange;
  int volume;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    lname: json["lname"],
    coName: json["Co_Name"],
    scCode: json["Sc_Code"],
    symbol: json["Symbol"],
    coCode: json["CO_CODE"],
    btdate: json["BTDATE"] == null ? null : DateTime.parse(json["BTDATE"]),
    btprice: json["BTPRICE"].toDouble(),
    bthigh: json["BTHIGH"].toDouble(),
    btlow: json["BTLOW"].toDouble(),
    btmcap: json["BTMCAP"].toDouble(),
    ntdate: DateTime.parse(json["NTDATE"]),
    ntprice: json["NTPRICE"].toDouble(),
    nthigh: json["NTHIGH"].toDouble(),
    ntlow: json["NTLOW"].toDouble(),
    ntmcap: json["NTMCAP"].toDouble(),
    b52High: json["B52HIGH"].toDouble(),
    b52Hmcap: json["B52HMCAP"].toDouble(),
    b52Hdate: json["B52HDATE"] == null ? null : DateTime.parse(json["B52HDATE"]),
    b52Low: json["B52LOW"].toDouble(),
    b52Lmcap: json["B52LMCAP"].toDouble(),
    b52Ldate: json["B52LDATE"] == null ? null : DateTime.parse(json["B52LDATE"]),
    n52High: json["N52HIGH"].toDouble(),
    n52Hmcap: json["N52HMCAP"].toDouble(),
    n52Hdate: DateTime.parse(json["N52HDATE"]),
    n52Low: json["N52LOW"].toDouble(),
    n52Lmcap: json["N52LMCAP"].toDouble(),
    n52Ldate: DateTime.parse(json["N52LDATE"]),
    ballhigh: json["BALLHIGH"].toDouble(),
    ballhdate: json["BALLHDATE"] == null ? null : DateTime.parse(json["BALLHDATE"]),
    ballhmcap: json["BALLHMCAP"].toDouble(),
    balllow: json["BALLLOW"].toDouble(),
    balllmcap: json["BALLLMCAP"].toDouble(),
    ballldate: json["BALLLDATE"] == null ? null : DateTime.parse(json["BALLLDATE"]),
    nallhigh: json["NALLHIGH"].toDouble(),
    nallhmcap: json["NALLHMCAP"].toDouble(),
    nallhdate: DateTime.parse(json["NALLHDATE"]),
    nalllow: json["NALLLOW"].toDouble(),
    nalllmcap: json["NALLLMCAP"].toDouble(),
    nallldate: DateTime.parse(json["NALLLDATE"]),
    updTime: DateTime.parse(json["Upd_Time"]),
    price: json["Price"].toDouble(),
    high: json["High"].toDouble(),
    low: json["Low"].toDouble(),
    pChange: json["pChange"].toDouble(),
    volume: json["Volume"],
  );

  Map<String, dynamic> toJson() => {
    "lname": lname,
    "Co_Name": coName,
    "Sc_Code": scCode,
    "Symbol": symbol,
    "CO_CODE": coCode,
    "BTDATE": btdate == null ? null : btdate.toIso8601String(),
    "BTPRICE": btprice,
    "BTHIGH": bthigh,
    "BTLOW": btlow,
    "BTMCAP": btmcap,
    "NTDATE": ntdate.toIso8601String(),
    "NTPRICE": ntprice,
    "NTHIGH": nthigh,
    "NTLOW": ntlow,
    "NTMCAP": ntmcap,
    "B52HIGH": b52High,
    "B52HMCAP": b52Hmcap,
    "B52HDATE": b52Hdate == null ? null : b52Hdate.toIso8601String(),
    "B52LOW": b52Low,
    "B52LMCAP": b52Lmcap,
    "B52LDATE": b52Ldate == null ? null : b52Ldate.toIso8601String(),
    "N52HIGH": n52High,
    "N52HMCAP": n52Hmcap,
    "N52HDATE": n52Hdate.toIso8601String(),
    "N52LOW": n52Low,
    "N52LMCAP": n52Lmcap,
    "N52LDATE": n52Ldate.toIso8601String(),
    "BALLHIGH": ballhigh,
    "BALLHDATE": ballhdate == null ? null : ballhdate.toIso8601String(),
    "BALLHMCAP": ballhmcap,
    "BALLLOW": balllow,
    "BALLLMCAP": balllmcap,
    "BALLLDATE": ballldate == null ? null : ballldate.toIso8601String(),
    "NALLHIGH": nallhigh,
    "NALLHMCAP": nallhmcap,
    "NALLHDATE": nallhdate.toIso8601String(),
    "NALLLOW": nalllow,
    "NALLLMCAP": nalllmcap,
    "NALLLDATE": nallldate.toIso8601String(),
    "Upd_Time": updTime.toIso8601String(),
    "Price": price,
    "High": high,
    "Low": low,
    "pChange": pChange,
    "Volume": volume,
  };
}
