import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../model/existingOrderDetails.dart';
import '../../model/jmModel/holdings.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/scrip_details_screen.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../ScriptInfo/ScriptInfo.dart';
import 'OrderPlacement/order_placement_screen.dart';

class HoldingDetails extends StatefulWidget {
  final HoldingDatum order;

  HoldingDetails(this.order);

  @override
  State<HoldingDetails> createState() => _HoldingDetailsState();
}

class _HoldingDetailsState extends State<HoldingDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 150,
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
                            "Holdings Details",
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
                                widget.order.quantity,
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
                              // if (widget.order.status == 'open' || widget.order.status == 'open pending' || widget.order.status == 'validation pending')
                              //   Text(
                              //     'PENDING',
                              //     style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                              //   ),
                              // if (widget.order.status == 'trigger pending')
                              //   Text(
                              //     'TRIGGER PENDING',
                              //     style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                              //   ),
                              // if (widget.order.status == 'rejected')
                              //   Text(
                              //     'REJECT',
                              //     style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.mediumRedColor),
                              //   ),
                              // if (widget.order.status == 'cancelled')
                              //   Text(
                              //     'CANCEL',
                              //     style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.greyColor),
                              //   ),
                              // if (widget.order.status.toLowerCase().contains('after market order'))
                              //   Text(
                              //     'AMO PENDING',
                              //     style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0, color: Utils.primaryColor),
                              //   ),
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
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Exchange", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                  Text(widget.order.exchange, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                                  Text("Used Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                  Text(widget.order.realisedquantity, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
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
                                  Text("Total Qty", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                  Text(widget.order.quantity, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // if (widget.index == 0)
                      //   Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Scrip Code", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.isin,
                      //               "500049",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Long Term P/L", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.quantity,
                      //               "1,22,432.21",
                      //               style: Utils.fonts(
                      //                 size: 14.0,
                      //                 color: Utils.darkGreenColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.product,
                      //               "1,13,674.21",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "3,54,546.54",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.index == 1)
                      //   Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Scrip Code", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.isin,
                      //               "500049",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Unrealised P/L", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.quantity,
                      //               "1,22,432.21",
                      //               style: Utils.fonts(
                      //                 size: 14.0,
                      //                 color: Utils.darkGreenColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.product,
                      //               "1,13,674.21",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Mkt Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "3,54,546.54",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.index == 2)
                      //   Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Settlement Price", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.isin,
                      //               "500049",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Previous Close", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.quantity,
                      //               "1,22,432.21",
                      //               style: Utils.fonts(
                      //                 size: 14.0,
                      //                 color: Utils.darkGreenColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Short Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.product,
                      //               "1,13,674.21",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Long Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "3,54,546.54",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Long Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Today's MTM", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Settled MTM", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.index == 4)
                      //   Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Future MTM", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.isin,
                      //               "500049",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Option MTM", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.quantity,
                      //               "1,22,432.21",
                      //               style: Utils.fonts(
                      //                 size: 14.0,
                      //                 color: Utils.darkGreenColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.product,
                      //               "1,13,674.21",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "3,54,546.54",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.index == 5)
                      //   Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Scrip Code", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.isin,
                      //               "500049",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Long Term P/L", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.quantity,
                      //               "1,22,432.21",
                      //               style: Utils.fonts(
                      //                 size: 14.0,
                      //                 color: Utils.darkGreenColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.product,
                      //               "1,13,674.21",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Market Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "3,54,546.54",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      //           Text(
                      //               // widget.order.haircut,
                      //               "1000",
                      //               style: Utils.fonts(size: 14.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
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
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OrderPlacementScreen(
                                          model: widget.order.model,
                                          orderType: ScripDetailType.holdingAdd,
                                          isBuy: true,
                                          selectedExch: widget.order.exchange == 'BSE' ? "B" : "N",
                                          orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                                          stream: Dataconstants.pageController.stream,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(child: Text("ADD MORE", style: Utils.fonts(size: 14.0, color: Utils.greyColor))),
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
                                      if (widget.order.quantity != '0') {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => OrderPlacementScreen(
                                              model: widget.order.model,
                                              orderType: ScripDetailType.holdingExit,
                                              // isBuy: int.tryParse(widget.order.netqty) > 0 ? false : true,
                                              isBuy: false,
                                              selectedExch: widget.order.exchange == 'NSE' ? "N" : "B",
                                              orderModel: ExistingNewOrderDetails.holdingReport(widget.order, true),
                                              stream: Dataconstants.pageController.stream,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Center(child: Text("SQUARE OFF", style: Utils.fonts(size: 14.0, color: Utils.greyColor)))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScriptInfo(
                              widget.order.model,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("GET QUOTE", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget closedHoldingsListElements(index) {
  if (index == 0) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Scrip Code", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.isin,
                "500049",
                style: Utils.fonts(size: 14.0, color: Utils.blackColor))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Long Term P/L", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.quantity,
                "1,22,432.21",
                style: Utils.fonts(
                  size: 14.0,
                  color: Utils.darkGreenColor,
                  fontWeight: FontWeight.w500,
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Buy Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.product,
                "1,13,674.21",
                style: Utils.fonts(size: 14.0, color: Utils.blackColor))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sell Value", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.haircut,
                "3,54,546.54",
                style: Utils.fonts(size: 14.0, color: Utils.blackColor))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Buy Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.haircut,
                "1000",
                style: Utils.fonts(size: 14.0, color: Utils.blackColor)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sell Qty", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
            Text(
                // widget.order.haircut,
                "1000",
                style: Utils.fonts(size: 14.0, color: Utils.blackColor))
          ],
        ),
      ],
    );
  }
}
