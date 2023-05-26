import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/bulkController.dart';

import '../../controllers/blockDealsController.dart';
import '../../model/jmModel/blockDeals.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class BulkBlockDeals extends StatefulWidget {
  @override
  State<BulkBlockDeals> createState() => _BulkBlockDealsState();
}

class _BulkBlockDealsState extends State<BulkBlockDeals> {
  var bulkBlockDeals = 1;

  @override
  void initState() {
    Dataconstants.blockDealsController.getBlockDeals();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  bulkBlockDeals = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: bulkBlockDeals == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: bulkBlockDeals == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: bulkBlockDeals == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: bulkBlockDeals == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Block Deals",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: bulkBlockDeals == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  Dataconstants.bulkDealsController.getBulkDeals();
                  bulkBlockDeals = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: bulkBlockDeals == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: bulkBlockDeals == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: bulkBlockDeals == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  left: bulkBlockDeals == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Bulk Deals",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: bulkBlockDeals == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        bulkBlockDeals == 1
            ? Column(
                children: [
                  Obx(() {
                    return BlockDealsController.isLoading.value
                        ? Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Loading",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                '.....',
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 400,
                          ),
                        ],
                      ),
                    )
                        : BlockDealsController.getBlockDealsListItems.length > 0
                        ? Column(children: [
                      for (var i = 0;
                      i <
                          BlockDealsController
                              .getBlockDealsListItems.length;
                      i++)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          BlockDealsController
                                              .getBlockDealsListItems[
                                          i]
                                              .scripName,
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w700,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 8.0),
                                        child: Text("NSE",
                                            style: Utils.fonts(
                                                fontWeight:
                                                FontWeight.w500,
                                                size: 14.0,
                                                color: Utils
                                                    .lightGreyColor)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      BlockDealsController
                                          .getBlockDealsListItems[
                                      i]
                                          .buysell ==
                                          Buysell.B
                                          ? "PURCHASE"
                                          : "SELL",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: BlockDealsController
                                              .getBlockDealsListItems[
                                          i]
                                              .buysell ==
                                              Buysell.B
                                              ? Utils.darkGreenColor
                                              : Utils.darkRedColor)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Qty",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text(
                                          BlockDealsController
                                              .getBlockDealsListItems[
                                          i]
                                              .qtyshares
                                              .toString(),
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text("Price",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text(
                                          BlockDealsController
                                              .getBlockDealsListItems[
                                          i]
                                              .avgPrice
                                              .toStringAsFixed(2),
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text("Traded % ",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text( " ",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "Sold by: ${BlockDealsController.getBlockDealsListItems[i].clientName}",
                                        maxLines: 1,
                                        style: Utils.fonts(
                                            fontWeight:
                                            FontWeight.w500,
                                            size: 14.0,
                                            color: Utils
                                                .lightGreyColor)),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        )
                    ])
                        : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Data Available",
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              )
            : Column(
                children: [
                  Obx(() {
                    return BulkDealsController.isLoading.value
                        ? Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Loading",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                '.....',
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 400,
                          ),
                        ],
                      ),
                    )
                        : BulkDealsController.getBulkDealsListItems.length > 0
                        ? Column(children: [
                      for (var i = 0;
                      i <
                          BulkDealsController
                              .getBulkDealsListItems.length;
                      i++)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .scripname,
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w700,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 8.0),
                                        child: Text("NSE",
                                            style: Utils.fonts(
                                                fontWeight:
                                                FontWeight.w500,
                                                size: 14.0,
                                                color: Utils
                                                    .lightGreyColor)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      BulkDealsController
                                          .getBulkDealsListItems[
                                      i]
                                          .buysell ==
                                          Buysell.B
                                          ? "PURCHASE"
                                          : "SELL",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .buysell ==
                                              Buysell.B
                                              ? Utils.darkGreenColor
                                              : Utils.darkRedColor)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Qty",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text(
                                          BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .qtyshares
                                              .toString(),
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text("Price",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text(
                                          BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .avgPrice
                                              .toStringAsFixed(2),
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text("Traded % ",
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreyColor)),
                                      Text(
                                          (BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .qtyshares /
                                              BulkDealsController
                                                  .getBulkDealsListItems[
                                              i]
                                                  .model
                                                  .prevDayCumVol ==
                                              'Infinity'
                                              ? "NA"
                                              : (BulkDealsController
                                              .getBulkDealsListItems[
                                          i]
                                              .qtyshares /
                                              BulkDealsController
                                                  .getBulkDealsListItems[
                                              i]
                                                  .model
                                                  .prevDayCumVol)
                                              .toStringAsFixed(
                                              2)),
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight.w500,
                                              size: 14.0,
                                              color:
                                              Utils.blackColor)),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "Sold by: ${BulkDealsController.getBulkDealsListItems[i].clientname}",
                                        maxLines: 1,
                                        style: Utils.fonts(
                                            fontWeight:
                                            FontWeight.w500,
                                            size: 14.0,
                                            color: Utils
                                                .lightGreyColor)),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        )
                    ])
                        : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Data Available",
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              )
      ],
    );
  }
}
