import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../../model/existingOrderDetails.dart';
import '../../model/jmModel/netPosition.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/scrip_details_screen.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'OrderPlacement/order_placement_screen.dart';

class TodayPositionDetails extends StatefulWidget {
  final NetPositionDatum order;

  TodayPositionDetails(this.order);

  @override
  State<TodayPositionDetails> createState() => _TodayPositionDetailsState();
}

class _TodayPositionDetailsState extends State<TodayPositionDetails> {
  final _convertController = ValueNotifier<bool>(false); // true = Market, false = Limit

  @override
  void initState() {
    _convertController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 90,
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
                            "Position Details",
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
                      Text(
                        'UNREALISED P/L',
                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Observer(builder: (_) {
                        if (int.parse(widget.order.netqty) == 0)
                          widget.order.pl = 0.00;
                        else if (int.parse(widget.order.netqty) < 0)
                          widget.order.pl = (double.tryParse(widget.order.sellavgprice.replaceAll(',', '')) - widget.order.model.close) * int.parse(widget.order.netqty).abs();
                        else
                          widget.order.pl = (widget.order.model.close - double.parse(widget.order.buyavgprice.replaceAll(',', ''))) * int.parse(widget.order.netqty).abs();
                        if (widget.order.model.exch == 'M' && widget.order.model.exchType == 'D') widget.order.pl = widget.order.pl * widget.order.model.factor * widget.order.model.minimumLotQty;
                        return Text(
                          '₹${widget.order.pl.toStringAsFixed(2)}',
                          style: Utils.fonts(size: 28.0, fontWeight: FontWeight.w700, color: widget.order.pl > 0.0 ? Utils.brightGreenColor : Utils.brightRedColor),
                        );
                      }),
                      // Observer(builder: (_) {
                      //   Text(widget.order.model.close - );
                      // }),
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
                                "OPEN QTY",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.order.netqty,
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
                                // int.parse(widget.order.netqty) > 0 ? widget.order.buyavgprice : widget.order.sellavgprice,
                                // widget.order.avgnetprice,
                                widget.order.avgnetprice,
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
                                'OPEN',
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
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
                            Text(
                                "STOCK YOU ${int.parse(widget.order.netqty) > 0 ? 'BUY' : int.parse(widget.order.netqty) < 0 ? 'SELL' : ''}",
                                style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
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
                                  const SizedBox(
                                    width: 2,
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
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Buy Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.order.buyqty, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                          Text("Buy Price", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text(widget.order.buyavgprice, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Buy Value", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text(widget.order.buyamount == null ? '0' : widget.order.buyamount, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sell Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.order.sellqty, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text("Sell Price", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.order.sellavgprice, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text("Sell Value", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.order.sellamount == null ? '0' : widget.order.sellamount, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text("Closed Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.order.closedquantity, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                        ],
                      ),
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OrderPlacementScreen(
                                          model: widget.order.model,
                                          orderType: ScripDetailType.positionAdd,
                                          isBuy: true,
                                          selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                          orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                          stream: Dataconstants.pageController.stream,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Utils.greyColor,
                                      ),
                                      Text("ADD MORE", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                    ],
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    if (widget.order.producttype == 'COVER') {
                                      CommonFunction.showBasicToastForJm('Cover orders cannot be converted');
                                      return;
                                    }
                                    if (widget.order.producttype == 'BRACKET') {
                                      CommonFunction.showBasicToastForJm('Bracket orders cannot be converted');
                                      return;
                                    }
                                    if (int.tryParse(widget.order.buyqty) != 0 && int.tryParse(widget.order.sellqty) != 0) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            var theme = Theme.of(context);
                                            return Platform.isIOS
                                                ? CupertinoAlertDialog(
                                                    title: Text("SELECT CONVERSION", style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Buy Qty : ", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                            Text(int.parse(widget.order.netqty) > 0 ? widget.order.netqty : widget.order.buyqty, style: Utils.fonts(size: 12.0, color: Utils.blackColor)),
                                                            Spacer(),
                                                            Text("Sell Qty : ", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                            Text(int.parse(widget.order.netqty) < 0 ? widget.order.netqty : widget.order.sellqty, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        SizedBox(
                                                          width: size.width * 0.7,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) => OrderPlacementScreen(
                                                                              model: widget.order.model,
                                                                              orderType: ScripDetailType.convertPosition,
                                                                              isBuy: true,
                                                                              orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                                                              stream: Dataconstants.pageController.stream,
                                                                            )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Utils.brightGreenColor),
                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                                  child: Text(
                                                                    'CONVERT BUY',
                                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) => OrderPlacementScreen(
                                                                              model: widget.order.model,
                                                                              orderType: ScripDetailType.convertPosition,
                                                                              isBuy: false,
                                                                              orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                                                              stream: Dataconstants.pageController.stream,
                                                                            )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Utils.brightRedColor),
                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                                  child: Text(
                                                                    'CONVERT SELL',
                                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : AlertDialog(
                                                    title: Text("SELECT CONVERSION", style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Buy Qty : ", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                            Text(int.parse(widget.order.netqty) > 0 ? widget.order.netqty : widget.order.buyqty,
                                                                style: Utils.fonts(size: 12.0, color: Utils.blackColor)),
                                                            Spacer(),
                                                            Text("Sell Qty : ", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                            Text(int.parse(widget.order.netqty) < 0 ? widget.order.netqty : widget.order.sellqty, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        SizedBox(
                                                          width: size.width * 0.7,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) => OrderPlacementScreen(
                                                                              model: widget.order.model,
                                                                              orderType: ScripDetailType.convertPosition,
                                                                              isBuy: true,
                                                                              orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                                                              stream: Dataconstants.pageController.stream,
                                                                            )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Utils.brightGreenColor),
                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                                  child: Text(
                                                                    'CONVERT BUY',
                                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) => OrderPlacementScreen(
                                                                              model: widget.order.model,
                                                                              orderType: ScripDetailType.convertPosition,
                                                                              isBuy: false,
                                                                              orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                                                              stream: Dataconstants.pageController.stream,
                                                                            )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Utils.brightRedColor),
                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                                  child: Text(
                                                                    'CONVERT SELL',
                                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                          });
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => OrderPlacementScreen(
                                                  model: widget.order.model,
                                                  orderType: ScripDetailType.convertPosition,
                                                  isBuy: int.parse(widget.order.netqty) > 0 ? true : false,
                                                  orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                                  stream: Dataconstants.pageController.stream,
                                                )),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text("CONVERT", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (widget.order.producttype == 'COVER') {
                          CommonFunction.showBasicToastForJm('Cover orders are exited from Order Book');
                          return;
                        }
                        if (widget.order.producttype == 'BRACKET') {
                          CommonFunction.showBasicToastForJm('Bracket orders are exited from Order Book');
                          return;
                        }
                        if (widget.order.netqty != '0') {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderPlacementScreen(
                                model: widget.order.model,
                                orderType: ScripDetailType.positionExit,
                                isBuy: int.tryParse(widget.order.netqty) > 0 ? false : true,
                                selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                                stream: Dataconstants.pageController.stream,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("SQUAREOFF", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
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
