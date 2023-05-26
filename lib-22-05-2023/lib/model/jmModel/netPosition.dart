// To parse this JSON data, do
//
//     final netPositions = netPositionsFromJson(jsonString);

import 'dart:convert';
import '../../util/CommonFunctions.dart';
import '../scrip_info_model.dart';

NetPositions netPositionsFromJson(String str) => NetPositions.fromJson(json.decode(str));

String netPositionsToJson(NetPositions data) => json.encode(data.toJson());

class NetPositions {
  NetPositions({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  List<NetPositionDatum> data;

  factory NetPositions.fromJson(Map<String, dynamic> json) => NetPositions(
        status: json["status"],
        message: json["message"],
        errorcode: json["errorcode"],
        data: List<NetPositionDatum>.from(json["data"].map((x) => NetPositionDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NetPositionDatum {
  NetPositionDatum({
    this.exchange,
    this.symboltoken,
    this.producttype,
    this.tradingsymbol,
    this.symbolname,
    this.instrumenttype,
    this.priceden,
    this.pricenum,
    this.genden,
    this.gennum,
    this.precision,
    this.multiplier,
    this.boardlotsize,
    this.buyqty,
    this.sellqty,
    this.buyamount,
    this.sellamount,
    this.symbolgroup,
    this.strikeprice,
    this.optiontype,
    this.expirydate,
    this.lotsize,
    this.cfbuyqty,
    this.cfsellqty,
    this.cfbuyamount,
    this.cfsellamount,
    this.buyavgprice,
    this.sellavgprice,
    this.avgnetprice,
    this.netvalue,
    this.netqty,
    this.totalbuyvalue,
    this.totalsellvalue,
    this.cfbuyavgprice,
    this.cfsellavgprice,
    this.totalbuyavgprice,
    this.totalsellavgprice,
    this.fillbuyquantity,
    this.fillsellquantity,
    this.closedquantity,
    this.netprice,
    this.model,
    this.pl,
    this.squareOff,
  }) {
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
    squareOff = true;
  }

  String exchange;
  String symboltoken;
  String producttype;
  String tradingsymbol;
  String symbolname;
  String instrumenttype;
  String priceden;
  String pricenum;
  String genden;
  String gennum;
  String precision;
  String multiplier;
  String boardlotsize;
  String buyqty;
  String sellqty;
  String buyamount;
  String sellamount;
  String symbolgroup;
  String strikeprice;
  String optiontype;
  String expirydate;
  String lotsize;
  String cfbuyqty;
  String cfsellqty;
  String cfbuyamount;
  String cfsellamount;
  String buyavgprice;
  String sellavgprice;
  String avgnetprice;
  String netvalue;
  String netqty;
  String totalbuyvalue;
  String totalsellvalue;
  String cfbuyavgprice;
  String cfsellavgprice;
  String totalbuyavgprice;
  String totalsellavgprice;
  String fillbuyquantity;
  String fillsellquantity;
  String closedquantity;
  String netprice;
  ScripInfoModel model;
  bool squareOff;
  double pl = 0.0;

  factory NetPositionDatum.fromJson(Map<String, dynamic> json) => NetPositionDatum(
      exchange: json["exchange"],
      symboltoken: json["symboltoken"],
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
      tradingsymbol: json["tradingsymbol"],
      symbolname: json["symbolname"],
      instrumenttype: json["instrumenttype"],
      priceden: json["priceden"],
      pricenum: json["pricenum"],
      genden: json["genden"],
      gennum: json["gennum"],
      precision: json["precision"],
      multiplier: json["multiplier"],
      boardlotsize: json["boardlotsize"],
      buyqty: json["buyqty"],
      sellqty: json["sellqty"],
      buyamount: json["buyamount"],
      sellamount: json["sellamount"],
      symbolgroup: json["symbolgroup"],
      strikeprice: json["strikeprice"],
      optiontype: json["optiontype"],
      expirydate: json["expirydate"],
      lotsize: json["lotsize"],
      cfbuyqty: json["cfbuyqty"],
      cfsellqty: json["cfsellqty"],
      cfbuyamount: json["cfbuyamount"],
      cfsellamount: json["cfsellamount"],
      buyavgprice: json["buyavgprice"],
      sellavgprice: json["sellavgprice"],
      avgnetprice: json["avgnetprice"],
      netvalue: json["netvalue"],
      netqty: json["netqty"],
      totalbuyvalue: json["totalbuyvalue"],
      totalsellvalue: json["totalsellvalue"],
      cfbuyavgprice: json["cfbuyavgprice"],
      cfsellavgprice: json["cfsellavgprice"],
      totalbuyavgprice: json["totalbuyavgprice"],
      totalsellavgprice: json["totalsellavgprice"],
      fillbuyquantity: json["fillbuyquantity"],
      fillsellquantity: json["fillsellquantity"],
      closedquantity: json["closedquantity"],
      netprice: json["netprice"],
      pl: (double.tryParse(json["sellavgprice"].replaceAll(',', '')) - double.parse(json["buyavgprice"].replaceAll(',', ''))) * int.parse(json["closedquantity"]));

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "symboltoken": symboltoken,
        "producttype": producttype,
        "tradingsymbol": tradingsymbol,
        "symbolname": symbolname,
        "instrumenttype": instrumenttype,
        "priceden": priceden,
        "pricenum": pricenum,
        "genden": genden,
        "gennum": gennum,
        "precision": precision,
        "multiplier": multiplier,
        "boardlotsize": boardlotsize,
        "buyqty": buyqty,
        "sellqty": sellqty,
        "buyamount": buyamount,
        "sellamount": sellamount,
        "symbolgroup": symbolgroup,
        "strikeprice": strikeprice,
        "optiontype": optiontype,
        "expirydate": expirydate,
        "lotsize": lotsize,
        "cfbuyqty": cfbuyqty,
        "cfsellqty": cfsellqty,
        "cfbuyamount": cfbuyamount,
        "cfsellamount": cfsellamount,
        "buyavgprice": buyavgprice,
        "sellavgprice": sellavgprice,
        "avgnetprice": avgnetprice,
        "netvalue": netvalue,
        "netqty": netqty,
        "totalbuyvalue": totalbuyvalue,
        "totalsellvalue": totalsellvalue,
        "cfbuyavgprice": cfbuyavgprice,
        "cfsellavgprice": cfsellavgprice,
        "totalbuyavgprice": totalbuyavgprice,
        "totalsellavgprice": totalsellavgprice,
        "fillbuyquantity": fillbuyquantity,
        "fillsellquantity": fillsellquantity,
        "closedquantity": closedquantity,
      };
}
