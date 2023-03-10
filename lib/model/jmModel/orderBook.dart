// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
import '../../util/CommonFunctions.dart';
import '../scrip_info_model.dart';

OrderBookJson OrderBookFromJson(String str) => OrderBookJson.fromJson(json.decode(str));

String OrderBookToJson(OrderBookJson data) => json.encode(data.toJson());

class OrderBookJson {
  OrderBookJson({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  List<orderDatum> data;

  factory OrderBookJson.fromJson(Map<String, dynamic> json) => OrderBookJson(
        status: json["status"],
        message: json["message"],
        errorcode: json["errorcode"],
        data: List<orderDatum>.from(json["data"].map((x) => orderDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class orderDatum {
  orderDatum(
      {this.variety,
      this.ordertype,
      this.producttype,
      this.duration,
      this.price,
      this.triggerprice,
      this.quantity,
      this.disclosedquantity,
      this.squareoff,
      this.stoploss,
      this.trailingstoploss,
      this.tradingsymbol,
      this.transactiontype,
      this.exchange,
      this.symboltoken,
      this.instrumenttype,
      this.strikeprice,
      this.optiontype,
      this.expirydate,
      this.lotsize,
      this.cancelsize,
      this.averageprice,
      this.filledshares,
      this.unfilledshares,
      this.orderid,
      this.exchorderid,
      this.text,
      this.status,
      this.orderstatus,
      this.updatetime,
      this.exseg,
      this.exchtime,
      this.exchorderupdatetime,
      this.fillid,
      this.filltime,
      this.parentorderid,
      this.specialOrderType,
      this.syomorderid,
      this.gtdValdate,
      this.model,
      this.cancel}) {
    model = CommonFunction.getScripDataModel(
      exch: exchange == 'BSE'
          ? 'B'
          : exchange == 'MCX'
              ? 'M'
              : exchange == 'CDS'
                  ? 'C'
                  : exchange == 'BCD'
                      ? 'E'
                      : 'N',
      exchCode: int.parse(symboltoken),
      sendReq: true,
      getNseBseMap: true,
    );
    if (status != "complete" || status != "cancelled" || status != "rejected") cancel = true;
  }

  String variety;
  String ordertype;
  String producttype;
  String duration;
  String price;
  String triggerprice;
  String quantity;
  String disclosedquantity;
  String squareoff;
  String stoploss;
  String trailingstoploss;
  String tradingsymbol;
  String transactiontype;
  String exchange;
  String symboltoken;
  String instrumenttype;
  String strikeprice;
  String optiontype;
  String expirydate;
  String lotsize;
  String cancelsize;
  String averageprice;
  String filledshares;
  String unfilledshares;
  String orderid;
  String exchorderid;
  String text;
  String status;
  String orderstatus;
  String updatetime;
  String exseg;
  String exchtime;
  String exchorderupdatetime;
  String fillid;
  String filltime;
  String parentorderid;
  String specialOrderType;
  String syomorderid;
  String gtdValdate;
  ScripInfoModel model;
  bool cancel;

  factory orderDatum.fromJson(Map<String, dynamic> json) => orderDatum(
        variety: json["variety"],
        ordertype: json["ordertype"],
        producttype: json["producttype"] == 'CARRYFORWARD' || json["producttype"] == 'NRML'
            ? 'NRML'
            : json["producttype"] == 'DELIVERY' || json["producttype"] == 'CNC'
                ? 'CNC'
                : json["producttype"] == 'INTRADAY' || json["producttype"] == 'MIS'
                    ? 'MIS'
                    : json["producttype"] == 'CO' || json["producttype"] == 'COVER'
                        ? 'COVER'
                        : json["producttype"] == 'BO' || json["producttype"] == 'BRACKET'
                            ? 'BRACKET'
                            : json["producttype"] == 'MTF'
                                ? 'MTF'
                                : '',
        duration: json["specialordertype"] == 'GTC' || json["specialordertype"] == 'GTD' ? json["specialordertype"] : json["duration"],
        price: json["price"],
        triggerprice: json["triggerprice"],
        quantity: json["quantity"],
        disclosedquantity: json["disclosedquantity"],
        squareoff: json["squareoff"],
        stoploss: json["stoploss"],
        trailingstoploss: json["trailingstoploss"],
        tradingsymbol: json["tradingsymbol"],
        transactiontype: json["transactiontype"],
        exchange: json["exchange"],
        symboltoken: json["symboltoken"] ?? '0',
        instrumenttype: json["instrumenttype"],
        strikeprice: json["strikeprice"],
        optiontype: json["optiontype"],
        expirydate: json["expirydate"],
        lotsize: json["lotsize"],
        cancelsize: json["cancelsize"],
        averageprice: json["averageprice"],
        filledshares: json["filledshares"],
        unfilledshares: json["unfilledshares"],
        orderid: json["orderid"],
        exchorderid: json["exchorderid"],
        text: json["text"],
        status: json["status"],
        orderstatus: json["orderstatus"],
        updatetime: json["updatetime"],
        exseg: json["exseg"],
        exchtime: json["exchtime"],
        exchorderupdatetime: json["exchorderupdatetime"],
        fillid: json["fillid"],
        filltime: json["filltime"],
        parentorderid: json["parentorderid"],
        specialOrderType: json["specialordertype"],
        syomorderid: json["syomorderid"],
        gtdValdate: json["gtdValdate"],
      );

  Map<String, dynamic> toJson() => {
        "variety": variety,
        "ordertype": ordertype,
        "producttype": producttype,
        "duration": duration,
        "price": price,
        "triggerprice": triggerprice,
        "quantity": quantity,
        "disclosedquantity": disclosedquantity,
        "squareoff": squareoff,
        "stoploss": stoploss,
        "trailingstoploss": trailingstoploss,
        "tradingsymbol": tradingsymbol,
        "transactiontype": transactiontype,
        "exchange": exchange,
        "symboltoken": symboltoken,
        "instrumenttype": instrumenttype,
        "strikeprice": strikeprice,
        "optiontype": optiontype,
        "expirydate": expirydate,
        "lotsize": lotsize,
        "cancelsize": cancelsize,
        "averageprice": averageprice,
        "filledshares": filledshares,
        "unfilledshares": unfilledshares,
        "orderid": orderid,
        "exchorderid": exchorderid,
        "text": text,
        "status": status,
        "orderstatus": orderstatus,
        "updatetime": updatetime,
        "exseg": exseg,
        "exchtime": exchtime,
        "exchorderupdatetime": exchorderupdatetime,
        "fillid": fillid,
        "filltime": filltime,
        "parentorderid": parentorderid,
        "specialordertype": specialOrderType,
        "syomorderid": syomorderid,
        "gtdValdate": gtdValdate,
      };
}
