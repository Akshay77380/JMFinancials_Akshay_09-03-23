import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/orderHistoryController.dart';
import '../../model/jmModel/orderBook.dart';
import '../../model/jmModel/order_history.dart';
import '../../model/jmModel/tradeBook.dart';
import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../mainScreen/MainScreen.dart';

class OrderTrail extends StatefulWidget {
  final orderDatum order;
  final tradebookDatum tradeOrder;
  final isPartial;

  OrderTrail({this.order, this.tradeOrder, this.isPartial});

  @override
  State<OrderTrail> createState() => _OrderTrailState();
}

class _OrderTrailState extends State<OrderTrail> {
  var orderData;

  @override
  void initState() {
    widget.order == null ? orderData = widget.tradeOrder : orderData = widget.order;
    Dataconstants.orderHistoryController.fetchOrderHistory(orderData.orderid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: Text(
          "Order Trail",
          style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
        ),
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                CommonFunction.marketWatchBottomSheet(context);
              },
              child: SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  widget.order == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /* Displaying the Script name */
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: orderData.transactiontype == 'BUY' ? Utils.brightGreenColor : Utils.brightRedColor),
                              child: Text(
                                orderData.transactiontype,
                                style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                            /* Displaying the Script Description */
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.brightGreenColor.withOpacity(0.2)),
                              child: Text(
                                widget.isPartial ? 'PARTIALLY EXECUTED' : 'EXECUTED',
                                style: Utils.fonts(color: Utils.brightGreenColor, size: 10.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /* Displaying the Script name */
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: orderData.transactiontype == 'BUY' ? Utils.brightGreenColor : Utils.brightRedColor),
                              child: Text(
                                orderData.transactiontype,
                                style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                            /* Displaying the Script Description */
                            if (widget.order.status == 'trigger pending')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.brightGreenColor.withOpacity(0.2)),
                                child: Text(
                                  'TRIGGER PENDING',
                                  style: Utils.fonts(color: Utils.brightGreenColor, size: 10.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (widget.order.status == 'complete')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.brightGreenColor.withOpacity(0.2)),
                                child: Text(
                                  'EXECUTED',
                                  style: Utils.fonts(color: Utils.brightGreenColor, size: 10.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (widget.order.status == 'open')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.primaryColor.withOpacity(0.2)),
                                child: Text(
                                  'PENDING',
                                  style: Utils.fonts(color: Utils.primaryColor, size: 10.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (widget.order.status == 'rejected')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.brightRedColor.withOpacity(0.2)),
                                child: Text(
                                  'REJECTED',
                                  style: Utils.fonts(color: Utils.brightRedColor, size: 10.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (widget.order.status == 'cancelled')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.greyColor.withOpacity(0.2)),
                                child: Text(
                                  'CANCELLED',
                                  style: Utils.fonts(color: Utils.greyColor, size: 10.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                          ],
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orderData.model.name.toUpperCase(), style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                      widget.order == null
                          ? Text((widget.isPartial ? widget.tradeOrder.fillsize + '/' + widget.tradeOrder.quantity.toString() : widget.tradeOrder.fillsize) + ' @ ' + widget.tradeOrder.fillprice, style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor))
                          : Text(widget.order.filledshares + '/' + '${int.tryParse(widget.order.unfilledshares) + int.tryParse(widget.order.filledshares)}' + ' @ ' + widget.order.price,
                              style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  // /* Displaying the Script Description */
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: orderData.exchange == 'NSE'
                                ? orderData.exchange.toUpperCase() + '-EQ'
                                : orderData.exchange == 'BSE'
                                    ? orderData.exchange.toUpperCase() + '-EQ'
                                    : orderData.expirydate.split(',')[0].toUpperCase(),
                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                            children: [
                              if (orderData.model.exchCategory != ExchCategory.nseEquity || orderData.model.exchCategory != ExchCategory.bseEquity) TextSpan(text: ' '),
                              if (orderData.model.exchCategory != ExchCategory.nseEquity || orderData.model.exchCategory != ExchCategory.bseEquity)
                                TextSpan(
                                  text: orderData.model.exchCategory == ExchCategory.nseFuture ||
                                          orderData.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                          orderData.model.exchCategory == ExchCategory.currenyFutures ||
                                          orderData.model.exchCategory == ExchCategory.mcxFutures
                                      ? 'FUT'
                                      : orderData.model.exchCategory == ExchCategory.nseOptions ||
                                              orderData.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                              orderData.model.exchCategory == ExchCategory.currenyOptions ||
                                              orderData.model.exchCategory == ExchCategory.mcxOptions
                                          ? orderData.strikeprice.split('.')[0]
                                          : '',
                                  style: Utils.fonts(
                                      size: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: orderData.model.exchCategory == ExchCategory.nseFuture ||
                                              orderData.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                              orderData.model.exchCategory == ExchCategory.currenyFutures ||
                                              orderData.model.exchCategory == ExchCategory.mcxFutures
                                          ? Utils.primaryColor
                                          : Utils.greyColor),
                                ),
                              if (orderData.model.exchCategory == ExchCategory.nseOptions ||
                                  orderData.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                  orderData.model.exchCategory == ExchCategory.currenyOptions ||
                                  orderData.model.exchCategory == ExchCategory.mcxOptions)
                                TextSpan(text: ' '),
                              if (orderData.model.exchCategory == ExchCategory.nseOptions ||
                                  orderData.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                  orderData.model.exchCategory == ExchCategory.currenyOptions ||
                                  orderData.model.exchCategory == ExchCategory.mcxOptions)
                                TextSpan(
                                  text: orderData.model.cpType == 3 ? 'CE' : 'PE',
                                  style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: orderData.model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
                                )
                            ]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(height: 3, width: 3, decoration: BoxDecoration(color: Utils.greyColor, shape: BoxShape.circle)),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(orderData.producttype.toUpperCase(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Spacer(),
                      Text('JMF Order ${orderData.orderid}', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    ],
                  ),
                  Obx(() {
                    return OrderHistoryController.isLoading.value
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ))
                        : OrderHistoryController.orderHistoryListItems.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: CustomTabBarScrollPhysics(),
                                itemCount: OrderHistoryController.orderHistoryListItems.length,
                                reverse: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return trailDetailsRow(OrderHistoryController.orderHistoryListItems[index]);
                                },
                              )
                            : Center(
                                child: Text(
                                  "No records found",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              );
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget trailDetailsRow(OrderHistoryDatum orderHistoryDatum) {
    // //print("Order: ${widget.order}");
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            orderHistoryDatum.orderstatus.toUpperCase(),
            style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1,child: trailDetailsElement('DQ', orderHistoryDatum.disclosedquantity, CrossAxisAlignment.start)),
            Expanded(flex: 1,child: trailDetailsElement('Quantity', orderHistoryDatum.quantity, CrossAxisAlignment.center),),
            Expanded(flex: 1,child: trailDetailsElement('Trigger Price', orderHistoryDatum.triggerprice, CrossAxisAlignment.end),)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1,child: trailDetailsElement('Price', orderHistoryDatum.price, CrossAxisAlignment.start)),
            Expanded(flex: 1,child: trailDetailsElement('Traded Quantity', orderHistoryDatum.filledshares, CrossAxisAlignment.center),),
            Expanded(flex: 1,child: trailDetailsElement('Traded value', (double.parse(orderHistoryDatum.averageprice.replaceAll(',', '')) * int.parse(orderHistoryDatum.filledshares)).toStringAsFixed(2), CrossAxisAlignment.end),)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            trailDetailsElement('Exchange order', orderHistoryDatum.exchangeorderid == null ? "--" : orderHistoryDatum.exchangeorderid, CrossAxisAlignment.start),
            trailDetailsElement('Validity', orderHistoryDatum.orderTime, CrossAxisAlignment.center),
            trailDetailsElement('Order type', orderHistoryDatum.ordertype, CrossAxisAlignment.end),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            trailDetailsElement(
                'Date and Time',
                orderHistoryDatum.orderstatus == 'complete'
                    ? orderHistoryDatum.filldateandtime == null
                        ? "--"
                        : orderHistoryDatum.filldateandtime
                    : orderHistoryDatum.exchangeTimestamp,
                CrossAxisAlignment.start),
          ],
        ),
        Visibility(
            visible: orderHistoryDatum.orderstatus == 'rejected',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Rejection Reason',
                  style: Utils.fonts(color: Utils.greyColor, size: 11.0, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 5,
                ),

                Text(
                  orderHistoryDatum.rejectionReason,
                  style: Utils.fonts(color: Colors.black, size: 13.0, fontWeight: FontWeight.w400),
                ),

                const SizedBox(
                  height: 5,
                ),

                Divider(
                  thickness: 3,
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     trailDetailsElement('Rejection Reason', orderHistoryDatum.rejectionReason == null ? "--" : orderHistoryDatum.rejectionReason, CrossAxisAlignment.start),
                //   ],
                // ),
              ],
            ))
      ],
    );
  }

  Widget trailDetailsElement(String title, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: Utils.fonts(color: Colors.black, size: 13.0, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
