import 'package:markets/model/jmModel/holdings.dart';
import 'package:markets/model/jmModel/tradeBook.dart';

import 'jmModel/orderBook.dart';
import 'jmModel/todaysPosition.dart';

class ExistingNewOrderDetails {
  bool isBuy = false, isSL = false, slTriggered = false, ahStatus = false;
  int qty = 0, tradedQty = 0, exchangeOrderId = 0, exchangeOrderTime = 0, scripCode, scripCode2, disclosedQty = 0, convertBuyQty, convertSellQty;
  String status = '', exch, orderId, isLimit, productType, validity, symboltoken, syomorderid, gtdValdate;
  double rate = 0, triggerRate = 0;

  ExistingNewOrderDetails.newOrderReport(orderDatum order, int precision) {
    /* Assigning new value to the old value of each order Report */
    this.isBuy = order.transactiontype == "BUY" ? true : false;
    this.isSL = order.ordertype.contains('STOPLOSS') ? true : false;
    this.slTriggered = order.status == "trigger pending" ? false : true;
    this.isLimit = order.ordertype;
    this.exch = order.model.exch;
    this.scripCode = order.model.exchCode;
    this.productType = order.producttype;
    this.validity = order.duration;
    this.disclosedQty = int.parse(order.disclosedquantity);
    this.qty = int.parse(order.quantity);
    this.tradedQty = int.parse(order.filledshares);
    this.rate = double.parse(double.parse(order.price).toStringAsFixed(precision));
    this.triggerRate = double.parse(double.parse(order.triggerprice).toStringAsFixed(precision));
    this.status = order.status;
    this.exchangeOrderId = order.exchorderid == "NA" ? 0 : int.parse(order.exchorderid);
    this.orderId = order.orderid;
    this.syomorderid = order.syomorderid;
    this.gtdValdate = order.gtdValdate;
  }

  ExistingNewOrderDetails.tradeReport(tradebookDatum order, int precision) {
    /* Assigning new value to the old value of each order Report */
    // this.isBuy = order.transactiontype == "BUY" ? true : false;
    // this.isSL = order.ordertype.contains('STOPLOSS') ? true : false;
    // this.slTriggered = order.status == "trigger pending" ? false : true;
    // this.isLimit = order.ordertype;
    // this.exch = order.model.exch;
    // this.scripCode = order.model.exchCode;
    // this.productType = order.producttype;
    // this.validity = order.duration;
    // this.disclosedQty = int.parse(order.disclosedquantity);
    this.qty = order.quantity;
    // this.tradedQty = int.parse(order.filledshares);
    // this.rate = double.parse(double.parse(order.price).toStringAsFixed(precision));
    // this.triggerRate = double.parse(double.parse(order.triggerprice).toStringAsFixed(precision));
    // this.status = order.status;
    // this.exchangeOrderId = order.exchorderid == "NA" ? 0 : int.parse(order.exchorderid);
    // this.orderId = order.orderid;
    // this.syomorderid = order.syomorderid;
    // this.gtdValdate = order.gtdValdate;
  }

  ExistingNewOrderDetails.positionReport(var order) {
    /* Assigning new value to the old value of each position Report */
    this.isBuy = int.tryParse(order.netqty) < 0 ? true : false;
    this.productType = order.producttype;
    this.exch = order.model.exch;
    this.scripCode = order.model.exchCode;
    this.qty = int.tryParse(order.netqty).abs();
    this.symboltoken = order.symboltoken;
    this.validity = 'DAY';
    this.convertBuyQty = int.parse(order.netqty) > 0 ? int.tryParse(order.netqty).abs() : int.tryParse(order.buyqty).abs();
    this.convertSellQty = int.parse(order.netqty) < 0 ? int.tryParse(order.netqty).abs() : int.tryParse(order.sellqty).abs();
  }

  ExistingNewOrderDetails.holdingReport(HoldingDatum order, bool isBuy) {
    /* Assigning new value to the old value of each holding Report */
    this.productType = order.product;
    this.validity = 'DAY';
    /* if buy then calculating buy quantity by excluding sell quantity from total quantity */
    if (isBuy)
      this.qty = int.parse(order.quantity) - int.parse(order.realisedquantity);
    else
      /* Else assigning by total quantity */
      /* IDK the logic is correct some how and its working */
      this.qty = int.parse(order.quantity);
  }
}
