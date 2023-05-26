import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/controllers/FIICashController.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../controllers/FiiDiiController.dart';
import '../../controllers/FiiFnoController.dart';
import '../../util/Utils.dart';

class FiiDii extends StatefulWidget {
  const FiiDii({Key key}) : super(key: key);

  @override
  State<FiiDii> createState() => _FiiDiiState();
}

class _FiiDiiState extends State<FiiDii> {
  int index = 0;

  List preferredSector = [
    'All',
    'Nifty 50',
    'Nifty Midcap 150',
    'Nifty Smallcap 250',
    'Nifty Smallcap 100',
    'Nifty Large Midcap',
    'Nifty Mid Smallcap',
    'Nifty SME Emerge',
    'Nifty 100 Equal',
    'Nifty Alpha 50',
  ];
  List<String> items = <String>['One', 'Two', 'Three', 'Four'];
  var tabValue;
  var fiidii = 1;
  var _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Dataconstants.fiiCashController.getFiicash();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        fiidii = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: fiidii == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        bottom: fiidii == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        right: fiidii == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                        left: fiidii == 1
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("FII Cash",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: fiidii == 1
                                    ? Utils.primaryColor
                                    : Utils.greyColor)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        fiidii = 2;
                        Dataconstants.fiiDiiController.getFiiDii();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: fiidii == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        bottom: fiidii == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        right: fiidii == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                        left: fiidii == 2
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("DII Cash",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: fiidii == 2
                                    ? Utils.primaryColor
                                    : Utils.greyColor)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        fiidii = 3;
                        Dataconstants.fiiFnoController.getFiiFno();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: fiidii == 3
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        bottom: fiidii == 3
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        right: fiidii == 3
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide(color: Utils.greyColor),
                        left: fiidii == 3
                            ? BorderSide(color: Utils.primaryColor)
                            : BorderSide.none,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("FII F&O",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: fiidii == 3
                                    ? Utils.primaryColor
                                    : Utils.greyColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fiidii == 3
                ? InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Select Index",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w700,
                                            size: 17.0,
                                            color: Utils.blackColor)),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                tabValue = 1;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: tabValue == 1
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide(
                                                        color: Utils.greyColor),
                                                bottom: tabValue == 1
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide(
                                                        color: Utils.greyColor),
                                                right: tabValue == 1
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide.none,
                                                left: tabValue == 1
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide(
                                                        color: Utils.greyColor),
                                              )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text("NSE",
                                                    style: Utils.fonts(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        size: 14.0,
                                                        color: tabValue == 1
                                                            ? Utils.primaryColor
                                                            : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                tabValue = 2;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                top: tabValue == 2
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide(
                                                        color: Utils.greyColor),
                                                bottom: tabValue == 2
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide(
                                                        color: Utils.greyColor),
                                                right: tabValue == 2
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide.none,
                                                left: tabValue == 2
                                                    ? BorderSide(
                                                        color:
                                                            Utils.primaryColor)
                                                    : BorderSide.none,
                                              )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text("BSE",
                                                    style: Utils.fonts(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        size: 14.0,
                                                        color: tabValue == 2
                                                            ? Utils.primaryColor
                                                            : Utils.greyColor)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: List.generate(
                                      preferredSector.length, (index) {
                                    return preferredSectorTitle(
                                        preferredSector[index], index);
                                  }),
                                ),
                              )
                            ]),
                          );
                        },
                        backgroundColor: Utils.whiteColor,
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.070,
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Utils.greyColor.withOpacity(0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Index Fut',
                            style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.blackColor),
                          ),
                          RotatedBox(
                              quarterTurns: 2,
                              child: SvgPicture.asset(
                                'assets/appImages/markets/inverted_rectangle.svg',
                                color: Utils.blackColor,
                              )),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Period",
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 14.0,
                    color: Utils.greyColor)),
            Text("New-Buy/Sell(Rs. Cr)",
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 14.0,
                    color: Utils.greyColor)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 2,
        ),
        fiidii == 1
            ? Column(
                children: [
                  Container(
                    child: Container(
                      color: Utils.lightGreenColor.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Last 5 Days",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0,
                                        color: Utils.greyColor)),
                                Text("1,323.23",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0,
                                        color: Utils.primaryColor)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Last 30 days",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0,
                                        color: Utils.greyColor)),
                                Text("945.71",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0,
                                        color: Utils.primaryColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  for (var i = 0;
                      i < FIICashController.getFiiCashListItems.length;
                      i++)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.32,
                              child: Text(
                                  FIICashController
                                      .getFiiCashListItems[i].fiiDate
                                      .toString()
                                      .split(" ")[0],
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Colors.black)),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Text(
                                  FIICashController
                                      .getFiiCashListItems[i].netValue
                                      .toString(),
                                  textAlign: TextAlign.end,
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                ],
              )
            : fiidii == 2
                ? Column(
                    children: [
                      Container(
                        color: Utils.lightGreenColor.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Last 5 Days",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                  Text("1,323.23",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.primaryColor)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Last 30 days",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                  Text("945.71",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.primaryColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var i = 0; i < FiiDiiController.getFiiDiiListItems.length; i++)
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(FiiDiiController.getFiiDiiListItems[i].fiiDate.toString().split(" ")[0],
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                                Text(FiiDiiController.getFiiDiiListItems[i].netValue.toStringAsFixed(2),
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        color: Utils.lightGreenColor.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Last 5 Days",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                  Text("1,323.23",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.primaryColor)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Last 30 days",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.greyColor)),
                                  Text("945.71",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                          color: Utils.primaryColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var i = 0; i < FiiFnoController.getFiiFnoListItems.length; i++)
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(FiiFnoController.getFiiFnoListItems[i].fiifnoDate.toString().split(" ")[0],
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),

                                Text(FiiFnoController.getFiiFnoListItems[i].indexFuturesBuyAmount.toStringAsFixed(2),
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )
                    ],
                  )
      ],
    );
  }

  Widget preferredSectorTitle(String title, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                index = i;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: Utils.fonts(
                        size: 14.0,
                        fontWeight:
                            index == i ? FontWeight.w600 : FontWeight.w400,
                        color: index == i
                            ? Utils.primaryColor
                            : Utils.blackColor)),
                index == i
                    ? SvgPicture.asset(
                        'assets/appImages/markets/checkbox_circle_blue.svg')
                    : Container(
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            )),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
