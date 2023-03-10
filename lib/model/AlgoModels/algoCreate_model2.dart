// To parse this JSON data, do
//
//     final createAlgo = createAlgoFromJson(jsonString);

import 'dart:convert';

CreateAlgoModel createAlgoFromJson(String str) => CreateAlgoModel.fromJson(json.decode(str));

String createAlgoToJson(CreateAlgoModel data) => json.encode(data.toJson());

class CreateAlgoModel {
  CreateAlgoModel({
    this.statusCode,
    this.status,
    this.data,
  });

  int statusCode;
  String status;
  Data data;

  factory CreateAlgoModel.fromJson(Map<String, dynamic> json) => CreateAlgoModel(
    statusCode: json["StatusCode"],
    status: json["Status"],
    data: Data.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "StatusCode": statusCode,
    "Status": status,
    "Data": data.toJson(),
  };
}

class Data {
  Data({
    this.instId,
    this.message,
  });

  int instId;
  String message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    instId: json["InstID"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "Message": message,
  };
}
