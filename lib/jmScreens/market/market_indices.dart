import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/BseIndicesController.dart';
import 'package:markets/jmScreens/orders/OrderPlacement/order_placement_screen.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../controllers/NseIndicesController.dart';
import '../../util/Utils.dart';

class MarketIndices extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<MarketIndices> createState() => _MarketIndicesState();
}

class _MarketIndicesState extends State<MarketIndices> {
  
  var marketIndices = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Dataconstants.bseIndicesController.getBseIndices();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                      onTap: () {
                        setState(() {
                          marketIndices = 2;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                              top: marketIndices == 2
                                  ? BorderSide(color: Utils.primaryColor)
                                  : BorderSide(color: Utils.greyColor),
                              bottom: marketIndices == 2
                                  ? BorderSide(color: Utils.primaryColor)
                                  : BorderSide(color: Utils.greyColor),
                              right: marketIndices == 2
                                  ? BorderSide(color: Utils.primaryColor)
                                  : BorderSide(color: Utils.greyColor),
                              left: marketIndices == 2
                                  ? BorderSide(color: Utils.primaryColor)
                                  :  BorderSide(color: Utils.greyColor),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("BSE",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: marketIndices == 2
                                      ? Utils.primaryColor
                                      : Utils.greyColor)),
                        ),
                      ),
                    ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            marketIndices = 1;
                            Dataconstants.nseIndicesController.getNseIndices();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                top: marketIndices == 1
                                    ? BorderSide(color: Utils.primaryColor)
                                    : BorderSide(color: Utils.greyColor),
                                bottom: marketIndices == 1
                                    ? BorderSide(color: Utils.primaryColor)
                                    : BorderSide(color: Utils.greyColor),
                                right: marketIndices == 1
                                    ? BorderSide(color: Utils.primaryColor)
                                    :  BorderSide(color: Utils.greyColor),
                                left: marketIndices == 1
                                    ? BorderSide(color: Utils.primaryColor)
                                    : BorderSide(color: Utils.greyColor),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("NSE",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: marketIndices == 1
                                        ? Utils.primaryColor
                                        : Utils.greyColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          marketIndices == 1 ? Obx(() {
              return Column(
                children: [
                  NseIndicesController.isLoading.value
                      ? CircularProgressIndicator()
                      : Column(
                    children: [
                      for (var i = 0; i < NseIndicesController.getNseIndicesListItems.length; i++)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      NseIndicesController.getNseIndicesListItems[i].indexName,
                                      style: Utils.fonts(
                                        size: 14.0,
                                        color: Utils.blackColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        NseIndicesController.getNseIndicesListItems[i].pricediff.toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.blackColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            NseIndicesController.getNseIndicesListItems[i].currentprice.toStringAsFixed(2),
                                            style: Utils.fonts(
                                              size: 12.0,
                                              color: Utils.lightGreenColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            '(${NseIndicesController.getNseIndicesListItems[i].prechange.toStringAsFixed(2)}%)',
                                            style: Utils.fonts(
                                              size: 12.0,
                                              color: NseIndicesController.getNseIndicesListItems[i].prechange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: NseIndicesController.getNseIndicesListItems[i].prechange > 0 ? SvgPicture.asset(
                                                "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                                              quarterTurns: 2,
                                                  child: SvgPicture.asset(
                                                  "assets/appImages/markets/inverted_rectangle.svg", color: Utils.lightRedColor,),
                                                ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        )
                    ],
                  )
                ],
              );
            }
          ) : SizedBox.shrink(),
          marketIndices == 2 ? Obx(() {
            return Column(
              children: [
                BseIndicesController.isLoading.value
                    ? CircularProgressIndicator()
                    : Column(
                  children: [
                    for (var i = 0; i < BseIndicesController.getBseIndicesListItems.length; i++)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.45,
                                  child: Text(
                                    BseIndicesController.getBseIndicesListItems[i].indexName,
                                    style: Utils.fonts(
                                      size: 14.0,
                                      color: Utils.blackColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      BseIndicesController.getBseIndicesListItems[i].pricediff.toStringAsFixed(2),
                                      style: Utils.fonts(
                                        size: 14.0,
                                        color: Utils.blackColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          BseIndicesController.getBseIndicesListItems[i].currentprice.toStringAsFixed(2),
                                          style: Utils.fonts(
                                            size: 12.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '(${BseIndicesController.getBseIndicesListItems[i].prechange.toStringAsFixed(2)}%)',
                                          style: Utils.fonts(
                                            size: 12.0,
                                            color: BseIndicesController.getBseIndicesListItems[i].prechange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: BseIndicesController.getBseIndicesListItems[i].prechange > 0 ? SvgPicture.asset(
                                              "assets/appImages/markets/inverted_rectangle.svg") : RotatedBox(
                                              quarterTurns: 2,
                                            child: SvgPicture.asset(
                                                "assets/appImages/markets/inverted_rectangle.svg", color: Utils.lightRedColor),
                                              ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      )
                  ],
                )
              ],
            );
          }
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
