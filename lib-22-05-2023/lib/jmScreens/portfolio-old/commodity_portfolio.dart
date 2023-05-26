import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/PortfolioControllers/PortfolioDerivateController.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../portfolio/view_transactions.dart';
class Commodity_Portfolio extends StatefulWidget
{
  double mtm_pl,marginused;

  Commodity_Portfolio({Key key,this.mtm_pl,this.marginused}) : super(key: key);
  @override
  State<Commodity_Portfolio> createState() => _Commodity_PortfolioState();
}

class _Commodity_PortfolioState extends State<Commodity_Portfolio> {

  bool isMTM = false;
  var res;
  String seriesCode, formattedDate, formatSeriesCode;
  DateTime date;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Dataconstants.portfolio_derivateController.getDetailResult();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.grey,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7ca6fa).withOpacity(0.2),
                            Color(0xff219305ff).withOpacity(0.2)
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        )),

                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 12, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "MTM/PL",
                                    style: Utils.fonts(size: 14.0),
                                  ),
                                  Text(
                                    "${widget.mtm_pl}",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 16.0,
                                        color: Utils.lightGreenColor),
                                  ),
                                  // Center(
                                  //   child: SvgPicture.asset(
                                  //     "assets/appImages/add_fund_portfolio.svg",
                                  //   ),
                                  // )
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/appImages/portfolio/zero_wallet.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Margin Used",
                                        style: Utils.fonts(
                                            size: 13.0,
                                            color: Utils.greyColor)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${widget.marginused}",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Day's P/L",
                                        style: Utils.fonts(
                                            size: 13.0,
                                            color: Utils.greyColor)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 16.0,
                                          color: Utils.lightGreenColor),
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 16.0,
                                          color: Utils.lightGreenColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Realised P/L",
                                        style: Utils.fonts(
                                            size: 13.0,
                                            color: Utils.greyColor)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 16.0,
                                          color: Utils.lightGreenColor),
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 16.0,
                                          color: Utils.lightGreenColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMTM = false;
                            });
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(8.0),
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              // border: Border.all(color: Utils.primaryColor)
                                border: Border(
                                  top: BorderSide(
                                      width: 1.5,
                                      color: !isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                  bottom: BorderSide(
                                      width: 1.5,
                                      color: !isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                  left: BorderSide(
                                      width: 1.5,
                                      color: !isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                  right: BorderSide(
                                      width: 1.5, color: Utils.primaryColor),
                                )),
                            child: Center(
                                child: Text(
                                  'OPEN',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: !isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMTM = true;
                            });
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(8.0),
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.5,
                                      color: isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                  bottom: BorderSide(
                                      width: 1.5,
                                      color: isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                  right: BorderSide(
                                      width: 1.5,
                                      color: isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                )),
                            child: Center(
                                child: Text(
                                  'MTM',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: isMTM
                                          ? Utils.primaryColor
                                          : Utils.lightGreyColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Divider(
                thickness: 3,
                color: Colors.grey[350],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Symbol",
                                style: Utils.fonts(
                                    size: 14.0, color: Utils.greyColor)),
                            isMTM
                                ? Text("Expiry Date",
                                style: Utils.fonts(
                                    size: 14.0, color: Utils.greyColor))
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMTM
                                  ? MediaQuery.of(context).size.width * 0.1
                                  : MediaQuery.of(context).size.width * 0.15,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isMTM == false
                                      ? Text("P/L",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.greyColor))
                                      : Text("Fut MTM",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  isMTM == false
                                      ? Text("LTP",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.greyColor))
                                      : Text("Opt MTM",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("QTY",
                                style: Utils.fonts(
                                    size: 14.0, color: Utils.greyColor)),
                            SizedBox(
                              height: 5,
                            ),
                            isMTM == false
                                ? Text("Avg Price",
                                style: Utils.fonts(
                                    size: 14.0, color: Utils.greyColor))
                                : SizedBox.shrink(),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              child: ListView.builder(
                // shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: PortfolioDerivateController
                      .getDetailResultListItems2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        // height: 90,
                        // color: Colors.green,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 0, bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.8),
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: SingleChildScrollView(
                                          child: (Column(
                                            children: [
                                              Card(
                                                margin: EdgeInsets.zero,
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10)),
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Holdings Details",
                                                            style:
                                                            Utils.fonts(
                                                                size:
                                                                20.0),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Icon(
                                                                Icons
                                                                    .close),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                "Qty",
                                                                style: Utils.fonts(
                                                                    color: Utils
                                                                        .greyColor,
                                                                    size:
                                                                    15.0,
                                                                    fontWeight:
                                                                    FontWeight.w400),
                                                              ),
                                                              Text(
                                                                "2000",
                                                                style: Utils
                                                                    .fonts(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  size:
                                                                  15.0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                "Status",
                                                                style: Utils.fonts(
                                                                    color: Utils
                                                                        .greyColor,
                                                                    size:
                                                                    15.0,
                                                                    fontWeight:
                                                                    FontWeight.w400),
                                                              ),
                                                              Text(
                                                                "OPEN",
                                                                style: Utils.fonts(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    size:
                                                                    15.0,
                                                                    color: Utils
                                                                        .primaryColor),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        decoration:
                                                        BoxDecoration(
                                                            border:
                                                            Border
                                                                .all(
                                                              color: Utils
                                                                  .greyColor,
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .all(
                                                              Radius.circular(
                                                                  15.0),
                                                            )),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "TATAPOWER",
                                                                        style: Utils.fonts(
                                                                            size: 21.0,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: Utils.blackColor)),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "241.85",
                                                                        style: Utils.fonts(
                                                                            size: 14.0,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Utils.greyColor)),
                                                                    Row(
                                                                      children: [
                                                                        Text("-2.80 (-2.43%)",
                                                                            style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700)),
                                                                        Padding(
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
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => viewTransactions()));
                                                                  },
                                                                  child: Container(
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), color: Utils.primaryColor.withOpacity(0.2)),
                                                                      child: Padding(
                                                                        padding:
                                                                        EdgeInsets.all(5.0),
                                                                        child:
                                                                        Text("View Tranactions", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.primaryColor)),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
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
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Long term P/L",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Utils
                                                                      .greyColor)),
                                                          Text("10115643",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  color: Utils
                                                                      .blackColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text("Buy Value",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Utils
                                                                      .greyColor)),
                                                          Text(
                                                              "2203280112183",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  color: Utils
                                                                      .blackColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Market Value",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Utils
                                                                      .greyColor)),
                                                          Text(
                                                              "12 Apr 2022 12:45",
                                                              style: Utils.fonts(
                                                                  size:
                                                                  14.0,
                                                                  color: Utils
                                                                      .blackColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "But Qty",
                                                                  style: Utils.fonts(
                                                                      size:
                                                                      14.0,
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      color:
                                                                      Utils.greyColor)),
                                                              Text(
                                                                  "234134223",
                                                                  style: Utils.fonts(
                                                                      size:
                                                                      14.0,
                                                                      color: Utils
                                                                          .blackColor,
                                                                      fontWeight:
                                                                      FontWeight.w700))
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
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Sell Qty",
                                                                  style: Utils.fonts(
                                                                      size:
                                                                      14.0,
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      color:
                                                                      Utils.greyColor)),
                                                              Text(
                                                                  "Towards Clear Balance",
                                                                  style: Utils.fonts(
                                                                      size:
                                                                      14.0,
                                                                      color: Utils
                                                                          .blackColor,
                                                                      fontWeight:
                                                                      FontWeight.w700))
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
                                              SizedBox(height: 20),
                                              Card(
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10)),
                                                color: Utils.primaryColor,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        color: Utils
                                                            .whiteColor,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(
                                                                10.0),
                                                            topRight: Radius
                                                                .circular(
                                                                10.0)),
                                                      ),
                                                      child:
                                                      IntrinsicHeight(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(
                                                              15.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              GestureDetector(
                                                                behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                                child: Text(
                                                                    "ADD MORE",
                                                                    style: Utils.fonts(
                                                                        size:
                                                                        14.0,
                                                                        color:
                                                                        Utils.greyColor)),
                                                              ),
                                                              VerticalDivider(
                                                                color: Utils
                                                                    .greyColor,
                                                                thickness:
                                                                2,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () {},
                                                                child: Text(
                                                                    "SQUARE OFF",
                                                                    style: Utils.fonts(
                                                                        size:
                                                                        14.0,
                                                                        color:
                                                                        Utils.greyColor)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      behavior:
                                                      HitTestBehavior
                                                          .opaque,
                                                      onTap: () {},
                                                      child: Container(
                                                        alignment: Alignment
                                                            .center,
                                                        width:
                                                        MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width,
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            15.0),
                                                        child: Text(
                                                            "GET QUOTE",
                                                            style: Utils.fonts(
                                                                size: 14.0,
                                                                color: Utils
                                                                    .whiteColor)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                        ),
                                      ));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${PortfolioDerivateController.getDetailResultListItems2[index].productCode}",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "${DateFormat('dd MMM').format(DateTime.parse(PortfolioDerivateController.getDetailResultListItems2[index].expiryDate)).toUpperCase()} ${PortfolioDerivateController.getDetailResultListItems2[index].seriesCode.replaceAll(RegExp('[^A-Za-z]'), '')?.split('FUT')[0]?.split('OPT')[0] ?? ''}${PortfolioDerivateController.getDetailResultListItems2[index].seriesCode.contains('FUT') ? 'FUT' : 'OPT'}",
                                            style: Utils.fonts(
                                                size: 13.0,
                                                color: Utils.greyColor
                                                    .withOpacity(0.7))),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${PortfolioDerivateController.getDetailResultListItems2[index].pl.toStringAsFixed(2)}",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                color: Utils.mediumRedColor,
                                                fontWeight: FontWeight.w700)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "${PortfolioDerivateController.getDetailResultListItems2[index].settlementPrice}",
                                            style: Utils.fonts(
                                                size: 13.0,
                                                color: Utils.greyColor)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            "${PortfolioDerivateController.getDetailResultListItems2[index].shortQty == 0 ? PortfolioDerivateController.getDetailResultListItems2[index].longQty : PortfolioDerivateController.getDetailResultListItems2[index].shortQty}",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "${PortfolioDerivateController.getDetailResultListItems2[index].costPrice.toStringAsFixed(2)}",
                                            style: Utils.fonts(
                                                size: 13.0,
                                                color: Utils.greyColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Colors.grey[350],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

