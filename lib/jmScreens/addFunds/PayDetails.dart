import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../util/Utils.dart';

class PayDetails extends StatefulWidget {
  var status;

  PayDetails(this.status);

  @override
  State<PayDetails> createState() => _PayDetailsState();
}

class _PayDetailsState extends State<PayDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Spacer(),
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
                        "Pay In Details",
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
                            "BANK",
                            style: Utils.fonts(
                                color: Utils.greyColor,
                                size: 15.0,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "HDFC BANK",
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
                            widget.status.toString().toUpperCase(),
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 15.0,
                                color: widget.status.toString().toUpperCase() ==
                                        "PENDING"
                                    ? Utils.primaryColor
                                    : Utils.darkGreenColor),
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
                          height: 10,
                        ),
                        Text("Amount",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w700)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("₹62,680",
                                style: Utils.fonts(
                                    size: 35.0,
                                    color: Utils.darkGreenColor,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Client ID",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text("10116241",
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
                      Text("Source ID",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text("10115643",
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
                      Text("Instruction No.",
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
                      Text("Instruction Date & Time",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text("12 Apr 2022 12:45",
                          style: Utils.fonts(
                              size: 14.0,
                              color: Utils.blackColor,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.status.toString().toUpperCase() == "SUCCESS")
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bank Ref. No.",
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
                  if (widget.status.toString().toUpperCase() == "PENDING")
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Remark",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Remark",
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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.status.toString().toUpperCase() == "PENDING")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0))),
                    color: Utils.primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Utils.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text("CANCEL",
                              style: Utils.fonts(
                                  size: 16.0, color: Utils.greyColor)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    color: Utils.primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Utils.primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text("MODIFY",
                              style: Utils.fonts(
                                  size: 16.0, color: Utils.whiteColor)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
