// To parse this JSON data, do
//
//     final checkMarketModel = checkMarketModelFromJson(jsonString);

import 'dart:convert';

CheckMarketModel checkMarketModelFromJson(String str) => CheckMarketModel.fromJson(json.decode(str));

String checkMarketModelToJson(CheckMarketModel data) => json.encode(data.toJson());

class CheckMarketModel {
  CheckMarketModel({
     this.status,
     this.message,
     this.note,
  });

  String status;
  String message;
  List<String> note;

  factory CheckMarketModel.fromJson(Map<String, dynamic> json) => CheckMarketModel(
    status: json["status"],
    message: json["message"],
    note: List<String>.from(json["note"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "note": List<dynamic>.from(note.map((x) => x)),
  };
}
