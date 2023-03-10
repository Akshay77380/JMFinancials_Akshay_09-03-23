// // To parse this JSON data, do
// //
// //     final netPositions = netPositionsFromJson(jsonString);
//
// import 'dart:convert';
// import '../../util/CommonFunctions.dart';
// import '../scrip_info_model.dart';
//
// TodaysPositions todaysPositionsFromJson(String str) => TodaysPositions.fromJson(json.decode(str));
//
// String todaysPositionsToJson(TodaysPositions data) => json.encode(data.toJson());
//
// class TodaysPositions {
//   TodaysPositions({
//     this.status,
//     this.message,
//     this.errorcode,
//     this.data,
//   });
//
//   bool status;
//   String message;
//   String errorcode;
//   List<TodaysPositionDatum> data;
//
//   factory TodaysPositions.fromJson(Map<String, dynamic> json) => TodaysPositions(
//         status: json["status"],
//         message: json["message"],
//         errorcode: json["errorcode"],
//         data: List<TodaysPositionDatum>.from(json["data"].map((x) => TodaysPositionDatum.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "errorcode": errorcode,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }
//
// class TodaysPositionDatum {
//   TodaysPositionDatum({
//     this.exchange,
//     this.symboltoken,
//     this.producttype,
//     this.tradingsymbol,
//     this.symbolname,
//     this.instrumenttype,
//     this.priceden,
//     this.pricenum,
//     this.genden,
//     this.gennum,
//     this.precision,
//     this.multiplier,
//     this.boardlotsize,
//     this.buyqty,
//     this.sellqty,
//     this.buyamount,
//     this.sellamount,
//     this.symbolgroup,
//     this.strikeprice,
//     this.optiontype,
//     this.expirydate,
//     this.lotsize,
//     this.buyavgprice,
//     this.sellavgprice,
//     this.avgnetprice,
//     this.netvalue,
//     this.netqty,
//     this.netprice,
//     this.fillbuyquantity,
//     this.fillsellquantity,
//     this.closedquantity,
//     this.model,
//     this.squareOff,
//     this.pl,
//   }) {
//     model = CommonFunction.getScripDataModel(
//       exch: exchange == 'BSE'
//           ? 'B'
//           : exchange == 'MCX'
//               ? 'M'
//               : exchange == 'CDS'
//                   ? 'C'
//                   : exchange == 'BCD'
//                       ? 'E'
//                       : 'N',
//       exchCode: int.parse(symboltoken),
//       sendReq: true,
//       getNseBseMap: true,
//     );
//     squareOff = true;
//   }
//
//   String exchange;
//   String symboltoken;
//   String producttype;
//   String tradingsymbol;
//   String symbolname;
//   String instrumenttype;
//   String priceden;
//   String pricenum;
//   String genden;
//   String gennum;
//   String precision;
//   String multiplier;
//   String boardlotsize;
//   String buyqty;
//   String sellqty;
//   String buyamount;
//   String sellamount;
//   String symbolgroup;
//   String strikeprice;
//   String optiontype;
//   String expirydate;
//   String lotsize;
//   String buyavgprice;
//   String sellavgprice;
//   String avgnetprice;
//   String netvalue;
//   String netqty;
//   String netprice;
//   String fillbuyquantity;
//   String fillsellquantity;
//   String closedquantity;
//   ScripInfoModel model;
//   bool squareOff;
//   double pl = 0.0;
//
//   factory TodaysPositionDatum.fromJson(Map<String, dynamic> json) => TodaysPositionDatum(
//         exchange: json["exchange"],
//         symboltoken: json["symboltoken"],
//         producttype: json["producttype"] == 'CARRYFORWARD'
//             ? 'NRML'
//             : json["producttype"] == 'DELIVERY'
//                 ? 'CNC'
//                 : json["producttype"] == 'INTRADAY'
//                     ? 'MIS'
//                     : json["producttype"] == 'CO'
//                         ? 'COVER'
//                         : json["producttype"] == 'BO'
//                             ? 'BRACKET'
//                             : '',
//         tradingsymbol: json["tradingsymbol"],
//         symbolname: json["symbolname"],
//         instrumenttype: json["instrumenttype"],
//         priceden: json["priceden"],
//         pricenum: json["pricenum"],
//         genden: json["genden"],
//         gennum: json["gennum"],
//         precision: json["precision"],
//         multiplier: json["multiplier"],
//         boardlotsize: json["boardlotsize"],
//         buyqty: json["buyqty"],
//         sellqty: json["sellqty"],
//         buyamount: json["buyamount"],
//         sellamount: json["sellamount"],
//         symbolgroup: json["symbolgroup"],
//         strikeprice: json["strikeprice"],
//         optiontype: json["optiontype"],
//         expirydate: json["expirydate"],
//         lotsize: json["lotsize"],
//         buyavgprice: json["buyavgprice"],
//         sellavgprice: json["sellavgprice"],
//         avgnetprice: json["avgnetprice"],
//         netvalue: json["netvalue"],
//         netqty: json["netqty"],
//         netprice: json["netprice"],
//         fillbuyquantity: json["fillbuyquantity"],
//         fillsellquantity: json["fillsellquantity"],
//         closedquantity: json["closedquantity"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "exchange": exchange,
//         "symboltoken": symboltoken,
//         "producttype": producttype,
//         "tradingsymbol": tradingsymbol,
//         "symbolname": symbolname,
//         "instrumenttype": instrumenttype,
//         "priceden": priceden,
//         "pricenum": pricenum,
//         "genden": genden,
//         "gennum": gennum,
//         "precision": precision,
//         "multiplier": multiplier,
//         "boardlotsize": boardlotsize,
//         "buyqty": buyqty,
//         "sellqty": sellqty,
//         "buyamount": buyamount,
//         "sellamount": sellamount,
//         "symbolgroup": symbolgroup,
//         "strikeprice": strikeprice,
//         "optiontype": optiontype,
//         "expirydate": expirydate,
//         "lotsize": lotsize,
//         "buyavgprice": buyavgprice,
//         "sellavgprice": sellavgprice,
//         "avgnetprice": avgnetprice,
//         "netvalue": netvalue,
//         "netqty": netqty,
//         "netprice": netprice,
//         "fillbuyquantity": fillbuyquantity,
//         "fillsellquantity": fillsellquantity,
//       };
// }
