import 'dart:convert';

CandleEntity candleEntityFromJson(String str) =>
    CandleEntity.fromJson(json.decode(str));

String candleEntityToJson(CandleEntity data) => json.encode(data.toJson());

class CandleEntity {
  CandleEntity(
      {this.s,
    this.r,
    this.t,
    this.o,
    this.h,
    this.l,
    this.c,
    this.v,
      this.trades,
      this.value});

  String s;
  int r;
  List<int> t;
  List<double> o;
  List<double> h;
  List<double> l;
  List<double> c;
  List<double> v;
  List<int> trades;
  List<double> value;

  factory CandleEntity.fromJson(Map<String, dynamic> json) => CandleEntity(
        s: json["s"],
        r: json["r"],
        t: List<int>.from(json["t"].map((x) => x)),
        o: List<double>.from(json["o"].map((x) => x.toDouble())),
        h: List<double>.from(json["h"].map((x) => x.toDouble())),
        l: List<double>.from(json["l"].map((x) => x.toDouble())),
        c: List<double>.from(json["c"].map((x) => x.toDouble())),
        v: List<double>.from(json["v"].map((x) => x)),
        trades: List<int>.from(json["tr"].map((x) => x)),
        value: List<double>.from(json["u"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "s": s,
        "r": r,
        "t": List<dynamic>.from(t.map((x) => x)),
        "o": List<dynamic>.from(o.map((x) => x)),
        "h": List<dynamic>.from(h.map((x) => x)),
        "l": List<dynamic>.from(l.map((x) => x)),
        "c": List<dynamic>.from(c.map((x) => x)),
        "v": List<dynamic>.from(v.map((x) => x)),
      };
}
