import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/controllers/WorldIndicesController.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/smallChart.dart';

class MarketGlobal extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<MarketGlobal> createState() => _MarketGlobalState();
}

class _MarketGlobalState extends State<MarketGlobal> {
  var global;

  @override
  void initState() {

    Dataconstants.worldIndicesController.getWorldIndices();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                setState(() {
                  global = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Utils.primaryColor)
                    // border: Border(
                    //   top: global == 1
                    //       ? BorderSide(color: Utils.primaryColor)
                    //       : BorderSide(color: Utils.greyColor),
                    //   bottom: global == 1
                    //       ? BorderSide(color: Utils.primaryColor)
                    //       : BorderSide(color: Utils.greyColor),
                    //   right: global == 1
                    //       ? BorderSide(color: Utils.primaryColor)
                    //       : BorderSide.none,
                    //   left: global == 1
                    //       ? BorderSide(color: Utils.primaryColor)
                    //       : BorderSide(color: Utils.greyColor),
                    // )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("All Global Indices",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color:
                          // global == 1
                          //     ?
                          Utils.primaryColor
                              // : Utils.greyColor
                      )),
                ),
              ),
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             global = 1;
          //           });
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //               border: Border(
          //             top: global == 1
          //                 ? BorderSide(color: Utils.primaryColor)
          //                 : BorderSide(color: Utils.greyColor),
          //             bottom: global == 1
          //                 ? BorderSide(color: Utils.primaryColor)
          //                 : BorderSide(color: Utils.greyColor),
          //             right: global == 1
          //                 ? BorderSide(color: Utils.primaryColor)
          //                 : BorderSide.none,
          //             left: global == 1
          //                 ? BorderSide(color: Utils.primaryColor)
          //                 : BorderSide(color: Utils.greyColor),
          //           )),
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text("All Global Indices",
          //                 style: Utils.fonts(
          //                     fontWeight: FontWeight.w500,
          //                     size: 14.0,
          //                     color: global == 1
          //                         ? Utils.primaryColor
          //                         : Utils.greyColor)),
          //           ),
          //         ),
          //       ),
          //       // InkWell(
          //       //   onTap: () {
          //       //     setState(() {
          //       //       global = 2;
          //       //     });
          //       //   },
          //       //   child: Container(
          //       //     decoration: BoxDecoration(
          //       //         border: Border(
          //       //       top: global == 2
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       bottom: global == 2
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       right: global == 2
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide.none,
          //       //       left: global == 2
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide.none,
          //       //     )),
          //       //     child: Padding(
          //       //       padding: const EdgeInsets.all(8.0),
          //       //       child: Text("Asia",
          //       //           style: Utils.fonts(
          //       //               fontWeight: FontWeight.w500,
          //       //               size: 14.0,
          //       //               color: global == 2
          //       //                   ? Utils.primaryColor
          //       //                   : Utils.greyColor)),
          //       //     ),
          //       //   ),
          //       // ),
          //       // InkWell(
          //       //   onTap: () {
          //       //     setState(() {
          //       //       global = 3;
          //       //     });
          //       //   },
          //       //   child: Container(
          //       //     decoration: BoxDecoration(
          //       //         border: Border(
          //       //       top: global == 3
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       bottom: global == 3
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       right: global == 3
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide.none,
          //       //       left: global == 3
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide.none,
          //       //     )),
          //       //     child: Padding(
          //       //       padding: const EdgeInsets.all(8.0),
          //       //       child: Text("Europe",
          //       //           style: Utils.fonts(
          //       //               fontWeight: FontWeight.w500,
          //       //               size: 14.0,
          //       //               color: global == 3
          //       //                   ? Utils.primaryColor
          //       //                   : Utils.greyColor)),
          //       //     ),
          //       //   ),
          //       // ),
          //       // InkWell(
          //       //   onTap: () {
          //       //     setState(() {
          //       //       global = 4;
          //       //     });
          //       //   },
          //       //   child: Container(
          //       //     decoration: BoxDecoration(
          //       //         border: Border(
          //       //       top: global == 4
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       bottom: global == 4
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       right: global == 4
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide(color: Utils.greyColor),
          //       //       left: global == 4
          //       //           ? BorderSide(color: Utils.primaryColor)
          //       //           : BorderSide.none,
          //       //     )),
          //       //     child: Padding(
          //       //       padding: const EdgeInsets.all(8.0),
          //       //       child: Text("North America",
          //       //           style: Utils.fonts(
          //       //               fontWeight: FontWeight.w500,
          //       //               size: 14.0,
          //       //               color: global == 4
          //       //                   ? Utils.primaryColor
          //       //                   : Utils.greyColor)),
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              for (var i = 0;
                  i < WorldIndicesController.getWorldIndicesListItems.length;
                  i++)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              WorldIndicesController
                                  .getWorldIndicesListItems[i].indexname,
                              style: Utils.fonts(
                                size: 14.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          WorldIndicesController
                              .getWorldIndicesListItems[i].prevClose
                              .toStringAsFixed(2),
                          style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          WorldIndicesController.getWorldIndicesListItems[i].date
                              .toString()
                              .split(" ")[0],
                          style: Utils.fonts(
                            size: 12.0,
                            color: Utils.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              WorldIndicesController
                                  .getWorldIndicesListItems[i].chg
                                  .toStringAsFixed(2),
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '(${WorldIndicesController.getWorldIndicesListItems[i].pChg}%)',
                              style: Utils.fonts(
                                size: 12.0,
                                color: WorldIndicesController
                                            .getWorldIndicesListItems[i].pChg >
                                        0
                                    ? Utils.lightGreenColor
                                    : Utils.lightRedColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: WorldIndicesController
                                          .getWorldIndicesListItems[i].pChg >
                                      0
                                  ? SvgPicture.asset(
                                      "assets/appImages/markets/inverted_rectangle.svg")
                                  : RotatedBox(
                                      quarterTurns: 2,
                                      child: SvgPicture.asset(
                                        "assets/appImages/markets/inverted_rectangle.svg",
                                        color: Utils.lightRedColor,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }
}
