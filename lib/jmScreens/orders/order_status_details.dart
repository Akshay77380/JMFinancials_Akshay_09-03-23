import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markets/screens/scrip_details_screen.dart';
import '../../controllers/limitController.dart';
import '../../model/jmModel/orderBook.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/web_view_link_screen.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../addFunds/AddFunds.dart';
import '../addFunds/AddMoney.dart';
import '../mainScreen/MainScreen.dart';
import 'OrderPlacement/order_placement_screen.dart';

class OrderStatusDetails extends StatefulWidget {
  orderDatum order;
  String qty;
  ScripDetailType orderType;

  OrderStatusDetails(this.order, {this.orderType, this.qty});

  @override
  State<OrderStatusDetails> createState() => _OrderStatusDetailsState();
}

class _OrderStatusDetailsState extends State<OrderStatusDetails> {
  bool status;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    if (widget.order.status == 'rejected')
      status = false;
    else
      status = true;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: status ? MediaQuery.of(context).size.height - 180 : MediaQuery.of(context).size.height - 80,
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
                            "Order Status",
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
                        height: 10,
                      ),
                      SvgPicture.asset(status ? "assets/appImages/success.svg" : "assets/appImages/error.svg"),
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
                                widget.qty != null ? widget.qty : widget.order.quantity,
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
                              Text(
                                status ? 'SUCCESS' : 'REJECT',
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: status ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                              )
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
                                                child: Text(
                                                    widget.order.model.close == 0.00
                                                        ? widget.order.model.prevDayClose.toStringAsFixed(widget.order.model.precision)
                                                        : widget.order.model.close.toStringAsFixed(widget.order.model.precision),
                                                    style: Utils.fonts(size: 16.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${widget.order.model.close == 0.00 ? "0.00" : widget.order.model.priceChangeText}" +
                                                        " " +
                                                        "${widget.order.model.close == 0.00 ? "(0.00%)" : widget.order.model.percentChangeText}",
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
                      if (widget.order.status == 'cancelled')
                        Column(
                          children: [
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
                                  Text("CANCELLATION REASON", style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Text("${widget.order.text}", style: Utils.fonts(size: 12.0, color: Colors.red), textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (!status)
                        Column(
                          children: [
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
                                  Text("REJECTION REASON", style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Text("${widget.order.text}", style: Utils.fonts(size: 12.0, color: Colors.red), textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (widget.order.text.toLowerCase().contains('margin exceeds'))
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Available Margin", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Obx(() {
                                            return Text('₹ ${LimitController.limitData.value.availableMargin.toString()}', style: Utils.fonts(size: 12.0, color: Utils.blackColor));
                                          })
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
                                          Text("Shortfall Amount", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Text('67,565.5', style: Utils.fonts(size: 12.0, color: Utils.brightRedColor))
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
                                          Text("Increase Margin using Holdings", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                          Text('1,12,000.5', style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  InAppSelection.mainScreenIndex = 3;
                                  Dataconstants.ordersScreenIndex = 0;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (_) => MainScreen(
                                                toChangeTab: true,
                                              )),
                                      (route) => false);
                                },
                                child: Text("ORDER BOOK", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                              ),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              widget.order.text.toLowerCase().contains('margin exceeds')
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddFunds()));
                                      },
                                      child: Text("ADD FUNDS", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        InAppSelection.mainScreenIndex = 1;
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (_) => MainScreen(
                                                      toChangeTab: false,
                                                    )),
                                            (route) => false);
                                      },
                                      child: Text("WATCHLIST", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    widget.order.text.toLowerCase().contains('margin exceeds')
                        ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData["pledge_url"], "PLEDGE")));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text("INCREASE MARGIN", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                            ),
                          )
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if ((status && widget.orderType == ScripDetailType.positionExit) || (status && widget.orderType == ScripDetailType.modify)) {
                                if (widget.order.model.exchCategory == ExchCategory.nseEquity || widget.order.model.exchCategory == ExchCategory.bseEquity)
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return OrderPlacementScreen(
                                          // model: currentModelNew,
                                          model: widget.order.model,
                                          // currentModelNew to be used only for equity nse/bse toggle
                                          orderType: ScripDetailType.none,
                                          isBuy: widget.order.transactiontype == 'BUY' ? true : false,
                                          selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                          stream: Dataconstants.pageController.stream,
                                        );
                                      },
                                    ),
                                  );
                                else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return OrderPlacementScreen(
                                          model: widget.order.model,
                                          orderType: ScripDetailType.none,
                                          isBuy: widget.order.transactiontype == 'BUY' ? true : false,
                                          selectedExch: "N",
                                          stream: Dataconstants.pageController.stream,
                                        );
                                      },
                                    ),
                                  );
                              } else
                                Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(status ? "ADD MORE" : "RETRY", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
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
}
