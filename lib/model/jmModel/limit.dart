// To parse this JSON data, do
//
//     final limit = limitFromJson(jsonString);

import 'dart:convert';

Limit limitFromJson(String str) => Limit.fromJson(json.decode(str));

String limitToJson(Limit data) => json.encode(data.toJson());

class Limit {
  Limit({
    this.status,
    this.message,
    this.errorcode,
    this.data,
  });

  bool status;
  String message;
  String errorcode;
  LimitData data;

  factory Limit.fromJson(Map<String, dynamic> json) => Limit(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    data: LimitData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "Data": data.toJson(),
  };
}

class LimitData {
  LimitData({
    this.sourceOfLimit,
    this.utilizationOfLimit,
    this.availableMargin,
    this.marginUsed,
    this.marginUsedPercentage,
    this.availableDerivativeMarginLimit,
    this.availableMarginLimit,
    this.availableDeliveryMarginLimitCnc,
    this.availableOptnBuyLimit,
    this.shortFall,
    this.cncrealizedmtomprsnt,
    this.deliverymarginprsnt,
    this.adhocscripmargin,
    this.brokerageprsnt,
    this.ipoAmount,
    this.bOmarginRequired,
    this.cdsspreadbenefit,
    this.scripbasketmargin,
    this.segment,
    this.equity,
    this.buyExposurePrsnt,
    this.grossCollateral,
    this.utilizedamount,
    this.branchadhoc,
    this.premiumpresent,
    this.sellExposurePrsnt,
    this.multiplier,
    this.elm,
    this.additionalpreexpirymarginprsnt,
    this.coMarginRequired,
    this.nfospreadbenefit,
    this.valueindelivery,
    this.payoutAmt,
    this.losslimit,
    this.viewunrealizedmtom,
    this.cncmarginused,
    this.stockValuation,
    this.cncsellcreditpresent,
    this.mfssamountused,
    this.spanmargin,
    this.openingBalance,
    this.netcashavailable,
    this.bookedPnl,
    this.exposuremargin,
    this.unrealisedmtom,
    this.payinAmt,
    this.lien,
    this.viewrealizedmtom,
    this.unbookedPnl,
    this.cncMarginVarPrsnt,
    this.marginScripBasketCustomPresent,
    this.t1GrossCollateral,
    this.adhoc,
    this.turnover,
    this.cncMarginElmPrsnt,
    this.grossexposurevalue,
    this.stat,
    this.buyPower,
    this.varmargin,
    this.mfamount,
    this.specialmarginprsnt,
    this.elbamount,
    this.directcollateralvalue,
    this.additionalmarginprsnt,
    this.realisedmtom,
    this.tendermarginprsnt,
    this.cncunrealizedmtomprsnt,
    this.financelimit,
    this.adhocmargin,
    this.category,
    this.cncbrokerageprsnt,
    this.notionalcash,
  });

  String sourceOfLimit;
  String utilizationOfLimit;
  double availableMargin;
  double marginUsed;
  String marginUsedPercentage;
  double availableDerivativeMarginLimit;
  double availableMarginLimit;
  double availableDeliveryMarginLimitCnc;
  double availableOptnBuyLimit;
  double shortFall;
  String cncrealizedmtomprsnt;
  String deliverymarginprsnt;
  String adhocscripmargin;
  String brokerageprsnt;
  String ipoAmount;
  String bOmarginRequired;
  String cdsspreadbenefit;
  String scripbasketmargin;
  String segment;
  dynamic equity;
  String buyExposurePrsnt;
  String grossCollateral;
  String utilizedamount;
  String branchadhoc;
  String premiumpresent;
  String sellExposurePrsnt;
  String multiplier;
  String elm;
  String additionalpreexpirymarginprsnt;
  String coMarginRequired;
  String nfospreadbenefit;
  String valueindelivery;
  String payoutAmt;
  String losslimit;
  String viewunrealizedmtom;
  String cncmarginused;
  String stockValuation;
  String cncsellcreditpresent;
  String mfssamountused;
  String spanmargin;
  String openingBalance;
  String netcashavailable;
  String bookedPnl;
  String exposuremargin;
  String unrealisedmtom;
  String payinAmt;
  String lien;
  String viewrealizedmtom;
  String unbookedPnl;
  String cncMarginVarPrsnt;
  String marginScripBasketCustomPresent;
  String t1GrossCollateral;
  String adhoc;
  String turnover;
  String cncMarginElmPrsnt;
  String grossexposurevalue;
  String stat;
  String buyPower;
  String varmargin;
  String mfamount;
  String specialmarginprsnt;
  String elbamount;
  String directcollateralvalue;
  String additionalmarginprsnt;
  String realisedmtom;
  String tendermarginprsnt;
  String cncunrealizedmtomprsnt;
  String financelimit;
  String adhocmargin;
  String category;
  String cncbrokerageprsnt;
  String notionalcash;

  factory LimitData.fromJson(Map<String, dynamic> json) => LimitData(
    sourceOfLimit: json["Source_of_Limit"],
    utilizationOfLimit: json["Utilization_of_Limit"],
    availableMargin: json["AvailableMargin"].toDouble(),
    marginUsed: json["MarginUsed"].toDouble(),
    marginUsedPercentage: json["MarginUsed_Percentage"],
    availableDerivativeMarginLimit: json["AvailableDerivativeMarginLimit"],
    availableMarginLimit: json["AvailableMarginLimit"],
    availableDeliveryMarginLimitCnc: json["AvailableDeliveryMarginLimitCNC"],
    availableOptnBuyLimit: json["AvailableOptnBuyLimit"],
    shortFall: json["ShortFall"],
    cncrealizedmtomprsnt: json["Cncrealizedmtomprsnt"],
    deliverymarginprsnt: json["Deliverymarginprsnt"],
    adhocscripmargin: json["Adhocscripmargin"],
    brokerageprsnt: json["Brokerageprsnt"],
    ipoAmount: json["IPOAmount"],
    bOmarginRequired: json["BOmarginRequired"],
    cdsspreadbenefit: json["Cdsspreadbenefit"],
    scripbasketmargin: json["Scripbasketmargin"],
    segment: json["Segment"],
    equity: json["Equity"],
    buyExposurePrsnt: json["BuyExposurePrsnt"],
    grossCollateral: json["GrossCollateral"],
    utilizedamount: json["Utilizedamount"],
    branchadhoc: json["Branchadhoc"],
    premiumpresent: json["Premiumpresent"],
    sellExposurePrsnt: json["SellExposurePrsnt"],
    multiplier: json["Multiplier"],
    elm: json["Elm"],
    additionalpreexpirymarginprsnt: json["Additionalpreexpirymarginprsnt"],
    coMarginRequired: json["COMarginRequired"],
    nfospreadbenefit: json["Nfospreadbenefit"],
    valueindelivery: json["Valueindelivery"],
    payoutAmt: json["PayoutAmt"],
    losslimit: json["Losslimit"],
    viewunrealizedmtom: json["Viewunrealizedmtom"],
    cncmarginused: json["Cncmarginused"],
    stockValuation: json["StockValuation"],
    cncsellcreditpresent: json["Cncsellcreditpresent"],
    mfssamountused: json["Mfssamountused"],
    spanmargin: json["Spanmargin"],
    openingBalance: json["OpeningBalance"],
    netcashavailable: json["Netcashavailable"],
    bookedPnl: json["BookedPNL"],
    exposuremargin: json["Exposuremargin"],
    unrealisedmtom: json["Unrealisedmtom"],
    payinAmt: json["PayinAmt"],
    lien: json["Lien"],
    viewrealizedmtom: json["Viewrealizedmtom"],
    unbookedPnl: json["UnbookedPNL"],
    cncMarginVarPrsnt: json["CncMarginVarPrsnt"],
    marginScripBasketCustomPresent: json["MarginScripBasketCustomPresent"],
    t1GrossCollateral: json["T1grossCollateral"],
    adhoc: json["Adhoc"],
    turnover: json["Turnover"],
    cncMarginElmPrsnt: json["CncMarginElmPrsnt"],
    grossexposurevalue: json["Grossexposurevalue"],
    stat: json["Stat"],
    buyPower: json["BuyPower"],
    varmargin: json["varmargin"],
    mfamount: json["Mfamount"],
    specialmarginprsnt: json["Specialmarginprsnt"],
    elbamount: json["Elbamount"],
    directcollateralvalue: json["Directcollateralvalue"],
    additionalmarginprsnt: json["Additionalmarginprsnt"],
    realisedmtom: json["Realisedmtom"],
    tendermarginprsnt: json["Tendermarginprsnt"],
    cncunrealizedmtomprsnt: json["Cncunrealizedmtomprsnt"],
    financelimit: json["Financelimit"],
    adhocmargin: json["Adhocmargin"],
    category: json["Category"],
    cncbrokerageprsnt: json["Cncbrokerageprsnt"],
    notionalcash: json["Notionalcash"],
  );

  Map<String, dynamic> toJson() => {
    "Source_of_Limit": sourceOfLimit,
    "Utilization_of_Limit": utilizationOfLimit,
    "AvailableMargin": availableMargin,
    "MarginUsed": marginUsed,
    "MarginUsed_Percentage": marginUsedPercentage,
    "AvailableDerivativeMarginLimit": availableDerivativeMarginLimit,
    "AvailableMarginLimit": availableMarginLimit,
    "AvailableDeliveryMarginLimitCNC": availableDeliveryMarginLimitCnc,
    "AvailableOptnBuyLimit": availableOptnBuyLimit,
    "ShortFall": shortFall,
    "Cncrealizedmtomprsnt": cncrealizedmtomprsnt,
    "Deliverymarginprsnt": deliverymarginprsnt,
    "Adhocscripmargin": adhocscripmargin,
    "Brokerageprsnt": brokerageprsnt,
    "IPOAmount": ipoAmount,
    "BOmarginRequired": bOmarginRequired,
    "Cdsspreadbenefit": cdsspreadbenefit,
    "Scripbasketmargin": scripbasketmargin,
    "Segment": segment,
    "Equity": equity,
    "BuyExposurePrsnt": buyExposurePrsnt,
    "GrossCollateral": grossCollateral,
    "Utilizedamount": utilizedamount,
    "Branchadhoc": branchadhoc,
    "Premiumpresent": premiumpresent,
    "SellExposurePrsnt": sellExposurePrsnt,
    "Multiplier": multiplier,
    "Elm": elm,
    "Additionalpreexpirymarginprsnt": additionalpreexpirymarginprsnt,
    "COMarginRequired": coMarginRequired,
    "Nfospreadbenefit": nfospreadbenefit,
    "Valueindelivery": valueindelivery,
    "PayoutAmt": payoutAmt,
    "Losslimit": losslimit,
    "Viewunrealizedmtom": viewunrealizedmtom,
    "Cncmarginused": cncmarginused,
    "StockValuation": stockValuation,
    "Cncsellcreditpresent": cncsellcreditpresent,
    "Mfssamountused": mfssamountused,
    "Spanmargin": spanmargin,
    "OpeningBalance": openingBalance,
    "Netcashavailable": netcashavailable,
    "BookedPNL": bookedPnl,
    "Exposuremargin": exposuremargin,
    "Unrealisedmtom": unrealisedmtom,
    "PayinAmt": payinAmt,
    "Lien": lien,
    "Viewrealizedmtom": viewrealizedmtom,
    "UnbookedPNL": unbookedPnl,
    "CncMarginVarPrsnt": cncMarginVarPrsnt,
    "MarginScripBasketCustomPresent": marginScripBasketCustomPresent,
    "T1grossCollateral": t1GrossCollateral,
    "Adhoc": adhoc,
    "Turnover": turnover,
    "CncMarginElmPrsnt": cncMarginElmPrsnt,
    "Grossexposurevalue": grossexposurevalue,
    "Stat": stat,
    "BuyPower": buyPower,
    "varmargin": varmargin,
    "Mfamount": mfamount,
    "Specialmarginprsnt": specialmarginprsnt,
    "Elbamount": elbamount,
    "Directcollateralvalue": directcollateralvalue,
    "Additionalmarginprsnt": additionalmarginprsnt,
    "Realisedmtom": realisedmtom,
    "Tendermarginprsnt": tendermarginprsnt,
    "Cncunrealizedmtomprsnt": cncunrealizedmtomprsnt,
    "Financelimit": financelimit,
    "Adhocmargin": adhocmargin,
    "Category": category,
    "Cncbrokerageprsnt": cncbrokerageprsnt,
    "Notionalcash": notionalcash,
  };
}
