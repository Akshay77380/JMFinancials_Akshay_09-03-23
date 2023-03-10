import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/orderBookController.dart';
import '../../controllers/tradeBookController.dart';
import '../../model/jmModel/orderBook.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'order_details.dart';

class ExecutedOrders extends StatefulWidget {
  @override
  _ExecutedOrdersState createState() => _ExecutedOrdersState();
}

class _ExecutedOrdersState extends State<ExecutedOrders> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Expanded(child: Obx(() {
          if (OrderBookController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else
            return RefreshIndicator(
              color: theme.primaryColor,
              onRefresh: () {
                Dataconstants.orderBookData.fetchOrderBook();
                return Future.value(true);
              },
              child: OrderBookController.executedList.length == 0
                  ? OrderBookController.isOrderBookSearch.value && OrderBookController.executedLength != 0
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
                                  "You have no Executed Orders in Order Book",
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
                                itemCount: OrderBookController.executedList.length,
                                itemBuilder: (ctx, index) => ExecutedOrderRow(
                                  key: ObjectKey(
                                    OrderBookController.executedList[index],
                                  ),
                                  order: OrderBookController.executedList[index],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/appImages/bellSmall.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('That’s all we have for you today', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        );
                    }),
            );
        }))
      ],
    );
  }
}

class ExecutedOrderRow extends StatelessWidget {
  final orderDatum order;

  ExecutedOrderRow({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => order.status == 'complete' || order.status == 'open' || order.status == 'partially executed'
                ? ExecutedOrderDetails(TradeBookController.tradeBookList.firstWhere((element) => element.orderid == order.orderid), order.status == 'partially executed' ? true : false)
                : OrderDetails(order));
        // builder: (context) => OrderDetails(order));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* Displaying the Script name */
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: order.transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                      child: Text(
                        order.transactiontype,
                        style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    /* Displaying the Script Description */
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: order.status == 'complete' || order.status == 'open' || order.status == 'partially executed'
                              ? ThemeConstants.buyColor.withOpacity(0.2)
                              : order.status == 'rejected'
                                  ? ThemeConstants.sellColor.withOpacity(0.2)
                                  : Utils.greyColor.withOpacity(0.2)),
                      child: Text(
                        order.status == 'complete' || order.status == 'open' ? 'EXECUTED' : order.status.toUpperCase(),
                        style: Utils.fonts(
                            color: order.status == 'complete' || order.status == 'open' || order.status == 'partially executed'
                                ? ThemeConstants.buyColor
                                : order.status == 'rejected'
                                    ? ThemeConstants.sellColor
                                    : Utils.greyColor,
                            size: 10.0,
                            fontWeight: FontWeight.w600),
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
                    Text(order.model.name.toUpperCase(), style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                    Text("${order.status == 'partially executed' ? order.filledshares + '/' + order.quantity : order.status == 'open' ? order.filledshares : order.quantity}" + ' @ ' + '${order.ordertype == 'MARKET' ? order.averageprice : order.price}',
                        style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                  ],
                ),
                // /* Displaying the Script Description */
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                          text: order.exchange == 'NSE'
                              ? order.exchange.toUpperCase()
                              : order.exchange == 'BSE'
                                  ? order.exchange.toUpperCase()
                                  : order.expirydate.split(',')[0].toUpperCase(),
                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                          children: [
                            if (order.model.exchCategory != ExchCategory.nseEquity || order.model.exchCategory != ExchCategory.bseEquity) TextSpan(text: ' '),
                            if (order.model.exchCategory != ExchCategory.nseEquity || order.model.exchCategory != ExchCategory.bseEquity)
                              TextSpan(
                                text: order.model.exchCategory == ExchCategory.nseFuture ||
                                    order.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                    order.model.exchCategory == ExchCategory.currenyFutures ||
                                    order.model.exchCategory == ExchCategory.mcxFutures
                                    ? 'FUT'
                                    : order.model.exchCategory == ExchCategory.nseOptions ||
                                    order.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                    order.model.exchCategory == ExchCategory.currenyOptions ||
                                    order.model.exchCategory == ExchCategory.mcxOptions
                                        ? order.strikeprice.split('.')[0]
                                        : '',
                                style:
                                    Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: order.model.exchCategory == ExchCategory.nseFuture ||
                                        order.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                        order.model.exchCategory == ExchCategory.currenyFutures ||
                                        order.model.exchCategory == ExchCategory.mcxFutures ? Utils.primaryColor : Utils.greyColor),
                              ),
                            if (order.model.exchCategory == ExchCategory.nseOptions ||
                                order.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                order.model.exchCategory == ExchCategory.currenyOptions ||
                                order.model.exchCategory == ExchCategory.mcxOptions) TextSpan(text: ' '),
                            if (order.model.exchCategory == ExchCategory.nseOptions ||
                                order.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                order.model.exchCategory == ExchCategory.currenyOptions ||
                                order.model.exchCategory == ExchCategory.mcxOptions)
                              TextSpan(
                                text: order.model.cpType == 3 ? 'CE' : 'PE',
                                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: order.model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
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
                    Text(order.producttype.toUpperCase(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    Spacer(),
                    Observer(
                      builder: (_) => Row(
                        children: [
                          Text("LTP", style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400)),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            order.model.close == 0.00 ? order.model.prevDayClose.toStringAsFixed(order.model.precision) : order.model.close.toStringAsFixed(order.model.precision),
                            style: Utils.fonts(
                                color: order.model.close > order.model.prevTickRate
                                    ? Utils.mediumGreenColor
                                    : order.model.close < order.model.prevTickRate
                                        ? Utils.mediumRedColor
                                        : Utils.greyColor,
                                size: 14.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              order.model.close > order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                              color: order.model.close > order.model.prevTickRate ? Utils.mediumGreenColor : Utils.mediumRedColor,
                            ),
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
          ),
          const Divider(),
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
      case 'COMPLETED':
        clr = ThemeConstants.buyColor;
        /* BOB want to show EXECUTED status insted of COMPLETED status */
        status = 'EXECUTED';
        break;
      case 'CANCELLED':
        status = 'CANCELLED';
        clr = theme.primaryColor;
        break;
      case 'AH CANCELLED':
        /* BOB want to show AMO CANCELLED status insted of AH CANCELLED status */
        status = 'AMO CANCELLED';
        clr = ThemeConstants.sellColor;
        break;
      case 'REJECTED':
        clr = ThemeConstants.sellColor;
        break;
      case 'REJECTED BY BROKER':
        clr = ThemeConstants.sellColor;
        /* BOB want to show REJECTED status insted of REJECTED BY BROKER status */
        status = 'REJECTED';
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

/*class PartExecutedOrderRow extends StatelessWidget {
  final OrderReportRecordModel order;

  PartExecutedOrderRow({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int precision = order.model.precision;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.model.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        order.rate.toStringAsFixed(precision),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      if (order.withSL) const SizedBox(width: 5),
                      if (order.withSL)
                        Text(
                          '(SL : ${order.triggerRate.toStringAsFixed(precision)})',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        order.model.exchName.toUpperCase(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order.model.marketWatchDesc.toUpperCase(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        order.orderTimeStamp,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 7,
                    ),
                    color: order.buySell
                        ? ThemeConstants.buyColor.withOpacity(0.2)
                        : ThemeConstants.sellColor.withOpacity(0.2),
                    child: Text(
                      order.buySell ? 'BUY' : 'SELL',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: order.buySell
                            ? ThemeConstants.buyColor
                            : ThemeConstants.sellColor,
                      ),
                    ),
                  ),
                  Observer(builder: (ctx) {
                    return Row(
                      children: [
                        if (order.isLimit) const SizedBox(width: 5),
                        if (order.isLimit)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 7,
                            ),
                            color: theme.primaryColor.withOpacity(0.2),
                            */
/* Short forms given by BOB */ /*
                            child: Text(
                              'LMT',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        if (order.withSL) const SizedBox(width: 5),
                        if (order.withSL)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 7,
                            ),
                            color: Colors.amber[700].withOpacity(0.2),
                            */ /* Short forms given by BOB */ /*
                            child: Text(
                              'SL',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.amber[700],
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 7,
                    ),
                    color: Colors.cyan.withOpacity(0.2),
                    child: Text(
                      */ /* Short forms given by BOB */ /*
                      order.intraDel == 1
                          ? 'DEL'
                          : order.intraDel == 0
                              ? 'INTRA'
                              : 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'QTY ${order.qty.toString()}',
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusContainer(order.status, theme),
                  if (order.status == 'COMPLETED' && !order.isConsolidated)
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: theme.primaryColor,
                        ),
                      ),
                      // borderSide: BorderSide(color: theme.primaryColor),
                      textColor: theme.primaryColor,
                      child: const Text('Convert Position'),
                      onPressed: () {
                        if (order.model.exchCategory ==
                                ExchCategory.nseEquity ||
                            order.model.exchCategory ==
                                ExchCategory.bseEquity) {
                          */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (builder) {
                              return DraggableScrollableSheet(
                                initialChildSize:
                                    MediaQuery.of(context).size.height * 0.0009,
                                minChildSize: 0.50,
                                maxChildSize: 0.8,
                                expand: false,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return EquityOrderReviewScreen(
                                    isBuy: order.buySell,
                                    model: order.model,
                                    isLimit: order.isLimit,
                                    isSL: order.withSL,
                                    intraDel: order.intraDel == 1
                                        ? 0
                                        : order.intraDel == 0
                                            ? 1
                                            : 2,
                                    //Reversed
                                    quantity: order.qty.toString(),
                                    validityType: order.productType ? 1 : 0,
                                    disclosedQty: order.disclosedQty.toString(),
                                    limitPrice: order.rate
                                        .toStringAsFixed(order.model.precision),
                                    triggerPrice: order.triggerRate
                                        .toStringAsFixed(order.model.precision),
                                    orderReportRecord: order,
                                    orderType: ScripDetailType.convertPosition,
                                    scrollController: scrollController,
                                  );
                                },
                              );
                              */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                              // ),
                              // ),
                            },
                          );
                        } else if (order.model.exchCategory ==
                                ExchCategory.nseFuture ||
                            order.model.exchCategory ==
                                ExchCategory.nseOptions) {
                          */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (builder) {
                              return DraggableScrollableSheet(
                                initialChildSize:
                                    MediaQuery.of(context).size.height * 0.0009,
                                minChildSize: 0.50,
                                maxChildSize: 0.8,
                                expand: false,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return DerivativeOrderReviewScreen(
                                    isBuy: order.buySell,
                                    model: order.model,
                                    isLimit: order.isLimit,
                                    isSL: order.withSL,
                                    intraDel: order.intraDel == 1
                                        ? 0
                                        : order.intraDel == 0
                                            ? 1
                                            : 2,
                                    //Reversed
                                    quantity: order.qty.toString(),
                                    validityType: order.productType ? 1 : 0,
                                    disclosedQty: order.disclosedQty.toString(),
                                    limitPrice: order.rate
                                        .toStringAsFixed(order.model.precision),
                                    triggerPrice: order.triggerRate
                                        .toStringAsFixed(order.model.precision),
                                    orderReportRecord: order,
                                    orderType: ScripDetailType.convertPosition,
                                    scrollController: scrollController,
                                  );
                                },
                              );
                              */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                              // ),
                              // ),
                            },
                          );
                        } else {
                          */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (builder) {
                              return DraggableScrollableSheet(
                                initialChildSize:
                                    MediaQuery.of(context).size.height * 0.0009,
                                minChildSize: 0.50,
                                maxChildSize: 0.8,
                                expand: false,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return CurrencyMcxOrderReviewScreen(
                                    isBuy: order.buySell,
                                    model: order.model,
                                    isLimit: order.isLimit,
                                    isSL: order.withSL,
                                    intraDel: order.intraDel == 1
                                        ? 0
                                        : order.intraDel == 0
                                            ? 1
                                            : 2,
                                    //Reversed
                                    quantity: order.qty.toString(),
                                    validityType: order.productType ? 1 : 0,
                                    disclosedQty: order.disclosedQty.toString(),
                                    limitPrice: order.rate
                                        .toStringAsFixed(order.model.precision),
                                    triggerPrice: order.triggerRate
                                        .toStringAsFixed(order.model.precision),
                                    orderReportRecord: order,
                                    orderType: ScripDetailType.convertPosition,
                                    scrollController: scrollController,
                                  );
                                },
                              );
                              */ /* use this code when you need PageRoute (screen) instead of Draggable Scrollable Sheet */ /*
                              // ),
                              // ),
                            },
                          );
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 5),
              if (order.status.toLowerCase().contains('rejected'))
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Reject Reason',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                ),
              if (order.status.toLowerCase().contains('rejected'))
                const SizedBox(height: 5),
              if (order.status.toLowerCase().contains('rejected'))
                Text(
                  order.rejectReason.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              if (order.status.toLowerCase().contains('rejected'))
                const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Broker ID',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    order.brokerOrderId.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exchange Order ID',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    order.exchangeOrderIDText,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (!order.isConsolidated)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exchange Trade ID',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      order.exchangeTradeIDText,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget statusContainer(String status, ThemeData theme) {
    Color clr;
    switch (status) {
      case 'EXECUTED':
        clr = ThemeConstants.buyColor;
        break;
      case 'CANCELLED':
      case 'AH CANCELLED':
        clr = ThemeConstants.sellColor;
        break;
      case 'REJECTED':
        clr = ThemeConstants.sellColor;
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
      child: Text(
        status,
        style: TextStyle(
          color: clr,
        ),
      ),
    );
  }
}*/
