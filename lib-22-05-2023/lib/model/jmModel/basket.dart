// To parse this JSON data, do
//
//     final basketData = basketDataFromJson(jsonString);

import 'dart:convert';

BasketData basketDataFromJson(String str) =>
    BasketData.fromJson(json.decode(str));

String basketDataToJson(BasketData data) => json.encode(data.toJson());

class BasketData {
  BasketData({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  List<BasketDatum> data;

  factory BasketData.fromJson(Map<String, dynamic> json) => BasketData(
        status: json["status"],
        message: json["message"],
        errorcode: json["errorcode"],
        data: List<BasketDatum>.from(json["data"].map((x) => BasketDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BasketDatum {
  BasketDatum({
    this.basketId,
    this.userId,
    this.basketName,
    this.basketScrips,
  });

  int basketId;
  String userId;
  String basketName;
  String basketScrips;

  factory BasketDatum.fromJson(Map<String, dynamic> json) => BasketDatum(
        basketId: json["Basket_Id"],
        userId: json["User_Id"],
        basketName: json["BasketName"] == null ? null : json["BasketName"],
        basketScrips:
            json["BasketScrips"] == null ? null : json["BasketScrips"],
      );

  Map<String, dynamic> toJson() => {
        "Basket_Id": basketId,
        "User_Id": userId,
        "BasketName": basketName == null ? null : basketName,
        "BasketScrips": basketScrips == null ? null : basketScrips,
      };
}
