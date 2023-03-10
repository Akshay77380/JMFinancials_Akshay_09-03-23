import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class EquitySipOrderDetails extends StatefulWidget {
  final bool status;

  // orderDatum order;

  EquitySipOrderDetails(this.status);

  @override
  State<EquitySipOrderDetails> createState() => _EquitySipOrderDetailsState();
}

class _EquitySipOrderDetailsState extends State<EquitySipOrderDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 220,
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
                            "SIP Order Details",
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
                                  color: Colors.green.withOpacity(0.3),
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
                                '2000',
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
                                "Avg Price",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '80.50',
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
                                "widget.status",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.status ? 'ACTIVE' : 'PAUSE',
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w700,
                                    size: 15.0,
                                    color: widget.status
                                        ? Utils.primaryColor
                                        : Utils.greyColor),
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
                                            size: 22.0,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SIP Reference ID',
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('20200527000207',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Frequency",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('Monthly',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
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
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('60',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Start Date",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('22 Apr 2022',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.status ? "Next Date" : "Pause Date",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('15 May 2022',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.status)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("End Date",
                                style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Utils.greyColor)),
                            Text('15 Apr 2027',
                                style: Utils.fonts(
                                    size: 14.0, color: Utils.blackColor))
                          ],
                        ),
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
                              if (widget.status)
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (builder) {
                                        return DraggableScrollableSheet(
                                          initialChildSize:
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0005,
                                          minChildSize: 0.30,
                                          maxChildSize: 0.6,
                                          expand: false,
                                          builder: (BuildContext context,
                                              ScrollController
                                                  scrollController) {
                                            return confirmDialog(false);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("PAUSE",
                                      style: Utils.fonts(
                                          size: 16.0, color: Utils.greyColor)),
                                )
                              else
                                Text("MODIFY",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (builder) {
                                      return DraggableScrollableSheet(
                                        initialChildSize:
                                            MediaQuery.of(context).size.height *
                                                0.0005,
                                        minChildSize: 0.30,
                                        maxChildSize: 0.6,
                                        expand: false,
                                        builder: (BuildContext context,
                                            ScrollController scrollController) {
                                          return confirmDialog(true);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text("CANCEL",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.status)
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 150.0, vertical: 20.0),
                          child: Text("MODIFY",
                              style: Utils.fonts(
                                  size: 16.0, color: Utils.whiteColor)),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 140.0, vertical: 20.0),
                          child: Text("RESTART SIP",
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

  Widget confirmDialog(bool isCancel) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SvgPicture.asset(isCancel
            ? 'assets/appImages/cancelSip.svg'
            : 'assets/appImages/pauseSip.svg'),
        const SizedBox(
          height: 15,
        ),
        Text('${isCancel ? 'Cancel' : 'Pause'} SIP?',
            style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600)),
        const SizedBox(
          height: 15,
        ),
        Text('Are you sure you want to ${isCancel ? 'cancel' : 'pause'} SIP?',
            style: Utils.fonts(
                size: 14.0,
                fontWeight: FontWeight.w400,
                color: Utils.greyColor)),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(
            thickness: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Utils.greyColor, width: 1),
                  ),
                  child: Text('Yes',
                      style: Utils.fonts(
                          size: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Utils.greyColor)),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Utils.primaryColor,
                  ),
                  child: Text('No',
                      style: Utils.fonts(
                          size: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Utils.whiteColor)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
