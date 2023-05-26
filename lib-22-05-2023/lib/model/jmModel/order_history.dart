// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) => OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) => json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
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
  List<OrderHistoryDatum> data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    status: json["status"],
    message: json["message"],
    errorcode: json["errorcode"],
    emsg: json["emsg"],
    data: List<OrderHistoryDatum>.from(json["data"].map((x) => OrderHistoryDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errorcode": errorcode,
    "emsg": emsg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderHistoryDatum {
  OrderHistoryDatum({
    this.tradingsymbol,
    this.price,
    this.quantity,
    this.orderstatus,
    this.transactiontype,
    this.ordertype,
    this.priceNumerator,
    this.generalNumerator,
    this.priceDenominator,
    this.generalDenominator,
    this.lotsize,
    this.exchange,
    this.nestorderid,
    this.nestreqid,
    this.symbolname,
    this.averageprice,
    this.triggerprice,
    this.disclosedquantity,
    this.exchangeorderid,
    this.rejectionReason,
    this.orderTime,
    this.producttype,
    this.reportType,
    this.customerFirm,
    this.exchangeTimestamp,
    this.ordersource,
    this.filldateandtime,
    this.orderGenerationType,
    this.scripname,
    this.legOrderIndicator,
    this.filledshares,
    this.orderMsg,
    this.modifiedBy,
    // this.stat,
    // this.tradingsymbol,
    // this.price,
    // this.quantity,
    // this.orderstatus,
    // this.transactiontype,
    // this.ordertype,
    // this.priceNumerator,
    // this.generalNumerator,
    // this.priceDenominator,
    // this.generalDenominator,
    // this.lotQty,
    // this.exchange,
    // this.nestOrderid,
    // this.nestReqid,
    // this.symbolName,
    // this.avgPrice,
    // this.triggerPrice,
    // this.disclosedQty,
    // this.exchangeOrderid,
    // this.rejectionReason,
    // this.orderTime,
    // this.productCode,
    // this.reportType,
    // this.customerFirm,
    // this.exchangeTimestamp,
    // this.orderSource,
    // this.filldateandtime,
    // this.orderGenerationType,
    // this.scripname,
    // this.legOrderIndicator,
    // this.filledShares,
    // this.orderMsg,
    // this.modifiedBy,
  });

  String tradingsymbol;
  String price;
  String quantity;
  String orderstatus;
  String transactiontype;
  String ordertype;
  String priceNumerator;
  String generalNumerator;
  String priceDenominator;
  String generalDenominator;
  String lotsize;
  String exchange;
  String nestorderid;
  String nestreqid;
  String symbolname;
  String averageprice;
  String triggerprice;
  String disclosedquantity;
  dynamic exchangeorderid;
  String rejectionReason;
  String orderTime;
  String producttype;
  String reportType;
  String customerFirm;
  String exchangeTimestamp;
  String ordersource;
  dynamic filldateandtime;
  String orderGenerationType;
  String scripname;
  String legOrderIndicator;
  String filledshares;
  String orderMsg;
  String modifiedBy;

  // String stat;
  // String tradingsymbol;
  // String price;
  // String quantity;
  // String orderstatus;
  // String transactiontype;
  // String ordertype;
  // String priceNumerator;
  // String generalNumerator;
  // String priceDenominator;
  // String generalDenominator;
  // String lotQty;
  // String exchange;
  // String nestOrderid;
  // String nestReqid;
  // String symbolName;
  // String avgPrice;
  // String triggerPrice;
  // String disclosedQty;
  // dynamic exchangeOrderid;
  // String rejectionReason;
  // String orderTime;
  // String productCode;
  // String reportType;
  // String customerFirm;
  // String exchangeTimestamp;
  // String orderSource;
  // dynamic filldateandtime;
  // String orderGenerationType;
  // String scripname;
  // String legOrderIndicator;
  // String filledShares;
  // String orderMsg;
  // String modifiedBy;

  factory OrderHistoryDatum.fromJson(Map<String, dynamic> json) => OrderHistoryDatum(
    tradingsymbol: json["tradingsymbol"],
    price: json["price"],
    quantity: json["quantity"],
    orderstatus: json["orderstatus"],
    transactiontype: json["transactiontype"],
    ordertype: json["ordertype"],
    priceNumerator: json["price_numerator"],
    generalNumerator: json["general_numerator"],
    priceDenominator: json["price_denominator"],
    generalDenominator: json["general_denominator"],
    lotsize: json["lotsize"],
    exchange: json["exchange"],
    nestorderid: json["nestorderid"],
    nestreqid: json["nestreqid"],
    symbolname: json["symbolname"],
    averageprice: json["averageprice"],
    triggerprice: json["triggerprice"],
    disclosedquantity: json["disclosedquantity"],
    exchangeorderid: json["exchangeorderid"],
    rejectionReason: json["rejection_reason"],
    orderTime: json["order_time"],
    producttype: json["producttype"],
    reportType: json["report_type"],
    customerFirm: json["customer_firm"],
    exchangeTimestamp: json["exchange_timestamp"],
    ordersource: json["ordersource"],
    filldateandtime: json["filldateandtime"],
    orderGenerationType: json["order_generation_type"],
    scripname: json["scripname"],
    legOrderIndicator: json["leg_order_indicator"],
    filledshares: json["filledshares"],
    orderMsg: json["order_msg"],
    modifiedBy: json["modified_by"],
    // stat: json["stat"],
    // tradingsymbol: json["tradingsymbol"],
    // price: json["price"],
    // quantity: json["quantity"],
    // orderstatus: json["orderstatus"],
    // transactiontype: json["transactiontype"],
    // ordertype: json["ordertype"],
    // priceNumerator: json["price_numerator"],
    // generalNumerator: json["general_numerator"],
    // priceDenominator: json["price_denominator"],
    // generalDenominator: json["general_denominator"],
    // lotQty: json["lot_qty"],
    // exchange: json["exchange"],
    // nestOrderid: json["nest_orderid"],
    // nestReqid: json["nest_reqid"],
    // symbolName: json["symbol_name"],
    // avgPrice: json["avg_price"],
    // triggerPrice: json["trigger_price"],
    // disclosedQty: json["disclosed_qty"],
    // exchangeOrderid: json["exchange_orderid"],
    // rejectionReason: json["rejection_reason"],
    // orderTime: json["order_time"],
    // productCode: json["product_code"],
    // reportType: json["report_type"],
    // customerFirm: json["customer_firm"],
    // exchangeTimestamp: json["exchange_timestamp"],
    // orderSource: json["order_source"],
    // filldateandtime: json["filldateandtime"],
    // orderGenerationType: json["order_generation_type"],
    // scripname: json["scripname"],
    // legOrderIndicator: json["leg_order_indicator"],
    // filledShares: json["filled_shares"],
    // orderMsg: json["order_msg"],
    // modifiedBy: json["modified_by"],
  );

  Map<String, dynamic> toJson() => {
    "tradingsymbol": tradingsymbol,
    "price": price,
    "quantity": quantity,
    "orderstatus": orderstatus,
    "transactiontype": transactiontype,
    "ordertype": ordertype,
    "price_numerator": priceNumerator,
    "general_numerator": generalNumerator,
    "price_denominator": priceDenominator,
    "general_denominator": generalDenominator,
    "lotsize": lotsize,
    "exchange": exchange,
    "nestorderid": nestorderid,
    "nestreqid": nestreqid,
    "symbolname": symbolname,
    "averageprice": averageprice,
    "triggerprice": triggerprice,
    "disclosedquantity": disclosedquantity,
    "exchangeorderid": exchangeorderid,
    "rejection_reason": rejectionReason,
    "order_time": orderTime,
    "producttype": producttype,
    "report_type": reportType,
    "customer_firm": customerFirm,
    "exchange_timestamp": exchangeTimestamp,
    "ordersource": ordersource,
    "filldateandtime": filldateandtime,
    "order_generation_type": orderGenerationType,
    "scripname": scripname,
    "leg_order_indicator": legOrderIndicator,
    "filledshares": filledshares,
    "order_msg": orderMsg,
    "modified_by": modifiedBy,

// "stat": stat,
    // "tradingsymbol": tradingsymbol,
    // "price": price,
    // "quantity": quantity,
    // "orderstatus": orderstatus,
    // "transactiontype": transactiontype,
    // "ordertype": ordertype,
    // "price_numerator": priceNumerator,
    // "general_numerator": generalNumerator,
    // "price_denominator": priceDenominator,
    // "general_denominator": generalDenominator,
    // "lot_qty": lotQty,
    // "exchange": exchange,
    // "nest_orderid": nestOrderid,
    // "nest_reqid": nestReqid,
    // "symbol_name": symbolName,
    // "avg_price": avgPrice,
    // "trigger_price": triggerPrice,
    // "disclosed_qty": disclosedQty,
    // "exchange_orderid": exchangeOrderid,
    // "rejection_reason": rejectionReason,
    // "order_time": orderTime,
    // "product_code": productCode,
    // "report_type": reportType,
    // "customer_firm": customerFirm,
    // "exchange_timestamp": exchangeTimestamp,
    // "order_source": orderSource,
    // "filldateandtime": filldateandtime,
    // "order_generation_type": orderGenerationType,
    // "scripname": scripname,
    // "leg_order_indicator": legOrderIndicator,
    // "filled_shares": filledShares,
    // "order_msg": orderMsg,
    // "modified_by": modifiedBy,
  };
}
