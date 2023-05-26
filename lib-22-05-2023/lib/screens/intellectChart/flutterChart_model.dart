// To parse this JSON data, do
//
//     final flutterChart = flutterChartFromJson(jsonString);

import 'dart:convert';

FlutterChart flutterChartFromJson(String str) => FlutterChart.fromJson(json.decode(str));

String flutterChartToJson(FlutterChart data) => json.encode(data.toJson());

class FlutterChart {
  FlutterChart({
    this.s,
    this.t,
    this.o,
    this.h,
    this.l,
    this.c,
    this.v,
  });

  String s;
  List<int> t;
  List<double> o;
  List<double> h;
  List<double> l;
  List<double> c;
  List<int> v;

  factory FlutterChart.fromJson(Map<String, dynamic> json) => FlutterChart(
    s: json["s"],
    t: List<int>.from(json["t"].map((x) => x)),
    o: List<double>.from(json["o"].map((x) => x.toDouble())),
    h: List<double>.from(json["h"].map((x) => x.toDouble())),
    l: List<double>.from(json["l"].map((x) => x.toDouble())),
    c: List<double>.from(json["c"].map((x) => x.toDouble())),
    v: List<int>.from(json["v"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "s": s,
    "t": List<dynamic>.from(t.map((x) => x)),
    "o": List<dynamic>.from(o.map((x) => x)),
    "h": List<dynamic>.from(h.map((x) => x)),
    "l": List<dynamic>.from(l.map((x) => x)),
    "c": List<dynamic>.from(c.map((x) => x)),
    "v": List<dynamic>.from(v.map((x) => x)),
  };
}
