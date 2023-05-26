import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Utils.dart';

class FundStatus extends StatefulWidget {
  var amount;

  FundStatus(this.amount);

  @override
  State<FundStatus> createState() => _FundStatusState();
}

class _FundStatusState extends State<FundStatus> {
  var researchPicks = 0;
  var researchTitleList = [
    "Technical",
    "Research",
    "Derivatives",
    "Commodity& Currency"
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Funds Status",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                  child: SvgPicture.asset("assets/appImages/successFund.svg")),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "Funds Addition Success",
                  style: Utils.fonts(
                    size: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Rs " + widget.amount,
                  style: Utils.fonts(
                    size: 17.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Transaction ID: 155699644",
                    style: Utils.fonts(
                        size: 13.0, color: Utils.greyColor.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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
                          Text(
                            "1,54,325.9",
                            style: Utils.fonts(
                                size: 18.0, fontWeight: FontWeight.w600),
                          ),
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
                          Text(
                            "1,25,251.5",
                            style: Utils.fonts(
                                size: 18.0, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "(73% used)",
                            style: Utils.fonts(
                                size: 12.0,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Top Research Picks",
                    style: Utils.fonts(
                      size: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/leftArrowInCircle.svg")
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border:
                          Border.all(color: Utils.greyColor.withOpacity(0.5))),
                  child: Row(
                    children: [
                      for (var i = 0; i < researchTitleList.length; i++)
                        InkWell(
                          onTap: () {
                            setState(() {
                              researchPicks = i;
                            });
                          },
                          child: researchPicks == i
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                      border: Border.all(
                                          color: researchPicks == i
                                              ? Utils.primaryColor
                                              : Utils.greyColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      researchTitleList[i].toString(),
                                      style: Utils.fonts(
                                          size: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Utils.primaryColor),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    researchTitleList[i].toString(),
                                    style: Utils.fonts(
                                        size: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Utils.greyColor.withOpacity(0.9)),
                                  ),
                                ),
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 230,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TATAMOTORS",
                                      style: Utils.fonts(
                                          size: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "BUY",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Utils.darkGreenColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Exp. Return",
                                      style: Utils.fonts(
                                          size: 11.0,
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Utils.lightGreenColor
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Text(
                                          "11.1%",
                                          style: Utils.fonts(
                                              size: 13.0,
                                              color: Utils.darkGreenColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
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
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 230,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TATAMOTORS",
                                      style: Utils.fonts(
                                          size: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "BUY",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          color: Utils.darkGreenColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Exp. Return",
                                      style: Utils.fonts(
                                          size: 11.0,
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Utils.lightGreenColor
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Text(
                                          "11.1%",
                                          style: Utils.fonts(
                                              size: 13.0,
                                              color: Utils.darkGreenColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Recently Visited",
                style: Utils.fonts(
                  size: 17.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "GOLD",
                                      style: Utils.fonts(
                                          size: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "22 MAR FUT",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up_rounded,
                                      color: Utils.darkGreenColor,
                                    ),
                                    Text(
                                      "6.71%",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.darkGreenColor,
                                          fontWeight: FontWeight.w500),
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
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "GOLD",
                                      style: Utils.fonts(
                                          size: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "22 MAR FUT",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up_rounded,
                                      color: Utils.darkGreenColor,
                                    ),
                                    Text(
                                      "6.71%",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.darkGreenColor,
                                          fontWeight: FontWeight.w500),
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
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "GOLD",
                                      style: Utils.fonts(
                                          size: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "22 MAR FUT",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_up_rounded,
                                      color: Utils.darkGreenColor,
                                    ),
                                    Text(
                                      "6.71%",
                                      style: Utils.fonts(
                                          size: 13.0,
                                          color: Utils.darkGreenColor,
                                          fontWeight: FontWeight.w500),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
