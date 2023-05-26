// To parse this JSON data, do
//
//     final getScripFromBasket = getScripFromBasketFromJson(jsonString);

import 'dart:convert';

import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';

GetScripFromBasket getScripFromBasketFromJson(String str) => GetScripFromBasket.fromJson(json.decode(str));

String getScripFromBasketToJson(GetScripFromBasket data) => json.encode(data.toJson());

class GetScripFromBasket {
  GetScripFromBasket({
     this.status,
     this.message,
     this.errorcode,
     this.emsg,
     this.data,
  });

  bool status;
  String message;
  String errorcode;
  dynamic emsg;
  List<Datum2> data;

  factory GetScripFromBasket.fromJson(Map<String, dynamic> json) => GetScripFromBasket(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: List<Datum2>.from(json["data"].map((x) => Datum2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum2 {
  Datum2({
   this.basketId,
   this.scriptId,
   this.createdAt,
   this.modifiedAt,
   this.variety,
    this.scriptDescription,
   this.tradingsymbol,
   this.symboltoken,
   this.transactiontype,
   this.exchange,
   this.ordertype,
   this.producttype,
   this.duration,
   this.price,
   this.quantity,
   this.triggerprice,
   this.disclosedquantity,
   this.remarks,
    this.model,
  }){
    model = CommonFunction.getScripDataModel(
      exch: exchange,   //exchange,
      exchCode: int.parse(symboltoken),
      sendReq: true,
      getNseBseMap: true,
    );

  }

  String basketId;
  String scriptId;
  String createdAt;
  String modifiedAt;
  String variety;
  String scriptDescription;
  String tradingsymbol;
  String symboltoken;
  String transactiontype;
  String exchange;
  String ordertype;
  String producttype;
  String duration;
  String price;
  String quantity;
  String triggerprice;
  String disclosedquantity;
  String remarks;
  ScripInfoModel model;

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
    basketId: json["basketId"],
    scriptId: json["scriptId"],
    createdAt: json["createdAt"],
    modifiedAt: json["modifiedAt"],
    variety: json["variety"],
    tradingsymbol: json["tradingsymbol"],
    scriptDescription: json["ScriptDescription"],
    symboltoken: json["symboltoken"],
    transactiontype: json["transactiontype"],
    exchange: json["exchange"],
    ordertype: json["ordertype"],
    producttype: json["producttype"],
    duration: json["duration"],
    price: json["price"],
    quantity: json["quantity"],
    triggerprice: json["triggerprice"],
    disclosedquantity: json["disclosedquantity"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "basketId": basketId,
    "scriptId": scriptId,
    "createdAt": createdAt,
    "modifiedAt": modifiedAt,
    "variety": variety,
    "ScriptDescription": scriptDescription,
    "tradingsymbol": tradingsymbol,
    "symboltoken": symboltoken,
    "transactiontype": transactiontype,
    "exchange": exchange,
    "ordertype": ordertype,
    "producttype": producttype,
    "duration": duration,
    "price": price,
    "quantity": quantity,
    "triggerprice": triggerprice,
    "disclosedquantity": disclosedquantity,
    "remarks": remarks,
  };
}
