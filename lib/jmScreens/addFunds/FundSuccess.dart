import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/limitController.dart';
import '../../util/DataConstants.dart';
import '../../util/Utils.dart';

class FundSuccess extends StatefulWidget {
  final String amount;
  final String transactionId;

  FundSuccess(this.amount, this.transactionId);


  @override
  State<FundSuccess> createState() => _FundSuccessState();
}

class _FundSuccessState extends State<FundSuccess> {

  var topPerformingIndustriesTab = 1;
  var otherAssetTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Fund Status",
            style: Utils.fonts(
                fontWeight: FontWeight.w700,
                size: 16.0,
                color: Utils.blackColor),
          ),
          actions: [
            SvgPicture.asset("assets/appImages/tranding.svg"),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width ,
                  child: SvgPicture.asset("assets/appImages/successFund.svg")),
              SizedBox(
                height: 10,
              ),
              Text(
                "Funds Addition success",
                style: Utils.fonts(
                    fontWeight: FontWeight.w700,
                    size: 16.0,
                    color: Utils.blackColor),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Rs ${widget.amount}",
                style: Utils.fonts(
                    fontWeight: FontWeight.w700,
                    size: 16.0,
                    color: Utils.blackColor),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Trasaction ID: ${widget.transactionId}",
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 12.0,
                    color: Utils.greyColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.primaryColor.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Available Margin",
                              style: Utils.fonts(
                                  size: 14.0, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return Text(
                                LimitController.limitData.value.availableMargin.toString(),
                                style: Utils.fonts(
                                    size: 18.0, fontWeight: FontWeight.w600),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Margin Used",
                              style: Utils.fonts(
                                  size: 14.0, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return Text(
                                LimitController.limitData.value.marginUsed.toString(),
                                style: Utils.fonts(
                                    size: 18.0, fontWeight: FontWeight.w600),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return Text(
                                "(${LimitController.limitData.value.marginUsedPercentage} used)"
                                    .toString(),
                                style: Utils.fonts(
                                    size: 12.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Top Research Picks",
                          style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                        Spacer(),
                        InkWell(
                            onTap: () {

                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg"))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 1;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Commodities",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 2;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Currencies",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 4;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "IPOs",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 10),
                     SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                      Utils.greyColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SILVER"
                                                  .toString(),
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "29 Mar",
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  color: Utils.greyColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                             Icons
                                                  .arrow_drop_down_rounded,
                                              color:Utils.lightRedColor,
                                            ),
                                            Text(
                                              "0.21",
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.lightRedColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/appImages/green_small_chart_shadow.png",
                                      width: 170,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                      Utils.greyColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SILVER"
                                                  .toString(),
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "29 Mar",
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  color: Utils.greyColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down_rounded,
                                              color:Utils.lightRedColor,
                                            ),
                                            Text(
                                              "0.21",
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.lightRedColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/appImages/green_small_chart_shadow.png",
                                      width: 170,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                      Utils.greyColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SILVER"
                                                  .toString(),
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "29 Mar",
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  color: Utils.greyColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down_rounded,
                                              color:Utils.lightRedColor,
                                            ),
                                            Text(
                                              "0.21",
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.lightRedColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/appImages/green_small_chart_shadow.png",
                                      width: 170,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                      Utils.greyColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SILVER"
                                                  .toString(),
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "29 Mar",
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  color: Utils.greyColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down_rounded,
                                              color:Utils.lightRedColor,
                                            ),
                                            Text(
                                              "0.21",
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.lightRedColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/appImages/green_small_chart_shadow.png",
                                      width: 170,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                      Utils.greyColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SILVER"
                                                  .toString(),
                                              style: Utils.fonts(
                                                  size: 13.0,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "29 Mar",
                                              style: Utils.fonts(
                                                  size: 11.0,
                                                  color: Utils.greyColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down_rounded,
                                              color:Utils.lightRedColor,
                                            ),
                                            Text(
                                              "0.21",
                                              style: Utils.fonts(
                                                  size: 12.0,
                                                  color: Utils.lightRedColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/appImages/green_small_chart_shadow.png",
                                      width: 170,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ) ,
                    Container(
                      height: 4.0,
                      width: MediaQuery.of(context).size.width,
                      color: Utils.greyColor.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recent visits",
                          style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                        Spacer(),
                        InkWell(
                            onTap: () {

                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg"))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 1;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Commodities",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 1
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 2;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Currencies",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 2
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 4;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "IPOs",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: otherAssetTab == 4
                                                ? Utils.primaryColor
                                                : Utils.greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Utils.greyColor.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SILVER"
                                                    .toString(),
                                                style: Utils.fonts(
                                                    size: 13.0,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "29 Mar",
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.greyColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_drop_down_rounded,
                                                color:Utils.lightRedColor,
                                              ),
                                              Text(
                                                "0.21",
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.lightRedColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        "assets/appImages/green_small_chart_shadow.png",
                                        width: 170,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Utils.greyColor.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SILVER"
                                                    .toString(),
                                                style: Utils.fonts(
                                                    size: 13.0,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "29 Mar",
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.greyColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_drop_down_rounded,
                                                color:Utils.lightRedColor,
                                              ),
                                              Text(
                                                "0.21",
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.lightRedColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        "assets/appImages/green_small_chart_shadow.png",
                                        width: 170,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Utils.greyColor.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SILVER"
                                                    .toString(),
                                                style: Utils.fonts(
                                                    size: 13.0,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "29 Mar",
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.greyColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_drop_down_rounded,
                                                color:Utils.lightRedColor,
                                              ),
                                              Text(
                                                "0.21",
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.lightRedColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        "assets/appImages/green_small_chart_shadow.png",
                                        width: 170,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Utils.greyColor.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SILVER"
                                                    .toString(),
                                                style: Utils.fonts(
                                                    size: 13.0,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "29 Mar",
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.greyColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_drop_down_rounded,
                                                color:Utils.lightRedColor,
                                              ),
                                              Text(
                                                "0.21",
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.lightRedColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        "assets/appImages/green_small_chart_shadow.png",
                                        width: 170,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Utils.greyColor.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "SILVER"
                                                    .toString(),
                                                style: Utils.fonts(
                                                    size: 13.0,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "29 Mar",
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    color: Utils.greyColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_drop_down_rounded,
                                                color:Utils.lightRedColor,
                                              ),
                                              Text(
                                                "0.21",
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.lightRedColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        "assets/appImages/green_small_chart_shadow.png",
                                        width: 170,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ) ,
                    Container(
                      height: 4.0,
                      width: MediaQuery.of(context).size.width,
                      color: Utils.greyColor.withOpacity(0.2),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
