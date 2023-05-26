import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/addFunds/AddFunds.dart';
import '../../model/existingOrderDetails.dart';
import '../../model/jmModel/orderBook.dart';
import '../../model/jmModel/tradeBook.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/JMOrderPlacedAnimationScreen.dart';
import '../../screens/scrip_details_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../addFunds/AddMoney.dart';
import 'OrderPlacement/order_placement_screen.dart';
import 'order_trail.dart';

class OrderDetails extends StatefulWidget {
  final orderDatum order;

  OrderDetails(this.order);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool status;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    if (widget.order.status == 'cancelled' || widget.order.status == 'rejected')
      status = false;
    else
      status = true;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: widget.order.status == 'cancelled'
            ? MediaQuery.of(context).size.height - 270
            : widget.order.status == 'rejected'
                ? MediaQuery.of(context).size.height - 120
                : MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Detail",
                            style: Utils.fonts(size: 18.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  "CLOSE",
                                  style: Utils.fonts(size: 14.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "QTY",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 12.0,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                widget.order.quantity,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "AVG PRICE",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.order.ordertype == 'LIMIT' ? widget.order.price : widget.order.averageprice,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "STATUS",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              if (widget.order.status == 'open' || widget.order.status == 'open pending' || widget.order.status == 'validation pending')
                                Text(
                                  'PENDING',
                                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                                ),
                              if (widget.order.status == 'trigger pending')
                                Text(
                                  'TRIGGER PENDING',
                                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                                ),
                              if (widget.order.status == 'rejected')
                                Text(
                                  'REJECT',
                                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.mediumRedColor),
                                ),
                              if (widget.order.status == 'cancelled')
                                Text(
                                  'CANCEL',
                                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.greyColor),
                                ),
                              if (widget.order.status.toLowerCase().contains('after market order'))
                                Text(
                                  'AMO PENDING',
                                  style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                                ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text("STOCK YOU ${widget.order.transactiontype.toUpperCase()}", style: Utils.fonts(size: 13.0, )),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                        widget.order.model.exchCategory == ExchCategory.nseEquity || widget.order.model.exchCategory == ExchCategory.bseEquity
                                            ? widget.order.model.name
                                            : widget.order.model.desc,
                                        maxLines: 1,
                                        style: Utils.fonts(size: 20.0, fontWeight: FontWeight.w700)),
                                  ),
                                  Observer(
                                      builder: (_) => Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(widget.order.model.close == 0.00 ? widget.order.model.prevDayClose.toStringAsFixed(widget.order.model.precision) : widget.order.model.close.toStringAsFixed(widget.order.model.precision),
                                                    style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${widget.order.model.close == 0.00 ? "0.00" : widget.order.model.priceChangeText}" + " " + "${widget.order.model.close == 0.00 ? "(0.00%)" : widget.order.model.percentChangeText}",
                                                    style: Utils.fonts(
                                                        color: widget.order.model.percentChange > 0
                                                            ? Utils.mediumGreenColor
                                                            : widget.order.model.percentChange < 0
                                                                ? Utils.mediumRedColor
                                                                : theme.errorColor,
                                                        size: 12.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Icon(
                                                      widget.order.model.close > widget.order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                      color: widget.order.model.percentChange > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if (widget.order.status == 'open' ||
                          widget.order.status == 'trigger pending' ||
                          widget.order.status == 'validation pending' ||
                          widget.order.status == 'open pending' ||
                          widget.order.status.toLowerCase().contains('after market order'))
                        pendingDetails()
                      else if (widget.order.status == 'cancelled' || widget.order.status == 'rejected')
                        cancelRejectDetails(),
                      if (widget.order.status == 'rejected')
                        Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Utils.greyColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("REJECTION REASON", style: Utils.fonts(size: 13.0)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Text("${widget.order.text}", style: Utils.fonts(size: 12.0, color: Utils.mediumRedColor), textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              if (widget.order.status != 'complete')
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      // Dataconstants.orderHistoryController.fetchOrderHistory(widget.order.orderid);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrail(order: widget.order, isPartial: false,)));
                                    },
                                    child: Center(child: Text("VIEW", style: Utils.fonts(size: 14.0, color: Utils.greyColor))),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Utils.greyColor,
                                  thickness: 2,
                                ),
                                if (!status)
                                  Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFunds()));
                                        },
                                        child: Center(child: Text("ADD FUNDS", style: Utils.fonts(size: 14.0, color: Utils.greyColor)))),
                                  )
                                else
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        if (widget.order.producttype == 'COVER') {
                                          var jsons = {
                                            "orderid": widget.order.orderid,
                                          };
                                          log(jsons.toString());
                                          var response = await CommonFunction.exitCoverOrder(jsons);
                                          //log("cancel Order Response => $response");
                                          try {
                                            var responseJson = json.decode(response.toString());
                                            if (responseJson["status"] == false) {
                                              CommonFunction.showBasicToast(responseJson["emsg"]);
                                            } else {
                                              HapticFeedback.vibrate();
                                              var data = await showDialog(
                                                context: context,
                                                builder: (_) => Material(
                                                  type: MaterialType.transparency,
                                                  child: OrderPlacedAnimationScreen('Order Cancelled'),
                                                ),
                                              );
                                              if (data['result'] == true) {
                                                Navigator.of(context).pop();
                                                Dataconstants.orderBookData.fetchOrderBook();
                                              }
                                            }
                                          } catch (e) {}
                                        }
                                        else if (widget.order.producttype == 'BRACKET') {
                                          var jsons = {
                                            "orderid": widget.order.orderid,
                                            "SyomOrderId": widget.order.syomorderid,
                                            "Status": widget.order.status
                                          };
                                          log(jsons.toString());
                                          var response = await CommonFunction.exitBracketOrder(jsons);
                                          //log("exit bracket Order Response => $response");
                                          try {
                                            var responseJson = json.decode(response.toString());
                                            if (responseJson["status"] == false) {
                                              CommonFunction.showBasicToast(responseJson["emsg"]);
                                            } else {
                                              HapticFeedback.vibrate();
                                              var data = await showDialog(
                                                context: context,
                                                builder: (_) => Material(
                                                  type: MaterialType.transparency,
                                                  child: OrderPlacedAnimationScreen('Order Cancelled'),
                                                ),
                                              );
                                              if (data['result'] == true) {
                                                Navigator.of(context).pop();
                                                Dataconstants.orderBookData.fetchOrderBook();
                                              }
                                            }
                                          } catch (e) {}
                                        }
                                        else {
                                          var jsons = {
                                            "orderid": widget.order.orderid,
                                          };
                                          log(jsons.toString());
                                          var response = await CommonFunction.cancelOrder(jsons);
                                          //log("cancel Order Response => $response");
                                          try {
                                            var responseJson = json.decode(response.toString());
                                            if (responseJson["status"] == false) {
                                              CommonFunction.showBasicToast(responseJson["emsg"]);
                                            } else {
                                              HapticFeedback.vibrate();
                                              var data = await showDialog(
                                                context: context,
                                                builder: (_) => Material(
                                                  type: MaterialType.transparency,
                                                  child: OrderPlacedAnimationScreen('Order Cancelled'),
                                                ),
                                              );
                                              if (data['result'] == true) {
                                                Navigator.of(context).pop();
                                                Dataconstants.orderBookData.fetchOrderBook();
                                              }
                                            }
                                          } catch (e) {}
                                        }
                                      },
                                      child: Center(child: Text("CANCEL", style: Utils.fonts(size: 14.0, color: Utils.greyColor))),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!status)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderPlacementScreen(
                                  model: widget.order.model,
                                  orderType: ScripDetailType.none,
                                  isBuy: widget.order.transactiontype == "BUY" ? true : false,
                                  selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                  stream: Dataconstants.pageController.stream,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width,
                            color: Utils.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text("RETRY", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => OrderPlacementScreen(
                                        model: widget.order.model,
                                        orderType: ScripDetailType.modify,
                                        // orderModel: widget.order,
                                        orderData: widget.order,
                                        isBuy: widget.order.transactiontype == "BUY" ? true : false,
                                        orderModel: ExistingNewOrderDetails.newOrderReport(
                                            widget.order,
                                            widget.order.model.precision
                                        ),
                                        stream: Dataconstants.pageController.stream,
                                      )),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width,
                            color: Utils.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text("MODIFY", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget pendingDetails() {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trading ID", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.tradingsymbol, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Type", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.ordertype, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.producttype, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trigger Price", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.triggerprice, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Remaining Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.unfilledshares, style: Utils.fonts(size: 12.0))]
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Executed Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.filledshares, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Disclosed Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.disclosedquantity, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date and Time", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.exchtime, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Internal Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.orderid, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Exchange Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(widget.order.exchorderid, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
          ],
        ),
      ],
    );
  }

  Widget cancelRejectDetails() {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Type", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.ordertype, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.producttype, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Internal Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.orderid, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Exchange Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.exchorderid, style: Utils.fonts(size: 12.0))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date and Time", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(widget.order.exchtime, style: Utils.fonts(size: 12.0))
          ],
        ),
      ],
    );
  }
}

class ExecutedOrderDetails extends StatefulWidget {
  final tradebookDatum order;
  final bool isPartial;

  ExecutedOrderDetails(this.order, this.isPartial);

  @override
  State<ExecutedOrderDetails> createState() => _ExecutedOrderDetailsState();
}

class _ExecutedOrderDetailsState extends State<ExecutedOrderDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Details",
                            style: Utils.fonts(size: 18.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  "CLOSE",
                                  style: Utils.fonts(size: 14.0, color: Utils.blackColor),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "QTY",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.isPartial ? widget.order.fillsize + '/' + widget.order.quantity.toString() : widget.order.fillsize,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "AVG PRICE",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.order.fillprice,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "STATUS",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.isPartial ? 'PARTIALLY\nEXECUTED' : 'EXECUTED',
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.mediumGreenColor),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text("STOCK YOU ${widget.order.transactiontype.toUpperCase()}", style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                        widget.order.model.exchCategory == ExchCategory.nseEquity || widget.order.model.exchCategory == ExchCategory.bseEquity
                                            ? widget.order.model.name
                                            : widget.order.model.desc,
                                        maxLines: 1,
                                        style: Utils.fonts(size: 20.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                  ),
                                  Observer(
                                      builder: (_) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(widget.order.model.close == 0.00 ? widget.order.model.prevDayClose.toStringAsFixed(widget.order.model.precision) : widget.order.model.close.toStringAsFixed(widget.order.model.precision),
                                                style: Utils.fonts(size: 16.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${widget.order.model.close == 0.00 ? "0.00" : widget.order.model.priceChangeText}" + " " + "${widget.order.model.close == 0.00 ? "(0.00%)" : widget.order.model.percentChangeText}",
                                                style: Utils.fonts(
                                                    color: widget.order.model.percentChange > 0
                                                        ? Utils.mediumGreenColor
                                                        : widget.order.model.percentChange < 0
                                                        ? Utils.mediumRedColor
                                                        : theme.errorColor,
                                                    size: 12.0,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(0.0),
                                                child: widget.order.model.percentChange >= 0 ? RotatedBox(
                                                  quarterTurns: 4,
                                                  child: Icon(
                                                    widget.order.model.close > widget.order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                    color: widget.order.model.close > widget.order.model.prevTickRate ? Utils.mediumGreenColor : Utils.mediumRedColor,
                                                  ),
                                                ) : RotatedBox(
                                                  quarterTurns: 2,
                                                  child: Icon(
                                                    widget.order.model.close > widget.order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                    color: widget.order.model.percentChange >= 0 ? Utils.mediumGreenColor : Utils.mediumRedColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      executedDetails(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Utils.primaryColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Utils.whiteColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Center(child: Text("VIEW", style: Utils.fonts(size: 14.0, color: Utils.greyColor))),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrail(tradeOrder: widget.order, isPartial: widget.isPartial ? true : false,)));
                                  },
                                ),
                              ),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              Expanded(
                                child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return OrderPlacementScreen(
                                              model: widget.order.model,
                                              orderType: ScripDetailType.none,
                                              isBuy: widget.order.transactiontype == 'BUY' ? true : false,
                                              selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                              stream: Dataconstants.pageController.stream,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Center(child: Text("ADD MORE", style: Utils.fonts(size: 14.0, color: Utils.greyColor)))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (widget.order.producttype == 'COVER') {
                          CommonFunction.showBasicToastForJm('Cannot set Stop loss for Cover orders');
                          return;
                        }
                        if (widget.order.producttype == 'BRACKET') {
                          CommonFunction.showBasicToastForJm('Cannot set Stop loss for Bracket orders');
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderPlacementScreen(
                              model: widget.order.model,
                              orderType: ScripDetailType.setStopLoss,
                              isBuy: widget.order.transactiontype == "BUY" ? false : true,
                              selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                              stream: Dataconstants.pageController.stream,
                              orderModel: ExistingNewOrderDetails.tradeReport(widget.order, widget.order.model.precision),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("SET STOP LOSS", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget executedDetails() {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Traded Value", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text((double.parse(widget.order.tradevalue.replaceAll(",", "")) * int.parse(widget.order.fillsize)).toStringAsFixed(2), style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.producttype, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Internal Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.orderid, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Exchange Ord. No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.exchorderid, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Exchange Trade No", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Text(widget.order.fillid, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date and Time", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text('${DateFormat('dd-MMM-yyyy').format(DateTime.now())}' + ' ' + widget.order.filltime, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
          ],
        ),
      ],
    );
  }
}
