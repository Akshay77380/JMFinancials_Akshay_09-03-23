import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import '../../controllers/limitController.dart';
import '../../model/scrip_info_model.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class OrderSummaryDetails extends StatefulWidget {
  final bool isBuy;
  final ScripInfoModel model;
  final String qty;
  final String limitPrice;
  final String productType;
  final bool isAdvanced;
  final Widget swipeAction;
  final String orderType;
  final String slTriggerPrice;
  final String dislosedQty, buyRange, sellRange, coverSellRange, validty, coverTriggerPrice, squareOff, boStopLoss, trailStopLoss;
  final bool afterMarketOrder;

  OrderSummaryDetails(
      {this.isBuy,
      this.model,
      this.qty,
      this.productType,
      this.swipeAction,
      this.limitPrice,
      this.isAdvanced,
      this.orderType,
      this.slTriggerPrice,
      this.dislosedQty,
      this.afterMarketOrder,
      this.buyRange,
      this.sellRange,
      this.coverSellRange,
      this.validty,
      this.coverTriggerPrice,
      this.squareOff,
      this.boStopLoss,
      this.trailStopLoss});

  @override
  State<OrderSummaryDetails> createState() => _OrderSummaryDetailsState();
}

class _OrderSummaryDetailsState extends State<OrderSummaryDetails> {
  String getExchCategory(ExchCategory e) {
    switch (e) {
      case ExchCategory.nseEquity:
        return 'NSE Equity';
        break;
      case ExchCategory.bseEquity:
        return 'BSE Equity';
        break;
      case ExchCategory.nseFuture:
        return 'NSE Future';
        break;
      case ExchCategory.nseOptions:
        return 'NSE Option';
        break;
      case ExchCategory.bseCurrenyFutures:
        return 'BSE Currency';
        break;
      case ExchCategory.bseCurrenyOptions:
        return 'BSE Currency';
        break;
      case ExchCategory.currenyFutures:
        return 'NSE Currency';
        break;
      case ExchCategory.currenyOptions:
        return 'NSE Currency';
        break;
      case ExchCategory.mcxFutures:
        return 'MCX Commodity';
        break;
      case ExchCategory.mcxOptions:
        return 'MCX Commodity';
        break;
      default:
        return '';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 110,
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
                            "Review your order",
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
                        'ORDER VALUE',
                        style: Utils.fonts(size: 14.0, color: Utils.lightGreyColor),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.limitPrice == '0'
                            ? '${(int.tryParse(widget.qty) * widget.model.close).toStringAsFixed(2)}'
                            : '${(int.tryParse(widget.qty) * double.tryParse(widget.limitPrice)).toStringAsFixed(2)}',
                        style: Utils.fonts(size: 28.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Margin',
                            style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Required Margin',
                            style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return Text(
                              '₹ ${LimitController.limitData.value.availableMargin.toString()}',
                              style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                            );
                          }),
                          Text(
                            '₹ 0.00',
                            style: Utils.fonts(color: Utils.blackColor, size: 14.0, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: widget.isBuy ? Utils.lightGreenColor.withOpacity(0.05) : Utils.lightRedColor.withOpacity(0.05),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            widget.isBuy
                                ? Text("STOCK YOU BUY", style: Utils.fonts(size: 12.0, color: Utils.darkGreenColor))
                                : Text("STOCK YOU SELL", style: Utils.fonts(size: 12.0, color: Utils.darkRedColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(widget.model.exchCategory == ExchCategory.nseEquity || widget.model.exchCategory == ExchCategory.bseEquity ? widget.model.name : widget.model.desc,
                                            maxLines: 1, style: Utils.fonts(size: 20.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                        Text('${getExchCategory(widget.model.exchCategory)}', style: Utils.fonts(size: 12.0, color: Utils.blackColor, fontWeight: FontWeight.w400)),
                                      ],
                                    ),
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
                                                child: Text(widget.model.close.toStringAsFixed(widget.model.precision),
                                                    style: Utils.fonts(size: 16.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.model.priceChangeText + " " + widget.model.percentChangeText,
                                                    style: Utils.fonts(
                                                        color: widget.model.percentChange > 0
                                                            ? Utils.brightGreenColor
                                                            : widget.model.percentChange < 0
                                                                ? Utils.brightRedColor
                                                                : theme.errorColor,
                                                        size: 12.0,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Icon(
                                                      widget.model.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                      color: widget.model.percentChange > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
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
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Margin Utilise", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text("₹1,000.0", style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Quantity", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.qty, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Product", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.productType, style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Book Profit", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.productType == 'BO' ? widget.squareOff : 'N/A', style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Stop Loss", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                              Text(widget.productType == 'BO' ? widget.boStopLoss : 'N/A', style: Utils.fonts(size: 12.0, color: Utils.blackColor))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      // if (widget.orderType=="STOP LOSS")
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Trigger Price",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.slTriggerPrice==""?"0.00":widget.slTriggerPrice}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.dislosedQty.isNotEmpty && widget.dislosedQty!='0' && widget.dislosedQty!='')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Disclosed Qty",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text(widget.dislosedQty,
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.validty.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Order Validity",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text(widget.validty,
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.coverTriggerPrice.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Cover Trigger Price",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text(widget.coverTriggerPrice,
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.orderType == 'COVER')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Buy Range",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.buyRange==""?"0.00":widget.buyRange}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.orderType == 'COVER')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Sell Range",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.sellRange==""?"0.00":widget.sellRange}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.afterMarketOrder)
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("After Market Order",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text(widget.afterMarketOrder ? "Yes" : "No",
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.orderType=='BRACKET')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Square Off",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.squareOff==""?"0.00":widget.squareOff}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.orderType=='BRACKET')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Bracket Stop Loss",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.boStopLoss==""?"0.00":widget.boStopLoss}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.orderType=='BRACKET')
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Trail Stop Loss",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text('${widget.trailStopLoss==""?"0.00":widget.trailStopLoss}',
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if (widget.isAdvanced)
                      //   Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Order",
                      //               style: Utils.fonts(
                      //                   size: 12.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Utils.greyColor)),
                      //           Text("${widget.orderType}",
                      //               style: Utils.fonts(
                      //                   size: 12.0, color: Utils.blackColor))
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // if(widget.orderType=="BRACKET")
                      // Column(
                      //   children: [
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text("Book Profit",
                      //             style: Utils.fonts(
                      //                 size: 12.0,
                      //                 fontWeight: FontWeight.w400,
                      //                 color: Utils.greyColor)),
                      //         Text("₹1,000.0",
                      //             style: Utils.fonts(
                      //                 size: 12.0, color: Utils.blackColor))
                      //       ],
                      //     ),
                      //     SizedBox(
                      //       height: 10,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.swipeAction,
            ],
          ),
        ),
      ),
    );
  }
}
