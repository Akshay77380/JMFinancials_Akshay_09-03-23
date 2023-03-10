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

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
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
              child: OrderBookController.allList.length == 0
                  ? OrderBookController.isOrderBookSearch.value && OrderBookController.allList.length != 0
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
                                builder: (_) =>
                                    MainScreen(
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
                          itemCount: OrderBookController.allList.length,
                          itemBuilder: (ctx, index) =>
                              AllOrderRow(
                                key: ObjectKey(
                                  OrderBookController.allList[index],
                                ),
                                order: OrderBookController.allList[index],
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

class AllOrderRow extends StatelessWidget {
  final orderDatum order;

  AllOrderRow({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return order.status == 'open' ? InkWell(
      onTap: () {
        showModalBottomSheet(isScrollControlled: true, context: context, backgroundColor: Colors.transparent, builder: (context) => OrderDetails(order));
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
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: order.transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                      child: Text(
                        order.transactiontype,
                        style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                      ),
                    ),
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
                    Text(order.model.name.toUpperCase(), style: Utils.fonts(size: 16.0, fontWeight: FontWeight.bold, color: Utils.blackColor)),
                    Text(
                        order.filledshares +
                            '/' +
                            '${int.tryParse(order.unfilledshares) + int.tryParse(order.filledshares)}' +
                            ' @ ' +
                            '${order.ordertype == 'MARKET' || order.ordertype == 'STOPLOSS_MARKET' ? order.averageprice : order.price}',
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
                                text: order.model.exchCategory.name.toLowerCase().contains('future')
                                    ? 'FUT'
                                    : order.model.exchCategory.name.toLowerCase().contains('option')
                                    ? order.strikeprice.split('.')[0]
                                    : '',
                                style: Utils.fonts(
                                    size: 12.0, fontWeight: FontWeight.w400, color: order.model.exchCategory.name.toLowerCase().contains('future') ? Utils.primaryColor : Utils.greyColor),
                              ),
                            if (order.model.exchCategory.name.toLowerCase().contains('option')) TextSpan(text: ' '),
                            if (order.model.exchCategory.name.toLowerCase().contains('option'))
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
                            order.model.close == 0.00
                                ? order.model.prevDayClose.toStringAsFixed(order.model.precision)
                                : order.model.close.toStringAsFixed(order.model.precision),
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
    ) : InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) =>
            order.status == 'complete' || order.status == 'open' || order.status == 'partially executed'
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
                    Text(
                        "${order.status == 'partially executed' ? order.filledshares + '/' + order.quantity : order.status == 'open' ? order.filledshares : order.quantity}" +
                            ' @ ' +
                            '${order.ordertype == 'MARKET' ? order.averageprice : order.price}',
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
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: order.model.exchCategory == ExchCategory.nseFuture ||
                                        order.model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                        order.model.exchCategory == ExchCategory.currenyFutures ||
                                        order.model.exchCategory == ExchCategory.mcxFutures
                                        ? Utils.primaryColor
                                        : Utils.greyColor),
                              ),
                            if (order.model.exchCategory == ExchCategory.nseOptions ||
                                order.model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                order.model.exchCategory == ExchCategory.currenyOptions ||
                                order.model.exchCategory == ExchCategory.mcxOptions)
                              TextSpan(text: ' '),
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
                      builder: (_) =>
                          Row(
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
      case 'open':
        clr = theme.primaryColor;
        break;
      case 'complete':
        clr = ThemeConstants.buyColor;
        /* BOB want to show EXECUTED status insted of COMPLETED status */
        status = 'EXECUTED';
        break;
      case 'CANCELLED':
        status = 'CANCELLED';
        clr = Utils.greyColor;
        break;
      case 'AH CANCELLED':
      /* BOB want to show AMO CANCELLED status insted of AH CANCELLED status */
        status = 'AMO CANCELLED';
        clr = ThemeConstants.sellColor;
        break;
      case 'rejected':
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
    );
  }
}
