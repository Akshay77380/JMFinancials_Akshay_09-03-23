// To parse this JSON data, do
//
//     final topPerformingIndustries = topPerformingIndustriesFromJson(jsonString);

import 'dart:convert';

TopPerformingIndustries topPerformingIndustriesFromJson(String str) => TopPerformingIndustries.fromJson(json.decode(str));

String topPerformingIndustriesToJson(TopPerformingIndustries data) => json.encode(data.toJson());

class TopPerformingIndustries {
  TopPerformingIndustries({
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

  factory TopPerformingIndustries.fromJson(Map<String, dynamic> json) => TopPerformingIndustries(
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
      this.sectorCode,
      this.sectorName,
      this.adv,
      this.dec,
      this.mcap,
      this.mcapPerChange,
      this.volumePerChange,
      this.deliveryPerChange,
      this.tradeDate,
  });

  String sectorCode;
  String sectorName;
  int adv;
  int dec;
  double mcap;
  double mcapPerChange;
  double volumePerChange;
  double deliveryPerChange;
  DateTime tradeDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sectorCode: json["SectorCode"],
    sectorName: json["SectorName"],
    adv: json["Adv"],
    dec: json["Dec"],
    mcap: json["MCAP"]?.toDouble(),
    mcapPerChange: json["MCAP_PerChange"]?.toDouble(),
    volumePerChange: json["Volume_PerChange"]?.toDouble(),
    deliveryPerChange: json["Delivery_PerChange"]?.toDouble(),
    tradeDate: DateTime.parse(json["TradeDate"]),
  );

  Map<String, dynamic> toJson() => {
    "SectorCode": sectorCode,
    "SectorName": sectorName,
    "Adv": adv,
    "Dec": dec,
    "MCAP": mcap,
    "MCAP_PerChange": mcapPerChange,
    "Volume_PerChange": volumePerChange,
    "Delivery_PerChange": deliveryPerChange,
    "TradeDate": tradeDate.toIso8601String(),
  };
}
