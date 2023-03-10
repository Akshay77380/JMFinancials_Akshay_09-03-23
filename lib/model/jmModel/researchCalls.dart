// To parse this JSON data, do
//
//     final researchCalls = researchCallsFromJson(jsonString);

import 'dart:convert';

import '../../util/CommonFunctions.dart';
import '../scrip_info_model.dart';

ResearchCalls researchCallsFromJson(String str) => ResearchCalls.fromJson(json.decode(str));

String researchCallsToJson(ResearchCalls data) => json.encode(data.toJson());

class ResearchCalls {
  ResearchCalls({
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
  List<ResearchCallsDatum> data;

  factory ResearchCalls.fromJson(Map<String, dynamic> json) => ResearchCalls(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: List<ResearchCallsDatum>.from(json["data"].map((x) => ResearchCallsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ResearchCallsDatum {
  ResearchCallsDatum({
    this.structuredcallentryid,
    this.exchange,
    this.exchsegment,
    this.scripcode,
    this.price,
    this.stoploss,
    this.targetprice,
    this.validity,
    this.rrrvalue,
    this.internalremark,
    this.header,
    this.calltype,
    this.categoryid,
    this.categoryname,
    this.subcategoryid,
    this.subcategoryname,
    this.insertiontime,
    this.isactive,
    this.attachment,
    this.status,
    this.statusdescreption,
    this.buysell,
    this.sendto,
    this.profitPotential,
    this.model
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
      exchCode: int.parse(scripcode),
      sendReq: true,
      getNseBseMap: true,
    );
  }

  String structuredcallentryid;
  String exchange;
  String exchsegment;
  String scripcode;
  String price;
  String stoploss;
  String targetprice;
  String validity;
  String rrrvalue;
  String internalremark;
  String header;
  String calltype;
  String categoryid;
  String categoryname;
  String subcategoryid;
  String subcategoryname;
  String insertiontime;
  String isactive;
  String attachment;
  String status;
  String statusdescreption;
  String buysell;
  String sendto;
  double profitPotential;
  ScripInfoModel model;

  factory ResearchCallsDatum.fromJson(Map<String, dynamic> json) => ResearchCallsDatum(
    structuredcallentryid: json["structuredcallentryid"],
    exchange: json["exchange"],
    exchsegment: json["exchsegment"],
    scripcode: json["scripcode"],
    price: json["price"],
    stoploss: json["stoploss"],
    targetprice: json["targetprice"],
    validity: json["validity"],
    rrrvalue: json["rrrvalue"],
    internalremark: json["internalremark"],
    header: json["header"],
    calltype: json["calltype"],
    categoryid: json["categoryid"],
    categoryname: json["categoryname"],
    subcategoryid: json["subcategoryid"],
    subcategoryname: json["subcategoryname"],
    insertiontime: json["insertiontime"],
    isactive: json["isactive"],
    attachment: json["attachment"],
    status: json["status"],
    statusdescreption: json["statusdescreption"],
    buysell: json["buysell"],
    sendto: json["sendto"],
  );

  Map<String, dynamic> toJson() => {
    "structuredcallentryid": structuredcallentryid,
    "exchange": exchange,
    "exchsegment": exchsegment,
    "scripcode": scripcode,
    "price": price,
    "stoploss": stoploss,
    "targetprice": targetprice,
    "validity": validity,
    "rrrvalue": rrrvalue,
    "internalremark": internalremark,
    "header": header,
    "calltype": calltype,
    "categoryid": categoryid,
    "categoryname": categoryname,
    "subcategoryid": subcategoryid,
    "subcategoryname": subcategoryname,
    "insertiontime": insertiontime,
    "isactive": isactive,
    "attachment": attachment,
    "status": status,
    "statusdescreption": statusdescreption,
    "buysell": buysell,
    "sendto": sendto,
  };
}
