import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/topGainersController.dart';
import '../../controllers/topLosersController.dart';
import '../../util/DataConstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../addFunds/AddFunds.dart';
import '../addFunds/AddMoney.dart';

class EquityPorfolio extends StatefulWidget {
  // const EquityPorfolio({Key? key}) : super(key: key);

  @override
  State<EquityPorfolio> createState() => _EquityPorfolioState();
}

class _EquityPorfolioState extends State<EquityPorfolio> {
  final ScrollController _controller = ScrollController();

  //_controller1 = ScrollController(initialScrollOffset: 50.0);

  bool topGainersExpanded = false;
  bool topLosersExpanded = false;
  var topGainersTab = 1;
  var topLosersTab = 1;

  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7ca6fa).withOpacity(0.2),
                            Color(0xff219305ff).withOpacity(0.2)
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        )),
                    // color: Color(0x7ca6fa),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Market Value",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 12.0),
                                    ),
                                    Text(
                                      "1,233,654.4",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 15.0),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddFunds()),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Add Funds",
                                        style: Utils.fonts(
                                          color: Utils.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          size: 11.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/appImages/portfolio/zero_wallet.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Invested",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 12.0,
                                        color: Utils.greyColor),
                                  ),
                                  Text(
                                    "67,68,340.8",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 13.0),
                                  ),
                                  Text("")
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Day's P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 12.0,
                                        color: Utils.greyColor),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "23,43,545.5",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 13.0,
                                        color: Utils.brightGreenColor),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "3.17%",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 11.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Unrealised P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 12.0,
                                        color: Utils.greyColor),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "43,56,657.4",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 13.0,
                                        color: Utils.brightGreenColor),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "2.71%",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 11.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Utils.primaryColor)),
                                child: Center(
                                    child: Text(
                                      'SUMMARY',
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 11.0,
                                          color: Utils.primaryColor),
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: Utils.greyColor.withOpacity(0.5)),
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Utils.greyColor.withOpacity(0.5)),
                                      right: BorderSide(
                                          width: 1,
                                          color: Utils.greyColor.withOpacity(0.5)),
                                    )),
                                child: Center(
                                    child: Text(
                                      'HOLDINGS',
                                      style: Utils.fonts(
                                          size: 11.0,
                                          color: Utils.greyColor.withOpacity(0.5)),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Realised P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  color: Utils.greyColor,
                                  size: 12.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "4,65,765.50",
                                style: Utils.fonts(
                                    size: 13.0, color: Utils.lightGreenColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Market Cap Allocation",
                        style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Container(
                            height: 130,
                            width: 130,
                            child: Center(
                                child: SvgPicture.asset(
                                    'assets/appImages/portfolio/pie_chart.svg'))),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 13.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                    'assets/appImages/green_dot.svg'),
                                SizedBox(
                                  height: 20,
                                ),
                                SvgPicture.asset(
                                    'assets/appImages/blue_dot.svg'),
                                SizedBox(
                                  height: 20,
                                ),
                                SvgPicture.asset(
                                    'assets/appImages/yellow_dot.svg'),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LARGECAP",
                                style: Utils.fonts(size: 12.0),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "MIDCAP",
                                style: Utils.fonts(size: 12.0),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "SMALLCAP",
                                style: Utils.fonts(size: 12.0),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(children: [
                        Text(
                          "43.49%",
                          style: Utils.fonts(size: 13.0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "23.65%",
                          style: Utils.fonts(size: 13.0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "56.32%",
                          style: Utils.fonts(size: 13.0),
                        )
                      ])
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffdd2006).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          // SvgPicture.asset(
                          //   "assets/appImages/market_cap_allocation2.svg",
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Higher concentration of portfolio in midcap\nand smallcap stocks",
                            style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 13.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      child: Image.asset(
                        "assets/appImages/start_sip.png",
                        fit: BoxFit.fill,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Top Holdings",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ICICIBANK",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 14.0),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "TATASTEEL",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 14.0),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "INFY",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 14.0),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "BALRAMCHIN",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 14.0),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "RELIANCE",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 14.0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 10,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Utils.greyColor.withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Utils.darkyellowColor,
                                    ),
                                    value: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "34%",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 10,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Utils.greyColor.withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Utils.darkyellowColor,
                                    ),
                                    value: 0.55,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "27%",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 10,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Utils.greyColor.withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Utils.darkyellowColor,
                                    ),
                                    value: 0.45,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "15%",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 10,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Utils.greyColor.withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Utils.darkyellowColor,
                                    ),
                                    value: 0.35,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "12%",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 10,
                                width: 160,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Utils.greyColor.withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Utils.darkyellowColor,
                                    ),
                                    value: 0.2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "11%",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View More",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Utils.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        // SizedBox(width: 5,),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                          color: Utils.primaryColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sectoral Holdings",
                          style: Utils.fonts(
                            fontWeight: FontWeight.w600,
                            size: 17.0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              _scrollTop();
                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg")),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "FMCG",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                  Utils.greyColor.withOpacity(0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Utils.primaryColor,
                                  ),
                                  value: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "27%",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "IT",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                  Utils.greyColor.withOpacity(0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Utils.primaryColor,
                                  ),
                                  value: 0.55,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "15%",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Pharma",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                  Utils.greyColor.withOpacity(0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Utils.primaryColor,
                                  ),
                                  value: 0.45,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "12%",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Energy",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                  Utils.greyColor.withOpacity(0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Utils.primaryColor,
                                  ),
                                  value: 0.35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "7%",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "real Estate",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                  Utils.greyColor.withOpacity(0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Utils.primaryColor,
                                  ),
                                  value: 0.2,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "7%",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View More",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Utils.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                          color: Utils.primaryColor,
                        )
                        // SizedBox(width: 5,),
                        // SvgPicture.asset(
                        //   "assets/appImages/upload.svg",
                        //   // width: 200,
                        //   // height: 200,
                        // ),
                        // Icon(Icons.arrow_drop_down,size: 40,color: Utils.primaryColor,)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Events",
                              style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 16.0,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              CupertinoIcons.forward,
                              size: 20,
                            )
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              _scrollTop();
                            },
                            child: SvgPicture.asset(
                                "assets/appImages/markets/up_arrow.svg")),
                        // Icon(
                        //   CupertinoIcons.arrow_up_left_circle,
                        //   color: Utils.primaryColor,
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(
                          right: 5,
                        ), //top: 8,bottom: 8
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          // height: 50,
                          decoration: BoxDecoration(
                            color: Utils.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dividend",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w600,
                                    size: 16.0,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 5, right: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "2 Scrip",
                                        style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                            color: Utils.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "View",
                                            style: TextStyle(
                                              // decoration: TextDecoration.underline,
                                                color: Utils.lightGreyColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                          // SizedBox(
                                          //   width: 5,
                                          // ),
                                          Icon(
                                            CupertinoIcons.forward,
                                            color: Utils.lightGreyColor,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor.withOpacity(0.5),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "News",
                            style: Utils.fonts(
                              fontWeight: FontWeight.w600,
                              size: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            size: 20,
                          )
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset(
                              "assets/appImages/markets/up_arrow.svg")),
                      // Icon(
                      //   CupertinoIcons.arrow_up_left_circle,
                      //   color: Utils.primaryColor,
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 475,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    "assets/appImages/portfolio/green_dot.svg",
                                    // width: 200,
                                    // height: 200,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adani Green Energy net profit rises 14% to \nRs 49 cr ",
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w600,
                                              size: 16.0),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Moneycontrol",
                                                style: TextStyle(
                                                    color: Utils.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "2 hours ago",
                                                style: TextStyle(
                                                    color: Utils.lightGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Divider(
                                thickness: 1,
                                color: Utils.greyColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(
                thickness: 3,
                color: Utils.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  topGrainers() {
    return TopGainersController.getTopGainersListItems.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (topGainersExpanded == false) {
                    topGainersExpanded = true;
                  } else if (topGainersExpanded == true) {
                    topGainersExpanded = false;
                  }
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Top Gainers",
                      style: Utils.fonts(
                          size: 17.0, color: Utils.blackColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                        "assets/appImages/arrow_right_circle.svg"),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          _scrollTop();
                        },
                        child: SvgPicture.asset(
                            "assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            topGainersTab = 1;
                            Dataconstants.topGainersController
                                .getTopGainers("day");
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: topGainersTab == 1
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: topGainersTab == 1
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: topGainersTab == 1
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: topGainersTab == 1
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "1 Day",
                                  style: Utils.fonts(
                                      size: 12.0,
                                      color: topGainersTab == 1
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            topGainersTab = 2;
                            Dataconstants.topGainersController
                                .getTopGainers("month");
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: topGainersTab == 2
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: topGainersTab == 2
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: topGainersTab == 2
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: topGainersTab == 2
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Monthly",
                                  style: Utils.fonts(
                                      size: 12.0,
                                      color: topGainersTab == 2
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            topGainersTab = 3;
                            Dataconstants.topGainersController
                                .getTopGainers("week");
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: topGainersTab == 3
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: topGainersTab == 3
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: topGainersTab == 3
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: topGainersTab == 3
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Weekly",
                                  style: Utils.fonts(
                                      size: 12.0,
                                      color: topGainersTab == 3
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            topGainersTab = 4;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: topGainersTab == 4
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: topGainersTab == 4
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: topGainersTab == 4
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: topGainersTab == 4
                                          ? Utils.primaryColor
                                          : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "My Holdings",
                                  style: Utils.fonts(
                                      size: 12.0,
                                      color: topGainersTab == 4
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
              SizedBox(
                height: 10,
              ),
              topGainersTab == 4
                  ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Data Avialable",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
                  : topGainersExpanded
                  ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: CustomTabBarScrollPhysics(),
                        itemCount: 4,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        TopGainersController
                                            .getTopGainersListItems[
                                        index]
                                            .symbol,
                                        style: Utils.fonts(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        TopGainersController
                                            .getTopGainersListItems[
                                        index]
                                            .perchg
                                            .toStringAsFixed(2),
                                        style: Utils.fonts(
                                          color:
                                          Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Text(
                                            TopGainersController
                                                .getTopGainersListItems[
                                            index]
                                                .prevClose
                                                .toString(),
                                            style: Utils.fonts(
                                              color: Utils
                                                  .mediumGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              )
                            ],
                          );
                        },
                      )),
                ],
              )
                  : Column(
                children: [
                  for (var i = 0;
                  i <
                      TopGainersController
                          .getTopGainersListItems.length;
                  i++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  TopGainersController
                                      .getTopGainersListItems[i]
                                      .symbol,
                                  style: Utils.fonts(
                                      size: 14.0,
                                      color: Utils.blackColor,
                                      fontWeight:
                                      FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        Icons
                                            .arrow_drop_up_rounded,
                                        color: Utils
                                            .lightGreenColor,
                                      ),
                                      Text(
                                        TopGainersController
                                            .getTopGainersListItems[
                                        i]
                                            .perchg
                                            .toStringAsFixed(2),
                                        style: Utils.fonts(
                                            size: 14.0,
                                            color: Utils
                                                .lightGreenColor,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      TopGainersController
                                          .getTopGainersListItems[
                                      i]
                                          .prevClose
                                          .toString(),
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color:
                                          Utils.blackColor,
                                          fontWeight:
                                          FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
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
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  topLosers() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (topLosersExpanded == false) {
                      topLosersExpanded = true;
                    } else if (topLosersExpanded == true) {
                      topLosersExpanded = false;
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Top Losers",
                        style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                          "assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            _scrollTop();
                          },
                          child: SvgPicture.asset(
                              "assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              topLosersTab = 2;
                              Dataconstants.topLosersController
                                  .getTopLosers("day");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 2
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 3;
                              Dataconstants.topLosersController
                                  .getTopLosers("week");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 3
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 1;
                              Dataconstants.topLosersController
                                  .getTopLosers("month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 1
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 4
                                            ? Utils.primaryColor
                                            : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(
                                        size: 12.0,
                                        color: topLosersTab == 4
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
                SizedBox(
                  height: 10,
                ),
                topLosersTab == 4
                    ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Data Available",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ))
                    : TopLosersController.getTopLosersListItems.isEmpty
                    ? Center(
                  child: Row(
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
                    : topLosersExpanded
                    ? Column(
                  children: [
                    for (var i = 0;
                    i <
                        TopLosersController
                            .getTopLosersListItems.length;
                    i++)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    TopLosersController
                                        .getTopLosersListItems[i]
                                        .symbol,
                                    style: Utils.fonts(
                                        size: 14.0,
                                        color: Utils.blackColor,
                                        fontWeight:
                                        FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Icon(
                                          Icons
                                              .arrow_drop_up_rounded,
                                          color: Utils
                                              .lightGreenColor,
                                        ),
                                        Text(
                                          "${TopLosersController.getTopLosersListItems[i].perchg.toStringAsFixed(2)}%",
                                          style: Utils.fonts(
                                              size: 14.0,
                                              color: Utils
                                                  .lightGreenColor,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ]),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        TopLosersController
                                            .getTopLosersListItems[
                                        i]
                                            .prevClose
                                            .toString(),
                                        style: Utils.fonts(
                                            size: 14.0,
                                            color:
                                            Utils.blackColor,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
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
                    : Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: CustomTabBarScrollPhysics(),
                          itemCount: 4,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          TopLosersController
                                              .getTopLosersListItems[
                                          index]
                                              .symbol,
                                          style: Utils.fonts(
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          TopLosersController
                                              .getTopLosersListItems[
                                          index]
                                              .perchg
                                              .toStringAsFixed(2),
                                          style: Utils.fonts(
                                            color:
                                            Utils.greyColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Text(
                                              TopLosersController
                                                  .getTopLosersListItems[
                                              index]
                                                  .prevClose
                                                  .toString(),
                                              style: Utils.fonts(
                                                color: Utils
                                                    .mediumGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            );
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }
}
