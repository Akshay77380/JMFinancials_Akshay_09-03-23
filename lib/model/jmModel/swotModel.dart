// To parse this JSON data, do
//
//     final swotModel = swotModelFromJson(jsonString);

import 'dart:convert';

SwotModel swotModelFromJson(String str) => SwotModel.fromJson(json.decode(str));

String swotModelToJson(SwotModel data) => json.encode(data.toJson());

class SwotModel {
  bool status;
  String message;
  String errorcode;
  String emsg;
  Data data;

  SwotModel({
      this.status,
      this.message,
      this.errorcode,
      this.emsg,
      this.data,
  });

  factory SwotModel.fromJson(Map<String, dynamic> json) => SwotModel(
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
  List<String> strengths;
  List<String> weaknesses;
  List<String> opportunities;
  List<String> threats;
  List<Count> counts;

  Data({
      this.strengths,
      this.weaknesses,
      this.opportunities,
      this.threats,
      this.counts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    strengths: List<String>.from(json["strengths"].map((x) => x)),
    weaknesses: List<String>.from(json["weaknesses"].map((x) => x)),
    opportunities: List<String>.from(json["opportunities"].map((x) => x)),
    threats: List<String>.from(json["threats"].map((x) => x)),
    counts: List<Count>.from(json["counts"].map((x) => Count.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "strengths": List<dynamic>.from(strengths.map((x) => x)),
    "weaknesses": List<dynamic>.from(weaknesses.map((x) => x)),
    "opportunities": List<dynamic>.from(opportunities.map((x) => x)),
    "threats": List<dynamic>.from(threats.map((x) => x)),
    "counts": List<dynamic>.from(counts.map((x) => x.toJson())),
  };
}

class Count {
  String name;
  int count;

  Count({
      this.name,
      this.count,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    name: json["name"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "count": count,
  };
}
