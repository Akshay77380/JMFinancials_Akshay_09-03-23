import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../style/theme.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';

class EquitySipOrderStatusDetails extends StatefulWidget {
  // orderDatum order;
  //
  // EquitySipOrderStatusDetails(this.order);

  @override
  State<EquitySipOrderStatusDetails> createState() =>
      _EquitySipOrderStatusDetailsState();
}

class _EquitySipOrderStatusDetailsState
    extends State<EquitySipOrderStatusDetails> {
  bool status = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // if (widget.order.status == 'rejected')
    //   status = false;
    // else
    //   status = true;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: status
            ? MediaQuery.of(context).size.height - 150
            : MediaQuery.of(context).size.height - 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Status",
                            style: Utils.fonts(size: 20.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  "CLOSE",
                                  style: Utils.fonts(
                                      size: 16.0, color: Utils.blackColor),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset('assets/appImages/sip_bell.png'),
                      // SvgPicture.asset(status ? "assets/appImages/bell.svg" : "assets/appImages/error.svg"),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "SIP Request Submitted Successfully",
                        style: Utils.fonts(size: 18.0),
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
                                "QTY",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '100',
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "AVG PRICE",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '243.25',
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
                                "STATUS",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                status ? 'SUCCESS' : 'REJECT',
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w700,
                                    size: 15.0,
                                    color: status
                                        ? ThemeConstants.buyColor
                                        : ThemeConstants.sellColor),
                              )
                            ],
                          )
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
                              height: 10,
                            ),
                            Text("SIP STOCK",
                                style: Utils.fonts(
                                    size: 15.0, color: Utils.blackColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text('TATAPOWER',
                                        style: Utils.fonts(
                                            size: 26.0,
                                            color: Utils.blackColor,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Observer(
                                      builder: (_) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text('243.85',
                                                    // widget.order.model.close
                                                    //     .toStringAsFixed(
                                                    //     widget.order.model
                                                    //         .precision),
                                                    style: Utils.fonts(
                                                        size: 18.0,
                                                        color: Utils.blackColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '-2.80 (-2.43%)',
                                                    // widget.order.model
                                                    //     .priceChangeText +
                                                    //     " " +
                                                    //     widget.order.model
                                                    //         .percentChangeText,
                                                    style: Utils.fonts(
                                                        color:
                                                            // widget
                                                            //     .order
                                                            //     .model
                                                            //     .percentChange >
                                                            //     0
                                                            //     ? ThemeConstants
                                                            //     .buyColor
                                                            //     : widget
                                                            //     .order
                                                            //     .model
                                                            //     .percentChange <
                                                            //     0
                                                            //     ?
                                                            ThemeConstants
                                                                .sellColor
                                                        // : theme
                                                        // .errorColor
                                                        ,
                                                        size: 13.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      // widget.order.model
                                                      //     .percentChange >
                                                      //     0
                                                      //     ? Icons
                                                      //     .arrow_drop_up_rounded
                                                      //     :
                                                      Icons
                                                          .arrow_drop_down_rounded,
                                                      color:
                                                          // widget
                                                          //     .order
                                                          //     .model
                                                          //     .percentChange >
                                                          //     0
                                                          //     ? ThemeConstants
                                                          //     .buyColor
                                                          //     :
                                                          ThemeConstants
                                                              .sellColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // if(!status)
                      //   Column(
                      //     children: [
                      //       Container(
                      //         width: MediaQuery.of(context).size.width,
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //               color: Utils.greyColor,
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(10.0),
                      //             )),
                      //         child: Column(
                      //           children: [
                      //             SizedBox(
                      //               height: 10,
                      //             ),
                      //             Text("REJECTION REASON",
                      //                 style: Utils.fonts(
                      //                     size: 15.0, color: Utils.blackColor)),
                      //             SizedBox(
                      //               height: 5,
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 15.0, vertical: 10.0),
                      //               child: Text("${widget.order.text}",
                      //                   style: Utils.fonts(
                      //                       size: 14.0, color: Colors.red),
                      //                   textAlign: TextAlign.center),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Utils.primaryColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Utils.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  // InAppSelection.mainScreenIndex = 2;
                                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  //     builder: (_) => MainScreen(
                                  //       toChangeTab: true,
                                  //     )));
                                },
                                child: Text("SIP BOOK",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              ),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  InAppSelection.mainScreenIndex = 0;
                                  Navigator.of(context)
                                      .pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (_) => MainScreen(
                                                toChangeTab: false,
                                              )), (route) => false);
                                },
                                child: Text("WATCHLIST",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 20.0),
                        child: Text(status ? "START ANOTHER SIP" : "RETRY",
                            style: Utils.fonts(
                                size: 16.0, color: Utils.whiteColor)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
