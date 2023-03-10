// To parse this JSON data, do
//
//     final watchListData = watchListDataFromJson(jsonString);

import 'dart:convert';

WatchListData watchListDataFromJson(String str) => WatchListData.fromJson(json.decode(str));

String watchListDataToJson(WatchListData data) => json.encode(data.toJson());

class WatchListData {
  WatchListData({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  List<WatchListDatum> data;

  factory WatchListData.fromJson(Map<String, dynamic> json) => WatchListData(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    data: List<WatchListDatum>.from(json["data"].map((x) => WatchListDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WatchListDatum {
  WatchListDatum({
    this.watchlistId,
    this.userId,
    this.watchlistName,
    this.watchlistScrips,
  });

  int watchlistId;
  String userId;
  String watchlistName;
  dynamic watchlistScrips;

  factory WatchListDatum.fromJson(Map<String, dynamic> json) => WatchListDatum(
    watchlistId: json["Watchlist_Id"],
    userId: json["User_Id"],
    watchlistName: json["WatchlistName"],
    watchlistScrips: json["WatchlistScrips"],
  );

  Map<String, dynamic> toJson() => {
    "Watchlist_Id": watchlistId,
    "User_Id": userId,
    "WatchlistName": watchlistName,
    "WatchlistScrips": watchlistScrips,
  };
}
