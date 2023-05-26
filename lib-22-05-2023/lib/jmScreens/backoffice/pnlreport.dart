import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../../controllers/SummaryController.dart';
import '../../controllers/DetailController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class backOffice extends StatefulWidget {
  @override
  State<backOffice> createState() => _backOfficeState();
}

class _backOfficeState extends State<backOffice> {
  @override
  void initState() {
    // fun1();
    // TODO: implement initState
    super.initState();
  }

  void fun1() async {
    // await CommonFunction.backOfficeTrPositionsCMDetail();
    await CommonFunction.backOfficeTrPlSummary();
    // Dataconstants.summaryController.getSummaryApi();
    // Dataconstants.detailsController.getDetailResult();
  }

  var exchangeItems = ["NSE", "BSE", "MCX"];
  var segmentItems = ["Equity", "Futures", "Options", "Currency", "Commodity"];

  var exchangeItemsName = "NSE";
  var segmentItemsName = "Equity";

  @override
  Widget build(BuildContext context) {
    // //print("${ DetailsControlller
    //     .getDetailResultListItems[2].tradeDate.toString().substring(0,4)} == ${Dataconstants.pnlDropodownYear}: ${DetailsControlller
    //     .getDetailResultListItems[
    // 0]
    //     .scripName ==
    //     SummaryController
    //         .getSummaryDetailListItems[
    //     0]
    //         .scripName && DetailsControlller
    //     .getDetailResultListItems[
    // 0].tradeDate.toString().substring(0, 4) == Dataconstants.pnlDropodownYear}");

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("P/L Report",
            style: Utils.fonts(
              color: Utils.greyColor,
            )),
        actions: [
          SvgPicture.asset("assets/appImages/tranding.svg"),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return SummaryController.isLoading.value
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(clipBehavior: Clip.none, children: [
                              Positioned(
                                child: Container(
                                    height: 58,
                                    width: 156,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: SizedBox.shrink(),
                                        items: exchangeItems.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(
                                                value,
                                                style: Utils.fonts(
                                                  size: 14.0,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              //TODO:
                                            },
                                          );
                                        }).toList(),
                                        underline: SizedBox(),
                                        hint: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Center(
                                            child: Text(
                                              exchangeItemsName,
                                              style: Utils.fonts(
                                                size: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            exchangeItemsName = val;
                                          });
                                        })),
                              ),
                              Positioned(
                                  top: -7,
                                  left: 55,
                                  child: Container(
                                    color: Utils.whiteColor,
                                    child: Container(
                                      width: 55,
                                      child: Center(
                                        child: Text(
                                          "Exchange",
                                          style: Utils.fonts(color: Utils.blackColor, size: 11.0),
                                        ),
                                      ),
                                    ),
                                  )),
                            ]),
                            Stack(clipBehavior: Clip.none, children: [
                              Positioned(
                                child: Container(
                                    height: 58,
                                    width: 156,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: SizedBox.shrink(),
                                        items: segmentItems.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(
                                                value,
                                                style: Utils.fonts(
                                                  size: 14.0,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              //TODO:
                                            },
                                          );
                                        }).toList(),
                                        underline: SizedBox(),
                                        hint: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Center(
                                            child: Text(
                                              segmentItemsName,
                                              style: Utils.fonts(
                                                size: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            segmentItemsName = val;
                                          });
                                        })),
                              ),
                              Positioned(
                                  top: -7,
                                  left: 50,
                                  child: Container(
                                    color: Utils.whiteColor,
                                    child: Container(
                                      // width: 50,
                                      decoration: BoxDecoration(
                                          // color: Colors.black
                                          ),
                                      child: Text(
                                        "Segment",
                                        style: Utils.fonts(color: Utils.blackColor, size: 11.0),
                                      ),
                                    ),
                                  )),
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "View P&L Report for",
                            style: Utils.fonts(color: Utils.blackColor, size: 13.0),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: Dataconstants.pnlDropodownYear,
                            items: Dataconstants.pnlItems.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    items,
                                    style: Utils.fonts(
                                      color: Utils.blackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                Dataconstants.pnlDropodownYear = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text("Search Results",
                                  style: Utils.fonts(
                                    color: Utils.greyColor,
                                  ))),
                          SvgPicture.asset("assets/appImages/download.svg", color: Colors.blue)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text("Scrip",
                                style: Utils.fonts(
                                  color: Utils.blackColor,
                                )),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text("Intraday P/L",
                                        style: Utils.fonts(
                                          color: Utils.blackColor,
                                        )),
                                    Text("Qty",
                                        style: Utils.fonts(
                                          color: Utils.blackColor,
                                        ))
                                  ],
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.33,
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Short-Term P/L",
                                    style: Utils.fonts(
                                      color: Utils.blackColor,
                                    )),
                                Text("Long-Term P/L",
                                    style: Utils.fonts(
                                      color: Utils.blackColor,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: SummaryController.getSummaryDetailListItems.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      for (var i = 0; i < DetailsControlller.getDetailResultListItems.length; i++)
                                                        if (DetailsControlller.getDetailResultListItems[i].scripName == SummaryController.getSummaryDetailListItems[index].scripName &&
                                                            DetailsControlller.getDetailResultListItems[i].tradeDate.toString().substring(0, 4) == Dataconstants.pnlDropodownYear)
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Buy Date",
                                                                                style: Utils.fonts(
                                                                                  color: Utils.blackColor,
                                                                                )),
                                                                            Text(DetailsControlller.getDetailResultListItems[i].tradeDate,
                                                                                style: Utils.fonts(
                                                                                  color: Utils.greyColor,
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Buy Value",
                                                                                style: Utils.fonts(
                                                                                  color: Utils.blackColor,
                                                                                )),
                                                                            Text(DetailsControlller.getDetailResultListItems[i].netValue.toStringAsFixed(2),
                                                                                style: Utils.fonts(
                                                                                  color: Utils.greyColor,
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text("Buy Qty",
                                                                                style: Utils.fonts(
                                                                                  color: Utils.blackColor,
                                                                                )),
                                                                            Text(DetailsControlller.getDetailResultListItems[i].netQty.toString(),
                                                                                style: Utils.fonts(
                                                                                  color: Utils.greyColor,
                                                                                ))
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Divider(
                                                                thickness: 2,
                                                              ),
                                                            ],
                                                          )
                                                      // ListView.builder(
                                                      //   shrinkWrap: true,
                                                      //   itemCount: DetailsControlller.getDetailResultListItems.length,
                                                      //   itemBuilder: (BuildContext context, int i){
                                                      //     if(DetailsControlller.getDetailResultListItems[i].tradeDate.split("-")[i] == Dataconstants.pnlDropodownYear) {
                                                      //       return Column(
                                                      //         children: [
                                                      //           Padding(
                                                      //             padding: const EdgeInsets
                                                      //                 .symmetric(
                                                      //                 vertical: 8.0
                                                      //             ),
                                                      //             child: Column(
                                                      //               children: [
                                                      //                 Row(
                                                      //                   mainAxisAlignment:
                                                      //                   MainAxisAlignment
                                                      //                       .spaceBetween,
                                                      //                   children: [
                                                      //                     Column(
                                                      //                       crossAxisAlignment:
                                                      //                       CrossAxisAlignment
                                                      //                           .start,
                                                      //                       children: [
                                                      //                         Text(
                                                      //                             "Buy Date",
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .blackColor,
                                                      //                             )),
                                                      //                         Text(
                                                      //                             DetailsControlller
                                                      //                                 .getDetailResultListItems[
                                                      //                             i]
                                                      //                                 .tradeDate,
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .greyColor,
                                                      //                             ))
                                                      //                       ],
                                                      //                     ),
                                                      //                     Column(
                                                      //                       crossAxisAlignment:
                                                      //                       CrossAxisAlignment
                                                      //                           .start,
                                                      //                       children: [
                                                      //                         Text(
                                                      //                             "Buy Value",
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .blackColor,
                                                      //                             )),
                                                      //                         Text(
                                                      //                             DetailsControlller
                                                      //                                 .getDetailResultListItems[
                                                      //                             i]
                                                      //                                 .netValue
                                                      //                                 .toStringAsFixed(
                                                      //                                 2),
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .greyColor,
                                                      //                             ))
                                                      //                       ],
                                                      //                     ),
                                                      //                     Column(
                                                      //                       crossAxisAlignment:
                                                      //                       CrossAxisAlignment
                                                      //                           .end,
                                                      //                       children: [
                                                      //                         Text(
                                                      //                             "Buy Qty",
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .blackColor,
                                                      //                             )),
                                                      //                         Text(
                                                      //                             DetailsControlller
                                                      //                                 .getDetailResultListItems[
                                                      //                             i]
                                                      //                                 .netQty
                                                      //                                 .toString(),
                                                      //                             style: Utils
                                                      //                                 .fonts(
                                                      //                               color: Utils
                                                      //                                   .greyColor,
                                                      //                             ))
                                                      //                       ],
                                                      //                     )
                                                      //                   ],
                                                      //                 ),
                                                      //               ],
                                                      //             ),
                                                      //           ),
                                                      //           SizedBox(height: 5,),
                                                      //           Divider(thickness: 2,),
                                                      //         ],
                                                      //       );
                                                      //     };
                                                      //   },
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              child: Text(
                                                SummaryController.getSummaryDetailListItems[index].scripName,
                                                style: Utils.fonts(color: Utils.blackColor, size: 11.0),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      // SummaryController.getSummaryDetailListItems[index].netQty.toString(),
                                                      SummaryController.getSummaryDetailListItems[index].netQty.toString(),
                                                      style: Utils.fonts(
                                                        color: Utils.greyColor,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(SummaryController.getSummaryDetailListItems[index].unrealisedPl.toStringAsFixed(2),
                                                      style: Utils.fonts(
                                                        color: Utils.greyColor,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
