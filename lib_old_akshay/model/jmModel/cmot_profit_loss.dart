// To parse this JSON data, do
//
//     final profitAndLoss = profitAndLossFromJson(jsonString);

import 'dart:convert';

ProfitAndLoss profitAndLossFromJson(String str) => ProfitAndLoss.fromJson(json.decode(str));

String profitAndLossToJson(ProfitAndLoss data) => json.encode(data.toJson());

class ProfitAndLoss {
  ProfitAndLoss({
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

  factory ProfitAndLoss.fromJson(Map<String, dynamic> json) => ProfitAndLoss(
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
    this.columnname,
    this.rid,
    this.y202112,
    this.y202012,
    this.y201912,
    this.y201812,
    this.y201712,
    this.rowno,
    this.colorfield,
    this.fontfield,
    this.shortdispname,
  });

  String columnname;
  int rid;
  double y202112;
  double y202012;
  double y201912;
  double y201812;
  double y201712;
  int rowno;
  Colorfield colorfield;
  Fontfield fontfield;
  String shortdispname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    columnname: json["COLUMNNAME"],
    rid: json["RID"],
    y202112: json["Y202112"].toDouble(),
    y202012: json["Y202012"].toDouble(),
    y201912: json["Y201912"].toDouble(),
    y201812: json["Y201812"].toDouble(),
    y201712: json["Y201712"].toDouble(),
    rowno: json["rowno"],
    colorfield: colorfieldValues.map[json["colorfield"]],
    fontfield: fontfieldValues.map[json["fontfield"]],
    shortdispname: json["shortdispname"] == null ? null : json["shortdispname"],
  );

  Map<String, dynamic> toJson() => {
    "COLUMNNAME": columnname,
    "RID": rid,
    "Y202112": y202112,
    "Y202012": y202012,
    "Y201912": y201912,
    "Y201812": y201812,
    "Y201712": y201712,
    "rowno": rowno,
    "colorfield": colorfieldValues.reverse[colorfield],
    "fontfield": fontfieldValues.reverse[fontfield],
    "shortdispname": shortdispname == null ? null : shortdispname,
  };
}

enum Colorfield { HEADERCOLOR, SUBHEADING }

final colorfieldValues = EnumValues({
  "Headercolor": Colorfield.HEADERCOLOR,
  "subheading": Colorfield.SUBHEADING
});

enum Fontfield { HEADERFONT, DATAFONT, LESSSUBTOTALFONT, TOTAL_FONT }

final fontfieldValues = EnumValues({
  "datafont": Fontfield.DATAFONT,
  "Headerfont": Fontfield.HEADERFONT,
  "lesssubtotalfont": Fontfield.LESSSUBTOTALFONT,
  "TotalFont": Fontfield.TOTAL_FONT
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
