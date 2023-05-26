import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/orders/order_status_details.dart';
import 'package:markets/jmScreens/portfolio/view_transactions.dart';

import '../../util/Utils.dart';
import '../addFunds/AddFunds.dart';

class closedHoldings extends StatefulWidget {
  @override
  State<closedHoldings> createState() => closedHoldingsState();
}

class closedHoldingsState extends State<closedHoldings> {
  // List<String, Number> values = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Closed Holdings",
          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          SvgPicture.asset(
            'assets/appImages/tranding.svg'
          ),

          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), 
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7ca6fa).withOpacity(0.2),
                          Color(0xff219305ff).withOpacity(0.2)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Intraday P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 14.0),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Short Term P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 14.0),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Long Term P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 14.0),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "10,02,893.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 14.0),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "89,83,892.9",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.mediumGreenColor),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "89,29,893.3",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.lightGreenColor),
                              textAlign: TextAlign.start,
                            )
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Symbol",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,color: Utils.greyColor, size: 14.0),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: Column( children: [
                            Text(
                              "Intraday P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,color: Utils.greyColor, size: 14.0),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Short T. P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,color: Utils.greyColor, size: 14.0),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                        ),
                        Expanded(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Long T. P/L",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,color: Utils.greyColor, size: 14.0),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Utils.greyColor.withOpacity(0.5),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (BuildContext context, int i) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(isScrollControlled: true,
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: SingleChildScrollView(
                                            child: (
                                                Column(
                                                  children: [
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                                                  style: Utils.fonts(size: 20.0),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Icon(Icons.close),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Qty",
                                                                      style: Utils.fonts(
                                                                          color: Utils.greyColor,
                                                                          size: 15.0,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                    Text(
                                                                      "2000",
                                                                      style: Utils.fonts(
                                                                        fontWeight: FontWeight.w700,
                                                                        size: 15.0,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      "Status",
                                                                      style: Utils.fonts(
                                                                          color: Utils.greyColor,
                                                                          size: 15.0,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                    Text(
                                                                      "OPEN",
                                                                      style: Utils.fonts(
                                                                          fontWeight: FontWeight.w700,
                                                                          size: 15.0,
                                                                          color:Utils.primaryColor
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 20,
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
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [

                                                                      Row(
                                                                        children: [
                                                                          Text("TATAPOWER",
                                                                              style: Utils.fonts(
                                                                                  size: 21.0,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: Utils.blackColor
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text("241.85",
                                                                              style: Utils.fonts(
                                                                                  size: 14.0,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Utils.greyColor
                                                                              )
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text("-2.80 (-2.43%)",
                                                                                  style: Utils.fonts(
                                                                                      size: 14.0,
                                                                                      color: Utils.lightGreenColor,
                                                                                      fontWeight: FontWeight.w700
                                                                                  )
                                                                              ),Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                                child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg"),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: (){
                                                                          Navigator.push(context,
                                                                              MaterialPageRoute(builder: (context) =>
                                                                                  viewTransactions()
                                                                              )
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(20),
                                                                                  topRight: Radius.circular(20),
                                                                                  bottomLeft: Radius.circular(20),
                                                                                  bottomRight: Radius.circular(20)),
                                                                              color: Utils.primaryColor.withOpacity(0.2)
                                                                          ),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.all(5.0),
                                                                            child: Text("View Tranactions",
                                                                                style: Utils.fonts(
                                                                                    size: 14.0,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Utils.primaryColor
                                                                                )
                                                                            ),
                                                                          )
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),

                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("Long term P/L",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Utils.greyColor)),
                                                                Text("10115643",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        color: Utils.blackColor,
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("Buy Value",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Utils.greyColor)),
                                                                Text("2203280112183",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        color: Utils.blackColor,
                                                                        fontWeight: FontWeight.w700))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                    "Market Value",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Utils.greyColor
                                                                    )
                                                                ),
                                                                Text(
                                                                    "12 Apr 2022 12:45",
                                                                    style: Utils.fonts(
                                                                        size: 14.0,
                                                                        color: Utils.blackColor,
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("But Qty",
                                                                        style: Utils.fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Utils.greyColor)),
                                                                    Text("234134223",
                                                                        style: Utils.fonts(
                                                                            size: 14.0,
                                                                            color: Utils.blackColor,
                                                                            fontWeight: FontWeight.w700))
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
                                                                    Text("Sell Qty",
                                                                        style: Utils.fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Utils.greyColor)),
                                                                    Text("Towards Clear Balance",
                                                                        style: Utils.fonts(
                                                                            size: 14.0,
                                                                            color: Utils.blackColor,
                                                                            fontWeight: FontWeight.w700))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),

                                                      ),
                                                    ),
                                                    SizedBox(height : 20),
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
                                                                      child: Text("ADD MORE", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                                                    ),
                                                                    VerticalDivider(
                                                                      color: Utils.greyColor,
                                                                      thickness: 2,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {

                                                                      },
                                                                      child: Text("SQUARE OFF", style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                       GestureDetector(
                                                            behavior: HitTestBehavior.opaque,
                                                            onTap: () {},
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              width: MediaQuery.of(context).size.width,
                                                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                              child: Text("GET QUOTE", style: Utils.fonts(size: 14.0, color: Utils.whiteColor)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
                                        )
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Column(
                                          crossAxisAlignment : CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "RELIANCE",
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w500,
                                                  size: 14.0
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              "",
                                            ),
                                          ],
                                        ),
                                    Row(
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "450",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                    color: Utils.mediumGreenColor),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "-9.859",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                    color:Utils.brightRedColor
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ]
                                        ),SizedBox(width: 20,)
                                      ],
                                    ),
                                  Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "1,11,699",
                                            ),
                                            Text(
                                              "",
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Utils.greyColor.withOpacity(0.5),
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
