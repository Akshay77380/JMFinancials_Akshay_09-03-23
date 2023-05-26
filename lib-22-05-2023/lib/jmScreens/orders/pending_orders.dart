import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/orderBookController.dart';
import '../../model/jmModel/orderBook.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'order_details.dart';

class PendingOrders extends StatefulWidget {
  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  bool cancelLoading = false;

  @override
  void initState() {
    Dataconstants.showCancelAll = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Obx(
            () {
              if (OrderBookController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else
                return RefreshIndicator(
                    color: theme.primaryColor,
                    onRefresh: () {
                      Dataconstants.orderBookData.fetchOrderBook();
                      return Future.value(true);
                    },
                    child: OrderBookController.pendingList.length == 0
                        ? OrderBookController.isOrderBookSearch.value && OrderBookController.pendingLength != 0
                            ? Center(
                                child: Text(
                                  "No records found",
                                  style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset('assets/appImages/noOrders.svg'),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "You have no Pending Orders in Order Book",
                                        style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          color: theme.primaryColor,
                                          padding: EdgeInsets.symmetric(horizontal: 50),
                                          child: Text(
                                            'GO TO WATCHLIST',
                                            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            InAppSelection.mainScreenIndex = 1;
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (_) => MainScreen(
                                                      toChangeTab: false,
                                                    )));
                                          })
                                    ],
                                  ),
                                ),
                              )
                        : Obx(() {
                            if (OrderBookController.isLoading.value == true)
                              return CircularProgressIndicator();
                            else
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: OrderBookController.pendingList.length,
                                      itemBuilder: (ctx, index) => PendingOrderRow(
                                        key: ObjectKey(OrderBookController.pendingList[index]),
                                        order: OrderBookController.pendingList[index],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CommonFunction.message('That’s all we have for you today'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    if (OrderBookController.pendingList.length > 1)
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    if (OrderBookController.pendingList.length > 1)
                                      GestureDetector(
                                        onTap: () async {
                                          if (Dataconstants.showCancelAll == false) {
                                            setState(() {
                                              Dataconstants.showCancelAll = true;
                                            });
                                          } else {
                                            setState(() {
                                              // cancelLoading = true;
                                              Dataconstants.showCancelAll = false;
                                            });
                                            // if (cancelLoading == true) {
                                            //   // showDialog(
                                            //   //   context: context,
                                            //   //   builder: (_) => Material(
                                            //   //     type: MaterialType.transparency,
                                            //   //     child: Center(child: CircularProgressIndicator()),
                                            //   //   ),
                                            //   // );
                                            // }
                                            OrderBookController.pendingList.forEach((element) async {
                                              if (element.producttype == 'COVER') {
                                                if (element.cancel) {
                                                  var jsons = {
                                                    "orderid": element.orderid,
                                                  };
                                                  // log('cancel Order Response => ${jsons.toString()}');
                                                  var response = await CommonFunction.exitCoverOrder(jsons);
                                                  //log("cancel Order Response => $response");
                                                  try {
                                                    var responseJson = json.decode(response.toString());
                                                    if (responseJson["status"] == false) {
                                                      CommonFunction.showBasicToast(responseJson["emsg"]);
                                                    } else {
                                                      Dataconstants.orderBookData.fetchOrderBook();
                                                    }
                                                  } catch (e) {}
                                                }
                                              } else if (element.producttype == 'BRACKET') {
                                                if(element.cancel){
                                                  var jsons = {"orderid": element.orderid, "SyomOrderId": element.syomorderid, "Status": element.status};
                                                  var response = await CommonFunction.exitBracketOrder(jsons);
                                                  try {
                                                    var responseJson = json.decode(response.toString());
                                                    if (responseJson["status"] == false) {
                                                      CommonFunction.showBasicToast(responseJson["emsg"]);
                                                    } else {
                                                      Dataconstants.orderBookData.fetchOrderBook();
                                                    }
                                                  } catch (e) {}
                                                }
                                              } else {
                                                if (element.cancel) {
                                                  var jsons = {
                                                    "orderid": element.orderid,
                                                  };
                                                  // log('cancel Order Response => ${jsons.toString()}');
                                                  var response = await CommonFunction.cancelOrder(jsons);
                                                  //log("cancel Order Response => $response");
                                                  try {
                                                    var responseJson = json.decode(response.toString());
                                                    if (responseJson["status"] == false) {
                                                      CommonFunction.showBasicToast(responseJson["emsg"]);
                                                    } else {
                                                      Dataconstants.orderBookData.fetchOrderBook();
                                                    }
                                                  } catch (e) {}
                                                }
                                              }
                                            });
                                            // Dataconstants.orderBookData.fetchOrderBook();
                                            // setState(() {
                                            //   cancelLoading = false;
                                            // });
                                            // Navigator.of(context).pop();
                                            //     .then((value) {
                                            //   // setState(() {
                                            //   cancelLoading = false;
                                            //   // });
                                            //   Navigator.of(context).pop();
                                            // });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Dataconstants.showCancelAll == true ? Utils.primaryColor : Utils.primaryColor.withOpacity(0.2),
                                                  ),
                                                  child: Text(
                                                    Dataconstants.showCancelAll == true ? 'Cancel All (${OrderBookController.cancelCount})' : 'Cancel All',
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Dataconstants.showCancelAll == true ? Utils.whiteColor : Utils.primaryColor),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                          }));
            },
          ),
        ),
      ],
    );
  }
}

class PendingOrderRow extends StatefulWidget {
  final orderDatum order;

  PendingOrderRow({Key key, @required this.order}) : super(key: key);

  @override
  State<PendingOrderRow> createState() => _PendingOrderRowState();
}

class _PendingOrderRowState extends State<PendingOrderRow> {
  @override
  Widget build(BuildContext context) {
    var scripName = widget.order.tradingsymbol.split('-');
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        children: [
          if (Dataconstants.showCancelAll)
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: Utils.primaryColor,
                value: widget.order.cancel,
                shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                onChanged: (value) {
                  setState(() {
                    widget.order.cancel = value;
                    OrderBookController.cancelCount.value = OrderBookController.pendingList.where((element) => element.cancel == true).toList().length;
                  });
                },
              ),
            ),
          if (Dataconstants.showCancelAll)
            const SizedBox(
              width: 8,
            ),
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => OrderDetails(widget.order));
              },
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* Displaying the Script name */
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: widget.order.transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                            child: Text(
                              widget.order.transactiontype,
                              style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Utils.primaryColor.withOpacity(0.2)),
                            child: Text(
                              widget.order.status.toUpperCase() == 'OPEN' ? 'PENDING' : widget.order.status.toUpperCase(),
                              style: Utils.fonts(
                                  color: widget.order.status == 'complete' || widget.order.status == 'partially executed'
                                      ? ThemeConstants.buyColor
                                      : widget.order.status == 'rejected'
                                      ? ThemeConstants.sellColor
                                      : widget.order.status == 'open' ? Utils.primaryColor  : Utils.greyColor,
                                  size: 10.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                          /* Displaying the Script Description */
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(scripName[0].toUpperCase(),
                          Text(widget.order.model.name.toUpperCase(), style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                          Text(
                              widget.order.filledshares +
                                  '/' +
                                  '${int.tryParse(widget.order.unfilledshares) + int.tryParse(widget.order.filledshares)}' +
                                  ' @ ' +
                                  // '${widget.order.ordertype == 'STOPLOSS_MARKET'
                                  //     ? widget.order.averageprice : widget.order.status == "TRIGGER PENDING" ? widget.order.triggerprice : widget.order.price}',
                                  '${
                                      widget.order.status == "trigger pending"
                                      ? widget.order.triggerprice
                                      : widget.order.price
                                  }',

                              style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                        ],
                      ),
                      // /* Displaying the Script Description */
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: widget.order.exchange == 'NSE'
                                    ? widget.order.exchange.toUpperCase()
                                    : widget.order.exchange == 'BSE'
                                        ? widget.order.exchange.toUpperCase()
                                        : widget.order.expirydate.split(',')[0].toUpperCase(),
                                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                children: [
                                  if (widget.order.model.exchCategory != ExchCategory.nseEquity || widget.order.model.exchCategory != ExchCategory.bseEquity) TextSpan(text: ' '),
                                  if (widget.order.model.exchCategory != ExchCategory.nseEquity || widget.order.model.exchCategory != ExchCategory.bseEquity)
                                    TextSpan(
                                      text: widget.order.model.exchCategory.name.toLowerCase().contains('future')
                                          ? 'FUT'
                                          : widget.order.model.exchCategory.name.toLowerCase().contains('option')
                                              ? widget.order.strikeprice.split('.')[0]
                                              : '',
                                      style: Utils.fonts(
                                          size: 12.0, fontWeight: FontWeight.w400, color: widget.order.model.exchCategory.name.toLowerCase().contains('future') ? Utils.primaryColor : Utils.greyColor),
                                    ),
                                  if (widget.order.model.exchCategory.name.toLowerCase().contains('option')) TextSpan(text: ' '),
                                  if (widget.order.model.exchCategory.name.toLowerCase().contains('option'))
                                    TextSpan(
                                      text: widget.order.model.cpType == 3 ? 'CE' : 'PE',
                                      style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: widget.order.model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
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
                          Text(widget.order.producttype.toUpperCase(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Spacer(),
                          Observer(
                            builder: (_) => Row(
                              children: [
                                Text("LTP", style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.order.model.close == 0.00
                                      ? widget.order.model.prevDayClose.toStringAsFixed(widget.order.model.precision)
                                      : widget.order.model.close.toStringAsFixed(widget.order.model.precision),
                                  style: Utils.fonts(
                                      // color: widget.order.model.close > widget.order.model.prevTickRate
                                      //     ? Utils.mediumGreenColor
                                      //     : widget.order.model.close < widget.order.model.prevTickRate
                                      //         ? Utils.mediumRedColor
                                      //         : Utils.greyColor,
                                      color: widget.order.model.percentChange > 0 ? Utils.lightGreenColor :Utils.lightRedColor,
                                      size: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  // child: Icon(
                                  //   order.model.close > order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                  //   color: order.model.close > order.model.prevTickRate ? Utils.mediumGreenColor : Utils.mediumRedColor,
                                  // )
                                  child: widget.order.model.percentChange > 0 ? Icon(
                                    Icons.arrow_drop_up_rounded ,
                                    color:   Utils.lightGreenColor,
                                  ) : Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Utils.mediumRedColor,
                                  )
                                  ,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // /* Displaying the Script buy sell status */
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusContainer(String status, ThemeData theme) {
    Color clr;
    switch (status) {
      case 'EXECUTED':
        clr = ThemeConstants.buyColor;
        break;
      case 'CANCELLED':
        status = 'CANCELLED';
        clr = theme.primaryColor;
        break;
      case 'AH PENDING':
        /* BOB want to show AMO PENDING status insted of AH PENDING status */
        status = 'AMO PENDING';
        clr = theme.primaryColor;
        break;
      case 'Pending':
        /* Getting unexpected Pending status in lower case from model,
           hence showing PENDING in caps */
        status = 'PENDING';
        clr = theme.primaryColor;
        break;
      case 'PARTLY EXECUTED':
        /* BOB want to show PARTIALLY EXECUTED status insted of PARTLY EXECUTED status */
        status = 'PARTIALLY EXECUTED';
        clr = theme.primaryColor;
        break;
      case 'AH CANCELLED':
        clr = ThemeConstants.sellColor;
        /* BOB want to show AMO CANCELLED status insted of AH CANCELLED status */
        status = 'AMO CANCELLED';
        break;
      case 'REJECTED':
        clr = ThemeConstants.sellColor;
        break;
      case 'AH PLACED|0':
        /* Getting unexpected AH PLACED|0 status from database,
           actually its AMO PENDING hence showing AMO PENDING */
        status = 'AMO PENDING';
        clr = theme.primaryColor;
        break;
      default:
        if (status.contains('REJECTED'))
          clr = ThemeConstants.sellColor;
        else
          clr = theme.primaryColor;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 7,
      ),
      color: clr.withOpacity(0.2),
      child: Text(status,
          style: Utils.fonts(
            size: 13.0,
            fontWeight: FontWeight.w400,
            color: clr,
          )
          // TextStyle(
          //   color: clr,
          // ),
          ),
    );
  }
}
