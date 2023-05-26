// To parse this JSON data, do
//
//     final shareHolding = shareHoldingFromJson(jsonString);

import 'dart:convert';

ShareHolding shareHoldingFromJson(String str) => ShareHolding.fromJson(json.decode(str));

String shareHoldingToJson(ShareHolding data) => json.encode(data.toJson());

class ShareHolding {
  ShareHolding({
    this.success,
    this.data,
    this.status,
    this.message,
    this.responsecode,
  });

  bool success;
  List<Map<String, dynamic>> data;
  String status;
  String message;
  String responsecode;

  factory ShareHolding.fromJson(Map<String, dynamic> json) => ShareHolding(
    success: json["success"],
    data: List<Map<String, dynamic>>.from(json["data"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    status: json["status"],
    message: json["message"],
    responsecode: json["responsecode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    "status": status,
    "message": message,
    "responsecode": responsecode,
  };
}
