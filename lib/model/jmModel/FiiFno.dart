// To parse this JSON data, do
//
//     final fiiFno = fiiFnoFromJson(jsonString);

import 'dart:convert';

FiiFno fiiFnoFromJson(String str) => FiiFno.fromJson(json.decode(str));

String fiiFnoToJson(FiiFno data) => json.encode(data.toJson());

class FiiFno {
  FiiFno({
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

  factory FiiFno.fromJson(Map<String, dynamic> json) => FiiFno(
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
      this.fiifnoDate,
      this.indexFuturesBuyContracts,
      this.indexFuturesBuyAmount,
      this.indexFuturesSellContracts,
      this.indexFuturesSellAmount,
      this.indexFuturesOpenInterestContracts,
      this.indexFuturesOpenInterestAmount,
      this.indexOptionsBuyContracts,
      this.indexOptionsBuyAmount,
      this.indexOptionsSellContracts,
      this.indexOptionsSellAmount,
      this.indexOptionsOpenInterestContracts,
      this.indexOptionsOpenInterestAmount,
      this.stockFuturesBuyContracts,
      this.stockFuturesBuyAmount,
      this.stockFuturesSellContracts,
      this.stockFuturesSellAmount,
      this.stockFuturesOpenInterestContracts,
      this.stockFuturesOpenInterestAmount,
      this.stockOptionsBuyContracts,
      this.stockOptionsBuyAmount,
      this.stockOptionsSellContracts,
      this.stockOptionsSellAmount,
      this.stockOptionsOpenInterestContracts,
      this.stockOptionsOpenInterestAmount,
  });

  DateTime fiifnoDate;
  double indexFuturesBuyContracts;
  double indexFuturesBuyAmount;
  double indexFuturesSellContracts;
  double indexFuturesSellAmount;
  double indexFuturesOpenInterestContracts;
  double indexFuturesOpenInterestAmount;
  double indexOptionsBuyContracts;
  double indexOptionsBuyAmount;
  double indexOptionsSellContracts;
  double indexOptionsSellAmount;
  double indexOptionsOpenInterestContracts;
  double indexOptionsOpenInterestAmount;
  double stockFuturesBuyContracts;
  double stockFuturesBuyAmount;
  double stockFuturesSellContracts;
  double stockFuturesSellAmount;
  double stockFuturesOpenInterestContracts;
  double stockFuturesOpenInterestAmount;
  double stockOptionsBuyContracts;
  double stockOptionsBuyAmount;
  double stockOptionsSellContracts;
  double stockOptionsSellAmount;
  double stockOptionsOpenInterestContracts;
  double stockOptionsOpenInterestAmount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    fiifnoDate: DateTime.parse(json["FIIFNODate"]),
    indexFuturesBuyContracts: json["IndexFutures_Buy_Contracts"],
    indexFuturesBuyAmount: json["IndexFutures_Buy_Amount"]?.toDouble(),
    indexFuturesSellContracts: json["IndexFutures_Sell_Contracts"],
    indexFuturesSellAmount: json["IndexFutures_Sell_Amount"]?.toDouble(),
    indexFuturesOpenInterestContracts: json["IndexFutures_OpenInterest_Contracts"],
    indexFuturesOpenInterestAmount: json["IndexFutures_OpenInterest_Amount"]?.toDouble(),
    indexOptionsBuyContracts: json["IndexOptions_Buy_Contracts"],
    indexOptionsBuyAmount: json["IndexOptions_Buy_Amount"]?.toDouble(),
    indexOptionsSellContracts: json["IndexOptions_Sell_Contracts"],
    indexOptionsSellAmount: json["IndexOptions_Sell_Amount"]?.toDouble(),
    indexOptionsOpenInterestContracts: json["IndexOptions_OpenInterest_Contracts"],
    indexOptionsOpenInterestAmount: json["IndexOptions_OpenInterest_Amount"]?.toDouble(),
    stockFuturesBuyContracts: json["StockFutures_Buy_Contracts"],
    stockFuturesBuyAmount: json["StockFutures_Buy_Amount"]?.toDouble(),
    stockFuturesSellContracts: json["StockFutures_Sell_Contracts"],
    stockFuturesSellAmount: json["StockFutures_Sell_Amount"]?.toDouble(),
    stockFuturesOpenInterestContracts: json["StockFutures_OpenInterest_Contracts"],
    stockFuturesOpenInterestAmount: json["StockFutures_OpenInterest_Amount"]?.toDouble(),
    stockOptionsBuyContracts: json["StockOptions_Buy_Contracts"],
    stockOptionsBuyAmount: json["StockOptions_Buy_Amount"]?.toDouble(),
    stockOptionsSellContracts: json["StockOptions_Sell_Contracts"],
    stockOptionsSellAmount: json["StockOptions_Sell_Amount"]?.toDouble(),
    stockOptionsOpenInterestContracts: json["StockOptions_OpenInterest_Contracts"],
    stockOptionsOpenInterestAmount: json["StockOptions_OpenInterest_Amount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "FIIFNODate": fiifnoDate.toIso8601String(),
    "IndexFutures_Buy_Contracts": indexFuturesBuyContracts,
    "IndexFutures_Buy_Amount": indexFuturesBuyAmount,
    "IndexFutures_Sell_Contracts": indexFuturesSellContracts,
    "IndexFutures_Sell_Amount": indexFuturesSellAmount,
    "IndexFutures_OpenInterest_Contracts": indexFuturesOpenInterestContracts,
    "IndexFutures_OpenInterest_Amount": indexFuturesOpenInterestAmount,
    "IndexOptions_Buy_Contracts": indexOptionsBuyContracts,
    "IndexOptions_Buy_Amount": indexOptionsBuyAmount,
    "IndexOptions_Sell_Contracts": indexOptionsSellContracts,
    "IndexOptions_Sell_Amount": indexOptionsSellAmount,
    "IndexOptions_OpenInterest_Contracts": indexOptionsOpenInterestContracts,
    "IndexOptions_OpenInterest_Amount": indexOptionsOpenInterestAmount,
    "StockFutures_Buy_Contracts": stockFuturesBuyContracts,
    "StockFutures_Buy_Amount": stockFuturesBuyAmount,
    "StockFutures_Sell_Contracts": stockFuturesSellContracts,
    "StockFutures_Sell_Amount": stockFuturesSellAmount,
    "StockFutures_OpenInterest_Contracts": stockFuturesOpenInterestContracts,
    "StockFutures_OpenInterest_Amount": stockFuturesOpenInterestAmount,
    "StockOptions_Buy_Contracts": stockOptionsBuyContracts,
    "StockOptions_Buy_Amount": stockOptionsBuyAmount,
    "StockOptions_Sell_Contracts": stockOptionsSellContracts,
    "StockOptions_Sell_Amount": stockOptionsSellAmount,
    "StockOptions_OpenInterest_Contracts": stockOptionsOpenInterestContracts,
    "StockOptions_OpenInterest_Amount": stockOptionsOpenInterestAmount,
  };
}
