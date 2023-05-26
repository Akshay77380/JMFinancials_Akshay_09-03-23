import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/number_field.dart';
import '../CommonWidgets/switch.dart';

class buyOrder extends StatefulWidget {
  @override
  State<buyOrder> createState() => _buyOrderState();
}

class _buyOrderState extends State<buyOrder> {
  TextEditingController _textEditingController;
  final _orderTypeController = ValueNotifier<bool>(false);

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _orderTypeController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Utils.mediumGreenColor.withOpacity(0.8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                child: Text(
                  "BUY",
                  style: Utils.fonts(
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("IT Basket",
                style: Utils.fonts(
                    size: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ],
        ),
        actions: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    context: context,
                    builder: (context) {
                      return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.3,
                          initialChildSize: 0.5,
                          maxChildSize: 0.75,
                          builder: (context, scrollController) {
                            return DotExpand(scrollController);
                          });
                    });
              },
              child: Icon(Icons.more_vert))
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderTypeController.value == true
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Utils.primaryColor.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Minimum first investment",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w400, size: 12.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "51,100.37",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w700, size: 14.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
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
                                  "Min. First Inv.",
                                  style: Utils.fonts(
                                      size: 12.0, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "51,301.70",
                                  style: Utils.fonts(
                                      size: 14.0, fontWeight: FontWeight.w700),
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
                                  "Next SIP Installments",
                                  style: Utils.fonts(
                                      size: 12.0, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "8,000",
                                  style: Utils.fonts(
                                      size: 14.0, fontWeight: FontWeight.w700),
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
                  ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                ),
                Text("MONTHLY SIP",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w700,
                        color: Utils.greyColor.withOpacity(0.7),
                        size: 12.0)),
                SizedBox(
                  width: 10,
                ),
                ToggleSwitch(
                    height: 15.0,
                    width: 30.0,
                    switchController: _orderTypeController,
                    isBorder: true,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white,
                    thumbColor: Colors.black),
                SizedBox(
                  width: 10,
                ),
                Text("LUMPSUM",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w700,
                        color: Utils.greyColor.withOpacity(0.7),
                        size: 12.0)),
              ],
            ),
            _orderTypeController.value == false
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        NumberField(
                          numberController: _textEditingController,
                          maxLength: 22,
                          isBuy: true,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Utils.containerColor,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Text("+1000",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: Utils.greyColor
                                              .withOpacity(0.8))),
                                )),
                            SizedBox(
                              width: 16.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Utils.containerColor,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Text("+2000",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: Utils.greyColor
                                              .withOpacity(0.8))),
                                )),
                            SizedBox(
                              width: 16.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Utils.containerColor,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Text("+5000",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: Utils.greyColor
                                              .withOpacity(0.8))),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SIP DATE",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w700,
                                      size: 12.0,
                                      color: Utils.greyColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:
                                      Utils.lightGreenColor.withOpacity(0.2)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text("20",
                                                  style: Utils.fonts(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Utils.blackColor)),
                                            ),
                                            Text("of every month",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w700,
                                                    size: 12.0,
                                                    color: Utils.greyColor
                                                        .withOpacity(0.5)))
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      RotatedBox(
                                        quarterTurns: 2,
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/appImages/basket/inverted_rectangle.svg",
                                            color: Utils.blackColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("AVAILABLE MARGIN",
                                          style: Utils.fonts(
                                              size: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey)),
                                      Text("REQUIRED MARGIN",
                                          style: Utils.fonts(
                                              size: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey)),
                                    ]),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('\u{20B9}${" 2,22,222.22"}',
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w700,
                                              color: Utils.blackColor)),
                                      Text('\u{20B9}${" 7,22,12.212"}',
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black)),
                                    ])
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        NumberField(
                          numberController: _textEditingController,
                          maxLength: 22,
                          isBuy: true,
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("AVAILABLE MARGIN",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                                  Text("REQUIRED MARGIN",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\u{20B9}${" 2,22,222.22"}',
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          color: Utils.blackColor)),
                                  Text('\u{20B9}${" 7,22,12.212"}',
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                ])
                          ],
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        color: Utils.whiteColor,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Utils.primaryColor,
            ),
            child: Center(
                child: Text("Confirm Account",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Widget DotExpand(ScrollController scrollController) {
    return Stack(children: <Widget>[
      SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  child:
                      SvgPicture.asset("assets/appImages/basket/deleteImg.svg"),
                )
              ]),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
            child: Center(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey[350],
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(color: Utils.blackColor, fontSize: 20),
                    )),
                  ),
                  // Spacer(flex: 1),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Utils.brightRedColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 30),
                        SvgPicture.asset(
                          "assets/appImages/basket/delete.svg",
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
