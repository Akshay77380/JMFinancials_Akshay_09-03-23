import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../model/existingOrderDetails.dart';
import '../../model/jmModel/netPosition.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/scrip_details_screen.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'OrderPlacement/order_placement_screen.dart';

class NetPositionDetails extends StatefulWidget {
  NetPositionDatum order;

  NetPositionDetails(this.order);

  @override
  State<NetPositionDetails> createState() => _NetPositionDetailsState();
}

class _NetPositionDetailsState extends State<NetPositionDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
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
                        'REALISED P/L',
                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '₹${widget.order.pl.toStringAsFixed(2)}',
                        style: Utils.fonts(size: 28.0, fontWeight: FontWeight.w700, color: widget.order.pl > 0.0 ? Utils.brightGreenColor : Utils.brightRedColor),
                      ),
                      // Observer(
                      //   builder: (_) {
                      //     return Text(
                      //       '₹${widget.order.pl.toStringAsFixed(2)}',
                      //       style: Utils.fonts(size: 28.0, fontWeight: FontWeight.w700, color: widget.order.pl > 0.0 ? Utils.brightGreenColor : Utils.brightRedColor),
                      //     );
                      //   }
                      // ),
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
                                "Avg Price",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                // int.parse(widget.order.netqty) > 0 ? widget.order.buyavgprice : widget.order.sellavgprice,
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
                                "Status",
                                style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'CLOSED',
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
                            Text("STOCK YOU BUY", style: Utils.fonts(size: 13.0, color: Utils.blackColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(widget.order.model.exchCategory == ExchCategory.nseEquity || widget.order.model.exchCategory == ExchCategory.bseEquity ? widget.order.model.name : widget.order.model.desc, maxLines: 1, style: Utils.fonts(size: 20.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
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
                                                    child: Icon(
                                                      widget.order.model.close > widget.order.model.prevTickRate ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                      color: widget.order.model.percentChange > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                  )
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
                          Text(widget.order.buyamount, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Buy Value", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text(widget.order.totalbuyvalue, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text(widget.order.sellamount, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text(widget.order.totalsellvalue, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                              Text("Closed Qty",
                                  style: Utils.fonts(
                                      size: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.greyColor)),
                              Text(widget.order.closedquantity,
                                  style: Utils.fonts(
                                      size: 12.0, color: Utils.blackColor))
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
                child: InkWell(
                  onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderPlacementScreen(
                            model: widget.order.model,
                            orderType: ScripDetailType.positionAdd,
                            isBuy: true,
                            selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                            orderModel: ExistingNewOrderDetails.positionReport(widget.order),
                            stream: Dataconstants.pageController.stream,
                          ),
                        ),
                      );
                  },
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Utils.whiteColor,
                        ),
                        Text("ADD MORE", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
